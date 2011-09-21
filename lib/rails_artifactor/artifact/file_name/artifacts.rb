# require 'migration_assist'
require 'rails_artifactor/base/file_name'

module RailsAssist::Artifact
  (RailsAssist.artifacts - [:migration, :view, :asset]).each do |name|
    class_eval %{
      module #{name.to_s.camelize}
        module FileName
          include RailsAssist::Artifact::FileName

          def #{name}_file_name name, options=nil
            artifact_path name, :#{name}, options
          end
        end

        extend FileName
        include FileName
      end
    }
  end
end  
