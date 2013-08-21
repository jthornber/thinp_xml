#----------------------------------------------------------------

module ThinpXML
  class Distribution
    def to_i
      generate
    end
  end

  class ConstDistribution < Distribution
    def initialize(v)
      raise "ConstDistribution must be constructed with an integer" if !v.kind_of?(Integer)
      @v = v
    end

    def generate
      @v
    end
  end

  class UniformDistribution < Distribution
    attr_accessor :start, :stop

    def initialize(start, stop)
      @start = start
      @stop = stop
    end

    def generate
      @start + rand(@stop - @start)
    end
  end

  #--------------------------------

  UNIFORM_REGEX = /uniform\[(\d+)..(\d+)\]/

  def parse_distribution(str)
    m = UNIFORM_REGEX.match(str)
    if m
      ThinpXML::UniformDistribution.new(m[1].to_i, m[2].to_i)
    else
      ConstDistribution.new(Integer(str))
    end
  end
end

#----------------------------------------------------------------
