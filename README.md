# ConditionalExpressionsExtended

This is a remastered extension of the Conditional Expressions - Subtle Face Animations mod (v 1.27) with new features and focus on compatibility
 
## What was changed?

- Added followers support (Up to 10 followers)
- Added SunhelmSurvival support for cold expressions
- Added trauma (pain) expressions for diseases. There's a chance also for a sobbing sound. (can be disabled in mcm)
- Added sad expressions based on dirtiness level (Dirt&Blood || Keep it clean || Bathing in Skyrim are supported)
- Added aroused expressions based on arousal level (OSL Aroused)
- Smoother exression changes
- Code refactored - random script is no longer used for condition checking. Cold scripts simplified.
- SL compatibility is built-in via sl factions (osmelmc patch).
- Ostim compatibility via events
- Compatibility with DD and Toys wearables.
- Dhlp suspend/resume events are respected. Mod is paused till respective scenarios are finished. No more face twitching. E.g. compatible with "The Trappings of Fate" mod.
- Compatibility with apropos2 w&t or ZAP slave faction condition for trauma expressions
- Added arousal cap feature with different conditions.Examples - if it's raining arousal capped by 50
 
## Hard dependencies

- Conditional Expressions - Subtle Face Animations
 
## Installation

- Override original mod (Conditional Expressions - Subtle Face Animations) mod with this one
- For midgame update be cautious - go inside or disable cold expressions before updating.

### Advanced config (not recommended):

In console:  set [global variable name] [amount]

Sample: set Condiexp_MinAroused 30

- Condiexp_MinTrauma range 1-10 default 1
- Condiexp_MinAroused range 0-100 default 30
- Condiexp_MinDirty range 0-4 default 1

- Condiexp_TraumaZBFFactionEnabled default 1 - to disable trauma on slave faction set to 0

(range values not inclusive - e.g. setting Condiexp_MinDirty to 4 will disable feature)


# Frequently Asked Questions

### MCM is not showing up; how do I enable it?

Move Conditional Expressions.esp higher in the load order. You can also try using [Jaxonz MCM Kicker SE](https://www.nexusmods.com/skyrimspecialedition/mods/36801?tab=description) 

### Can I use this with X mod? 

All animation mods should be compatible. Only mods that might cause issues are those that change the players facial expressions, which there shouldn't be many.

Details:  
Random Emotions - (incompatible) similar feature with random expressions is included
SL Emotions - compatible
Ostim - compatible
Death Expressions (compatible)
PC Head Tracking (compatible - better to disable expressions in mcm)
Blush When Aroused - (compatible - patched version in downloads section) -  CEExtended has built in aroused expressions support.
Devious Devices - (compatible) - gags are compatible
Toys framework - (compatible) - gags are compatible
SL animations (compatible) - sl faction check (osmel patch + additional checks) 
Expressive Facegen Morphs   (compatible)
Expressive Facial Animation (Male/Female)  (compatible)
Mods that use dhlp events (compatible) 
