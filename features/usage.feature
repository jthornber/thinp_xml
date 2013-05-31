Feature: The tool should be helpful

  Scenario: --help prints usage to stdout
    When I thinp_xml --help
    Then the stdout should contain:
      """
      Manipulation of thin provisioning xml format metadata
        --help, -h:	Show this message
      """

  Scenario: Unknown sub commands cause fail
    When I thinp_xml unleashtheearwigs
    Then it should fail
    And the stderr should contain:
    """
    unknown command 'unleashtheearwigs'
    """

