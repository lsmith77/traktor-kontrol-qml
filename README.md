# Traktor QML Mods (Documentation)

**Handbook Version**: v0.6.0

This repo is a **friendly documentation set** for customizing Native Instruments **Traktor Pro** using **QML** — the language Traktor uses for its controller UI. No deep programming knowledge required.

**If you've created MIDI mappings in Traktor Pro**, you understand the concept of wiring hardware controls to actions. QML works the same way — it's just more powerful: you can change what buttons do, what screens show, and how the UI behaves.

---

## I want to install a community mod

Find working mods, understand what they do, and deploy them safely.

1. **[Chapter 03: Community Resources](03_COMMUNITY_RESOURCES.md)** — curated list of GitHub repos and forum mods for S4 MK3, X1 MK3, and other controllers
2. **[Chapter 01: Basics](01_BASICS.md)** — `qml` folder structure, how to install and restore
3. **[Chapter 05: FAQ](05_FAQ.md)** — safety, Traktor updates overwriting mods, common questions
4. **[Chapter 04: Troubleshooting](04_TROUBLESHOOTING.md)** — when something breaks

**The one rule**: always back up your `qml` folder before editing. Quit Traktor, copy the folder, make one change, restart and test.

---

## I want to combine features from multiple mods

Combining mods by hand is error-prone: the same file appears in both, conflict resolutions get lost, and there's no record of what came from where. This handbook provides **AI prompt templates** that handle this systematically.

- **`combine-mods`** — give the AI a baseline (clean Traktor QML) and each mod's feature list; it outputs a merged directory plus a `METADATA.md` lock file recording every version and conflict resolution
- **`update-mod`** — when a mod releases a new version, apply only the relevant delta to your combined setup
- **`remove-feature`** — remove a single feature cleanly, including any conflict resolutions that were made to accommodate it
- **`list-features`** / **`split-mod`** — if a mod has no author feature list, extract and split it before merging

Paste the prompt into Claude, ChatGPT, Copilot, or any AI chat — no tooling beyond a text editor and git.

**→ [Chapter 10: Prompt Templates](10_PROMPT_TEMPLATES.md)** — full index with workflow order
**→ [Chapter 11: Combining Mods — Complete Workflow](11_COMBINING_MODS_WORKFLOW.md)** — step-by-step guide (preparation → AI generation → save → deploy)

---

## I'm a new mod author

You want to create something and share it with the community.

1. **[Chapter 01: Basics](01_BASICS.md)** — QML fundamentals, folder structure, how Traktor loads files
2. **[Chapter 02: API Reference](02_API_REFERENCE.md)** — control value paths, copy-paste code patterns
3. **[Chapter 08: Sharing Changes](08_SHARING_CHANGES.md)** — how to package and publish your work
4. **[Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md)** — how to structure your mod so users can apply individual features, and so AI tools can combine your mod with others automatically

The format in Chapter 09 — one markdown file per feature, semantic version tags in git — means your users can pick just the features they want, and understand exactly what changed in each release.

---

## I have an existing mod and want to adopt these conventions

Right now most Traktor mods are shared as ZIP files with no feature listing, no version history, and no way to apply just one part. When you release an update, users have no idea what changed.

Two changes fix this:

**1. Use git and semantic version tags** — tag your releases (`v1.2.3`). Users can then run `git diff v1.2.2..v1.2.3` to see exactly what changed. No changelog needed — the diff _is_ the changelog.

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

**Why this matters for your users:**

- They can apply just the features they want
- AI tools (Claude, Copilot) can read your feature files and combine mods automatically — tracking exactly which version of which feature came from your mod
- Conflict detection is visible before anyone starts editing

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
