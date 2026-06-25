# Console Commands

!!! warning "Advanced — not recommended"
    Most tuning belongs in the [MCM](mcm-reference.md). These global-variable overrides exist for edge cases and debugging. Set them from the console with:

    ```
    set <GlobalVariableName> to <amount>
    ```

## Threshold globals

| Global | Range | Default | Effect |
|--------|-------|---------|--------|
| `Condiexp_MinAroused` | 0–100 | 30 | Arousal level required before aroused expressions show |
| `Condiexp_MinDirty` | 0–4 | 1 | Dirtiness stage required before sad/dirty expressions show |
| `Condiexp_MinTrauma` | 1–10 | 1 | Trauma level required before trauma expressions show |
| `Condiexp_TraumaZBFFactionEnabled` | 0 / 1 | 1 | Set to `0` to stop the ZaZ slave faction from driving trauma |

### Examples

```
set Condiexp_MinAroused to 30
set Condiexp_MinDirty to 1
set Condiexp_MinTrauma to 1
set Condiexp_TraumaZBFFactionEnabled to 0
```

!!! note "Range values are not inclusive"
    Setting a value to the top of its range disables the feature. For example, `set Condiexp_MinDirty to 4` turns the dirty feature **off** (nothing reaches stage 4+).
