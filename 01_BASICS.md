# Basics: QML in Traktor Mods

**Purpose**: Beginner-friendly intro to QML syntax, Traktor architecture, and safe install/backup/restore workflow
**Use when**: Setting up changes for the first time or learning how Traktor's QML folder is organized

🧭 **Navigation** — ← [00_HANDBOOK.md](00_HANDBOOK.md) | **You are here** | → [02_API_REFERENCE.md](02_API_REFERENCE.md) | 📖 [Troubleshooting: 04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)

## For MIDI Mappers: Why QML?

If you've created MIDI mappings in Traktor Pro, you already understand how controllers work:

- **MIDI Mapping**: You map hardware buttons/encoders to Traktor functions (via mapping panel)
- **QML Modding**: You edit the same logic, but _visually_ (editing code instead of UI)

Think of QML as "MIDI mapping on steroids"—you can do everything the mapping panel does, plus:

- Add custom screen layouts and visual feedback
- Create complex multi-button logic (long-press, double-tap)
- Create reusable configuration systems
- Access Traktor's entire internal state (not just MIDI CCs)

This guide translates MIDI concepts to QML so you can leverage your existing knowledge.

---

## Musician's Glossary: QML in Plain English

Before diving in, here's a quick translation of the core QML concepts you'll see:

| Jargon                        | What Musicians Call It         | What It Does                                                                                              |
| ----------------------------- | ------------------------------ | --------------------------------------------------------------------------------------------------------- |
| **AppProperty**               | A connection to Traktor's data | Lets you read or write information like "Deck 1's BPM," "is playing," or "track title"                    |
| **Wire**                      | A "when X, do Y" instruction   | Connects an event (button press) to an action (load track, toggle sync, etc.)                             |
| **Binding**                   | A "keep these in sync" rule    | Automatically copies a value from one place to another; if the source changes, the copy updates instantly |
| **Value Converter / Adapter** | A translator                   | Transforms one type of signal into another (e.g., encoder rotation into volume change)                    |
| **Control Value Path**        | An address for Traktor's data  | A name/reference like `app.traktor.decks.1.tempo` meaning "Deck 1's BPM"                                  |
| **MappingProperty**           | A controller-specific setting  | Information about your controller setup, like "Shift button is pressed" or "Browse mode is active"        |

**See also**: [Chapter 07: Glossary](07_GLOSSARY.md) for detailed definitions.

---

## What Can I Change? (Concrete Example)

Let's start with something concrete: **Make a button do something different**.

### Example: Change SYNC to NOSYNC

Imagine you want to change what the SYNC button does. Here's the real-world workflow:

**What you're doing:**

