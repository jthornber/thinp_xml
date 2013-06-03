module ThinpXML
  THINP_TOOLS_VERSION = '0.1.5'

  def self.tools_are_installed
    true
  end
end

unless ThinpXML::tools_are_installed
  raise "please install the thin provisioning tools version #{THINP_TOOLS_VERSION}"
end

require 'thinp_xml/builder'
require 'thinp_xml/emit'
require 'thinp_xml/metadata'
require 'thinp_xml/parse'
require 'thinp_xml/utils'
require 'thinp_xml/version'
