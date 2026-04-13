# Traktor QML Troubleshooting (Debugging + Testing)

**Purpose**: Structured debugging workflow, checklists, and solutions for common QML issues
**Use when**: A change doesn't work, Traktor won't start, or you need to isolate a problem
Use this file when something breaks or you’re not sure why a change didn’t work.

---

🧭 **Navigation** — ← [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) | **You are here** | → [05_FAQ.md](05_FAQ.md) | 📖 [Basics: 01_BASICS.md](01_BASICS.md)

**Quick Links:**

- Safety / backup / restore: [01_BASICS.md](01_BASICS.md)
- Where to edit + Traktor-QML building blocks: [02_API_REFERENCE.md](02_API_REFERENCE.md)
- Version-specific fixes: [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)

---

## 🧭 Quick Navigation

- [Debugging Workflow](#debugging-workflow)
- [Debugging Checklist](#debugging-checklist)
- [Troubleshooting Specific Issues](#troubleshooting-specific-issues)
- [Debugging Techniques](#debugging-techniques)
- [Advanced Debugging: HTTP Logger](#technique-4-advanced-debugging-with-http-logger-structured-logging)
- [Testing Checklist](#testing-framework-3-pass-approach--checklist)

---

## Debugging Workflow (Flowchart)

Use this flowchart to isolate problems quickly. For detailed steps, see **Debugging Steps** section below.

```
┌─────────────────────────────────────────────────────┐
│  "It doesn't work" — START HERE                     │
└─────────────────────────────────────────────────────┘
                        ↓
          File saved? → Traktor quit? → Restarted?
                  │
                NO│
                  ↓
          ┌──────────────────────────────────────┐
          │  Linter showing errors?              │
          │  (Check Problems panel in VS Code)  │
          └──────────────────────────────────────┘
```

**See Debugging Steps section below for detailed instructions.**

---

## Debugging Steps (Detailed)

### 1) Run Traktor from Terminal and Check Startup Errors

**This is the most direct way to find problems—do this first.**

When you run Traktor from a terminal, all QML errors, warnings, and undefined variables print to the screen with the exact file and line number.

**Using traktor-mod (easiest):**

```bash
traktor-mod traktor start
```

**Or directly (macOS):**

```bash
/Applications/Native\ Instruments/Traktor\ Pro\ 4/Traktor\ Pro\ 4.app/Contents/MacOS/Traktor\ Pro\ 4
```

Watch the terminal as Traktor loads. Look for error messages like:

- `ReferenceError: someVariable is not defined`
- `Cannot open: file:///...undefined.png`
- `Error: Cannot assign [undefined] to QString`
- `Binding loop detected for property "propertyName"`

> **Note:** Traktor always logs some warnings on startup — those are normal and can be ignored. Focus on errors that reference your modified files.

**Windows:**
The command path will be different. If you know the installation path to Traktor Pro 4, you can try a similar approach.

---

**Optional: Save the error output to a file for later review:**

```bash
/Applications/Native\ Instruments/Traktor\ Pro\ 4/Traktor\ Pro\ 4.app/Contents/MacOS/Traktor\ Pro\ 4 > traktor_debug.log 2>&1
```

This creates a file called `traktor_debug.log` in your Terminal's current folder with all the errors.

**Next step:** If errors appear, fix them in your QML files and restart Traktor. If no errors appear, continue below.

💡 **Tip:** For analyzing complex error logs, use the `analyze-qml-errors.md` prompt template to categorize all issues at once.

---

### 2) Reduce variables

- Quit Traktor.
- Reproduce with the smallest possible change.
- If you changed multiple files, restore all but one and retry.

### 3) Confirm you edited the right file

Traktor has many controller-specific variants. Make sure you’re editing:

- the correct controller folder (e.g. `CSI/S4MK3` vs `CSI/S8`)
- the correct layer (`CSI` vs `Screens` vs `Defines`)

If you’re not sure where to edit, see the map in [02_API_REFERENCE.md](02_API_REFERENCE.md#file-locations-quick-map).

### 4) Look for obvious QML errors first

The most common failures are basic:

- missing `{` / `}`
- missing commas or quotes
- wrong import style for your Traktor version
- typo in a control value path

### 5) Validate your assumptions

- Is the control value path available in your Traktor version?
- Is the deck ID variable what you think it is?
- Is a connection disabled by a condition?

Tip: confirm control value paths using the catalog embedded in [02_API_REFERENCE.md](02_API_REFERENCE.md#full-appproperty-path-catalog), and compare against working examples in the [X1MK3 Performance Mod](https://github.com/lsmith77/X1MK3_PerformanceMod) (see [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for feature-by-feature breakdown).

### 5b) Verify runtime state with logger output

Use structured logger output to verify conditions, wire execution, and state transitions in real time:

```qml
Logger { id: logger }

onMyButtonPressedChanged: {
    logger.debug("Button state changed", {
        pressed: myButtonPressed,
        deck: deckId
    })
}
```

This works reliably across all controllers, including those without hardware displays.

### 6) When in doubt, restore and re-apply

If Traktor becomes unstable, see [Chapter 01: Install / Backup / Restore](01_BASICS.md#install--backup--restore-the-safe-workflow) for detailed steps.

Quick version: Run `traktor-mod restore` to reset to stock QML, then re-apply changes one at a time.

### Quick path when following a community example

If you're working from an example in [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) (such as the X1MK3 mod) and it doesn't work:

1. Re-read that example’s “Explanation” section.
2. Confirm you edited the correct controller and layer (CSI vs Screens vs Defines).
3. Check for typos in `AppProperty` paths and `Wire from:` strings.
4. Use the checklist below.
5. If stuck, follow the systematic approach in [Chapter 01: Install / Backup / Restore](01_BASICS.md#install--backup--restore-the-safe-workflow).

---

## Debugging Checklist

### ⚡ Quick Fixes First (Solve 90% of Issues)

✅ **File saved?** (Easy to forget!)
✅ **Traktor completely closed?** (Quit, not minimize - Cmd+Q / File → Exit)
✅ **Traktor restarted?** (Required for QML changes to load)
✅ **Test the specific feature** (Don't assume it worked)

---

### �️ Prevention: Use a QML Linter _Before_ Testing

The single best way to avoid debugging is to catch errors before they reach Traktor.

**Before restarting Traktor, always check your editor's Problems panel** (if using VS Code with QML extension):

- **Red squiggles** = syntax errors or undefined properties
- **Yellow warnings** = unused code or type mismatches

**Common linter catches:**

- Missing closing brace `}`
- Typo in property name: `enabled: undefinedSetting`
- Missing comma between properties
- Incorrect property type: `visible: "true"` (should be `true`, not a string)

**Pro tip**: If your editor shows "0 Problems" but Traktor fails silently, then:

1. Check for Traktor version-specific API changes (see [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md))
2. Use logger probes (add temporary `logger.debug(...)` checkpoints—see Debugging Steps step 4b)
3. Use a clean backup and test with the smallest possible change

---

### �🔍 Common Issues (Check These Next)

**Issue:** Changes to a custom setting (like a toggle or delay) don't have any effect after restarting Traktor.

**Cause:** The `mapping.settings` vs `mapping.state` Persistence Trap.
When creating custom settings for a mod, it is common to use `MappingPropertyDescriptor` with a path like `mapping.settings.my_custom_setting`. However, properties under `mapping.settings` are **persistent** and are saved into Traktor's permanent `Traktor Settings.tsi` file the first time they are loaded. Once Traktor saves the setting to the `.tsi` file, it will **ignore** any future changes you make to the `value:` field in your QML file. The QML `value:` is only treated as a _default_ if the setting doesn't exist yet.

**Fix:**
For mod settings that you want to hardcode and tweak directly via QML files (especially for controllers without custom UI settings tabs), use `mapping.state` instead of `mapping.settings`.

```qml
// BAD: Traktor saves this once and ignores future QML edits
MappingPropertyDescriptor { id: mySetting; path: "mapping.settings.my_setting"; type: MappingPropertyDescriptor.Boolean; value: true; }

// GOOD: Traktor reads the exact value from QML every time it loads
MappingPropertyDescriptor { id: mySetting; path: "mapping.state.my_setting"; type: MappingPropertyDescriptor.Boolean; value: true; }
```

---

**Issue:** Controller fails to light up or screens stay blank after an edit, but Traktor shows no error.

**Cause:** QML Errors Fail Silently at Runtime.
Traktor's QML engine does not always provide visible error messages when a QML file fails to compile or load. If you make a syntax error, reference a non-existent property, or use an unsupported module, the controller might simply fail to initialize without any warning in the Traktor UI.

**Fix:**

- Always keep a clean backup of the original QML files.
- Make small, incremental changes and test frequently by restarting Traktor.
- If a controller fails to light up after an edit, immediately roll back the last change to isolate the issue.

---

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
4. **Use logger checkpoints** to trace the logic:

```qml
Logger { id: logger }

onSomeTrigger: {
    logger.debug("Wire condition check", {
        wireCondition: wireCondition,
        shift: shift,
        deck: deckId
    })
}
```

If the log appears with expected values, the path is active; if not, inspect your conditions and wiring source.

---

**Issue:** Display showing wrong data

**Check these:**

1. **AppProperty path correct?** `app.traktor.decks.1` NOT `app.traktor.deck.1` (plural!)
2. **Binding working?** Add a temporary `logger.debug` in the binding path to print current input values (see Technique 1 in Debugging Techniques)
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

### Debugging `enabled:` conditions (conflicts and "nothing happens")

If a button/encoder works sometimes (or never fires), the cause is often an `enabled:` condition that is always false, or two groups fighting over the same control.

Practical workflow:

- Temporarily force `enabled: true` to prove the `Wire` works.
- Then re-introduce conditions one-by-one until you find the blocker.
- Prefer the _most specific_ condition that matches the intent (avoid disabling unrelated functionality).

Example properties that are useful when debugging stem/remix encoder conflicts (varies by controller/version):

| Property                | Type | What it usually means                                           |
| ----------------------- | ---- | --------------------------------------------------------------- |
| `slotState.value`       | bool | A stem/remix slot is selected/toggled                           |
| `deck.focusedSlotstate` | bool | A specific slot has focus (more granular than `slotState`)      |
| `deck.footerControlled` | bool | Footer panel (stem/remix controls) is actively being controlled |

Tip: if `enabled: active && !slotState.value` is too broad, try a more specific blocker like `enabled: active && !deck.focusedSlotstate`.

### Runtime Probing During Development

Add temporary logger probes while developing to validate conditions and values:

```qml
Logger { id: logger }

onMyPropertyChanged: {
    logger.debug("Property probe", {
        value: (myProperty ? myProperty.value : null)
    })
}
```

Remove or reduce probe volume once the feature passes testing.

### Understanding error messages

- Traktor logs QML errors to the console (developer mode).
- “Missing property/path” typically means the path is wrong for your Traktor version, controller, or deck type.
- Syntax errors usually mean a typo (unmatched braces, missing quotes/commas).

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

## Troubleshooting Specific Issues

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
        logger.debug("Timer fired", { timer: "myTimer" })
    }
}

Logger { id: logger }

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
import QtQuick 2.0  // Use the QtQuick import version your target Traktor build uses
QtObject {
    readonly property int mySetting: 500
}
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

### Issue: Accessing Browser/Playlist Data

Browser item selection is **not accessible via the AppProperty API** — but it IS accessible through `Traktor.Browser` in the Screens layer for controllers that have displays.

**What does NOT work (AppProperty API):**

- `app.traktor.browser.list_selected_item` → returns `undefined`
- `app.traktor.browser.list_index` → returns `undefined`
- `app.traktor.browser.list_focus` → returns `undefined`

These are not exposed. The AppProperty API only gives UI state (`full_screen`, `sort_id`, preview player).

**What DOES work: `Traktor.Browser` in the Screens layer**

Controllers with displays (S4MK3, S8, D2) load QML from a `Screens/` folder that has access to `Traktor.Gui 1.0`. This module provides a native `Traktor.Browser` component with full access to browser state:

```qml
import Traktor.Gui 1.0 as Traktor

Traktor.Browser {
    id: browser
    isActive: true  // subscribe to browser model updates
    // Exposes:
    //   browser.currentPath    — e.g. "Browser | Track Collection | Releases"
    //   browser.currentIndex   — currently selected row index
    //   browser.isContentList  — true when viewing tracks (vs folder list)
    //   browser.dataSet        — list model of visible items
}

ListView {
    model: browser.dataSet
    delegate: Item {
        property var trackName: model.trackName
        property var artistName: model.artistName
        property var bpm: model.bpm
        property var key: model.key
        // also: nodeName, dataType, keyIndex, rating, prepared, loadedInDeck
    }
}
```

**Constraint: Screens layer only**

`Traktor.Gui 1.0` is only available in QML loaded from the `Screens/` folder. It is **not** available in the CSI layer (`CSI/`) — any attempt to use it there will fail silently or crash. Screen-less controllers (X1, Z1, F1, etc.) cannot use this approach.

**traktor-logger integration**

The `traktor-logger` package includes `ApiBrowser.qml` (a `Screens/Common/` component) that uses `Traktor.Browser` to monitor browser state and send it to the dashboard in real time. Enable it with:

```bash
traktor-mod logger api D2
```

This injects `ApiBrowser` into the Screen.qml of the target controller and sends current path, selected item metadata, and a window of surrounding items (up to 10 above, 20 below) to the **🎵 Browser** tab of the dashboard.

**References:**

- See [02_API_REFERENCE.md — Browser & Preview](02_API_REFERENCE.md#browser--preview) for AppProperty browser properties
- Deck metadata (for loaded tracks): [02_API_REFERENCE.md — Track Metadata](02_API_REFERENCE.md#track-metadata)

---

## Debugging Techniques

### Technique 1: Use Structured Logger Probes (Real-Time Feedback)

Add temporary logger probes to inspect state transitions in real time:

```qml
Logger { id: logger }

onMyConditionChanged: {
    logger.debug("Condition changed", {
        myCondition: myCondition,
        value: myProperty ? myProperty.value : null
    })
}
```

Remove or downgrade probe verbosity before final release.

### Technique 2: Simplify to Isolate Problem

Replace complex logic with a simple test:

```qml
onPress: {
    // Complex original code...

    // Simplified test:
    logger.debug("Simplified press test", { source: "onPress" })
}
```

If the simple version logs correctly, add back complexity step by step.

### Technique 3: Verify Against Working Code

Compare your wire/binding against a similar working element (in the stock QML or a community mod). Match the pattern exactly—if they look different, that's your bug.

### Technique 4: Advanced Debugging with HTTP Logger (Structured Logging)

For complex state debugging, use the **traktor-logger** tool—a structured logging system that runs inside Traktor's QML engine with a real-time browser dashboard.

When to use:

- ✅ Complex state tracking across multiple components
- ✅ Event timing and sequencing (which fires first?)
- ✅ Structured data inspection (JSON objects from wires)
- ✅ Post-mortem analysis (review what happened after a crash)

**Installation:**

You have two options depending on your use case:

**Option 1: Install traktor-logger as an overlay mod** (recommended)

```bash
traktor-mod logger pull
traktor-mod --source ~/.traktor-mod/traktor-logger
traktor-mod logger api S8  # or D2, S4MK3, etc.
```

Installs Logger.qml, the qmldir module registration, and all Api components into Traktor's QML. Then injects `ApiModule {}` into the specified controller.

**Option 2: Manual install** (without traktor-mod)

Download the package from https://github.com/lsmith77/traktor-logger and copy `qml/Defines/Logger.qml` to `<qml>/Defines/Logger.qml` manually. See the [traktor-logger README](https://github.com/lsmith77/traktor-logger) for full instructions.

**Usage in your QML:**

```qml
import Traktor.Defines 1.0

Module {
    Logger { id: logger }

    // Log state changes with structured data
    onSomeEventChanged: {
        logger.info("Event fired", {
            deckId: deck1.id,
            trackTitle: track.title,
            timestamp: new Date().toISOString(),
            state: someProperty.value
        })
    }

    // Different log levels for priority
    Wire {
        from: "%surface%.button.back"
        to: ButtonScriptAdapter {
            onPress: logger.debug("Back button pressed")
            onError: logger.error("Back button error", { reason: "hardware" })
        }
    }
}
```

**View logs in real-time:**

1. Clone the repo and navigate into it:

   ```bash
   git clone https://github.com/lsmith77/traktor-logger
   cd traktor-logger
   ```

2. Start the server:
   ```bash
   python3 server.py
   ```
3. Open dashboard: http://localhost:8080

4. Interact with Traktor—see logs appear in the dashboard with:
   - Color-coded severity (error=red, warn=orange, info=blue, debug=cyan)
   - Timestamps for timing analysis
   - Structured JSON data viewable inline
   - Full-text search and level filtering

**API Reference:**

```qml
Logger {
    // All methods accept: message (string) + optional data object (JSON)
    logger.log(message, data)      // Raw log (avoid—use specific levels below)
    logger.info(message, data)     // Important events
    logger.debug(message, data)    // Detailed state for investigation
    logger.warn(message, data)     // Unexpected but recoverable
    logger.error(message, data)    // Failures that need fixing
}
```

**Example: Debugging a complex interaction**

```qml
Logger { id: logger }

Binding {
    target: trackDisplay
    property: "color"
    value: {
        logger.debug("Color binding recalculated", {
            isPlayingDeck1: deck1.isPlaying,
            focusedDeck: focusedDeck.id,
            brightness: brightness.value
        })

        // Now you can see in the dashboard:
        // - Did this binding execute?
        // - What were the inputs?
        // - In what order did related bindings fire?

        return deck1.isPlaying ? "lime" : "gray"
    }
}
```

**Troubleshooting Logger Issues:**

| Problem                  | Solution                                                 |
| ------------------------ | -------------------------------------------------------- |
| No logs appearing        | Start server: `python3 server.py` in Logger repo         |
| "Logs are old"           | Restart: Page reload doesn't clear—restart Traktor       |
| Can't find Logger.qml    | Run `traktor-mod logger update` to refresh cache |
| No internet (first-time) | Use `logger update` on a machine with internet first     |

**Learn more:**

- [GitHub: traktor-logger](https://github.com/lsmith77/traktor-logger) — Full source, examples, and troubleshooting
- Logger.qml source: [Logger.qml on GitHub](https://github.com/lsmith77/traktor-logger/blob/main/qml/Logger.qml)
- HTTP server: [server.py on GitHub](https://github.com/lsmith77/traktor-logger/blob/main/server.py)

---

## Help & Resources

**This project**:

- Handbook index: [00_HANDBOOK.md](00_HANDBOOK.md)
- API reference: [02_API_REFERENCE.md](02_API_REFERENCE.md)
- Resources: [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md)

**External**:

- Qt QML Docs: https://doc.qt.io/qt-6/qml
- NI Forums: https://community.native-instruments.com/
- Traktor Bible: https://www.traktorbible.com/

---

## Testing Framework: 3-Pass Approach + Checklist

Follow this structured testing method after making changes. This catches 95% of issues efficiently.

### The 3 Passes

1. **Normal Path** – Does the feature work as designed?
   - Single button press / single encoder movement
   - Expected behavior occurs
   - No side effects
2. **Edge Cases** – What about boundary conditions?
   - Rapid clicks (debounce issues?)
   - Hold-down too long (timing issues?)
   - Shift+feature combinations (conflicts?)
3. **Reversal Test** – Can you reliably undo?
   - Disable a toggle, then re-enable?
   - Load track, then unload?
   - Verify state resets to before your change

**Common issues this catches:** Debounce failures, race conditions, state corruption, shift layer conflicts, timing bugs.

### Quick Checklist (After Each Pass)

Use these as validation for each pass above:

**Visual**: Display shows correct data, no glitches, overlays appear/disappear  
**Functional**: Buttons respond, encoders work, shift combinations work, no unexpected behavior  
**Physical**: LEDs light up, screens update in real-time, visual state matches actual state

**Pro tip:** Document which pass a bug was caught in—it tells you where to look (input handling, timing, or state management).

---

**Next:** [05_FAQ.md](05_FAQ.md)
