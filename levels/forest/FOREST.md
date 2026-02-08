LEVEL

- theme: save the forest
- people live in forest
- enemy is destroying forest
- must defeat enemies that are destroying the forest

ELEMENTS

- slime
- wisp
  - gives magic missile spell
- campfire
  - gives fire spell
- fisherman
  - using hand spell to catch fish
  - gives hand spell: grab something and move it (like telekinesis)
- farmhouse
- spellbook that allows you to swap out a spell
  - has a cooldown

BEATS

- get magic missile spell
- go fishing
- dark forest area that requires fire spell for light
- player defeats boss
- player gets into locked room via one-way secret entrance. gains magic missile. opens door to many enemies.

QUESTIONS

- Why would you want to enter the dark forest?
- Where do you get the spellbook?
  - A resident rewards you after helping them
- How is the room locked?
  - Space blocked by objects: hay bales, farm machinery
- Where are the animals in the farmhouse?
  - Locked in stables/safe areas
- How does sneaking work?
  - Break line of sight
- How does the player get a wand?
  - NPC gives it to them (they don't know what to do with it)
- How do show that an npc has something to say?
  - Exclamation point speech bubble next to them
- Should the game be beatable with only magic missile?
  - Yes
- How does the boss spawn?
  - Kill 100 slimes, 100th slime revives and merges all slimes in the forest
  - Different color slime spawns in random open area, surrounded by other slimes
- How to do quick player movements?
  - Flick stick (gamepad), Douple tap direction (kbm)
  - Short dash + decaying high movement speed

SEQUENCE

- START player enters the forest

- player sees 3 paths
  - stack of hay bales blocking portal to another zone
  - short path to farmhouse
  - long path to pond

## Portal

- player destroys/moves hay bales blocking portal
  - using fire spell
  - using hand spell

## Pond

- path to pond is long and filled with enemies
- at the end of the path there is a lake/pond/whatever
- fisherman is catching fish using 'hand' spell (telekinesis)
- player can attack fish basket
- attacking the basket enough causes fisherman to use hand spell on player to stop them, but also grants them hand spell
- helping the fisherman gather fish will make them start the campfire to cook the fish
- campfire can give player fire spell

## Farmhouse

- player enters farmhouse
- enemies spread around farmhouse
- there is an area of farmhouse not populated by enemies where player can move around a part of the perimeter and see other parts of first floor
- player sees area with wisp
- wisp is blocked by hay bales and farm machinery

- player moves to 2nd floor of farmhouse
- 2nd floor is dark
- there are thieves with lanterns (lantern light is round but show which direction they are looking since it is slightly offset from actor model)
- player moves past theives without being seen
- player pushes box to reveal small hidden area
- hidden area has a hole
- hole leads to area with wisp

- player points wand at wisp
- wisp moves to wand tip and gives player magic missile ability
- magic missile can destroy hay bales
- player then kills enemies on the way out of farmhouse

- player leaves farmhouse and kills all enemies in the farm land
- farmer asks if player can help others in the forest (add other ppl later like fisherman)

- player encounters a large yellow slime
- yellow slime
  - doesn't aggro towards player until attacked
  - turns into a weapon:
    - floating dagger
      - follows player movement
      - vibrates when about to attack
      - flys at player in fast straight line
      - gets stuck in ground
      - after a second, turns back into slime
    - bouncing bomb
      - bounces in random direction
      - explodes after delay and shoots slime droplets into the air towards random spots (does damage)
      - combines all puddles into yellow slime after delay
    - avoids player (moves around quickly but keeps distance from player)
    - every yellow slime turns into a weapon again after X seconds
    - slime dropping below 1/2 hp splits it:
      - 1 large
      - 2 medium
      - 3 small
  - killing the last yellow slime, defeats it for good

- GOAL player leaves forest via a portal
