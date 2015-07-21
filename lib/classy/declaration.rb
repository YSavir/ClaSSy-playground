module Classy
  class Declaration
    attr_reader :selector

    def initialize(selector, raw_property, value)
      @selector = selector
      @value = value
      parse_raw_property(raw_property)
    end

    def formatted
      Classy::Formatter.indent to_s, depth
    end

    def to_s
      case @operator
      when "="
        "#{@property}: #{@value}"
      else
        [@property, @operator, @value].join(' ')
      end
    end

    private

    def parse_raw_property(raw_property)
      if raw_property.end_with? ':'
        @property = raw_property.chop
        @operator = "="
      else
        @property, @operator = raw_property.split(' ').map(&:strip)
      end
    end

    def depth
      @depth ||= selector.depth + 1
    end
  end
end
