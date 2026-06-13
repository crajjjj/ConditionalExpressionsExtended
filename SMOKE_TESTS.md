# Conditional Expressions Extended -- AI Smoke Tests

Pre-release checklist. Each scenario should be verified in-game or by code inspection before tagging a release.

**Priority key:** P0 = blocker, P1 = high, P2 = medium

---

## 1. Initialization & Game Load

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 1.1 | P0 | Fresh install -- new save, no prior CEE data | `OnInit` fires, `_checkPlugins` defers to 2nd tick, `StartMod()` runs: optional mods discovered, expressions loaded, spell applied, events registered | CondiExp_StartMod, CondiExp_PCTracking |
| 1.2 | P0 | Existing save -- reload with active expressions | `onPlayerLoadGame` -> `init()` re-discovers mods, `NewRace()` updates sounds, `RegisterForSingleUpdate(5)` resumes polling | CondiExp_PCTracking |
| 1.3 | P1 | Missing MFG Fix NG plugin | `MfgConsoleFuncExt` calls fail gracefully, no hard crash. Expressions simply don't apply | CondiExp_util |
| 1.4 | P1 | Missing PapyrusUtil dependency | `JsonUtil` calls fail, `ImportJson()` returns false, `Enabled = false` for all expressions, mod runs but no JSON expressions applied | CondiExp_BaseExpression |
| 1.5 | P1 | Loading Menu close with stuck busy flags | `OnMenuClose("Loading Menu")` detects `CurrentlyBusy > 0`, triggers `StopMod/StartMod` cycle to reset | CondiExp_PCTracking |
| 1.6 | P2 | `_checkPlugins` re-entrancy | Counter increments from 1 to 2 before `StartMod()` fires; second `OnUpdate` before counter reaches 2 just increments and returns | CondiExp_StartMod |

## 2. Main Polling Loop

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 2.1 | P0 | Normal update tick -- no conditions active | All status globals set to 0, no expression applied, re-registers for next update | CondiExp_StartMod |
| 2.2 | P0 | Menu mode active (Utility.IsInMenuMode) | `shouldDeferPollingBasic` returns true, update deferred with 3s retry | CondiExp_StartMod, CondiExp_util |
| 2.3 | P1 | Player in dialogue | `isInDialogue` returns true via `MfgConsoleFuncExt.GetPlayerSpeechTarget()`, mod suspends, MFG cleaned up | CondiExp_StartMod |
| 2.4 | P1 | Update interval set to 0 | Spell present but interval 0 -> no `RegisterForSingleUpdate` after update -> polling stops. Resume by setting interval > 0 via MCM/console | CondiExp_StartMod |
| 2.5 | P2 | PlayerRef is None | Early return with 5s retry, no crash | CondiExp_StartMod |

## 3. Suspension System

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 3.1 | P0 | dhlp-Suspend event received | `Condiexp_SuspendedByDhlpEvent = 1`, `Condiexp_ModSuspended = 1`, expressions paused | CondiExp_StartMod |
| 3.2 | P0 | dhlp-Resume event received | `Condiexp_SuspendedByDhlpEvent = 0`, mod resumes if no other suspension conditions | CondiExp_StartMod |
| 3.3 | P0 | OStim scene start/end | `ostim_start` maps to dhlp-Suspend, `ostim_end` maps to dhlp-Resume -- expressions paused during scene | CondiExp_StartMod |
| 3.4 | P1 | SexLab animating faction active | `IsActorActive(sexlab, act)` returns true, mod suspends for that actor | CondiExp_StartMod |
| 3.5 | P1 | Hotkey pause toggle | `Condiexp_SuspendedByKey` toggles 0/1, notification shown, mod suspends/resumes | CondiExp_StartMod |
| 3.6 | P1 | Gag equipped (DD/ZaZ/Toys/SLS) | `checkIfModShouldBeSuspendedByWearables` returns true, mod suspended for player; `checkMouthWearable` returns true, phonemes suppressed for NPC | CondiExp_PCTracking, CondiExp_StartMod |
| 3.7 | P2 | Multiple suspension sources active, one cleared | Mod stays suspended until ALL sources cleared (dhlp, key, wearable, SL, dialogue) | CondiExp_StartMod |

