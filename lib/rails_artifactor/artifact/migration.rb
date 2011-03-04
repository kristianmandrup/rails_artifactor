require 'migration_assist'

RailsAssist::Migration.rails_root_dir = RailsAssist::Directory.rails_root

module RailsAssist::Artifact
  module Migration
    include RailsAssist::BaseHelper    
    include RailsAssist::Migration::ClassMethods
    include RailsAssist::Artifact::FileName
  end
end