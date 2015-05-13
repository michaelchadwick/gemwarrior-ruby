# lib/gemwarrior/constants.rb
# List of constant values

module Gemwarrior
  PROGRAM_NAME = 'Gem Warrior'
  CHAR_UPPER_POOL = (65..90).map{ |i| i.chr }
  CHAR_LOWER_POOL = (97..122).map{ |i| i.chr }
  CHAR_LOWER_VOWEL_POOL = ['a','e','i','o','u','y']
  FACE_DESC  = ['smooth', 'tired', 'ruddy', 'moist', 'shocked']
  HANDS_DESC = ['worn', 'balled into fists', 'relaxed', 'cracked', 'tingly', 'mom\'s spaghetti']
  MOOD_DESC  = ['calm', 'excited', 'depressed', 'tense', 'lackadaisical', 'angry', 'positive']
  
  # player defaults
  PLAYER_LEVEL_DEFAULT = 1
  PLAYER_XP_DEFAULT = 0
  PLAYER_HP_CUR_DEFAULT = 10
  PLAYER_HP_MAX_DEFAULT = 10
  PLAYER_STAM_CUR_DEFAULT = 20
  PLAYER_STAM_MAX_DEFAULT = 20
  PLAYER_ATK_LO_DEFAULT = 1
  PLAYER_ATK_HI_DEFAULT = 2
  PLAYER_ROX_DEFAULT = 0

  # locations
  LOCATION_ID_HOME = 0
  LOCATION_NAME_HOME = 'Home'
  LOCATION_DESC_HOME = 'The little, unimportant, decrepit hut that you live in.'
  LOCATION_ID_CAVE = 1
  LOCATION_NAME_CAVE = 'Cave'
  LOCATION_DESC_CAVE = 'A nearby, dank cavern, filled with stacktites, stonemites, and rocksites.'
  LOCATION_ID_FOREST = 2
  LOCATION_NAME_FOREST = 'Forest'
  LOCATION_DESC_FOREST = 'Trees exist here, in droves.'
  LOCATION_ID_SKYTOWER = 3
  LOCATION_NAME_SKYTOWER = 'Emerald\'s Sky Tower'
  LOCATION_DESC_SKYTOWER = 'The craziest guy that ever existed is around here somewhere amongst the cloud floors, snow walls, and ethereal vibe.'

  # monsters
  MONSTER_ID_ALEXANDRAT = 0
  MONSTER_NAME_ALEXANDRAT = 'Alexandrat'
  MONSTER_DESC_ALEXANDRAT = 'Tiny, but fierce, color-changing rodent.'
  MONSTER_ID_AMBEROO = 1
  MONSTER_NAME_AMBEROO = 'Amberoo'
  MONSTER_DESC_AMBEROO = 'Fossilized and jumping around like an adorably dangerous threat from the past.'
  MONSTER_ID_AMETHYSTLE = 2
  MONSTER_NAME_AMETHYSTLE = 'Amethystle'
  MONSTER_DESC_AMETHYSTLE = 'Sober and contemplative, it moves with purplish tentacles swaying in the breeze.'
  MONSTER_ID_AQUAMARINE = 3
  MONSTER_NAME_AQUAMARINE = 'Aquamarine'
  MONSTER_DESC_AQUAMARINE = 'It is but one of the few, proud, and underwater assassins.'

  # items
  ITEM_ID_BED = 0
  ITEM_ID_STALACTITE = 1
  ITEM_ID_TREE = 2
  ITEM_ID_CLOUD = 3
end