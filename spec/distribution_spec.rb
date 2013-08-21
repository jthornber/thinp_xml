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

describe "integer distributions" do
  describe ConstDistribution do
    it "should be constructed with a single value" do
      expect do
        dist = ConstDistribution.new
      end.to raise_error

      expect do
        dist = ConstDistribution.new(1, 2)
      end.to raise_error
    end

    it "should always return it's given value" do
      dist = ConstDistribution.new(5)
      10.times do
        dist.generate.should == 5
      end

      dist = ConstDistribution.new(11)
      10.times do
        dist.generate.should == 11
      end
    end

    it "should be passed an integer" do
      expect do
        dist = ConstDistribution.new('fish')
      end.to raise_error
    end
  end

  #--------------------------------

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
        buckets[n].should_not == 0
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

  #--------------------------------

  describe "parsing" do
    describe "constant expression" do
      it "should parse a const expression" do
        10.times do
          n = rand(50)
          parse_distribution(n.to_s).to_i.should == n
          parse_distribution(n.to_s).to_i.should == n
        end
      end
    end

    describe "uniform expression" do
      def check_range(b, e, n)
        n.should >= b
        n.should < e
      end

      it "should accept well formed expressions" do
        10.times do
          b, e = [rand(100), rand(100)].sort
          d = parse_distribution("uniform[#{b}..#{e}]")

          100.times do
            check_range(b, e, d.to_i)
          end
        end
      end

      it "should reject badly formed expressions" do
        bad = ['fred[1..20]',
               'uniform[1..]',
               'uniform[..20]',
               'uniform 1..20',
               'uniform[1..20',
               'uniform1..20]']
        bad.each do |b|
          expect {parse_distribution(b)}.to raise_error
        end
      end
    end
  end
end

#----------------------------------------------------------------
