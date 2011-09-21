require 'spec_helper'

describe 'asset API - symbols' do
  use_helpers :asset

  before :each do
    RailsAssist::Directory.rails_root = fixtures_dir

    remove_asset :javascript, :edit if has_asset? :account, :edit
    create_asset :javascript, :edit do
      "edit me"
    end

    create_asset :javascript, :show do
      "show me"
    end
  end

  after :each do
    remove_view :account
  end

  context "Non-existant view(s)" do

    it "should read application layouts view" do
      asset_file_name(:javascripts => :edit).should match /edit/
      read_asset(:javascripts => :edit).should match /edit me/
      read_asset(:javascripts => :show).should match /show me/
    end

    it "should not fail trying to remove non-existant views" do
      remove_assets :edit, :show, :folder => :javascripts
      remove_artifacts :asset, :edit, :show, :folder => :javascripts

      remove_asset :javascripts => :show
      remove_artifact :asset, :show, :folder => :javascripts
    end

    it "should not find a non-existant asset" do
      asset_file :show, :folder => :javascripts do |person|
        fail "should not find asset show!"
      end

      has_asset?(:show, :folder => :javascripts).should be_false
      has_assets?(:show, :edit, :folder => :javascripts).should be_false
    end

    it "should not read from non-existant view" do
      read_asset :javascripts => :show do |content|
        fail "should not find person content!"
      end.should_not be_true
    end
  end
end


