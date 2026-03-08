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
- [Testing Checklist](#testing-checklist)

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

### 1) Reduce variables

- Quit Traktor.
- Reproduce with the smallest possible change.
- If you changed multiple files, restore all but one and retry.

### 2) Confirm you edited the right file

Traktor has many controller-specific variants. Make sure you’re editing:

- the correct controller folder (e.g. `CSI/S4MK3` vs `CSI/S8`)
- the correct layer (`CSI` vs `Screens` vs `Defines`)

If you’re not sure where to edit, see the map in [02_API_REFERENCE.md](02_API_REFERENCE.md#file-locations-quick-map).

### 3) Look for obvious QML errors first

The most common failures are basic:

- missing `{` / `}`
- missing commas or quotes
- wrong import style for your Traktor version
- typo in a control value path

### 4) Validate your assumptions

- Is the control value path available in your Traktor version?
- Is the deck ID variable what you think it is?
- Is a connection disabled by a condition?

Tip: confirm control value paths using the catalog embedded in [02_API_REFERENCE.md](02_API_REFERENCE.md#full-appproperty-path-catalog), and compare against working examples in the [X1MK3 Performance Mod](https://github.com/lsmith77/X1MK3_PerformanceMod) (see [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for feature-by-feature breakdown).

### 4b) Use visual debugging to see real-time state

Add temporary visible indicators to your QML to see what's happening **in real-time** as you test:

```qml
Rectangle {
    width: 100
    height: 20
    color: myButtonPressed ? "green" : "red"  // ← Shows state on screen
    Text {
        text: "Button: " + (myButtonPressed ? "ON" : "OFF")
    }
}
```

This gives you **immediate visual feedback** without needing to restart or check log files. When you see the color/text change in real-time, you know your code is executing. When it doesn't change, the wire or condition is the problem.

**Pro tip**: Add debug rectangles to prove each step of the logic works, then remove them before final testing.

### 5) When in doubt, restore and re-apply

If Traktor becomes unstable, see [Chapter 01: Install / Backup / Restore](01_BASICS.md#install--backup--restore-the-safe-workflow) for detailed steps.

Quick version: Run `install-traktor-mod restore` to reset to stock QML, then re-apply changes one at a time.

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

**Did you try turning it off and on again?**

✅ **File saved?** (Easy to forget!)
✅ **Traktor completely closed?** (Quit, not minimize - Cmd+Q / File → Exit)
✅ **Traktor restarted?** (Required for QML changes to load)
✅ **Test the specific feature** (Don't assume it worked)

**💡 If fixed, you're done! If still broken, continue below...**

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
2. Use visual debugging (add temporary colored rectangles—see Debugging Steps step 4b)
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
4. **Use visual debugging** to trace the logic:

```qml
Rectangle {
    width: 50
    height: 50
    color: wireCondition ? "green" : "red"  // ← Is wire enabled?
}
```

When you press the button: does the rectangle change color? If yes, the wire works. If no, the condition is the problem.

---

**Issue:** Display showing wrong data

**Check these:**

1. **AppProperty path correct?** `app.traktor.decks.1` NOT `app.traktor.deck.1` (plural!)
2. **Binding working?** Add a visual debug rectangle that shows the binding's value (see Technique 1 in Debugging Techniques)
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

### Visual Debugging During Development

Add temporary visual indicators while developing to see state changes instantly:

```qml
// Add debug rectangle to test a condition
Rectangle {
    width: 50
    height: 50
    color: (myProperty && myProperty.value > 10) ? "blue" : "gray"
    Text { text: "Val: " + (myProperty ? myProperty.value : "null") }
}

// Remove this after testing passes
```

This is instant feedback—no restart or log file hunting needed.

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
        debugRect.color = "lime"  // ← Visual confirmation timer fired
    }
}

// Add debug rectangle to the screen
Rectangle {
    id: debugRect
    width: 50
    height: 50
    color: "gray"
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

## Debugging Techniques

### Technique 1: Use Visual Debugging (Real-Time Feedback)

Add visible indicators to see state changes instantly **without restarting**:

```qml
// Add temporary debug elements
Rectangle {
    width: 100
    height: 20
    color: myCondition ? "green" : "red"  // ← See state change in real-time
    Text {
        text: "State: " + myProperty.value.toString()  // ← See actual values
    }
}
```

Remove these debug rectangles before final testing.

### Technique 2: Simplify to Isolate Problem

Replace complex logic with a simple test:

```qml
onPress: {
    // Complex original code...

    // Simplified test:
    debugRectangle.color = "blue"  // ← Visual confirmation this runs
}
```

If the simple version triggers visually, add back complexity step by step.

### Technique 3: Verify Against Working Code

Compare your wire/binding against a similar working element (in the stock QML or a community mod). Match the pattern exactly—if they look different, that's your bug.

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
