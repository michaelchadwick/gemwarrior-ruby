```
/-+-+-+ +-+-+-+-+-+-+-\
|G|E|M| |W|A|R|R|I|O|R|
\-+-+-+ +-+-+-+-+-+-+-/
```
<small>logo courtesy of [ascii generator](http://www.network-science.de/ascii/)</small>

**Gem Warrior** is a text adventure that takes place in the land of **Jool**, where randomized fortune is just as likely as *mayhem*.

You take up the mantle of **1.upto(rand(5..10)) {print rand(65..90).chr}**, a gifted young acolyte who has been tasked by the queen herself, **Ruby**, to venture off into the unknown to recapture a **Shiny Thing<sup>tm</sup>** that holds great power within its crystallized boundaries. Unfortunately, it was stolen recently by a crazed madperson named **Emerald**, bent on using its frightening power for **Evil**. You are **Good**, obviously, and the rightful caretaker of such power, but he will not give it up willingly, and has cursed all the creatures of the land into doing his bidding, which is largely tearing you limb from limb.

Start in your poor, super lame cottage, where you live alone, subsisting off the sale of polished rocks you scavenge all day for in the neighboring caves. Once tasked with your quest, travel throughout the land of Jool, eventually reaching the sky tower that Emerald resides in with his stolen goods, laughing to himself, occasionally.

As you travel you will discover sights and sounds of the land, all of which are new to you because you don't really get out much. Visit towns with merchants willing to trade coin for wares they bought off of other adventurers who didn't last the previous attempts at thwartion. Sleep in makeshift huts to regain your health and magic points (or the ground, if that's all that's available), which are conveniently located in your peripheral vision (i.e. the console window). Eventually, if you're skilled (and I actually code it in), you'll reach **Emerald's Sky Tower**, part him from his **ShinyThing<sup>tm</sup>**, and then do what is "right".

## How to Get to Jool

1. `gem install gemwarrior`  
2. `gemwarrior`

Run the two commands above and you'll be whisked away to Jool, ready to start or continue your quest to defeat Emerald and take back the coveted Shiny Thing(tm) that you will bring back to Queen Ruby (or will you...?).

## In Progress, Yanno

This is in super-hyper-turbo-edition pre-pre-pre-alpha right now, but a working console prompt, some commands (type `h` for a list), and a few locations exist already. Each time you start the game a new hero will be created with a randomized name, but you can change that with `> change name`.

`> c` - character check for visual identity  
`> i [object]` - check your inventory (or an individual item within)  
`> r` - take a load off  
`> l [object]` - look at current location and items  
`> t [object]` - take an item from a location  
`> g [direction]` - go in a direction, if possible  
`> w` - list all the locations available in the world  
`> m` - list all the monsters available in the world  
`> ch [attribute]` - change some things about yourself  
`> q` - quit this nonsense  

To come:

* ~~Ability to move between locations!~~
* More locations to move between!
* Monsters!
* Ability to fight those monsters!
* ~~Items you can pick up!~~
* Quests!
* Towns!
* Merchants!
* Sound FX!
* Music!
* Epic Length (whereby "Epic" I mean "maybe 30 minutes"?)!
