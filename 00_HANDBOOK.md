# Traktor QML Modder’s Handbook

**Handbook Version**: v0.8.0  
**Purpose**: Index and reading guide for the handbook docs  
**Use when**: Starting your QML modding journey or navigating between docs

---

🧭 **Navigation** — Start here, then go → [01_BASICS.md](01_BASICS.md)

> **New & Easy**: Want to combine mods without coding? Check out the **Mod Combination System** section below. It's designed for musicians, not programmers.

---

## Key Concepts (Quick Definition)

These three terms will appear throughout the handbook. Here's what they mean:

- **Mod**: Any customization you make to your Traktor QML—could be a single file change or many files combined.
- **Overlay Mod**: How a mod is packaged for sharing—as only the files it changes, designed to layer on top of your existing setup safely.
- **Overlay Install**: The process of merging an overlay mod into your current QML using the `traktor-mod` script.

Example: You make changes to 3 files and package them as an overlay mod. Another user can overlay-install them on top of their own setup, and all their other files stay intact.

**See also**: [Chapter 05 FAQ](05_FAQ.md#whats-the-difference-between-a-mod-and-an-overlay-mod) for more detail.

---

## Path Format Guide (Copy-Paste Safe Reference)

Throughout this handbook, you'll see paths to files and Traktor properties. Here's what each format means:

### File System Paths (Folder & File Locations)

Always use `/` (forward slash), never `\` (backslash):

| Format                            | Meaning                                                   | Example                                |
| --------------------------------- | --------------------------------------------------------- | -------------------------------------- |
| `qml/`                            | Absolute folder path (from Traktor install root)          | `~/Traktor 4.4.1/Resources/qml/`       |
| `CSI/[ControllerName]/D2.qml`     | **`[Placeholder]` = replace with your controller**        | `CSI/X1MK3/D2.qml` (not `X1MK3` alone) |
| `Screens/[ControllerName]/...`    | Folder path with placeholder                              | `Screens/S4MK3/`                       |
| `~/MyMod/qml/CSI/X1MK3/D2.qml`    | Home directory shortcut (macOS/Linux) = your user folder  | `/Users/yourname/MyMod/qml/...`        |
| `C:\Users\YourName\MyMod\qml\...` | Windows (still use `/` in code, but `\` in file explorer) | Windows file browser shows `\`         |

**Key Rule**: In documentation and terminal commands, **always write paths with `/`**, never `\`. If you copy a Windows path, convert `\` → `/`.

### Traktor Control / Property Paths (What You Wire To)

These are **data paths** in Traktor (not file paths). Format: dots separate levels.

| Format                                 | Meaning                                       | Example                          |
| -------------------------------------- | --------------------------------------------- | -------------------------------- |
| `app.traktor.decks.DECK_ID.PROPERTY`   | **`DECK_ID`** = 1, 2, 3, or 4 (not a literal) | `app.traktor.decks.1.play`       |
| `app.traktor.browser.BROWSER_ID.state` | **`BROWSER_ID`** = 0 or 1                     | `app.traktor.browser.0.state`    |
| `app.traktor.settings.SETTING_NAME`    | Global setting path                           | `app.traktor.settings.bpm`       |
| `mapping.state.SETTING_NAME`           | User-defined mapping state (persistent)       | `mapping.state.my_custom_toggle` |
| `app.traktor.mix.crossfader`           | Special properties (well-known)               | Direct access (no placeholder)   |

**Key Rule**: Uppercase placeholders like `DECK_ID` = **replace with a number**. Lowercase like `setting_name` = **replace with your chosen name**.

### Variable Naming Conventions

When you create new properties or IDs, follow these:

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
- How to combine multiple mods (musician's guide): [11_COMBINING_MODS_WORKFLOW.md](11_COMBINING_MODS_WORKFLOW.md)
- Prompt templates (AI prompts for combining, updating, removing): [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md)

**Appendices**:

- Frequently asked questions: [05_FAQ.md](05_FAQ.md)
- Glossary: [07_GLOSSARY.md](07_GLOSSARY.md)
- Sharing changes: [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md)

## Suggested learning path

**For individual mod creation**:

- Start with [01_BASICS.md](01_BASICS.md) (you only need the first half to do safe edits)
- Keep [02_API_REFERENCE.md](02_API_REFERENCE.md) open while making changes
- Pick one small change from a [community mod example](03_COMMUNITY_RESOURCES.md) (like X1MK3)
- If a change doesn't work, go to [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)
- For common questions, check [05_FAQ.md](05_FAQ.md)
- If anything breaks after a Traktor update, go to [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)

**For creating a brand-new custom feature**:

- Use the AI prompt template in [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md) → [prompts/create-feature.md](prompts/create-feature.md)
- Describe what you want in natural language (trigger, behavior, configuration)
- Get production-ready code + test checklist
- Reference [02_API_REFERENCE.md](02_API_REFERENCE.md) for control paths and patterns
- Document your feature following [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md)

**For combining multiple community mods**:

- Read [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) to understand the **metadata lock file** pattern — your key to safe, incremental updates
- Follow the complete workflow in [11_COMBINING_MODS_WORKFLOW.md](11_COMBINING_MODS_WORKFLOW.md) (4 phases: preparation, AI generation, save, deploy)
- Use the prompt templates in [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md) with Claude or Copilot to:
  - Gather version information and combine mods ([prompts/combine-mods.md](prompts/combine-mods.md))
  - Update a mod to a new version ([prompts/update-mod.md](prompts/update-mod.md))
  - Remove or swap a feature ([prompts/remove-feature.md](prompts/remove-feature.md))
- Learn from professional implementations in [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md)
- When mods update, use metadata lock files to understand which components changed and whether you need the update

**For mod authors creating features for community**:

- Read [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) to understand the documentation-first approach used by community feature creators
- Follow the feature documentation template to create shareable .md files
- Use AI tools (Copilot, Claude) with your documentation to generate code
- See [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real examples of documented features
- Use [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) to track and share your mods via git

---

## Debugging & Metadata Collection Tools

The handbook includes integrated debugging and metadata collection tools via `traktor-logger`:

**Quick Start (3 steps)**:

1. **Install Logger** to Traktor's qml:

   ```bash
   traktor-mod logger install
   ```

2. **Enable metadata collection on at least one connected controller**:

   This step is required if you want data in the **Live Metadata** tab. Without API integration on a connected controller, the logger server runs but receives no deck metadata.

   ```bash
   traktor-mod enable-metadata D2,S8,X1MK3
   ```

3. **Start the server**:

   ```bash
   traktor-mod server start
   ```

   `traktor-mod` downloads/updates the server package and can launch it directly via `server start`.

   Open dashboard: http://localhost:8080

**Supported Controllers**: D2, S8, S5, S4MK3, S3, S2MK3, X1MK3, Z1MK2, MX2, CDJ3000, XDJ700, XDJ1000MK2

**What's included**:

- **Automatic metadata**: Track loaded, play/pause, tempo, key, sync, BPM, mixer channels (requires metadata/API integration on a connected controller)
- **Manual logging**: `Logger` QML component for structured debug messages with severity levels
- **Real-time dashboard**: Browser UI with live metadata view and console log viewer
- **Color-coded CLI**: Terminal output with visual severity indicators

**Installation options**:

```bash
# Option 1: Add Logger to a mod
traktor-mod --with-logger

# Option 2: Install Logger standalone (no mod)
traktor-mod logger install

# Option 3: Update Logger + Api modules from GitHub
traktor-mod logger update

# Option 4: Install Logger and start server in one command
traktor-mod logger install && traktor-mod server start
```

**Logger usage in QML**:

```qml
import Traktor.Defines 1.0

Module {
    Logger { id: logger }

    onSomeEvent: {
        logger.info("Event triggered", { deck: 1, state: "playing" })
        logger.debug("Detailed diagnostics", { value: propValue.value })
        logger.error("Something failed", { reason: "timeout" })
    }
}
```

**For complete documentation**:

- **Logger usage & examples**: See [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) → "Technique 4: Advanced Debugging with HTTP Logger"
- **Server/API documentation (primary)**: https://github.com/lsmith77/traktor-logger

**Security note**: Don't log passwords, API keys, or personal data—all logs are visible in the browser dashboard and terminal.

---

## Visual Guide: Emoji System

The handbook uses emoji consistently to aid quick scanning:

| Symbol   | Meaning                                          | Used In                  |
| -------- | ------------------------------------------------ | ------------------------ |
| 🧭       | Quick Navigation section header                  | All main docs            |
| 🟢🟡🟠🔴 | Difficulty rating (Beginner → Advanced → Expert) | Practical Examples       |
| 🎯🔄📊   | Example category icons                           | Practical Examples       |
| ⚡💡🔍✅ | Troubleshooting sections                         | Troubleshooting doc      |
| 📖🗂️🎯   | Guide section categories                         | Practical Examples intro |

Not all sections use emoji — some use **bold titles** instead. Emoji are added where visual scanning speed helps.

---

**Next:** [01_BASICS.md](01_BASICS.md)
