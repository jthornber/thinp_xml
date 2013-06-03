require 'thinp_xml/metadata'

#----------------------------------------------------------------

module ThinpXML

  class Builder
    attr_accessor :uuid, :nr_thins, :nr_mappings

    def initialize
      @uuid = ''
      @nr_thins = 0
      @nr_mappings = 0
    end

    def generate
      superblock = Superblock.new(@uuid, 0, 1, 128, 100)

      devices = Array.new
      offset = 0
      0.upto(@nr_thins - 1) do |dev|
        mappings = Array.new

        if @nr_mappings > 0
          mappings << Mapping.new(0, offset, @nr_mappings, 1)
          offset += @nr_mappings
        end

        devices << Device.new(dev, @nr_mappings, 0, 0, 0, mappings)
      end

      Metadata.new(superblock, devices)
    end
  end
end

#----------------------------------------------------------------
