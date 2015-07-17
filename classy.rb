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
        content = line.chop.strip
        broken_down_content = content.split ';'
        selector_chain = broken_down_content.pop
        new_selector = Selector.new(selector_chain)
        current_selector.parse broken_down_content if broken_down_content.any?
        if current_chain.empty?
          base_selectors << new_selector
        else
          current_selector.children << new_selector
        end
        current_chain << new_selector           
      elsif line.end_with? '}'
        content = line.chop.strip
        content = content.split ';'
        current_selector.parse content
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
    @selector_chain = selector_chain.strip
  end

  def children
    @children ||= []
  end

  def parse(attribute_pairs)
    attribute_pairs.map! do |pair|
      pair.split(/:/).map(&:strip)
    end.each do |pair|
      attributes[pair[0]] = pair[1]
    end
  end

  private

  def attributes
    @attributes ||= {}
  end
end

parser = Parser.new

parser.parse_file CCSS_FILE

