require 'thinp_xml/thinp/metadata'

#----------------------------------------------------------------

module ThinpXML
  class Emitter
    def initialize(out)
      @out = out
      @indent = 0
    end

    def emit_tag(obj, tag, *fields, &block)
      expanded = fields.map {|fld| "#{fld}=\"#{obj.send(fld)}\""}
      if block.nil?
        emit_line "<#{tag} #{expanded.join(' ')}/>"
      else
        emit_line "<#{tag} #{expanded.join(' ')}>"
        push
        yield unless block.nil?
        pop
        emit_line "</#{tag}>"
      end
    end

    def emit_line(str)
      @out.puts((' ' * @indent) + str)
    end

    def push
      @indent += 2
    end

    def pop
      @indent -= 2
    end
  end

  def emit_superblock(e, sb, &block)
    e.emit_tag(sb, 'superblock', :uuid, :time, :transaction, :data_block_size, :nr_data_blocks, &block)
  end

  def emit_device(e, dev, &block)
    e.emit_tag(dev, 'device', :dev_id, :mapped_blocks, :transaction, :creation_time, :snap_time, &block)
  end

  def emit_mapping(e, m)
    if m.length == 1
      e.emit_line("<single_mapping origin_block=\"#{m.origin_begin}\" data_block=\"#{m.data_begin}\" time=\"#{m.time}\"/>")
    else
      e.emit_tag(m, 'range_mapping', :origin_begin, :data_begin, :length, :time)
    end
  end

  def write_xml(metadata, io)
    e = Emitter.new(io)

    emit_superblock(e, metadata.superblock) do
      metadata.devices.each do |dev|
        emit_device(e, dev) do
          dev.mappings.each do |m|
            emit_mapping(e, m)
          end
        end
      end
    end
  end
end

#----------------------------------------------------------------
