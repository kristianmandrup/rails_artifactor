module RailsAssist
  module TemplateLanguage
    class Erb < Base
      def insert_ruby_statement statement, options = {}
        "<%= #{statement} %>"
      end
      
      def insert_ruby_block statement, options = {}, &block
        %Q{"<%= #{statement} %>"
#{yield}
<% end %>
}
        # insert_content options
      end      

      def insert_tag tag, attributes, options= {}, &block
        %Q{"<#{tag} #{attributes}>"
#{yield}
<#{tag}/>
}
      end            
    end
  end
end