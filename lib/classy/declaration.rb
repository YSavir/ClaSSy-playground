module Classy
  class Declaration
    attr_reader :selector, :property

    def initialize(selector, property, operator, value)
      @property = property
      @selector = selector
      @operator = operator
      @value = value
    end

    def formatted
      Classy::Formatter.indent to_css, depth
    end

    def to_css
      "#{@property.dasherize}: #{@value};"
    end

    def to_stringified_block
      "@#{@property.underscore} #{@operator} \"#{@value}\""
    end

    private

    def self.from_unparsed_declaration(selector, unparsed_declaration)
      raw_property, value = unparsed_declaration.split(/(?<=[:])/).map(&:strip)
      property, operator = parse_property_and_operator(raw_property)
      new(selector, property, operator, value)
    end

    def self.from_property(selector, property)
      new(selector, property.name, '=', property.value) 
    end

    def self.parse_property_and_operator(raw_property)
      if raw_property.end_with? ':'
        return raw_property.chop, '='
      else
        return raw_property.split(' ').map(&:strip)
      end
    end

    def depth
      @depth ||= selector.depth + 1
    end
  end
end
