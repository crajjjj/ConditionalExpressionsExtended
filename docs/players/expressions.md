# Expressions & Conditions

CEE polls your character's state on a timer and renders the **single most relevant** emotion. Conditions are checked top-to-bottom in a fixed priority order — the first one that matches wins, so higher entries override lower ones.

## Priority order

| # | Condition | Reaction |
|---|-----------|----------|
| 1 | Sleeping | Blink / close eyes |
| 2 | Pain (Health < 50%) | Pain expression |
| 3 | Combat anger | Angry expression (in combat, healthy) |
| 4 | Fatigue (low stamina) | Breathing animation |
| 5 | Drunk / Skooma | Multi-phase intoxication expressions |
| 6 | Eating | Chewing animation |
| 7 | Cold | Shivering |
| 8 | Trauma | Distress expression + optional sobbing sounds |
| 9 | Dirty | Sadness expression |
| 10 | Aroused | Arousal expression (gender-aware) |
| 11 | Swimming | Breathing |
| 12 | Sneaking | Squint |
| 13 | No clothes | Embarrassment |
| 14 | Random | Relationship-aware or random emotion |

Because the list is ordered, e.g. taking heavy damage (Pain) will override a Cold shiver, and being in combat overrides arousal.

## Emotion sources

- **Pain** triggers on low health and on active diseases.
- **Trauma** comes from Apropos2 abuse state or the ZaZ slave faction.
- **Dirty** comes from your bathing mod's dirtiness/bloodiness stages, plus SexLab cum detection.
- **Aroused** comes from OSL/SexLab Aroused arousal level, above a configurable threshold.
- **Cold** comes from your survival mod (Frostfall/Frostbite/SunHelm) or vanilla snow.

## Arousal modifiers

Several conditions reduce arousal rather than showing their own face — they nudge the arousal value used by aroused expressions. These are tuned on the **Aroused Modifiers** MCM page:

- Rain (when outdoors)
- Low health (strong pain)
- Low magicka (headache, < 30%)
- Swimming

## NPC expressions

The follower system tracks up to **16 nearby NPCs**, each running its own update loop:

- NPCs follow the same emotion priority as the player (minus the wearable/gag check differences).
- **Relationship-aware random expressions:** friendly NPCs lean toward smiles and happiness, hostile NPCs toward anger/frown/disgust, neutral NPCs toward puzzled/thinking/looking around.
- **Dead NPCs** get a death expression (random blink/squint/brow) before being cleared.
- NPCs beyond ~1024 units are counted down and removed.

## Sounds

Optional sobbing/breathing sounds during trauma use race/gender-specific sound sets (Khajiit, Orc, and default voices for each gender). Toggle them on the **Settings** MCM page.
