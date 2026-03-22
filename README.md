# Traktor QML Mods (Documentation)

**Handbook Version**: v1.0.0

This repo is a **documentation set** for customizing Native Instruments **Traktor Pro** using **QML** — the language Traktor uses for its controller UI.
**If you've created MIDI mappings in Traktor Pro**, you understand the concept of wiring hardware controls to actions. QML works the same way — it's just more powerful: you can change what buttons do, what screens show, and how the UI behaves.

# NOTE: The traktor-mod scripts referenced in this documentation are vibe coded via AI with minimal code review. Use with caution and review scripts before production use.

---

## Setup: Companion Repositories

Clone these two repositories alongside this handbook:

```bash
git clone https://github.com/lsmith77/traktor-kontrol-qml-files traktor-kontrol-qml-files
git clone https://github.com/lsmith77/traktor-logger traktor-logger
```

- **`traktor-kontrol-qml-files/`** — stock Traktor QML baseline, used by AI tools for comparison
- **`traktor-logger/`** — real-time debugging dashboard (required for `traktor-mod logger` commands)

---

**Navigation**: [00_HANDBOOK.md](00_HANDBOOK.md) · [01_BASICS.md](01_BASICS.md) · [Full chapter list](#all-chapters)

---

## I want to install a community mod

1. **[Chapter 03: Community Resources](03_COMMUNITY_RESOURCES.md)** — curated list of GitHub repos and forum mods for S4 MK3, X1 MK3, and other controllers
2. **[Chapter 01: Basics](01_BASICS.md)** — `qml` folder structure, Traktor architecture
3. **[Chapter 08: Sharing Changes](08_SHARING_CHANGES.md)** — `traktor-mod` script setup (automates backup, overlay install, restore)
   - **macOS users**: run `traktor-mod.sh` instead; if the script fails, **[scripts/manual-install.md](scripts/manual-install.md)** covers every step manually
4. **[Chapter 05: FAQ](05_FAQ.md)** — safety, Traktor updates overwriting mods, common questions
5. **[Chapter 04: Troubleshooting](04_TROUBLESHOOTING.md)** — when something breaks

---

## I want to combine features from multiple mods

1. **[Chapter 10: Prompt Templates](10_PROMPT_TEMPLATES.md)** — full index with workflow order
2. **[Chapter 11: Combining Mods — Complete Workflow](11_COMBINING_MODS_WORKFLOW.md)** — step-by-step guide (preparation → AI generation → save → deploy)
3. **[Chapter 08: Sharing Changes](08_SHARING_CHANGES.md)** — understand mod structure before combining
4. **[Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md)** — how to read feature documentation in well-documented mods
5. **[traktor-logger](https://github.com/lsmith77/traktor-logger/README.md)** — verify combined mods load and interact correctly

Paste the prompt into Claude, ChatGPT, Copilot, or any AI chat — no tooling beyond a text editor and git.

---

## I want to create a custom feature

Example: _"Pressing PLAY while the deck is playing should trigger a 700ms vinyl brake ramp, then stop."_

1. **[Prompt Template: Create Feature](prompts/create-feature.md)** — copy the template into Claude, ChatGPT, or Copilot
2. Answer a few questions about your feature (trigger, behavior, configuration)
3. Get complete QML code + documentation + test checklist
4. Deploy and test in Traktor — use **[traktor-logger](https://github.com/lsmith77/traktor-logger/README.md)** for real-time monitoring

See [Chapter 10: Prompt Templates](10_PROMPT_TEMPLATES.md) for details, or jump straight to [prompts/create-feature.md](prompts/create-feature.md).

---

## I'm a new mod author

1. **[Chapter 01: Basics](01_BASICS.md)** — QML fundamentals, folder structure, how Traktor loads files
2. **[Chapter 02: API Reference](02_API_REFERENCE.md)** — control value paths, copy-paste code patterns
3. **[Chapter 08: Sharing Changes](08_SHARING_CHANGES.md)** — how to package and publish your work
4. **[Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md)** — how to structure your mod so users can apply individual features, and so AI tools can combine your mod with others automatically
5. **[traktor-logger](https://github.com/lsmith77/traktor-logger/README.md)** — test and debug your code with real-time monitoring

The format in Chapter 09 — one markdown file per feature, semantic version tags in git — means your users can pick just the features they want, and understand exactly what changed in each release.

---

## I have an existing mod and want to adopt these conventions

Two changes make your mod compatible:

**1. Use git and semantic version tags** — tag your releases (`v1.2.3`). Users can run `git diff v1.2.2..v1.2.3` to see exactly what changed.

**2. One feature = one markdown file** — document each feature alongside your QML:

```
your-mod/
  features/
    vinyl-break.md       ← what it does, files changed, before/after code
    loop-roll.md
    screen-display.md
  qml/
    ...
```

Each file lists: what the feature does, which QML files it touches, settings/toggles, and a 3-step test checklist.

**→ [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md)** — full format spec, real examples, pitfalls to avoid, and the reasoning behind each convention

---

## All chapters

- [00_HANDBOOK.md](00_HANDBOOK.md) — index and suggested reading order
- [01_BASICS.md](01_BASICS.md) — beginner QML + Traktor `qml` folder structure + install/restore
- [02_API_REFERENCE.md](02_API_REFERENCE.md) — reference guide + copy-paste code patterns (includes the full control value path catalog)
- [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) — real working mods from the community (GitHub repos + forum discussions)
- [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) — debugging + testing when something breaks
- [05_FAQ.md](05_FAQ.md) — frequently asked questions (safety, installation, mods, updates)
- [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md) — version compatibility + known fixes
- [07_GLOSSARY.md](07_GLOSSARY.md) — quick definitions
- [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) — how to share your changes (basics)
- [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) — how to document mods + metadata lock files
- [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md) — AI prompt templates for combining, updating, and removing mods
- [11_COMBINING_MODS_WORKFLOW.md](11_COMBINING_MODS_WORKFLOW.md) — complete step-by-step workflow for combining mods

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
