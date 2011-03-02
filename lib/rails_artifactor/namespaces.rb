require 'rails_assist'

module RailsAssist
  module Artifact
    modules :crud
    modules RailsAssist.artifacts do
      nested_modules :file_name
    end
  end
end
