# Requirements & Compatibility

## Hard dependencies

- **MFG Fix NG** — the SKSE plugin that does all facial morphing and smooth blending.
- **PapyrusUtil SE** — used to load the JSON expression definitions.

## Optional integrations (auto-detected)

CEE discovers optional mods at startup and lazily resolves their forms only when present, so none of these are required and missing ones simply disable the related feature.

### Cold / survival

Cold shivering uses whichever supported source it finds, auto-detected in this order:

- Frostfall
- Frostbite
- SunHelm
- Vanilla snow weather (fallback)

SunHelm is also used for food, alcohol, and drug keyword detection.

### Bathing / dirtiness

Dirt-based sadness works with the first bathing mod found:

- Dirt & Blood
- Bathing in Skyrim
- BIS Renewed
- Keep It Clean

### Arousal & adult frameworks

- **OSL / SexLab Aroused** — arousal level drives aroused expressions and the exposure cap.
- **SexLab** — cum detection (oral / vaginal-anal) feeds dirtiness; the animating faction suspends the mod during scenes.
- **Apropos2** — abuse state (0–10) drives trauma expressions.
- **ZaZ / DD (Devious Devices) / Toys** — gag detection (forces open-mouth or suppresses expressions); ZaZ slave faction can drive trauma.
- **PO3 Papyrus Extender** — used for improved expression overrides when available.

### Framework & scene compatibility

- **OStim** — `ostim_start` / `ostim_end` are mapped to suspend/resume.
- Any mod that emits **`dhlp-Suspend` / `dhlp-Resume`** — CEE suspends expressions for the duration.

## Known-compatible mods

All animation mods should be compatible. The only mods that can conflict are ones that also drive the player's **facial** expressions.

| Mod | Status |
|-----|--------|
| Random Emotions | Compatible — patch available to let it replace random expressions |
| SL Emotions | Compatible |
| OStim | Compatible |
| Death Expressions | Compatible |
| PC Head Tracking | Compatible (better to disable expressions in its MCM) |
| Blush When Aroused | Compatible — CEE has built-in aroused support; patched version available |
| Devious Devices | Compatible — gags supported |
| Toys Framework | Compatible — gags supported |
| SexLab animations | Compatible — faction check suspends the mod during scenes |
| Expressive Facegen Morphs | Compatible |
| Expressive Facial Animation (Male/Female) | Compatible |
| Mods using `dhlp` events | Compatible |

!!! warning "Facial-expression mods"
    If another mod continuously drives the player's expression morphs (RaceMenu expression sliders, persistent override mods), it can fight CEE for the same face. Disable the overlapping feature in one of the two mods.
