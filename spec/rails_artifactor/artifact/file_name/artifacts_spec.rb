require 'spec_helper'

CLASS = RailsAssist::Artifact::FileName

class ArtDir
  include CLASS
end

describe RailsAssist::Artifact::FileName do
  # use_helper :directories

  before do
    RailsAssist::Directory.rails_root = File.dirname (__FILE__)
    @test = ArtDir.new
  end

  (RailsAssist.artifacts - [:migration, :view]).each do |name|
    eval %{
      describe '##{name}_file_name' do
        it "should return the file name for #{name} using class method" do
          clazz = RailsAssist::Artifact::#{name.to_s.camelize}
          clazz.#{name}_file_name('user').should match /user/
        end

        it "should return the file name for #{name} using instance method" do
          art = ArtDir.new
          art.extend RailsAssist::Artifact::#{name.to_s.camelize}
          art.#{name}_file_name('user').should match /user/
        end
      end
    }
  end
end