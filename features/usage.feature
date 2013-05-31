Feature: The tool should be helpful

  Scenario: --help prints usage to stdout
    When I thinp_xml --help
    Then the stdout should contain:
      """
      Manipulation of thin provisioning xml format metadata
        --help, -h:	Show this message
      """
