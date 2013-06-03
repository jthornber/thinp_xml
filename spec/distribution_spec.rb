require 'thinp_xml/distribution'

include ThinpXML

#----------------------------------------------------------------

module ApproxInt
  def approx?(target, delta)
    (self.to_i >= target - delta) && (self.to_i <= target + delta)
  end
end

class Fixnum
  include ApproxInt
end

class Bignum
  include ApproxInt
end

#----------------------------------------------------------------

describe "random distributions" do
  describe UniformDistribution do
    it "should be constructed with a range of values" do
      dist = UniformDistribution.new(1, 10)
    end

    it "should generate a number from this range every time generate is called" do
      dist = UniformDistribution.new(1, 10)

      buckets = Array.new(11, 0)

      10000.times do
        buckets[dist.generate] += 1
      end

      buckets[0].should == 0
      buckets[10].should == 0

      1.upto(9) do |n|
        buckets[n].should be_approx(1000, 200)
      end
    end

    it "should have a to_i method that just calls generate" do
      dist = UniformDistribution.new(1, 10)

      # redefine generate
      $called456 = false
      class << dist
        def generate
          $called456 = true
        end
      end

      dist.to_i
      $called456.should be_true
    end
  end
end

#----------------------------------------------------------------