## 4. Cold Expressions

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 4.1 | P0 | Frostfall cold (method 1) | `Temp.GetValueInt() > 2` -> cold status 1, shiver expression applied | CondiExp_StartMod, CondiExp_Cold_Script |
| 4.2 | P0 | Frostbite/SunHelm cold (methods 2-3) | `HasSpell(Cold1/Cold2/Cold3)` checked, chilly/cold/freezing mapped to status 1 with different arousal modifiers | CondiExp_StartMod |
| 4.3 | P1 | Vanilla cold (method 4) | Non-vampire + exterior + snow weather classification (3) -> cold | CondiExp_StartMod |
| 4.4 | P1 | Auto-detect cold method (method 5) | `resolveAutoColdMethod` probes Frostfall -> Frostbite -> SunHelm -> Vanilla in order, sets permanent method | CondiExp_StartMod |
| 4.5 | P2 | Cold override active | `coldOverride = true` -> always returns cold 1, other overrides force cold to 0 | CondiExp_StartMod |
| 4.6 | P2 | Vampire in snow (vanilla method) | `HasKeyword(Vampire)` -> cold status 0, no shiver | CondiExp_StartMod |

## 5. Trauma Expressions

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 5.1 | P0 | Apropos2 abuse state > threshold | `GetWearState0to10` returns trauma level, expression applied via `traumaExpr.Apply` | CondiExp_StartMod, CondiExp_TraumaScript |
| 5.2 | P1 | High trauma (>= 6) blocks arousal | `OnCondiExpSLAEvent` fires with `arousalTraumaMajor` cap, arousal suppressed | CondiExp_StartMod |
| 5.3 | P1 | ZaZ slave faction active | `zbfFactionSlave` check returns trauma 5, expression applied | CondiExp_StartMod |
| 5.4 | P1 | Trauma sounds play correctly | Sound set matches player race/gender (6 variants), volume scales with trauma intensity | CondiExp_TraumaScript |
| 5.5 | P2 | Apropos2 not installed | `ActorsQuest` is None, ZaZ faction checked as fallback, no script errors | CondiExp_StartMod |
| 5.6 | P2 | `Condiexp_TraumaZBFFactionEnabled` set to 0 | ZaZ faction check skipped even if faction exists | CondiExp_StartMod |

## 6. Dirty/Sadness Expressions

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 6.1 | P0 | Dirt & Blood dirtiness stage 3+ | MagicEffect detected, dirty status 2-3, sadness expression applied | CondiExp_StartMod, Condiexp_Dirty |
| 6.2 | P1 | SexLab cum overlay (oral) | `IsPlayerCumsoakedOral` returns true, dirty = 3 | CondiExp_StartMod, CondiExp_Interface_SL |
| 6.3 | P1 | SexLab cum overlay (vaginal/anal) | `IsPlayerCumsoakedVagOrAnal` returns true, dirty = 2 | CondiExp_StartMod, CondiExp_Interface_SL |
| 6.4 | P1 | Bathing in Skyrim / BIS Renewed / Keep It Clean | Correct MagicEffect forms resolved from each ESP, dirtiness stages mapped correctly | CondiExp_StartMod, CondiExp_util |
| 6.5 | P2 | No bathing mod installed | `LoadedBathMod = "None Found"`, only SL cum detection active for dirty status | CondiExp_StartMod |
| 6.6 | P2 | Dirty level below threshold | `dirty > 0 && dirty > Condiexp_MinDirty` fails, returns 0, no expression | CondiExp_StartMod |

