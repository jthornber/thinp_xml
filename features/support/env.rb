ENV['RUBYLIB'] = "#{Dir.pwd}"
ENV['PATH'] = "#{Dir::pwd}:#{ENV['PATH']}"

require 'thinp_xml'
require 'aruba/cucumber'
