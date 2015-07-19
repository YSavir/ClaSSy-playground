module Classy
  module Parser
    class Line

      def initialize(line)
        @line = line
        parse
      end

      def starts_block?
        @starts_block ||=  @line.end_with? '{'
      end

      def ends_block?
        @ends_block ||= @line.end_with? '}'
      end

      def selector_chain
        @selector_chain ||= @parsed_line[:selector_chain]
      end

      def content
        @content ||= @parsed_line[:content]
      end

      def parse
        content = @line.chop.strip.split ';'
        if ends_block?
          parse_without_selector content
        else
          parse_with_selector content
        end
      end

      def parse_with_selector(content)
        @parsed_line = {
          :selector_chain => content.pop,
          :content => content
        }
      end

      def parse_without_selector(content)
        @parsed_line = {
          :content => content
        }
      end
     
      def parsed
        @parsed_line ||= parsed
      end
    end
  end
end
