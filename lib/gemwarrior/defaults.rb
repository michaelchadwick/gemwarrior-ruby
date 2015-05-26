# lib/gemwarrior/defaults.rb
# List of default values for world entities

module Gemwarrior
  module Entities
    module Monsters
      MOB_ID_ALEXANDRAT         = 0
      MOB_NAME_ALEXANDRAT       = 'alexandrat'
      MOB_DESC_ALEXANDRAT       = 'Tiny, but fierce, color-changing rodent.'
      MOB_LEVEL_ALEXANDRAT      = 1
      MOB_BATTLECRY_ALEXANDRAT  = 'Bitey, bitey!'
      
      MOB_ID_AMBEROO            = 1
      MOB_NAME_AMBEROO          = 'amberoo'
      MOB_DESC_AMBEROO          = 'Fossilized and jumping around like an adorably dangerous threat from the past.'
      MOB_LEVEL_AMBEROO         = 1
      MOB_BATTLECRY_AMBEROO     = 'I\'m hoppin\' mad!'
      
      MOB_ID_AMETHYSTLE         = 2
      MOB_NAME_AMETHYSTLE       = 'amethystle'
      MOB_DESC_AMETHYSTLE       = 'Sober and contemplative, it moves with purplish tentacles swaying in the breeze.'
      MOB_LEVEL_AMETHYSTLE      = 2
      MOB_BATTLECRY_AMETHYSTLE  = 'You\'ve found yourself in quite the thorny issue!'
      
      MOB_ID_AQUAMARINE         = 3
      MOB_NAME_AQUAMARINE       = 'aquamarine'
      MOB_DESC_AQUAMARINE       = 'It is but one of the few, the proud, the underwater.'
      MOB_LEVEL_AQUAMARINE      = 3
      MOB_BATTLECRY_AQUAMARINE  = 'Attention! You are about to get smashed!'
      
      MOB_ID_APATIGER           = 4
      MOB_NAME_APATIGER         = 'apatiger'
      MOB_DESC_APATIGER         = 'Apathetic about most everything as it lazes around, save for eating you.'
      MOB_LEVEL_APATIGER        = 4
      MOB_BATTLECRY_APATIGER    = 'Gggggggggrrrrrrrrrrrrrrrrooooooooooowwwwwwwwwwwwlllllllll!'
      
      MOB_ID_BLOODSTORM         = 5
      MOB_NAME_BLOODSTORM       = 'bloodstorm'
      MOB_DESC_BLOODSTORM       = 'A literal swirling, maniacal vortex of human hemoglobin.'
      MOB_LEVEL_BLOODSTORM      = 5
      MOB_BATTLECRY_BLOODSTORM  = '/swirls'
      
      MOB_ID_CITRINAGA          = 6
      MOB_NAME_CITRINAGA        = 'citrinaga'
      MOB_DESC_CITRINAGA        = 'Refreshing in its shiny, gleaming effectiveness at ending your life.'
      MOB_LEVEL_CITRINAGA       = 4
      MOB_BATTLECRY_CITRINAGA   = 'Slice and dice so nice!'
      
      MOB_ID_CORALIZ            = 7
      MOB_NAME_CORALIZ          = 'coraliz'
      MOB_DESC_CORALIZ          = 'Small blue lizard that slithers around, nipping at your ankles.'
      MOB_LEVEL_CORALIZ         = 3
      MOB_BATTLECRY_CORALIZ     = 'Where am I? You\'ll never guess!'
      
      MOB_ID_CUBICAT            = 8
      MOB_NAME_CUBICAT          = 'cubicat'
      MOB_DESC_CUBICAT          = 'Perfectly geometrically cubed feline, fresh from its woven enclosure, claws at the ready.'
      MOB_LEVEL_CUBICAT         = 4
      MOB_BATTLECRY_CUBICAT     = 'I don\'t really care, as long as you die!'
      
      MOB_ID_DIAMAN             = 9
      MOB_NAME_DIAMAN           = 'diaman'
      MOB_DESC_DIAMAN           = 'Crystalline structure in the form of a man, lumbering toward you, with outstretched, edged pincers.'
      MOB_LEVEL_DIAMAN          = 6
      MOB_BATTLECRY_DIAMAN      = 'Precious human, prepare to be lost to the annals of time!'
    end

    module Items
      ITEM_ID_STONE = 0
      ITEM_NAME_STONE = 'stone'
      ITEM_DESC_STONE = 'A small, sharp mega pebble, suitable for tossing in amusement, and perhaps combat.'
      ITEM_ID_BED = 1
      ITEM_NAME_BED = 'bed'
      ITEM_DESC_BED = 'The place where you sleep when you\'re not adventuring.'
      ITEM_ID_STALACTITE = 2
      ITEM_NAME_STALACTITE = 'stalactite'
      ITEM_DESC_STALACTITE = 'Long protrusion of cave adornment, broken off and fallen to the ground, where the stalagmites sneer at it from.'
      ITEM_ID_FEATHER = 3
      ITEM_NAME_FEATHER = 'feather'
      ITEM_DESC_FEATHER = 'Soft and tender, unlike the craven bird that probably shed it.'
      ITEM_ID_GUN = 4
      ITEM_NAME_GUN = 'gun'
      ITEM_DESC_GUN = 'Pew pew goes this firearm, you suspect.'
    end

    module Locations
      LOC_ID_HOME = 0
      LOC_NAME_HOME = 'Home'
      LOC_DESC_HOME = 'The little, unimportant, decrepit hut that you live in.'
      LOC_CONNECTIONS_HOME = {:north => 4, :east => 1, :south => nil, :west => 3}
    
      LOC_ID_CAVE_ENTRANCE = 1
      LOC_NAME_CAVE_ENTRANCE = 'Cave (Entrance)'
      LOC_DESC_CAVE_ENTRANCE = 'A nearby, dank cavern\'s entrance, surely filled with stacktites, stonemites, and rocksites.'
      LOC_CONNECTIONS_CAVE_ENTRANCE = {:north => nil, :east => 2, :south => nil, :west => 0}
      
      LOC_ID_CAVE_ROOM1 = 2
      LOC_NAME_CAVE_ROOM1 = 'Cave (Room1)'
      LOC_DESC_CAVE_ROOM1 = 'Now inside the first cavernous room, you confirm that there are stacktites, stonemites, rocksites, and even one or two pebblejites.'
      LOC_CONNECTIONS_CAVE_ROOM1 = {:north => nil, :east => nil, :south => nil, :west => 1}
  
      LOC_ID_FOREST = 3
      LOC_NAME_FOREST = 'Forest'
      LOC_DESC_FOREST = 'Trees exist here, in droves.'
      LOC_CONNECTIONS_FOREST = {:north => nil, :east => 0, :south => nil, :west => nil}
  
      LOC_ID_SKYTOWER = 4
      LOC_NAME_SKYTOWER = 'Emerald\'s Sky Tower'
      LOC_DESC_SKYTOWER = 'The craziest guy that ever existed is around here somewhere amongst the cloud floors, snow walls, and ethereal vibe.'
      LOC_CONNECTIONS_SKYTOWER = {:north => nil, :east => nil, :south => 0, :west => nil}
    end
  end
end
