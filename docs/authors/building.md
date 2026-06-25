# Building from Source

CEE is pure Papyrus — there is no native plugin to compile. You only need the Skyrim SE Papyrus compiler and the dependency scripts on your import path.

## Layout

```
Source/Scripts/               Papyrus source (.psc)
Scripts/                      Compiled bytecode (.pex)
Conditional Expressions.esp   Main plugin (quests, spells, globals, formlists)
SKSE/Plugins/CondiExp/        JSON expression definitions + mfgfix.ini
Interface/translations/       Localized MCM strings (13 languages)
skyrimse.ppj                  Papyrus project file (compiler config)
Build/                        Release .zip archives
```

## Prerequisites on the import path

The scripts import types from these mods' sources — they must be available to the compiler:

- MFG Fix NG (`MfgConsoleFunc`, `MfgConsoleFuncExt`)
- PapyrusUtil (`JsonUtil`, `PapyrusUtil`)
- SKSE script sources
- Skyrim base script sources

## Compiling

The project is configured by `skyrimse.ppj`:

- Sources: `Source/Scripts/*.psc`
- Output: `Scripts/*.pex`

Compile the project file with the Creation Kit Papyrus compiler (or your editor's Papyrus build integration pointed at `skyrimse.ppj`).

## Conventions

!!! warning "Don't remove CK-filled properties"
    Script properties filled via the Creation Kit in the ESP must **not** be removed from `.psc` files even if unused in code — removing them breaks the form binding. To truly remove one, clear it in the ESP as well. When in doubt, leave it as dead weight.

- Keep **UTF-16 LE BOM** encoding for translation files under `Interface/translations/`.
- Keep edits **ASCII** unless the file already contains non-ASCII.
- Resolve optional mod dependencies **lazily** via `Game.GetFormFromFile()` guarded by dependency checks — never type a property to an optional mod's script (that resolves at load and breaks the script if the mod is absent).

## Releasing

Release builds are zipped under `Build/`. Versioning is tracked by `GetVersion()` / `GetVersionString()` in `CondiExp_util.psc`, and a release is marked by a matching git tag.
