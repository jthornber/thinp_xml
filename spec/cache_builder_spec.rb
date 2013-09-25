require 'thinp_xml/cache/builder'

#----------------------------------------------------------------

describe "CacheXML::Builder" do
  def as_percentage(n, tot)
    (n * 100) / tot
  end

  def approx_percentage(n, tot, target)
    actual = as_percentage(n, tot)
    (actual - target).abs < 3
  end

  before :each do
    @b = CacheXML::Builder.new
  end

  describe "uuid" do
    it "should be an empty string by default" do
      @b.uuid.should == ''
    end

    it "should reflect any changes" do
      uuid = 'one two three'
      @b.uuid = uuid
      @b.uuid.should == uuid
    end

    it "should generate the correct uuid" do
      uuid = 'one two three'
      @b.uuid = uuid
      md = @b.generate
      md.superblock.uuid.should == uuid
    end
  end

  describe "block_size" do
    it "should be 128 by default" do
      @b.block_size.should == 128
    end

    it "should reflect any changes" do
      @b.block_size = 512
      @b.block_size.should == 512
    end

    it "should generate the correct block size" do
      bs = 1024
      @b.block_size = bs
      md = @b.generate
      md.superblock.block_size.should == bs
    end
  end

  describe "nr cache blocks" do
    it "should be zero by default" do
      @b.nr_cache_blocks.should == 0
      @b.generate.should have(0).mappings
    end

    it "should reflect any changes" do
      n = rand(1000)
      @b.nr_cache_blocks = n
      @b.nr_cache_blocks.should == n
      @b.generate.superblock.nr_cache_blocks.should == n
    end
  end

  describe "policy name" do
    it "should be 'mq' by default" do
      @b.policy_name.should == 'mq'
      @b.generate.superblock.policy.should == 'mq'
    end

    it "should reflect changes" do
      n = 'most_recently_not_used_least'
      @b.policy_name = n
      @b.policy_name.should == n
      @b.generate.superblock.policy.should == n
    end
  end

  describe "hint width" do
    it "should be '4' by default" do
      @b.hint_width.should == 4
      @b.generate.superblock.hint_width.should == 4
    end

    it "should allow a hint size between 4 and 128, mod 4" do
      0.upto(132) do |n|
        if (((n % 4) == 0) && n <= 128)
          @b.hint_width = n
          @b.hint_width.should == n
        end
      end
    end

    it "should disallow other hint sizes" do
      [3, 7, 23, 93, 129].each do |n|
        expect do
          @b.hint_width = n
        end.to raise_error
      end
    end

    it "should reflect changes" do
      @b.hint_width = 12
      @b.generate.superblock.hint_width.should == 12
    end
  end

  describe "mappings" do
    describe "mapping policy" do
      it "should default to :random" do
        @b.mapping_policy.should == :random
      end

      it "should only accept :random, or :linear" do
        [:foo, :bar, :jumpy].each do |p|
          expect {@b.mapping_policy = p}.to raise_error
        end
      end
    end

    describe "nr mappings" do
      it "should default to zero" do
        @b.nr_mappings.should == 0
      end

      it "should never be bigger than the nr_cache_blocks" do
        100.times do
          nr_cache = rand(1000)
          @b.nr_cache_blocks = nr_cache
          expect {@b.nr_mappings = nr_cache + rand(20) + 1}.to raise_error
        end
      end

      it "should generate the given number of mappings" do
        100.times do
          @b.nr_cache_blocks = rand(1000)
          @b.nr_mappings = rand(@b.nr_cache_blocks)
          @b.generate.should have(@b.nr_mappings).mappings
        end
      end
    end

    describe "dirty percentage" do
      it "should default to zero" do
        @b.dirty_percentage.should == 0
      end

      it "should throw if set to a negative number" do
        expect do
          @b.dirty_percentage = -20
        end.to raise_error(RuntimeError, /-20/)
      end

      it "should throw if set to a > 100 number" do
        expect do
          @b.dirty_percentage = 101
        end.to raise_error(RuntimeError, /101/)
      end

      it "should accept a valid value" do
        [0, 1, 34, 78, 99, 100].each do |valid_value|
          @b.dirty_percentage = valid_value
          @b.dirty_percentage.should == valid_value
        end
      end

      it "should generate the required percentage" do
        n_mappings = 10000
        @b.nr_cache_blocks = n_mappings
        @b.nr_mappings = n_mappings

        [0, 1, 34, 78, 99, 100].each do |p|
          @b.dirty_percentage = p
          metadata = @b.generate
          nr_dirty = 0
          metadata.mappings.each do |m|
            nr_dirty += 1 if m.dirty
          end

          approx_percentage(nr_dirty, n_mappings, p).should be_true
        end
      end
    end

    describe "linear layout" do
      before :each do
        @b.mapping_policy = :linear
      end

      it "should allocate cache blocks in order" do
        @b.nr_cache_blocks = 100
        @b.nr_mappings = rand(@b.nr_cache_blocks)
        mappings = @b.generate.mappings

        cb = 0
        mappings.each do |m|
          m.cache_block.should == cb
          cb += 1
        end
      end

      it "should allocate origin blocks in order" do
        @b.nr_cache_blocks = 100
        @b.nr_mappings = 100
        mappings = @b.generate.mappings

        b = nil
        mappings.each do |m|
          if b.nil?
            b = m.origin_block
          else
            m.origin_block.should == b
          end

          b += 1
        end
      end
    end

    describe "random mapping" do
      before :each do
        @b.mapping_policy = :random
      end

      it "should allocate cache blocks in order" do
        @b.nr_cache_blocks = 100
        @b.nr_mappings = rand(@b.nr_cache_blocks)
        mappings = @b.generate.mappings

        cb = 0
        mappings.each do |m|
          m.cache_block.should == cb
          cb += 1
        end
      end

      it "should allocate origin blocks out of order" do
        @b.nr_cache_blocks = 100
        @b.nr_mappings = 100
        mappings = @b.generate.mappings

        in_order = true
        b = nil
        mappings.each do |m|
          if b.nil?
            b = m.origin_block
          else
            if m.origin_block != b
              in_order = false
            end
          end

          b += 1
        end

        in_order.should be_false
      end
    end
  end
end

#----------------------------------------------------------------

