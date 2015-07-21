module Classy
  module Formatter

    def self.selector_chain(selector)
      indent(selector.selector_chain, selector.depth)
    end

    def self.indent(content, depth)
      content.prepend(tab * depth) 
    end

    private

    def self.tab
      " " * indent_level
    end

    def self.indent_level
      2
    end

  end
end
