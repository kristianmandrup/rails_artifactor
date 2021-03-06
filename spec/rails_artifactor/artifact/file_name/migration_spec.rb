require 'spec_helper'
require 'migration_assist'

CLASS = RailsAssist::Artifact::Migration

RailsAssist::Migration.orm = :active_record

class ArtDir
  include CLASS
end

describe RailsAssist::Artifact::Migration::FileName do
  # use_orm :active_record

  before do
    RailsAssist::Directory.rails_root = File.dirname (__FILE__)
    @test = ArtDir.new
  end

  describe '#migration_file_name' do
    it "should return the file name for migration" do      
      CLASS.migration_file_name(:create_persons).should match /create_persons/
    end
  end

  describe '#migration_file_name' do
    it "should return the file name for migration" do      
      CLASS.migration_file_name(:create_persons, :root_path => 'my_root').should match /my_root/
    end
  end
end

