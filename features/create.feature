Feature: I can create new metadata

  @announce
  Scenario: Create a fully mapped volume
    When I thinp_xml create
    Then the stdout should contain:
    """
    <superblock uuid="uuid here" time="0" transaction="1" data_block_size="128" nr_data_blocks="100">
    </superblock>
    """