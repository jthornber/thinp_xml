#----------------------------------------------------------------

module ThinpXML
  module Base
    module ListenerUtils
      def to_hash(pairs)
        r = Hash.new
        pairs.each do |p|
          r[p[0].intern] = p[1]
        end
        r
      end

      def get_fields(attr, flds)
        flds.map do |n,t|
          case t
          when :int
            attr[n].to_i

          when :string
            attr[n]

          when :object
            attr[n]

          else
            raise "unknown field type"
          end
        end
      end

      def text(data)
        return if data =~ /^\w*$/ # ignore whitespace
        abbrev = data[0..40] + (data.length > 40 ? "..." : "")
        puts "  text    :    #{abbrev.inspect}"
      end
    end
  end
end

#----------------------------------------------------------------
