Feature: I can create new metadata

  Scenario: Create a valid superblock with no mappings
    When I cache_xml create
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="0">
    </superblock>
    """

  Scenario: Create a valid superblock with specified uuid
    When I cache_xml create --uuid 'one two three'
    Then the stdout should contain:
    """
    <superblock uuid="one two three" block_size="128" nr_cache_blocks="0">
    </superblock>
    """

  Scenario: Create a valid superblock with specified block size
    When I cache_xml create --block-size 512
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="512" nr_cache_blocks="0">
    </superblock>
    """

  Scenario: Take an integer for the number of cached blocks
    When I cache_xml create --nr-cache-blocks 345
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="345">
    </superblock>
    """

  Scenario: Take a uniform distribution  for the number of cached blocks
    When I cache_xml create --nr-cache-blocks uniform[123..124]
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="123">
    </superblock>
    """

  Scenario: Take an integer for the number of mappings
    When I cache_xml create --nr-cache-blocks 3 --nr-mappings 3 --layout linear
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_cache_blocks="3">
      <mapping cache_block="0" origin_block="0" dirty="false"/>
      <mapping cache_block="1" origin_block="1" dirty="false"/>
      <mapping cache_block="2" origin_block="2" dirty="false"/>
    </superblock>
    """
    