# lib/gemwarrior/entities/entity.rb
# Base class for an interactable object

module Gemwarrior
  class Entity
    attr_accessor :name,
                  :description

    def status
      status_text =  name.ljust(26).upcase.colorize(:green)
      status_text << "#{description}\n".colorize(:white)
    end
  end
end
