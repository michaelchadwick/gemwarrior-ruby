# lib/gemwarrior/entities/entity.rb
# Base class for an interactable object

module Gemwarrior
  class Entity
    attr_reader :id, :name, :description
    
    def initialize(options)
      self.id           = options[:id]
      self.name         = options[:name]
      self.description  = options[:description]
    end
    
    def status
      status_text =  name.ljust(20).upcase
      status_text << "#{description}\n"
      status_text.to_s
    end
  end
end
