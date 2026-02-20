# Basics: QML in Traktor Mods

**Purpose**: Beginner-friendly intro to QML syntax, Traktor architecture, and safe install/backup/restore workflow
**Use when**: Setting up changes for the first time or learning how Traktor's QML folder is organized

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

This is the "basics" section of the handbook.

- API reference & patterns: [02_API_REFERENCE.md](02_API_REFERENCE.md)
- Examples (copy/adapt real code): [03_PRACTICAL_EXAMPLES.md](03_PRACTICAL_EXAMPLES.md)
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

| Component               | Purpose                                    | Example                                  |
| ----------------------- | ------------------------------------------ | ---------------------------------------- |
| **AppProperty**         | Read/write Traktor's internal state        | Deck tempo, track title, play state      |
| **MappingProperty**     | Controller mapping configuration           | Shift state, browse mode settings        |
| **Wire**                | Connect hardware control to function       | Button press → Load track                |
| **PropertyAdapter**     | Transform data between hardware and app    | Encoder rotation → Volume change         |
| **Timer**               | Delayed or repeated actions                | Auto-hide overlay after 5 seconds        |
| **ButtonScriptAdapter** | Custom button logic                        | Multi-function: single/double/long-press |
| **WiresGroup**          | Group wires with enable/disable conditions | Shift mode: enable different wire set    |

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

| Concept      | MIDI Analogy             | QML Example                      |
| ------------ | ------------------------ | -------------------------------- |
| **Property** | MIDI CC value or state   | `enabled: deck.is_playing`       |
| **Binding**  | MIDI conditional mapping | `visible: deck.is_playing`       |
| **Wire**     | MIDI assignment          | Button press → Load track action |
| **Adapter**  | MIDI transformer/script  | Convert 0-127 to 0-100% volume   |

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

- **AppProperty**: A bridge to Traktor's internal state (play status, track name, tempo) — see [02_API_REFERENCE.md](02_API_REFERENCE.md#appproperty)
- **Wire**: Connects a hardware control to an action or property — see [02_API_REFERENCE.md](02_API_REFERENCE.md#wire)
- **Adapter**: A component that transforms data in a Wire connection (e.g., `ButtonScriptAdapter`) — see [02_API_REFERENCE.md](02_API_REFERENCE.md#adapters-example-buttonscriptadapter)
- **enabled:**: A condition on a Wire that controls whether it's active (used for "shift layers") — see [02_API_REFERENCE.md](02_API_REFERENCE.md#wire)
- **MappingProperty**: Controller-mapping configuration like shift state or mode flags — see [02_API_REFERENCE.md](02_API_REFERENCE.md#mappingproperty)

**Workflow terms:**

- **Overlay**: A mod packaged as only the files it changes (smaller, easier to share) — see [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md)
- **Restore**: Rolling back to a previously backed-up state when changes don't work
- **Deck ID**: The deck number (1–4) that a piece of logic targets

For a complete glossary, see [07_GLOSSARY.md](07_GLOSSARY.md).

---

## Install / backup / restore (the safe workflow)

**Note on terminal examples below**: The steps can be done via Finder, but terminal examples are also provided for speed and precision. A terminal is a text-based command interface (macOS: "Terminal" app; Windows: "Command Prompt" or "PowerShell"). Simply copy & paste the command lines shown.

### Back up first

Before you change anything, copy Traktor's `qml` folder somewhere safe (see ["The Traktor `qml` folder"](#the-traktor-qml-folder) above for the path on your system).

**Tip:** There is a [GitHub repository](https://github.com/lsmith77/traktor-kontrol-qml-files) that offers a tag for each Traktor Pro release (since version 4.4.1), containing the stock `qml` directory for that release. This can be useful for reference or restoring stock files, but does not replace your own backup.

**Note:** These backups do not help if a Traktor Pro update is installed, as updates overwrite the `qml` folder. However, Native Access automatically creates a backup of the previous Traktor install, which can help restore your setup after an update.

**macOS terminal:**

```bash
cd "/Applications/Native Instruments/Traktor Pro 4.app/Contents/Resources"
cp -r qml qml.backup
```

**Windows terminal:**

```bat
cd "C:\Program Files\Native Instruments\Traktor Pro 4\Resources64"
xcopy qml qml.backup /E /I /H
```

### Install a mod (overlay approach)

Most community mods are not complete replacements; they are **overlays**:

1. Start from the correct stock `qml` base (matching the Traktor version the mod targets)
2. Copy the mod’s files over the base `qml`, overwriting when asked
3. Keep all files the mod doesn’t replace

This avoids missing-file crashes.

#### macOS note: “overlaying” folders (Merge vs Replace)

On macOS, copying a folder on top of another can be confusing because the dialog offers actions like **Replace** (dangerous if it replaces the whole folder).

Two safe approaches:

**Option A (Finder): merge folders, replace files**

- Copy the mod’s _contents_ into the target `qml` (not the other way around).
- When Finder asks about folders, choose **Merge** (keeps files the mod doesn’t include).
- When Finder asks about individual files, choose **Replace** for the files you actually want to override.

**Option B (Terminal): use `rsync` to merge an overlay**

If the mod overlay is a folder that contains `CSI`, `Defines`, `Screens` (etc.), you can merge it into the target `qml` (see ["The Traktor `qml` folder"](#the-traktor-qml-folder) for your path):

```bash
sudo rsync -a "path/to/mod-overlay/" \
  "/Applications/Native Instruments/Traktor Pro 4.app/Contents/Resources/qml/"
```

Notes:

- The trailing `/` on the source path matters: it copies the _contents_ of the overlay.
- `sudo` is often required because Traktor’s `qml` is inside the app bundle.

### Restore stock QML files

If Traktor fails to start or screens break, restore from your backup (see ["The Traktor `qml` folder"](#the-traktor-qml-folder) for the path on your system):

**macOS terminal:**

```bash
cd "/Applications/Native Instruments/Traktor Pro 4.app/Contents/Resources"
rm -rf qml
mv qml.backup qml
```

**Windows terminal:**

```bat
cd "C:\Program Files\Native Instruments\Traktor Pro 4\Resources64"
rmdir /s qml
move qml.backup qml
```

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
