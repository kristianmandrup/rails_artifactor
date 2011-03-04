require 'rspec'
require 'rails_artifactor'
require 'rails_artifactor/rspec'
require 'code-spec'
require 'fixtures'

RSpec.configure do |config|
  config.mock_with :mocha
end
