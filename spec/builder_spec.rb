require 'thinp_xml/thinp/builder'
require 'thinp_xml/distribution'

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
      expect(@b.uuid).to eq('')
    end

    it "should reflect any changes" do
      uuid = 'one two three'
      @b.uuid = uuid
      expect(@b.uuid).to eq(uuid)
    end

    it "should generate the correct uuid" do
      uuid = 'one two three'
      @b.uuid = uuid
      md = @b.generate
      expect(md.superblock.uuid).to eq(uuid)
    end
  end

  describe "block_size" do
    it "should be 128 by default" do
      expect(@b.block_size).to eq(128)
    end

    it "should reflect any changes" do
      @b.block_size = 512
      expect(@b.block_size).to eq(512)
    end

    it "should generate the correct block size" do
      bs = 1024
      @b.block_size = bs
      md = @b.generate
      expect(md.superblock.data_block_size).to eq(bs)
    end
  end

  describe "nr of thins" do
    it "zero by default" do
      expect(@b.nr_thins).to eq(0)
    end

    it "should reflect any changes" do
      @b.nr_thins = 5
      expect(@b.nr_thins).to eq(5)
    end

    it "should generate the correct nr" do
      @b.nr_thins = 5
      md = @b.generate

      expect(md.devices.size).to eq(5)
      0.upto(4) do |n|
        expect(md.devices[n]).not_to eq(nil)
      end
    end

    it "should take a distribution" do
      @b.nr_thins = ThinpXML::UniformDistribution.new(2, 6)
      md = @b.generate

      expect(md.devices.size).to be <= 5
      expect(md.size).to be >= 2
    end
  end

  describe "nr of mappings" do
    it "none by default" do
      @b.nr_thins = 1
      expect(@b.generate.devices[0].mappings.size).to eq(0)
    end

    it "should reflect any changes" do
      @b.nr_mappings = 101
      expect(@b.nr_mappings).to eq(101)
    end

    it "should generate the correct nr" do
      @b.nr_thins = 5
      @b.nr_mappings = 101
      md = @b.generate

      0.upto(@b.nr_thins - 1) do |n|
        dev = md.devices[n]
        total = total_mapped(dev)
        expect(total).to eq(101)
        expect(dev.mapped_blocks).to eq(101)
      end
    end

    it "should generate a single mapping" do
      @b.nr_thins = 1
      @b.nr_mappings = 101
      md = @b.generate

      expect(md.devices[0].mappings.size).to eq(1)
    end

    it "should be used to calculate the nr data blocks" do
      @b.nr_thins = 2
      @b.nr_mappings = 117
      md = @b.generate

      expect(md.superblock.nr_data_blocks).to eq(234)
    end
  end
end

#----------------------------------------------------------------
