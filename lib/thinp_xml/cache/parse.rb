require 'thinp_xml/listener'
require 'thinp_xml/cache/metadata'

require 'rexml/document'
require 'rexml/streamlistener'

#----------------------------------------------------------------

module CacheXML
  module CacheParseDetail
    class Listener
      include ThinpXML::Base::ListenerUtils
      include REXML::StreamListener

      attr_reader :metadata

      def initialize
        @metadata = Metadata.new(nil, [], [])
        @in_mappings = false
        @in_hints = false
      end

      def tag_start(tag, args)
        attr = to_hash(args)

        case tag
        when 'superblock'
          @metadata.superblock = Superblock.new(*get_fields(attr, SUPERBLOCK_FIELDS))

        when 'mappings'
          @in_mappings = true

        when 'mapping'
          raise "not in mappings section" unless @in_mappings
          m = Mapping.new(*get_fields(attr, MAPPING_FIELDS))
          @metadata.mappings << m

        when 'hints'
          @in_hints = true

        when 'hint'
          raise "not in hints section" unless @in_hints
          h = Hint.new(*get_fields(attr, HINT_FIELDS))
          @metadata.hints << h

        else
          raise "unhandled tag '#{tag} #{attr.map {|x| x.inspect}.join(' ')}'"
        end
      end

      def tag_end(tag)
        case tag
        when 'mappings'
          @in_mappings = false

        when 'hints'
          @in_hints = false
        end
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
