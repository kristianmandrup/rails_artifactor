module RailsAssist::Orm
  module ActiveRecord
    include RailsAssist::Orm::Base

    def orm_marker_name name, options=nil
      'ActiveRecord::Base'
    end

    def new_model_content name, options={}, &block
      content = block ? yield : options[:content]
      file_w_inherit(name, orm_marker_name(name, options)) { content }
    end
  end
end
