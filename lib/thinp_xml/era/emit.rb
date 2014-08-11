require 'thinp_xml/era/metadata'
require 'thinp_xml/emitter'

#----------------------------------------------------------------

module EraXML
  module EraEmitterDetail
    class EraEmitter
      def initialize(out)
        @e = ThinpXML::Base::Emitter.new(out)
      end

      def emit_superblock(sb, &block)
        @e.emit_tag(sb, 'superblock', :uuid, :block_size, :nr_blocks, :current_era, &block)
      end

      def emit_writesets(sets)
        sets.each do |ws|
          block = lambda do
            ws.bits.each do |b|
              @e.emit_tag(b, :block, :value)
            end
          end

          @e.emit_tag(ws, 'writeset', :era, :nr_blocks, &block)
        end
      end

      def emit_era_array(ea)
        block = lambda do
          ea.each_index do |b|
            @e.emit_line("<era block=\"#{b}\" era=\"#{ea[b]}\"\\>")
          end
        end

        @e.emit_tag(ea, 'era_array', &block)
      end
    end
  end
  
  #--------------------------------

  def write_xml(md, io)
    e = EraEmitterDetail::EraEmitter.new(io)
    e.emit_superblock(md.superblock) do
      e.emit_writesets(md.writesets)
      e.emit_era_array(md.era_array)
    end
  end
end

#----------------------------------------------------------------
