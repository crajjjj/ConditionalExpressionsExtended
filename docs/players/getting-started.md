# Getting Started

## Requirements

| Type | Mod |
|------|-----|
| Required | [MFG Fix NG](https://www.nexusmods.com/skyrimspecialedition/mods/56767) |
| Required | [PapyrusUtil SE](https://www.nexusmods.com/skyrimspecialedition/mods/13048) |

Both are hard dependencies — CEE will not function without them. Everything else is optional and detected automatically at runtime (see [Requirements & Compatibility](compatibility.md)).

## Installation

1. Install MFG Fix NG and PapyrusUtil SE with your mod manager.
2. Install Conditional Expressions Extended.
3. If you previously used the original *Conditional Expressions - Subtle Face Animations*, let CEE **override** it. CEE is designed as a drop-in replacement.
4. Launch the game and let the MCM register (a notification appears when the mod has started).

!!! tip "Load order"
    If the MCM doesn't appear, move **Conditional Expressions.esp** higher in your load order. See [Troubleshooting](troubleshooting.md).

## Updating mid-game

Expression effects can be active on your character while you update. To update as safely as possible:

- Go **indoors**, or **disable cold expressions** in the MCM, before swapping versions.
- Avoid updating during a scene, dialogue, or combat.

This minimizes the chance of a facial state being "stuck" across the version change. CEE also re-initializes itself after a load to recover from stuck busy flags.

## First-time checklist

- [ ] MFG Fix NG installed
- [ ] PapyrusUtil SE installed
- [ ] CEE installed and overriding the original mod (if present)
- [ ] MCM **Conditional Expressions** page visible
- [ ] Walk around, sneak, swim, or take a hit and watch your character's face react

Once it's running, head to [Expressions & Conditions](expressions.md) to see everything CEE reacts to, or [MCM Reference](mcm-reference.md) to tune it.
