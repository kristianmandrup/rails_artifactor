module RailsAssist::Artifact
  module Asset
    include RailsAssist::BaseHelper
    include RailsAssist::Artifact::CRUD

    def has_asset? name, *args, &block
      file_name = asset_file_name(name, args)
      file_name.path.file?
    end

    def has_assets? *args, &block
      options = last_option args
      args.to_strings.each do |name|
        return false if !has_asset? name, options
      end
      true
    end

    def asset_file *args
      asset_file_name(args)
    end

    # CREATE
    def create_asset *args, &block
      file_name = asset_file_name(args)
      dir = File.dirname(file_name)
      FileUtils.mkdir_p dir if !File.directory?(dir)

      content = get_asset_content(args) || yield if block

      # abort if no content given
      debug "Warning: Content must be passed in either as a :content hash or a block" if !content
      return nil if !content

      debug "Writing asset file: #{file_name}"
      # write file content of asset
      File.open(file_name, 'w') do |f|
        f.puts content
      end
    end

    # READ
    def read_asset *args, &block
      file_name = asset_file_name(args)
      debug "reading from: #{file_name}"
      begin
        file = File.new(file_name)
        content = file.read
        debug "read content: #{content}"
        yield content if block
        content
      rescue
        nil
      end
    end

    # UPDATE
    def insert_into_asset *args, &block
      begin
        file_name = asset_file_name(args)
        options = last_option args
        raise ArgumentError, ":before or :after option must be specified for insertion" if !(options[:before] || options[:after])
        File.insert_into file_name, options, &block
        true
      rescue
        nil
      end
    end

    # DELETE
    def remove_asset *args
      file = asset_file_name(args)
      FileUtils.rm_f(file) if File.exist?(file)
    end

    # remove_assets :edit, :show, :folder => :javascripts
    def remove_assets *args
      options = last_option args
      raise ArgumentError, "Missing :folder option in the last argument which must be a Hash" if !options && !options[:folder]
      args.to_symbols.each{|name| remove_asset name, options}
    end

    [:javascript, :coffeescript, :stylesheet].each do |type|
      class_eval %{
        def create_#{type}_asset *args, &block
          options = last_option args
          args.last = options.merge :folder => :#{type}
          create_asset *args, &block
        end

        def read_#{type}_asset *args, &block
          options = last_option args
          args.last = options.merge :folder => :#{type}
          read_asset *args, &block
        end

        def remove_#{type}_asset *args, &block
          options = last_option args
          args.last = options.merge :folder => :#{type}
          remove_asset *args, &block
        end

        def remove_#{type}_assets *args
          remove_assets *args, :folder => :#{type.to_s.pluralize}
        end
      }
    end

    def get_asset_content args
      args = args.flatten
      case args.first
      when Hash
        args.first[:content]
      end
    end

    multi_aliases_for :asset
  end
end

