require 'pry'
CCSS_FILE = './style.ccss'


class Parser

  NEW_SELECTOR_MATCHER = /(\s*\w+\s*)+{/

  SELECTOR_CONTENT_MATCHER = /{.*/m

  def parse_file(file)
    data = File.read file
    lines = data.split(/(?<=[{}])/)
            .reject(&:empty?)
            .map(&:strip)
    lines.each do |line|
      if line.end_with? '{'
        selector_chain = line.chop.strip
        new_selector = Selector.new(selector_chain)
        if current_chain.empty?
          base_selectors << new_selector
        else
          current_selector.children << new_selector
        end
        current_chain << new_selector           
      elsif line.end_with? '}'
        current_chain.pop
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

  def current_chain
    @current_chain ||= []
  end

  def base_selectors
    @base_selectors ||= []
  end

  def current_selector
    @current_chain.last
  end

end

class Selector

  def initialize(selector_chain)
    @selector_chain = selector_chain
  end

  def children
    @children ||= []
  end
end

parser = Parser.new

parser.parse_file CCSS_FILE

