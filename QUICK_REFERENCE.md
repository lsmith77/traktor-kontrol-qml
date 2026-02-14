# Traktor QML Quick Reference Card

**One-page reference for common customization tasks**

---

## 🧭 Quick Navigation

**🎯 Find What You Need:**
- [File Locations & Decision Tree](#file-locations-quick-map) - Which file to edit?
- [Common Tasks (Copy-Paste)](#common-tasks-cheat-sheet) - Quick solutions
- [Property Paths Reference](#common-property-paths) - app.traktor paths

**🔧 Building & Customizing:**
- [Design Patterns](#creating-your-own-customizations) - Reusable templates
- [Modification Templates](#modification-templates) - Step-by-step recipes
- [Wire & Adapter Reference](#property-types-reference) - Connection syntax

**🐛 Problem Solving:**
- [Debugging Checklist](#debugging-checklist) - Quick fixes first!
- [Troubleshooting Guide](#troubleshooting-common-issues) - Common problems solved
- [Testing Checklist](#testing-checklist) - Verify your changes
- [Risk Assessment](#modification-risk-assessment) - Know before you modify

**📦 Operations:**
- [Installation Steps](#installation-quick-steps) - Setup instructions
- [Backup & Restore](#rollback-instructions) - Safety first
- [Git Commands](#essential-git-commands) - Version control

**📚 Cross-References:**
- See [README.md](README.md) for architecture overview & getting started
- See [PRACTICAL_EXAMPLES.md](PRACTICAL_EXAMPLES.md) for 41 complete examples
- See [Commands.txt](Commands.txt) for the complete AppProperty path reference
- Jump to specific example: [PRACTICAL_EXAMPLES.md → Table of Contents](PRACTICAL_EXAMPLES.md#-table-of-contents)

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

> **Complete reference**: See [Commands.txt](Commands.txt) for the full list of all known `AppProperty` paths organized by category (global, browser, deck, track, stem, remix, mixer, effects, settings). The table below covers the most common ones with usage examples.
>
> **Source**: [NI Community Forum - S4MK3/S3 Performance Mod QML Coding](https://community.native-instruments.com/discussion/26956/s4mk3-s3-performance-mod-qml-coding)

### Find Property by Use Case

**Quick lookup: "I want to do X, which property do I need?"**

| I want to...                            | Property Path                                       | Example Usage                                                   |
| --------------------------------------- | --------------------------------------------------- | --------------------------------------------------------------- |
| **Playback Control**                    |                                                     |                                                                 |
| Detect if deck is playing               | `app.traktor.decks.[1-4].play`                      | `visible: deckPlay.value` (show when playing)                   |
| Trigger play/pause                      | `app.traktor.decks.[1-4].play`                      | `Wire { to: TogglePropertyAdapter { path: "..." } }`            |
| Check if track is loaded                | `app.traktor.decks.[1-4].is_loaded`                 | `enabled: isLoaded.value` (disable buttons when empty)          |
| Access cue point state                  | `app.traktor.decks.[1-4].cue`                       | `to: TriggerPropertyAdapter { path: "..." }`                    |
| **Tempo & Sync**                        |                                                     |                                                                 |
| Read/change deck tempo (BPM)            | `app.traktor.decks.[1-4].tempo.absolute`            | `text: deckTempo.value.toFixed(2)` (display BPM)                |
| Read master clock tempo                 | `app.traktor.masterclock.tempo`                     | `text: "Master: " + masterTempo.value.toFixed(1)`               |
| Detect sync enabled                     | `app.traktor.decks.[1-4].sync.enabled`              | `color: syncEnabled.value ? colors.green : colors.gray`         |
| Get master clock source                 | `app.traktor.masterclock.source_id`                 | `visible: masterSource.value === deckId` (show if master)       |
| **Track Information**                   |                                                     |                                                                 |
| Read track title                        | `app.traktor.decks.[1-4].track.content.title`       | `text: trackTitle.value`                                        |
| Read track artist                       | `app.traktor.decks.[1-4].track.content.artist`      | `text: trackArtist.value`                                       |
| Read track BPM                          | `app.traktor.decks.[1-4].track.content.bpm`         | `text: trackBPM.value.toFixed(1) + " BPM"`                      |
| Read track key                          | `app.traktor.decks.[1-4].track.content.musical_key` | `text: trackKey.value` (e.g., "8A", "C Minor")                  |
| Get track time remaining                | `app.traktor.decks.[1-4].track.time.remaining`      | `color: timeLeft.value < 30 ? colors.red : colors.white`        |
| Get track elapsed time                  | `app.traktor.decks.[1-4].track.time.elapsed`        | `text: formatTime(elapsed.value)`                               |
| **Mixer Controls**                      |                                                     |                                                                 |
| Control channel volume                  | `app.traktor.mixer.channels.[1-4].volume`           | `Wire { to: DirectPropertyAdapter { path: "..." } }`            |
| Control channel filter                  | `app.traktor.mixer.channels.[1-4].filter`           | `to: DirectPropertyAdapter { path: "..." }`                     |
| Control crossfader                      | `app.traktor.mixer.xfader.adjust`                   | `to: DirectPropertyAdapter { path: "..." }`                     |
| Select FX unit for channel              | `app.traktor.mixer.channels.[1-4].fx.select`        | `to: ButtonScriptAdapter { onPress: { fxSelect.value = 1 } }`   |
| **Deck Modes & Features**               |                                                     |                                                                 |
| Check deck type (Track/Stem/etc)        | `app.traktor.decks.[1-4].type`                      | `visible: deckType.value === DeckType.Track`                    |
| Detect Flux mode enabled                | `app.traktor.decks.[1-4].flux.enabled`              | `brightness: fluxEnabled.value ? 1.0 : 0.0` (LED feedback)      |
| Check if in loop                        | `app.traktor.decks.[1-4].loop.active`               | `color: loopActive.value ? colors.orange : colors.white`        |
| Get loop size                           | `app.traktor.decks.[1-4].loop.size`                 | `text: loopSize.value + " beats"`                               |
| **Browser & Navigation**                |                                                     |                                                                 |
| Get selected browser item               | `app.traktor.browser.list_selected_item`            | `text: selectedItem.value`                                      |
| Load track to deck                      | `app.traktor.decks.[1-4].load.selected`             | `to: TriggerPropertyAdapter { path: "..." }`                    |
| Browse up/down                          | `app.traktor.browser.list_navigation`               | `to: RelativePropertyAdapter { path: "..." }`                   |
| **Effects**                             |                                                     |                                                                 |
| Enable/disable FX unit                  | `app.traktor.fx.4fx_units.[1-4].enabled`            | `to: TogglePropertyAdapter { path: "..." }`                     |
| Select FX slot                          | `app.traktor.fx.4fx_units.[1-4].select`             | `onPress: { fxSelect.value = slotNum }`                         |
| Control FX dry/wet                      | `app.traktor.fx.4fx_units.[1-4].mix`                | `to: DirectPropertyAdapter { path: "..." }`                     |

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

### Comprehensive Property List by Category

**Deck Playback & State**

```qml
app.traktor.decks.[1-4].type                 // DeckType enum (Track/Stem/Live/etc)
app.traktor.decks.[1-4].is_loaded            // bool: track loaded?
app.traktor.decks.[1-4].play                 // bool: playing state
app.traktor.decks.[1-4].cue                  // bool: cue point active
app.traktor.decks.[1-4].flux.enabled         // bool: flux mode on/off
```

**Deck Tempo & Sync**

```qml
app.traktor.decks.[1-4].tempo.absolute       // real: actual BPM (e.g., 128.5)
app.traktor.decks.[1-4].tempo.relative       // real: tempo adjust % (-100 to +100)
app.traktor.decks.[1-4].sync.enabled         // bool: sync on/off
app.traktor.decks.[1-4].sync.phase           // real: beat phase alignment
```

**Track Metadata**

```qml
app.traktor.decks.[1-4].track.content.title         // string: track title
app.traktor.decks.[1-4].track.content.artist        // string: artist name
app.traktor.decks.[1-4].track.content.bpm           // real: original track BPM
app.traktor.decks.[1-4].track.content.musical_key   // string: key notation (e.g., "8A")
app.traktor.decks.[1-4].track.content.album         // string: album name
app.traktor.decks.[1-4].track.content.genre         // string: genre
app.traktor.decks.[1-4].track.content.comment       // string: comment field
```

**Track Timing**

```qml
app.traktor.decks.[1-4].track.time.elapsed          // real: seconds played
app.traktor.decks.[1-4].track.time.remaining        // real: seconds left
app.traktor.decks.[1-4].track.time.total            // real: total track length
app.traktor.decks.[1-4].track.grid.lock             // bool: beatgrid locked?
```

**Loop Controls**

```qml
app.traktor.decks.[1-4].loop.active                 // bool: loop enabled?
app.traktor.decks.[1-4].loop.size                   // real: loop length (beats)
app.traktor.decks.[1-4].loop.in                     // trigger: set loop in point
app.traktor.decks.[1-4].loop.out                    // trigger: set loop out point
```

**Mixer Channel Controls**

```qml
app.traktor.mixer.channels.[1-4].volume             // real: 0.0-1.0 volume level
app.traktor.mixer.channels.[1-4].filter             // real: -1.0 to 1.0 filter position
app.traktor.mixer.channels.[1-4].eq.high            // real: high EQ level
app.traktor.mixer.channels.[1-4].eq.mid             // real: mid EQ level
app.traktor.mixer.channels.[1-4].eq.low             // real: low EQ level
app.traktor.mixer.channels.[1-4].fx.select          // int: selected FX unit (1-4)
app.traktor.mixer.channels.[1-4].fx.on              // bool: FX enabled for channel?
```

**Mixer Master Controls**

```qml
app.traktor.mixer.xfader.adjust                     // real: -1.0 (left) to 1.0 (right)
app.traktor.mixer.xfader.assign.[1-4]               // int: crossfader assignment
app.traktor.mixer.master.level                      // real: master output level
```

**Master Clock**

```qml
app.traktor.masterclock.tempo                       // real: master clock BPM
app.traktor.masterclock.source_id                   // int: which deck is master (1-4)
```

**Browser**

```qml
app.traktor.browser.list_selected_item              // string: selected track name
app.traktor.browser.list_navigation                 // relative: scroll up/down
app.traktor.browser.tree_navigation                 // relative: navigate tree
app.traktor.browser.sort_id                         // int: sort column ID
```

**Effects (4 FX Units)**

```qml
app.traktor.fx.4fx_units.[1-4].enabled              // bool: FX unit on/off
app.traktor.fx.4fx_units.[1-4].mix                  // real: 0.0-1.0 dry/wet mix
app.traktor.fx.4fx_units.[1-4].select               // int: select FX slot
app.traktor.fx.4fx_units.[1-4].button1              // trigger: FX button 1
app.traktor.fx.4fx_units.[1-4].button2              // trigger: FX button 2
app.traktor.fx.4fx_units.[1-4].button3              // trigger: FX button 3
app.traktor.fx.4fx_units.[1-4].knob1                // real: FX knob 1 value
app.traktor.fx.4fx_units.[1-4].knob2                // real: FX knob 2 value
app.traktor.fx.4fx_units.[1-4].knob3                // real: FX knob 3 value
```

---

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

## Debugging Checklist

### ⚡ Quick Fixes First (Solve 90% of Issues)

**Did you try turning it off and on again?**

✅ **File saved?** (Easy to forget!)
✅ **Traktor completely closed?** (Quit, not minimize - Cmd+Q / File → Exit)
✅ **Traktor restarted?** (Required for QML changes to load)
✅ **Test the specific feature** (Don't assume it worked)

**💡 If fixed, you're done! If still broken, continue below...**

---

### 🔍 Common Issues (Check These Next)

**Issue:** Changes don't appear after restart

**Check in this order** (most likely first):

1. **Did Traktor actually fully restart?** Force quit if hung (Activity Monitor/Task Manager)
2. **Did you save the file?** Check file timestamp
3. **Are you editing the right file?** Verify controller name in path (S8 vs S4MK3 vs S5)
4. **Is there a syntax error?** Check for missing `}`, `,`, or quotes
5. **Is your backup interfering?** Make sure you're not editing the backup folder

---

**Issue:** Traktor won't start at all

**Fix immediately:**

1. **Restore backup** - Delete `qml` folder, restore `qml.backup`
2. **Then investigate:**
   - Check last file you edited for syntax errors
   - Look for missing braces `{}`
   - Look for missing imports (`import CSI 1.0`)
   - Check Traktor console for QML error messages

---

**Issue:** Button/encoder not working

**Check these in order:**

1. **Wire 'from' path correct?** Verify `%surface%.button.name` matches your controller
2. **enabled: condition true?** Check shift state, browse mode, etc.
3. **Property path exists?** Try similar button/encoder to verify path
4. **Add debug logging:**
   ```qml
   Wire {
       from: "%surface%.button"
       to: ButtonScriptAdapter {
           onPress: { console.log("Button pressed!") }
       }
   }
   ```

---

**Issue:** Display showing wrong data

**Check these:**

1. **AppProperty path correct?** `app.traktor.decks.1` NOT `app.traktor.deck.1` (plural!)
2. **Binding working?** Add `console.log()` in `onValueChanged`
3. **Conditional logic reversed?** Check `value === 1` vs `value !== 1`
4. **Color/font defined?** Verify imports and color names

---

### 📋 Comprehensive Diagnostic Checklist

**If nothing above worked, go through this systematically:**

```
File & Syntax:
□ Syntax valid? (matching braces, quotes, commas)
□ All imports present? (QtQuick, CSI, custom modules)
□ File encoding UTF-8? (not ANSI or other)
□ IDs unique? (no duplicate id: values in same scope)
□ File saved with correct name/location?

Properties & Paths:
□ Property paths correct? (app.traktor.decks.1 not app.traktor.deck.1)
□ Types match? (int to int, string to string, bool to bool)
□ Property exists for your controller? (some paths S8-specific)
□ Path spelling correct? (play not Play, tempo not Tempo)

Wires & Logic:
□ Wires enabled? (check enabled: conditions aren't always false)
□ Wire 'from' path matches hardware? (button names vary by controller)
□ Adapters correct type? (Toggle vs Direct vs ButtonScript)
□ Logic conditions correct? (&&, ||, !, parentheses)

Runtime:
□ Traktor fully restarted? (not just minimized)
□ Controller connected and recognized?
□ Traktor settings correct? (controller mode, MIDI mode)
□ No conflicting modifications? (two mods changing same thing)

Safety:
□ Backup available? (for quick rollback if needed)
□ Changes documented? (what you changed and why)
```

### Debug Logging

```qml
// Add temporary logging
onValueChanged: {
    console.log("[DEBUG]", id, "changed to:", value)
}

// Remove before production - impacts performance
```

### Safe Property Access

```qml
// Prevent undefined errors
property var safeValue: (unsafeValue !== undefined) ? unsafeValue : defaultValue

// Conditional execution
if (typeof someProperty !== 'undefined' && someProperty !== null) {
    // Use someProperty
}
```

---

## Installation Quick Steps

### macOS

```bash
cd "/Applications/Native Instruments/Traktor Pro 4.app/Contents/Resources"
cp -r qml qml.backup
# Replace CSI/, Defines/, Screens/ folders
# Restart Traktor
```

### Windows

```cmd
cd "C:\Program Files\Native Instruments\Traktor Pro 4\Resources64"
xcopy qml qml.backup /E /I /H
REM Replace CSI/, Defines/, Screens/ folders
REM Restart Traktor
```

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

## Safety Checklist

Before modifying:

```
□ Backup original qml folder
□ Know which file to edit
□ Understand the change
□ Have rollback plan
```

After modifying:

```
□ Save file
□ Restart Traktor
□ Test specific feature
□ Check for errors
□ Document change
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

## Creating Your Own Customizations

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

**See**: PRACTICAL_EXAMPLES.md → Example 17, 19, 26

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

**See**: PRACTICAL_EXAMPLES.md → Example 13, 14, 16

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

**See**: PRACTICAL_EXAMPLES.md → Example 14, 16

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

**See**: PRACTICAL_EXAMPLES.md → Example 16, 27

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

**See**: PRACTICAL_EXAMPLES.md → Example 11, 22, 27

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

**See**: PRACTICAL_EXAMPLES.md → Example 14, 27

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

**See**: PRACTICAL_EXAMPLES.md → Example 15, 22

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

## Modification Templates

### Template 1: Add New Preference

**File**: `Defines/Prefs.qml`

```qml
// Add to QtObject:
readonly property [type] [name]: [defaultValue]

// Types: int, real, bool, string, variant, color
// Examples:
readonly property bool enableCustomFeature: true
readonly property int customTimeout: 5000
readonly property variant customList: ["item1", "item2"]
```

**Register in** `Defines/qmldir`:

```qml
singleton Prefs Prefs.qml
```

---

### Template 2: Swap Control Behavior (Shift Toggle)

**Pattern**: Invert `enabled` condition on Wire

```qml
// Original:
Wire { from: "..."; to: "...action1"; enabled:  shift }
Wire { from: "..."; to: "...action2"; enabled: !shift }

// Swapped:
Wire { from: "..."; to: "...action1"; enabled: !shift }
Wire { from: "..."; to: "...action2"; enabled:  shift }
```

---

### Template 3: Add Property Binding

```qml
AppProperty {
    id: [uniqueId]
    path: "app.traktor.[category].[item].[property]"
    onValueChanged: {
        // React to changes
        [action]
    }
}
```

**Common paths**:

- Deck: `app.traktor.decks.[1-4].[property]`
- Mixer: `app.traktor.mixer.channels.[1-4].[property]`
- Master: `app.traktor.masterclock.[property]`
- Browser: `app.traktor.browser.[property]`

---

### Template 4: Modify Timer Duration

```qml
Timer {
    id: [timerId]
    interval: [milliseconds]  // ← Modify this value
    repeat: [true/false]
    onTriggered: { ... }
}
```

**Common timers**:

- Overlay timeout: 3000-5000ms
- Double-tap window: 200-300ms
- Long-hold threshold: 300-500ms

---

### Template 5: Add Button Multi-Function

```qml
property bool shift: false

Wire {
    from: "%surface%.[button]"
    to: ButtonScriptAdapter {
        onPress: {
            if (shift) {
                // Shift + button action
            } else {
                // Normal button action
            }
        }
        onRelease: {
            // Optional release action
        }
    }
}
```

---

### Template 6: Conditional Display Logic

```qml
function update[Component]() {
    if ([condition1]) {
        [element].property = [value1]
    } else if ([condition2]) {
        [element].property = [value2]
    } else {
        [element].property = [defaultValue]
    }
}

// Trigger updates:
Component.onCompleted: { update[Component]() }
on[Property]Changed: { update[Component]() }
```

---

## Essential Git Commands

```bash
# Initialize
git init
git add .
git commit -m "Original files"

# Before making changes
git checkout -b my-feature

# After changes
git add .
git commit -m "Description of change"

# View changes
git diff
git log --oneline

# Revert last commit
git reset --hard HEAD~1
```

---

## Modification Risk Assessment

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

---

## Testing Checklist

After making customizations:

**Visual Tests**:

- [ ] Deck header displays correctly
- [ ] Waveforms render properly
- [ ] Browser displays all columns
- [ ] Overlays appear and disappear correctly
- [ ] Colors/fonts applied as expected
- [ ] No visual glitches or overlapping elements

**Functional Tests**:

- [ ] All buttons respond
- [ ] Encoders work correctly
- [ ] Shift combinations work
- [ ] Tempo adjustment works
- [ ] Browser navigation works
- [ ] Overlays timeout correctly
- [ ] No unexpected behavior

**Controller Tests**:

- [ ] Physical buttons match expected functions
- [ ] LEDs light up appropriately
- [ ] Touchstrip/faders work
- [ ] Pads respond correctly
- [ ] Screen displays update in real-time

---

## Rollback Instructions

If issues occur after modifications:

**Complete Rollback**:

```bash
# Restore entire QML folder from backup
rm -rf /path/to/Traktor/Resources64/qml
mv /path/to/backup/qml /path/to/Traktor/Resources64/qml
```

**Partial Rollback** (specific file):

```bash
# Restore single file from backup
cp /path/to/backup/qml/CSI/S8/Mixer.qml \
   /path/to/Traktor/Resources64/qml/CSI/S8/Mixer.qml
```

**Git Rollback**:

```bash
# Revert last commit
git reset --hard HEAD~1

# Revert specific file
git checkout HEAD -- CSI/S8/Mixer.qml

# Revert to specific commit
git reset --hard <commit-hash>
```

**Always restart Traktor** after any rollback.

---

## Maintenance Notes

### When Updating Traktor

**Before Update**:

1. Backup your custom QML folder:

   ```bash
   cp -r /path/to/Traktor/Resources64/qml \
        ~/traktor-qml-backup-$(date +%Y%m%d)
   ```

2. Document your changes:
   ```bash
   git diff > my-customizations.patch
   ```

**After Update**:

1. Traktor will replace QML files with defaults
2. Compare changes:
   ```bash
   diff -r ~/traktor-qml-backup /path/to/Traktor/Resources64/qml
   ```
3. Re-apply customizations manually or:
   ```bash
   git apply my-customizations.patch
   ```

### Version Control Best Practices

```bash
# Initial setup
cd /path/to/Traktor/Resources64/qml
git init
git add .
git commit -m "Stock Traktor QML files (version X.X.X)"

# After customizing
git add .
git commit -m "Custom: Added Camelot keys and tempo swap"

# After Traktor update
git add .
git commit -m "Traktor update to X.X.X (stock files)"
git diff HEAD~1 HEAD  # See what Traktor changed
git rebase  # Re-apply your customizations
```

---

## Troubleshooting Common Issues

### Issue: Changes Don't Appear After Restart

**Possible Causes**:

1. ✅ Edited wrong file (check controller name matches)
2. ✅ Edited wrong QML folder (Traktor may have multiple installations)
3. ✅ Syntax error prevents file from loading
4. ✅ File wasn't saved before restarting

**Solutions**:

- Verify file path matches your controller
- Check Traktor installation location
- Look for syntax errors (missing brackets, semicolons)
- Confirm file save timestamp is recent

---

### Issue: Button/Encoder Doesn't Work

**Possible Causes**:

1. ✅ Wrong `from:` path for controller
2. ✅ Multiple `Wire` with conflicting `enabled` conditions
3. ✅ `enabled: false` accidentally set
4. ✅ Property path doesn't exist for this deck type

**Solutions**:

```qml
// Check enabled condition
Wire {
    from: "%surface%.button"
    to: ...
    enabled: true  // ← Temporarily force enable to test
}

// Check for conflicts
WiresGroup {
    enabled: mode == 1  // ← Only one WiresGroup should be enabled
}

// Verify property exists
AppProperty {
    id: testProp
    path: "app.traktor.decks.1.play"
    onValueChanged: console.log("Value:", value)  // ← Debug output
}
```

---

### Issue: Display Shows Wrong/Missing Info

**Possible Causes**:

1. ✅ Wrong property path
2. ✅ Property not loaded (deck not active)
3. ✅ Text element hidden (`visible: false`)
4. ✅ Color same as background (invisible)

**Solutions**:

```qml
// Force visibility for testing
Text {
    visible: true  // ← Force visible
    color: "#FF0000"  // ← Bright red for testing
    text: "TEST"  // ← Simple text first
}

// Check property loading
AppProperty {
    id: title
    path: "app.traktor.decks." + deckId + ".track.content.title"
    onValueChanged: console.log("Title changed:", value)
}
```

---

### Issue: Timer Doesn't Fire

**Possible Causes**:

1. ✅ Timer not started (`restart()` never called)
2. ✅ Timer stopped before triggering
3. ✅ `interval` set to 0

**Solutions**:

```qml
Timer {
    id: myTimer
    interval: 1000  // ← Must be > 0
    repeat: false
    running: false  // ← Should be false, start manually
    onTriggered: {
        console.log("Timer fired!")  // ← Debug output
    }
}

// Start the timer
myTimer.restart()
```

---

### Issue: Preference Not Working

**Possible Causes**:

1. ✅ Not registered in `qmldir`
2. ✅ Wrong import path
3. ✅ Singleton not declared

**Solutions**:

```qml
// 1. Verify Prefs.qml has pragma
pragma Singleton
import QtQuick 2.12
QtObject {
    readonly property int mySetting: 500
}

// 2. Verify qmldir registration
// File: Defines/qmldir
singleton Prefs Prefs.qml

// 3. Use correct syntax
interval: Prefs.mySetting  // ✓ Correct
interval: Defines.Prefs.mySetting  // ✗ Wrong
```

---

### Issue: LED Brightness Not Changing

**Possible Causes**:

1. ✅ `brightness` property not supported on adapter type
2. ✅ Value out of range (must be 0.0-1.0)
3. ✅ Controller doesn't support variable brightness

**Solutions**:

```qml
// Use ButtonScriptAdapter for LED control
ButtonScriptAdapter {
    brightness: myCondition ? 1.0 : 0.0  // Binary on/off
    // Some controllers don't support dimming (only 0.0 or 1.0)
}

// Or for dimming (if supported)
brightness: volumeLevel  // 0.0 to 1.0
```

---

### Issue: Shift Key Not Working

**Possible Causes**:

1. ✅ `shift` property not defined in module
2. ✅ Shift state not wired from hardware
3. ✅ Wrong property name

**Solutions**:

```qml
// Verify shift property exists
Module {
    property bool shift: false  // ← Must be defined
}

// Verify shift wire exists (usually in main controller file)
Wire {
    from: "%surface%.shift"
    to: ButtonScriptAdapter {
        onPress: { shift = true }
        onRelease: { shift = false }
    }
}
```

---

### Debugging Techniques

#### Technique 1: Add Console Logging

```qml
// Add to any function or signal handler
onPress: {
    console.log("Button pressed!")
    console.log("Shift state:", shift)
    console.log("Property value:", myProperty.value)
}
```

**View logs**: Run Traktor from command line or check application logs

---

#### Technique 2: Simplify to Isolate Problem

```qml
// Replace complex logic with simple test
onPress: {
    // Complex original code...

    // Simplified test:
    console.log("Button works!")
}
```

If simple version works, add back complexity step by step.

---

#### Technique 3: Use Visual Debugging

```qml
// Add visible indicators
Rectangle {
    width: 100
    height: 20
    color: myCondition ? "green" : "red"  // Visual state indicator
    Text {
        text: myProperty.value.toString()  // Show actual values
    }
}
```

---

### Quick Diagnostic Checklist

When modification doesn't work:

```
□ File saved?
□ Traktor restarted?
□ Correct file edited? (controller name matches)
□ Syntax valid? (no missing brackets/semicolons)
□ Property path correct?
□ Wire enabled condition true?
□ No conflicting Wire?
□ Import statements present?
□ Console shows errors? (check logs)
□ Tested on correct deck/channel?
```

---

## Help & Resources

**This Project**:

- Main Guide: `TRAKTOR_QML_CUSTOMIZATION_GUIDE.md`
- Examples: `PRACTICAL_EXAMPLES.md`
- This Card: `QUICK_REFERENCE.md`

**External**:

- Qt QML Docs: https://doc.qt.io/qt-6/qml
- NI Forums: https://community.native-instruments.com/
- Traktor Bible: https://www.traktorbible.com/

---

**Print this page for quick reference while coding!**
