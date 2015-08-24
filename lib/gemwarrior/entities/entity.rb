# lib/gemwarrior/entities/entity.rb
# Base class for a describable object

require_relative '../game_options'
require_relative '../misc/formatting'

module Gemwarrior
  class Entity
    attr_accessor :name,
                  :name_display,
                  :description,
                  :talkable

    attr_reader   :describe,
                  :describe_detailed

    def initialize
      self.name         = 'entity'
      self.name_display = Formatting::upstyle(name)
      self.description  = 'entity description'
      self.talkable     = false
    end

    def describe
      desc_text = "#{description}".colorize(:white)
    end

    def describe_detailed
      desc_text =  "\"#{name_display}\"\n".colorize(:yellow)
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}".colorize(:white)
    end

    def puts(s = '', width = GameOptions.data['wrap_width'])
      super s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n") unless s.nil?
    end
  end
end
