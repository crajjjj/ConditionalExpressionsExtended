# Conditional Expressions Extended

Skyrim SE mod: dynamic facial animations and expressions based on game conditions and emotions. Pure Papyrus script system using MFG Fix NG for smooth facial animation blending.

## Build

```sh
# Papyrus scripts (Skyrim SE compiler)
# Project file: skyrimse.ppj
# Sources: Source/Scripts/*.psc -> Scripts/*.pex
# Zip output: Build/Conditional Expressions Extended (SE-AE).zip
```

## Important: CK-Filled Properties

Script properties filled via the Creation Kit (CK) in the ESP must NOT be removed from `.psc` files even if unused in code. Removing them breaks the form binding. To clean up, you must also clear the property in the ESP. When in doubt, leave them as dead weight.

## Papyrus Language Notes

### Reserved keywords (case-insensitive, cannot be used as identifiers)
`As`, `Auto`, `AutoReadOnly`, `Bool`, `Else`, `ElseIf`, `EndEvent`, `EndFunction`, `EndIf`, `EndProperty`, `EndState`, `EndWhile`, `Event`, `Extends`, `False`, `Float`, `Function`, `Global`, `If`, `Import`, `Int`, `Length`, `Native`, `New`, `None`, `Parent`, `Property`, `Return`, `ScriptName`, `Self`, `State`, `String`, `True`, `While`

### Control flow
- No `break` or `continue` -- use flags or early `return` to exit loops.
- Only `if/elseif/else/endif` and `while/endwhile`. No for-loops, switch, or do-while.
- Logical `||` and `&&` short-circuit.

### Variables & types
- Five base types: `Bool`, `Int`, `Float`, `String`, plus object references and arrays.
- Value types (Bool/Int/Float/String) are copied on assignment. Objects/arrays are by reference.
- Variables inside `while` loops persist across iterations (NOT reset each iteration). Always initialize explicitly.
- Script-level variables can only be initialized with literals, not expressions. Function-level can use expressions.
- Division by zero and modulus by zero produce undefined results (engine logs error).

### Arrays
- Max 128 elements. Size must be an integer literal (`new int[128]`), not a variable.
- `array[i] += 5` does NOT compile -- use `array[i] = array[i] + 5`.
- No arrays of arrays. Arrays are passed/assigned by reference.
- `Find()`/`RFind()` and SKSE string functions are case-insensitive. `==` string comparison is case-sensitive.

### Properties & optional mod dependencies
- Global/static function calls (e.g. `Game.GetFormFromFile(...)`) resolve lazily at call time, not script load. Safe to reference optional mods if guarded by `Game.GetModByName()`.
- Properties typed to external scripts (e.g. `SexLabFramework Property SexLab Auto`) resolve at script load -- the type must exist or the script fails to load entirely.
- Auto property getters/setters are external calls in threading context.

### States
- Script can be in only one state at a time. `GotoState("")` returns to empty state.
- State function signatures must exactly match the empty-state definition.
- Call `GotoState()` BEFORE external calls, not after (threading safety).
- State transitions fire `OnEndState()` -> change -> `OnBeginState()`.

### Threading
- Only one thread can run a script instance at a time. Any external call (including `Debug.Trace()`, property access on other objects) unlocks the script, allowing other threads in.
- After an external call returns, local assumptions about script state may be stale.
- Internal operations (own variables, own properties, array ops) do NOT unlock.

### Misc gotchas
- `GetAnimationVariableInt()` only works on actors with loaded 3D in third-person view.
- Compiler does not check all code paths for return values -- missing returns cause undefined behavior.
- `parent.FunctionName()` calls one level up, not necessarily the base definition.
- Unary minus can misbehave without spaces: write `x = y - 1` not `x = y-1`.

## Code Conventions

- Keep UTF-16 LE BOM encoding for translation files (`Interface/translations/`).
- Keep edits ASCII unless the file already contains non-ASCII.
- All optional mod dependencies are resolved lazily via `Game.GetFormFromFile()` guarded by `isDependencyReady()` checks.
- GlobalVariable properties store mod configuration; toggled via MCM or console commands.

