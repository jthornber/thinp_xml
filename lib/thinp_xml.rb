module ThinpXML
  THINP_TOOLS_VERSION = '0.7'

  def self.tools_are_installed
    true
  end
end

unless ThinpXML::tools_are_installed
  raise "please install the thin provisioning tools version #{THINP_TOOLS_VERSION}"
end

require 'thinp_xml/thinp/builder'
require 'thinp_xml/thinp/emit'
require 'thinp_xml/thinp/metadata'
require 'thinp_xml/thinp/parse'
require 'thinp_xml/thinp/utils'
require 'thinp_xml/version'