## 7. Arousal Expressions

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 7.1 | P0 | SLA arousal above threshold | `getArousal0To100` returns value > `Condiexp_MinAroused`, arousal expression applied | CondiExp_StartMod, CondiExp_ArousedScript |
| 7.2 | P1 | Arousal phase escalation | Low arousal (< 50): phases 1-3, medium (50-80): phases 1-5, high (> 80): phases 1-7 | CondiExp_Expression_Util |
| 7.3 | P1 | Arousal 30% random skip | `RandomInt(1, 10) <= 3` -> expression skipped, logged as "Effect: skip" | CondiExp_Expression_Util |
| 7.4 | P2 | SLA not installed | `sla` is None, arousal status always 0, no script errors | CondiExp_StartMod |
| 7.5 | P2 | Arousal override active | `arousalOverride = true` -> returns 99, other overrides force arousal to 0 | CondiExp_StartMod |

## 8. Arousal Modifiers System

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 8.1 | P1 | Rain suppresses arousal | Exterior + weather classification 2 -> `OnCondiExpSLAEvent` with rain threshold/cap | CondiExp_StartMod |
| 8.2 | P1 | Low health suppresses arousal | Health < 50% -> pain arousal modifier applied | CondiExp_StartMod |
| 8.3 | P1 | Low magicka suppresses arousal | Magicka < 30% -> headache arousal modifier applied | CondiExp_StartMod |
| 8.4 | P1 | Swimming suppresses arousal | `IsSwimming()` -> swim arousal modifier applied | CondiExp_StartMod |
| 8.5 | P2 | Arousal modifiers disabled in MCM | `Condiexp_GlobalArousalModifiers = 0` -> `isSendArousalEventsEnabled` returns false, events ignored | CondiExp_StartMod |
| 8.6 | P2 | Modifier notifications toggle | `Condiexp_GlobalArousalModifiersNotifications = 1` -> player sees notification text | CondiExp_StartMod |

## 9. Pain & Disease Expressions

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 9.1 | P1 | Disease active (any of 7 types + trap variants) | `HasSpell` check for Ataxia/BoneBreak/BrainRot/Rattles/Rockjoint/Sanguinare/Witbane -> pain expression | CondiExp_PainScript |
| 9.2 | P1 | Health < 50% in follower loop | Pain expression played, arousal modifier sent if SLA active | CondiExp_Followers |
| 9.3 | P2 | Multiple diseases active | Only one pain expression plays (first match), not stacked | CondiExp_PainScript |

## 10. Intoxication Expressions

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 10.1 | P1 | Alcohol consumed | `CondiExp_PlayerIsDrunk = 1`, drunk expression plays 3-phase sequence (happy/sloppy -> dazed -> smirk), MFG reset after | CondiExp_Drunk_Script, CondiExp_Expression_Util |
| 10.2 | P1 | Skooma consumed | `CondiExp_PlayerIsHigh = 1`, skooma expression plays 3-phase sequence (euphoria -> dissociation -> paranoia) | CondieExp_Skooma_Script, CondiExp_Expression_Util |
| 10.3 | P2 | SunHelm alcohol keyword detection | `_SH_AlcoholDrinkKeyword` triggers drunk status independently of formlist | CondiExp_PCTracking |
| 10.4 | P2 | Drug/drink flags reset after expression | Flags cleared after animation completes, ready for next consumption | CondiExp_Drunk_Script, CondieExp_Skooma_Script |

## 11. Eating Expressions

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 11.1 | P1 | Food consumed (VendorItemFood keyword) | `CondiExp_PlayerJustAte = 1`, eating expression (TeethIn -> 4x YumYum -> TeethOut -> reset) | CondiExp_PCTracking, CondiExp_Eating_Script |
| 11.2 | P2 | Raw food consumed (VendorItemFoodRaw) | Same as cooked food -- eating expression plays | CondiExp_PCTracking |
| 11.3 | P2 | Ingredient consumed with eating mode | `Condiexp_GlobalEating == 2` (all ingredients) -> triggers eating; `== 1` (first only) -> triggers once then resets to 2 for 5s | CondiExp_PCTracking |
| 11.4 | P2 | SunHelm food keywords | `_SH_LightFoodKeyword/Medium/Heavy/Soup` all trigger eating | CondiExp_PCTracking |

