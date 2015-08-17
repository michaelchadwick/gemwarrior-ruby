# lib/gemwarrior/entities/entity.rb
# Base class for an interactable object

require_relative '../game_options'

module Gemwarrior
  class Entity
    attr_accessor :name, :description

    def status
      status_text =  name.ljust(26).upcase.colorize(:green)
      status_text << "#{description}\n".colorize(:white)
    end

    def puts(s = '', width = GameOptions.data['wrap_width'])
      super s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n") unless s.nil?
    end
  end
end
