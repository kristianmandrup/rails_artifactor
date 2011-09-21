module RailsAssist::Artifact
  module Asset
    module FileName
      DIR = RailsAssist::Artifact::Directory

      module Helper
        def type_from folder
          case folder.to_s
          when /javascript/
            :js
          when /style/
            :css
          else
            folder.to_s # raise ArgumentError, "Asset type could not be determined from #{folder}"
          end
        end

        def get_type type
          case type.to_s
          when 'coffee'
            'js.coffee'
          when 'scss'
            'css.scss'
          when 'sass'
            'css.sass'
          else
            type_from type
          end
        end

        def get_asset_type type
          raise "No type defined" if !type || type.empty?
          get_type(type)
        end

        def filename_type str
          str.split('.')[1..-1].join('.')
        end

        def filename_name str
          str.gsub /\.(.*)/, ''
        end
      end

      def asset_file_name *args
        folder, name, type = get_asset_args(args)
        options = last_option args
        root_path = options[:root_path]
        assets_path = options[:assets_path]
        assets_path ||= File.join(root_path, 'app/assets') if root_path
        File.expand_path File.join(assets_path || DIR.asset_dirpath, folder.to_s, "#{name}.#{type}")
      end

      def get_asset_args *args
        args = args.flatten
        raise ArgumentError, "asset_file_name must be called with one or more arguments to return a asset file" if args.size == 0
        case args.size
        when 1
          SingleArg.get_asset_args *args
        else
          TwoArgs.get_asset_args *args
        end
      end
    end

    module SingleArg
      def self.get_asset_args *args
        args = args.flatten
        arg = args.first
        case arg
        when Hash
          return HashArg.get_asset_args arg if arg.keys.size == 1
          HashArgs.get_asset_args *args
        when Symbol, String
          TwoArgs.get_asset_args *args
        end
      end

      module HashArg
        extend RailsAssist::Artifact::Asset::FileName::Helper

        def self.get_asset_args one_hash
          folder = one_hash.keys.first.to_s
          filename = one_hash.values.first.to_s
          name = filename_name filename
          type = get_asset_type(filename_type filename)
          [folder, name, type]
        end
      end

      module HashArgs
        extend RailsAssist::Artifact::Asset::FileName::Helper

        DIR = RailsAssist::Artifact::Directory

        # asset_file(:folder => 'javascripts', :name => 'hello', :type => :js).should == /assets\/javascripts\/hello\.js/
        def self.get_asset_args hash
          try_folder = hash.keys.first
          try_asset_folder = File.expand_path(File.join(DIR.asset_dir, try_folder.to_s))
          if File.directory? try_asset_folder
            folder = try_folder
            name = hash.values.first
          else
            folder = hash[:folder]
            name = hash[:name]
          end
          type = get_asset_type(hash[:type] || folder)
          [folder, name, type]
        end
      end

      module StringArg
        extend RailsAssist::Artifact::Asset::FileName::Helper

        # asset_file('stylesheets/localize').should == /assets\/stylesheets\/localize\.css/
        def self.get_asset_args string
          path_lvs = string.split('/')
          raise ArgumentError, "asset must be in a subfolder #{args}" if path_lvs.size < 2
          folder = path_lvs[0..-2].join('/')
          filename = path_lvs.last
          name = filename_name filename
          type = get_asset_type(filename_type filename)
          [folder, name, type]
        end
      end
    end

    module TwoArgs
      def self.get_asset_args *args
        args = args.flatten
        arg2 = args[1]
        res = case arg2
        when String, Symbol
          # asset_file(:stylesheets, :show).should == /assets\/stylesheets\/show\.css/
          TwoLabels.get_asset_args args
        when Hash
          # asset_file(:show, :folder => 'javascripts', :type => :js).should == /assets\/javascripts\/show\.js/
          NameAndHash.get_asset_args args
        end
      end

      module TwoLabels
        extend RailsAssist::Artifact::Asset::FileName::Helper

        # asset_file(:person, :show, :type => 'js').should == /assets\/person\/show\.js/
        def self.get_asset_args *args
          args = args.flatten
          folder = args.first.to_s
          action = args[1].to_s
          hash = args[2] if args.size > 2
          type = get_asset_type(hash[:type] || folder)
          [folder, action, type]
        end
     end

      module NameAndHash
        extend RailsAssist::Artifact::Asset::FileName::Helper

        def self.get_asset_args *args
          args = args.flatten
          action = args.first.to_s

          hash = args.last
          folder = hash[:folder]
          type = get_asset_type(hash[:type] || folder)

          [folder, action, type]
        end
      end
    end

    include FileName
    extend FileName
  end
end

