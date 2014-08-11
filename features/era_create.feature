Feature: I can create new metadata

  Scenario: Create a valid superblock with no blocks
    When I era_xml create
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="128" nr_blocks="0" current_era="0">
      <era_array>
      </era_array>
    </superblock>
    """

  Scenario: Create a valid superblock with specified uuid
    When I era_xml create --uuid 'one two three'
    Then the stdout should contain:
    """
    <superblock uuid="one two three" block_size="128" nr_blocks="0" current_era="0">
      <era_array>
      </era_array>
    </superblock>
    """

  Scenario: Create a superblock with specified block size
    When I era_xml create --block-size 512
    Then the stdout should contain:
    """
    <superblock uuid="" block_size="512" nr_blocks="0" current_era="0">
      <era_array>
      </era_array>
    </superblock>
    """

  Scenario: Fail if the block size is not an integer
    When I era_xml create --block-size large
    Then it should fail
    
  Scenario: Accept --nr-blocks
    When I era_xml create --nr-blocks 8
    Then it should pass

  Scenario: Fail if the nr blocks is not an integer
    When I era_xml create --nr-blocks loads
    Then it should fail

  Scenario: Accept --current-era
    When I era_xml create --current-era 1000
    Then it should pass

  Scenario: Fail if the current era is not an integer
    When I era_xml create --current-era peistocene
    Then it should fail

  Scenario: Accept --nr-writesets
    When I era_xml create --nr-writesets 56 --current-era 100
    Then it should pass

  Scenario: Fail if the nr writesets is not an integer
    When I era_xml create --nr-writesets lots --current-era 1000
    Then it should fail