<div align="center">

# 😐 Conditional Expressions Extended (CEE)

*Dynamic and immersive facial expressions for the player and NPCs*

</div>

---

## What Is This?

CEE expands upon *Conditional Expressions - Subtle Face Animations* by adding **NPC support**, deeper **condition-based expressions**, and smoother **SKSE-driven transitions**.
It responds to cold, trauma, arousal, dirtiness, and more – with MCM options and JSON-based customization.

📖 **Full documentation:** <https://crajjjj.github.io/ConditionalExpressionsExtended/>

---

## ✨ What's New in CEE?

- **NPC Support:** Up to 16 nearby NPCs with relationship-based emotional logic. (auto refresh)
- **Sunhelm Survival Integration:** Cold shivers, food/alcohol detection
- **DBVO is supported** (new SKSE-based dialogue checks with or without dialogue menus)
- **Regular expressions are enhanced and extended**
- **Trauma Expressions:** Pain animations for disease effects; optional sobbing sounds
- **Dirt-based Sadness:** Works with Dirt & Blood, Keep It Clean, Bathing in Skyrim
- **Aroused Expressions:** Based on arousal level; *compatible with SLO/OSL Aroused*
- **Smooth Expression Transitions:** Using native SKSE calls — no twitching
- **Expression Cap (SLO/OSL-Aroused-aware):** Limits visual exposure above arousal thresholds; MCM configurable
- **Hotkeys:** Pause mod on the fly
- **Localized MCM Menu**
- **Fully JSON-Driven Expressions:** Define your own emotion presets
- **Respect for Scene Events:** Dhlp suspend/resume prevents facial glitches
- **Animation Framework Compatibility (SL and Ostim)**
- **Wearable-Friendly:** Designed to work with helmets, masks, gags and more
- **Code Overhaul:** Faster, leaner, different bugfixes – sounds fixed. No breathing underwater, etc.
- See [Changelog](https://github.com/crajjjj/ConditionalExpressionsExtended/releases) for full details

---

## 📦 Installation

- **For new saves:** Install CEE alongside or instead of the original Conditional Expressions
- **For existing saves:**
    - Disable any active expression states (cold, pain, etc.) before updating
    - Override the original mod with this one
    - Reboot the game and use **MCM > Restart Mod**

---

## ⚙ Requirements

- [BEES](https://www.nexusmods.com/skyrimspecialedition/mods/106441) – required for versions 1.5.97 to 1.6.659
- [MFG Fix NG](https://www.nexusmods.com/skyrimspecialedition/mods/133568) – native expression support for AE/SE
- [PapyrusUtil SE](https://www.nexusmods.com/skyrimspecialedition/mods/13048) – loads the JSON expression definitions

---

## 🐛 Known Issues & Caveats

- ~~**Hair mods with intense physics** can freeze facial animations — use *showracemenu* to reset~~ Fixed in [FSMP - Faster HDT-SMP v3](https://www.nexusmods.com/skyrimspecialedition/mods/57339?tab=files)
- **Face-covering helmets** may disable expressions
- **Disable sounds/notifications:** Available in MCM
- Logs available at: *Documents\My Games\Skyrim Special Edition\Logs\Script\User\ConditionalExpressionsExtended.0.log* (enable Papyrus logging)

---

**[SubscribeStar](https://subscribestar.adult/crajjjj)**

## 🙌 Credits

- **JaySerpa** – Original Conditional Expressions mod
- **ponzipyramid** – SKSE/NG integration, performance overhaul
- **Andrelo** – MFG Fix
- **krzp** – Media file support

---

<div align="center">

*Bringing immersive emotion and expression to every Skyrim playthrough – for you and NPCs alike.*

</div>
