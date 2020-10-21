**Gem Warrior** is a text adventure that takes place in the land of **Jool**, where randomized fortune is just as likely as *mayhem*.

You take up the mantle of **1.upto(rand(5..10)) {print rand(65..90).chr}**, a gifted young acolyte who has been tasked by the queen herself, **Ruby**, to venture off into the unknown to recapture a **Shiny Thing<sup>tm</sup>** that holds great power within its crystallized boundaries. Unfortunately, it was stolen recently by a crazed madperson named **Emerald**, bent on using its frightening power for **Evil**. You are **Good**, obviously, and the rightful caretaker of such power, but he will not give it up willingly, and has cursed all the creatures of the land into doing his bidding, which is largely tearing you limb from limb.

Start in your poor, super lame cottage, where you live alone, subsisting off the sale of polished rocks you scavenge all day for in the neighboring caves. Once tasked with your quest, travel throughout the land of Jool, eventually reaching the sky tower that Emerald resides in with his stolen goods, laughing to himself, occasionally.

As you travel you will discover sights and sounds of the land, all of which are new to you because you don't really get out much. Visit towns with merchants willing to trade coin for wares they bought off of other adventurers who didn't last the previous attempts at thwartion. Sleep in a tent (or on the ground, if that's all that's available) to regain your enumerated status points, which are conveniently located in your peripheral vision (i.e. the console window). Eventually, if you're skilled, you'll reach **Emerald's Sky Tower**, part him from his **ShinyThing<sup>tm</sup>**, and then do what is "right".

## How to Get to Jool

1. `ruby -v` should return `ruby 2.something`; else install [Ruby](https://www.ruby-lang.org)
2. `gem -v` should return `2.something`; else install [RubyGems](https://rubygems.org)
2. `(sudo) gem install gemwarrior`  
3. `gemwarrior`

Run the commands above and you'll be whisked away to Jool, ready to start or continue your quest to defeat Emerald and take back the coveted Shiny Thing(tm) that you will bring back to Queen Ruby (or will you...?).

## Main Commands

`> character`             - character check for visual identity  
`> inventory [object]`    - check your inventory (or an individual item within)  
`> rest`                  - take a load off and replenish hp  
`> look      [object]`    - look at current location and its items and monsters  
`> take      [object]`    - take an item from a location  
`> use       [object]`    - use an item from your inventory or current location  
`> drop      [object]`    - drop an item from your inventory  
`> equip     [object]`    - designate an item in your inventory your weapon  
`> unequip   [object]`    - stop using an item in your inventory as your weapon  
`> go        [direction]` - go in a direction, if possible (north|east|south|west work as shortcuts)  
`> attack    [monster]`   - attack a monster  
`> change    [attribute]` - change some things about yourself  
`> help`                  - display available commands  
`> version`               - display current game version  
`> quit`                  - quit this nonsense w/ prompt  
`> quit!`                 - quit this nonsense w/o prompt  