## Project Structure

```
Source/Scripts/               26 Papyrus source files (.psc)
Scripts/                      Compiled bytecode (.pex)
Conditional Expressions.esp   Main ESP plugin (quests, spells, globals, formlists)
SKSE/Plugins/CondiExp/        JSON expression definitions + mfgfix.ini
Interface/translations/       Localized MCM strings (13 languages)
Interface/MCM/                MCM splash image
Sound/                        Voice/sound assets (breathing, sobbing)
Build/                        Release .zip archives
skyrimse.ppj                  Papyrus project file (compiler config)
```

## Core Systems & Code Paths

### 1. Initialization & Main Loop

Entry: `CondiExp_PCTracking.onPlayerLoadGame()` -> `CondiExp_StartMod.StartMod()`
- Resolves cold detection method (auto-detect Frostfall/Frostbite/SunHelm/Vanilla)
- Discovers optional mods (Apropos2, ZaZ, DD, SLA, SexLab, Toys, PO3 Extender)
- Discovers bathing mod (Dirt & Blood, Bathing in Skyrim, BIS Renewed, Keep It Clean)
- Loads all 5 JSON expression profiles (arousal, trauma, dirty, pain, random)
- Applies `CondiExp_Fatigue1` constant-effect spell to player
- Registers for mod events (dhlp-Suspend/Resume, ostim_start/end, CondiExp_SLAEvent)
- `OnInit()` -> deferred `StartMod()` via `_checkPlugins` counter (runs on 2nd update tick)

### 2. Polling System (`CondiExp_StartMod.OnUpdate`)

The main update loop runs on `RegisterForSingleUpdate(Condiexp_UpdateInterval)` (default ~5s).

Each tick:
1. Defer if in menu mode or player invalid (`shouldDeferPollingBasic`)
2. Check suspension conditions: dhlp event, hotkey pause, wearables (gags), SexLab animating faction, dialogue
3. If suspended: clean up MFG state and set `Condiexp_ModSuspended = 1`
4. Update global status variables:
   - `Condiexp_CurrentlyCold` (cold mod integration)
   - `Condiexp_CurrentlyTrauma` (Apropos2 abuse state or ZaZ slave faction)
   - `Condiexp_CurrentlyDirty` (bathing mod dirtiness + SexLab cum detection)
   - `Condiexp_CurrentlyAroused` (SLA arousal faction)
5. Apply arousal modifiers for rain, low health (pain), low magicka (headache), swimming

### 3. Expression Effect Scripts (ActiveMagicEffect pattern)

Each emotion type is an `ActiveMagicEffect` script applied by the constant-effect spell `CondiExp_Fatigue1`. They trigger via `OnEffectFinish` (treating the effect as a one-time trigger due to constant-effect quirks).

**Priority order (checked top to bottom in each script):**
1. Sleeping -> blink/close eyes
2. Pain (Health < 50%) -> pain expression
3. Combat Anger (in combat, high health/stamina)
4. Fatigue (low stamina) -> breathing animation
5. Drunk/Skooma -> multi-phase intoxication expressions
6. Eating -> chewing animation
7. Cold -> shivering
8. Trauma -> pain/distress expression + optional sobbing sounds
9. Dirty -> sadness expression
10. Aroused -> arousal expression (gender-aware)
11. Water (swimming) -> breathing
12. Sneaking -> squint
13. No clothes -> embarrassment
14. Random -> relationship-aware or random emotion

### 4. JSON Expression System (`CondiExp_BaseExpression`)

Expressions are loaded from `SKSE/Plugins/CondiExp/Expression_[name].json` via PapyrusUtil `JsonUtil`.

**32-Float Array per phase:**
- `[0-15]`: Phoneme strengths (Aah, BigAah, BMP, ChjSh, DST, Eee, Eh, FV, i, k, N, Oh, OohQ, R, Th, W)
- `[16-29]`: Modifier strengths (BlinkL/R, BrowDownL/R, BrowInL/R, BrowUpL/R, LookDown/Left/Right/Up, SquintL/R)
- `[30]`: Base expression ID (0-14, clamped to prevent OpenMouth issues)
- `[31]`: Expression strength (0.0-1.0 float)

