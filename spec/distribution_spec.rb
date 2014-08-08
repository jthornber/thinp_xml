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
        expect(dist.generate).to eq(5)
      end

      dist = ConstDistribution.new(11)
      10.times do
        expect(dist.generate).to eq(11)
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

    it "should only accept start and stop if they're different" do
      expect {UniformDistribution.new(45, 45)}.to raise_error
    end

    it "should only accept start if it's lower than stop" do
      expect {UniformDistribution.new(45, 35)}.to raise_error
    end

    it "should generate a number from this range every time generate is called" do
      dist = UniformDistribution.new(1, 10)

      buckets = Array.new(11, 0)

      10000.times do
        buckets[dist.generate] += 1
      end

      expect(buckets[0]).to eq(0)
      expect(buckets[10]).to eq(0)

      1.upto(9) do |n|
        expect(buckets[n]).not_to eq(0)
        expect(buckets[n]).to be_approx(1000, 200)
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
      expect($called456).to be_truthy
    end
  end

  #--------------------------------

  describe "parsing" do
    describe "constant expression" do
      it "should parse a const expression" do
        10.times do
          n = rand(50)
          expect(parse_distribution(n.to_s).to_i).to eq(n)
          expect(parse_distribution(n.to_s).to_i).to eq(n)
        end
      end
    end

    describe "uniform expression" do
      def check_range(b, e, n)
        expect(n).to be >= b
        expect(n).to be < e
      end

      it "should accept well formed expressions" do
        10.times do
          b, e = [rand(100), rand(100)].sort
          e += 1
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
