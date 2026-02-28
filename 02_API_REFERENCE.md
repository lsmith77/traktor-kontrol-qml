# Traktor QML API Reference (API + Patterns)

**Purpose**: Complete API reference, file location map, and reusable code templates for Traktor QML
**Use when**: Looking up a property path, understanding how to set up a wire, or finding copy-paste patterns

This is the “API/reference” section of the handbook.

- Basics (syntax + folder layout + install/restore): [01_BASICS.md](01_BASICS.md)
- Community mods & working examples: [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md)
- Troubleshooting (debugging + testing): [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)
- Version compatibility + known fixes: [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)
- How to package & share mods: [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md)

For real-world code examples, see [**Chapter 03: Community Resources**](03_COMMUNITY_RESOURCES.md) for links to working mods and their documentation.

---

## ⚡ Quick Reference (TL;DR for Busy People)

If you already know QML basics and just need a **quick lookup table**:

| I want to...                    | File to edit             | Key building block         |
| ------------------------------- | ------------------------ | -------------------------- |
| Map a button to a function      | CSI/[Controller].qml     | Connection + Control Value |
| Change something on screen      | Screens/[Controller]/... | Rectangle + link           |
| Add a global setting            | Defines/Prefs.qml        | QtObject + Control Value   |
| Transform data (e.g., 0-127→0%) | CSI/[Controller].qml     | Value Converter            |
| React to a button hold          | CSI/[Controller].qml     | Button Handler             |
| Show/hide a component           | Screens/.../...          | visible: link              |
| Store persistent state          | CSI/Common/...           | mapping.settings path      |

