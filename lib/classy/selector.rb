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
      @declarations.map do |declaration|
        parse_content(declaration)
      end.each do |dec|
        add_prop dec.keys.first
        properties_and_values.merge! dec
      end
    end

    def parse_content(content)
      property, value = content.split /:/
      {
        property.strip => value.strip,
      }
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
      string_array = ["#{selector_chain} {".prepend(" " * selector_indent_level)]
      properties_and_values.each do |property, value|
        string_array << "#{property}: #{value};".prepend(" " * content_indent_level)
      end
      children.each do |child|
        string_array.push "", child.to_s
      end
      string_array << "}".prepend(" " * selector_indent_level)
      string_array.join("\n")
    end

    protected

    attr_writer :parent

    private

    def add_prop(property)
      property_name = property.split('-').map(&:capitalize).join
      prop_object = constantize("Classy::Property::#{property_name}").new(self)
      instance_variable_set "@#{property_name.camelize}", prop_object
    end

    def depth
      ancestors.length
    end

    def selector_indent_level
      @selector_intend_level ||= depth * 2
    end

    def content_indent_level
      @content_indent_level ||= selector_indent_level + 2
    end

    def properties_and_values
      @properties_and_values ||= {}
    end
  end
end
