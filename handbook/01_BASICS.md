# Basics: QML in Traktor Mods

**Purpose**: Intro to QML syntax, Traktor architecture, and safe install/backup/restore workflow
**Use when**: Setting up changes for the first time or learning how Traktor's QML folder is organized

🧭 **Navigation** — ← [00_HANDBOOK.md](00_HANDBOOK.md) | **You are here** | → [02_API_REFERENCE.md](02_API_REFERENCE.md) | 📖 [Troubleshooting: 04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)

---

## QML vs MIDI Mapping

QML modding extends what the MIDI mapping panel can do:

- Custom screen layouts and visual feedback
- Complex multi-button logic (long-press, double-tap)
- Reusable configuration systems
- Access to Traktor's full internal state (not just MIDI CCs)

---

## Core Concepts

| Concept                       | In plain terms                 | What It Does                                                                                       |
| ----------------------------- | ------------------------------ | -------------------------------------------------------------------------------------------------- |
| **AppProperty**               | A connection to Traktor's data | Read or write values like Deck 1's BPM, play state, or track title                                 |
| **Wire**                      | A "when X, do Y" instruction   | Connects an event (button press) to an action (load track, toggle sync, etc.)                      |
| **Binding**                   | A "keep these in sync" rule    | Automatically copies a value from one place to another; updates when the source changes            |
| **Value Converter / Adapter** | A translator                   | Transforms one type of signal into another (e.g., encoder rotation into volume change)             |
| **Control Value Path**        | An address for Traktor's data  | A reference like `app.traktor.decks.1.tempo` meaning "Deck 1's BPM"                                |
| **MappingProperty**           | A controller-specific setting  | Information about your controller setup, like "Shift button is pressed" or "Browse mode is active" |

**See also**: [Chapter 07: Glossary](07_GLOSSARY.md) for detailed definitions.

---

## What Can I Change? (Concrete Example)

### Example: Change SYNC to NOSYNC

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

To change what SYNC does, replace `someAction` with a different action (or a `ButtonScriptAdapter` with custom code).

