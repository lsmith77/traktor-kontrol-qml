# Traktor QML Practical Examples

**Purpose**: Real-world customization examples from community modifications

## 📋 Table of Contents

**📖 Getting Started:**

- [How to Use This Guide](#how-to-use-this-guide) - Learning paths & reading structure
- [Before You Start](#before-you-start) - Prerequisites & safety checklist
- [Example Categories](#example-categories) - Overview table
- [How to Apply an Example](#how-to-apply-an-example) - Step-by-step process

**🗂️ Find Examples By:**

- [Difficulty](#by-difficulty) - Beginner → Intermediate → Advanced → Expert
- [Category](#by-category) - Controller, Visual, Settings, Advanced Features
- [Controller Type](#by-controller-focus) - All, Screen Controllers, S4 MK3
- [Quick Reference Table](#quick-reference-table) - All examples with difficulty & time

**🎯 Jump to Examples:**

- [Examples 1-5](#example-1-bpm-coarsefine-adjustment-swap) - 🟢 Beginner (Controller basics, widgets, preferences)
- [Examples 6-10](#example-6-browser-additional-sorting-column) - 🟡 Intermediate (Visual customization, browser, headers)
- [Examples 11-16](#example-11-json-based-settings-file) - 🟡🟠 Intermediate-Advanced (Settings, warnings, themes)
- [Examples 17-20](#example-17-custom-jump-modes-for-pads) - 🟠 Advanced (Gestures, automation, double-tap)
- [Example 21](#example-21-external-http-api-integration) - 🔴 Expert (API integration - 4+ hours)
- [Examples 22-25](#example-22-modular-settings-framework) - 🔴 Expert (Modular systems, LED control, effects)
- [Examples 26-27](#example-26-native-tp4-buttongestures-module) - 🟢🔴 Easy-Expert (TP4 features & comprehensive UI)

**💡 Getting Help:**

- [Customizing Examples](#customizing-examples-for-your-needs) - How to adapt for your needs
- [Getting Help](#getting-help) - Troubleshooting & error messages
- See also: [README.md](README.md) for architecture overview
- See also: [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for syntax lookup
- See also: [COMPATIBILITY_FIXES.md](COMPATIBILITY_FIXES.md) for version-specific bug fixes

---

## How to Use This Guide

### Learning Path

**Beginner** (Start here):

- **Examples 1-3**: Simple modifications (swap behavior, change timers)
- **Example 4**: Understanding properties and overlays
- **Example 5**: Creating reusable widgets

**Intermediate** (Build on basics):

- **Examples 6-10**: Advanced UI customization (browser, headers, visual feedback)
- **Examples 11-13**: Settings systems and theme management
- **Examples 14-16**: Warning systems and conditional display

**Advanced** (Complex interactions):

- **Examples 17-20**: Custom gestures, auto-sync, long-hold patterns
- **Examples 21**: External API integration
- **Examples 22-25**: Modular systems, LED control, simulation effects
- **Examples 26-27**: Native TP4 features and comprehensive UI innovations

### Reading Each Example

Each example follows this structure:

1. **Default Behavior**: What Traktor does normally
2. **Customized Behavior**: What the modification achieves
3. **Implementation**: Complete working code
4. **Explanation**: Why it works and key concepts
5. **Use Cases** (when applicable): When to apply this technique

### Before You Start

**Essential Prerequisites**:

- ✅ Backup your QML folder (`Resources64/qml/`)
- ✅ Read README.md for architecture overview
- ✅ Keep QUICK_REFERENCE.md open for syntax lookup
- ✅ Test changes on one controller first
- ✅ Restart Traktor after every modification

**Understanding File Paths**:
All file paths in examples are relative to your Traktor installation:

- Windows: `C:\Program Files\Native Instruments\Traktor Pro 3\Resources64\qml\`
- macOS: `/Applications/Native Instruments/Traktor Pro 3.app/Contents/Resources/qml/`

### Example Categories

| Category                | Examples               | Focus                                 |
| ----------------------- | ---------------------- | ------------------------------------- |
| **Controller Behavior** | 1, 17-18               | Button/encoder mappings, Wire logic   |
| **Timing & Gestures**   | 2, 17, 19-20, 26       | Timers, double-tap, long-hold         |
| **Visual Display**      | 5-10, 12-13, 15-16, 27 | Screen layouts, colors, indicators    |
| **Settings Systems**    | 4, 11, 22              | Preferences, configuration            |
| **Advanced Features**   | 21, 23-25              | API integration, LED control, effects |

### How to Apply an Example

1. **Locate the file** mentioned in the example
2. **Find the code** section to modify (use line numbers as guides)
3. **Make the change** exactly as shown
4. **Save the file**
5. **Restart Traktor** (required for QML changes)
6. **Test** the functionality
7. **If it doesn't work**: Restore from backup and review

### Customizing Examples for Your Needs

Most examples can be adapted:

- **Change values**: Timer intervals, colors, thresholds
- **Combine techniques**: Mix multiple examples together
- **Adapt for controllers**: Most CSI logic works across controllers with path adjustments
- **Extend functionality**: Use examples as templates for your own ideas

### Getting Help

**If something doesn't work**:

1. Check QUICK_REFERENCE.md → Testing Checklist
2. Review the example's "Explanation" section
3. Verify file paths match your controller
4. Check for typos in property paths
5. Use QUICK_REFERENCE.md → Rollback Instructions

**Understanding Error Messages**:

- Traktor logs QML errors to console (enable developer mode)
- Missing properties = wrong path or controller mismatch
- Syntax errors = typo in QML code

---

## Examples Quick Index

### By Difficulty

**Beginner** (Start here):

- Example 1: BPM Coarse/Fine Swap
- Example 2: Extended Overlay Timeout
- Example 3: Mixer FX Overlay
- Example 4: Preferences System
- Example 5: Reusable Widgets

**Intermediate**:

- Examples 6-10: Visual Customization (browser, headers, colors)
- Examples 11-13: Settings & Theme Systems
- Examples 14-16: Warning & Indicator Systems
- Example 26: Native ButtonGestures

**Advanced**:

- Examples 17-20: Custom Gestures & Automation
- Example 21: HTTP API Integration
- Examples 22-25: Modular Systems & Effects
- Example 27: Comprehensive UI Innovations (19 features)

### By Category

**Controller Behavior** (CSI Layer):

- Example 1: Tempo swap
- Example 3: Overlay timing
- Example 17: Custom jump modes
- Example 18: Auto-sync
- Example 19: Long-hold patterns
- Example 20: Double-tap gestures
- Example 24: Vinyl break
- Example 25: Fader start
- Example 26: ButtonGestures module

**Visual Display** (Screens Layer):

- Example 5: Reusable widgets
- Example 6: Browser sorting
- Example 7: Deck header layout
- Example 8: Key display format
- Example 9: Tempo display
- Example 10: Color customization
- Example 12: Theme system
- Example 13: Phase meter
- Example 15: Touch menu
- Example 16: Time warnings
- Example 27: Dynamic waveforms & UI

**Settings & Configuration** (Defines Layer):

- Example 4: Preferences system
- Example 11: JSON settings
- Example 22: Modular settings

**Advanced Features**:

- Example 14: BPM difference warnings
- Example 21: External HTTP API
- Example 23: LED blinkers
- Example 27: 19 advanced UI features

### By Controller Focus

**All Controllers**:

- Examples 1-5, 11-14, 17-26

**Screen Controllers** (D2/S5/S8):

- Examples 6-10, 15-16, 22, 27

**S4 MK3 Specific**:

- Examples 13, 15, 17-18

### Quick Reference Table

| #   | Name             | Difficulty | Layer           | Time     |
| --- | ---------------- | ---------- | --------------- | -------- |
| 1   | Tempo Swap       | Easy       | CSI             | 5 min    |
| 2   | Overlay Timeout  | Easy       | CSI             | 5 min    |
| 3   | Mixer FX Overlay | Easy       | CSI             | 10 min   |
| 4   | Preferences      | Easy       | Defines         | 15 min   |
| 5   | Reusable Widgets | Easy       | Screens         | 20 min   |
| 6   | Browser Sorting  | Medium     | Screens         | 30 min   |
| 7   | Deck Header      | Medium     | Screens         | 30 min   |
| 8   | Key Display      | Medium     | Screens         | 20 min   |
| 9   | Tempo Display    | Medium     | Screens         | 20 min   |
| 10  | Color Scheme     | Easy       | Screens         | 15 min   |
| 11  | JSON Settings    | Advanced   | Defines         | 2 hrs    |
| 12  | Theme System     | Advanced   | Screens         | 2 hrs    |
| 13  | Phase Meter      | Medium     | Screens         | 45 min   |
| 14  | BPM Warnings     | Medium     | Screens         | 45 min   |
| 15  | Touch Menu       | Medium     | Screens         | 1 hr     |
| 16  | Time Warnings    | Medium     | Screens         | 45 min   |
| 17  | Custom Jump      | Advanced   | CSI             | 1 hr     |
| 18  | Auto-Sync        | Medium     | CSI             | 30 min   |
| 19  | Long-Hold        | Advanced   | CSI             | 1 hr     |
| 20  | Double-Tap       | Advanced   | CSI             | 1 hr     |
| 21  | HTTP API         | Expert     | CSI/External    | 4 hrs    |
| 22  | Modular Settings | Expert     | Defines/Screens | 4 hrs    |
| 23  | LED Blinkers     | Advanced   | CSI             | 2 hrs    |
| 24  | Vinyl Break      | Advanced   | CSI             | 2 hrs    |
| 25  | Fader Start      | Advanced   | CSI             | 2 hrs    |
| 26  | ButtonGestures   | Easy       | CSI             | 15 min   |
| 27  | UI Innovations   | Expert     | All Layers      | Full day |

---

## 🎚️ Example 1: BPM Coarse/Fine Adjustment Swap

**Difficulty**: 🟢 Beginner | **Layer**: 🔌 CSI | **Time**: 5 min | **Controllers**: All ✓

### Default Behavior (Native Instruments)

When adjusting the master tempo encoder:

- **Normal**: Fine adjustment (small BPM changes)
- **Shift+Encoder**: Coarse adjustment (large BPM changes)

### Customized Behavior

Swap this so coarse is the default:

- **Normal**: Coarse adjustment (large BPM changes)
- **Shift+Encoder**: Fine adjustment (small BPM changes)

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Wire.enabled controls when connections are active - multiple wires can share the same input
• Boolean logic with shift states (!shift vs shift) determines which mode is default
• Simple property inversion changes behavior without modifying underlying functionality
• Use this pattern anytime you want to swap primary/secondary button behaviors
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation

**File**: `CSI/S8/Mixer.qml`

**Original Code (default Traktor)**:

```qml
import CSI 1.0

Module
{
    id: mixer
    property bool shift: false
    property string surface: ""

    // Master Clock
    MasterClock { name: "MasterTempo" }
    Wire { from: "%surface%.mixer.tempo"; to: "MasterTempo.coarse"; enabled:  shift }
    Wire { from: "%surface%.mixer.tempo"; to: "MasterTempo.fine";   enabled: !shift }

    // ... rest of file
}
```

**Modified Code**:

```qml
import CSI 1.0

Module
{
    id: mixer
    property bool shift: false
    property string surface: ""

    // Master Clock
    MasterClock { name: "MasterTempo" }
    Wire { from: "%surface%.mixer.tempo"; to: "MasterTempo.coarse"; enabled: !shift }  // ← Inverted
    Wire { from: "%surface%.mixer.tempo"; to: "MasterTempo.fine";   enabled:  shift }  // ← Inverted

    // ... rest of file
}
```

### Explanation

The `enabled` property on each `Wire` controls when that connection is active. By swapping `!shift` and `shift`, we reverse which mode is active by default.

**Key Concept**: Multiple wires can connect the same input to different outputs. Only one wire is active at a time based on the `enabled` condition.

### See Also

**Related Examples:**

- [Example 8 (Shift+Flux = Flux Reverse)](#🔄-example-8-shiftflux--flux-reverse) - Another shift-based behavior swap using the same technique
- [Example 17 (Custom Jump Modes)](#🎯-example-17-custom-jump-mode-with-pad-layout) - Advanced CSI layer customization with conditional wire routing

**Quick Reference:**

- [QUICK_REFERENCE.md → Swap Shift Behavior](#2-swap-shift-behavior) - Copy-paste template for this pattern
- [QUICK_REFERENCE.md → Wire Adapters Reference](#wire-adapters-quick-reference) - Understanding Wire types and enabled conditions

**Prerequisites/Background:**

- [README.md → CSI Layer](#✅-🎛️-controller-behavior-csi-layer) - Understanding controller behavior customization
- [README.md → Key Concepts](#key-concepts) - Wire and property adapter fundamentals

---

## ⏱️ Example 2: Extended Overlay Timeout

**Difficulty**: 🟢 Beginner | **Layer**: 🔌 CSI | **Time**: 5 min | **Controllers**: All ✓

### Default Behavior

BPM and Key overlays disappear after 3 seconds of inactivity.

### Customized Behavior

Overlays stay visible for 5 seconds instead.

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Timer.interval is specified in milliseconds (1000ms = 1 second)
• onTriggered executes when timer completes - perfect for auto-hide behaviors
• Adjust timing to match your workflow needs (longer for complex mixing scenarios)
• This pattern applies to any temporary overlay or visual feedback system
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation

**File**: `CSI/Common/Deck_S8Style.qml`

**Original Code (default Traktor, line ~67)**:

```qml
Timer {
    id: overlay_countdown
    interval: 3000
    onTriggered:
    {
        if (keyOrBPMOverlay) {
            screenOverlay.value = Overlay.none
        }
    }
}
```

**Modified Code**:

```qml
Timer {
    id: overlay_countdown
    interval: 5000  // ← Changed from 3000 to 5000
    onTriggered:
    {
        if (keyOrBPMOverlay) {
            screenOverlay.value = Overlay.none
        }
    }
}
```

### Explanation

The `interval` property is specified in milliseconds:

- 3000ms = 3 seconds
- 5000ms = 5 seconds

When the timer triggers after the interval, it sets the overlay back to `Overlay.none` (hidden).

### See Also

**Related Examples:**

- [Example 3 (Mixer FX Overlay)](#🎛️-example-3-mixer-fx-overlay-support) - Extends the same overlay system with additional functionality
- [Example 10 (Fast Double-Tap Detection)](#🎨-example-10-fast-double-tap-detection-200ms) - Another timer-based pattern with 200ms intervals
- [Example 19 (Long-Press Patterns)](#👆-example-19-touch-hotcues-with-long-press) - Advanced timer usage for gesture detection

**Quick Reference:**

- [QUICK_REFERENCE.md → Change Timer Duration](#1-change-timer-duration) - Simple pattern for modifying any timer interval
- [QUICK_REFERENCE.md → Modify Timer Duration Template](#template-4-modify-timer-duration) - Step-by-step template

**Prerequisites/Background:**

- [README.md → Quick Start: Your First Mod](#🚀-quick-start-your-first-mod-5-minutes) - This example is recommended as your first modification
- [README.md → The Three Layers](#the-three-layers) - Understanding where timers live in the CSI layer

---

## 🎛️ Example 3: Mixer FX Overlay Support

**Difficulty**: 🟢 Beginner | **Layer**: 🔌 CSI | **Time**: 10 min | **Controllers**: All ✓

### Default Behavior

Only BPM and Key overlays trigger the auto-hide timer.

### Customized Behavior

Add support for a Mixer FX overlay that also auto-hides.

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• AppProperty bindings read Traktor's internal state in real-time
• onValueChanged fires whenever a property updates - perfect for triggering overlay logic
• Extend existing conditions with || (OR) to add new overlay types
• Combining properties + conditional logic creates powerful dynamic UI behaviors
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation

**File**: `CSI/Common/Deck_S8Style.qml`

**Added Properties (customized version, near line 14)**:

```qml
property bool keyOrBPMOverlay: false
property bool tempBPMOverlay: false  // ← New property

readonly property double syncPhase: (syncPhaseProp.value * 2.0).toFixed(2)  // ← New property
```

**Added AppProperties** (near line 48):

```qml
AppProperty { id: masterDeckIdProp; path: "app.traktor.masterclock.source_id" }
AppProperty { id: isTempoSynced;    path: "app.traktor.decks." + (focusedDeckId) + ".sync.enabled" }
AppProperty { id: syncPhaseProp;    path: "app.traktor.decks." + (focusedDeckId) + ".tempo.phase" }  // ← New
AppProperty { id: mixerFxSelect;    path: "app.traktor.mixer.channels." + focusedDeckId + ".fx.select" }  // ← New
```

**Modified Overlay Detection (customized version, near line 32)**:

```qml
MappingPropertyDescriptor {
    id: screenOverlay
    path: propertiesPath + ".overlay"
    type: MappingPropertyDescriptor.Integer
    value: Overlay.none
    onValueChanged: {
        // Original:
        // keyOrBPMOverlay = screenOverlay.value == Overlay.bpm || screenOverlay.value == Overlay.key

        // Modified:
        keyOrBPMOverlay = screenOverlay.value == Overlay.bpm ||
                          screenOverlay.value == Overlay.key ||
                          screenOverlay.value == Overlay.mixerFx  // ← Added

        if (value == Overlay.fx) {
            editMode.value = editModeNone
        }
        // idle timeout for BPM and Key overlays
        if (keyOrBPMOverlay) {
            overlay_countdown.restart()
        }
    }
}
```

### Explanation

**Three key changes**:

1. **New properties** to track sync phase and mixer FX selection
2. **New AppProperty bindings** to read Traktor's internal state
3. **Extended condition** to include `Overlay.mixerFx` in the auto-hide logic

This allows the Mixer FX overlay to behave like the BPM and Key overlays - appearing when activated and auto-hiding after 5 seconds of inactivity.

### See Also

**Related Examples:**

- [Example 2 (Extended Overlay Timeout)](#⏱️-example-2-extended-overlay-timeout) - Base overlay timer system that this builds upon
- [Example 4 (Preferences System)](#⚙️-example-4-custom-preferences-system) - How to manage properties like `mixerFxSelect` centrally

**Quick Reference:**

- [QUICK_REFERENCE.md → Bind to Traktor Property](#4-bind-to-traktor-property) - Understanding AppProperty bindings
- [QUICK_REFERENCE.md → Common Property Paths](#common-property-paths) - Reference for mixer and deck property paths
- [QUICK_REFERENCE.md → Conditionals](#conditionals) - Syntax for multi-condition logic

**Prerequisites/Background:**

- [README.md → Key Concepts](#key-concepts) - AppProperty and MappingProperty fundamentals
- [README.md → CSI Layer](#✅-🎛️-controller-behavior-csi-layer) - Where overlay logic is controlled

---

## ⚙️ Example 4: Custom Preferences System

**Difficulty**: 🟢 Beginner | **Layer**: ⚙️ Defines | **Time**: 15 min | **Controllers**: All ✓

### Default Behavior

No centralized preferences file - settings scattered across multiple files.

### Customized Behavior

Create a singleton preferences file that can be imported anywhere.

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• pragma Singleton creates a globally accessible object with one shared instance
• qmldir file registers singletons so QML can find them across all files
• readonly property ensures values can't be accidentally modified at runtime
• Essential for maintaining consistent settings across complex multi-file customizations
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation

**File**: `Defines/Prefs.qml` (Custom addition - not in default Traktor)

```qml
pragma Singleton

import QtQuick 2.0

QtObject {
    // Number of bars per phrase for the beat counter
    readonly property int barsPerPhrase: 4

    // Display Open Key as Camelot Key
    readonly property bool camelotKey: true

    // List of Mixer FX selected in Traktor Preferences > Mixer
    // BRPL: Barber Pole
    // CRSH: Crush
    // DLDL: Dual Delay
    // DTDL: Dotted Delay
    // FLNG: Flanger
    // FLTR: Filter
    // NOISE: Noise
    // RVRB: Reverb
    // TIMG: Time Gater
    readonly property var mixerFxSlots: [
        "RVRB",
        "DLDL",
        "NOISE",
        "TIMG",
    ]

    // Move playmarker position to the left
    readonly property bool playmarkerPositionLeft: true

    // Display bar markers on large waveform
    readonly property bool waveformBarMarkers: true

    // Display minute markers on stripe waveform
    readonly property bool waveformMinuteMarkers: true

    // Waveform colors
    //  0: Default
    //  1: Red
    //  2: Dark Orange
    //  3: Light Orange
    //  4: Warm Yellow
    //  5: Yellow
    //  6: Lime
    //  7: Green
    //  8: Mint
    //  9: Cyan
    // 10: Turquoise
    // 11: Blue
    // 12: Plum
    // 13: Violet
    // 14: Purple
    // 15: Magenta
    // 16: Fuchsia
    // 17: Infrared
    // 18: Ultraviolet
    // 19: X-Ray
    // 20: Nexus
    // 21: Prime
    // 22: RB 3Band
    readonly property int waveformColors: 20
}
```

**File**: `Defines/qmldir` (Modified in custom version)

**Original**:

```qml
singleton Overlay           Overlay.qml
singleton FxOverlay         FxOverlay.qml
singleton FooterPage        FooterPage.qml
singleton StemStyle         StemStyle.qml
singleton ScreenView        ScreenView.qml
singleton PadsMode          PadsMode.qml
singleton LoopSize          LoopSize.qml
singleton MoveSize          MoveSize.qml
singleton JumpSize          JumpSize.qml
singleton NavigationMode    NavigationMode.qml
```

**Modified**:

```qml
singleton Overlay           Overlay.qml
singleton FxOverlay         FxOverlay.qml
singleton FooterPage        FooterPage.qml
singleton StemStyle         StemStyle.qml
singleton ScreenView        ScreenView.qml
singleton PadsMode          PadsMode.qml
singleton LoopSize          LoopSize.qml
singleton MoveSize          MoveSize.qml
singleton JumpSize          JumpSize.qml
singleton NavigationMode    NavigationMode.qml
singleton Prefs             Prefs.qml  // ← Added
```

**Usage Example** (in any QML file):

```qml
import "../../Defines"

Rectangle {
    visible: Prefs.waveformBarMarkers  // ← Access preference

    Text {
        text: Prefs.camelotKey ? toCamelot(key) : key
    }
}
```

### Explanation

**Singleton Pattern**: The `pragma Singleton` directive makes this QML object available globally with a single shared instance.

**Registration**: The `qmldir` file tells QML where to find the singleton.

**Benefits**:

- Single source of truth for preferences
- Easy to modify - change one file instead of many
- Type-safe - QML checks property types at load time
- Self-documenting - all options in one place with comments

### See Also

**Related Examples:**

- [Example 11 (JSON-Based Settings)](#📁-example-11-json-based-settings-system) - Advanced settings system that loads from external JSON files
- [Example 22 (Modular Settings Framework)](#🏗️-example-22-modular-settings-system) - Expert-level settings architecture
- [Example 12 (Theme System)](#🎨-example-12-multi-theme-waveform-system) - Uses preferences to manage multiple visual themes

**Quick Reference:**

- [QUICK_REFERENCE.md → Add New Preference](#3-add-new-preference) - How to add properties to this file
- [QUICK_REFERENCE.md → Property Types Reference](#property-types-reference) - Understanding readonly, var, int, bool types

**Prerequisites/Background:**

- [README.md → Defines Layer](#✅-⚙️-settings--configuration-defines-layer) - Understanding the configuration layer
- [README.md → Decision Tree → Global Settings](#decision-tree-finding-the-right-file) - When to use Defines/Prefs.qml

---

## 🖼️ Example 5: Deck Header Layout Customization

**Difficulty**: 🟢 Beginner | **Layer**: 🖼️ Screens | **Time**: 20 min | **Controllers**: All controllers

### Default Behavior

Deck header shows track title across most of the header.

### Customized Behavior

Reorganize header to show: Title | Remaining Time + Beats | BPM + Tempo

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• State mapping integers (0, 14, 17) reference specific data sources in Traktor
• anchors.leftMargin positions elements horizontally - measure pixel positions carefully
• Monospaced fonts (Pragmatica) prevent number jitter as values change
• Use this to reorganize any header information to match your DJing priorities
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation

**File**: `Screens/S8/Views/Deck/DeckHeader.qml`

**Layout Definition** (around line 42):

```qml
// PROPERTY SELECTION
// IMPORTANT: See 'stateMapping' in DeckHeaderText.qml for the correct Mapping from
//            the state-enum in c++ to the corresponding state
// NOTE: For now, we set fix states in the DeckHeader! But we wanna be able to
//       change the states.
property int topLeftState:   0                                   // Title
property int topMiddleState: hasTrackStyleHeader(deckType) ? 14 : 29  // Remaining Time
property int topRightState:  hasTrackStyleHeader(deckType) ? 17 : 30  // BPM
```

**Text Positioning** (around line 123):

```qml
// top_left_text: TITLE
DeckHeaderText {
    id: top_left_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth: 276
    textState: topLeftState
    color: textColors[deck_Id]
    elide: Text.ElideRight
    font.pixelSize: fonts.scale(13)
    anchors.top: top_line.bottom
    anchors.left: parent.left
    anchors.topMargin: -1
    anchors.leftMargin: 3
}

// top_middle_text: REMAINING TIME
DeckHeaderText {
    id: top_middle_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth: 50
    textState: topMiddleState
    font.family: "Pragmatica" // is monospaced
    color: textColors[deck_Id]
    elide: Text.ElideRight
    font.pixelSize: fonts.scale(13)
    horizontalAlignment: Text.AlignRight
    anchors.top: top_line.bottom
    anchors.left: parent.left
    anchors.topMargin: 1
    anchors.leftMargin: 299  // ← Positioned to the right
}

// top_right_text: BPM
DeckHeaderText {
    id: top_right_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth: 80
    textState: topRightState
    font.family: "Pragmatica" // is monospaced
    color: textColors[deck_Id]
    elide: Text.ElideRight
    font.pixelSize: fonts.scale(13)
    anchors.top: top_line.bottom
    anchors.left: parent.left
    anchors.topMargin: 1
    anchors.leftMargin: 393  // ← Positioned at far right
}
```

### Explanation

**State Mapping**: Each number corresponds to a specific data source:

- `0` = Track title
- `14` = Remaining time with beat counter
- `17` = BPM with tempo percentage

**Positioning**: Using `anchors.leftMargin` to position elements:

- Left: 3px (title starts near left edge)
- Middle: 299px (remaining time)
- Right: 393px (BPM)

**Font Choice**: `"Pragmatica"` is monospaced, ensuring numbers don't jump around as values change.

### See Also

**Related Examples:**

- [Example 6 (Browser Sorting)](#📊-example-6-browser-sorting-options) - Browser customization using similar state mapping concepts
- [Example 9 (Browse Encoder Zoom)](#🔍-example-9-browse-encoder-for-waveform-zoom) - More Screens layer display modifications
- [Example 16 (Time Warnings)](#⏰-example-16-time-warning-system-with-color-indicators) - Advanced deck header with conditional displays

**Quick Reference:**

- [QUICK_REFERENCE.md → Position Element](#8-position-element) - Anchoring and positioning syntax
- [QUICK_REFERENCE.md → Change Font](#7-change-font) - Font properties and scaling
- [QUICK_REFERENCE.md → File Locations → Screen header layout](#file-locations-quick-map) - Where to find DeckHeader.qml

**Prerequisites/Background:**

- [INDEX.md → Screens Layer](#✅-🖥️-visual-display-screens-layer) - Understanding visual display customization
- [INDEX.md → Decision Tree → Visual Display](#decision-tree-finding-the-right-file) - Finding the right Screens files

---

## 📊 Example 6: Browser Sorting Options

**Difficulty**: 🟡 Intermediate | **Layer**: 🖼️ Screens | **Time**: 30 min | **Controllers**: Screen controllers

### Default Behavior

Limited sorting options in browser footer.

### Customized Behavior

Add "Genre" and "Release" to available sort options.

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Traktor database columns have numeric IDs (e.g., 15=Genre, 26=Release)
• Parallel arrays (sortIds and sortNames) must stay synchronized by index
• Column IDs discovered through reverse-engineering and community knowledge
• Add any database field to browser sorting with the right column ID
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation

**File**: `Screens/S8/Views/Browser/BrowserFooter.qml`

**Note**: Full diff is complex, but key change is in the sort arrays.

**Key Modification**:

```qml
// The given numbers are determined by the EContentListColumns in Traktor
readonly property variant sortIds: [
    0,   // Sort By #
    2,   // Title
    3,   // Artist
    5,   // BPM
    28,  // Key
    22,  // Rating
    27,  // Import Date
    15,  // Genre (Added in custom version)
    26   // Release (Added in custom version)
]

readonly property variant sortNames: [
    "Sort By #",
    "Title",
    "Artist",
    "BPM",
    "Key",
    "Rating",
    "Import Date",
    "Genre",      // Added
    "Release"     // Added
]
```

### Explanation

**Column IDs**: Traktor's internal database uses numeric column IDs:

- `15` = Genre column
- `26` = Release column

**Parallel Arrays**: `sortIds` and `sortNames` must match in length - index 7 in both arrays refers to Genre.

**Discovery**: These column IDs can be found by:

1. Reverse-engineering Traktor.exe
2. Trial and error with different numbers
3. Community knowledge sharing

### See Also

**Related Examples:**

- [Example 7 (Conditional Key Coloring)](#🎨-example-7-conditional-key-coloring-in-browser) - More browser customization techniques
- [Example 5 (Deck Header Layout)](#🖼️-example-5-deck-header-layout-customization) - Similar state mapping and layout concepts

**Quick Reference:**

- [QUICK_REFERENCE.md → File Locations → Browser appearance](#file-locations-quick-map) - Where to find browser files
- [QUICK_REFERENCE.md → Property Types Reference](#property-types-reference) - Working with variant (array) types

**Prerequisites/Background:**

- [INDEX.md → Screens Layer](#✅-🖥️-visual-display-screens-layer) - Understanding visual customization
- [INDEX.md → Decision Tree → Visual Display](#decision-tree-finding-the-right-file) - Finding browser files

---

## 🎨 Example 7: Conditional Key Coloring in Browser

**Difficulty**: 🟡 Intermediate | **Layer**: 🖼️ Screens | **Time**: 30 min | **Controllers**: Screen controllers

### Concept

Only color keys that are harmonically compatible with the master deck.

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Camelot Wheel math: compatible keys are ±0, ±1, or ±7 positions apart
• AppProperty paths can reference master deck dynamically for context-aware UI
• Color-coding provides instant visual feedback for harmonic mixing decisions
• Combine music theory algorithms with QML for intelligent track selection aids
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation Approach

**File**: Custom logic in browser list delegate

```qml
// Pseudo-code structure (simplified)

AppProperty {
    id: masterDeckKey
    path: "app.traktor.decks." + masterDeckId + ".track.content.musical_key"
}

AppProperty {
    id: currentItemKey
    path: "app.traktor.browser.preview_content.musical_key"
}

Rectangle {
    id: keyDisplay
    color: isHarmonicWith(masterDeckKey.value, currentItemKey.value)
           ? colors.colorGreen
           : colors.colorWhite
}

function isHarmonicWith(key1, key2) {
    // Camelot wheel logic
    var camelot1 = toCamelotNumber(key1)
    var camelot2 = toCamelotNumber(key2)
    var distance = Math.abs(camelot1 - camelot2)

    // Harmonic if: same key, ±1, or ±7 (opposite gender)
    return distance == 0 || distance == 1 || distance == 7
}

function toCamelotNumber(openKey) {
    var mapping = {
        "1d": 8,  "1m": 5,
        "2d": 3,  "2m": 12,
        "3d": 10, "3m": 7,
        // ... full mapping
    }
    return mapping[openKey] || 0
}
```

### Explanation

**Harmonic Mixing Rules** (Camelot Wheel):

- **Same key**: Perfect match (e.g., 8B → 8B)
- **±1**: Adjacent keys (e.g., 8B → 9B or 7B)
- **±7**: Energy shift, same tonality (e.g., 8B → 3B)

**Visual Feedback**: Compatible keys show in green, incompatible in white/gray.

### See Also

**Related Examples:**

- [Example 6 (Browser Sorting)](#📊-example-6-browser-sorting-options) - Browser modification foundation
- [Example 10 (Color Customization)](#🎨-example-10-fast-double-tap-detection-200ms) - More color-based conditional logic
- [Example 14 (BPM Warnings)](#⚠️-example-14-bpm-difference-warning-system) - Similar conditional color warnings

**Quick Reference:**

- [QUICK_REFERENCE.md → Change Color](#6-change-color) - Conditional color syntax
- [QUICK_REFERENCE.md → Conditionals](#conditionals) - If/else and ternary operators
- [QUICK_REFERENCE.md → Common Property Paths → Deck Properties](#deck-properties) - musical_key property path

**Prerequisites/Background:**

- [INDEX.md → Screens Layer](#✅-🖥️-visual-display-screens-layer) - Visual display fundamentals
- [INDEX.md → Key Concepts](#key-concepts) - AppProperty bindings for track data

---

## 🔄 Example 8: Shift+Flux = Flux Reverse

**Difficulty**: 🟡 Intermediate | **Layer**: 🖼️ Screens | **Time**: 20 min | **Controllers**: All controllers

### Default Behavior

Flux button only toggles flux mode on/off.

### Customized Behavior

- **Flux**: Normal flux mode
- **Shift+Flux**: Flux reverse mode

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• ButtonScriptAdapter enables custom JavaScript logic on button press/release
• Single physical button can trigger multiple Traktor properties with shift logic
• flux_reverse.enabled is an undocumented property found through reverse-engineering
• This pattern works for any button where you want shift to access alternate functionality
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation

**File**: Deck-specific QML (e.g., `S8Deck.qml`)

```qml
AppProperty {
    id: fluxEnabled
    path: "app.traktor.decks." + deckId + ".flux.enabled"
}

AppProperty {
    id: fluxReverse
    path: "app.traktor.decks." + deckId + ".flux_reverse.enabled"
}

property bool shift: false

Wire {
    from: "%surface%.deck.flux"
    to: ButtonScriptAdapter {
        onPress: {
            if (shift) {
                // Shift+Flux = Toggle Flux Reverse
                fluxReverse.value = !fluxReverse.value
            } else {
                // Normal Flux = Toggle Flux Mode
                fluxEnabled.value = !fluxEnabled.value
            }
        }
    }
}
```

### Explanation

**Button Logic**: Single physical button performs two functions based on shift state.

**Property Paths**:

- `flux.enabled` - Standard flux mode
- `flux_reverse.enabled` - Flux reverse (plays backwards while button held)

**Discovery**: The flux_reverse property was found by examining Traktor.exe internals, as it's not exposed in the UI but exists in the codebase.

### See Also

**Related Examples:**

- [Example 1 (BPM Coarse/Fine Swap)](#🎚️-example-1-bpm-coarsefine-adjustment-swap) - Uses the same shift-based wire pattern
- [Example 19 (Long-Press Patterns)](#👆-example-19-touch-hotcues-with-long-press) - Advanced multi-function button patterns
- [Example 20 (Dual Actions)](#👆-example-20-touch-color-fx-with-dual-actions) - Another shift+button customization

**Quick Reference:**

- [QUICK_REFERENCE.md → Multi-Function Button](#5-multi-function-button) - Template for shift-based buttons
- [QUICK_REFERENCE.md → Swap Shift Behavior](#2-swap-shift-behavior) - Pattern used here
- [QUICK_REFERENCE.md → Common Property Paths → Deck Properties](#deck-properties) - flux property paths

**Prerequisites/Background:**

- [README.md → CSI Layer](#✅-🎛️-controller-behavior-csi-layer) - Controller button logic
- [README.md → Key Concepts](#key-concepts) - ButtonScriptAdapter for custom logic

---

## 🔍 Example 9: Browse Encoder for Waveform Zoom

**Difficulty**: 🟡 Intermediate | **Layer**: 🖼️ Screens | **Time**: 20 min | **Controllers**: Screen controllers

### Default Behavior

Browse encoder only scrolls through browser lists.

### Customized Behavior

When viewing a track deck, browse encoder zooms waveform in/out.

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• EncoderScriptAdapter.onIncrement/onDecrement handle encoder rotation events
• Math.min/max clamps values to valid ranges (prevents out-of-bounds errors)
• Wire.enabled with DeckType conditions makes context-aware encoder behavior
• Repurpose encoders based on screen state for maximum controller efficiency
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation

**File**: Deck-specific QML

```qml
AppProperty {
    id: waveformZoom
    path: "app.traktor.decks." + deckId + ".track.waveform_zoom"
}

AppProperty {
    id: deckType
    path: "app.traktor.decks." + deckId + ".type"
}

Wire {
    from: "%surface%.browse"
    to: EncoderScriptAdapter {
        onIncrement: {
            // Zoom in (more detail)
            waveformZoom.value = Math.min(waveformZoom.value + 0.1, 2.0)
        }
        onDecrement: {
            // Zoom out (less detail)
            waveformZoom.value = Math.max(waveformZoom.value - 0.1, 0.1)
        }
    }
    enabled: deckType.value == DeckType.Track  // Only for track decks
}
```

### Explanation

**Conditional Enable**: Wire only active when `deckType.value == DeckType.Track`.

**Zoom Range**:

- Minimum: 0.1 (zoomed out, seeing more time)
- Maximum: 2.0 (zoomed in, seeing more detail)
- Step: 0.1 per encoder tick

**Math.min/max**: Clamps value within valid range.

### See Also

**Related Examples:**

- [Example 5 (Deck Header Layout)](#🖼️-example-5-deck-header-layout-customization) - Similar Screens layer modifications
- [Example 17 (Custom Jump Modes)](#🎯-example-17-custom-jump-mode-with-pad-layout) - EncoderScriptAdapter for custom encoder logic
- [Example 26 (ButtonGestures)](#👆-example-26-native-buttongestures-module-traktor-pro-4) - More encoder and gesture-based controls

**Quick Reference:**

- [QUICK_REFERENCE.md → Wire Adapters → EncoderScriptAdapter](#wire-adapters-quick-reference) - How encoders work
- [QUICK_REFERENCE.md → Common Property Paths → Deck Properties](#deck-properties) - waveform_zoom property
- [QUICK_REFERENCE.md → Conditionals](#conditionals) - enabled: conditions with deck types

**Prerequisites/Background:**

- [README.md → CSI Layer](#✅-🎛️-controller-behavior-csi-layer) - Controller encoder behavior
- [README.md → Key Concepts](#key-concepts) - EncoderScriptAdapter fundamentals

---

## 🎨 Example 10: Fast Double-Tap Detection (200ms)

**Difficulty**: 🟢 Beginner | **Layer**: 🖼️ Screens | **Time**: 15 min | **Controllers**: All controllers

### Default Behavior

Native implementation uses 1-second delay.

### Customized Behavior

Custom 200-250ms double-tap detection for more responsive feel.

### Key Concepts

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Date.now() provides millisecond timestamps for precise timing detection
• 200-250ms window balances responsiveness vs accidental double-tap triggering
• Timer delays single-tap action to avoid conflicts with double-tap detection
• Essential pattern for advanced button gestures (double-tap to loop, shift-double-tap, etc.)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Implementation

```qml
// State tracking
property int tapCount: 0
property real lastTapTime: 0

Timer {
    id: doubleTapTimer
    interval: 250  // 250ms window for second tap
    repeat: false
    onTriggered: {
        if (tapCount == 1) {
            // Single tap confirmed
            executeSingleTap()
        }
        tapCount = 0
    }
}

Wire {
    from: "%surface%.deck.play"
    to: ButtonScriptAdapter {
        onPress: {
            var currentTime = Date.now()
            var timeSinceLastTap = currentTime - lastTapTime

            if (timeSinceLastTap < 250) {
                // Second tap within 250ms = double tap!
                doubleTapTimer.stop()
                executeDoubleTap()
                tapCount = 0
            } else {
                // First tap
                tapCount = 1
                doubleTapTimer.start()
            }

            lastTapTime = currentTime
        }
    }
}

function executeSingleTap() {
    // Single tap action (e.g., play/pause)
    playEnabled.value = !playEnabled.value
}

function executeDoubleTap() {
    // Double tap action (e.g., return to cue point)
    cueTrigger.value = true
}
```

### Explanation

**Algorithm**:

1. On button press, check time since last press
2. If < 250ms → Double tap detected
3. If ≥ 250ms → Start timer, wait for potential second tap
4. If timer expires (250ms) → Confirm single tap

**Why 250ms?**: Fast enough to feel instant, slow enough to be reliable.

**Community Innovation**: Native Instruments later added double-tap with 1-second delay. Community mods had it first with better timing.

### See Also

**Related Examples:**

- [Example 2 (Extended Overlay Timeout)](#⏱️-example-2-extended-overlay-timeout) - Basic timer usage (simpler starting point)
- [Example 19 (Long-Press Patterns)](#👆-example-19-touch-hotcues-with-long-press) - Advanced timer-based gestures
- [Example 20 (Double-Tap Gestures)](#👆-example-20-touch-color-fx-with-dual-actions) - Similar double-tap implementation
- [Example 26 (Native ButtonGestures)](#👆-example-26-native-buttongestures-module-traktor-pro-4) - TP4's built-in double-tap support

**Quick Reference:**

- [QUICK_REFERENCE.md → Change Timer Duration](#1-change-timer-duration) - Basic timer syntax
- [QUICK_REFERENCE.md → Multi-Function Button](#5-multi-function-button) - ButtonScriptAdapter pattern
- [QUICK_REFERENCE.md → Functions](#functions) - JavaScript function syntax in QML

**Prerequisites/Background:**

- [README.md → CSI Layer](#✅-🎛️-controller-behavior-csi-layer) - Timer-based logic
- [README.md → Key Concepts](#key-concepts) - Timer and ButtonScriptAdapter
- [README.md → Advanced Features](#✅-🚀-advanced-features-all-layers-combined) - Gesture detection overview

---

## Summary

These examples demonstrate:

1. **Simple property changes** (timer intervals, colors)
2. **Control flow modifications** (swapping enabled conditions)
3. **New feature additions** (Mixer FX overlay, preferences)
4. **Layout customization** (deck header reorganization)
5. **Advanced logic** (double-tap, harmonic mixing)

All customizations follow QML's declarative paradigm while adding JavaScript logic where needed. The key is understanding the relationship between:

- **Hardware** (controllers) ↔ **Wire** ↔ **Properties** ↔ **Traktor internals**
- **Properties** ↔ **Visual Elements** ↔ **Screen rendering**

---

## 📁 Example 11: JSON-Based Settings System

**Difficulty**: 🟠 Advanced | **Layer**: ⚙️ Defines | **Time**: 2 hrs | **Controllers**: All controllers

Sophisticated JSON-based settings system that allows real-time configuration changes without restarting Traktor.

### ConfigLoader Pattern

```qml
// CSI/Common/Settings/ConfigLoader.qml
import CSI 1.0
import QtQuick

Item {
  id: configLoader

  AppProperty { id: traktorPath; path: "app.traktor.settings.paths.root" }

  readonly property string _XMLHTTP_GET: "GET"
  readonly property string _XMLHTTP_PUT: "PUT"
  readonly property bool _XMLHTTP_ASYNCHRO: true
  readonly property int _XMLHTTP_DONE: 4

  signal configLoaded()
  signal configSaved()
  signal notifyLog(string message, string level)

  Component.onCompleted: {
    loadConfigAsync()
  }

  function loadConfigAsync() {
    var configpath = getSettingsFilePath()
    notifyLog("Loading config from: " + configpath, "INFO")

    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
      if (xhr.readyState === _XMLHTTP_DONE) {
        if (xhr.status === 200) {
          try {
            var prefsTemp = JSON.parse(xhr.responseText)
            updatePrefs(prefsTemp)
            configLoaded()
          } catch (e) {
            notifyLog("Error parsing config: " + e.message, "ERROR")
            saveConfig(prefs)
          }
        }
      }
    }
    xhr.open(_XMLHTTP_GET, configpath, _XMLHTTP_ASYNCHRO)
    xhr.send()
  }

  function saveConfig(prefs) {
    var configData = prepareConfigData(prefs)
    var configpath = getSettingsFilePath()
    var jsonString = JSON.stringify(configData, null, 2)

    var xhr = new XMLHttpRequest()
    xhr.open(_XMLHTTP_PUT, configpath, _XMLHTTP_ASYNCHRO)
    xhr.setRequestHeader("Content-Type", "application/json")
    xhr.send(jsonString)
  }

  function getSettingsFilePath() {
    var platform = osMode === 1 ? "MacOSX" : "Windows"
    return traktorPath.value + "/SettingsFor" + platform + ".json"
  }

  function prepareConfigData(prefs) {
    return {
      currentTheme: prefs.currentTheme,
      spectrumWaveformColors: prefs.spectrumWaveformColors,
      displayAlbumCover: prefs.displayAlbumCover,
      displayPhaseMeter: prefs.displayPhaseMeter,
      phaseMeterHeight: prefs.phaseMeterHeight,
      normalFontName: prefs.normalFontName,
      // ... all other preferences
    }
  }
}
```

**Key Features:**

- Asynchronous file I/O using XMLHttpRequest
- Platform-specific settings files (macOS/Windows)
- Automatic error handling with fallback to defaults
- JSON serialization with pretty-printing

**Environment Setup:**

```bash
# Required for file access
export QML_XHR_ALLOW_FILE_READ=1
export QML_XHR_ALLOW_FILE_WRITE=1
```

### Settings Integration in Prefs.qml

```qml
// Screens/Defines/Prefs.qml
Rectangle {
  id: instancePrefs

  Component.onCompleted: {
    var confLoader = Qt.createComponent("../../CSI/Common/Settings/ConfigLoader.qml").createObject(this)
    if (confLoader) {
      confLoader.loadConfigAsync()
    }
  }

  // Properties with change handlers
  property int spectrumWaveformColors: 1
  onSpectrumWaveformColorsChanged: {
    instancePrefs.log("INFO", "spectrumWaveformColors changed to " + spectrumWaveformColors)
    // Auto-save on change
    savePreferences()
  }
}
```

## 🎨 Example 12: Multi-Theme Waveform System

**Difficulty**: 🟠 Advanced | **Layer**: 🖼️ Screens | **Time**: 2 hrs | **Controllers**: Screen controllers

Provides 16 different waveform color themes, each emulating different professional DJ equipment.

### Theme Definitions Structure

```qml
// Screens/Defines/ThemeDefinitions.qml
QtObject {
  readonly property variant waveformColorsMap: [
    // 0: Default (Kokernutz style)
    {
      low1:  rgba(24,  48,  80, 180),  low2:  rgba(24,  56,  96, 190),
      mid1:  rgba(80, 160, 160, 100),  mid2:  rgba(48, 112, 112, 150),
      high1: rgba(184, 240, 232, 120), high2: rgba(208, 255, 248, 180)
    },

    // 1: Pioneer CDJ-2000 style
    {
      low1:  rgba(30,  85, 170, 150),  low2:  rgba(50, 100, 180, 170),
      mid1:  rgba(115, 170, 255, 120), mid2:  rgba(130, 180, 255, 140),
      high1: rgba(200, 230, 255, 140), high2: rgba(215, 240, 255, 170)
    },

    // 2: Denon SC5000/SC6000 style
    {
      low1:  rgba(0, 155, 110, 150),   low2:  rgba(10, 165, 130, 170),
      mid1:  rgba(20, 235, 165, 120),  mid2:  rgba(20, 245, 170, 150),
      high1: rgba(200, 255, 235, 140), high2: rgba(210, 255, 245, 170)
    }

    // ... 13 more themes
  ]

  function rgba(r, g, b, a) {
    return [r, g, b, a]
  }
}
```

### Applying Theme Colors

```qml
// In waveform display component
Rectangle {
  id: waveformStripe

  property var currentTheme: themeDefinitions.waveformColorsMap[prefs.spectrumWaveformColors]

  Canvas {
    id: waveformCanvas

    onPaint: {
      var ctx = getContext('2d')
      var theme = currentTheme

      // Low frequencies
      ctx.fillStyle = Qt.rgba(
        theme.low1[0]/255,
        theme.low1[1]/255,
        theme.low1[2]/255,
        theme.low1[3]/255
      )
      ctx.fillRect(x, y, width, lowHeight)

      // Mid frequencies
      ctx.fillStyle = Qt.rgba(
        theme.mid1[0]/255,
        theme.mid1[1]/255,
        theme.mid1[2]/255,
        theme.mid1[3]/255
      )
      ctx.fillRect(x, y + lowHeight, width, midHeight)

      // High frequencies
      ctx.fillStyle = Qt.rgba(
        theme.high1[0]/255,
        theme.high1[1]/255,
        theme.high1[2]/255,
        theme.high1[3]/255
      )
      ctx.fillRect(x, y + lowHeight + midHeight, width, highHeight)
    }
  }
}
```

## 📊 Example 13: Phase Meter with Configurable Height

**Difficulty**: 🟡 Intermediate | **Layer**: 🖼️ Screens | **Time**: 45 min | **Controllers**: S4 MK3

Dynamic phase meter visualization with user-configurable dimensions.

```qml
// Phase meter component
Rectangle {
  id: phaseMeter

  height: prefs.displayPhaseMeter ? prefs.phaseMeterHeight : 0
  width: parent.width

  property bool visible: prefs.displayPhaseMeter

  // Phase meter visualization
  Canvas {
    anchors.fill: parent

    property real phaseValue: 0.0  // -1.0 to 1.0

    onPaint: {
      var ctx = getContext('2d')
      ctx.clearRect(0, 0, width, height)

      // Background
      ctx.fillStyle = colors.colorBlack94
      ctx.fillRect(0, 0, width, height)

      // Center line
      ctx.strokeStyle = colors.colorWhite25
      ctx.lineWidth = 1
      ctx.beginPath()
      ctx.moveTo(width/2, 0)
      ctx.lineTo(width/2, height)
      ctx.stroke()

      // Phase indicator
      var xPos = (width/2) + (phaseValue * width/2)
      ctx.fillStyle = phaseValue < 0.1 ? colors.colorGreen : colors.colorOrange
      ctx.fillRect(xPos - 2, 0, 4, height)
    }
  }
}
```

**Preferences:**

```qml
property bool displayPhaseMeter: true
property int phaseMeterHeight: 20

onPhaseMeterHeightChanged: {
  instancePrefs.log("INFO", "phaseMeterHeight changed to " + phaseMeterHeight)
}
```

## ⚠️ Example 14: BPM Difference Warning System

**Difficulty**: 🟡 Intermediate | **Layer**: 🖼️ Screens | **Time**: 45 min | **Controllers**: Screen controllers

Visual feedback system that warns when deck BPMs differ significantly.

```qml
// Deck header component
Item {
  id: deckHeader

  AppProperty { id: masterDeckBpm; path: "app.traktor.decks.1.tempo.base_bpm" }
  AppProperty { id: thisDeckBpm; path: "app.traktor.decks." + deckId + ".tempo.base_bpm" }
  AppProperty { id: syncEnabled; path: "app.traktor.decks." + deckId + ".sync.enabled" }

  property real bpmDifference: Math.abs(masterDeckBpm.value - thisDeckBpm.value)
  property bool bpmWarning: bpmDifference > 2.0

  // SYNC indicator with warning colors
  Rectangle {
    id: syncIndicator

    visible: syncEnabled.value
    color: bpmWarning ? colors.colorRed : deckColor

    Text {
      text: "SYNC"
      font.family: prefs.mediumFontName
      color: colors.colorWhite
    }
  }

  // BPM difference display
  Text {
    id: bpmDiffText

    visible: bpmWarning && syncEnabled.value
    text: "Δ " + bpmDifference.toFixed(1) + " BPM"
    color: colors.colorOrange
    font.family: prefs.normalFontName
  }
}
```

## 👆 Example 15: Touch-Based Settings Menu

**Difficulty**: 🟡 Intermediate | **Layer**: 🖼️ Screens | **Time**: 1 hr | **Controllers**: S4 MK3

Interactive settings access via deck header touch.

```qml
// Deck header with touch handling
Rectangle {
  id: deckHeaderTop

  MouseArea {
    anchors.fill: parent

    onClicked: {
      // Open settings menu
      var settingsMenu = Qt.createComponent("SettingsMenu.qml").createObject(root)
      if (settingsMenu) {
        settingsMenu.visible = true
        settingsMenu.deckId = deckId
      }
    }
  }
}

// Settings menu component
Rectangle {
  id: settingsMenu

  property int deckId: 1

  anchors.fill: parent
  color: colors.colorBlack94
  z: 1000

  ListView {
    id: settingsList
    anchors.fill: parent

    model: ListModel {
      ListElement { category: "DISPLAY DECK TOP"; setting: "displayAlbumCover" }
      ListElement { category: "DISPLAY DECK TOP"; setting: "displayPhaseMeter" }
      ListElement { category: "DISPLAY WAVEFORM"; setting: "spectrumWaveformColors" }
      ListElement { category: "DISPLAY THEME"; setting: "currentTheme" }
    }

    delegate: Rectangle {
      width: parent.width
      height: 40

      Text {
        text: category + " > " + setting
        color: colors.colorWhite
      }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          toggleSetting(setting)
        }
      }
    }
  }

  function toggleSetting(settingName) {
    // Toggle or cycle through values
    if (typeof prefs[settingName] === "boolean") {
      prefs[settingName] = !prefs[settingName]
    } else if (typeof prefs[settingName] === "number") {
      prefs[settingName] = (prefs[settingName] + 1) % maxValueForSetting(settingName)
    }
  }
}
```

## ⏰ Example 16: Time Warning System with Color Indicators

**Difficulty**: 🟡 Intermediate | **Layer**: 🖼️ Screens | **Time**: 45 min | **Controllers**: Screen controllers

Progressive warning system for track time remaining.

```qml
// Time display with warning colors
Text {
  id: timeRemaining

  property real trackLength: trackLengthProperty.value
  property real playPosition: playPositionProperty.value
  property real percentRemaining: (trackLength - playPosition) / trackLength

  // Calculate warning level
  property int warningLevel: {
    if (percentRemaining < 0.05) return 2  // Critical (last 5%)
    if (percentRemaining < prefs.timeWarningThreshold / 100.0) return 1  // Warning
    return 0  // Normal
  }

  // Dynamic color based on warning level
  color: {
    if (!prefs.showTimeWarnings) return deckColor

    switch (warningLevel) {
      case 2: return colors.colorRed      // Critical
      case 1: return colors.colorOrange   // Warning
      default: return deckColor           // Normal
    }
  }

  // Optional milliseconds display
  text: {
    var totalSeconds = Math.floor(trackLength - playPosition)
    var minutes = Math.floor(totalSeconds / 60)
    var seconds = totalSeconds % 60
    var milliseconds = Math.floor((trackLength - playPosition - totalSeconds) * 1000)

    var timeStr = minutes + ":" + (seconds < 10 ? "0" : "") + seconds

    if (prefs.showMillisecondsInTime) {
      timeStr += "." + (milliseconds < 100 ? "0" : "") + (milliseconds < 10 ? "0" : "") + milliseconds
    }

    return timeStr
  }
}

// Preferences
property bool showMillisecondsInTime: false
property bool showTimeWarnings: true
property int timeWarningThreshold: 20  // Warning at 20% remaining
```

## 🎯 Example 17: Custom Jump Mode with Pad Layout

**Difficulty**: 🟠 Advanced | **Layer**: 🔌 CSI | **Time**: 1 hr | **Controllers**: S4 MK3

Custom jump mode allows precise track navigation using pads with configurable jump sizes.

### MoveSize Definition

```qml
// Defines/MoveSize.qml
pragma Singleton
import QtQuick 2.0

QtObject {
  readonly property int move_1:    6
  readonly property int move_2:    7
  readonly property int move_4:    8
  readonly property int move_8:    9
  readonly property int move_16:   10
  readonly property int move_32:   11
}
```

### PadsMode with Custom Jump

```qml
// Defines/PadsMode.qml
pragma Singleton
import QtQuick 2.0
import CSI 1.0

QtObject {
  readonly property int disabled:    0
  readonly property int hotcues:     1
  readonly property int remix:       2
  readonly property int stems:       3
  readonly property int freeze:      4
  readonly property int loop:        5
  readonly property int customjump:  6  // Custom addition
  readonly property int customloop:  7  // Custom addition

  function isPadsModeSupported(padMode, deckType) {
    switch(padMode) {
      case customjump:
      case customloop:
        return deckType == DeckType.Track
      // ... other cases
    }
  }

  function defaultPadsModeForDeck(deckType) {
    switch(deckType) {
      case DeckType.Track:
        return hotcues
      // ... other cases
    }
  }
}
```

### Jump Mode Implementation

```qml
// Jump mode controller logic
AppProperty {
  id: moveSize
  path: "app.traktor.decks." + deckId + ".move.size"
}

AppProperty {
  id: moveMode
  path: "app.traktor.decks." + deckId + ".move.mode"
}

// Pad layout without shift:
// | -4 beats | +4 beats | -8 beats | +8 beats |
// |-16 beats |+16 beats |-32 beats |+32 beats |

Wire {
  from: "%surface%.pads.1"
  to: ButtonScriptAdapter {
    onPress: {
      if (shift) {
        // Shift layout: -1 beat
        moveSize.value = MoveSize.move_1
        moveMode.value = -1  // Backward
      } else {
        // Normal layout: -4 beats
        moveSize.value = MoveSize.move_4
        moveMode.value = -1
      }
      // Trigger move
      moveCommand.value = true
    }
  }
  enabled: padsMode.value == PadsMode.customjump
}

Wire {
  from: "%surface%.pads.2"
  to: ButtonScriptAdapter {
    onPress: {
      if (shift) {
        moveSize.value = MoveSize.move_1
        moveMode.value = 1  // Forward
      } else {
        moveSize.value = MoveSize.move_4
        moveMode.value = 1
      }
      moveCommand.value = true
    }
  }
  enabled: padsMode.value == PadsMode.customjump
}

// ... pads 3-8 for other jump sizes
```

**Key Features:**

- Dual layouts (normal/shift)
- Loop-aware jumping (moves entire loop if active)
- Supports 1, 2, 4, 8, 16, 32 beat jumps
- Bidirectional navigation

## 🔄 Example 18: Auto-Sync on Track Load

**Difficulty**: 🟡 Intermediate | **Layer**: 🔌 CSI | **Time**: 30 min | **Controllers**: All controllers

Automatically sync a deck when loading a new track if other decks are already synced.

```qml
AppProperty {
  id: isLoaded
  path: "app.traktor.decks." + deckId + ".is_loaded"
  onValueChanged: {
    if (isLoaded.value) {
      checkAutoSync()
    }
  }
}

AppProperty {
  id: syncEnabled
  path: "app.traktor.decks." + deckId + ".sync.enabled"
}

// Track other decks' sync status
AppProperty { id: deck1Sync; path: "app.traktor.decks.1.sync.enabled" }
AppProperty { id: deck2Sync; path: "app.traktor.decks.2.sync.enabled" }
AppProperty { id: deck3Sync; path: "app.traktor.decks.3.sync.enabled" }
AppProperty { id: deck4Sync; path: "app.traktor.decks.4.sync.enabled" }

function checkAutoSync() {
  // Check if at least one other deck is synced
  var otherDecksSynced = false

  if (deckId != 1 && deck1Sync.value) otherDecksSynced = true
  if (deckId != 2 && deck2Sync.value) otherDecksSynced = true
  if (deckId != 3 && deck3Sync.value) otherDecksSynced = true
  if (deckId != 4 && deck4Sync.value) otherDecksSynced = true

  if (otherDecksSynced && !syncEnabled.value) {
    // Enable sync for newly loaded track
    syncEnabled.value = true
    console.log("Auto-sync enabled for deck", deckId)
  }
}
```

**Use Case**: Seamless mixing workflow where new tracks automatically match tempo.

## 👆 Example 19: Touch Hotcues with Long-Press

**Difficulty**: 🟠 Advanced | **Layer**: 🔌 CSI | **Time**: 1 hr | **Controllers**: All controllers

Touch-based hotcue triggering with short/long press differentiation.

```qml
// Touch hotcue component
Rectangle {
  id: hotcueTouch

  property int hotcueIndex: 0  // 0-7
  property bool isSet: hotcueExists.value

  AppProperty {
    id: hotcueExists
    path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + hotcueIndex + ".exists"
  }

  AppProperty {
    id: hotcueTrigger
    path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + hotcueIndex + ".trigger"
  }

  AppProperty {
    id: hotcueDelete
    path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + hotcueIndex + ".delete"
  }

  property bool isHolding: false

  Timer {
    id: longPressTimer
    interval: 500  // 500ms for long press
    onTriggered: {
      isHolding = true
      // Long press: delete hotcue
      if (isSet) {
        hotcueDelete.value = true
      }
    }
  }

  MouseArea {
    anchors.fill: parent

    onPressed: {
      isHolding = false
      longPressTimer.start()

      // Immediate visual feedback
      parent.opacity = 0.7
    }

    onReleased: {
      longPressTimer.stop()
      parent.opacity = 1.0

      if (!isHolding) {
        // Short press: trigger hotcue
        hotcueTrigger.value = true
      }
    }
  }

  // Visual styling
  color: isSet ? hotcueColor : colors.colorGrey50
  border.width: 2
  border.color: isHolding ? colors.colorRed : colors.colorWhite25
}
```

**Features:**

- Short press: Jump to/trigger hotcue
- Long press (500ms): Delete hotcue
- Visual feedback during interaction
- Works with all 8 hotcue slots

## 👆 Example 20: Touch Color FX with Dual Actions

**Difficulty**: 🟠 Advanced | **Layer**: 🔌 CSI | **Time**: 1 hr | **Controllers**: All controllers

Touch interface for color FX with different actions for short/long press.

```qml
// Color FX touch button
Rectangle {
  id: colorFxButton

  property int fxUnit: 1  // 1-4

  AppProperty {
    id: fxOn
    path: "app.traktor.fx." + fxUnit + ".enabled"
  }

  AppProperty {
    id: fxButton1
    path: "app.traktor.fx." + fxUnit + ".buttons.1"
  }

  AppProperty {
    id: fxButton2
    path: "app.traktor.fx." + fxUnit + ".buttons.2"
  }

  property bool isHolding: false

  Timer {
    id: longPressTimer
    interval: 400
    onTriggered: {
      isHolding = true
      executeLongPress()
    }
  }

  MouseArea {
    anchors.fill: parent

    onPressed: {
      isHolding = false
      longPressTimer.start()
    }

    onReleased: {
      longPressTimer.stop()

      if (!isHolding) {
        executeShortPress()
      }

      isHolding = false
    }
  }

  function executeShortPress() {
    // Short press: Toggle FX on/off
    fxOn.value = !fxOn.value
  }

  function executeLongPress() {
    // Long press: Toggle all FX buttons
    var newState = !fxButton1.value
    fxButton1.value = newState
    fxButton2.value = newState
    // Button 3 if applicable
  }

  // Visual state
  color: fxOn.value ? fxColor : colors.colorGrey40
  opacity: isHolding ? 0.6 : 1.0
}
```

**Actions:**

- Short press: Toggle FX unit on/off
- Long press: Toggle all FX buttons simultaneously

## 🌐 Example 21: HTTP API Integration for External Apps

**Difficulty**: 🔴 Expert | **Layer**: 🔌 CSI/External | **Time**: 4 hrs | **Controllers**: All controllers

The traktor-api-client demonstrates how to send live track data from Traktor to external web servers or applications.

### API Client JavaScript Module

```javascript
// ApiClient.js
var API_BASE_URL = "http://localhost:8080";

function send(endpoint, data) {
  var request = new XMLHttpRequest();
  var body = JSON.stringify(data);

  request.open("POST", API_BASE_URL + "/" + endpoint, true);
  request.setRequestHeader("Content-Type", "application/json");
  request.setRequestHeader("Content-Length", body.length);
  request.send(body);
}
```

### API Module Structure

```qml
// ApiModule.qml
import CSI 1.0

Module {
  // Monitor all 4 mixer channels
  ApiChannel { index: 1 }
  ApiChannel { index: 2 }
  ApiChannel { index: 3 }
  ApiChannel { index: 4 }

  // Monitor all 4 decks
  ApiDeck { deckId: 0 }
  ApiDeck { deckId: 1 }
  ApiDeck { deckId: 2 }
  ApiDeck { deckId: 3 }

  // Monitor master clock
  ApiMasterClock {}
}
```

### Deck Data Broadcasting

```qml
// ApiDeck.qml - Excerpt
import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  property int deckId: 0
  property var hotcueExists: []
  property var hotcuePos: []
  property var hotcueName: []
  property var hotcueType: []

  readonly property string deckLetter: String.fromCharCode(65 + deckId)  // A, B, C, D
  readonly property string pathPrefix: "app.traktor.decks." + (deckId+1) + "."

  // Track metadata properties
  AppProperty { id: propTitle;    path: pathPrefix + "content.title" }
  AppProperty { id: propArtist;   path: pathPrefix + "content.artist" }
  AppProperty { id: propAlbum;    path: pathPrefix + "content.album" }
  AppProperty { id: propGenre;    path: pathPrefix + "content.genre" }
  AppProperty { id: propKey;      path: pathPrefix + "content.musical_key" }
  AppProperty { id: propBpm;      path: pathPrefix + "tempo.base_bpm" }
  AppProperty { id: propFilePath; path: pathPrefix + "track.content.file_path" }

  // Playback state properties
  AppProperty { id: propElapsedTime; path: pathPrefix + "track.player.elapsed_time" }
  AppProperty { id: propNextCuePoint; path: pathPrefix + "track.player.next_cue_point" }

  // Track loading event
  AppProperty {
    path: pathPrefix + "is_loaded"
    onValueChanged: deckLoadedTimer.start()
  }

  // Play state changes
  AppProperty {
    id: propIsPlaying
    path: pathPrefix + "play"

    onValueChanged: {
      ApiClient.send("updateDeck/" + deckLetter, {
        elapsedTime: propElapsedTime.value,
        isPlaying: propIsPlaying.value
      })
    }
  }

  // Sync state changes
  AppProperty {
    id: propIsSynced
    path: pathPrefix + "sync.enabled"

    onValueChanged: {
      ApiClient.send("updateDeck/" + deckLetter, {
        isSynced: propIsSynced.value
      })
    }
  }

  // Send full track info when loaded
  Timer {
    id: deckLoadedTimer
    interval: 250

    onTriggered: {
      var cueIdxs = findCueIdxs()

      ApiClient.send("deckLoaded/" + deckLetter, {
        filePath:     getFilePath(),
        title:        propTitle.value,
        artist:       propArtist.value,
        album:        propAlbum.value,
        genre:        propGenre.value,
        key:          propKey.value,
        bpm:          propBpm.value,
        trackLength:  propTrackLength.value,
        elapsedTime:  propElapsedTime.value,
        nextCuePos:   getOrNull(hotcuePos, cueIdxs.next),
        nextCueName:  getOrNull(hotcueName, cueIdxs.next),
        isPlaying:    propIsPlaying.value,
        isSynced:     propIsSynced.value
      })
    }
  }

  // Continuous elapsed time updates while playing
  Timer {
    interval: 1000
    repeat: true
    running: propIsPlaying.value

    onTriggered: {
      ApiClient.send("updateDeck/" + deckLetter, {
        elapsedTime: propElapsedTime.value
      })
    }
  }

  // Helper: Convert file path for cross-platform compatibility
  function getFilePath() {
    if (!propFilePath.value) return ""

    // Windows path or Unix absolute path
    return /^[A-Z]:\\/.test(propFilePath.value) || /^\//.test(propFilePath.value)
      ? propFilePath.value
      : "/Volumes/" + propFilePath.value.replace(/:/g, "/")
  }
}
```

### Channel Monitoring (On-Air Detection)

```qml
// ApiChannel.qml
import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  property int index: 1
  property bool isOnAirState: null
  property real onAirLevelState: null

  readonly property string pathPrefix: "app.traktor.mixer.channels." + index + "."

  AppProperty { id: propVolume;            path: pathPrefix + "volume" }
  AppProperty { id: propXfaderAssignLeft;  path: pathPrefix + "xfader_assign.left" }
  AppProperty { id: propXfaderAssignRight; path: pathPrefix + "xfader_assign.right" }
  AppProperty { id: propXfaderAdjust;      path: "app.traktor.mixer.xfader.adjust" }

  Timer {
    id: onAirLevelChangedTimer
    interval: 250

    onTriggered: {
      var onAirLevel = propVolume.value

      // Calculate crossfader influence
      if ((propXfaderAssignLeft.value && propXfaderAdjust.value > 0.5)
        || (propXfaderAssignRight.value && propXfaderAdjust.value < 0.5)) {
        onAirLevel *= 1 - Math.abs(propXfaderAdjust.value * 2 - 1)
      }

      if (onAirLevel != onAirLevelState) {
        ApiClient.send("updateChannel/" + index, {
          onAirLevel: onAirLevel
        })
        onAirLevelState = onAirLevel
      }
    }
  }

  function updateOnAirState() {
    // Channel is on-air if:
    // 1. Volume > 0, AND
    // 2. Not assigned to crossfader, OR crossfader not cutting it out
    var isOnAir = propVolume.value > 0
      && ((!propXfaderAssignLeft.value && !propXfaderAssignRight.value)
        || (propXfaderAssignLeft.value && propXfaderAdjust.value < 1)
        || (propXfaderAssignRight.value && propXfaderAdjust.value > 0))

    if (isOnAir != isOnAirState) {
      ApiClient.send("updateChannel/" + index, {
        isOnAir: isOnAir
      })
      isOnAirState = isOnAir
    }

    onAirLevelChangedTimer.restart()
  }
}
```

### Master Clock Monitoring

```qml
// ApiMasterClock.qml
import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  AppProperty {
    id: propMasterDeckId
    path: "app.traktor.masterclock.source_id"
    onValueChanged: updateMasterClock()
  }

  AppProperty {
    id: propMasterBpm
    path: "app.traktor.masterclock.tempo"
    onValueChanged: masterBpmChangedTimer.restart()
  }

  Timer {
    id: masterBpmChangedTimer
    interval: 250
    onTriggered: updateMasterClock()
  }

  function updateMasterClock() {
    ApiClient.send("updateMasterClock", {
      deck: (propMasterDeckId.value == -1)
        ? null
        : String.fromCharCode(65 + propMasterDeckId.value),  // Convert to A/B/C/D
      bpm: propMasterBpm.value
    })
  }
}
```

### API Endpoints

The system sends POST requests with JSON payloads to:

1. **`/deckLoaded/<deck>`** - Track loaded (full metadata)

   ```json
   {
     "filePath": "/path/to/track.mp3",
     "title": "Track Name",
     "artist": "Artist Name",
     "album": "Album Name",
     "genre": "Genre",
     "key": "8A",
     "bpm": 128.0,
     "trackLength": 240.5,
     "elapsedTime": 0.0,
     "isPlaying": false,
     "isSynced": false
   }
   ```

2. **`/updateDeck/<deck>`** - State changes (partial updates)

   ```json
   {
     "elapsedTime": 45.2,
     "isPlaying": true,
     "isSynced": true,
     "tempo": 1.05
   }
   ```

3. **`/updateChannel/<channel>`** - Mixer channel state

   ```json
   {
     "isOnAir": true,
     "onAirLevel": 0.85
   }
   ```

4. **`/updateMasterClock`** - Master tempo changes
   ```json
   {
     "deck": "A",
     "bpm": 128.0
   }
   ```

### Integration into Controller Mapping

```qml
// D2.qml (or any controller)
import CSI 1.0
import "./Api"

Mapping {
  // Add API module
  ApiModule {}

  // Rest of controller mapping...
  D2 { name: "surface" }

  Deck_S8Style {
    id: deck
    name: "deck"
    // ... deck configuration
  }
}
```

### Use Cases

**Streaming Overlays:**

```javascript
// Node.js server receiving Traktor data
app.post("/deckLoaded/:deck", (req, res) => {
  const { title, artist, bpm } = req.body;
  updateOverlay(req.params.deck, `${artist} - ${title} (${bpm} BPM)`);
  res.sendStatus(200);
});
```

**Web-Based Now Playing:**

```javascript
app.post("/updateDeck/:deck", (req, res) => {
  if (req.body.isPlaying) {
    io.emit("nowPlaying", {
      deck: req.params.deck,
      time: req.body.elapsedTime,
    });
  }
  res.sendStatus(200);
});
```

**Analytics/Logging:**

```javascript
app.post("/updateChannel/:channel", (req, res) => {
  if (req.body.isOnAir) {
    logMixerEvent({
      channel: req.params.channel,
      level: req.body.onAirLevel,
      timestamp: Date.now(),
    });
  }
  res.sendStatus(200);
});
```

**Key Features:**

- Real-time track metadata broadcasting
- On-air detection with crossfader awareness
- Hotcue tracking (next/previous cue detection)
- Debounced updates (250ms) to reduce network traffic
- Cross-platform file path handling
- Continuous elapsed time updates during playback

**Installation:**

1. Replace D2 folder in Traktor's CSI directory
2. Enable D2 controller in Traktor (even if you don't own one)
3. Start your web server on `http://localhost:8080`
4. Traktor will send live data to your server

---

## 🏗️ Example 22: Modular Settings System

**Difficulty**: 🔴 Expert | **Layer**: ⚙️ Defines/Screens | **Time**: 4 hrs | **Controllers**: Screen controllers

Sophisticated modular settings system where each controller has its own configuration file, allowing granular customization without modifying core QML files.

### Settings Module Structure

**File**: `Settings/S2MK3.qml`

```qml
import CSI 1.0
import QtQuick 2.12

Module {
  //-----------------------------------------------------
  // SETTINGS - SHIFT
  //-----------------------------------------------------

  property bool globalShift: false

  //-----------------------------------------------------
  // SETTINGS - MIXER
  //-----------------------------------------------------

  property bool filterFX: false
  /* false: control 4 MixerFXs (off when none selected)
     true: control 4+1 MixerFXs (Filter mode when none selected) */

  property bool individualFXs: false
  /* true: Shift+FX button assigns to single channel only
     false: Shift+FX button assigns to both channels */

  property int precueButton: 0
  /* 0: Precue - enable/disable preCueing
     1: MixerFX On/Off - enable/disable Mixer FX */

  property int shiftPrecueButton: 0
  /* Same options as precueButton for Shift+Precue */

  property bool mixerFXsBlinkers: false
  /* false: Active MixerFXs displayed brighter
     true: All MixerFXs bright, active ones blink */

  //-----------------------------------------------------
  // SETTINGS - TRANSPORT BUTTONS
  //-----------------------------------------------------

  property int playButton: 0
  /* 0: Play - instant pause
     1: Vinyl Break - slow pause simulating vinyl stop */

  property int shiftPlayButton: 0
  /* Same options as playButton for Shift+Play */

  property bool playBlinker: false
  /* true: Play LED blinks when paused/cueing
     false: Play LED follows Traktor GUI behavior */

  property int cueButton: 0
  property int shiftCueButton: 2
  /* 0: CUE
     1: CUP (Cue Play)
     2: Restart */

  property bool cueBlinker: false
  /* true: CUE LED blinks when paused at non-cue position
     false: CUE LED follows Traktor GUI behavior */

  property bool faderStart: false
  /* true: Deck auto-plays when 'on air' (Volume + XFader)
     false: Default behavior */

  property bool reverseCensor: true
  /* true: Reverse button always censors (flux reverse)
     false: Reverse/flux reverse depends on flux state */

  property int vinylBreakDuration: 1000  // milliseconds

  //-----------------------------------------------------
  // SETTINGS - KEY SYNC
  //-----------------------------------------------------

  property bool fuzzyKeySync: true
  /* true: Opposite scale adjacent keys considered match
          (5A matches: 5A/B + 4A/B & 6A/B)
     false: Only same scale adjacent keys match
          (5A matches: 5A/B + 4A & 6A) */

  property bool useKeyText: false
  /* true: Use Key Text field (must be correctly formatted)
     false: Use Traktor's Key field */
}
```

### Using Settings in Controller Module

**File**: `CSI/S2MK3/S2MK3.qml`

```qml
import CSI 1.0
import "../../Settings" as Settings

Module {
  id: module

  // Load settings
  Settings.S2MK3 { id: settings }

  // Apply settings to wire behavior
  Wire {
    from: "%surface%.play"
    to: ButtonScriptAdapter {
      onPress: {
        if (settings.playButton == 0) {
          // Instant play/pause
          playProp.value = !playProp.value
        } else {
          // Vinyl break
          vinylBreak.trigger()
        }
      }
    }
  }

  // Fuzzy key sync implementation
  function isKeyMatch(key1, key2) {
    if (settings.useKeyText) {
      key1 = getKeyFromText(key1)
      key2 = getKeyFromText(key2)
    }

    var camelot1 = toCamelotNumber(key1)
    var camelot2 = toCamelotNumber(key2)
    var scale1 = getScale(key1)  // A or B
    var scale2 = getScale(key2)

    var distance = Math.abs(camelot1 - camelot2)

    // Perfect match (same key)
    if (distance == 0) return true

    // Adjacent keys (+1 or -1)
    if (distance == 1 || distance == 11) {
      if (settings.fuzzyKeySync) {
        return true  // Allow opposite scale adjacent
      } else {
        return scale1 == scale2  // Same scale only
      }
    }

    // Relative key (+7 or -7)
    if (distance == 7 || distance == 5) {
      return true
    }

    return false
  }
}
```

### Benefits:

- **Centralized Configuration**: All settings in one file per controller
- **Non-Destructive**: Core QML files remain unchanged
- **Self-Documenting**: Comments explain each option
- **Multi-Controller Support**: Different settings per controller type
- **Easy Backup/Sharing**: Single file contains all customizations

---

## 💡 Example 23: Advanced LED Control with Blinkers

**Difficulty**: 🟠 Advanced | **Layer**: 🔌 CSI | **Time**: 2 hrs | **Controllers**: All controllers

Sophisticated LED feedback with blinking patterns for enhanced visual communication.

### Play Button Blinker

```qml
// Settings
property bool playBlinker: false

// Play state tracking
AppProperty { id: isPlaying; path: "app.traktor.decks." + deckId + ".play" }
AppProperty { id: isCueing; path: "app.traktor.decks." + deckId + ".is_in_active_cue" }

// Blinker timer
Timer {
  id: playBlinkTimer
  interval: 500  // 500ms on/off cycle
  repeat: true
  running: settings.playBlinker && (!isPlaying.value || isCueing.value)

  property bool blinkState: false

  onTriggered: {
    blinkState = !blinkState
  }
}

// LED output
Wire {
  from: "playLED"
  to: DirectPropertyAdapter {
    path: "%surface%.deck.play.led"
    output: {
      if (!settings.playBlinker) {
        // Standard behavior
        return isPlaying.value ? 1.0 : 0.0
      } else {
        // Blinking when paused or cueing
        if (isPlaying.value && !isCueing.value) {
          return 1.0  // Solid when playing
        } else {
          return playBlinkTimer.blinkState ? 1.0 : 0.0  // Blink
        }
      }
    }
  }
}
```

### CUE Button Blinker

```qml
// Settings
property bool cueBlinker: false

// Cue state tracking
AppProperty { id: cuePosition; path: "app.traktor.decks." + deckId + ".track.cue.position" }
AppProperty { id: playPosition; path: "app.traktor.decks." + deckId + ".track.player.position" }

// Blinker condition: paused and NOT at cue point
property bool shouldCueBlink: {
  if (!settings.cueBlinker) return false
  if (isPlaying.value) return false

  // Blink if playhead is NOT at cue position
  return Math.abs(playPosition.value - cuePosition.value) > 0.01
}

Timer {
  id: cueBlinkTimer
  interval: 400  // Faster blink for urgency
  repeat: true
  running: shouldCueBlink
  property bool blinkState: false
  onTriggered: { blinkState = !blinkState }
}

// CUE LED
Wire {
  from: "cueLED"
  to: DirectPropertyAdapter {
    path: "%surface%.deck.cue.led"
    output: {
      if (shouldCueBlink) {
        return cueBlinkTimer.blinkState ? 1.0 : 0.0
      } else if (isCueing.value) {
        return 1.0  // Solid when cueing
      } else {
        return 0.0  // Off
      }
    }
  }
}
```

### Mixer FX Blinkers

```qml
// Settings
property bool mixerFXsBlinkers: false

// FX state
AppProperty {
  id: selectedMixerFX
  path: "app.traktor.mixer.channels." + channelId + ".fx.select"
}

// All 4 FX blinkers
Repeater {
  model: 4

  Timer {
    id: fxBlinkTimer
    interval: 300
    repeat: true
    running: settings.mixerFXsBlinkers && (selectedMixerFX.value == index + 1)
    property bool blinkState: false
    onTriggered: { blinkState = !blinkState }
  }
}

// FX LED output
Wire {
  from: "mixerFX" + (index + 1) + "LED"
  to: DirectPropertyAdapter {
    path: "%surface%.mixer.fx" + (index + 1) + ".led"
    output: {
      var isSelected = (selectedMixerFX.value == index + 1)

      if (!settings.mixerFXsBlinkers) {
        // Standard: selected FX is brighter
        return isSelected ? 1.0 : 0.3
      } else {
        // Blinker mode: all bright, selected blinks
        if (isSelected) {
          return fxBlinkTimer.blinkState ? 1.0 : 0.3
        } else {
          return 1.0  // Non-selected are solid bright
        }
      }
    }
  }
}
```

**Key Features:**

- **Visual Feedback**: Immediate understanding of controller state
- **Configurable**: Enable/disable per feature
- **Different Blink Rates**: Faster for urgent states (CUE), slower for informational (Play)
- **Context-Aware**: Blink patterns change based on multiple conditions
- **LED Brightness Levels**: 0.0 (off), 0.3 (dim), 1.0 (bright)

---

## 🎵 Example 24: Vinyl Break Simulation

**Difficulty**: 🟠 Advanced | **Layer**: 🔌 CSI | **Time**: 2 hrs | **Controllers**: All controllers

Realistic vinyl-style deceleration when stopping playback.

### Vinyl Break Implementation

```qml
// Settings
property int playButton: 0  // 0=instant, 1=vinyl break
property int vinylBreakDuration: 1000  // milliseconds

// State tracking
AppProperty { id: playProp; path: "app.traktor.decks." + deckId + ".play" }
AppProperty { id: tempo; path: "app.traktor.decks." + deckId + ".tempo.absolute" }

// Vinyl break controller
QtObject {
  id: vinylBreak

  property real targetTempo: 0
  property real startTempo: 0
  property real currentProgress: 0
  property bool active: false

  Timer {
    id: vinylBreakTimer
    interval: 16  // ~60fps for smooth deceleration
    repeat: true
    running: vinylBreak.active

    onTriggered: {
      vinylBreak.currentProgress += interval / settings.vinylBreakDuration

      if (vinylBreak.currentProgress >= 1.0) {
        // Deceleration complete
        vinylBreak.stop()
        playProp.value = false
      } else {
        // Interpolate tempo with easing curve
        var eased = easeOutCubic(vinylBreak.currentProgress)
        var newTempo = vinylBreak.startTempo * (1.0 - eased)
        tempo.value = newTempo
      }
    }
  }

  function trigger() {
    if (!playProp.value) return  // Already stopped

    active = true
    startTempo = tempo.value
    targetTempo = 0
    currentProgress = 0
  }

  function stop() {
    active = false
    tempo.value = 1.0  // Reset to normal tempo
  }

  // Easing function for realistic deceleration
  function easeOutCubic(t) {
    var t1 = t - 1
    return t1 * t1 * t1 + 1
  }
}

// Play button wire
Wire {
  from: "%surface%.deck.play"
  to: ButtonScriptAdapter {
    onPress: {
      if (isShifted ? settings.shiftPlayButton : settings.playButton == 1) {
        // Vinyl break mode
        if (playProp.value) {
          vinylBreak.trigger()
        } else {
          playProp.value = true
        }
      } else {
        // Instant play/pause
        playProp.value = !playProp.value
      }
    }
    onRelease: {
      // Allow interruption
      if (vinylBreak.active) {
        vinylBreak.stop()
      }
    }
  }
}
```

### Easing Curves

```javascript
// Different deceleration feels
function easeOutQuad(t) {
  return t * (2 - t); // Gentle slowdown
}

function easeOutCubic(t) {
  var t1 = t - 1;
  return t1 * t1 * t1 + 1; // More realistic vinyl
}

function easeOutQuart(t) {
  var t1 = t - 1;
  return 1 - t1 * t1 * t1 * t1; // Heavy platter
}

// Linear (no easing)
function linear(t) {
  return t;
}
```

**Features:**

- **Configurable Duration**: 500ms (quick), 1000ms (realistic), 2000ms (slow)
- **Smooth Animation**: 60fps tempo interpolation
- **Interruptible**: Press button again to stop immediately
- **Easing Curves**: Different curves simulate different turntable weights
- **Separate Settings**: Different behavior for normal/shift button press

---

## 🎚️ Example 25: Fader Start with Multi-Condition Detection

**Difficulty**: 🟠 Advanced | **Layer**: 🔌 CSI | **Time**: 2 hrs | **Controllers**: All controllers

Automatically play/cue decks when faders bring them "on air", simulating classic DJ mixer behavior.

### Fader Start Implementation

```qml
// Settings
property bool faderStart: false

// Fader state tracking
AppProperty {
  id: channelVolume
  path: "app.traktor.mixer.channels." + channelId + ".volume"
}

AppProperty {
  id: xfaderAssign
  path: "app.traktor.mixer.channels." + channelId + ".xfader.assign"
}

AppProperty {
  id: xfaderPosition
  path: "app.traktor.mixer.xfader.adjust"
}

// Deck state
AppProperty { id: isPlaying; path: "app.traktor.decks." + deckId + ".play" }
AppProperty { id: isCueing; path: "app.traktor.decks." + deckId + ".is_in_active_cue" }

// On-air calculation
QtObject {
  id: onAirDetector

  property real volumeThreshold: 0.05  // 5% volume
  property real xfaderThreshold: 0.10  // 10% crossfader position

  property bool isOnAir: {
    if (!settings.faderStart) return false

    // Volume fader must be up
    if (channelVolume.value < volumeThreshold) return false

    // Check crossfader assignment
    var xfaderLeft = (xfaderAssign.value == 0)   // Left
    var xfaderRight = (xfaderAssign.value == 1)  // Right
    var xfaderThru = (xfaderAssign.value == 2)   // Thru (always on)

    // If assigned thru, volume fader is enough
    if (xfaderThru) return true

    // Check crossfader position
    if (xfaderLeft && xfaderPosition.value > (1.0 - xfaderThreshold)) {
      return false  // Faded to right
    }

    if (xfaderRight && xfaderPosition.value < xfaderThreshold) {
      return false  // Faded to left
    }

    return true
  }

  // Detect state changes
  property bool wasOnAir: false

  onIsOnAirChanged: {
    if (!settings.faderStart) return

    if (isOnAir && !wasOnAir) {
      // Just came on air
      if (!isPlaying.value) {
        if (isCueing.value) {
          // At cue point - start playing
          isPlaying.value = true
        }
      }
    } else if (!isOnAir && wasOnAir) {
      // Just went off air
      if (isPlaying.value) {
        // Return to cue point
        playProp.value = false
        seekToCue.trigger()
      }
    }

    wasOnAir = isOnAir
  }
}

// Seek to cue helper
TriggerPropertyAdapter {
  id: seekToCue
  path: "app.traktor.decks." + deckId + ".track.cue.seek"
}
```

### Advanced On-Air Logic

```qml
// More sophisticated on-air detection
function calculateOnAirLevel() {
  var volumeLevel = channelVolume.value

  // Apply crossfader if assigned
  if (xfaderAssign.value != 2) {  // Not thru
    var xfaderLevel = 1.0

    if (xfaderAssign.value == 0) {  // Left
      xfaderLevel = 1.0 - xfaderPosition.value
    } else {  // Right
      xfaderLevel = xfaderPosition.value
    }

    volumeLevel *= xfaderLevel
  }

  return volumeLevel
}

property real onAirLevel: calculateOnAirLevel()
property bool isAudible: onAirLevel > 0.05

// Debounce to prevent jitter
Timer {
  id: faderStartDebounce
  interval: 100  // 100ms debounce
  property bool pendingState: false

  onTriggered: {
    if (pendingState && !isPlaying.value) {
      isPlaying.value = true
    } else if (!pendingState && isPlaying.value) {
      isPlaying.value = false
      seekToCue.trigger()
    }
  }
}

onIsAudibleChanged: {
  faderStartDebounce.pendingState = isAudible
  faderStartDebounce.restart()
}
```

**Key Features:**

- **Multi-Condition**: Checks both volume fader AND crossfader
- **Assignment Aware**: Respects L/R/Thru crossfader assignment
- **Threshold Configurable**: Prevents triggering on small movements
- **Debounced**: 100ms delay prevents jitter from quick fader movements
- **Cue Return**: Returns to cue point when faded out
- **On-Air Level Calculation**: Multiplies volume × crossfader for accurate detection

**Use Cases:**

- Classic mixer workflow (fade in = play, fade out = return to cue)
- Quick mixing without touching transport buttons
- Prevents accidentally leaving tracks playing when faded out

---

## 👆 Example 26: Native ButtonGestures Module (Traktor Pro 4)

**Difficulty**: 🟢 Beginner | **Layer**: 🔌 CSI | **Time**: 15 min | **Controllers**: All controllers (TP4 only)

Traktor Pro 4 includes a built-in **ButtonGestures** module that provides native support for single-click, double-click, and long-hold detection without custom timers.

### ButtonGestures Declaration

```qml
// Declare the gesture handler
ButtonGestures { name: "loading_button_gesture" }
```

### Wiring Pattern

```qml
// Connect physical button to gesture handler
Wire {
  from: "%surface%.browse.push"
  to: "loading_button_gesture.input"
}

// Single click (released before 1 second)
Wire {
  from: "loading_button_gesture.single_click"
  to: TriggerPropertyAdapter {
    path: "app.traktor.decks." + deckIdx + ".load.selected"
    output: false
  }
}

// Double click (two clicks within 1 second)
Wire {
  from: "loading_button_gesture.double_click"
  to: TriggerPropertyAdapter {
    path: "app.traktor.decks." + deckIdx + ".load_secondary.selected"
    output: false
  }
}

// Long click (held for more than 1 second)
Wire {
  from: "loading_button_gesture.long_click"
  to: TriggerPropertyAdapter {
    path: "app.traktor.decks." + deckIdx + ".load_stems.selected"
    output: false
  }
}
```

### Complete Example: Multi-Function Load Button

```qml
import CSI 1.0

Module {
  id: deck
  property int deckIdx: 1

  // Gesture handler
  ButtonGestures { name: "load_gesture" }

  // Connect physical button
  Wire {
    from: "%surface%.deck.load"
    to: "load_gesture.input"
  }

  // Single click: Load track (primary deck type)
  Wire {
    from: "load_gesture.single_click"
    to: TriggerPropertyAdapter {
      path: "app.traktor.decks." + deckIdx + ".load.selected"
      output: false
    }
  }

  // Double click: Load as secondary deck type
  Wire {
    from: "load_gesture.double_click"
    to: TriggerPropertyAdapter {
      path: "app.traktor.decks." + deckIdx + ".load_secondary.selected"
      output: false
    }
  }

  // Long hold: Load stems
  Wire {
    from: "load_gesture.long_click"
    to: TriggerPropertyAdapter {
      path: "app.traktor.decks." + deckIdx + ".load_stems.selected"
      output: false
    }
  }
}
```

### Available Load Property Paths

```qml
// Navigation
"app.traktor.decks.X.load.next"
"app.traktor.decks.X.load.previous"

// Loading modes (Traktor Pro 4)
"app.traktor.decks.X.load.selected"            // Legacy (now load_primary)
"app.traktor.decks.X.load_secondary.selected"  // New in TP4
"app.traktor.decks.X.load_track.selected"      // New in TP4
"app.traktor.decks.X.load_stems.selected"      // New in TP4

// Other
"app.traktor.decks.X.load.from_preview_player"
"app.traktor.decks.X.unload"
```

### Gesture Timing Characteristics

**Important Constraints:**

- All three gesture types trigger **1 second after releasing the button**
- **single_click**: Released before 1 second hold time
- **long_click**: Released after 1 second hold time
- **double_click**: Two clicks within 1 second window
- **Timings are NOT configurable** (hardcoded by NI)

**Comparison with Custom Timers:**

| Aspect      | ButtonGestures                | Custom Timers (Example 17)             |
| ----------- | ----------------------------- | -------------------------------------- |
| Setup       | Simple, one declaration       | Complex, manual implementation         |
| Timing      | Fixed 1s threshold            | Fully customizable (200-500ms typical) |
| Latency     | 1s delay on all gestures      | Immediate feedback possible            |
| Reliability | Native, well-tested           | Requires careful coding                |
| Use Case    | Simple multi-function buttons | Fast response, custom timings          |

### When to Use ButtonGestures

✅ **Use ButtonGestures when:**

- Simple single/double/long-click detection needed
- 1-second timing is acceptable
- Prefer native NI implementation
- Want minimal code complexity

❌ **Use custom timers when:**

- Need faster response (<1s)
- Require configurable timing thresholds
- Need immediate visual/audio feedback
- Complex state machines with multiple timings

### Advanced: Multiple Gesture Handlers

```qml
// Different buttons, different gesture handlers
ButtonGestures { name: "load_gesture" }
ButtonGestures { name: "hotcue_gesture" }
ButtonGestures { name: "loop_gesture" }

// Load button
Wire { from: "%surface%.deck.load"; to: "load_gesture.input" }
Wire { from: "load_gesture.single_click"; to: /* ... */ }
Wire { from: "load_gesture.double_click"; to: /* ... */ }

// Hotcue button
Wire { from: "%surface%.deck.hotcue.1"; to: "hotcue_gesture.input" }
Wire { from: "hotcue_gesture.single_click"; to: /* trigger hotcue */ }
Wire { from: "hotcue_gesture.long_click"; to: /* delete hotcue */ }

// Loop button
Wire { from: "%surface%.deck.loop"; to: "loop_gesture.input" }
Wire { from: "loop_gesture.single_click"; to: /* activate loop */ }
Wire { from: "loop_gesture.double_click"; to: /* halve loop size */ }
```

**Key Features:**

- **Native Module**: Built into Traktor Pro 4
- **Zero Timer Code**: No manual Timer implementation needed
- **Consistent Behavior**: Same timing across all controllers
- **Multiple Instances**: Each button can have its own gesture handler
- **Type Safety**: Uses Traktor's internal gesture detection

**Limitations:**

- Fixed 1-second thresholds (not adjustable)
- 1-second release delay for all gestures (may feel sluggish)
- Cannot customize double-click window timing
- All gestures fire on button release (not press)

**Recommendation**: For most use cases, ButtonGestures is the simplest solution. Only use custom timer implementations if you specifically need faster response times or configurable thresholds.

---

## 🚀 Example 27: Advanced UI Innovations

**Difficulty**: 🔴 Expert | **Layer**: All Layers | **Time**: Full day | **Controllers**: Screen controllers

Introduces several advanced UI and interaction features that enhance the Traktor experience on controllers with screens (D2/S5/S8).

### Feature 1: Dynamic Waveforms with Filter/Volume Response

Waveforms dynamically adjust their appearance based on audio processing:

```qml
// Waveform opacity responds to filter state
AppProperty {
  id: filterOn
  path: "app.traktor.mixer.channels." + deckId + ".fx.on"
}

AppProperty {
  id: filterAdjust
  path: "app.traktor.mixer.channels." + deckId + ".fx.adjust"
}

Canvas {
  id: waveformCanvas

  // Dynamic opacity based on filter
  opacity: {
    if (!filterOn.value) return 1.0

    // Fade waveform as filter is applied
    var filterAmount = Math.abs(filterAdjust.value - 0.5) * 2
    return 1.0 - (filterAmount * 0.6)  // Max 60% fade
  }

  onPaint: {
    // Waveform rendering with dynamic opacity
  }
}

// Remix Deck: Adjust to slot filter
AppProperty {
  id: slotFilter
  path: "app.traktor.decks." + deckId + ".remix.cell." + slotId + ".filter_on"
}

// Stem Deck: Adjust to slot volume/mute
AppProperty {
  id: slotVolume
  path: "app.traktor.decks." + deckId + ".stems.slot." + slotId + ".volume"
}

AppProperty {
  id: slotMuted
  path: "app.traktor.decks." + deckId + ".stems.slot." + slotId + ".muted"
}

// Stem waveform rendering
Rectangle {
  opacity: slotMuted.value ? 0.2 : slotVolume.value
  // Stem waveform content
}
```

### Feature 2: Expanded Zoom Steps (20 Levels)

Nearly stepless waveform zoom with 20 incremental levels:

```qml
// Define 20 zoom levels
readonly property variant zoomLevels: [
  0.5,   0.6,   0.7,   0.8,   0.9,
  1.0,   1.2,   1.4,   1.6,   1.8,
  2.0,   2.5,   3.0,   4.0,   5.0,
  6.0,   8.0,   10.0,  15.0,  20.0
]

property int currentZoomIndex: 5  // Start at 1.0x

// Zoom in
function zoomIn() {
  if (currentZoomIndex < zoomLevels.length - 1) {
    currentZoomIndex++
    waveformZoom.value = zoomLevels[currentZoomIndex]
  }
}

// Zoom out
function zoomOut() {
  if (currentZoomIndex > 0) {
    currentZoomIndex--
    waveformZoom.value = zoomLevels[currentZoomIndex]
  }
}

// Wire to encoder
Wire {
  from: "%surface%.browse"
  to: EncoderScriptAdapter {
    onIncrement: { zoomIn() }
    onDecrement: { zoomOut() }
  }
  enabled: !browserMode && deckType == DeckType.Track
}
```

### Feature 3: Browse-On-Touch Mode with Smart Back Button

Convert back button to browser toggle when browse-on-touch is disabled:

```qml
MappingProperty {
  id: browseOnTouch
  path: "mapping.settings.browse_on_touch"
}

// Back button dual function
Wire {
  from: "%surface%.back"
  to: ButtonScriptAdapter {
    onPress: {
      if (browseOnTouch.value) {
        // Normal back button: navigate up in browser
        browserUp.trigger()
      } else {
        // Browse-on-touch OFF: toggle browser overlay
        screenView.value = (screenView.value == ScreenView.deck)
          ? ScreenView.browser
          : ScreenView.deck
      }
    }
  }
  enabled: !touchingBrowseKnob
}

// Touch browse knob + press back = navigate up (always)
Wire {
  from: "%surface%.back"
  to: TriggerPropertyAdapter { path: "app.traktor.browser.navigation.up" }
  enabled: touchingBrowseKnob
}

// Browse knob push: toggle loop when in move/beatjump mode
Wire {
  from: "%surface%.browse.push"
  to: ButtonScriptAdapter {
    onPress: {
      if (browseKnobMode.value == BrowseMode.moveMode) {
        loopActive.value = !loopActive.value
      } else {
        // Normal behavior: load track
        loadTrack.trigger()
      }
    }
  }
}
```

### Feature 4: PadFX Trigger on First Tap

Standard Traktor requires holding PadFX buttons. This makes them trigger immediately:

```qml
// Original behavior: hold to activate
Wire {
  from: "%surface%.pads.1"
  to: HoldPropertyAdapter {
    path: "app.traktor.fx.4fx_units.1.buttons.1"
  }
}

// Modified: trigger on press
Wire {
  from: "%surface%.pads.1"
  to: ButtonScriptAdapter {
    onPress: {
      padFX1.value = true
    }
    onRelease: {
      padFX1.value = false
    }
  }
}
```

### Feature 5: Double-Tap for Secondary Functions

Replace Shift+Button with double-tap for one-handed operation:

```qml
property int lastTapTime: 0
property int doubleTapWindow: 300  // ms

Timer {
  id: singleTapTimer
  interval: doubleTapWindow
  onTriggered: {
    // Single tap action
    executePrimaryFunction()
  }
}

Wire {
  from: "%surface%.deck.fx_select"
  to: ButtonScriptAdapter {
    onPress: {
      var currentTime = Date.now()
      var timeSinceLastTap = currentTime - lastTapTime

      if (timeSinceLastTap < doubleTapWindow) {
        // Double tap detected
        singleTapTimer.stop()
        executeSecondaryFunction()  // FX Settings overlay
        lastTapTime = 0
      } else {
        // Possible first tap
        singleTapTimer.restart()
        lastTapTime = currentTime
      }
    }
  }
}

function executePrimaryFunction() {
  // Cycle through FX units
  screenOverlay.value = Overlay.fx
}

function executeSecondaryFunction() {
  // Open FX settings (previously Shift+FX)
  screenView.value = ScreenView.fxSettings
}
```

### Feature 6: Custom Logo/Artwork Fallback

Display custom branding when tracks have no artwork:

```qml
// File: Screens/Shared/Widgets/ArtworkBox.qml
Image {
  id: albumArt
  anchors.fill: parent

  source: {
    if (!isLoaded.value) {
      return "../Images/NoCoverLogo.png"  // Custom logo
    }

    if (albumCoverDirectory.value != "") {
      return "image://covers/" + albumCoverDirectory.value
    }

    return "../Images/NoCoverLogo.png"  // Fallback to custom logo
  }

  fillMode: Image.PreserveAspectFit
  cache: false
}
```

**Creating Custom Logo:**

1. Create a PNG image (recommended 300x300px)
2. Save as `Screens/Shared/Images/NoCoverLogo.png`
3. Replace in all QML files referencing album artwork

### Feature 7: SYNC with Tempo Match LED Indicator

Visual feedback for tempo synchronization accuracy:

```qml
AppProperty { id: deckTempo; path: "app.traktor.decks." + deckId + ".tempo.absolute" }
AppProperty { id: masterTempo; path: "app.traktor.masterclock.tempo" }
AppProperty { id: syncEnabled; path: "app.traktor.decks." + deckId + ".sync.enabled" }

property real tempoThreshold: 0.005  // BPM tolerance

property bool inTempoSync: {
  return Math.abs(deckTempo.value - masterTempo.value) < tempoThreshold
}

// SYNC button LED
Wire {
  from: "syncLED"
  to: DirectPropertyAdapter {
    path: "%surface%.deck.sync.led"
    output: {
      if (!syncEnabled.value) {
        // Off when sync disabled
        return inTempoSync ? 0.3 : 0.0  // Dim green if matched, off if not
      } else {
        // Sync enabled
        return 1.0  // Bright
      }
    }
  }
}

// On-screen SYNC label color
Text {
  id: syncLabel
  text: "SYNC"
  color: {
    if (!syncEnabled.value) return colors.colorGrey
    return inTempoSync ? colors.colorGreen : colors.colorRed
  }
}
```

### Feature 8: Theme Preset Customization

Customize theme presets via code comments:

```qml
// File: Screens/S8/Views/Settings/SettingsGrid.qml (line 1327+)

else if (theme.value == 2) {
  // Uncomment and modify any line to customize
  // hideBottomPanel.value = false
  topLeftCorner.value = 1  // Album(1), Deck Letter(2), etc.
  // waveformColor.value = 20
  waveformOffset.value = 18
  gridMode.value = 2  // Full(0), Dim(1), Ticks(2), Invisible(3)
  displayGridMarkersWF.value = true
  displayPhrasesWF.value = true
  displayBarsWF.value = true
  displayDeckLetterStripe.value = true
  displayDarkenerPlayed.value = true
  displayMinuteMarkersStripe.value = false
  displayGridMarkersStripe.value = false
  // panelMode.value = 0  // Disabled(0), Hotcue Bar(1), Performance Panel(2)
  beatsxPhrase.value = 16
  beatCounterMode.value = 3  // X BARS(0), X.Z BARS(1), X.Y.Z(2), -X.Y.Z(3)
  phaseWidget.value = 2  // Empty(0), Phase Meter(1), Beat Counter(2), Waveform(3)
}
```

**Customization Process:**

1. Open `SettingsGrid.qml`
2. Find theme preset section (line 1310+)
3. Remove `//` from any line to activate that setting
4. Modify value to desired state
5. Selecting that theme in settings applies all uncommented values

### Feature 9: Deck Button as Hold-to-Scratch

Override touchstrip mode by holding deck button:

```qml
property bool holdingDeckButton: false

Wire {
  from: "%surface%.deck_button"
  to: ButtonScriptAdapter {
    onPress: { holdingDeckButton = true }
    onRelease: { holdingDeckButton = false }
  }
}

// Touchstrip behavior
property int touchstripMode: {
  if (holdingDeckButton) {
    return TouchstripMode.scratch  // Force scratch while holding
  }
  return touchstripSettings.value  // Use configured mode otherwise
}

Wire {
  from: "%surface%.touchstrip"
  to: {
    switch(touchstripMode) {
      case TouchstripMode.scratch:
        return scratchAdapter
      case TouchstripMode.pitch:
        return pitchAdapter
      default:
        return disabledAdapter
    }
  }
}
```

### Key Innovations Summary

| Feature              | Benefit                                   |
| -------------------- | ----------------------------------------- |
| Dynamic Waveforms    | Visual feedback for filter/volume changes |
| 20 Zoom Levels       | Nearly stepless zoom precision            |
| Smart Back Button    | Browser toggle when browse-on-touch off   |
| PadFX First Tap      | Immediate response (no hold required)     |
| Double-Tap Functions | One-handed operation (no shift needed)    |
| Custom Logo Fallback | Branding/personalization                  |
| Tempo Match LED      | Instant visual sync accuracy feedback     |
| Theme Customization  | Code-based preset modification            |
| Hold-to-Scratch      | Temporary touchstrip override             |

### Feature 10: SYNC Button Hold Logic with Tempo Reset

Advanced SYNC button behavior with 250ms hold detection and intelligent tempo reset:

```qml
AppProperty { id: isSyncEnabled; path: "app.traktor.decks." + deckId + ".sync.enabled" }
AppProperty { id: isSyncTriggered; path: "app.traktor.decks." + deckId + ".sync.trigger" }
AppProperty { id: tempoAbsolute; path: "app.traktor.decks." + deckId + ".tempo.absolute" }
AppProperty { id: isPlaying; path: "app.traktor.decks." + deckId + ".play" }

Timer {
  id: holdSync_countdown
  interval: 250  // milliseconds
}

ButtonScriptAdapter {
  name: "SyncButton"

  onPress: {
    holdSync_countdown.restart()  // Start 250ms countdown when pressed
  }

  onRelease: {
    if (holdSync_countdown.running) {
      // Released BEFORE 250ms (quick press)
      if (isSyncEnabled.value) {
        isSyncEnabled.value = false  // SYNC ON → SYNC OFF
      } else {
        isSyncTriggered.value = !isSyncTriggered.value  // SYNC OFF → tempo sync only
      }
    } else {
      // Released AFTER 250ms (long press)
      if (isSyncEnabled.value) {
        isSyncEnabled.value = false  // SYNC ON → SYNC OFF
        if (!isPlaying.value) {
          tempoAbsolute.value = 1  // Reset tempo to ±0% (only when stopped)
        }
      } else {
        isSyncEnabled.value = true  // SYNC OFF → SYNC ON
      }
    }
    holdSync_countdown.stop()
  }
}
```

**Behavior Matrix:**

| Press Duration | SYNC State Before | Action                                                |
| -------------- | ----------------- | ----------------------------------------------------- |
| Quick (<250ms) | OFF               | Trigger tempo sync (not beat sync)                    |
| Quick (<250ms) | ON                | Disable SYNC                                          |
| Long (≥250ms)  | OFF               | Enable SYNC                                           |
| Long (≥250ms)  | ON                | Disable SYNC + Reset tempo to ±0% (deck stopped only) |

**Use Cases:**

- **Bar tempo/beatmatch by hand** on tracks with imperfect beatgrids
- **Tempo sync without beat sync** for manual alignment (Traktor set to beat sync mode)
- **Two ways to unsync**: Quick (standard) or long (with tempo reset)
- **Accidental reset prevention**: Tempo reset only when deck is stopped

### Feature 11: Toggle Shortcuts for S5/S8 Controllers

Quick access shortcuts using SHIFT combinations:

```qml
MappingProperty { id: browseOnTouch; path: "mapping.settings.browse_on_touch" }
MappingProperty { id: touchstripScratch; path: "mapping.settings.touchstrip_scratch" }

// SHIFT + QUANT: Toggle Browse-On-Touch
Wire {
  from: "%surface%.quant"
  to: ButtonScriptAdapter {
    brightness: browseOnTouch.value ? 1.0 : 0.0
    onPress: {
      if (shiftPressed.value) {
        browseOnTouch.value = !browseOnTouch.value
      } else {
        // Normal quantize function
        quantize.value = !quantize.value
      }
    }
  }
}

// SHIFT + SNAP: Toggle Touchstrip-Scratch
Wire {
  from: "%surface%.snap"
  to: ButtonScriptAdapter {
    brightness: touchstripScratch.value ? 1.0 : 0.0
    onPress: {
      if (shiftPressed.value) {
        touchstripScratch.value = !touchstripScratch.value
      } else {
        // Normal snap function
        snap.value = !snap.value
      }
    }
  }
}
```

**Shortcuts Summary:**

- **SHIFT + QUANT**: Toggle browse-on-touch mode
- **SHIFT + SNAP**: Toggle touchstrip-scratch mode
- LED brightness reflects current state

### Feature 12: D2 Controller Enhancements

#### D2 Screen Button Toggles

```qml
// Screen Button 6: Browse-On-Touch toggle
Wire {
  from: "%surface%.screen_button.6"
  to: ButtonScriptAdapter {
    onPress: {
      if (shiftPressed.value) {
        browseOnTouch.value = !browseOnTouch.value
        showPopup("Browse-On-Touch: " + (browseOnTouch.value ? "ON" : "OFF"))
      } else {
        // Normal screen button function
      }
    }
  }
}

// Screen Button 7: Touchstrip-Scratch toggle
Wire {
  from: "%surface%.screen_button.7"
  to: ButtonScriptAdapter {
    onPress: {
      if (shiftPressed.value) {
        touchstripScratch.value = !touchstripScratch.value
        showPopup("Touchstrip-Scratch: " + (touchstripScratch.value ? "ON" : "OFF"))
      } else {
        // Normal screen button function
      }
    }
  }
}

// Popup display function
function showPopup(message) {
  popupText.value = message
  popupTimer.restart()
}

Timer {
  id: popupTimer
  interval: 2000
  onTriggered: { popupText.value = "" }
}
```

#### D2 One-Handed FX Assignment

Replace SHIFT + [A,B,C,D] with FX-SELECT + [A,B,C,D] for secondary FX assignment:

```qml
AppProperty { id: holdingFxSelect; path: "mapping.state.fx_select_held" }

// FX-SELECT button state
Wire {
  from: "%surface%.fx_select"
  to: ButtonScriptAdapter {
    onPress: { holdingFxSelect.value = true }
    onRelease: { holdingFxSelect.value = false }
  }
}

// FX Assign buttons (A, B, C, D)
Wire {
  from: "%surface%.fx_assign.1"  // Button A
  to: ButtonScriptAdapter {
    onPress: {
      if (holdingFxSelect.value) {
        // FX-SELECT held: Assign FX Unit 2 to Deck A
        fxUnit2Assignment.value = 0  // Deck A
      } else {
        // Normal: Assign FX Unit 1 to Deck A
        fxUnit1Assignment.value = 0  // Deck A
      }
    }
  }
}

// Repeat for buttons B, C, D (decks 1, 2, 3)
```

**Benefits:**

- **One hand operation**: Hold FX-SELECT (thumb) + press A/B/C/D (fingers)
- **SHIFT freed up**: Can use SHIFT for other functions
- **Faster workflow**: No hand repositioning required

#### D2 SHIFT + ABCD Multi-Functions

Advanced display controls using SHIFT combinations:

```qml
MappingProperty { id: dynamicWaveforms; path: "mapping.settings.dynamic_waveforms" }
MappingProperty { id: waveformColorIndex; path: "mapping.settings.waveform_color" }
MappingProperty { id: hideBottomPanel; path: "app.traktor.decks." + deckId + ".hide_bottom_panel" }
MappingProperty { id: performancePanel; path: "app.traktor.decks." + deckId + ".performance_panel" }

readonly property variant waveformColors: [
  0, 1, 2, 3, 4, 5, 6, 7  // Color indices
]

readonly property variant panelStates: [
  0,  // Disabled
  1,  // Hotcue Bar
  2   // Performance Panel
]

// SHIFT + A: Toggle dynamic waveforms (hold)
Wire {
  from: "%surface%.fx_assign.1"  // Button A
  to: ButtonScriptAdapter {
    onPress: {
      if (shiftPressed.value) {
        holdTimer_A.restart()
      }
    }
    onRelease: {
      holdTimer_A.stop()
    }
  }
}

Timer {
  id: holdTimer_A
  interval: 500
  onTriggered: {
    dynamicWaveforms.value = !dynamicWaveforms.value
  }
}

// SHIFT + B: Cycle waveform colors (hold)
Timer {
  id: holdTimer_B
  interval: 500
  onTriggered: {
    var currentIndex = waveformColors.indexOf(waveformColorIndex.value)
    var nextIndex = (currentIndex + 1) % waveformColors.length
    waveformColorIndex.value = waveformColors[nextIndex]
  }
}

// SHIFT + C: Toggle bottom panel visibility (hold)
Timer {
  id: holdTimer_C
  interval: 500
  onTriggered: {
    hideBottomPanel.value = !hideBottomPanel.value
  }
}

// SHIFT + D: Cycle performance panel states (hold)
Timer {
  id: holdTimer_D
  interval: 500
  onTriggered: {
    var currentIndex = panelStates.indexOf(performancePanel.value)
    var nextIndex = (currentIndex + 1) % panelStates.length
    performancePanel.value = panelStates[nextIndex]
  }
}
```

**D2 SHIFT Combinations:**

- **SHIFT + Hold A**: Toggle dynamic waveforms
- **SHIFT + Hold B**: Cycle through waveform colors
- **SHIFT + Hold C**: Toggle hide/show bottom panel
- **SHIFT + Hold D**: Cycle through performance panel states (Disabled → Hotcue Bar → Performance Panel)

### Feature 13: Fullscreen Browser Fix (S5/S8)

Enable fullscreen browser mode when either screen displays browser:

```qml
// File: CSI/S8/S8.qml (line 47)

AppProperty {
  id: fullscreenBrowser
  path: "app.traktor.browser.full_screen"
}

onLeftScreenViewValueChanged: {
  // Prevent both screens showing browser simultaneously
  if (left.screenView.value == ScreenView.browser && right.screenView.value == ScreenView.browser) {
    right.screenView.value = ScreenView.deck
  }

  // Enable fullscreen browser when either screen shows browser
  if (left.screenView.value == ScreenView.browser || right.screenView.value == ScreenView.browser) {
    fullscreenBrowser.value = true
  } else {
    fullscreenBrowser.value = false
  }
}

onRightScreenViewValueChanged: {
  // Prevent both screens showing browser simultaneously
  if (left.screenView.value == ScreenView.browser && right.screenView.value == ScreenView.browser) {
    left.screenView.value = ScreenView.deck
  }

  // Enable fullscreen browser when either screen shows browser
  if (left.screenView.value == ScreenView.browser || right.screenView.value == ScreenView.browser) {
    fullscreenBrowser.value = true
  } else {
    fullscreenBrowser.value = false
  }
}
```

**Benefits:**

- **Fullscreen mode**: Browser uses full screen width when active on either display
- **Auto-toggle**: Automatically enables/disables fullscreen based on screen state
- **Mutual exclusion**: Prevents both screens showing browser (one reverts to deck)
- **Works on S5/S8**: Tested and confirmed working on dual-screen controllers

### Feature 14: Refined SYNC Button (Single/Double/Hold-Tap)

Improved SYNC button implementation with cleaner logic using boolean state:

```qml
AppProperty { id: isSyncEnabled; path: "app.traktor.decks." + deckId + ".sync.enabled" }
AppProperty { id: isSyncTriggered; path: "app.traktor.decks." + deckId + ".sync.trigger" }
AppProperty { id: tempoAbsolute; path: "app.traktor.decks." + deckId + ".tempo.absolute" }

property int holdTimer: 250  // milliseconds
property bool doubleTapSync: false

Timer { id: holdSync_countdown; interval: holdTimer }
Timer { id: tapSync_countdown; interval: holdTimer }

ButtonScriptAdapter {
  name: "SyncButton"

  onPress: {
    if (holdSync_countdown.running) {
      // Second press detected (double-tap)
      holdSync_countdown.stop()
      doubleTapSync = true

      // Double-tap function: Enable SYNC
      isSyncEnabled.value = true
    } else {
      // First press: Start hold countdown
      holdSync_countdown.restart()
    }
  }

  onRelease: {
    if (holdSync_countdown.running) {
      // Released before 250ms: Start tap countdown
      tapSync_countdown.restart()
    } else if (!doubleTapSync) {
      // Held for 250ms (not double-tap): Hold function
      tapSync_countdown.stop()

      // Hold button functions:
      tempoAbsolute.value = 1  // Reset tempo to ±0%
      isSyncEnabled.value = false  // Disable SYNC
    } else {
      // Was double-tap: Clean up
      doubleTapSync = false
      tapSync_countdown.stop()
    }
  }
}

Timer {
  id: holdSync_countdown
  interval: holdTimer

  onTriggered: {
    if (tapSync_countdown.running) {
      // Single tap confirmed (no second tap came)

      // Single-tap functions:
      isSyncEnabled.value = false  // Disable SYNC toggle
      isSyncTriggered.value = !isSyncTriggered.value  // Trigger tempo sync
    }
  }
}
```

**Behavior:**

- **Single-Tap**: TempoSync trigger + disable SYNC toggle
- **Double-Tap**: Enable SYNC toggle
- **Hold (≥250ms)**: Reset tempo to ±0% + disable SYNC toggle

**Improvements over Feature 10:**

- Uses `doubleTapSync` boolean for cleaner state tracking
- Prevents accidental double-tap during hold
- More reliable gesture detection
- **Vinyl Break Bugfix**: Included in this version

### Feature 15: Half-Size Waveform Stripe

Reduce stripe height to show more deck information:

```qml
// File: Screens/Shared/Widgets/Stripe/StripeContainer.qml (line 28)

// Original:
// anchors.bottom: parent.bottom

// Modified: Double stripe height (extends upward)
height: parent.height * 2 - 1  // anchors.bottom: parent.bottom
```

**Adjust Cue Marker Positions:**

```qml
// File: Screens/Shared/Widgets/Stripe/Stripe.qml

// ActiveCue positioning
// Original:
// anchors.bottom: parent.bottom

// Modified: Center cue markers vertically
anchors.bottom: parent.verticalCenter  // parent.bottom
```

**Effect:**

- Stripe is half the original height
- Cue marker triangles remain visible (positioned at vertical center)
- More screen space for deck information
- Cleaner, less cluttered appearance

**Note**: Triangle bases of cue markers are cut off, but markers remain clearly visible.

### Feature 16: Adjusted Loop/Move Controls

Context-aware loop encoder behavior based on Browse-on-touch and Move function:

```qml
MappingProperty { id: browseOnTouch; path: "mapping.settings.browse_on_touch" }
MappingProperty { id: shiftedBrowseMode; path: "mapping.settings.shifted_browse_mode" }

// Loop encoder behavior changes based on context
WiresGroup {
  // SHIFT + BROWSE encoder: Move mode
  enabled: browseOnTouch.value && shiftedBrowseMode.value == BrowseMode.move

  Wire {
    from: "%surface%.browse"
    to: EncoderScriptAdapter {
      onIncrement: {
        if (shiftPressed.value) {
          // Move 1 beat forward
          beatjumpSize.value = 1
          beatjumpForward.trigger()
        }
      }
      onDecrement: {
        if (shiftPressed.value) {
          // Move 1 beat backward
          beatjumpSize.value = 1
          beatjumpBackward.trigger()
        }
      }
    }
  }
}

WiresGroup {
  // SHIFT + LOOP encoder: Alternate behavior when browse has move
  enabled: browseOnTouch.value && shiftedBrowseMode.value == BrowseMode.move

  Wire {
    from: "%surface%.loop_size"
    to: EncoderScriptAdapter {
      onIncrement: {
        if (shiftPressed.value) {
          // Custom loop function (e.g., loop move)
          moveLoopForward.trigger()
        } else {
          // Normal loop size
          loopSizeMultiply.trigger()
        }
      }
      onDecrement: {
        if (shiftPressed.value) {
          moveLoopBackward.trigger()
        } else {
          loopSizeDivide.trigger()
        }
      }
    }
  }
}
```

**Conditional Behaviors:**

- **Browse-on-touch OFF**: Standard encoder functions
- **Browse-on-touch ON + Shifted Browse = Move**: SHIFT + BROWSE moves 1 beat
- **Browse-on-touch ON + Shifted Browse = Move**: SHIFT + LOOP gets alternate function
- Prevents function conflicts between encoders

### Feature 17: Encoder Conflict Resolution for Stems/Samples

Prevent loop/move encoders from interfering with stem volume/filter controls:

```qml
AppProperty {
  id: slotState
  path: "app.traktor.decks." + deckId + ".remix.slot.state"
}

// Stock loop/move controls
WiresGroup {
  // Disable when stem/sample slot is selected
  enabled: active && !slotState.value

  // Move encoder
  Wire {
    from: "%surface%.move"
    to: EncoderScriptAdapter {
      onIncrement: { beatjumpForward.trigger() }
      onDecrement: { beatjumpBackward.trigger() }
    }
  }

  // Loop encoder
  Wire {
    from: "%surface%.loop_size"
    to: EncoderScriptAdapter {
      onIncrement: { loopSizeMultiply.trigger() }
      onDecrement: { loopSizeDivide.trigger() }
    }
  }
}

// Stem/sample volume/filter controls
WiresGroup {
  // Enable when stem/sample slot is selected
  enabled: slotState.value

  // Move encoder → Volume
  Wire {
    from: "%surface%.move"
    to: EncoderScriptAdapter {
      onIncrement: {
        selectedSlotVolume.value = Math.min(1.0, selectedSlotVolume.value + 0.05)
      }
      onDecrement: {
        selectedSlotVolume.value = Math.max(0.0, selectedSlotVolume.value - 0.05)
      }
    }
  }

  // Loop encoder → Filter
  Wire {
    from: "%surface%.loop_size"
    to: EncoderScriptAdapter {
      onIncrement: {
        selectedSlotFilter.value = Math.min(1.0, selectedSlotFilter.value + 0.05)
      }
      onDecrement: {
        selectedSlotFilter.value = Math.max(0.0, selectedSlotFilter.value - 0.05)
      }
    }
  }
}
```

**Solution:**

- `slotState.value` is **true** when any stem/sample slot button is toggled/held
- Stock controls disabled when `!slotState.value`
- Stem/sample controls enabled when `slotState.value`
- Prevents simultaneous encoder functions (loop size + volume changes)

**Note**: This fix resolves encoder conflicts in legacy-remix-pad-mode and stems-pad-mode where volume/filter controls are visible on screen.

### Feature 18: Screen Button 7 Alternative Toggle

Alternative configuration for D2 screen button 7:

```qml
// File: CSI/Common/LegacyControllers/ScreenButtons.qml (line 123)

// Option 1: Touchstrip-Scratch toggle (original Feature 12)
Wire {
  from: "%surface%.display.buttons.7"
  to: TogglePropertyAdapter {
    path: "mapping.settings.scratch_with_touchstrip"
  }
  enabled: isTraktorD2 && shift && hasDeckProperties && hasEditButton
}

// Option 2: Performance Control on Touch toggle (alternative)
Wire {
  from: "%surface%.display.buttons.7"
  to: TogglePropertyAdapter {
    path: "mapping.settings.show_performance_control_on_touch"
  }
  enabled: isTraktorD2 && shift && hasDeckProperties && hasEditButton
}
```

**Choice:**

- **Option 1**: SHIFT + Screen 7 = Toggle touchstrip scratch mode
- **Option 2**: SHIFT + Screen 7 = Toggle performance control visibility on touch

Comment out the option you don't want to use.

### Feature 19: Remix Set Save Button Fix

Proper implementation for saving remix sets via screen button:

```qml
// INCORRECT (causes crashes):
Wire {
  from: "%surface%.display.buttons.2"
  to: HoldPropertyAdapter {
    path: "app.traktor.decks." + deckId + ".remix.save_set"
  }
  enabled: shift
}

// CORRECT (works properly):
Wire {
  from: "%surface%.display.buttons.2"
  to: TriggerPropertyAdapter {  // Use TriggerPropertyAdapter, not Hold
    path: "app.traktor.decks." + deckId + ".remix.save_set"
  }
  enabled: hasRemixProperties && shift  // Add hasRemixProperties check
}
```

**Fixes:**

- Use **TriggerPropertyAdapter** instead of **HoldPropertyAdapter**
- Add **hasRemixProperties** check (only works on Remix Deck)
- Prevents crashes when trying to save on non-remix decks
- Button 2 now safely saves remix sets when shifted

### Complete Features Summary

| #   | Feature               | Controllers | Benefit                                                |
| --- | --------------------- | ----------- | ------------------------------------------------------ |
| 1   | Dynamic Waveforms     | D2, S5, S8  | Visual feedback for filter/volume changes              |
| 2   | 20 Zoom Levels        | All         | Nearly stepless zoom precision                         |
| 3   | Smart Back Button     | All         | Browser toggle when browse-on-touch off                |
| 4   | PadFX First Tap       | All         | Immediate response (no hold required)                  |
| 5   | Double-Tap Functions  | All         | One-handed operation (no shift needed)                 |
| 6   | Custom Logo Fallback  | D2, S5, S8  | Branding/personalization                               |
| 7   | Tempo Match LED       | All         | Instant visual sync accuracy feedback                  |
| 8   | Theme Customization   | D2, S5, S8  | Code-based preset modification                         |
| 9   | Hold-to-Scratch       | All         | Temporary touchstrip override                          |
| 10  | SYNC Hold Logic       | All         | Smart tempo reset, bar beatmatching                    |
| 11  | SHIFT Toggles         | S5, S8      | Browse-on-touch, touchstrip-scratch shortcuts          |
| 12a | Screen Button Toggles | D2          | SHIFT + Screen 6/7 for settings                        |
| 12b | One-Hand FX Assign    | D2          | FX-SELECT + ABCD for FX Unit 2                         |
| 12c | SHIFT + ABCD          | D2          | Hold for display controls (waveforms, colors, panels)  |
| 13  | Fullscreen Browser    | S5, S8      | Auto fullscreen when browser visible                   |
| 14  | Refined SYNC Button   | All         | Cleaner single/double/hold-tap logic + vinyl break fix |
| 15  | Half-Size Stripe      | D2, S5, S8  | More screen space, cleaner appearance                  |
| 16  | Loop/Move Controls    | All         | Context-aware based on browse settings                 |
| 17  | Encoder Conflict Fix  | All         | Prevents stem/loop encoder conflicts                   |
| 18  | Screen Button 7 Alt   | D2          | Alternative toggle (performance control)               |
| 19  | Remix Save Fix        | All         | Proper TriggerPropertyAdapter usage                    |

---
