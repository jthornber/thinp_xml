require 'thinp_xml/listener'
require 'thinp_xml/era/metadata'

require 'rexml/document'
require 'rexml/streamlistener'

#----------------------------------------------------------------

module EraXML
  module EraParseDetail
    class Listener
      include ThinpXML::Base::ListenerUtils
      include REXML::StreamListener

      attr_reader :metadata

      def initialize
        @in_era_array = false
        @in_writeset = false
        @writesets = []
      end

      def tag_start(tag, args)
        attr = to_hash(args)

        case tag
        when 'superblock'
          @superblock = Superblock.new(*get_fields(attr, SUPERBLOCK_FIELDS))
          @era_array = Array.new(attr[:nr_blocks].to_i, 0)

        when 'writeset'
          @in_writeset = true
          @writeset_era = attr[:era].to_i
          @current_writeset = Array.new(attr[:nr_bits].to_i, false)

        when 'bit'
          raise "bit when not in a bitset" unless @in_writeset
          @current_writeset[attr[:block].to_i] = to_bool(attr[:value])

        when 'era_array'
          @in_era_array = true

        when 'era'
          raise "not in era array" unless @in_era_array
          @era_array[attr[:block].to_i] = attr[:era].to_i

        else
          raise "unhandled tag '#{tag} #{attr.map {|x| x.inspect}.join(' ')}'"
        end
      end

      def tag_end(tag)
        case tag
        when 'writeset'
          @writesets << Writeset.new(@writeset_era,
                                     @current_writeset.size,
                                     @current_writeset)
          @in_writeset = false

        when 'era_array'
          @in_era_array = false

        when 'superblock'
          @metadata = Metadata.new(@superblock, @writesets, @era_array)
        end
      end

      def to_bool(str)
        case str
        when 'true'
          true

        when 'false'
          false

        else
          raise "bad bool value: #{str}"
        end
      end
    end
  end

  def read_xml(io)
    l = EraParseDetail::Listener.new
    REXML::Document.parse_stream(io, l)
    l.metadata
  end
end

#----------------------------------------------------------------
