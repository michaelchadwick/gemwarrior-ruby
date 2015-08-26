# lib/gemwarrior/entities/entity.rb
# Base class for a describable object

require_relative '../game_options'
require_relative '../misc/formatting'
require_relative '../misc/animation'

module Gemwarrior
  class Entity
    attr_accessor :name,
                  :name_display,
                  :description,
                  :takeable,
                  :useable,
                  :useable_battle,
                  :talkable,
                  :consumable,
                  :equippable,
                  :equipped,
                  :used,
                  :number_of_uses

    attr_reader   :describe,
                  :describe_detailed,
                  :display_shopping_cart

    def initialize
      self.name           = 'entity'
      self.name_display   = Formatting::upstyle(name)
      self.description    = 'An entity.'
      self.useable        = true
      self.useable_battle = false
      self.talkable       = false
      self.consumable     = false
      self.takeable       = true
      self.equippable     = false
      self.equipped       = false
      self.used           = false
      self.number_of_uses = nil
    end

    def use(world)
      'That does not appear to be useable.'
    end

    def describe
      desc_text = "#{description}".colorize(:white)
    end

    def describe_detailed
      desc_text =  "\"#{name_display}\"\n".colorize(:yellow)
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)
      desc_text << "TAKEABLE?   #{takeable}\n".colorize(:white)
      desc_text << "USEABLE?    #{useable}\n".colorize(:white)
      desc_text << "TALKABLE?   #{talkable}\n".colorize(:white)
      desc_text << "CONSUMABLE? #{consumable}\n".colorize(:white)
      desc_text << "EQUIPPABLE? #{equippable}\n".colorize(:white)
      desc_text << "EQUIPPED?   #{equipped}\n".colorize(:white)
      desc_text << "USED?       #{used}\n".colorize(:white)
      desc_text << "USES LEFT?  #{number_of_uses}\n".colorize(:white) unless number_of_uses.nil?
      desc_text
    end

    def display_shopping_cart(cart)
      puts "ITEMS SELECTED: #{cart.map(&:name).join(', ')}"
    end

    def puts(s = '', width = GameOptions.data['wrap_width'])
      super s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n") unless s.nil?
    end
  end
end
