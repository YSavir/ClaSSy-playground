module Classy
  module Parser
    class Sheet

      NEW_SELECTOR_MATCHER = /(\s*\w+\s*)+{/

      SELECTOR_CONTENT_MATCHER = /{.*/m

      def initialize(file_name)
        @file_name = file_name
      end

      def parse_file

        @lines = File.read "#{@file_name}.ccss"
        break_up_lines
        @lines.map! { |line| Classy::Parser::Line.new line }

        @lines.each do |line|
          if line.starts_block?
            new_selector = Selector.new line.selector_chain
             
            if current_chain.empty?
              base_selectors << new_selector
            else
              current_selector.add_content(line.content)
              current_selector.add_child(new_selector)
            end
            current_chain << new_selector           
          elsif line.ends_block?
            current_selector.add_content line.content
            current_chain.pop
          end
        end
      end

      def output_to_file
        text_array = base_selectors.map { |selector| selector.to_s }

        file = File.open "#{@file_name}.css", 'w'
        file.write text_array.join("\n\n")
        file.close
      end

      private

      attr_writer :current_selector

      def break_up_lines
        @lines = @lines.split(/(?<=[{}])/)
                       .reject(&:empty?)
                       .map(&:strip)
      end

      def current_selector
        @current_selector ||= nil
      end

      def current_chain
        @current_chain ||= []
      end

      def base_selectors
        @base_selectors ||= []
      end

      def current_selector
        @current_chain.last
      end

    end
  end
end
