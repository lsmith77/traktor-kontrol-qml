# Traktor QML Modding Caveats

This document outlines common pitfalls, unexpected behaviors, and "gotchas" when modifying Traktor QML files.

## 1. `mapping.settings` vs `mapping.state` Persistence Trap

**The Issue:**
When creating custom settings for a mod (e.g., a toggle or a delay value), it is common to use `MappingPropertyDescriptor` with a path like `mapping.settings.my_custom_setting`. However, properties under `mapping.settings` are **persistent** and are saved into Traktor's permanent `Traktor Settings.tsi` file the first time they are loaded.

**The Trap:**
Once Traktor saves the setting to the `.tsi` file, it will **ignore** any future changes you make to the `value:` field in your QML file. The QML `value:` is only treated as a *default* if the setting doesn't exist yet. 
If your controller does not have a UI settings tab exposed in Traktor to change this value, you will be permanently stuck with the original value you first coded, even if you change the QML file and restart Traktor.

**The Solution:**
For mod settings that you want to hardcode and tweak directly via QML files (especially for controllers without custom UI settings tabs like the MX2), use `mapping.state` instead of `mapping.settings`.

```qml
// BAD: Traktor saves this once and ignores future QML edits
MappingPropertyDescriptor { id: mySetting; path: "mapping.settings.my_setting"; type: MappingPropertyDescriptor.Boolean; value: true; }

// GOOD: Traktor reads the exact value from QML every time it loads
MappingPropertyDescriptor { id: mySetting; path: "mapping.state.my_setting"; type: MappingPropertyDescriptor.Boolean; value: true; }
```

## 2. QML Errors Fail Silently at Runtime

**The Issue:**
Traktor's QML engine does not always provide visible error messages when a QML file fails to compile or load.

**The Trap:**
If you make a syntax error, reference a non-existent property, or use an unsupported module, the controller might simply fail to initialize (e.g., lights stay off, screens stay blank) without any warning in the Traktor UI. Furthermore, standard code editors might not flag these as static errors because they lack the full Traktor QML context.

**The Solution:**
- Always keep a clean backup of the original QML files.
- Make small, incremental changes and test frequently by restarting Traktor.
- If a controller fails to light up after an edit, immediately roll back the last change to isolate the issue.

## 3. Missing QtQuick Imports

**The Issue:**
Some standard QML components (like `Timer`) require explicit imports that might not be present in the stock Traktor QML files.

**The Trap:**
If you add a `Timer` to a file like `MX2Deck.qml` without importing `QtQuick`, the file will fail to load, and the controller will not initialize.

**The Solution:**
Always ensure you have the necessary imports at the top of your file when adding new QML components.
```qml
import QtQuick 2.0
```
