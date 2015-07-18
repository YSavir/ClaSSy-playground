require 'pry'

module Classy; end

require_relative 'classy/selector'
require_relative 'classy/parsers/sheet'
require_relative 'classy/parsers/line'

CCSS_FILE = File.expand_path 'style'

parser = Classy::Parser::Sheet.new CCSS_FILE

parser.parse_file
parser.output_to_file

