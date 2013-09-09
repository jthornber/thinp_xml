require 'thinp_xml/cache/metadata'

#----------------------------------------------------------------

module CacheXML
  class Builder
    attr_accessor :uuid, :block_size, :nr_cache_blocks, :policy_name
    attr_reader :mapping_policy, :nr_mappings, :dirty_percentage

    def initialize
      @uuid = ''
      @block_size = 128
      @nr_cache_blocks = 0
      @policy_name = 'mq'
      @mapping_policy = :random
      @nr_mappings = 0
      @dirty_percentage = 0
    end

    def generate
      superblock = Superblock.new(@uuid, @block_size.to_i, @nr_cache_blocks.to_i, @policy_name)
      mappings = []

      case @mapping_policy
      when :linear
        cb = 0
        ob = safe_rand(@nr_cache_blocks - @nr_mappings)

        @nr_mappings.times do
          dirty = safe_rand(100) < @dirty_percentage
          mappings << Mapping.new(cb, ob, dirty)
          cb += 1
          ob += 1
        end

      when :random
        origin_blocks = []

        ob = 0
        @nr_mappings.times do
          origin_blocks << ob
          ob += 1
        end

        0.upto(@nr_mappings - 1) do |n|
          tmp = origin_blocks[n]

          index = n + rand(@nr_mappings - n)
          origin_blocks[n] = origin_blocks[index]
          origin_blocks[index] = tmp

          dirty = safe_rand(100) < @dirty_percentage
          mappings << Mapping.new(n, origin_blocks[n], dirty)
        end

      else
        raise "unknown mapping policy"
      end

      hints = []

      Metadata.new(superblock, mappings, hints)
    end

    def mapping_policy=(sym)
      raise "mapping policy must be :random or :linear" unless valid_policy(sym)
      @mapping_policy = sym
    end

    def nr_mappings=(n)
      n = n.to_i
      #raise "nr_mappings must not exceed nr_cache_blocks" if n > @nr_cache_blocks
      @nr_mappings = n
    end

    def dirty_percentage=(n)
      raise "invalid percentage (#{n})" if n < 0 || n > 100
      @dirty_percentage = n
    end

    private
    def valid_policy(sym)
      [:random, :linear].member?(sym)
    end

    def safe_rand(n)
      n == 0 ? 0 : rand(n)
    end
  end
end

#----------------------------------------------------------------
