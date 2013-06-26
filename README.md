# ThinpXML

This gem contains a library and command line tool for manipulating the
XML format for thin provisioning metadata.

Convert thinp's binary format to/from xml using the _thin\_dump_ and
_thin\_restore_ tools in [thin-provisioning-tools][tpt]

[tpt]: https://github.com/jthornber/thin-provisioning-tools "Thin provisioning tools"

## Installation

Add this line to your application's Gemfile:

    gem 'thinp_xml'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thinp_xml

## Usage

    $ thinp_xml create --nr-thins 4 --nr-mappings 100 --block-size 512

When specifying numerical constants you may also give a random number distribution.

    uniform[<begin>..<end inclusive>]

    $ thinp_xml create --nr-thins uniform[4..9] --nr-mappings uniform[1000..10000] --block-size 1024


