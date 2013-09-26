require 'thinp_xml/cache/metadata'
require 'thinp_xml/emitter'

#----------------------------------------------------------------

module CacheXML
  module CacheEmitterDetail
    class CacheEmitter
      def initialize(out)
        @e = ThinpXML::Base::Emitter.new(out)
      end

      def emit_superblock(sb, &block)
        @e.emit_tag(sb, 'superblock', :uuid, :block_size, :nr_cache_blocks, :policy, :hint_width, &block)
      end

      def emit_mappings(ms)
        return if no_entries(ms)

        block = lambda do
          ms.each {|m| emit_mapping(m)}
        end

        @e.emit_tag(ms, 'mappings', &block)
      end

      def emit_hints(hs)
        return if no_entries(hs)

        block = lambda do
          hs.each {|h| emit_hint(h)}
        end

        @e.emit_tag(hs, 'hints', &block)
      end

      private
      def no_entries(a)
        a.nil? || a.size == 0
      end

      def emit_mapping(m)
        @e.emit_tag(m, 'mapping', :cache_block, :origin_block, :dirty)
      end

      def emit_hint(h)
        @e.emit_line("<hint cache_block=\"#{m.cache_block}\" data=\"#{h.encoded_data}\"\>")
      end
    end
  end

  #--------------------------------

  def write_xml(metadata, io)
    e = CacheEmitterDetail::CacheEmitter.new(io)
    e.emit_superblock(metadata.superblock) do
      e.emit_mappings(metadata.mappings)
      e.emit_hints(metadata.hints)
    end
  end
end

#----------------------------------------------------------------
