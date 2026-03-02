# Traktor QML Mods (Documentation)

**Handbook Version**: v0.4.0 | **Last Updated**: 2 March 2026

This repo is a **friendly documentation set** for customizing Native Instruments **Traktor Pro** using **QML** (a programming language for UI customization).

You don’t need to be a programmer to get value from QML mods.

- Change what your controller buttons/encoders do
- Change what your hardware screens show
- Tune UI details (colors, timers, overlays)

**If you've created MIDI mappings in Traktor Pro**, you understand the concept of wiring hardware controls to actions. QML works the same way—it's just a more powerful language that lets you customize the interface itself, not just button behavior.

## Start here

- [00_HANDBOOK.md](00_HANDBOOK.md) — index and suggested reading order
- [01_BASICS.md](01_BASICS.md) — beginner QML + Traktor `qml` folder structure + install/restore
- [02_API_REFERENCE.md](02_API_REFERENCE.md) — reference guide + copy-paste code patterns (includes the full control value path catalog)
- [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) — Real working mods from the community (GitHub repos + forum discussions)
- [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) — debugging + testing when something breaks
- [05_FAQ.md](05_FAQ.md) — frequently asked questions (safety, installation, mods, updates)
- [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md) — version compatibility + known fixes
- [07_GLOSSARY.md](07_GLOSSARY.md) — quick definitions
- [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) — how to share your changes (basics)
- [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) — how to document mods + metadata lock files
- [10_MOD_COMBINATION_PROMPT.md](10_MOD_COMBINATION_PROMPT.md) — combining multiple mods with version tracking and metadata

## Combining Multiple Mods?

When mixing features from different mods, read [**Chapter 10: MOD_COMBINATION_PROMPT**](10_MOD_COMBINATION_PROMPT.md). Copy the prompt template and use it with Claude, Copilot, or your preferred AI to capture version information and create metadata lock files automatically. It helps track versions, identify conflicts, and enable incremental updates.

## The one rule: back up before editing

Traktor updates can overwrite your customizations, and a syntax error can stop parts of the UI from loading.

Workflow:

1. Quit Traktor
2. Back up the `qml` folder
3. Make one small change
4. Restart Traktor and test

---

## Acknowledgments

This documentation was inspired by community customizations from:

- **[Erik Minekus's Traktor Kontrol Screens](https://github.com/ErikMinekus/traktor-kontrol-screens)** - Nexus and Prime editions
- **[Erik Minekus's Traktor API Client](https://github.com/ErikMinekus/traktor-api-client)** - HTTP API integration
- **[kokernutz's Traktor Kontrol Screens](https://github.com/kokernutz/traktor-kontrol-screens)**
- **[artemvmin's Traktor S4 MK3 Mod](https://github.com/artemvmin/traktor_s4mk3_mod)**
- **[djmirror v1.2.0](https://github.com/djmirror/traktor-kontrol-screens/tree/v1.2.0)** - Fader start and LED blinkers
- **[Supreme Edition 3.0 BETA 36.3](https://community.native-instruments.com/discussion/4473/)** - Modular settings and vinyl break
- **[SupremeModEdit V2](https://community.native-instruments.com/discussion/4473/supremeeditionmod-edit)** by Sûlherokhh - Dynamic waveforms and advanced UI
- **[X1 MK3 Community Performance Mod V12](https://community.native-instruments.com/discussion/17167/x1mk3-qml-coding-projects-browsermode-anyone)** by Sûlherokhh - Browser mode, mixer overlay, 3-page setup system, vinyl break, CDJ-style LEDs, and fine tempo/beatgrid control for X1 MK3 (TP 4.4.1). With contributions from Stevan (SuperKnob concept), spinlud (beat counter/tempo), pixel, and Aleix Jiménez
- **S4 MK3 Screen Mod** by Joe Easton - 16-color per-deck customization, beat counter, BPM offset display, colored deck headers, jog wheel track-end blink, and central Settings.qml configuration (TP 3.x, July 2019). Version used in this guide: [GitHub](https://github.com/joe-easton/s4mk3); Newer versions available on [Patreon](https://www.patreon.com/c/traktormods/about?l=de)
- **[Traktor Kontrol Screens (tipesoft edition)](https://github.com/kokernutz/traktor-kontrol-screens)** by @tipesoft / @TraktorSimpleScreen - 7 spectrum waveform color themes, Camelot key display, hotcue bar, phase meter, flux reverse, Prefs.qml system, with contributions from kokernutz, jlertle, derzw3rg, and MrPatben8 (TP 3.10-3.11)
- **[Flux Marker Fix](https://community.native-instruments.com/discussion/1202/dysfunctional-flux-marker-repaired)** - Community fix for broken flux marker on hardware screens (Traktor 3.5+)
- Various contributions from the Native Instruments community forums
