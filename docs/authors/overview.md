# Overview (for mod authors)

CEE is a pure Papyrus system built on **MFG Fix NG** (facial morphing) and **PapyrusUtil** (JSON loading). This section is for modders who want to add expression presets, integrate via mod events, or build from source.

## Architecture in brief

```
onPlayerLoadGame  ->  StartMod()  ->  discover optional mods, load JSON profiles,
                                       apply constant-effect ability to the player
                                              |
                                              v
            CondiExp_Fatigue1 (constant-effect spell on the player)
                                              |
            each emotion is an ActiveMagicEffect gated by CK conditions
                                              |
                  picks the single highest-priority matching emotion
                                              |
                  renders via MFG Fix NG (MfgConsoleFuncExt smooth setters)
```

The main quest script (`CondiExp_StartMod`) runs a `RegisterForSingleUpdate` poll loop that updates status globals (cold, trauma, dirty, aroused). The per-emotion `ActiveMagicEffect` scripts read those globals (via Creation Kit conditions) and apply the matching expression.

## Key building blocks

| Piece | Role |
|-------|------|
| `CondiExp_StartMod` | Initialization, status polling, suspension logic |
| `CondiExp_PCTracking` | Equip/food/gag detection, load-game handling |
| `CondiExp_BaseExpression` | Loads JSON presets, selects gender/phase, applies presets |
| `CondiExp_Expression_Util` | Facial animation helpers (emotions, breathing, eating) |
| `CondiExp_Followers` | NPC expression system (up to 16 actors) |
| `CondiExp_util` | MFG wrappers, dependency checks, cleanup |

## Expression data is editable

The *content* of each emotion lives in JSON under `SKSE/Plugins/CondiExp/Expression_<name>.json` and is loaded with PapyrusUtil. You can edit the bundled profiles or ship your own without recompiling anything — see [Custom Expression JSON](expression-json.md).

## Integration surface

- **Mod events** — CEE listens for `dhlp-Suspend/Resume`, `ostim_start/end`, and `CondiExp_SLAEvent`, and emits `CondiExp_SLAEvent`. See [Mod Events API](modevents.md).
- **Status globals** — `Condiexp_CurrentlyCold/Trauma/Dirty/Aroused`, `Condiexp_ModSuspended`, and the `Condiexp_Min*` thresholds are global variables you can read or override.
