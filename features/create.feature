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

  Scenario: Take an expression for the number of mappings per device
    When I thinp_xml create --nr-thins 1 --nr-mappings 67
    Then the stdout should contain:
    """
    <superblock uuid="" time="0" transaction="1" data_block_size="128" nr_data_blocks="100">
      <device dev_id="0" mapped_blocks="67" transaction="0" creation_time="0" snap_time="0">
        <range_mapping origin_begin="0" data_begin="0" length="67" time="1"/>
      </device>
    </superblock>
    """

  Scenario: A uniform distribution can be given for nr thins
    When I thinp_xml create --nr-thins uniform(4,7)
    Then it should pass

  Scenario: An unkown distrubution should fail for the nr thins
    When I thinp_xml create --nr-thins fred(1,2,3)
    Then it should fail



