# Mod Events API

CEE integrates with other mods through SKSE mod events. You can suspend it during your own scenes, or feed it arousal modifiers.

## Events CEE listens for

### `dhlp-Suspend` / `dhlp-Resume`

The standard "device hider / scene" suspend protocol. Send `dhlp-Suspend` to pause CEE's expressions for the duration of your scene, and `dhlp-Resume` to release it. Any mod already using `dhlp` events works automatically.

```papyrus
; Pause Conditional Expressions during your scene
SendModEvent("dhlp-Suspend")
; ... your scene ...
SendModEvent("dhlp-Resume")
```

### `ostim_start` / `ostim_end`

OStim's scene events. CEE maps these internally to suspend/resume, so OStim scenes pause expressions without any patch.

### `CondiExp_SLAEvent`

Arousal-modifier event. CEE both listens for and emits this. Payload (as used internally):

| Arg | Meaning |
|-----|---------|
| Number arg | Arousal threshold |
| (decrease) | Amount to decrease arousal by |
| String arg | Notification text / effect name |
| Form arg | The actor |

Use it to apply your own arousal modifier the same way CEE's built-in rain/pain/swim/headache modifiers do.

## Events CEE emits

### `CondiExp_SLAEvent`

Sent by CEE to itself (via `SendSLAModEvent()`) for arousal-cap processing. If you build on the SexLab Aroused exposure/cap pipeline, this is the hook CEE uses.

## Status globals

Beyond events, CEE exposes global variables you can read or override from your own scripts/console:

| Global | Purpose |
|--------|---------|
| `Condiexp_CurrentlyCold` | Current cold status |
| `Condiexp_CurrentlyTrauma` | Current trauma status |
| `Condiexp_CurrentlyDirty` | Current dirtiness status |
| `Condiexp_CurrentlyAroused` | Current arousal status |
| `Condiexp_ModSuspended` | `1` while the mod is suspended |
| `Condiexp_MinAroused` / `Condiexp_MinDirty` / `Condiexp_MinTrauma` | Thresholds (see [Console Commands](../players/console-commands.md)) |

!!! tip
    Reading these is the lightest way to know what CEE currently thinks about the player without parsing facial state.
