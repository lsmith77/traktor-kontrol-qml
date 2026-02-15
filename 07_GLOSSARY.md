# Glossary

**Purpose**: Quick reference definitions for QML, Traktor, and modding terms
**Use when**: You encounter an unfamiliar term and need a one-line definition
Short definitions for common terms you’ll see when working with Traktor QML mods.

## Traktor + modding

- **QML**: A UI and logic language from Qt. Traktor uses it to define controller behavior and screen layouts.
- **QML mod**: A set of changes to Traktor’s `qml` folder (usually a small overlay of edited files).
- **Overlay install**: Installing a mod by copying its files “on top of” a complete base `qml` folder, overwriting only the files it changes.
- **Base version**: The Traktor version a mod was built for. Overlay mods often require a specific base to work.

## Folder structure

- **`qml`**: The folder inside the Traktor installation that contains all QML files.
- **`CSI`**: Controller Surface Interface. “What the hardware does.” Buttons, encoders, wiring, adapters.
- **`Screens`**: “What you see.” Layouts, colors, fonts, waveform UI, browser columns.
- **`Defines`**: Shared definitions. Constants, enums, preferences/singletons, shared helper components.
- **`qmldir`**: A module index file that enables `import`-ing a folder as a QML module.

## Core QML concepts

- **Component**: A QML element like `Rectangle`, `Text`, or a Traktor-specific component.
- **Property**: A named value on a component, e.g. `visible: true` or `property int deckId: 1`.
- **Binding**: A property value defined by an expression that updates automatically, e.g. `visible: shift.value`.
- **Signal / handler**: An event and the code that reacts to it, e.g. `onTriggered: { ... }`.
- **`id`**: A local name you can use to reference an object within the same QML file.

## Traktor-specific building blocks

- **`AppProperty`**: A bridge to Traktor’s internal state. Reads/writes values via a `path` like `app.traktor.decks.1.play`.
- **AppProperty path**: The string that identifies a Traktor state value you can read/write.
- **`MappingProperty`**: A property exposed by Traktor’s mapping layer (often used for mode flags).
- **`Wire`**: Connects a source (`from`) to a destination (`to`). Used to link hardware controls to actions/properties. Think of it as a MIDI assignment or mapping in Traktor's mapping panel.
- **Adapter**: A component used in a `Wire` when you need logic or transformation (e.g. scripts, scaling, toggles). Similar to a MIDI transformer or script in Traktor's mapping system.

## Mapping layer concepts

- **`mapping.state`**: Transient mapping state. Resets when a controller disconnects or Traktor restarts.
- **`mapping.settings`**: Persistent mapping settings. Survives restarts; commonly used for user preferences stored in mappings.
- **`propertiesPath`**: A variable some mods use to point at a mapping root (often `mapping.state`).
- **`settingsPath`**: A variable some mods use to point at a persistent mapping root (often `mapping.settings`).
- **`enabled:`**: A condition used on `Wire` / `WiresGroup` to decide whether that connection/group is active. Think of it as a layer or conditional MIDI mapping in Traktor—the wire only works when the condition is true.
- **`WiresGroup`**: Groups multiple wires behind a single `enabled:` gate. Like a mapping shift layer—all wires in the group activate/deactivate together based on the condition.

## Common workflow terms

- **Deck ID**: Which deck (1–4) a piece of logic applies to.
- **Restart required**: Traktor loads QML at startup; changes usually require quitting and reopening Traktor.
- **Rollback**: Restoring your backed-up `qml` folder to undo changes.