1. Find the QML file that controls the SYNC button (it's in `CSI/[ControllerName]/`)
2. Locate the instruction that says "when SYNC is pressed, do this"
3. Change "do this" to something else

**Real code looks like:**

```qml
Wire {
    from: "%surface%.sync"           // ← When SYNC button is pressed
    to: someAction                  // ← Do this action
}
```

To change what SYNC does, you'd replace `someAction` with a different action (or a `ButtonScriptAdapter` with custom code).

**Why this matters:**

- You're not learning QML in the abstract—you're editing real instructions that control your hardware.
- Every button, encoder, and screen element follows this same pattern: "when this happens, do that."
- Once you understand one button, you can understand all of them.

**Next step:** After you understand the architecture below, come back to [Chapter 02: API Reference](02_API_REFERENCE.md#file-locations-quick-map) to find the exact files and property paths for your controller.

---

This is the "basics" section of the handbook.

- API reference & patterns: [02_API_REFERENCE.md](02_API_REFERENCE.md)
- Real-world examples to learn from: [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) → [X1MK3 Performance Mod](https://github.com/lsmith77/X1MK3_PerformanceMod)
- Community mods & complete projects: [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md)
- Troubleshooting (debugging + testing): [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)
- Version compatibility + known fixes: [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)
- How to package & share mods: [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md)

---

This is a **beginner-friendly** introduction to how QML is used inside Traktor controller mods.

Scope (on purpose):

- Covers the QML syntax you need for most mods
- Covers Traktor’s `qml` folder structure
- Covers **install / backup / restore** workflows
- Does **not** try to teach advanced QML/Qt (links are provided)

---

## Understanding Traktor's Architecture

### The Three Layers

```
┌─────────────────────────────────────────────────────┐
│  CSI (Controller Surface Interface)                 │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│  • Maps hardware buttons/encoders to functions      │
│  • Files: CSI/[Controller]/*.qml                    │
│  • Controls: What buttons DO                        │
└─────────────────────────────────────────────────────┘
            ↓ Reads from / Writes to
┌─────────────────────────────────────────────────────┐
│  Defines (Configuration & Preferences)              │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│  • Global settings, constants, enums                │
│  • Files: Defines/*.qml                             │
│  • Controls: Configuration values                   │
└─────────────────────────────────────────────────────┘
            ↓ Provides data to
┌─────────────────────────────────────────────────────┐
│  Screens (Visual Display)                           │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│  • Layout, colors, fonts, waveforms                 │
│  • Files: Screens/[Controller]/*.qml                │
│  • Controls: What users SEE                         │
└─────────────────────────────────────────────────────┘
```

### Key Concepts

| Component                 | Purpose                                 | Example                                  |
| ------------------------- | --------------------------------------- | ---------------------------------------- |
| **Traktor Control Value** | Read/write Traktor's internal state     | Deck tempo, track title, play state      |
| **Controller Setting**    | Controller mapping configuration        | Shift state, browse mode settings        |
| **Connection**            | Connect hardware control to function    | Button press → Load track                |
| **Value Converter**       | Transform data between hardware and app | Encoder rotation → Volume change         |
| **Timer**                 | Delayed or repeated actions             | Auto-hide overlay after 5 seconds        |
| **Button Handler**        | Custom button logic                     | Multi-function: single/double/long-press |
| **Control Group**         | Group connections with enable/disable   | Shift mode: enable different set         |

---

## The Traktor `qml` folder

Traktor’s QML files are inside the application install.

- macOS (typical): `/Applications/Native Instruments/Traktor Pro 4.app/Contents/Resources/qml`
  - Finder: right click the app → “Show Package Contents” → `Contents/Resources/qml`
- Windows (typical): `C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml`

Traktor loads QML on startup, so:

- Always **quit Traktor** before editing
- After edits, **restart Traktor** to see changes

---

## The Traktor QML directory structure

High-level structure:

- `CSI` — controller mappings and logic (“what the hardware does”)
- `Defines` — shared constants, enums, preferences, small building blocks
- `Screens` — UI and screen layouts (“what you see”)

If you’re new, these rules-of-thumb help:

- Want to change a button/encoder action? Start in `CSI/...`
- Want to change what’s drawn on a screen? Start in `Screens/...`
- Want a global setting you can reuse everywhere? Put it in `Defines/...`

### What are `qmldir` files?

Some folders contain a file named `qmldir`. It’s a Qt/QML “module index” that lets other QML files import that folder as a module.

Practical takeaway: if you add a new shared component/singleton, you may need to register it in a `qmldir` file.

---

## QML Essentials (the 20% you need to know)

You don't need to learn all of QML—just the basics that Traktor uses. Here's what professionals use most.

### The Four Concepts You'll Use 80% of the Time

| Concept             | MIDI Analogy             | QML Example                      |
| ------------------- | ------------------------ | -------------------------------- |
| **Property**        | MIDI CC value or state   | `enabled: deck.is_playing`       |
| **Automatic Link**  | MIDI conditional mapping | `visible: deck.is_playing`       |
| **Connection**      | MIDI assignment          | Button press → Load track action |
| **Value Converter** | MIDI transformer/script  | Convert 0-127 to 0-100% volume   |

### 1) Imports

At the top of a QML file you’ll see imports, e.g.

```qml
import QtQuick 2.0
import CSI 1.0
```

Traktor versions may differ in the exact QtQuick import version. When porting between versions, keep imports consistent with the target version’s stock files.

**MIDI Mapper's Note**: Think of imports as "load the modules you need" — just like Traktor's mapping panel loads the device definition for your controller.

### 2) Components and nesting (Building Blocks)

QML is a tree of components:

```qml
Rectangle {
    Text { text: "Hello" }
}
```

Curly braces define a component instance; nested blocks are children.

### 3) Properties

Properties store values:

```qml
property bool shift: false
property int deckId: 1
property string label: "SYNC"
```

### 4) Bindings (values that automatically update)

Bindings are “live expressions”:

```qml
visible: shift
text: shift ? "SHIFT" : "NORMAL"
```

### 5) Signals / handlers

Handlers react to events:

```qml
onValueChanged: {
    // JavaScript runs when a property changes
}
```

### 6) IDs

`id` lets you reference an object elsewhere in the same QML file:

```qml
Timer { id: overlayCountdown; interval: 3000 }
```

---

## Key Terms & Glossary References

This section defines the core concepts you'll see throughout the handbook. For detailed definitions, see [07_GLOSSARY.md](07_GLOSSARY.md).

**Essential QML concepts:**

- **Property**: A named value on a component (e.g., `visible: true`, `id: myButton`)
- **Binding**: A property that automatically updates when its expression changes (e.g., `visible: shift.value`)
- **Signal / Handler**: An event and the code that reacts to it (e.g., `onPressed: { ... }`)
- **Component**: A reusable QML element (e.g., `Rectangle`, `Text`, `Module`)

**Traktor-specific concepts:**

- **Traktor Control Value**: A bridge to Traktor's internal state (play status, track name, tempo) — see [02_API_REFERENCE.md](02_API_REFERENCE.md#appproperty)
- **Connection**: Links a hardware control to an action or property — see [02_API_REFERENCE.md](02_API_REFERENCE.md#wire)
- **Value Converter**: A component that transforms data in a connection (e.g., turn encoder rotation into volume change) — see [02_API_REFERENCE.md](02_API_REFERENCE.md#adapters-example-buttonscriptadapter)
- **Condition**: A rule on a connection that controls whether it's active (used for "shift layers") — see [02_API_REFERENCE.md](02_API_REFERENCE.md#wire)
- **Controller Setting**: Controller-mapping configuration like shift state or mode flags — see [02_API_REFERENCE.md](02_API_REFERENCE.md#mappingproperty)

**Workflow terms:**

- **Customization Package**: A mod packaged as only the files it changes (smaller, easier to share) — see [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md)
- **Restore**: Rolling back to a previously backed-up state when changes don't work
- **Deck ID**: The deck number (1–4) that a piece of logic targets

For a complete glossary, see [07_GLOSSARY.md](07_GLOSSARY.md).

---

## Recommended IDE Setup

### Code Editor with QML Syntax Highlighting

Editing QML files in a plain text editor is error-prone. Use an IDE with QML syntax highlighting to catch typos, missing braces, and incorrect property names before you restart Traktor.

**Recommended editors:**

- **VS Code** (macOS/Windows/Linux) — Free, lightweight
  - Install extension: "QML" by Qt tools (or "Qt for Python")
  - (Optional) Install AI assistant: GitHub Copilot, Copilot Chat, or Claude (via extension)
  - Enables syntax highlighting, basic error detection, and code completion
- **JetBrains QML Studio** — Professional QML IDE, free community edition
  - Built-in AI assistant support (with JetBrains AI Assistant subscription)
- **Qt Creator** — Official Qt IDE, heavier but very powerful
  - Built-in QML linter and refactoring tools
  - (Optional) IDE can be paired with external AI tools for code review
- **Sublime Text** — Fast editor with QML plugins available
  - (Optional) AI assistant extensions available

**Why it matters**: Syntax errors (missing `}`, forgotten commas, typos) cause Traktor to fail silently without warnings. Highlighting makes these visible immediately.

### QML Linter

A linter analyzes QML code and reports issues before you test in Traktor. Choose one of three practical options below.

#### Option A: qml-linter (Command Line — Recommended for simplest setup)

**Installation:**

- **macOS**:

  ```bash
  pip3 install qml-linter
  ```

- **Windows**:
  1. Install Python 3 from https://www.python.org/downloads/
  2. Open Command Prompt and run: `pip install qml-linter`

**Usage:**

```bash
qml-linter ./qml/ --output-format compact
```

**Best for**: Musicians who want a quick, standalone command-line tool.

#### Option B: VS Code QML Extension (Visual — Real-time feedback)

**Installation:**

1. Install VS Code (https://code.visualstudio.com/)
2. Open VS Code → Extensions (Cmd+Shift+X / Ctrl+Shift+X)
3. Search for "QML" and install "QML" by Qt Tools
4. Open your `/qml/` folder as a workspace

**Usage:**

- Errors appear in **Problems panel** (View → Problems, or Cmd/Ctrl+Shift+M)
- Red squiggles appear inline as you edit

**Best for**: Musicians using VS Code who want real-time feedback while editing.

#### Option C: qmllint (Qt Official Tool)

`qmllint` is included with Qt Creator. Download it from https://www.qt.io/download-qt-tools (Community Edition, free).

Once installed:

- **macOS**: `/Applications/Qt Creator.app/Contents/MacOS/qmllint`
- **Windows**: `C:\Qt\Tools\QtCreator\bin\qmllint.exe`

**Usage:**

```bash
qmllint -I ./Defines ./qml/
```

**Best for**: Access to the most powerful type checking available.

#### Comparison

| Feature       | qml-linter     | VS Code QML          | qmllint                        |
| ------------- | -------------- | -------------------- | ------------------------------ |
| Setup Time    | 2 minutes      | 5 minutes            | ~1 hour (includes Qt download) |
| CLI-Friendly  | ✅ Yes         | ⚠️ GUI only          | ✅ Yes                         |
| Real-time     | ❌ Run command | ✅ Yes (as you type) | ❌ Run command                 |
| Type Checking | ⭐⭐⭐         | ⭐⭐⭐               | ⭐⭐⭐⭐⭐                     |

**Quick start**: Not sure? Use Option A (2-minute pip install).

### AI Assistant Extensions (Optional)

An AI code assistant accelerates development by providing real-time suggestions, code review, and explanations directly in your editor.

**Available in VS Code:**

- **GitHub Copilot** or **Copilot Chat** — Real-time code suggestions and multi-line completions for QML
- **Claude for VS Code** — Claude directly in your editor for code review, explanations, and debugging
- **ChatGPT** — ChatGPT plugin available in VS Code marketplace

**How it helps:**

- Get real-time code completions as you type QML
- Ask the AI to explain QML syntax, patterns, or suggest refactoring approaches
- Receive context-aware code generation for common Traktor QML patterns
- Get instant code review without waiting for manual feedback

**Why it matters**: An AI assistant helps you **write code faster and understand patterns** by providing immediate, context-aware suggestions. Use it alongside the linter for comprehensive development support.

**Create custom features in plain English**: Beyond real-time suggestions, you can use AI to design entirely new features. See [prompts/create-feature.md](prompts/create-feature.md) — describe what you want (e.g., _"Pressing PLAY while playing triggers a vinyl brake"_), and get production-ready code + documentation + test checklist. See [Chapter 10: Prompt Templates](10_PROMPT_TEMPLATES.md) for the full workflow.

---

## Install / backup / restore (the safe workflow)

> **Disclaimer:** The install-traktor-mod scripts referenced here are vibe coded via AI with minimal code review. Use with caution and review scripts before production use.

**The script automates backup, installation, and restoration.** It works on macOS and Windows and prevents the most common mistakes (incomplete installs, missing files).

**Setup** (one-time): See [08_SHARING_CHANGES.md — Setup](08_SHARING_CHANGES.md#setup-install-script-to-system-path-one-time-setup) to add the script to your PATH.

**Quick reference** (from any mod directory):

```bash
install-traktor-mod              # Install: merge mod into current qml
install-traktor-mod --fresh      # Fresh: reset to stock, then install mod
install-traktor-mod --symlink    # Symlink: use/edit files directly from mod repo
install-traktor-mod restore      # Restore: reset to stock qml, remove all mods
```

Flags can be combined (e.g., `install-traktor-mod --fresh --symlink`).

**Full documentation**: See [08_SHARING_CHANGES.md — Testing your overlay mod](08_SHARING_CHANGES.md#testing-your-overlay-mod) for how the script manages backups, all modes, and troubleshooting.

---

## Development Setup Tip: Organization for AI-Assisted Mods

### The Pattern: Develop Inside the Handbook Directory

If you're using AI assistants (Claude, Copilot, etc.) to help develop mods, organize your work like this:

**Setup**:

1. Create a directory for your mod **inside this handbook repository**
   - Example: `my-d2-mod/`, `my-x1-custom/`, etc.
2. Structure it like [traktor-kontrol-d2](traktor-kontrol-d2/):

   ```
   my-d2-mod/
   ├── qml/                    # The actual mod files
   │   ├── CSI/
   │   ├── Defines/
   │   └── Screens/
   ├── .claude/                # Claude-specific context (optional)
   ├── my-feature.md           # Feature documentation
   └── README.md               # Quick start & overview
   ```

3. The `.gitignore` already ignores it:
   ```
   */                          # Ignore everything by default
   !prompts/                   # Except prompts/ and main docs
   ```

**Why this works**:

- **AI has full context**: Your AI assistant can read all handbook chapters while analyzing your mod code
- **No external context switching**: Everything is in one workspace (handbook + your mod + mod docs)
- **Versioning**: As you develop, git diff shows exactly what changed
- **Symlink option**: On macOS/Linux, create a symlink from Traktor's `qml` → your `my-mod/qml/` for live testing without copying back and forth

**Example: Set up symlink mode (macOS/Windows)**:

Use the included `install-traktor-mod` script to create a symlink. Install instructions, all available modes, and detailed workflows are documented in [Chapter 08: Sharing Changes](08_SHARING_CHANGES.md#testing-your-overlay-mod).

**Pro tip for AI workflows**:

When asking Claude or Copilot for help, include this in your prompt:

> I'm developing a mod in `./my-d2-mod/qml/` inside this handbook repo.
> The handbook documents are in Chapters 01-11. Reference them by name (e.g., "see 02_API_REFERENCE.md") as they're in the same repo context.

This tells the AI that handbook chapters are nearby and available for reference during development.

---

## Where to learn more QML (3rd party guides)

When you hit the limits of this basics guide:

- Qt’s official QML docs: https://doc.qt.io/
- QML language concepts (properties, bindings, signals): search “Qt QML properties binding signals”

Traktor modding adds Traktor-specific building blocks on top of QML — those are documented in [02_API_REFERENCE.md](02_API_REFERENCE.md).

---

## Modification Risk Assessment & Pre/Post Checklist

### Before You Modify

```
□ Backup original qml folder
□ Know which file to edit
□ Understand the change
□ Have rollback plan
```

### Low Risk (Safe to modify)

- Prefs.qml values
- Color definitions (Screens/Defines/Colors.qml)
- Font sizes (Screens/Defines/Font.qml)
- Timer intervals (overlay timeouts)
- Margin values (Screens/Defines/Margins.qml)

### Medium Risk (Test carefully)

- Header layout (DeckHeader.qml)
- Browser footer (BrowserFooter.qml)
- Waveform settings (Waveform.qml)
- Widget positioning
- Visual element arrangement

### High Risk (Backup first)

- Deck_S8Style.qml (core deck logic)
- Mixer.qml (controller behavior)
- Wire connections (button/encoder mappings)
- AppProperty paths
- State machine logic

### After You Modify

```
□ Save file
□ Restart Traktor
□ Test specific feature
□ Check for errors
□ Document change
```

---

**Next:** [02_API_REFERENCE.md](02_API_REFERENCE.md)
