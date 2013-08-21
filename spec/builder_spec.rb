require 'thinp_xml/thinp/builder'

#----------------------------------------------------------------

describe "ThinpXML::Builder" do
  before :each do
    @b = ThinpXML::Builder.new
  end

  def total_mapped(device)
    device.mappings.inject(0) {|sum, m| sum + m.length}
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
      md.superblock.data_block_size.should == bs
    end
  end

  describe "nr of thins" do
    it "zero by default" do
      @b.nr_thins.should == 0
    end

    it "should reflect any changes" do
      @b.nr_thins = 5
      @b.nr_thins.should == 5
    end

    it "should generate the correct nr" do
      @b.nr_thins = 5
      md = @b.generate

      md.should have(5).devices
      0.upto(4) do |n|
        md.devices[n].should_not == nil
      end
    end

    it "should take a distribution" do
      @b.nr_thins = UniformDistribution.new(2, 6)
      md = @b.generate

      md.should have_at_most(5).devices
      md.should have_at_least(2).devices
    end
  end

  describe "nr of mappings" do
    it "none by default" do
      @b.nr_thins = 1
      @b.generate.devices[0].should have(0).mappings
    end

    it "should reflect any changes" do
      @b.nr_mappings = 101
      @b.nr_mappings.should == 101
    end

    it "should generate the correct nr" do
      @b.nr_thins = 5
      @b.nr_mappings = 101
      md = @b.generate

      0.upto(@b.nr_thins - 1) do |n|
        dev = md.devices[n]
        total = total_mapped(dev)
        total.should == 101
        dev.mapped_blocks.should == 101
      end
    end

    it "should generate a single mapping" do
      @b.nr_thins = 1
      @b.nr_mappings = 101
      md = @b.generate

      md.devices[0].should have(1).mappings
    end

    it "should be used to calculate the nr data blocks" do
      @b.nr_thins = 2
      @b.nr_mappings = 117
      md = @b.generate

      md.superblock.nr_data_blocks.should == 234
    end
  end
end

#----------------------------------------------------------------
