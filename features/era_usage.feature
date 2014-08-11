Feature: The tool should be helpful

  Scenario: --help prints usage to stdout
    When I era_xml --help
    Then the stdout should contain:
      """
      Manipulation of era xml format metadata

      Usage:
         era_xml [options]
           --help, -h:   Show this message

         era_xml create [options]
           --uuid:         Set the uuid for the metadata
           --block-size:   Set the block size, in 512 byte sectors
           --nr-blocks:    Set the number of blocks
           --current-era:  Set the current era

           --nr-writesets: Output a number of undigested writesets (you
                           probably don't need this unless you're debugging).
      """

  Scenario: Unknown sub commands cause fail
    When I era_xml unleashtheearwigs
    Then it should fail
    And the stderr should contain:
    """
    unknown command 'unleashtheearwigs'
    """
