# lib/constants.rb

module Gemwarrior
  PROGRAM_NAME = "Gem Warrior"
  CHARUPPER_POOL = (65..90).map{ |i| i.chr }
  CHARLOWER_POOL = (97..122).map{ |i| i.chr }
  FACE_DESC  = ["smooth", "tired", "ruddy", "moist", "shocked"]
  HANDS_DESC = ["worn", "balled into fists", "relaxed", "cracked", "tingly", "mom's spaghetti"]
  MOOD_DESC  = ["calm", "excited", "depressed", "tense", "lackadaisical", "angry", "positive"]
end