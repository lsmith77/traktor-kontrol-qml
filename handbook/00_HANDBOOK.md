# Traktor QML Modder's Handbook

**Handbook Version**: v1.1.0
**Purpose**: Index and reading guide for the handbook docs
**Use when**: Starting your QML modding journey or navigating between docs

---

🧭 **Navigation** — Start here, then go → [01_BASICS.md](01_BASICS.md)

> **New & Easy**: Want to combine mods without coding? Check out the **Mod Combination System** section below.

---

## Companion Repositories (Recommended Setup)

```bash
git clone https://github.com/lsmith77/traktor-kontrol-qml-files
git clone https://github.com/lsmith77/traktor-logger
```

- **`traktor-kontrol-qml-files/`** — stock Traktor QML baseline for AI comparison and code examples
- **`traktor-logger/`** — real-time debugging dashboard (see [Debugging](#debugging--metadata-collection-tools))

You can also clone community mod repos into subdirectories here — both overlay mods (e.g. [X1MK3_PerformanceMod](https://github.com/lsmith77/X1MK3_PerformanceMod)) and full replacement mods (e.g. [traktor-kontrol-d2](https://github.com/lsmith77/traktor-kontrol-d2)) that ship a complete `qml/` folder.

> **Tip for AI-assisted work**: Always open this handbook folder as your workspace root — even when working on a mod in a subdirectory. This gives the AI access to the API reference, troubleshooting guides, stock QML files, and community mods in one session.

---

## Key Concepts (Quick Definition)

- **Mod**: Any customization you make to your Traktor QML — a single file change or many files combined.
- **Full Replacement Mod**: A mod packaged that was based on ful copy of the Traktor qml directory, designed to replace the qml directory.
- **Overlay Mod**: A mod packaged as only the files it changes, designed to layer on top of your existing setup safely.
- **Overlay Install**: The process of merging an overlay mod into your current QML using the `traktor-mod` script.

**See also**: [Chapter 05 FAQ](05_FAQ.md#whats-the-difference-between-a-mod-and-an-overlay-mod)

---

## Path Format Guide (Copy-Paste Safe Reference)

### File System Paths (Folder & File Locations)

Always use `/` (forward slash) in documentation and terminal commands:

| Format                            | Meaning                                            | Example                          |
| --------------------------------- | -------------------------------------------------- | -------------------------------- |
| `qml/`                            | Absolute folder path (from Traktor install root)   | `~/Traktor 4.4.1/Resources/qml/` |
| `CSI/[ControllerName]/D2.qml`     | **`[Placeholder]` = replace with your controller** | `CSI/X1MK3/D2.qml`               |
| `Screens/[ControllerName]/...`    | Folder path with placeholder                       | `Screens/S4MK3/`                 |
| `~/MyMod/qml/CSI/X1MK3/D2.qml`    | Home directory                                     | `/Users/yourname/MyMod/qml/...`  |
| `C:\Users\YourName\MyMod\qml\...` | Windows path (use `/` in code)                     | Windows file browser shows `\`   |

### Traktor Control / Property Paths (What You Wire To)

These are **data paths** in Traktor (not file paths). Format: dots separate levels.

| Format                                 | Meaning                                       | Example                          |
| -------------------------------------- | --------------------------------------------- | -------------------------------- |
| `app.traktor.decks.DECK_ID.PROPERTY`   | **`DECK_ID`** = 1, 2, 3, or 4 (not a literal) | `app.traktor.decks.1.play`       |
| `app.traktor.browser.BROWSER_ID.state` | **`BROWSER_ID`** = 0 or 1                     | `app.traktor.browser.0.state`    |
| `app.traktor.settings.SETTING_NAME`    | Global setting path                           | `app.traktor.settings.bpm`       |
| `mapping.state.SETTING_NAME`           | User-defined mapping state (persistent)       | `mapping.state.my_custom_toggle` |
| `app.traktor.mix.crossfader`           | Special properties (well-known)               | Direct access (no placeholder)   |

**Key Rule**: Uppercase placeholders like `DECK_ID` = replace with a number. Lowercase like `setting_name` = replace with your chosen name.

### Variable Naming Conventions

| Context           | Convention            | Example                                  |
| ----------------- | --------------------- | ---------------------------------------- |
| Component `id:`   | camelCase (no dashes) | `id: syncButton` not `sync-button`       |
| Property names    | camelCase             | `property bool isPlaying`                |
| AppProperty paths | snake_case + numbers  | `app.traktor.decks.1.play` (established) |
| File names        | PascalCase or snake   | `D2.qml` or `my_custom_screen.qml`       |

---

## How this handbook is organized

**Core modding guides**:

1. [01_BASICS.md](01_BASICS.md) — Basics (QML fundamentals + Traktor's folder structure + install/restore)
2. [02_API_REFERENCE.md](02_API_REFERENCE.md) — API reference (Traktor building blocks + control value paths)
3. [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) — Community mods + working examples (GitHub repos and forum discussions)
4. [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) — Troubleshooting (debugging + testing)
5. [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md) — Compatibility fixes (version-specific issues)

**Advanced guides**:

- How to document mods for sharing: [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md)
- How to combine multiple mods: [11_COMBINING_MODS_WORKFLOW.md](11_COMBINING_MODS_WORKFLOW.md)
- Prompt templates (AI prompts for combining, updating, removing): [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md)

**Appendices**:

- Frequently asked questions: [05_FAQ.md](05_FAQ.md)
- Glossary: [07_GLOSSARY.md](07_GLOSSARY.md)
- Sharing changes: [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md)

## Suggested learning path

**For individual mod creation**:

- Start with [01_BASICS.md](01_BASICS.md)
- Keep [02_API_REFERENCE.md](02_API_REFERENCE.md) open while making changes
- Pick one small change from a [community mod example](03_COMMUNITY_RESOURCES.md) (like X1MK3)
- If a change doesn't work, go to [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)
- For common questions, check [05_FAQ.md](05_FAQ.md)
- If anything breaks after a Traktor update, go to [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)

**For creating a brand-new custom feature**:

- Use the AI prompt template in [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md) → [prompts/create-feature.md](../prompts/create-feature.md)
- Describe what you want (trigger, behavior, configuration)
- Get production-ready code + test checklist
- Reference [02_API_REFERENCE.md](02_API_REFERENCE.md) for control paths and patterns
- Document your feature following [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md)

**For combining multiple community mods**:

- Read [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) to understand the **metadata lock file** pattern
- Follow the complete workflow in [11_COMBINING_MODS_WORKFLOW.md](11_COMBINING_MODS_WORKFLOW.md) (4 phases: preparation, AI generation, save, deploy)
- Use the prompt templates in [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md) with Claude or Copilot to:
  - Gather version information and combine mods ([prompts/combine-mods.md](../prompts/combine-mods.md))
  - Update a mod to a new version ([prompts/update-mod.md](../prompts/update-mod.md))
  - Remove or swap a feature ([prompts/remove-feature.md](../prompts/remove-feature.md))
- Learn from professional implementations in [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md)

**For mod authors creating features for community**:

- Read [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) for the documentation-first approach
- Follow the feature documentation template to create shareable .md files
- Use AI tools (Copilot, Claude) with your documentation to generate code
- See [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real examples
- Use [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) to track and share your mods via git

---

## Debugging & Metadata Collection Tools

Install **[traktor-logger](https://github.com/lsmith77/traktor-logger)** for structured QML logging and a real-time browser dashboard:

```bash
traktor-mod logger pull
traktor-mod --source ~/.traktor-mod/traktor-logger
traktor-mod logger api D2   # wire metadata collection (one controller only)
traktor-mod server start    # open dashboard at http://localhost:8080
```

**Full setup, usage, and examples**: [04_TROUBLESHOOTING.md → Technique 4: Advanced Debugging with HTTP Logger](04_TROUBLESHOOTING.md#technique-4-advanced-debugging-with-http-logger-structured-logging)

---

**Next:** [01_BASICS.md](01_BASICS.md)
