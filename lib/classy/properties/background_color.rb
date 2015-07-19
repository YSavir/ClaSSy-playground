module Classy
  module Property
    class BackgroundColor < Base

      def initialize(selector)
        @value = 'transparent'
        super
      end
    end
  end
end
