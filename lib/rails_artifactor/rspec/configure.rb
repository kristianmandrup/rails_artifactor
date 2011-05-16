require 'rspec'

RSpec.configure do |config|
  config.extend   RailsAssist::UseMacro
  config.include  RailsAssist::UseMacro
end