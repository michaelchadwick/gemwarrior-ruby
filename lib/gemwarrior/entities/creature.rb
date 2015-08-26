# lib/gemwarrior/entities/creature.rb
# Entity::Creature base class

require_relative 'entity'

module Gemwarrior
  class Creature < Entity
    attr_accessor :face,
                  :hands,
                  :mood,
                  :level,
                  :xp,
                  :hp_cur,
                  :hp_max,
                  :atk_lo,
                  :atk_hi,
                  :defense,
                  :dexterity,
                  :inventory,
                  :rox

    attr_reader   :use,
                  :speak

    def initialize
      super

      self.name         = 'creature'
      self.name_display = Formatting::upstyle(name)
      self.description  = 'A creature.'
      self.face       = 'face-y'
      self.hands      = 'handsy'
      self.mood       = 'moody'
      self.level      = 1
      self.xp         = 0
      self.hp_cur     = 10
      self.hp_max     = 10
      self.atk_lo     = 1
      self.atk_hi     = 1
      self.defense    = 1
      self.dexterity  = 1
      self.inventory  = Inventory.new
      self.rox        = 0
      self.talkable   = true
      self.used       = false
    end

    def use(world)
      'That creature does not seem to want to talk to you right now.'
    end

    def describe
      desc_text = "#{description}".colorize(:white)
      desc_text << "\n"
      desc_text << "The creature has several distinguishing features, as well: face is #{face}, hands are #{hands}, and mood is, generally, #{mood}."
      desc_text
    end

    def describe_detailed
      desc_text =  "\"#{name_display}\"\n".colorize(:yellow)
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)
      desc_text << "FACE      : #{face}\n".colorize(:white)
      desc_text << "HANDS     : #{hands}\n".colorize(:white)
      desc_text << "MOOD      : #{mood}\n".colorize(:white)
      desc_text << "LEVEL     : #{level}\n".colorize(:white)
      desc_text << "XP        : #{xp}\n".colorize(:white)
      desc_text << "HP        : #{hp_cur}/#{hp_max}\n".colorize(:white)
      desc_text << "ATK_RANGE : #{atk_lo}-#{atk_hi}\n".colorize(:white)
      desc_text << "DEFENSE   : #{defense}\n".colorize(:white)
      desc_text << "DEXTERITY : #{dexterity}\n".colorize(:white)
      desc_text << "ROX       : #{rox}\n".colorize(:white)
      desc_text << "INVENTORY : #{inventory.list_contents}\n".colorize(:white)
      desc_text
    end
    
    def speak(s, no_end_quote = false, no_line_feed = false)
      text =  ">> \"#{s}"
      text += "\"" unless no_end_quote
      text += "\n" unless no_line_feed
      text = text.colorize(:yellow)
      if no_line_feed
        print text
      else
        print text.gsub(/(.{1,#{GameOptions.data['wrap_width']}})(\s+|\Z)/, "\\1\n")
      end
    end
  end
end
