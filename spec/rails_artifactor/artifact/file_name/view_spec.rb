require 'spec_helper'

CLASS = RailsAssist::Artifact::View

class ArtDir
  include CLASS
end

describe RailsAssist::Artifact::View::FileName do
  # use_orm :active_record

  before do
    RailsAssist::Directory.rails_root = File.dirname (__FILE__)
    @test = ArtDir.new
  end

  describe '#view_file_name' do
    it "should return the file name for the persons/show view with default action" do      
      CLASS.view_file_name(:person, :show).should match 'views/person/show'.to_regexp
    end

    it "should return the file name for the persons/show view with template type" do      
      CLASS.view_file_name(:person, :show, :type => :erb).should match 'views/person/show'.to_regexp
    end
    
    it "should return the file name for the persons/show view using hash" do      
      CLASS.view_file_name(:folder => :person, :action => :show, :type => 'erb.hml').should match 'views/person/show'.to_regexp
    end
    
    it "should return the file name for the persons/show view with root path" do      
      CLASS.view_file_name(:folder => :person, :action => :show, :type => :erb, :root_path => RailsAssist::Directory.rails_root).should match 'views/person/show'.to_regexp
    end        

    it "should return the file name for the persons/show view with root path" do      
      CLASS.view_file_name(:folder => :person, :action => :show, :type => :erb, :views_path => 'my/views').should match 'views/person/show'.to_regexp
    end        
  end
end
