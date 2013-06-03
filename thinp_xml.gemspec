# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thinp_xml/version'

Gem::Specification.new do |spec|
  spec.name          = "thinp_xml"
  spec.version       = ThinpXml::VERSION
  spec.authors       = ["Joe Thornber"]
  spec.email         = ["ejt@redhat.com"]
  spec.description   = %q{Ruby library for parsing and generating the Linux thin-provisioning xml metadata format.}
  spec.summary       = %q{Thin provisioning xml}
  spec.homepage      = ""
  spec.license       = "GPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ejt_command_line", "0.0.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'json', '~> 1.7.7'
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "rspec"
end
