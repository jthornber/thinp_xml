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
        @e.emit_tag(sb, 'superblock', :uuid, :block_size, :nr_cache_blocks, &block)
      end

      def emit_mapping(m)
        @e.emit_tag(m, 'mapping', :cache_block, :origin_block)
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
      metadata.mappings.each do |m|
        e.emit_mapping(m)
      end

      metadata.hints.each do |h|
        e.emit_hint(h)
      end
    end
  end
end

#----------------------------------------------------------------
