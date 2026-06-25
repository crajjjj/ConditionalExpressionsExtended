# Custom Expression JSON

Every emotion's *look* is data. Profiles live in:

```
SKSE/Plugins/CondiExp/Expression_<name>.json
```

Bundled profiles: `Expression_aroused.json`, `Expression_trauma.json`, `Expression_dirty.json`, `Expression_pain.json`, `Expression_Random.json`. Edit these or ship your own — they're loaded at runtime via PapyrusUtil, no recompile required.

## File shape

```json
{
  "floatList": {
    "female1": [0, 0, 0, 0, 0, 0.3, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0],
    "female2": [ ... ],
    "...":     [ ... ],
    "male1":   [ ... ],
    "...":     [ ... ]
  },
  "string": {
    "name": "aroused"
  }
}
```

- Up to **7 phases per gender**: `male1`–`male7` and `female1`–`female7`. Phase selection is driven by emotion intensity, so phase 1 is the mildest and higher phases are stronger.
- Each phase is a **32-float array**.

## The 32-float array

| Index | Group | Meaning | Range |
|-------|-------|---------|-------|
| 0–15 | Phonemes | Aah, BigAah, BMP, ChJSh, DST, Eee, Eh, FV, I, K, N, Oh, OohQ, R, Th, W | 0.0–1.0 |
| 16–29 | Modifiers | BlinkL/R, BrowDownL/R, BrowInL/R, BrowUpL/R, LookDown, LookLeft, LookRight, LookUp, SquintL/R | 0.0–1.0 |
| 30 | Expression | Base expression ID (see below) | 0–16 (whole number) |
| 31 | Strength | Strength of the index-30 expression | 0.0–1.0 |

All values are floats in `0.0–1.0`, **except index 30**, which is a whole number `0–16`.

!!! note "Index 31 = 0 means dynamic"
    If index 31 (strength) is set to `0`, CEE applies a dynamic strength based on the current condition instead of a fixed value.

### Expression IDs (index 30)

| ID | Expression | ID | Expression |
|----|------------|----|------------|
| 0 | Dialogue Anger | 9 | Mood Fear |
| 1 | Dialogue Fear | 10 | Mood Happy |
| 2 | Dialogue Happy | 11 | Mood Sad |
| 3 | Dialogue Sad | 12 | Mood Surprise |
| 4 | Dialogue Surprise | 13 | Mood Puzzled |
| 5 | Dialogue Puzzled | 14 | Mood Disgusted |
| 6 | Dialogue Disgusted | 15 | Combat Anger |
| 7 | Mood Neutral | 16 | Combat Shout |
| 8 | Mood Anger | | |

!!! warning "Avoid ID 16 (Combat Shout)"
    Combat Shout opens the mouth like a phoneme. Don't use it unless you have a specific reason.

## Paired modifiers

Brow and eye modifiers come in left/right pairs (e.g. `SquintLeft` + `SquintRight`, `BrowUpLeft` + `BrowUpRight`). If both halves of a pair use the same value, they're applied simultaneously for a symmetric result.

!!! warning "These modifiers stop the eyes blinking"
    `BlinkLeft`, `BlinkRight`, `LookDown`, `LookLeft`, `LookRight`, and `LookUp` will hold the eye and prevent natural blinking while active. Use sparingly.

## Worked example

```json
"female3": [0, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0.6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 2, 0.8]
```

This phase reads as:

- index 5 `Eee` phoneme @ 50%
- index 11 `Oh` phoneme @ 60%
- index 28/29 `SquintLeft`/`SquintRight` @ 80% (applied together)
- index 30 = `2` (Dialogue Happy), index 31 = `0.8` strength

!!! tip "Visual reference"
    The MFG phoneme/modifier set is documented with pictures here: [Steam guide 187155077](https://steamcommunity.com/sharedfiles/filedetails/?l=english&id=187155077).

## Testing your preset

Use the **Maintenance** MCM page: the *test expression tool* lets you pick a type and a specific phase and play it on demand, so you can iterate on a phase without waiting for the in-game condition to occur.
