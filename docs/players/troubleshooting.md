# Troubleshooting & FAQ

## The MCM isn't showing up — how do I enable it?

Move **Conditional Expressions.esp** higher in your load order. If it still doesn't register, try [Jaxonz MCM Kicker SE](https://www.nexusmods.com/skyrimspecialedition/mods/36801?tab=description) to force the menu to populate.

## Can I use this with *X* mod?

All animation mods should be compatible. The only mods that can conflict are ones that also change the player's **facial expressions** — and there aren't many. See the full list on [Requirements & Compatibility](compatibility.md).

## Expressions aren't appearing at all

Work through these in order:

1. Confirm **MFG Fix NG** and **PapyrusUtil SE** are installed and active.
2. Make sure the mod isn't **suspended** — check the Maintenance page status. Scenes (`dhlp`/OStim), gags, dialogue, and the SexLab animating faction all suspend it by design.
3. Confirm the emotion you expect is **enabled** on the Expressions page and that its **threshold** (MCM / [console globals](console-commands.md)) is met.
4. Some expressions are gated by view/state — `GetAnimationVariableInt` (used for first-person checks) only reports correctly when the actor has loaded 3D in third-person.
5. If another mod (e.g. RaceMenu expression sliders) is holding the face, it can override CEE's morphs — disable the overlapping feature on one side.

## Expressions look stuck after a save load

CEE re-initializes after a load and clears stuck busy flags. If something is still frozen, use **Reset expression** and then **Restart** on the Maintenance page.

## Updating mid-game caused a glitch

Update from indoors or with cold expressions disabled, and not during a scene. See [Getting Started → Updating mid-game](getting-started.md#updating-mid-game).

## Developer notes (why the effect behaves the way it does)

Working with a constant-effect ability in Papyrus is finicky, and CEE's design reflects it:

1. The effect restarts often unless blocked via an external variable. When blocked, it exits immediately through `OnEffectFinish`.
2. Doing immediate internal script checks causes freezing.
3. If not blocked, it can occasionally restart in a separate instance.

The reliable approach — and what CEE does — is to treat `OnEffectFinish` as a one-time trigger and drive the real polling loop from `RegisterForSingleUpdate`.
