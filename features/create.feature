Feature: I can create new metadata

  Scenario: Create a valid superblock with no devices
    When I thinp_xml create
    Then the stdout should contain:
    """
    <superblock uuid="" time="0" transaction="1" data_block_size="128" nr_data_blocks="100">
    </superblock>
    """

  Scenario: Create a valid superblock with specified uuid
    When I thinp_xml create --uuid 'one two three'
    Then the stdout should contain:
    """
    <superblock uuid="one two three" time="0" transaction="1" data_block_size="128" nr_data_blocks="100">
    </superblock>
    """