## 12. Other Expression Types

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 12.1 | P1 | Combat anger | `IsInCombat()` + health >= 40% + stamina > 60% -> anger expression (expression 15, 35-80 strength) | CondiExp_AngryScript, CondiExp_Followers |
| 12.2 | P1 | Fatigue/breathing | Stamina < 60% + health >= 40% -> breathing animation (Inhale/Exhale phoneme cycling) | CondiExp_Fatigue, CondiExp_Followers |
| 12.3 | P1 | Random emotion | 110 weighted outcomes: look, smile, frown, angry, puzzled, thinking, yawn, etc. Falls back to JSON random expression phases 1-7 | CondiExp_RandomScript, CondiExp_Expression_Util |
| 12.4 | P2 | Sneaking | Player crouching -> squint expression | CondiExp_Sneaking_Script |
| 12.5 | P2 | Swimming | In water -> breathing expression | CondiExp_WaterScript |
| 12.6 | P2 | No clothes | No armor equipped -> embarrassment expression | Condiexp_NoclothesScript |
| 12.7 | P2 | Headache | Magicka < 30% -> headache expression (sad expression + brow down + look down) | Condiexp_Headache |

## 13. NPC Follower System

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 13.1 | P0 | Quest starts, NPCs detected | Up to 16 aliases filled, each runs independent `OnUpdate` loop | CondiExp_Followers |
| 13.2 | P1 | Player moves > 300 units | `firstRun` toggled, quest reset to re-scan nearby NPCs | CondiExp_Followers |
| 13.3 | P1 | NPC > 1024 units away | Distance counter decrements (from 6); at 0, alias cleared and NPC removed | CondiExp_Followers |
| 13.4 | P1 | NPC dies | Death expression applied (random blink/squint/brow), alias cleared | CondiExp_Followers |
| 13.5 | P1 | NPC sleeping | Blink modifier set to 90, no other expressions | CondiExp_Followers |
| 13.6 | P1 | NPC relationship-based emotions | `GetRelationshipRank` >= 2: friendly (smile/happy), <= -2: hostile (angry/frown), else: neutral (puzzled/thinking) | CondiExp_Followers, CondiExp_Expression_Util |
| 13.7 | P2 | NPC 3D not loaded | Update deferred, no expression attempt | CondiExp_Followers |
| 13.8 | P2 | Follower quest stopped via MCM | `IsStopped()` check -> alias cleared, NPC removed cleanly | CondiExp_Followers |
| 13.9 | P2 | NPC gag detected | `checkMouthWearable` returns true, phoneme-based expressions suppressed but others still play | CondiExp_Followers |

## 14. JSON Expression Loading

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 14.1 | P0 | All 5 expression JSON files load | `Initialize()` loads each, `CountPhases()` validates phases, `Enabled = true` | CondiExp_BaseExpression |
| 14.2 | P1 | Missing JSON file | `JsonUtil.GetStringValue` returns "", `ImportJson` returns false, `Enabled = false`, mod continues without that expression type | CondiExp_BaseExpression |
| 14.3 | P1 | Expression ID > 14 clamped | `if Preset[30] > 14` -> set to 0, prevents OpenMouth expression glitch | CondiExp_BaseExpression |
| 14.4 | P2 | Phase with all zeros | `ValidatePreset` returns 0, phase not counted, sequential phase chain breaks | CondiExp_BaseExpression |
| 14.5 | P2 | Preset array wrong size (!= 32) | `_ApplyPresetFloats` early returns, `GenderPhase` returns empty 32-float array | CondiExp_BaseExpression |

## 15. MFG Cleanup & Transitions

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 15.1 | P0 | Expression cleanup on suspension | `mfgCleanup` called: resets phonemes, modifiers, and expressions smoothly | CondiExp_util |
| 15.2 | P1 | Cleanup with gag equipped | Phonemes and expressions NOT cleaned (keeps mouth open state), only modifiers cleaned | CondiExp_util |
| 15.3 | P1 | Cleanup during dialogue | Full cleanup unless gagged | CondiExp_util |
| 15.4 | P1 | Dead actor cleanup | `mfgCleanup` early returns for dead actors (no crash) | CondiExp_util |
| 15.5 | P2 | `resetMFGSmooth` during dialogue | `isInDialogue` check prevents reset from interrupting dialogue animations | CondiExp_util |

