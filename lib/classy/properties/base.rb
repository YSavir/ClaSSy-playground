module Classy
  module Property
    class Base
      attr_reader :value

      def initialize(selector)
        @selector = selector
      end
    end
  end
end
