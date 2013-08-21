Feature: The tool should be helpful

  Scenario: --help prints usage to stdout
    When I cache_xml --help
    Then the stdout should contain:
      """
      Manipulation of cache xml format metadata
        --help, -h:	Show this message
      """

  Scenario: Unknown sub commands cause fail
    When I cache_xml unleashtheearwigs
    Then it should fail
    And the stderr should contain:
    """
    unknown command 'unleashtheearwigs'
    """
