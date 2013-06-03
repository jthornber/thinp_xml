require 'thinp_xml/builder'

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
  end
end

#----------------------------------------------------------------
