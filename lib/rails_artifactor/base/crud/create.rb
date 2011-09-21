require 'rails_artifactor/ruby_mutator'

module RailsAssist::Artifact::CRUD
  module Create
    include RailsAssist::Artifact::Marker

    def create_artifact name, options={}, &block
      type = get_type(options)
      file = make_file_name(name, type)
      return nil if File.exist?(file) && options[:no_overwrite]

      create_artifact_dir(file)
      content = get_content(name, type, options, &block)

      superclass = options[:superclass] if options[:superclass]

      if superclass
        content.extend(RailsAssist::RubyMutator)
        content.remove_superclass
        content.inherit_from "#{superclass}_permit"
      end

      return if content.blank?

      File.overwrite file, content
    end

    protected

    def new_artifact_content name, options = {}, &block
      type = get_type(options)
      content = extract_content type, options, &block
      %Q{class #{marker(name, type)}
  #{content}
end}
    end

    def create_artifact_dir file
      # make dir
      dir = File.dirname(file)
      FileUtils.mkdir_p dir if !File.directory?(dir)
    end

    def content_method type
      method = :"new_#{type}_content"
      raise "Content method #{content_method} not found #{orm_notify}" if !respond_to?(method)
      method
    end

    def extract_content type, options, &block
      content = block ? yield : options[:content]
      content = type == :model ? options.merge(:content => content) : content
    end

    def get_content name, type, options = {}, &block
      content = extract_content type, options, &block
      method = content_method(type)
      options[:content] = content
      send method, name, options, &block 
    end
  end
end
