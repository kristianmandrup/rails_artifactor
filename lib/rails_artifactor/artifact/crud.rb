require 'sugar-high/file'
require_all File.dirname(__FILE__) + '/crud'

module RailsAssist::Artifact
  (RailsAssist.artifacts - [:model]).each do |name|
    class_eval %{
      module #{name.to_s.camelize}
        def new_#{name}_content name, content=nil, options = {}, &block
          options = options.merge(:type => :#{name}, :content => content)
          new_artifact_content name, options, &block
        end
      end
    }
  end

  RailsAssist.artifacts.each do |name|
    plural_name = name.to_s.pluralize
    class_eval %{
      module #{name.to_s.camelize}
        include RailsAssist::BaseHelper
        
        def self.included base
          base.class_eval do              
            include RailsAssist::Artifact::CRUD        
          end
        end
                
        multi_aliases_for :#{name}            
      end
    }
  end    
end
