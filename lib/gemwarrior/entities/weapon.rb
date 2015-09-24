# lib/gemwarrior/entities/weapon.rb
# Entity::Item::Weapon base class

require_relative 'item'

module Gemwarrior
  class Weapon < Item
    attr_accessor :atk_lo,
                  :atk_hi,
                  :dex_mod,
                  :is_weapon

    def initialize
      super

      self.atk_lo       = 0
      self.atk_hi       = 0
      self.dex_mod      = 0
      self.takeable     = true
      self.equippable   = true
      self.is_weapon    = true
    end

    def use(world)
      'Save the brrandishing of your weapon for battle.'
    end

    def describe_detailed
      desc_text =  "\"#{name_display}\"\n".colorize(:yellow)
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)
      desc_text << "WEAPON?         #{is_weapon}\n".colorize(:white)
      desc_text << "ATTACK_RANGE  : #{atk_lo}-#{atk_hi}\n".colorize(:white)
      desc_text << "TAKEABLE?   #{takeable}\n".colorize(:white)
      desc_text << "USEABLE?    #{useable}\n".colorize(:white)
      desc_text << "TALKABLE?   #{talkable}\n".colorize(:white)
      desc_text << "CONSUMABLE? #{consumable}\n".colorize(:white)
      desc_text << "EQUIPPABLE? #{equippable}\n".colorize(:white)
      desc_text << "EQUIPPED?   #{equipped}\n".colorize(:white)
      desc_text << "USED?       #{used}\n".colorize(:white)
      desc_text << "USED AGAIN? #{used_again}\n".colorize(:white)
      desc_text << "USES LEFT?  #{number_of_uses}\n".colorize(:white) unless number_of_uses.nil?
      desc_text
    end
  end
end
