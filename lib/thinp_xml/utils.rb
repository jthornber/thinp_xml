require 'thinp_xml/metadata'

#----------------------------------------------------------------

module ThinpXML
  def get_device(md, dev_id)
    md.devices.each do |dev|
      if dev.dev_id == dev_id
        return dev
      end
    end
  end

  # Turns 2 lists of mappings, into a list of pairs of mappings.
  # These pairs cover identical regions.  nil is used for the
  # data_begin if that region isn't mapped.
  def expand_mappings(left, right)
    pairs = Array.new
    i1 = 0
    i2 = 0

    m1 = left[i1]
    m2 = right[i2]

    # look away now ...
    loop do
      if !m1 && !m2
        return pairs
      elsif !m1
        pairs << [Mapping.new(m2.origin_begin, nil, m2.length, m2.time),
                  m2]
        m2 = nil
      elsif !m2
        pairs << [m1,
                  Mapping.new(m1.origin_begin, nil, m1.length, m1.time)]
        m1 = nil
      elsif m1.origin_begin < m2.origin_begin
        if m1.origin_begin + m1.length <= m2.origin_begin
          pairs << [Mapping.new(m1.origin_begin, m1.data_begin, m1.length, m1.time),
                    Mapping.new(m1.origin_begin, nil, m1.length, m1.time)]
          i1 += 1
          m1 = left[i1]
        else
          len = m2.origin_begin - m1.origin_begin
          pairs << [Mapping.new(m1.origin_begin, m1.data_begin, len, m1.time),
                    Mapping.new(m1.origin_begin, nil, len, m1.time)]
          m1 = Mapping.new(m1.origin_begin + len, m1.data_begin + len, m1.length - len, m1.time)
        end
      elsif m2.origin_begin < m1.origin_begin
        if m2.origin_begin + m2.length <= m1.origin_begin
          pairs << [Mapping.new(m2.origin_begin, nil, m2.length, m2.time),
                    Mapping.new(m2.origin_begin, m2.data_begin, m2.length, m2.time)]
          i2 += 1
          m2 = right[i2]
        else
          len = m1.origin_begin - m2.origin_begin
          pairs << [Mapping.new(m2.origin_begin, nil, len, m2.time),
                    Mapping.new(m2.origin_begin, m2.data_begin, len, m2.time)]
          m2 = Mapping.new(m2.origin_begin + len, m2.data_begin + len, m2.length - len, m2.time)
        end
      else
        len = [m1.length, m2.length].min
        pairs << [Mapping.new(m1.origin_begin, m1.data_begin, len, m1.time),
                  Mapping.new(m1.origin_begin, m2.data_begin, len, m2.time)]
        if m1.length < m2.length
          i1 += 1
          m1 = left[i1]
          m2 = Mapping.new(m2.origin_begin + len, m2.data_begin + len, m2.length - len, m2.time)
        elsif m2.length < m1.length
          i2 += 1
          m1 = Mapping.new(m1.origin_begin + len, m1.data_begin + len, m1.length - len, m1.time)
          m2 = right[i2]
        else
          i1 += 1
          i2 += 1
          m1 = left[i1]
          m2 = right[i2]
        end
      end
    end
  end

  # returns 3 arrays of mappings: unique to first arg, common, unique
  # to second arg
  def compare_devs(md_dev1, md_dev2)
    m1 = md_dev1.mappings
    m2 = md_dev2.mappings

    left = Array.new
    center = Array.new
    right = Array.new

    expand_mappings(m1, m2).each do |pair|
      if pair[0].data_begin == pair[1].data_begin &&
          pair[0].time == pair[1].time
        # mappings are the same
        center << pair[0]
      else
        left << pair[0]
        right << pair[1]
      end
    end

    [left, center, right].each {|a| a.reject {|e| e.data_begin == nil}}
    [left, center, right]
  end

  def compare_thins(md1, md2, dev_id)
    compare_devs(get_device(md1, dev_id),
                 get_device(md2, dev_id))
  end
end

#----------------------------------------------------------------

