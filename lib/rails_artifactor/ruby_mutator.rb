module RailsAssist
  module RubyMutator
    def remove_superclass
      self.gsub! /(class\s+\w+\s*)<\s*(\w|::)+/, '\1'
    end
  
    def inherit_from superclass
      self.gsub! /(class\s+(\w|::)+)/, '\1' + " < #{superclass.to_s.camelize}\n"
    end
  end
end
