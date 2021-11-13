# ConditionalExpressionsExtended

This is a refactor and extension to the Conditional Expressions - Subtle Face Animations mod https://www.nexusmods.com/skyrimspecialedition/mods/45148

What was changed?
- SL compatibility is builtin via sl factions (osmelmc patch).
- Dhlp suspend/resume events are respected. Mod is paused till respective scenarious are finished. No more face twitching.
- Added abuse (pain) expressions based on apropos2 w&t or ZAP slave faction condition. Expression is different depending on abuse stage. There's a chance also for a sobbing sound. (can be disabled in mcm)
- Added sad expressions based on dirtiness level (Dirt&Blood || Keep it clean || Bathing in Skyrim are supported)
- Code refactoring - random script is no longer used for condition checking.

Hard dependencies
- Mfg Fix https://www.nexusmods.com/skyrimspecialedition/mods/11669
- Sexlab 

Soft dependencies
- Apropos 2 or slavery mods that support zbfFactionSlave from ZaZAnimationPack.esm
- Dirt&Blood || Keep it clean || Bathing in Skyrim 


Installation
- Original mod is not needed
- Install as any other mod