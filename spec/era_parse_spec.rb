require 'thinp_xml/era/parse'

include EraXML

#----------------------------------------------------------------

describe "EraXML::read_xml" do
  it "should handle metadata with zero blocks" do
    metadata = read_xml(StringIO.new(<<EOF))
<superblock uuid="" block_size="128" nr_blocks="0" current_era="0">
  <era_array>
  </era_array>
</superblock>
EOF

    expect(metadata.superblock).to eq(Superblock.new("", 128, 0, 0))
    expect(metadata.writesets).to eq([])
    expect(metadata.era_array).to eq([])
  end

  it "should handle more complicated metadata" do
    metadata = read_xml(StringIO.new(<<EOF))
<superblock uuid="blip blop" block_size="256" nr_blocks="32" current_era="100">
  <writeset era="98" nr_bits="32">
    <bit block="0" value="true"/>
    <bit block="1" value="true"/>
    <bit block="2" value="false"/>
    <bit block="3" value="false"/>
    <bit block="4" value="false"/>
    <bit block="5" value="true"/>
    <bit block="6" value="true"/>
    <bit block="7" value="false"/>
    <bit block="8" value="true"/>
    <bit block="9" value="true"/>
    <bit block="10" value="true"/>
    <bit block="11" value="true"/>
    <bit block="12" value="false"/>
    <bit block="13" value="false"/>
    <bit block="14" value="false"/>
    <bit block="15" value="false"/>
    <bit block="16" value="true"/>
    <bit block="17" value="true"/>
    <bit block="18" value="true"/>
    <bit block="19" value="true"/>
    <bit block="20" value="false"/>
    <bit block="21" value="true"/>
    <bit block="22" value="false"/>
    <bit block="23" value="false"/>
    <bit block="24" value="false"/>
    <bit block="25" value="false"/>
    <bit block="26" value="true"/>
    <bit block="27" value="true"/>
    <bit block="28" value="true"/>
    <bit block="29" value="true"/>
    <bit block="30" value="true"/>
    <bit block="31" value="false"/>
  </writeset>
  <writeset era="99" nr_bits="32">
    <bit block="0" value="false"/>
    <bit block="1" value="true"/>
    <bit block="2" value="false"/>
    <bit block="3" value="false"/>
    <bit block="4" value="false"/>
    <bit block="5" value="true"/>
    <bit block="6" value="true"/>
    <bit block="7" value="true"/>
    <bit block="8" value="false"/>
    <bit block="9" value="false"/>
    <bit block="10" value="true"/>
    <bit block="11" value="true"/>
    <bit block="12" value="true"/>
    <bit block="13" value="false"/>
    <bit block="14" value="true"/>
    <bit block="15" value="true"/>
    <bit block="16" value="false"/>
    <bit block="17" value="true"/>
    <bit block="18" value="false"/>
    <bit block="19" value="false"/>
    <bit block="20" value="false"/>
    <bit block="21" value="false"/>
    <bit block="22" value="true"/>
    <bit block="23" value="true"/>
    <bit block="24" value="false"/>
    <bit block="25" value="false"/>
    <bit block="26" value="false"/>
    <bit block="27" value="false"/>
    <bit block="28" value="true"/>
    <bit block="29" value="true"/>
    <bit block="30" value="false"/>
    <bit block="31" value="true"/>
  </writeset>
  <era_array>
    <era block="0" era="62"/>
    <era block="1" era="27"/>
    <era block="2" era="8"/>
    <era block="3" era="19"/>
    <era block="4" era="70"/>
    <era block="5" era="69"/>
    <era block="6" era="57"/>
    <era block="7" era="33"/>
    <era block="8" era="66"/>
    <era block="9" era="42"/>
    <era block="10" era="85"/>
    <era block="11" era="68"/>
    <era block="12" era="10"/>
    <era block="13" era="12"/>
    <era block="14" era="43"/>
    <era block="15" era="68"/>
    <era block="16" era="45"/>
    <era block="17" era="7"/>
    <era block="18" era="16"/>
    <era block="19" era="73"/>
    <era block="20" era="29"/>
    <era block="21" era="16"/>
    <era block="22" era="94"/>
    <era block="23" era="91"/>
    <era block="24" era="9"/>
    <era block="25" era="80"/>
    <era block="26" era="93"/>
    <era block="27" era="96"/>
    <era block="28" era="62"/>
    <era block="29" era="75"/>
    <era block="30" era="46"/>
    <era block="31" era="14"/>
  </era_array>
</superblock>
EOF

    expect(metadata.superblock).to eq(Superblock.new("blip blop", 256, 32, 100))
    expect(metadata.writesets.size).to eq(2)

    expect(metadata.writesets[0].era).to eq(98)
    expect(metadata.writesets[0].nr_bits).to eq(32)
    expect(metadata.writesets[0].bits[4]).to eq(false)
    expect(metadata.writesets[0].bits[6]).to eq(true)
    expect(metadata.writesets[0].bits[16]).to eq(true)
    expect(metadata.writesets[0].bits[31]).to eq(false)

    expect(metadata.writesets[1].era).to eq(99)
    expect(metadata.writesets[1].nr_bits).to eq(32)
    expect(metadata.writesets[1].bits[4]).to eq(false)
    expect(metadata.writesets[1].bits[6]).to eq(true)
    expect(metadata.writesets[1].bits[16]).to eq(false)
    expect(metadata.writesets[1].bits[31]).to eq(true)

    expect(metadata.era_array[7]).to eq(33)
    expect(metadata.era_array[12]).to eq(10)
    expect(metadata.era_array[31]).to eq(14)
  end
end

#----------------------------------------------------------------
