require 'require_all'
require 'rails_artifactor/namespaces'
require 'rails_artifactor/base/file_name'

describe RailsAssist::Artifact::FileName do
  describe '#make_file_name' do
    it "should ..." do
      pending "todo"
    end
  end

  describe '#existing_file_name' do
    it "should ..." do
      pending "todo"
    end
    
    RailsAssist.artifacts.each do |name|
      it "should find existing file for #{name}" do
        pending
      end
    end
  end
end