**Gender phases:** Up to 7 phases per gender (Male1-Male7, Female1-Female7). Phase selection based on emotion intensity.

**Expression types:** aroused, trauma, dirty, pain, random

### 5. NPC Follower System (`CondiExp_Followers`)

Quest-alias based system supporting up to 16 nearby NPCs.

- Player alias tracks movement; refreshes quest when player moves > 300 units
- NPC aliases run independent `OnUpdate` loops at `Condiexp_FollowersUpdateInterval`
- Distance check: NPCs > 1024 units away are counted down (6 ticks) then removed
- Dead NPCs get death expressions (random blink/squint/brow) then cleared
- Living NPCs follow same emotion priority as player but use `checkIfModShouldBeSuspendedForNPCs` (skips wearable check)
- Relationship-rank-aware random expressions: friendly (smile, happy), hostile (angry, frown, disgust), neutral (puzzled, thinking, look)

### 6. Wearable Detection (`CondiExp_PCTracking`)

Tracks equipped items that affect facial expressions:
- **Gags** (DD `zad_DeviousGag`, ZaZ `zbfWornGag`/`zbfEffectOpenMouth`, Toys `ToysEffectMouthOpen`, SLS `_SLS_TongueKeyword`): suppress mod or force open-mouth phonemes
- **Food/Drink** detection via keywords: SunHelm food keywords, vanilla `VendorItemFood`/`VendorItemFoodRaw`/`VendorItemIngredient`, alcohol (formlist + SunHelm keyword), drugs (formlist)
- **Race change**: re-detects sound set on `OnRaceSwitchComplete`
- **Loading Menu**: restarts mod if busy flags are stuck after load

### 7. Smooth Expression Utilities (`CondiExp_util`, `CondiExp_Expression_Util`)

All facial animation goes through MFG Fix NG SKSE plugin:
- `MfgConsoleFuncExt.SetPhoneme/SetModifier/SetExpression` with speed parameter for smooth transitions
- `MfgConsoleFuncExt.ApplyExpressionPresetSmooth` for full 32-float preset application
- `MfgConsoleFuncExt.ResetMFG/ResetPhonemes/ResetModifiers` for cleanup
- `MfgConsoleFuncExt.GetPlayerSpeechTarget/IsInDialogue` for dialogue detection

Expression utility functions: `Smile`, `Frown`, `Angry`, `Thinking`, `Yawn`, `Squint`, `BrowsUp/Down`, `BrowsUpSmile`, `Happy`, `Disgust`, `Fear`, `Surprised`, `Puzzled`, `LookLeft/Right/Down`, `Breathe` (Inhale/Exhale), `Headache`, `PlayEatingExpression` (YumYum/TeethIn/Out), `HumanOuch`, `VampireOuch`

### 8. MCM Configuration (`condiexp_MCM`)

4 pages: Expressions, Settings, Maintenance, Aroused Modifiers

**Expressions page:** Toggle each emotion type on/off, eating speed, cold method selector
**Settings page:** Sounds toggle, update intervals (player/followers), expression/modifier/phoneme strength sliders (0-2x), follower system toggle, hotkeys
**Maintenance page:** Status display, restart, reset expression, uninstall, verbose logging, loaded expression counts, test expression tool (type + phase selector), condition overrides (simulate trauma/cold/dirty/aroused)
**Aroused Modifiers page:** Per-condition arousal threshold and cap sliders (chilly/cold/freezing, pain, trauma minor/major, swim, rain, headache)

### 9. Sound System

Race/gender-specific sound sets (6 variants):
- Male: Khajiit (1), Orc (2), Default (3)
- Female: Khajiit (4), Orc (5), Default (6)

Used in `CondiExp_TraumaScript` for optional sobbing/breathing sounds during trauma expressions.

## Key Scripts by Role