**Next step:** See [Chapter 02: API Reference](02_API_REFERENCE.md#file-locations-quick-map) for the exact files and property paths for your controller.

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

- macOS (typical): `/Applications/Native Instruments/Traktor Pro 4.app/Contents/Resources/qml`
  - Finder: right-click the app → "Show Package Contents" → `Contents/Resources/qml`
- Windows (typical): `C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml`

Always **quit Traktor** before editing. **Restart** to see changes.

---

## The Traktor QML directory structure

- `CSI` — controller mappings and logic ("what the hardware does")
- `Defines` — shared constants, enums, preferences, small building blocks
- `Screens` — UI and screen layouts ("what you see")

Rules of thumb:

- Changing a button/encoder action? Start in `CSI/...`
- Changing what's drawn on a screen? Start in `Screens/...`
- Global setting you want to reuse? Put it in `Defines/...`

### What are `qmldir` files?

A Qt/QML "module index" that lets other QML files import that folder as a module. If you add a new shared component or singleton, you may need to register it in a `qmldir` file.

---

## QML Essentials (the 20% you need)

### Core Concepts

| Concept             | Analogy                  | QML Example                      |
| ------------------- | ------------------------ | -------------------------------- |
| **Property**        | MIDI CC value or state   | `enabled: deck.is_playing`       |
| **Binding**         | MIDI conditional mapping | `visible: deck.is_playing`       |
| **Connection**      | MIDI assignment          | Button press → Load track action |
| **Value Converter** | MIDI transformer/script  | Convert 0-127 to 0-100% volume   |

### 1) Imports

```qml
import QtQuick 2.0
import CSI 1.0
```

Traktor versions may differ in the exact QtQuick import version. When porting between versions, keep imports consistent with the target version's stock files.

### 2) Components and nesting

QML is a tree of components:

```qml
Rectangle {
    Text { text: "Hello" }
}
```

Curly braces define a component instance; nested blocks are children.

### 3) Properties

```qml
property bool shift: false
property int deckId: 1
property string label: "SYNC"
```

### 4) Bindings (values that automatically update)

```qml
visible: shift
text: shift ? "SHIFT" : "NORMAL"
```

### 5) Signals / handlers

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

**Essential QML concepts:**

- **Property**: A named value on a component (e.g., `visible: true`, `id: myButton`)
- **Binding**: A property that automatically updates when its expression changes (e.g., `visible: shift.value`)
- **Signal / Handler**: An event and the code that reacts to it (e.g., `onPressed: { ... }`)
- **Component**: A reusable QML element (e.g., `Rectangle`, `Text`, `Module`)

**Traktor-specific concepts:**

- **Traktor Control Value**: A bridge to Traktor's internal state (play status, track name, tempo) — see [02_API_REFERENCE.md](02_API_REFERENCE.md#appproperty)
- **Connection**: Links a hardware control to an action or property — see [02_API_REFERENCE.md](02_API_REFERENCE.md#wire)
- **Value Converter**: Transforms data in a connection — see [02_API_REFERENCE.md](02_API_REFERENCE.md#adapters-example-buttonscriptadapter)
- **Condition**: A rule on a connection that controls whether it's active (used for "shift layers") — see [02_API_REFERENCE.md](02_API_REFERENCE.md#wire)
- **Controller Setting**: Controller-mapping configuration like shift state or mode flags — see [02_API_REFERENCE.md](02_API_REFERENCE.md#mappingproperty)

For a complete glossary, see [07_GLOSSARY.md](07_GLOSSARY.md).

---

## Recommended IDE Setup

### Code Editor with QML Syntax Highlighting

Syntax errors cause Traktor to fail silently — a QML-aware editor catches them before you restart.

**Recommended editors:**

- **VS Code** (macOS/Windows/Linux) — Install the "QML" extension by Qt Tools
- **JetBrains QML Studio** — Professional QML IDE, free community edition
- **Qt Creator** — Official Qt IDE with built-in QML linter and refactoring
- **Sublime Text** — Fast editor with QML plugins available

### QML Linter

#### Option A: qml-linter (Command Line)

```bash
# macOS
pip3 install qml-linter

# Windows
pip install qml-linter
```

```bash
qml-linter ./qml/ --output-format compact
```

#### Option B: VS Code QML Extension (Real-time feedback)

1. Extensions (Cmd+Shift+X) → search "QML" → install "QML" by Qt Tools
2. Errors appear in the Problems panel; red squiggles inline as you type

#### Option C: qmllint (Qt Official)

Included with Qt Creator (https://www.qt.io/download-qt-tools):

```bash
qmllint -I ./Defines ./qml/
```

#### Comparison

| Feature       | qml-linter     | VS Code QML          | qmllint                            |
| ------------- | -------------- | -------------------- | ---------------------------------- |
| Setup Time    | 2 minutes      | 5 minutes            | 10+ minutes (includes Qt download) |
| CLI-Friendly  | ✅ Yes         | ⚠️ GUI only          | ✅ Yes                             |
| Real-time     | ❌ Run command | ✅ Yes (as you type) | ❌ Run command                     |
| Type Checking | ⭐⭐⭐         | ⭐⭐⭐               | ⭐⭐⭐⭐⭐                         |

Not sure? `qml-linter` is a 2-minute pip install.

### AI Assistant Extensions (Optional)

- **GitHub Copilot / Copilot Chat** — Real-time completions and multi-line suggestions
- **Claude for VS Code** — Code review, explanations, and debugging in-editor
- **ChatGPT** — Plugin available in VS Code marketplace

For designing entire new features from a plain-English description, see [prompts/create-feature.md](../prompts/create-feature.md) and [Chapter 10: Prompt Templates](10_PROMPT_TEMPLATES.md).

---

## Install / backup / restore (the safe workflow)

> **Disclaimer:** The traktor-mod scripts are vibe coded via AI with minimal code review. Use with caution and review scripts before production use.

**Setup** (one-time): See [08_SHARING_CHANGES.md — Setup](08_SHARING_CHANGES.md#setup-install-script-to-system-path-one-time-setup) to add the script to your PATH.

**Quick reference:**

```bash
traktor-mod              # Install: merge mod into current qml
traktor-mod --fresh      # Fresh: reset to stock, then install mod
traktor-mod --symlink    # Symlink: use/edit files directly from mod repo
traktor-mod restore      # Restore: reset to stock qml, remove all mods
```

Flags can be combined (e.g., `traktor-mod --fresh --symlink`).

**Full documentation**: [08_SHARING_CHANGES.md — Testing your overlay mod](08_SHARING_CHANGES.md#testing-your-overlay-mod)

---

## Development Setup: AI-Assisted Mods

Develop your mod **inside the handbook directory** so AI tools can read both your mod code and the handbook docs in one session.

**Setup**:

1. Create a directory for your mod inside this repo (e.g. `my-d2-mod/`)
2. Structure it like [traktor-kontrol-d2](traktor-kontrol-d2/):

   ```
   my-d2-mod/
   ├── qml/                    # The actual mod files
   │   ├── CSI/
   │   ├── Defines/
   │   └── Screens/
   ├── my-feature.md           # Feature documentation
   └── README.md
   ```

3. The `.gitignore` already ignores it (`*/` ignores all subdirectories by default)

When prompting Claude or Copilot, include:

> I'm developing a mod in `./my-d2-mod/qml/` inside this handbook repo.
> The handbook chapters 01-11 are in the same repo — reference them by name.

---

## Where to learn more QML

- Qt's official QML docs: https://doc.qt.io/
- QML language concepts: search "Qt QML properties binding signals"

Traktor-specific building blocks are in [02_API_REFERENCE.md](02_API_REFERENCE.md).

---

## Modification Risk Assessment

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
