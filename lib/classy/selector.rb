module Classy
  class Selector
    attr_reader :parent, :selector_chain

    def initialize(selector_chain)
      @selector_chain = selector_chain.strip
      @declarations = []
    end

    def children
      @children ||= []
    end

    def add_content(new_declarations)
      new_declarations.each do |declaration|
        parse_and_add declaration
      end
    end

    def parse_declaration(content)
      Declaration.from_unparsed_declaration(self, content)
    end

    def add_child(selector)
      children << selector
      selector.parent = self
    end

    def ancestors
      return [] unless @parent
      @ancestors ||= [parent] + parent.ancestors
    end

    def to_css
      run_declarations
      string_array = [Classy::Formatter.indent(selector_chain, depth)]
      properties.each do |prop|
        value = instance_variable_get "@#{prop.name}"
        string_array << Declaration.new(self, prop.name, ':', value).formatted
      end
      children.each do |child|
        string_array.push "", child.to_css
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

    def run_declarations
      @declarations.each do |declaration|
        puts declaration.to_stringified_block
        instance_eval declaration.to_stringified_block
      end
      Pry.start binding
    end

    def add_prop(property_name)
      prop = Property.new_of_type(property_name, self)
      inst_var_name = "@#{prop.name.underscore}"
      unless instance_variable_defined? inst_var_name
        properties << prop
        set_instance_var inst_var_name, prop.value
      end
    end

    def parse_and_add declaration
      parsed_dec = parse_declaration declaration
      @declarations << parsed_dec
      add_prop parsed_dec.property
    end

    def properties
      @properties ||= []
    end

    def content_indent_level
      @content_indent_level ||= depth + 1
    end

    def properties_and_values
      @properties_and_values ||= {}
    end
    
    def set_instance_var(var_name, value)
      instance_variable_set var_name, value
    end
  end
end