**Jump to property paths**: [Common Property Paths](#common-property-paths)  
**Need code template?**: [Common Tasks Cheat Sheet](#common-tasks-cheat-sheet)  
**Full reference below** with explanations and examples.

---

## 🧭 Full Topic Navigation

**1) Orientation (where to edit)**

- [File Locations & Decision Tree](#file-locations-quick-map)
- [When to Use Each Layer](#when-to-use-each-layer)

**2) API reference (Traktor-QML building blocks)**

- [Traktor QML Building Blocks](#traktor-qml-building-blocks)
- [Wire Adapters Quick Reference](#wire-adapters-quick-reference)
- [Common Property Paths](#common-property-paths)

**3) Patterns & templates (copy/paste)**

- [Common Tasks Cheat Sheet](#common-tasks-cheat-sheet) — quick recipes
- [Advanced Patterns & State Management](#advanced-patterns--state-management) — detailed deep dives

**4) Operations & Troubleshooting**

- [Installation Quick Steps](#installation-quick-steps)
- Restore stock QML files: [01_BASICS.md](01_BASICS.md#restore-stock)
- Troubleshooting: [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)

---

## File Locations Quick Map

```
Need to modify...                    → Edit file...
─────────────────────────────────────────────────────────────────
Global preferences                   → Defines/Prefs.qml
Controller button behavior           → CSI/[Controller]/[Controller].qml
Mixer tempo/crossfader               → CSI/[Controller]/Mixer.qml
Deck controls (play, cue, sync)      → CSI/[Controller]/[Controller]Deck.qml
Core deck logic & timers             → CSI/Common/Deck_S8Style.qml
Screen header layout                 → Screens/[Controller]/Views/Deck/DeckHeader.qml
Browser appearance                   → Screens/[Controller]/Views/Browser/*.qml
Colors                               → Screens/Defines/Colors.qml
Fonts                                → Screens/Defines/Font.qml
Waveform settings                    → Screens/[Controller]/Views/Deck/Waveform*.qml
```

### File Decision Tree

```
IF modifying controller behavior:
  → Edit CSI/[ControllerName]/ files
  → Primary: [Controller].qml, [Controller]Deck.qml, Mixer.qml

IF modifying visual display:
  → Edit Screens/[ControllerName]/Views/ files
  → Primary: DeckHeader.qml, BrowserFooter.qml, TrackDeck.qml

IF adding global preferences:
  → Edit/create Defines/Prefs.qml
  → Register in Defines/qmldir

IF modifying timing/behavior logic:
  → Edit CSI/Common/Deck_S8Style.qml (shared across controllers)
```

### File Type Recognition

**CSI Controller Mapping** - Look for:

```qml
Module {
    Wire { from: "%surface%..."; to: ... }
    AppProperty { path: "app.traktor..." }
    MappingProperty { path: "mapping..." }
}
```

**Screen Display** - Look for:

```qml
Rectangle {
    DeckHeaderText { ... }
    anchors { ... }
    color: colors...
}
```

**Preferences** - Look for:

```qml
pragma Singleton
QtObject {
    readonly property ...
}
```

---

## When to Use Each Layer

**CSI Layer** (Controller logic):

- Hardware button mappings
- Encoder behavior
- Controller state management
- Wire connections

**Defines Layer** (Configuration):

- User preferences
- Global constants
- Enums and state definitions
- Module registration

**Screens Layer** (Visual):

- Layout and positioning
- Colors and fonts
- Display text formatting
- UI component styling

---

## Traktor QML Building Blocks

This section describes the Traktor-specific “API surface” you see in mods: how controller events, Traktor state, and UI logic are wired together.

### `Module`

Most CSI/controller mapping files wrap logic inside a `Module { ... }`.

Typical structure:

```qml
Module {
    // 1) Read/write Traktor state
    AppProperty { id: playing; path: "app.traktor.decks." + deckId + ".play" }

    // 2) Connect hardware to actions
    Wire { from: "%surface%.deck.play"; to: playing }
}
```

### `AppProperty`

`AppProperty` is the main way QML talks to Traktor’s internal state.

- Reads: `someProperty.value`
- Writes: often by wiring a control directly “to” the property, or via adapters

Property paths live under `app.traktor...`.

- For the full path catalog, see [Full AppProperty Path Catalog](#full-appproperty-path-catalog)
- For examples of using paths in real code, see [community resources and working mods](03_COMMUNITY_RESOURCES.md)

Common pattern (per-deck):

```qml
property int deckId: 1

AppProperty {
    id: deckPlay
    path: "app.traktor.decks." + deckId + ".play"
}
```

### `MappingProperty`

**What it is**: Controller-mapping configuration (mode flags, shift state, layer selection, etc.)

**How to use**:

```qml
// Common: shift state
MappingProperty { id: shift; path: "mapping.shift" }

// Use in conditional logic
Wire { from: button; to: action; enabled: shift.value }
```

### `Wire`

`Wire` connects a source (`from`) to a destination (`to`). In practice this can mean:

- Hardware event → action/property
- Traktor state → UI element

You’ll commonly see:

```qml
Wire { from: "%surface%.deck.button"; to: someAdapter }
Wire { from: "%surface%.encoder"; to: someProperty }
```

The `enabled:` field is frequently used for “Shift layers”:

```qml
Wire { from: "%surface%.deck.button"; to: actionA; enabled:  shift.value }
Wire { from: "%surface%.deck.button"; to: actionB; enabled: !shift.value }
```

### Adapters (example: `ButtonScriptAdapter`)

**What they are**: Components used in a `Wire` when you need custom logic or transformation

**Pattern**:

```qml
Wire {
    from: "%surface%.button"
    to: ButtonScriptAdapter {
        onPress: { /* custom action */ }
        onRelease: { /* cleanup */ }
    }
}
```

**Common adapters**: `ButtonScriptAdapter`, `EncoderScriptAdapter`, `DirectPropertyAdapter`

### Timers

**What they are**: Delay and polling mechanisms for overlay timeouts, long-press detection, repeated actions

**Pattern**:

```qml
Timer {
    id: overlayHide
    interval: 3000           // milliseconds
    repeat: false            // or true for repeated firing
    onTriggered: { ... }     // action when timer completes
}
```

**Typical intervals**: Overlay timeout = 3000–5000ms, double-tap window = 200–300ms, long-hold = 300–500ms

---

## Common Tasks Cheat Sheet

### 1. Change Timer Duration

```qml
Timer {
    interval: 5000  // ← Change this number (milliseconds)
}
```

**Common timers**:

- Overlay timeout: 3000-5000ms
- Double-tap window: 200-300ms
- Long-hold threshold: 300-500ms

---

### 2. Swap Shift Behavior

```qml
// Find these lines:
Wire { from: "..."; to: "action1"; enabled:  shift }
Wire { from: "..."; to: "action2"; enabled: !shift }

// Swap to:
Wire { from: "..."; to: "action1"; enabled: !shift }
Wire { from: "..."; to: "action2"; enabled:  shift }
```

---

### 3. Add New Preference

**In Defines/Prefs.qml**:

```qml
readonly property bool myNewSetting: true
readonly property int myNumberSetting: 42
readonly property var myListSetting: ["item1", "item2"]
```

**Use anywhere**:

```qml
import "../../Defines"

visible: Prefs.myNewSetting
```

---

### 4. Bind to Traktor Property

```qml
AppProperty {
    id: myProperty
    path: "app.traktor.[category].[id].[property]"
    onValueChanged: {
        // React to changes
    }
}
```

**Common paths**:

```
app.traktor.decks.[1-4].play
app.traktor.decks.[1-4].track.content.title
app.traktor.mixer.channels.[1-4].volume
app.traktor.masterclock.tempo
```

---

### 5. Multi-Function Button

```qml
property bool shift: false

Wire {
    from: "%surface%.deck.button"
    to: ButtonScriptAdapter {
        onPress: {
            if (shift) {
                // Shift+button action
            } else {
                // Normal action
            }
        }
    }
}
```

---

### 6. Change Color

```qml
// Direct color:
color: "#FF0000"  // Red in hex

// From color palette:
import "../Defines/Colors.qml"
color: colors.colorDeckBlueBright

// Conditional:
color: isActive ? colors.colorGreen : colors.colorGray
```

---

### 7. Change Font

```qml
Text {
    font.pixelSize: fonts.scale(13)  // Scaled size
    font.family: "Pragmatica"        // Font name
    font.bold: true                  // Bold
}
```

---

### 8. Position Element

```qml
Rectangle {
    // Anchor to parent edges
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.topMargin: 10
    anchors.leftMargin: 20

    // Or center
    anchors.centerIn: parent

    // Or fill
    anchors.fill: parent
}
```

---

## Property Types Reference

| Type       | Example                         | Use For        |
| ---------- | ------------------------------- | -------------- |
| `int`      | `property int count: 0`         | Whole numbers  |
| `real`     | `property real tempo: 120.5`    | Decimals       |
| `bool`     | `property bool enabled: true`   | True/false     |
| `string`   | `property string name: "Deck"`  | Text           |
| `var`      | `property var items: [1,2,3]`   | Arrays/objects |
| `color`    | `property color bg: "#FFF"`     | Colors         |
| `readonly` | `readonly property int max: 10` | Constants      |

---

## Wire Adapters Quick Reference

| Adapter                   | Use When              | Example        |
| ------------------------- | --------------------- | -------------- |
| `TogglePropertyAdapter`   | Button toggles on/off | Sync, Play     |
| `DirectPropertyAdapter`   | Pass value directly   | Fader, volume  |
| `RelativePropertyAdapter` | Encoder steps         | Browse scroll  |
| `TriggerPropertyAdapter`  | One-time trigger      | Load track     |
| `ButtonScriptAdapter`     | Custom button logic   | Multi-function |
| `EncoderScriptAdapter`    | Custom encoder logic  | Zoom control   |

---

## Common Property Paths

> **Complete reference**: See [Full AppProperty Path Catalog](#full-appproperty-path-catalog) for the full list of all known `AppProperty` paths organized by category (global, browser, deck, track, stem, remix, mixer, effects, settings). The table below covers the most common ones with usage examples.
>
> **Source**: [NI Community Forum - S4MK3/S3 Performance Mod QML Coding](https://community.native-instruments.com/discussion/26956/s4mk3-s3-performance-mod-qml-coding)

### Find Property by Use Case

**Quick lookup: "I want to do X, which property do I need?"**

| I want to...                     | Property Path                                       | Example Usage                                                 |
| -------------------------------- | --------------------------------------------------- | ------------------------------------------------------------- |
| **Playback Control**             |                                                     |                                                               |
| Detect if deck is playing        | `app.traktor.decks.[1-4].play`                      | `visible: deckPlay.value` (show when playing)                 |
| Trigger play/pause               | `app.traktor.decks.[1-4].play`                      | `Wire { to: TogglePropertyAdapter { path: "..." } }`          |
| Check if track is loaded         | `app.traktor.decks.[1-4].is_loaded`                 | `enabled: isLoaded.value` (disable buttons when empty)        |
| Access cue point state           | `app.traktor.decks.[1-4].cue`                       | `to: TriggerPropertyAdapter { path: "..." }`                  |
| **Tempo & Sync**                 |                                                     |                                                               |
| Read/change deck tempo (BPM)     | `app.traktor.decks.[1-4].tempo.absolute`            | `text: deckTempo.value.toFixed(2)` (display BPM)              |
| Read master clock tempo          | `app.traktor.masterclock.tempo`                     | `text: "Master: " + masterTempo.value.toFixed(1)`             |
| Detect sync enabled              | `app.traktor.decks.[1-4].sync.enabled`              | `color: syncEnabled.value ? colors.green : colors.gray`       |
| Get master clock source          | `app.traktor.masterclock.source_id`                 | `visible: masterSource.value === deckId` (show if master)     |
| **Track Information**            |                                                     |                                                               |
| Read track title                 | `app.traktor.decks.[1-4].track.content.title`       | `text: trackTitle.value`                                      |
| Read track artist                | `app.traktor.decks.[1-4].track.content.artist`      | `text: trackArtist.value`                                     |
| Read track BPM                   | `app.traktor.decks.[1-4].track.content.bpm`         | `text: trackBPM.value.toFixed(1) + " BPM"`                    |
| Read track key                   | `app.traktor.decks.[1-4].track.content.musical_key` | `text: trackKey.value` (e.g., "8A", "C Minor")                |
| Get track time remaining         | `app.traktor.decks.[1-4].track.time.remaining`      | `color: timeLeft.value < 30 ? colors.red : colors.white`      |
| Get track elapsed time           | `app.traktor.decks.[1-4].track.time.elapsed`        | `text: formatTime(elapsed.value)`                             |
| **Mixer Controls**               |                                                     |                                                               |
| Control channel volume           | `app.traktor.mixer.channels.[1-4].volume`           | `Wire { to: DirectPropertyAdapter { path: "..." } }`          |
| Control channel filter           | `app.traktor.mixer.channels.[1-4].filter`           | `to: DirectPropertyAdapter { path: "..." }`                   |
| Control crossfader               | `app.traktor.mixer.xfader.adjust`                   | `to: DirectPropertyAdapter { path: "..." }`                   |
| Select FX unit for channel       | `app.traktor.mixer.channels.[1-4].fx.select`        | `to: ButtonScriptAdapter { onPress: { fxSelect.value = 1 } }` |
| **Deck Modes & Features**        |                                                     |                                                               |
| Check deck type (Track/Stem/etc) | `app.traktor.decks.[1-4].type`                      | `visible: deckType.value === DeckType.Track`                  |
| Detect Flux mode enabled         | `app.traktor.decks.[1-4].flux.enabled`              | `brightness: fluxEnabled.value ? 1.0 : 0.0` (LED feedback)    |
| Check if in loop                 | `app.traktor.decks.[1-4].loop.active`               | `color: loopActive.value ? colors.orange : colors.white`      |
| Get loop size                    | `app.traktor.decks.[1-4].loop.size`                 | `text: loopSize.value + " beats"`                             |
| **Browser & Navigation**         |                                                     |                                                               |
| Get selected browser item        | `app.traktor.browser.list_selected_item`            | `text: selectedItem.value`                                    |
| Load track to deck               | `app.traktor.decks.[1-4].load.selected`             | `to: TriggerPropertyAdapter { path: "..." }`                  |
| Browse up/down                   | `app.traktor.browser.list_navigation`               | `to: RelativePropertyAdapter { path: "..." }`                 |
| **Effects**                      |                                                     |                                                               |
| Enable/disable FX unit           | `app.traktor.fx.4fx_units.[1-4].enabled`            | `to: TogglePropertyAdapter { path: "..." }`                   |
| Select FX slot                   | `app.traktor.fx.4fx_units.[1-4].select`             | `onPress: { fxSelect.value = slotNum }`                       |
| Control FX dry/wet               | `app.traktor.fx.4fx_units.[1-4].mix`                | `to: DirectPropertyAdapter { path: "..." }`                   |

**Usage Pattern**:

```qml
// 1. Declare AppProperty
AppProperty {
    id: trackTitle
    path: "app.traktor.decks.1.track.content.title"
}

// 2. Use in display
Text {
    text: trackTitle.value
}

// 3. Or react to changes
AppProperty {
    id: deckPlay
    path: "app.traktor.decks.1.play"
    onValueChanged: {
        if (value) {
            console.log("Deck started playing")
        }
    }
}
```

---

### Path Structure Reference

```
app.traktor.[context].[id/index].[category].[property]
         │        │         │          │         │
         │        │         │          │         └─ Specific value
         │        │         │          └─────────── Property group
         │        │         └────────────────────── Deck/Channel number (1-4)
         │        └──────────────────────────────── Feature area
         └───────────────────────────────────────── Application root
```

| Context       | Description        | Example Path                             |
| ------------- | ------------------ | ---------------------------------------- |
| `decks`       | Deck A/B/C/D (1-4) | `app.traktor.decks.1.play`               |
| `mixer`       | Mixer channels     | `app.traktor.mixer.channels.1.volume`    |
| `masterclock` | Master tempo/sync  | `app.traktor.masterclock.tempo`          |
| `browser`     | Track browser      | `app.traktor.browser.list_selected_item` |
| `fx`          | Effects units      | `app.traktor.fx.4fx_units.[1-4].enabled` |

---

## Full AppProperty Path Catalog

**Quick reference**: Traktor `AppProperty` paths organized by function. All paths are read/write unless marked `[trigger]` or `[read-only]`.

**Path syntax**:

- `X` = Deck number (1–4)
- `Y` = Stem/player index (1–4)
- `Z` = Cell/remix index
- `%d` = Printf-style placeholder

---

### 📍 Index by Category

| Category              | Section                                                  |
| --------------------- | -------------------------------------------------------- |
| Global & Master Clock | [Global](#global--master-clock)                          |
| Browser & Preview     | [Browser](#browser--preview)                             |
| Deck Playback         | [Deck Playback Control](#deck-playback-control)          |
| Tempo & Sync          | [Tempo & Sync](#tempo--sync)                             |
| Track Info            | [Track Metadata](#track-metadata)                        |
| Playhead & Timing     | [Track Player & Timing](#track-player--timing)           |
| Loop & Beat Jumping   | [Loop & Beat Jumping](#loop--beat-jumping)               |
| Cues & Hotcues        | [Cue Points & Hotcues](#cue-points--hotcues)             |
| Beatgrid              | [Beatgrid & Analysis](#beatgrid--analysis)               |
| Freeze Mode           | [Freeze & Advanced Features](#freeze--advanced-features) |
| Stem Deck             | [Stem Deck](#stem-deck)                                  |
| Remix Deck            | [Remix Deck](#remix-deck)                                |
| Mixer                 | [Mixer](#mixer)                                          |
| Effects               | [Effects](#effects)                                      |
| Settings              | [Settings & Display](#settings--display)                 |

---

### Global & Master Clock

| Path                                   | Type    | Purpose                    |
| -------------------------------------- | ------- | -------------------------- |
| `app.traktor.snap`                     | bool    | Quantize to grid           |
| `app.traktor.quant`                    | bool    | Snap mode enabled          |
| `app.traktor.measurement.enable`       | bool    | Enable measurement tools   |
| `app.traktor.masterclock.tempo`        | real    | Master clock BPM           |
| `app.traktor.masterclock.active_tempo` | real    | Active master tempo        |
| `app.traktor.masterclock.mode`         | string  | Sync mode                  |
| `app.traktor.masterclock.source_id`    | int     | Which deck is master (1–4) |
| `app.traktor.midi.buttons.*`           | various | MIDI button mappings       |
| `app.traktor.midi.faders.*`            | various | MIDI fader mappings        |
| `app.traktor.midi.knobs.*`             | various | MIDI knob mappings         |

---

### Browser & Preview

| Path                                               | Type             | Purpose                |
| -------------------------------------------------- | ---------------- | ---------------------- |
| `app.traktor.browser.full_screen`                  | bool             | Browser in fullscreen  |
| `app.traktor.browser.sort_id`                      | int              | Current sort column    |
| `app.traktor.browser.tree.select_up_down`          | trigger          | Navigate folder tree   |
| `app.traktor.browser.list.select_up_down`          | trigger          | Scroll track list      |
| `app.traktor.browser.flip_sort_up_down`            | trigger          | Toggle sort direction  |
| `app.traktor.browser.preparation.append`           | trigger          | Add to prep list       |
| `app.traktor.browser.preparation.toggle`           | trigger          | Toggle prep status     |
| `app.traktor.browser.preview_player.load`          | trigger          | Load in preview player |
| `app.traktor.browser.preview_player.play`          | trigger          | Play preview           |
| `app.traktor.browser.preview_player.is_loaded`     | bool [read-only] | Preview loaded         |
| `app.traktor.browser.preview_player.elapsed_time`  | real [read-only] | Preview playhead       |
| `app.traktor.browser.preview_content.track_length` | real [read-only] | Preview track duration |

---

### Deck Playback Control

| Path                                | Type             | Purpose                      | Example                                   |
| ----------------------------------- | ---------------- | ---------------------------- | ----------------------------------------- |
| `app.traktor.decks.X.is_loaded`     | bool [read-only] | Track loaded on deck         | `enabled: isLoaded.value`                 |
| `app.traktor.decks.X.play`          | bool             | Play/pause state             | Toggle via wire                           |
| `app.traktor.decks.X.cue`           | bool             | Cue point active             | Listen control                            |
| `app.traktor.decks.X.reverse`       | bool             | Reverse playback             | Scratch mode                              |
| `app.traktor.decks.X.running`       | bool [read-only] | Deck actively playing        | LED feedback                              |
| `app.traktor.decks.X.direct_thru`   | bool             | Direct monitoring            | Headphone pre-fader                       |
| `app.traktor.decks.X.type`          | enum [read-only] | Deck type (Track/Stem/Remix) | Check `deckType.value === DeckType.Track` |
| `app.traktor.decks.X.load.selected` | trigger          | Load selected track          | Browser → Deck                            |
| `app.traktor.decks.X.load.next`     | trigger          | Load next in queue           | Auto-advance prep list                    |
| `app.traktor.decks.X.unload`        | trigger          | Unload track                 | Clear deck                                |

---

### Tempo & Sync

| Path                                    | Type             | Purpose                  | Typical Range      |
| --------------------------------------- | ---------------- | ------------------------ | ------------------ |
| `app.traktor.decks.X.tempo.absolute`    | real             | Current deck BPM         | 80–160             |
| `app.traktor.decks.X.tempo.adjust`      | real             | Tempo fader position     | -1.0 to +1.0       |
| `app.traktor.decks.X.tempo.range_value` | real             | Range setting (50/8/16%) | 50, 100, 200       |
| `app.traktor.decks.X.tempo.base_bpm`    | real [read-only] | Original track BPM       | Constant per track |
| `app.traktor.decks.X.sync.enabled`      | bool             | Sync mode active         | Toggle button      |
| `app.traktor.decks.X.sync.phase`        | real             | Beat phase alignment     | 0.0–1.0            |
| `app.traktor.decks.X.set_as_master`     | trigger          | Make this deck master    | Multi-deck control |

---

### Track Metadata

| Path                                      | Type   | Purpose        | Source                  |
| ----------------------------------------- | ------ | -------------- | ----------------------- |
| `app.traktor.decks.X.content.title`       | string | Track name     | Library metadata        |
| `app.traktor.decks.X.content.artist`      | string | Artist name    | Library metadata        |
| `app.traktor.decks.X.content.album`       | string | Album title    | Library metadata        |
| `app.traktor.decks.X.content.bpm`         | real   | Original BPM   | Analyzed value          |
| `app.traktor.decks.X.content.musical_key` | string | Musical key    | e.g., "8A" or "C Minor" |
| `app.traktor.decks.X.content.genre`       | string | Genre tag      | Library metadata        |
| `app.traktor.decks.X.content.comment`     | string | Track comment  | User field              |
| `app.traktor.decks.X.content.bitrate`     | int    | Audio bitrate  | kbps                    |
| `app.traktor.decks.X.content.cover_md5`   | string | Album art hash | Cached identifier       |

---

### Track Player & Timing

| Path                                                 | Type             | Purpose                  | Example             |
| ---------------------------------------------------- | ---------------- | ------------------------ | ------------------- |
| `app.traktor.decks.X.track.player.elapsed_time`      | real [read-only] | Playhead position        | Waveform marker     |
| `app.traktor.decks.X.track.player.playhead_position` | real [read-only] | Exact playhead (0–1)     | Normalized position |
| `app.traktor.decks.X.track.time.remaining`           | real [read-only] | Seconds left             | Show as countdown   |
| `app.traktor.decks.X.track.time.total`               | real [read-only] | Total track length       | Display duration    |
| `app.traktor.decks.X.track.player.effective_tempo`   | real [read-only] | Effective BPM after sync | Display tempo       |
| `app.traktor.decks.X.track.stream_end_warning`       | bool [read-only] | Near end of track        | Caution indicator   |

---

### Loop & Beat Jumping

| Path                                | Type    | Purpose                    | Mode               |
| ----------------------------------- | ------- | -------------------------- | ------------------ |
| `app.traktor.decks.X.loop.active`   | bool    | Loop enabled               | Toggle             |
| `app.traktor.decks.X.loop.size`     | real    | Loop length (beats)        | 0.5–64 typically   |
| `app.traktor.decks.X.loop.set.in`   | trigger | Set loop start             | Manual             |
| `app.traktor.decks.X.loop.set.out`  | trigger | Set loop end               | Manual             |
| `app.traktor.decks.X.loop.set.auto` | trigger | Auto-loop from current     | Quick loop         |
| `app.traktor.decks.X.move.beatjump` | trigger | Jump forward/back          | Beat-grid aligned  |
| `app.traktor.decks.X.move.size`     | int     | Jump distance (beats)      | 1, 2, 4, 8 typical |
| `app.traktor.decks.X.beatjump`      | int     | Jump direction & magnitude | -4 to +4 typical   |

---

### Cue Points & Hotcues

| Path                                                 | Type               | Purpose               | Index             |
| ---------------------------------------------------- | ------------------ | --------------------- | ----------------- |
| `app.traktor.decks.X.cue`                            | bool               | Main cue point        | Hardwired         |
| `app.traktor.decks.X.track.cue.hotcues.Y.exists`     | bool [read-only]   | Hotcue Y placed       | Y = 1–8           |
| `app.traktor.decks.X.track.cue.hotcues.Y.start_pos`  | real               | Position in track     | Seconds           |
| `app.traktor.decks.X.track.cue.hotcues.Y.length`     | real               | Hotcue entry duration | Sample length     |
| `app.traktor.decks.X.track.cue.select_or_set_hotcue` | trigger            | Set/jump to hotcue    | Context-dependent |
| `app.traktor.decks.X.track.cue.delete_hotcue`        | trigger            | Delete hotcue         | Permanent         |
| `app.traktor.decks.X.track.cue.active.type`          | int [read-only]    | Current cue type      | 0=main, 1=hotcue  |
| `app.traktor.decks.X.track.cue.active.name`          | string [read-only] | Active cue label      | Display name      |

---

### Beatgrid & Analysis

| Path                                                    | Type             | Purpose              | Context              |
| ------------------------------------------------------- | ---------------- | -------------------- | -------------------- |
| `app.traktor.decks.X.analyze`                           | trigger          | Analyze track        | Manual analysis      |
| `app.traktor.decks.X.track.beat_pos_relative_to_grid`   | real [read-only] | Beat alignment       | 0–1 position in beat |
| `app.traktor.decks.X.track.grid.lock_bpm`               | trigger          | Lock BPM             | Prevent adjustment   |
| `app.traktor.decks.X.track.grid.tap`                    | trigger          | Tap tempo            | Manual BPM entry     |
| `app.traktor.decks.X.track.grid.double_bpm`             | trigger          | Double detected BPM  | Halving correction   |
| `app.traktor.decks.X.track.grid.half_bpm`               | trigger          | Halve detected BPM   | Doubling correction  |
| `app.traktor.decks.X.track.grid.copy_phase_from_master` | trigger          | Sync phase to master | Beat alignment       |
| `app.traktor.decks.X.track.grid.set_autogrid`           | trigger          | Auto-detect beatgrid | Traktor Pro 4        |

---

### Freeze & Advanced Features

| Path                                        | Type            | Purpose                     | Use Case             |
| ------------------------------------------- | --------------- | --------------------------- | -------------------- |
| `app.traktor.decks.X.flux.enabled`          | bool            | Flux mode active            | Reverse scratch prep |
| `app.traktor.decks.X.flux.state`            | int [read-only] | Flux state (standby/active) | LED mode             |
| `app.traktor.decks.X.freeze.enabled`        | bool            | Freeze mode                 | Slicer/looper        |
| `app.traktor.decks.X.freeze.slice_count`    | int [read-only] | Number of slices            | Audio analysis       |
| `app.traktor.decks.X.freeze.current_slice`  | int             | Currently playing slice     | Navigation           |
| `app.traktor.decks.X.freeze.is_slicer_mode` | bool            | Slicer vs looper            | Mode indicator       |
| `app.traktor.decks.X.platter.touch`         | bool            | Jog wheel touched           | Contact detection    |
| `app.traktor.decks.X.platter.move`          | trigger         | Jog wheel moved             | Scratch/seek         |

---

### Stem Deck

| Path                                           | Type             | Purpose              | Index          |
| ---------------------------------------------- | ---------------- | -------------------- | -------------- |
| `app.traktor.decks.X.stems.Y.stem_info_exists` | bool [read-only] | Stem loaded          | Y = 1–4        |
| `app.traktor.decks.X.stems.Y.volume`           | real             | Stem volume          | 0–1 normalized |
| `app.traktor.decks.X.stems.Y.muted`            | bool             | Stem muted           | Toggle         |
| `app.traktor.decks.X.stems.Y.filter_value`     | real             | Stem filter position | -1 to +1       |
| `app.traktor.decks.X.stems.Y.fx_send`          | real             | Stem FX send level   | 0–1            |
| `app.traktor.decks.X.stems.Y.color_id`         | int              | Stem color           | UI identifier  |

---

### Remix Deck

#### Remix Players

| Path                                                | Type | Purpose            | Index            |
| --------------------------------------------------- | ---- | ------------------ | ---------------- |
| `app.traktor.decks.X.remix.players.Y.volume`        | real | Player volume      | Y = 1–4          |
| `app.traktor.decks.X.remix.players.Y.muted`         | bool | Mute player        | Toggle           |
| `app.traktor.decks.X.remix.players.Y.filter_value`  | real | Filter position    | -1 to +1         |
| `app.traktor.decks.X.remix.players.Y.key_lock`      | bool | Key lock enabled   | Pitch correction |
| `app.traktor.decks.X.remix.players.Y.play_position` | real | Playhead (0–1)     | Normalized       |
| `app.traktor.decks.X.remix.players.Y.level`         | real | Output level meter | -∞ to 0 dB       |

#### Remix Cells

| Path                                                        | Type            | Purpose                                        |
| ----------------------------------------------------------- | --------------- | ---------------------------------------------- | --------- |
| `app.traktor.decks.X.remix.cell.columns.Y.rows.Z.trigger`   | trigger         | Play cell sample                               |
| `app.traktor.decks.X.remix.cell.columns.Y.rows.Z.stop`      | trigger         | Stop cell playback                             |
| `app.traktor.decks.X.remix.cell.columns.Y.rows.Z.state`     | int [read-only] | State: 0=empty, 1=loaded, 2=playing, 3=waiting |
| `app.traktor.decks.X.remix.cell.columns.Y.rows.Z.play_mode` | string          | "Looped" or "OneShot"                          |
| `app.traktor.decks.X.remix.cell.columns.Y.rows.Z.color_id`  | int             | Cell color                                     |
| `app.traktor.decks.X.remix.cell.columns.Y.rows.Z.gain`      | real            | Sample gain                                    | dB level  |
| `app.traktor.decks.X.remix.cell.columns.Y.rows.Z.pitch`     | real            | Sample pitch                                   | Semitones |

#### Remix Sequencer

| Path                                                         | Type   | Purpose                |
| ------------------------------------------------------------ | ------ | ---------------------- | --- |
| `app.traktor.decks.X.remix.sequencer.on`                     | bool   | Sequencer active       |
| `app.traktor.decks.X.remix.sequencer.swing`                  | real   | Swing percentage       | 0–1 |
| `app.traktor.decks.X.remix.players.Y.sequencer.pattern_mode` | string | Pattern mode           |
| `app.traktor.decks.X.remix.players.Y.sequencer.current_step` | int    | Current sequencer step |

---

### Mixer

#### Master Controls

| Path                                 | Type             | Purpose             |
| ------------------------------------ | ---------------- | ------------------- | ----------------------- |
| `app.traktor.mixer.master_volume`    | real             | Master fader        | 0–1                     |
| `app.traktor.mixer.master.level.sum` | real [read-only] | Master out level    | dB meter                |
| `app.traktor.mixer.cue.volume`       | real             | Headphone volume    | 0–1                     |
| `app.traktor.mixer.cue.mix`          | real             | Cue mix (main/aux)  | 0–1                     |
| `app.traktor.mixer.xfader.adjust`    | real             | Crossfader position | -1 (left) to +1 (right) |
| `app.traktor.mixer.xfader.curve`     | real             | Crossfader curve    | Linear to sharp         |

#### Channel Controls

| Path                                                       | Type             | Purpose                   |
| ---------------------------------------------------------- | ---------------- | ------------------------- | -------- |
| `app.traktor.mixer.channels.X.volume`                      | real             | Channel fader             | 0–1      |
| `app.traktor.mixer.channels.X.gain`                        | real             | Channel gain              | dB       |
| `app.traktor.mixer.channels.X.eq.high`                     | real             | High EQ                   | -∞ to +∞ |
| `app.traktor.mixer.channels.X.eq.mid`                      | real             | Mid EQ                    | -∞ to +∞ |
| `app.traktor.mixer.channels.X.eq.low`                      | real             | Low EQ                    | -∞ to +∞ |
| `app.traktor.mixer.channels.X.eq.kill_high`                | bool             | Kill high (Traktor Pro 4) | Toggle   |
| `app.traktor.mixer.channels.X.filter`                      | real             | Channel filter            | -1 to +1 |
| `app.traktor.mixer.channels.X.fx.on`                       | bool             | FX enabled on channel     | Toggle   |
| `app.traktor.mixer.channels.X.fx.select`                   | int              | Selected FX unit          | 1–4      |
| `app.traktor.mixer.channels.X.level.prefader.linear.meter` | real [read-only] | Pre-fader meter           | dB       |

---

### Effects

> **Reference**: See the official [Traktor Effect Reference](https://www.native-instruments.com/ni-tech-manuals/traktor-pro-manual/en/effect-reference) for detailed effect descriptions and parameters.

#### FX Unit Controls

| Path                         | Type    | Purpose                |
| ---------------------------- | ------- | ---------------------- | --------- |
| `app.traktor.fx.X.enabled`   | bool    | Enable/disable FX unit | X = 1–4   |
| `app.traktor.fx.X.dry_wet`   | real    | Dry/wet mix            | 0–1       |
| `app.traktor.fx.X.select.1`  | trigger | Select FX slot 1       |
| `app.traktor.fx.X.select.2`  | trigger | Select FX slot 2       |
| `app.traktor.fx.X.select.3`  | trigger | Select FX slot 3       |
| `app.traktor.fx.X.knobs.1`   | real    | FX knob 1 value        | 0–1       |
| `app.traktor.fx.X.knobs.2`   | real    | FX knob 2 value        | 0–1       |
| `app.traktor.fx.X.knobs.3`   | real    | FX knob 3 value        | 0–1       |
| `app.traktor.fx.X.buttons.1` | trigger | FX button 1            | Momentary |
| `app.traktor.fx.X.buttons.2` | trigger | FX button 2            | Momentary |
| `app.traktor.fx.X.buttons.3` | trigger | FX button 3            | Momentary |
| `app.traktor.fx.X.lfo_reset` | trigger | Reset LFO phase        |
| `app.traktor.fx.X.store`     | trigger | Store FX preset        |

#### Pattern Player (Traktor Pro 4)

| Path                                            | Type               | Purpose                |
| ----------------------------------------------- | ------------------ | ---------------------- |
| `app.traktor.fx.X.pattern_player.kit_shortname` | string [read-only] | Current kit name       |
| `app.traktor.fx.X.pattern_player.current_sound` | int [read-only]    | Playing sound index    |
| `app.traktor.fx.X.pattern_player.current_step`  | int [read-only]    | Current sequencer step |
| `app.traktor.fx.X.pattern_player.is_customized` | bool [read-only]   | Pattern modified       |

---

### Settings & Display

| Path                                        | Type               | Purpose                  |
| ------------------------------------------- | ------------------ | ------------------------ | ----------------- |
| `app.traktor.settings.paths.root`           | string [read-only] | Traktor library root     |
| `app.traktor.settings.waveform.color`       | int                | Waveform color scheme    | 0–21              |
| `app.traktor.settings.metadatasync.enabled` | bool               | Metadata sync active     |
| `app.traktor.settings.deckheader.top.left`  | int                | Deck header field        | Info display slot |
| `app.traktor.settings.deckheader.top.mid`   | int                | Deck header field        |
| `app.traktor.settings.deckheader.top.right` | int                | Deck header field        |
| `settings.pro.plus.pattern_player.ready`    | bool [read-only]   | Pattern player available | Traktor Pro 4     |

---

**Legend**:

- `[trigger]` = momentary action (no persistent value)
- `[read-only]` = readable but not writable
- `X`, `Y`, `Z` = indices; replace with numbers (1–4)
- `real` = floating-point (0.0–1.0 typical)
- `bool` = true/false
- `int` = whole number
- `string` = text value

### Common Patterns & Tips

### Common Patterns & Tips

**Dynamic Deck Selection**

```qml
// Use deckId variable for reusable components
property int deckId: 1

AppProperty {
    id: deckPlay
    path: "app.traktor.decks." + deckId + ".play"
}
```

**Safe Property Access**

```qml
// Check if value exists before using
AppProperty {
    id: trackTitle
    path: "app.traktor.decks.1.track.content.title"
}

Text {
    text: (trackTitle.value !== undefined && trackTitle.value !== "")
          ? trackTitle.value
          : "No Track"
}
```

**Conditional Color Based on Value**

```qml
AppProperty { id: timeRemaining; path: "app.traktor.decks.1.track.time.remaining" }

Text {
    text: formatTime(timeRemaining.value)
    color: {
        if (timeRemaining.value < 10) return colors.red        // Critical
        if (timeRemaining.value < 30) return colors.orange     // Warning
        return colors.white                                     // Normal
    }
}
```

**Two-Way Control (Read & Write)**

```qml
// Read current state
AppProperty {
    id: deckVolume
    path: "app.traktor.mixer.channels.1.volume"
}

// Control via wire
Wire {
    from: "%surface%.volume"
    to: DirectPropertyAdapter {
        path: "app.traktor.mixer.channels.1.volume"
    }
}

// Display current value
Text {
    text: (deckVolume.value * 100).toFixed(0) + "%"
}
```

---

## Installation Quick Steps

This handbook keeps the **canonical** install / backup / restore steps in one place:

- Safe workflow (paths + backup + overlay install): [01_BASICS.md](01_BASICS.md#install--backup--restore-the-safe-workflow)
- Version pitfalls when overlaying mods: [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)

If you’re in the middle of editing an example, the shortest path is:

1. Quit Traktor
2. Back up `qml`
3. Apply the change
4. Restart Traktor

---

## Syntax Quick Reference

### Comments

```qml
// Single line comment
/* Multi-line
   comment */
```

### Conditionals

```qml
if (condition) {
    // action
} else if (otherCondition) {
    // other action
} else {
    // default
}

// Ternary
value = condition ? ifTrue : ifFalse
```

### Functions

```qml
function myFunction(param1, param2) {
    var result = param1 + param2
    return result
}
```

### Loops

```qml
for (var i = 0; i < array.length; i++) {
    // process array[i]
}

array.forEach(function(item) {
    // process item
})
```

---

## Common Waveform Colors

```qml
property int waveformColors: X

0:  Default
20: Nexus (recommended)
21: Prime
1:  Red
11: Blue
7:  Green
5:  Yellow
13: Violet
```

---

## Keyboard Shortcuts for Editing

**VS Code**:

- `Cmd/Ctrl + P` - Quick file open
- `Cmd/Ctrl + F` - Find in file
- `Cmd/Ctrl + Shift + F` - Find in all files
- `Cmd/Ctrl + D` - Select next occurrence
- `Cmd/Ctrl + /` - Toggle comment

---

## Advanced Patterns & State Management

The examples below expand on the quick tasks in [Common Tasks Cheat Sheet](#common-tasks-cheat-sheet). For each pattern, start with the quick recipe above, then use these deep dives to understand the advanced mechanics.

### Design Patterns for Common Modifications

#### Pattern 1: Multi-Function Button (Single/Double/Long Press)

**When to use**: One button, multiple actions

```qml
// Declare timers
Timer { id: doubleTapTimer; interval: 300 }
Timer { id: longPressTimer; interval: 500 }

property int lastPressTime: 0
property bool longPressTriggered: false

ButtonScriptAdapter {
    name: "multiButton"

    onPress: {
        var now = Date.now()
        var timeSince = now - lastPressTime

        if (timeSince < 300) {
            // Double tap detected
            doubleTapTimer.stop()
            executeDoubleTapAction()
        } else {
            // First tap
            longPressTimer.restart()
            doubleTapTimer.restart()
        }
        lastPressTime = now
    }

    onRelease: {
        if (!longPressTriggered) {
            longPressTimer.stop()
        }
        longPressTriggered = false
    }
}

Timer {
    id: longPressTimer
    onTriggered: {
        longPressTriggered = true
        executeLongPressAction()
    }
}

Timer {
    id: doubleTapTimer
    onTriggered: {
        if (!longPressTriggered) {
            executeSingleTapAction()
        }
    }
}
```

**See**: Refer to [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real-world examples and patterns

---

#### Pattern 2: Conditional Display (Show/Hide Based on State)

**When to use**: Display different info based on conditions

```qml
// Read state
AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type" }
AppProperty { id: isPlaying; path: "app.traktor.decks." + deckId + ".play" }

// Conditional visibility
Text {
    visible: deckType.value == DeckType.Track && isPlaying.value
    text: "Track Playing"
}

Text {
    visible: deckType.value == DeckType.Stem
    text: "Stem Deck"
}
```

**See**: Refer to [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real-world examples and patterns

---

#### Pattern 3: Warning System (Threshold-Based Color Change)

**When to use**: Visual alerts when values cross thresholds

```qml
// Read value
AppProperty { id: timeRemaining; path: "app.traktor.decks." + deckId + ".track.time.remaining" }

// Define thresholds
readonly property int warningTime: 30  // seconds
readonly property int criticalTime: 10

// Computed color
property color timeColor: {
    if (timeRemaining.value < criticalTime) return colors.red
    if (timeRemaining.value < warningTime) return colors.orange
    return colors.white
}

Text {
    text: formatTime(timeRemaining.value)
    color: timeColor
}
```

**See**: Refer to [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real-world examples

---

#### Pattern 4: Encoder Context Switching

**When to use**: Same encoder controls different functions in different modes

```qml
AppProperty { id: shiftPressed; path: "mapping.state.shift" }
MappingProperty { id: browseMode; path: "mapping.settings.browse_mode" }

// Encoder routing based on context
WiresGroup {
    enabled: !shiftPressed.value
    Wire {
        from: "%surface%.browse"
        to: EncoderScriptAdapter {
            onIncrement: { browseNext() }
            onDecrement: { browsePrevious() }
        }
    }
}

WiresGroup {
    enabled: shiftPressed.value
    Wire {
        from: "%surface%.browse"
        to: EncoderScriptAdapter {
            onIncrement: { zoomIn() }
            onDecrement: { zoomOut() }
        }
    }
}
```

**See**: Study [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real-world implementations

---

#### Pattern 5: Setting Toggle with Visual Feedback

**When to use**: Button toggles setting + shows current state

```qml
MappingProperty { id: customSetting; path: "mapping.settings.custom" }

Wire {
    from: "%surface%.button"
    to: ButtonScriptAdapter {
        brightness: customSetting.value ? 1.0 : 0.0  // LED feedback

        onPress: {
            customSetting.value = !customSetting.value
        }
    }
}

// Optional: Screen feedback
Text {
    visible: customSetting.value
    text: "Custom Mode: ON"
    color: colors.green
}
```

**See**: Study [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real-world implementations

---

#### Pattern 6: Computed Property (Derived Values)

**When to use**: Calculate new values from existing properties

```qml
AppProperty { id: deckTempo; path: "app.traktor.decks." + deckId + ".tempo.absolute" }
AppProperty { id: masterTempo; path: "app.traktor.masterclock.tempo" }

// Computed property
readonly property real tempoDifference: {
    return Math.abs(deckTempo.value - masterTempo.value)
}

// Use computed value
Text {
    visible: tempoDifference > 0.5
    text: "BPM Mismatch: " + tempoDifference.toFixed(1)
    color: colors.red
}
```

**See**: Study [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real-world implementations

---

#### Pattern 7: State Machine (Multiple Modes)

**When to use**: Complex behavior with distinct states

```qml
// Define states
readonly property int State_Default: 0
readonly property int State_Editing: 1
readonly property int State_Browsing: 2

property int currentState: State_Default

// State-dependent behavior
function handleButtonPress() {
    switch(currentState) {
        case State_Default:
            enterEditMode()
            break
        case State_Editing:
            saveAndExit()
            break
        case State_Browsing:
            loadSelected()
            break
    }
}

// Visual feedback per state
Rectangle {
    color: {
        switch(currentState) {
            case State_Default: return colors.blue
            case State_Editing: return colors.orange
            case State_Browsing: return colors.green
        }
    }
}
```

**See**: Study [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real-world implementations

---

### Common Modification Recipes

#### Recipe: Make Any Overlay Timeout Configurable

```qml
// 1. Add preference (Defines/Prefs.qml)
readonly property int overlayTimeout: 5000

// 2. Use preference (CSI/Common/Deck_S8Style.qml)
Timer {
    id: overlay_countdown
    interval: Prefs.overlayTimeout  // ← Use preference
}
```

---

#### Recipe: Add LED Feedback to Any Button

```qml
Wire {
    from: "%surface%.button"
    to: ButtonScriptAdapter {
        brightness: condition ? 1.0 : 0.0  // LED on/off
        onPress: { /* action */ }
    }
}
```

---

#### Recipe: Create Encoder with Visual Feedback

```qml
property int currentValue: 5

Wire {
    from: "%surface%.encoder"
    to: EncoderScriptAdapter {
        onIncrement: {
            currentValue = Math.min(10, currentValue + 1)
        }
        onDecrement: {
            currentValue = Math.max(0, currentValue - 1)
        }
    }
}

// Display
Text {
    text: currentValue.toString()
}
```

---

#### Recipe: Prevent Conflicts Between Multiple Wires

```qml
// Use mutually exclusive enabled conditions
WiresGroup {
    enabled: mode == Mode_A && !shiftPressed
    // Wires for Mode A
}

WiresGroup {
    enabled: mode == Mode_B && !shiftPressed
    // Wires for Mode B
}

WiresGroup {
    enabled: shiftPressed  // Shift overrides all modes
    // Shift wires
}
```

---

**Next**: Start with [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) to see real-world implementations
