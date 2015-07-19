module Classy
  module Property
    class Width < Base

      def initialize(selector)
        @value = 'auto' 
        super
      end

    end
  end
end
