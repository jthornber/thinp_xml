require 'thinp_xml/cache/parse'

include CacheXML

#----------------------------------------------------------------

INPUT=<<EOF
<superblock uuid="" block_size="512" nr_cache_blocks="4096" policy="hints" hint_width="4">
  <mappings>
    <mapping cache_block="0" origin_block="4095" dirty="false"/>
    <mapping cache_block="1" origin_block="0" dirty="false"/>
    <mapping cache_block="2" origin_block="4" dirty="false"/>
    <mapping cache_block="3" origin_block="1" dirty="false"/>
    <mapping cache_block="4" origin_block="8" dirty="false"/>
  </mappings>
  <hints>
    <hint cache_block="0" data="AQAAAA=="/>
    <hint cache_block="1" data="AAAAAA=="/>
    <hint cache_block="2" data="AgAAAA=="/>
    <hint cache_block="3" data="AAAAAA=="/>
    <hint cache_block="4" data="AwAAAA=="/>
  </hints>
</superblock>
EOF

describe "CacheXML::read_xml" do
  # a sanity check (debugging some namespace issues)
  it "should work" do
    CacheXML::read_xml(StringIO.new(INPUT))
  end
end

#----------------------------------------------------------------
