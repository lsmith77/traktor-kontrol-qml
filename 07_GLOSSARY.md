# Glossary

**Purpose**: Quick reference definitions for QML, Traktor, and modding terms
**Use when**: You encounter an unfamiliar term and need a one-line definition

---

🧭 **Navigation** — ← [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md) | **You are here** | → [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) | 📖 [Basics: 01_BASICS.md](01_BASICS.md)
Short definitions for common terms you’ll see when working with Traktor QML mods.

## Traktor + modding

- **QML**: A UI and logic language from Qt. Traktor uses it to define controller behavior and screen layouts.
- **QML Mod**: A folder containing a `qml/` subdirectory with changes to Traktor's controller setup. Can be partial (only changed files) or a full copy. Structure: `MyMod/qml/{CSI,Screens,Defines}...`. When installed, the mod's `qml/` contents are merged into Traktor's `qml/` folder.
- **Customization Package Install**: Installing a mod by copying its files "on top of" a complete base controller setup, overwriting only the files it changes. Safer because your other customizations stay intact.
- **Base version**: The Traktor version a mod was built for. Overlay mods often require a specific base to work.

## Folder structure

- **`qml``**: The folder inside a Traktor installation containing all the QML files that control your hardware. Changes here customize button behavior, screen layout, and visual feedback.
- **`CSI`**: Where hardware button and encoder behavior is defined. "What the hardware does." Buttons, encoders, control pathways, signal transformation.
- **`Screens`**: “What you see.” Layouts, colors, fonts, waveform UI, browser columns.
- **`Defines`**: Shared definitions. Constants, enums, preferences/singletons, shared helper components.
- **`qmldir`**: A module index file that enables `import`-ing a folder as a QML module.

## Core QML concepts

- **Component**: A QML element like `Rectangle`, `Text`, or a Traktor-specific component.
- **Property**: A named value on a component, e.g. `visible: true` or `property int deckId: 1`.
- **Binding**: A property value defined by an expression that updates automatically. Like an "assignment" in MIDI logic—when the condition changes, the property updates. Example: `visible: shift.value` (show this button only when Shift is pressed).
- **Signal / handler**: An event and the code that reacts to it, e.g. `onTriggered: { ... }`.
- **`id`**: A local name you can use to reference an object within the same QML file.

## Traktor-specific building blocks

- **`AppProperty`**: A bridge to Traktor's internal state. Reads/writes values you can control in Traktor, like deck play state, track name, or tempo. You reference them by a `path` like `app.traktor.decks.1.play` (deck 1's play button status).
- **AppProperty path**: The string that identifies a Traktor state value you can read/write.
- **`MappingProperty`**: A property exposed by Traktor’s mapping layer (often used for mode flags).
- **`Wire`**: Connects a source (`from`) to a destination (`to`). Think of it like a MIDI assignment or mapping in Traktor—you say "when this button is pressed, do that action." Wires link hardware controls to functions.
- **Adapter**: A component used in a `Wire` when you need custom logic or data transformation. Examples: convert button presses into toggles, scale encoder rotation to volume change, create multi-touch logic (single-press vs long-press). Similar to a MIDI transformer or script in Traktor's mapping.

## Mapping layer concepts

- **`mapping.state`**: Transient mapping state. Resets when a controller disconnects or Traktor restarts.
- **`mapping.settings`**: Persistent mapping settings. Survives restarts; commonly used for user preferences stored in mappings.
- **`propertiesPath`**: A variable some mods use to point at a mapping root (often `mapping.state`).
- **`settingsPath`**: A variable some mods use to point at a persistent mapping root (often `mapping.settings`).
- **`enabled:`**: A condition used on connections to decide whether they're active. Think of it as a shift layer or conditional mapping—the wire only works when the condition is true. Example: "only mute stems when in Stem mode."
- **`WiresGroup`**: Groups multiple wires behind a single `enabled:` gate. Like a mapping shift layer—all wires in the group activate/deactivate together based on the condition.

## Common workflow terms

- **Deck ID**: Which deck (1–4) a piece of logic applies to.
- **Restart required**: Traktor loads QML at startup; changes usually require quitting and reopening Traktor.
- **Rollback**: Restoring your backed-up `qml` folder to undo changes.
- **Terminal / Command line**: A text-based interface to your computer's file system and programs. On macOS, it's called "Terminal"; on Windows, it's "Command Prompt" or "PowerShell". Instead of clicking folders in Finder, you type commands like `cd folder_name` to navigate and run scripts.

---

**Next:** [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md)
