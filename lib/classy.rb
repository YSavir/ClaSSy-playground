require 'pry'

module Classy; end

require_relative 'classy/selector'
require_relative 'classy/parsers/sheet'
require_relative 'classy/parsers/line'
require_relative 'classy/property'
require_relative 'classy/properties/base'
require_relative 'classy/properties/height'
require_relative 'classy/properties/width'
require_relative 'classy/properties/background_color'

require 'active_support/inflector'
include ActiveSupport::Inflector

CCSS_FILE = File.expand_path 'style'

parser = Classy::Parser::Sheet.new CCSS_FILE

parser.parse_file
parser.output_to_file