## 16. MCM Configuration

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 16.1 | P0 | All 4 MCM pages render | Expressions, Settings, Maintenance, Aroused Modifiers -- no script errors | condiexp_MCM |
| 16.2 | P1 | Toggle each expression type | GlobalVariable updated immediately, expression enables/disables on next tick | condiexp_MCM |
| 16.3 | P1 | Cold method change triggers restart | `_restart()` called, `StopMod/StartMod` cycle, cold method re-initialized | condiexp_MCM |
| 16.4 | P1 | Update interval slider (0-60) | `Condiexp_UpdateInterval` set, affects next `RegisterForSingleUpdate` | condiexp_MCM |
| 16.5 | P1 | Expression strength sliders (0-2x) | `Condiexp_ExpressionStr/ModifierStr/PhonemeStr` scale all expression applications | condiexp_MCM |
| 16.6 | P2 | Test expression tool | Select type + phase -> "GO" applies expression to player at power 100, MFG reset first | condiexp_MCM |
| 16.7 | P2 | Condition overrides | `traumaOverride/coldOverride/dirtOverride/arousalOverride` force corresponding status to max value | condiexp_MCM |
| 16.8 | P2 | Uninstall via MCM | `StopMod()` -> suspend, wait 3s, remove spell, reset MFG, unregister events, stop quests | condiexp_MCM |

## 17. Hotkeys

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 17.1 | P1 | Pause hotkey | `Condiexp_SuspendedByKey` toggles, notification "Suspended/Resumed by key" | CondiExp_StartMod |
| 17.2 | P1 | Register followers hotkey | `CondiExpFollowerQuest` reset (re-scans NPCs), notification "Followers were registered" | CondiExp_StartMod |
| 17.3 | P2 | Hotkey during initialization | `_checkPlugins != 0` -> notification "Initialization in progress", hotkey ignored | CondiExp_StartMod |
| 17.4 | P2 | Followers quest not running | Register followers hotkey -> notification "Followers support is disabled" | CondiExp_StartMod |
| 17.5 | P2 | Hotkey conflict detection | MCM warns about key conflicts, asks confirmation before reassigning | condiexp_MCM |

## 18. Integration -- SexLab

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 18.1 | P1 | SexLab animating faction check | `IsActorActive(sexlab, act)` suspends mod during scenes | CondiExp_StartMod, CondiExp_Interface_SL |
| 18.2 | P1 | SexLab cum detection (oral) | `IsPlayerCumsoakedOral` returns true -> dirty status 3 | CondiExp_Interface_SL |
| 18.3 | P1 | SexLab cum detection (vag/anal) | `IsPlayerCumsoakedVagOrAnal` returns true -> dirty status 2 | CondiExp_Interface_SL |
| 18.4 | P2 | SexLab not installed | `sexlab` quest is None, all SL checks skipped cleanly | CondiExp_StartMod |

## 19. Integration -- Other Mods

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 19.1 | P1 | Devious Devices gag detection | `zad_DeviousGag` keyword on worn item -> mod suspended or phonemes suppressed | CondiExp_PCTracking |
| 19.2 | P1 | ZaZ Animation Pack gag/mouth keywords | `zbfWornGag`, `zbfEffectOpenMouth` detected -> suspension or mouth-open mode | CondiExp_PCTracking |
| 19.3 | P1 | Toys framework mouth open | `ToysEffectMouthOpen` keyword -> suspension or mouth-open mode | CondiExp_PCTracking |
| 19.4 | P2 | SL Survival tongue keyword | `_SLS_TongueKeyword` detected -> mod suspended | CondiExp_PCTracking |
| 19.5 | P2 | PO3 Papyrus Extender installed | `Condiexp_PO3ExtenderInstalled = 1`, `RandomNumber` uses `PO3_SKSEFunctions.GenerateRandomInt` instead of `Utility.RandomInt` | CondiExp_StartMod, CondiExp_util |
| 19.6 | P2 | Dhlp-compatible mods | Any mod sending `dhlp-Suspend/Resume` events correctly pauses/resumes CEE | CondiExp_StartMod |

