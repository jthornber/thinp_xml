require 'thinp_xml/era/builder'

require 'set'

#----------------------------------------------------------------

describe "EraXML::Builder" do
  before :each do
    @b = EraXML::Builder.new
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
      expect(md.superblock.block_size).to eq(bs)
    end
  end

  describe "nr_blocks" do
    it "should be 0 by default" do
      expect(@b.nr_blocks).to eq(0)
    end

    it "should reflect any changes" do
      @b.nr_blocks = 1234
      expect(@b.nr_blocks).to eq(1234)
    end

    it "should generate the correct nr blocks" do
      n = 1234
      @b.nr_blocks = n
      md = @b.generate
      expect(md.superblock.nr_blocks).to eq(n)
    end
  end

  describe "current_era" do
    it "should be 0 by default" do
      expect(@b.current_era).to eq(0)
    end

    it "should reflect any changes" do
      @b.current_era = 678
      expect(@b.current_era).to eq(678)
    end

    it "should generate the correct current_era" do
      @b.current_era = 678
      md = @b.generate
      expect(md.superblock.current_era).to eq(678)
    end
  end

  describe "nr_writesets" do
    it "should be 0 by default" do
      expect(@b.nr_writesets).to eq(0)
    end

    it "should reflect any changes" do
      @b.nr_writesets = 34
      expect(@b.nr_writesets).to eq(34)
    end

    it "should generate the correct nr writesets" do
      @b.current_era = 100
      @b.nr_writesets = 34
      md = @b.generate
      expect(md.writesets.size).to eq(34)
    end

    it "should raise if asked to generate more writesets than eras" do
      @b.nr_writesets = 50
      @b.current_era = 40
      expect do
        @b.generate
      end.to raise_error(RuntimeError)
    end
  end

  describe "generated metadata" do
    before :each do
      @b.nr_blocks = 1234
      @b.nr_writesets = 50
      @b.current_era = 100
      @md = @b.generate
    end

    describe "era array" do
      it "should have nr_blocks entries" do
        expect(@md.era_array.size).to eq(@b.nr_blocks)
      end

      it "should have no value higher than the current era" do
        @md.era_array.each do |era|
          expect(era).to be <= @b.current_era
        end
      end
    end

    describe "generated writesets" do
      it "should not have an era higher than the current era" do
        @md.writesets.each do |ws|
          expect(ws.era).to be <= @b.current_era
        end
      end

      it "should not have duplicate eras" do
        seen = Set.new
        @md.writesets.each do |ws|
          expect(seen.member?(ws.era)).to be false
          seen.add(ws.era)
        end
      end

      it "should have the correct number of bits" do
        @md.writesets.each do |ws|
          expect(ws.bits.size).to eq(@b.nr_blocks)
        end
      end
    end
  end
end

#----------------------------------------------------------------
