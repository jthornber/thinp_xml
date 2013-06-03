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

  Scenario: Take an expression for the number of devices
    When I thinp_xml create --nr-thins 3
    Then the stdout should contain:
    """
    <superblock uuid="" time="0" transaction="1" data_block_size="128" nr_data_blocks="100">
      <device dev_id="0" mapped_blocks="0" transaction="0" creation_time="0" snap_time="0">
      </device>
      <device dev_id="1" mapped_blocks="0" transaction="0" creation_time="0" snap_time="0">
      </device>
      <device dev_id="2" mapped_blocks="0" transaction="0" creation_time="0" snap_time="0">
      </device>
    </superblock>
    """

