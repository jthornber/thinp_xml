require 'thinp_xml/era/metadata'

#----------------------------------------------------------------

module EraXML
  class Builder
    attr_accessor :uuid, :block_size, :nr_blocks, :current_era, :nr_writesets

    def initialize
      @uuid = ''
      @block_size = 128
      @nr_blocks = 0
      @current_era = 0
      @nr_writesets = 0
    end

    def generate
      s = Superblock.new(@uuid, @block_size, @nr_blocks, @current_era)

      if @nr_writesets > @current_era
        raise "can't have more writesets than eras"
      end

      era_array_limit = @current_era - @nr_writesets

      writesets = (0..@nr_writesets - 1).map do |i|
        bits = (0..@nr_blocks - 1).map do |block|
          WritesetBit.new(block, rand(2) == 0 ? false : true)
        end

        Writeset.new(era_array_limit + i, @nr_blocks, bits)
      end

      era_array = (0..@nr_blocks - 1).map do |block|
        if @current_era > 0
          rand(era_array_limit)
        else
          0
        end
      end

      Metadata.new(s, writesets, era_array)
    end
  end
end

#----------------------------------------------------------------
