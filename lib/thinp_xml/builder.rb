require 'thinp_xml/metadata'

#----------------------------------------------------------------

module ThinpXML

  class Builder
    attr_accessor :nr_thins, :nr_mappings

    def initialize
      @nr_thins = 0
      @nr_mappings = 0
    end

    def generate
      superblock = Superblock.new("uuid here", 0, 1, 128, 100)

      devices = Array.new
      offset = 0
      0.upto(@nr_thins - 1) do |dev|
        mappings = Array.new
        1.upto(@nr_mappings) do |n|
          mappings << Mapping.new(n, offset + n, 1, 1)
          offset += @nr_mappings
        end

        devices << Device.new(dev, @nr_mappings, 0, 0, 0, mappings)
      end

      Metadata.new(superblock, devices)
    end
  end
end

#----------------------------------------------------------------
