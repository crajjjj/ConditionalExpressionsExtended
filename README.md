# ConditionalExpressionsExtended

This is a remastered extension of the Conditional Expressions - Subtle Face Animations mod (v 1.28) with new features and focus on compatibility
 
## What was changed?

What's New in CEE?  
  
NPC Support: Up to 16 nearby NPCs with relationship-based emotional logic  
Sunhelm Survival Integration: Cold shivers, food/alcohol detection  
Trauma Expressions: Pain animations for disease effects; optional sobbing sounds  
Dirt-based Sadness: Works with Dirt & Blood, Keep It Clean, Bathing in Skyrim  
Aroused Expressions: Based on arousal level; compatible with OSL Aroused  
Smooth Expression Transitions: Using native SKSE calls — no twitching  
Expression Cap (OSL-Aroused-aware): Limits visual exposure above arousal thresholds; MCM configurable  
Follower Hotkeys: Pause mod or register followers on the fly  
Localized MCM Menu  
Fully JSON-Driven Expressions: Define your own emotion presets  
Respect for Scene Events: Dhlp suspend/resume prevents facial glitches  
Animation Framework Compatibility  
Wearable-Friendly: Designed to work with helmets, masks, gags and more  
Code Overhaul: Faster, leaner – no random scripts or legacy checks  
 
## Hard dependencies

- MFG fix NG
- PapyrusUtil
 
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
Random Emotions - (patch available) can replace random expressions if patch is installed
SL Emotions - compatible
Ostim - compatible
Death Expressions (compatible)
PC Head Tracking (compatible - better to disable expressions in mcm)
Blush When Aroused - (compatible - patched version in downloads section in LL) -  CEExtended has built in aroused expressions support.
Devious Devices - (compatible) - gags are compatible
Toys framework - (compatible) - gags are compatible
SL animations (compatible) - sl faction check (osmel patch + additional checks) 
Expressive Facegen Morphs   (compatible)
Expressive Facial Animation (Male/Female)  (compatible)
Mods that use dhlp events (compatible) 

Dev notes:
Working with ability or constant effect is a pain in the ass
1) The effect restarts often if not blocked via external variable. If blocked - it exits immediately with oneffectfinish 
2) Doing internal immediate script checks results in freezing
3) If not blocked - occasionaly can restart in a separate instance
The only way to reliably work is via OnEffectFinish - basically treating effect as a one time trigger.