| Script | Role |
|--------|------|
| `CondiExp_StartMod.psc` | Main quest script, initialization, status polling, suspension logic |
| `CondiExp_PCTracking.psc` | Equip/food/drink detection, gag/wearable tracking, game load handler |
| `CondiExp_BaseExpression.psc` | JSON expression loader, phase system, expression application |
| `CondiExp_Expression_Util.psc` | Facial animation functions (emotions, breathing, eating, etc.) |
| `CondiExp_Followers.psc` | NPC follower expression system (up to 16 NPCs) |
| `condiexp_MCM.psc` | MCM configuration (4 pages, all settings) |
| `CondiExp_util.psc` | Utility functions, MFG wrappers, dependency checks, cleanup |
| `CondiExp_log.psc` | Logging and debug output |

## Emotion Effect Scripts (ActiveMagicEffect)

| Script | Emotion | Trigger |
|--------|---------|---------|
| `CondiExp_ArousedScript.psc` | Arousal | SLA arousal > threshold |
| `CondiExp_TraumaScript.psc` | Trauma/Pain | Apropos2 abuse or ZaZ slave faction |
| `Condiexp_Dirty.psc` | Sadness | Bathing mod dirtiness or SL cum |
| `CondiExp_Cold_Script.psc` | Shivering | Cold mod or vanilla snow weather |
| `CondiExp_PainScript.psc` | Pain | Active diseases |
| `CondiExp_RandomScript.psc` | Random emotion | Always (when no higher-priority emotion) |
| `CondiExp_AngryScript.psc` | Anger | In combat |
| `CondiExp_Fatigue.psc` | Breathing | Low stamina |
| `CondiExp_Drunk_Script.psc` | Drunk | Alcohol consumed |
| `CondieExp_Skooma_Script.psc` | Skooma high | Skooma consumed |
| `CondiExp_Eating_Script.psc` | Eating | Food consumed |
| `Condiexp_Headache.psc` | Headache | Low magicka (< 30%) |
| `CondiExp_WaterScript.psc` | Swimming | In water |
| `CondiExp_Sneaking_Script.psc` | Sneaking | Crouching |
| `Condiexp_NoclothesScript.psc` | Embarrassment | No armor equipped |

## Integration Scripts

| Script | Mod | Purpose |
|--------|-----|---------|
| `CondiExp_Interface_SL.psc` | SexLab | Cum detection (`IsPlayerCumsoakedOral`, `IsPlayerCumsoakedVagOrAnal`), animating faction check |
| `CondiExp_Interface_Sla.psc` | SexLabAroused | Arousal level queries, exposure/arousal cap management |
| `CondiExp_Interface_Appr2.psc` | Apropos2 | Abuse state queries (0-10 scale) |

## Mod Events API

**Listens for:**
- `dhlp-Suspend` / `dhlp-Resume` -- suspend/resume expressions (compatible with any dhlp-using mod)
- `ostim_start` / `ostim_end` -- mapped to dhlp suspend/resume
- `CondiExp_SLAEvent` -- arousal modifier events (threshold, decrease, notification, effectName, actor)

**Emits:**
- `CondiExp_SLAEvent` -- sent by `SendSLAModEvent()` to self for arousal cap processing

## Constant-Effect Spell Pattern

Working with constant effects is tricky:
1. The effect restarts often if not blocked via external variable. If blocked, it exits immediately with `OnEffectFinish`.
2. Internal immediate script checks cause freezing.
3. If not blocked, the effect can occasionally restart in a separate instance.
4. The only reliable approach: treat `OnEffectFinish` as a one-time trigger, use `RegisterForSingleUpdate` for the actual polling loop.

## Console Commands

```
set Condiexp_MinAroused to 30       ; arousal threshold (0-100, default 30)
set Condiexp_MinDirty to 1          ; dirtiness threshold (0-4, default 1)
set Condiexp_MinTrauma to 1         ; trauma threshold (1-10, default 1)
set Condiexp_TraumaZBFFactionEnabled to 0  ; disable ZaZ slave faction trauma
```

Note: range values are not inclusive (e.g. setting `Condiexp_MinDirty` to 4 disables the feature).
