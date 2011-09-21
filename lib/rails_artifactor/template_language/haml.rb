module RailsAssist
  module TemplateLanguage
    class Haml < Base
      def insert_ruby_statement statement, options = {}
        "\n= #{statement}"
      end
      def insert_ruby_block statement, options = {}, &block
        # get indentation of previous line
        %Q{"<%= #{statement} %>"
#{yield}
<% end %>
}
      end

      def insert_tag tag, options= {}, &block
        attributes = options[:attributes]
        atr_atr = "{#{format attributes}}" if attributes
        %Q{"%#{tag}#{atr_atr}"
#{yield}
<#{tag}/>
}
      end

      protected

      def format attributes
        attributes.map{|key, value| ":#{key} => \"#{value}\""}        
      end
    end
  end
end
