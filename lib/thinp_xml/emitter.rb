#----------------------------------------------------------------

module ThinpXML
  module Base
    class Emitter
      def initialize(out)
        @out = out
        @indent = 0
      end

      def emit_tag(obj, tag, *fields, &block)
        expanded = fields.map {|fld| "#{fld}=\"#{obj.send(fld)}\""}
        if block.nil?
          emit_line "<#{tag}#{join_fields(expanded)}/>"
        else
          emit_line "<#{tag}#{join_fields(expanded)}>"
          push
          yield unless block.nil?
          pop
          emit_line "</#{tag}>"
        end
      end

      def emit_line(str)
        @out.puts((' ' * @indent) + str)
      end

      private

      def join_fields(fields)
        fields.size == 0 ? "" : " #{fields.join(' ')}"
      end

      def push
        @indent += 2
      end

      def pop
        @indent -= 2
      end
    end
  end
end

#----------------------------------------------------------------
