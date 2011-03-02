require 'migration_assist'

Rails3::Migration::Assist.rails_root_dir = RailsAssist::Directory.rails_root

module RailsAssist::Artifact
  module Migration
    include RailsAssist::BaseHelper    
    include Rails3::Migration::Assist::ClassMethods
    include RailsAssist::Artifact::FileName
  end
end