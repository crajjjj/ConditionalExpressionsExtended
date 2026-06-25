# Conditional Expressions Extended

**Dynamic facial animations and expressions for Skyrim SE, driven by what's actually happening to your character.**

Conditional Expressions Extended (CEE) is a remastered extension of *Conditional Expressions - Subtle Face Animations* (v1.28), rebuilt as a pure Papyrus system on top of **MFG Fix NG** for smooth, twitch-free facial blending. Your character — and nearby NPCs — react with appropriate expressions to cold, pain, fatigue, combat, intoxication, arousal, trauma, dirtiness, and more.

[Get Started](players/getting-started.md){ .md-button .md-button--primary }
[Requirements & Compatibility](players/compatibility.md){ .md-button }

---

## What's new in CEE?

- **NPC support** — up to 16 nearby NPCs with relationship-aware emotional logic.
- **Survival integration** — cold shivers, food/alcohol/drug detection (SunHelm and others).
- **Trauma expressions** — distress animations with optional sobbing/breathing sounds.
- **Dirt-based sadness** — works with Dirt & Blood, Keep It Clean, Bathing in Skyrim.
- **Aroused expressions** — gender-aware, arousal-driven; compatible with OSL/SexLab Aroused.
- **Smooth transitions** — native SKSE (MFG Fix NG) calls, no twitching.
- **Exposure cap** — limits visual arousal display above configurable thresholds.
- **Follower hotkeys** — pause the mod or register followers on the fly.
- **Fully JSON-driven** — define your own emotion presets without touching scripts.
- **Scene-aware** — honors `dhlp` suspend/resume so it won't fight animation frameworks.
- **Wearable-friendly** — designed around helmets, masks, and gags.
- **Localized MCM** — 13 languages.

## How it works at a glance

CEE applies a constant-effect ability to the player that polls game state every few seconds. Based on a fixed priority order, it picks the single most relevant emotion and renders it through MFG Fix NG. Expression *content* lives in editable JSON files, so the look of each emotion is data, not hard-coded.

| Audience | Start here |
|----------|------------|
| Players | [Getting Started](players/getting-started.md) → [Expressions & Conditions](players/expressions.md) → [MCM Reference](players/mcm-reference.md) |
| Mod authors | [Overview](authors/overview.md) → [Custom Expression JSON](authors/expression-json.md) → [Mod Events API](authors/modevents.md) |

!!! note "Hard requirements"
    [MFG Fix NG](https://www.nexusmods.com/skyrimspecialedition/mods/56767) and [PapyrusUtil SE](https://www.nexusmods.com/skyrimspecialedition/mods/13048) are required. See [Requirements & Compatibility](players/compatibility.md).
