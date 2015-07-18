require 'pry'

module Classy; end

require_relative 'classy/selector'
require_relative 'classy/parsers/sheet'
require_relative 'classy/parsers/line'

CCSS_FILE = File.expand_path 'style.ccss'

parser = Classy::Parser::Sheet.new

parser.parse_file CCSS_FILE

