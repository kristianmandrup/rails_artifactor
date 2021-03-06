require 'rails_assist/artifact'

module RailsAssist::Artifact
  module FileName
    include RailsAssist::Artifact::Directory
    include RailsAssist::Artifact::Path

    def make_file_name name, type, options={}
      send :"#{type}_file_name", name, options
    end

    def existing_file_name name, type=nil, options = {}
      # first try finder method
      finder_method = :"find_#{type}"
      if respond_to?(finder_method)
        result = send finder_method, name, options
        if !result.kind_of? String
          raise IOError, "The call to #find_#{type}(#{name}) didn't find an existing #{type} file. Error in find expression: #{result.find_expr}"
        end
        return result
      elsif type == :migration
        raise StandardError, "The method #find_#{type} to find the migration is not available!"
      end

      # default for non-migration
      file_name = make_file_name name, type, options
      raise IOError, "No file for :#{type} found at location: #{file_name}" if !File.file?(file_name)
      file_name
    end

    RailsAssist.artifacts.each do |name|
      class_eval %{
        def existing_#{name}_file name, type=nil, options = {}
          existing_file_name name, type, options
        end
      }
    end
  end  # file_name

  include FileName
end