## 20. Sound System

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 20.1 | P1 | Sound set matches race/gender | Male Khajiit=1, Male Orc=2, Male Default=3, Female Khajiit=4, Female Orc=5, Female Default=6 | CondiExp_StartMod |
| 20.2 | P1 | Race change updates sounds | `OnRaceSwitchComplete` -> `NewRace()` re-detects and updates `Condiexp_Sounds` | CondiExp_PCTracking |
| 20.3 | P2 | Sounds disabled | `Condiexp_Sounds = 0` -> `NewRace()` early returns, no sound set selection | CondiExp_StartMod |
| 20.4 | P2 | Vampire race variants | `KhajiitRaceVampire`/`OrcRaceVampire` mapped to same sound sets as base races | CondiExp_StartMod |

## 21. Save/Load Stability

| # | P | Scenario | Expected | Scripts |
|---|---|----------|----------|---------|
| 21.1 | P0 | Save/reload preserves mod state | GlobalVariables survive save cycle, expressions resume on next tick | CondiExp_PCTracking |
| 21.2 | P1 | Stuck busy flags after crash | `OnMenuClose("Loading Menu")` detects `CurrentlyBusy > 0`, forces `StopMod/StartMod` | CondiExp_PCTracking |
| 21.3 | P1 | Optional mod removed between saves | `isDependencyReady` returns false, mod references stay None, no script errors on next load | CondiExp_StartMod |
| 21.4 | P2 | Quest alias persistence | Follower quest aliases cleared and re-scanned on game load via `ResetQuest` | CondiExp_Followers |

---

## 22. Known Bugs & Fragile Areas

These are confirmed or suspected issues found during code inspection. Each should be triaged as fix-or-accept before release.

| # | P | Issue | Location | Impact |
|---|---|-------|----------|--------|
| 22.1 | P2 | **SexLabAnimatingFaction property empty** -- `Faction Property SexLabAnimatingFaction Auto` has comment "empty - to delete" but is still declared | CondiExp_StartMod:63 | Dead property; CK-filled property removal risk if cleaned up |
| 22.2 | P2 | **`isSuspendedByDhlpEvent` bool property marked "to delete"** -- `Bool Property isSuspendedByDhlpEvent Auto Hidden` alongside the GlobalVariable version | CondiExp_StartMod:66 | Dead property, should not be removed without CK cleanup |
| 22.3 | P2 | **`Condiexp_ColdGlobal` property marked "to delete"** | CondiExp_StartMod:32 | Dead GlobalVariable property |
| 22.4 | P2 | **Cold method 5 (auto) logs error if not resolved** -- `log("Condiexp_ColdMethod is set to auto and wasn't updated", 1)` falls through to return 0 | CondiExp_StartMod:442 | Could happen if `resolveAutoColdMethod` fails for unexpected reason |
| 22.5 | P2 | **Duplicate dirty return** -- `getDirtyStatus` has `return 0` on line 502 after `EndIf` that already returned | CondiExp_StartMod:502 | Unreachable code, no functional impact |
| 22.6 | P1 | **NPC suspension skips wearable check** -- `checkIfModShouldBeSuspendedForNPCs` does not call `checkIfModShouldBeSuspendedByWearables` | CondiExp_StartMod:377 | Gagged NPCs may still get expressions applied (mitigated by `checkMouthWearable` in follower loop) |
| 22.7 | P2 | **CondieExp_Skooma_Script typo in filename** -- note the double 'e' in "CondieExp" | CondieExp_Skooma_Script.psc | Cosmetic; renaming would require ESP update |
| 22.8 | P2 | **Follower distance counter not reset on quest restart** -- `distanceCounter` initialized to 6 at script level but not re-initialized in `OnInit` | CondiExp_Followers:17 | Script-level init covers new instances; only matters if script state persists unexpectedly |

---

*Last updated: 2026-05-01*
