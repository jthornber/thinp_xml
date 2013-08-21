require 'thinp_xml/thinp/metadata'
require 'thinp_xml/listener'

require 'rexml/document'
require 'rexml/streamlistener'

#----------------------------------------------------------------

module ThinpXML
  module ParseDetail
    include REXML

    class Listener
      include Base::ListenerUtils
      include REXML::StreamListener

      attr_reader :metadata

      def initialize
        @metadata = Metadata.new(nil, Array.new)
      end


      def tag_start(tag, args)
        attr = to_hash(args)

        case tag
        when 'superblock'
          @metadata.superblock = Superblock.new(*get_fields(attr, SUPERBLOCK_FIELDS))

        when 'device'
          attr[:mappings] = Array.new
          @current_device = Device.new(*get_fields(attr, DEVICE_FIELDS))
          @metadata.devices << @current_device

        when 'single_mapping'
          @current_device.mappings << Mapping.new(attr[:origin_block].to_i, attr[:data_block].to_i, 1, attr[:time])

        when 'range_mapping'
          @current_device.mappings << Mapping.new(*get_fields(attr, MAPPING_FIELDS))

        else
          raise "unhandled tag '#{tag} #{attr.map {|x| x.inspect}.join(', ')}'"
        end
      end

      def tag_end(tag)
      end
    end
  end

  def read_xml(io)
    l = ParseDetail::Listener.new
    REXML::Document.parse_stream(io, l)
    l.metadata
  end
end

#----------------------------------------------------------------
