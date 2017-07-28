require 'thinp_xml/thinp/metadata'
require 'thinp_xml/emitter'

#----------------------------------------------------------------

module ThinpXML
  module EmitterDetail
    class ThinpEmitter
      def initialize(out)
        @e = ThinpXML::Base::Emitter.new(out)
      end

      def emit_superblock(sb, &block)
        @e.emit_tag(sb, 'superblock', :uuid, :time, :transaction, :flags, :version, :data_block_size, :nr_data_blocks, &block)
      end

      def emit_device(dev, &block)
        @e.emit_tag(dev, 'device', :dev_id, :mapped_blocks, :transaction, :creation_time, :snap_time, &block)
      end

      def emit_mapping(m)
        if m.length == 1
          @e.emit_line("<single_mapping origin_block=\"#{m.origin_begin}\" data_block=\"#{m.data_begin}\" time=\"#{m.time}\"/>")
        else
          @e.emit_tag(m, 'range_mapping', :origin_begin, :data_begin, :length, :time)
        end
      end
    end
  end

  #--------------------------------

  def write_xml(metadata, io)
    e = EmitterDetail::ThinpEmitter.new(io)

    e.emit_superblock(metadata.superblock) do
      metadata.devices.each do |dev|
        e.emit_device(dev) do
          dev.mappings.each do |m|
            e.emit_mapping(m)
          end
        end
      end
    end
  end
end

#----------------------------------------------------------------
