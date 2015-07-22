module Classy
  module Property
    class Base
      attr_accessor :value

      @@default = nil

      class << self
        attr_accessor :default
      end

      def initialize(selector)
        @selector = selector
      end

      def name
        self.class.name.demodulize.underscore
      end

      def value
        @value || @@default
      end
    end
  end
end
