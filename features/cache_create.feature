Feature: I can create new metadata

  Scenario: Create a valid superblock with no mappings
    When I cache_xml create
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="0" policy="mq" hint_width="4">
    </superblock>
    """

  Scenario: Create a valid superblock with specified uuid
    When I cache_xml create --uuid 'one two three'
    Then the stdout should contain:
    """
    <superblock uuid="one two three" block_size="128" nr_cache_blocks="0" policy="mq" hint_width="4">
    </superblock>
    """

  Scenario: Create a valid superblock with specified block size
    When I cache_xml create --block-size 512
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="512" nr_cache_blocks="0" policy="mq" hint_width="4">
    </superblock>
    """

  Scenario: Take an integer for the number of cached blocks
    When I cache_xml create --nr-cache-blocks 345
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="345" policy="mq" hint_width="4">
    </superblock>
    """

  Scenario: Take a uniform distribution  for the number of cached blocks
    When I cache_xml create --nr-cache-blocks uniform[123..124]
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="123" policy="mq" hint_width="4">
    </superblock>
    """

  Scenario: Take an integer for the number of mappings
    When I cache_xml create --nr-cache-blocks 3 --nr-mappings 3 --layout linear
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="3" policy="mq" hint_width="4">
      <mappings>
        <mapping cache_block="0" origin_block="0" dirty="false"/>
        <mapping cache_block="1" origin_block="1" dirty="false"/>
        <mapping cache_block="2" origin_block="2" dirty="false"/>
      </mappings>
    </superblock>
    """

  Scenario: Take a percentage for the number of dirty mappings
    When I cache_xml create --nr-cache-blocks 3 --nr-mappings 3 --layout linear --dirty-percent 100
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="3" policy="mq" hint_width="4">
      <mappings>
        <mapping cache_block="0" origin_block="0" dirty="true"/>
        <mapping cache_block="1" origin_block="1" dirty="true"/>
        <mapping cache_block="2" origin_block="2" dirty="true"/>
      </mappings>
    </superblock>
    """

  Scenario: Take the policy name
    When I cache_xml create --nr-cache-blocks 3 --nr-mappings 3 --layout linear --policy fred
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="3" policy="fred" hint_width="4">
      <mappings>
        <mapping cache_block="0" origin_block="0" dirty="false"/>
        <mapping cache_block="1" origin_block="1" dirty="false"/>
        <mapping cache_block="2" origin_block="2" dirty="false"/>
      </mappings>
    </superblock>
    """

  Scenario: Take the hint width
    When I cache_xml create --nr-cache-blocks 3 --nr-mappings 3 --layout linear --hint-width 8
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="3" policy="mq" hint_width="8">
      <mappings>
        <mapping cache_block="0" origin_block="0" dirty="false"/>
        <mapping cache_block="1" origin_block="1" dirty="false"/>
        <mapping cache_block="2" origin_block="2" dirty="false"/>
      </mappings>
    </superblock>
    """