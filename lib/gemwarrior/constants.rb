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
  PLYR_DESC_DEFAULT = 'Picked to do battle against a wizened madman for a shiny something or other for world-saving purposes, you\'re actually fairly able, as long as you\'ve had breakfast first.'
  PLYR_LEVEL_DEFAULT = 1
  PLYR_XP_DEFAULT = 0
  PLYR_HP_CUR_DEFAULT = 10
  PLYR_HP_MAX_DEFAULT = 10
  PLYR_STAM_CUR_DEFAULT = 20
  PLYR_STAM_MAX_DEFAULT = 20
  PLYR_ATK_LO_DEFAULT = 1
  PLYR_ATK_HI_DEFAULT = 2
  PLYR_ROX_DEFAULT = 0

  # locations
  LOC_ID_HOME = 0
  LOC_NAME_HOME = 'Home'
  LOC_DESC_HOME = 'The little, unimportant, decrepit hut that you live in.'
  LOC_ID_CAVE = 1
  LOC_NAME_CAVE = 'Cave'
  LOC_DESC_CAVE = 'A nearby, dank cavern, filled with stacktites, stonemites, and rocksites.'
  LOC_ID_FOREST = 2
  LOC_NAME_FOREST = 'Forest'
  LOC_DESC_FOREST = 'Trees exist here, in droves.'
  LOC_ID_SKYTOWER = 3
  LOC_NAME_SKYTOWER = 'Emerald\'s Sky Tower'
  LOC_DESC_SKYTOWER = 'The craziest guy that ever existed is around here somewhere amongst the cloud floors, snow walls, and ethereal vibe.'

  # monsters
  MOB_ID_ALEXANDRAT = 0
  MOB_NAME_ALEXANDRAT = 'Alexandrat'
  MOB_DESC_ALEXANDRAT = 'Tiny, but fierce, color-changing rodent.'
  MOB_ID_AMBEROO = 1
  MOB_NAME_AMBEROO = 'Amberoo'
  MOB_DESC_AMBEROO = 'Fossilized and jumping around like an adorably dangerous threat from the past.'
  MOB_ID_AMETHYSTLE = 2
  MOB_NAME_AMETHYSTLE = 'Amethystle'
  MOB_DESC_AMETHYSTLE = 'Sober and contemplative, it moves with purplish tentacles swaying in the breeze.'
  MOB_ID_AQUAMARINE = 3
  MOB_NAME_AQUAMARINE = 'Aquamarine'
  MOB_DESC_AQUAMARINE = 'It is but one of the few, proud, and underwater assassins.'

  # items
  ITEM_ID_BED = 0
  ITEM_ID_STALACTITE = 1
  ITEM_ID_TREE = 2
  ITEM_ID_CLOUD = 3
end