require 'pry'
CCSS_FILE = './style.ccss'

NEW_SELECTOR_MATCHER = /(\s*\w+\s*)+{/

class Parser

  def parse_file(file)
    lines = File.readlines file
    lines.each do |line|
      if line.match NEW_SELECTOR_MATCHER
        selectors.push Selector.new(line)
      end
    end
    Pry.start binding
  end

  private

  attr_writer :current_selector

  def current_selector
    @current_selector ||= nil
  end

  def selectors
    @selectors ||= []
  end

end

class Selector

  def initialize(selector_chain)
    selector_words = selector_chain.strip.scan /\S+/
    @selector_chain = selector_words.first selector_words.index("{")
  end
end

parser = Parser.new

parser.parse_file CCSS_FILE

