require 'rspec/core'
require 'rails_artifactor/macro'

RSpec.configure do |config|
  config.extend   RailsAssist::UseMacro
  config.include  RailsAssist::UseMacro
end