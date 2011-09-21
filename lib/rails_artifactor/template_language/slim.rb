module RailsAssist
  module TemplateLanguage
    class Slim < Base
      def insert_ruby_statement statement, options = {}
        "\n= #{statement}"
      end

      def insert_ruby_block statement, options = {}, &block
      end

      def insert_tag tag, css, options= {}, &block
      end
    end
  end
end
