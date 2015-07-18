module Classy
  class Selector

    def initialize(selector_chain)
      @selector_chain = selector_chain.strip
    end

    def children
      @children ||= []
    end

    def add_content(content)
      parse content unless content.empty?
    end

    def parse(line_contents)
      line_contents.map! do |pair|
        pair.split(/:/).map(&:strip)
      end.each do |pair|
        attributes[pair[0]] = pair[1]
      end
    end

    def parse_content(content)
      content.split(/:/).map(&:strip)
    end

    def add_child(selector)
      children << selector
    end

    private

    def attributes
      @attributes ||= {}
    end
  end
end
