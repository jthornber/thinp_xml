require 'thinp_xml/listener'
require 'thinp_xml/cache/metadata'

require 'rexml/document'
require 'rexml/streamlistener'

#----------------------------------------------------------------

module ThinpXML
  module CacheParseDetail
    include REXML

    class Listener
      include Base::ListenerUtils
      include Base::StreamListener

      attr_reader :metadata

      def initialize
        @metadata = Metdadata.new(nil, [], [])
      end

      def tag_start(tag, args)
        attr = to_hash(args)

        case tag
        when 'superblock'
          @metadata.superblock = Superblock.new(*get_fields(attr, SUPERBLOCK_FIELDS))

        when 'mapping'
          m = Mapping.new(*get_fields(attr, MAPPING_FIELDS))
          @metadata.mappings << m

        when 'hint'
          h = Hint.new(*get_fields(attr, HINT_FIELDS))
          @metadata.hints << h

        else
          raise "unhandled tag '#{tag} #{attr.map {|x| x.inspect}.join(' ')}'"
        end
      end

      def tag_end(tag)
      end
    end
  end

  def read_xml(io)
    l = CacheParseDetail::Listener.new
    REXML::Document.parse_stream(io, l)
    l.metadata
  end
end

#----------------------------------------------------------------
