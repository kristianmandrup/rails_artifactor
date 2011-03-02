require 'active_support/inflector'

module RailsAssist::Orm
  module None
    include RailsAssist::Orm::Base

    def orm_marker_name name, options=nil
      name.to_s.camelize
    end

    def new_model_content name, options={}, &block        
      content = block ? yield : options[:content]
      simple_file(name, orm_marker_name(name, options)) { content }
    end
  end
end
