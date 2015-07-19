module Classy
  module Property
    class Height < Base

      def initialize(selector)
        @value = 'auto' 
        super
      end

    end
  end
end
