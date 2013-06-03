#----------------------------------------------------------------

module ThinpXML
  class Distribution
    def to_i
      generate
    end
  end

  class UniformDistribution
    attr_accessor :start, :stop

    def initialize(start, stop)
      @start = start
      @stop = stop
    end

    def generate
      @start + rand(@stop - @start)
    end
  end
end

#----------------------------------------------------------------
