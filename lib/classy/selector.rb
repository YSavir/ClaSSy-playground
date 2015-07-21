module Classy
  class Selector
    attr_reader :parent, :selector_chain

    def initialize(selector_chain)
      @selector_chain = selector_chain.strip
    end

    def children
      @children ||= []
    end

    def add_content(declarations)
      @declarations = declarations
      parse unless declarations.empty?
    end

    def parse
      @declarations.map! do |raw_declaration|
        parse_declaration(raw_declaration)
      end
    end

    def parse_declaration(content)
      property, value = content.split(/(?<=[:])/).map(&:strip)
      Declaration.new self, property, value
    end

    def add_child(selector)
      children << selector
      selector.parent = self
    end

    def ancestors
      return [] unless @parent
      @ancestors ||= [parent] + parent.ancestors
    end

    def to_s
      string_array = [Classy::Formatter.indent(selector_chain, depth)]
      @declarations.each do |dec|
        string_array << dec.formatted
      end
      children.each do |child|
        string_array.push "", child.to_s
      end
      string_array << Classy::Formatter.indent("}", depth)
      string_array.join("\n")
    end

    def depth
      ancestors.length
    end

    protected

    attr_writer :parent

    private

    def add_prop(property)
      property_name = property.split('-').map(&:capitalize).join
      prop_object = constantize("Classy::Property::#{property_name}").new(self)
      instance_variable_set "@#{property_name.camelize}", prop_object
    end

    def content_indent_level
      @content_indent_level ||= depth + 1
    end

    def properties_and_values
      @properties_and_values ||= {}
    end
  end
end
