Feature: The tool should be helpful

  Scenario: --help prints usage to stdout
    When I cache_xml --help
    Then the stdout should contain:
      """
      Manipulation of cache xml format metadata

      Usage:
        cache_xml [options]
          --help, -h:    Show this message

        cache_xml create [options]
          --uuid:              Set the uuid
          --block-size:        In 512 byte sectors
          --nr-cache-blocks:   Set the nr of blocks in the cache device
          --nr-mappings:       Set the nr of mappings, either a number or distribution (eg, 'uniform[45..100]')
          --dirty-percentage:  What percentage of the cache should be marked dirty
          --policy-name:       Set the name of the cache policy (eg, 'mq')
          --hint-width:        Set the hint width (current kernels only support 4 bytes)
          --mapping-policy:    Changes how the mappings are generated; 'random' or 'linear'
      """

  Scenario: Unknown sub commands cause fail
    When I cache_xml unleashtheearwigs
    Then it should fail
    And the stderr should contain:
    """
    unknown command 'unleashtheearwigs'
    """
