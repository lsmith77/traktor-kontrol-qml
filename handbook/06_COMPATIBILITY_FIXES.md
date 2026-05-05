# Traktor QML: Compatibility Fixes

**Purpose**: Version compatibility matrix and specific fixes for known issues across Traktor versions
**Use when**: Something breaks after a Traktor update, or you're updating to a new Traktor version

---

🧭 **Navigation** — ← [05_FAQ.md](05_FAQ.md) | **You are here** | → [07_GLOSSARY.md](07_GLOSSARY.md) | 📖 [API: 02_API_REFERENCE.md](02_API_REFERENCE.md)

## 🧭 Quick Navigation

- [Version Compatibility Matrix](#version-compatibility-matrix) - Which versions break what
- [Fix 1: Flux Marker on Hardware Screens](#fix-1-flux-marker-not-appearing-on-hardware-screens) - Traktor 3.5+
- [Fix 2: QML Mod Base Version Requirements](#fix-2-qml-mod-base-version-requirements) - Installation method
- [General Version Migration Tips](#general-version-migration-tips) - What to check after updates

## Version Compatibility Matrix

QML mods can break between Traktor versions. This matrix documents known compatibility boundaries based on community experience.

| Traktor Version | QML Status        | Notes                                                                                                |
| --------------- | ----------------- | ---------------------------------------------------------------------------------------------------- |
| 3.0 - 3.4       | Stable            | Original QML structure, most mods originate here                                                     |
| 3.5             | Breaking changes  | `followFluxPosition` property broken ([Fix 1](#fix-1-flux-marker-not-appearing-on-hardware-screens)) |
| 3.5 - 3.7       | Stable with fixes | Community mods (Supreme Edition, SupremeModEdit) confirmed working                                   |
| 3.8+            | Breaking changes  | QML folder structure changes; many mods require rework                                               |
| 3.9             | Unconfirmed       | Community mods not yet ported as of last report                                                      |
| 4.x (TP4)       | New features      | Adds `ButtonGestures` module, new load modes, new property paths; older mods may need updates        |

**Key takeaway**: Always test mods after any Traktor update. Versions 3.5-3.7 are the most battle-tested for community mods. Moving to 3.8+ or 4.x may require significant rework.

---

## Fix 1: Flux Marker Not Appearing on Hardware Screens

**Affected versions**: Traktor 3.5+
**Affected controllers**: S4 MK3, D2, S8, S5 (all controllers with screens)
**NI Bug Ticket**: TP-16853
**Source**: [NI Community Forum](https://community.native-instruments.com/discussion/1202/dysfunctional-flux-marker-repaired)

### The Problem

After the Traktor 3.5 update, the Flux playmarker stopped appearing and moving on hardware screens. The built-in QML property `followFluxPosition: true` on the `Traktor.WaveformTranslator` component silently broke — no error, the marker just doesn't render.

### The Fix

Replace the broken `followFluxPosition` binding with a manual position calculation in the WaveformContainer file.

**File**: `Screens/S8/Views/Deck/WaveformContainer.qml` (path varies by controller — check your controller's `Screens/[Controller]/Views/Deck` folder)

#### Step 1: Add AppProperty Declarations

Add these three properties near the top of the WaveformContainer file, alongside existing AppProperty declarations. Replace `deckId` with whatever deck identifier variable your file uses:

```qml
AppProperty { id: playheadPosition; path: "app.traktor.decks." + deckId + ".track.player.playhead_position" }
AppProperty { id: fluxPosition;     path: "app.traktor.decks." + deckId + ".track.player.flux_position" }
AppProperty { id: freezeEnabled;    path: "app.traktor.decks." + deckId + ".freeze.enabled" }
```

#### Step 2: Fix the Flux Marker Position

Find the flux marker `Rectangle` inside the `Traktor.WaveformTranslator` component. It typically looks like this:

```qml
Traktor.WaveformTranslator {
    // ...
    followFluxPosition: true  // ← This is broken in 3.5+

    Rectangle {
        id: flux_marker
        width: 3
        height: view.height
        color: colors.playmarker_flux
        border.color: colors.colorBlack31
        border.width: 1
        visible: fluxState.value == 2
        x: 0  // ← This doesn't move
    }
}
```

Replace the `followFluxPosition` and static `x: 0` with the calculated position:

```qml
Traktor.WaveformTranslator {
    // ...
    // followFluxPosition: true  ← Remove or comment out

    Rectangle {
        id: flux_marker
        width: 3
        height: view.height
        color: colors.playmarker_flux
        border.color: colors.colorBlack31
        border.width: 1
        visible: fluxState.value == 2
        x: ((fluxPosition.value - playheadPosition.value) / wfPosition.sampleWidth) * (freezeEnabled.value ? 0x13d8000 : 0x1f80000)
    }
}
```

### How It Works

The formula calculates the pixel offset of the flux marker relative to the current playhead:

| Component                                     | Purpose                                                 |
| --------------------------------------------- | ------------------------------------------------------- |
| `fluxPosition.value - playheadPosition.value` | Distance between flux return point and current playhead |
| `/ wfPosition.sampleWidth`                    | Normalize to waveform's visible sample range            |
| `* 0x1f80000`                                 | Scale to pixel coordinates in **normal playback mode**  |
| `* 0x13d8000`                                 | Scale to pixel coordinates in **freeze/slicer mode**    |

The two hex multipliers (`0x1f80000` = 33,095,680 and `0x13d8000` = 20,742,144) account for different waveform display scales between normal and freeze modes.

### Tuning

This is described by the original author as "an eyeball fix." If the marker position seems slightly off on your hardware:

- Increase the multiplier to move the marker further from the playhead
- Decrease it to move the marker closer
- The ratio between the two multipliers should stay roughly the same (freeze multiplier is ~63% of normal)

### New AppProperty Paths

This fix introduces three properties not commonly used elsewhere:

| Property Path                                        | Type  | Description                             |
| ---------------------------------------------------- | ----- | --------------------------------------- |
| `app.traktor.decks.X.track.player.playhead_position` | float | Current playhead position in the track  |
| `app.traktor.decks.X.track.player.flux_position`     | float | Position where flux mode will return to |
| `app.traktor.decks.X.freeze.enabled`                 | bool  | Whether freeze/slicer mode is active    |

---

## Fix 2: QML Mod Base Version Requirements

**Affected versions**: All
**Source**: [NI Community Forum - SupremeModEdit](https://community.native-instruments.com/discussion/4473/supremeeditionmod-edit)

### The Problem

Community mods (Supreme Edition, SupremeModEdit, etc.) are built as **overlay patches** — they replace specific files on top of a particular Traktor version's QML folder. Installing them on the wrong base version causes silent failures or crashes.

### The Solution

When installing community QML mods:

1. **Check which Traktor version the mod was built for**. For example, SupremeModEdit V2 requires the Traktor Beta 31 QML folder as its base.

2. **Use the overlay method**, not full replacement:

   ```
   # Correct: overlay mod files on top of base
   1. Start with the correct base version's qml/ folder
   2. Copy the mod's files on top, overwriting when prompted

   # Wrong: replace the entire qml/ folder with just the mod files
   # This will be missing files the mod doesn't override
   ```

3. **Verify completeness** after overlay — the mod only replaces files it changes. All other stock files must remain from the correct base version.

### Why This Matters

QML mods typically modify 10-30 files out of hundreds in the `qml` folder. The unmodified files must come from the version the mod was designed for, because:

- Internal `import` paths may change between versions
- Component APIs (available properties, signals) can change
- New files added in updates won't be present if you only use mod files
- File structure reorganizations between major versions break relative paths

---

## General Version Migration Tips

When updating Traktor and re-applying your QML mods:

### Before Updating

1. **Backup your modded `qml` folder** outside the Traktor directory
2. **Document your changes** — keep a list of which files you modified and why
3. **Use Git** to track your modifications (see the workflow notes in [01_BASICS.md](01_BASICS.md) and the structure in [00_HANDBOOK.md](00_HANDBOOK.md))

### After Updating

1. **Diff the new stock files against your backup** to see what NI changed:

   ```bash
   diff -rq qml/ qml.modded/ | grep "differ"
   ```

2. **Check for these common breaking changes**:
   - Renamed or moved QML files
   - Changed `import` module versions (e.g., `import CSI 1.0` → `import CSI 2.0`)
   - Removed or renamed AppProperty paths
   - New required properties on existing components
   - Changed function signatures in adapters

3. **Re-apply changes one file at a time**, testing after each

4. **Test these areas first** (most likely to break):
   - Waveform display (rendering changes are common)
   - Browser navigation (column IDs can shift)
   - Overlay timing (timer infrastructure changes)
   - LED/button mappings (new hardware support can reorganize CSI files)

### Version-Specific Property Changes

| Version   | Added                                                                                                                               | Changed/Removed                                                                                                   |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| TP4 (4.x) | `app.traktor.decks.X.load_secondary.selected`, `app.traktor.decks.X.load_track.selected`, `app.traktor.decks.X.load_stems.selected` | -                                                                                                                 |
| TP4 (4.x) | `ButtonGestures` module (native gesture detection)                                                                                  | -                                                                                                                 |
| TP4 (4.x) | `import QtQuick 2.0` (explicit version required)                                                                                    | `import QtQuick` (versionless) no longer used                                                                     |
| 3.5+      | -                                                                                                                                   | `followFluxPosition` broken on WaveformTranslator ([Fix 1](#fix-1-flux-marker-not-appearing-on-hardware-screens)) |

---

## Fix 3: QtQuick Import Version Compatibility

**Affected versions**: Mods built for TP 3.10-3.11 running on TP 4.x (or vice versa)
**Affected controllers**: All

### The Problem

Community mods built for different Traktor versions may use different `QtQuick` import styles. The stock QML files have changed their import convention between major versions:

- **Traktor Pro 3.10-3.11** (and some community mods): `import QtQuick` (versionless)
- **Traktor Pro 4.x** (current stock): `import QtQuick 2.0` (explicit version)

Mixing import styles can cause silent failures where components don't load properly.

### The Fix

When porting a mod between Traktor versions, ensure all QML files use the same import style as the target version's stock files:

```qml
// For Traktor Pro 4.x (current):
import QtQuick 2.0
import CSI 1.0

// For older Traktor Pro 3.10-3.11 mods:
import QtQuick
import CSI 1.0
```

**Batch fix** (find and replace across all mod files):

- Search: `import QtQuick\n` (without version number)
- Replace: `import QtQuick 2.0\n`

### Related Import Changes

| Import             | TP 3.x (older)                  | TP 4.x (current)                                  |
| ------------------ | ------------------------------- | ------------------------------------------------- |
| QtQuick            | `import QtQuick`                | `import QtQuick 2.0`                              |
| QtGraphicalEffects | `import QtGraphicalEffects 1.0` | `import Qt5Compat.GraphicalEffects` (some builds) |

### Which Mods Are Affected

| Mod                                | Built For     | Import Style                                  | Needs Fix for TP 4.x    |
| ---------------------------------- | ------------- | --------------------------------------------- | ----------------------- |
| traktor-kontrol-screens (tipesoft) | TP 3.10-3.11  | `import QtQuick` (versionless)                | Yes                     |
| S4 MK3 Mod (Joe Easton)            | TP 3.x (2019) | `import QtQuick 2.5`                          | Check compatibility     |
| X1 MK3 Performance Mod V12         | TP 4.4.1      | `import QtQuick 2.0`                          | No (already compatible) |
| S3 PerformanceMod 4.0.2 (pixel)    | TP 4.4.1      | `import QtQuick 2.0` / `2.5` / `2.12` (mixed) | No (already compatible) |
| Supreme Edition / SupremeModEdit   | TP 3.5-3.7    | `import QtQuick 2.0`                          | Check compatibility     |

---

## Fix 4: Controller-Specific Module Differences

**Affected versions**: All
**Affected controllers**: All (when porting mods between controllers)

### The Problem

Some community mods replace shared modules in `CSI/Common` with controller-specific versions. This can cause conflicts when multiple mods are combined or when a mod is installed alongside stock files expecting the shared module.

### Known Module Replacements

These mods replace shared modules with self-contained versions:

| Shared Module                                    | Replaced By                                                                                                                             | Mod                                |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `CSI/Common/ExtendedBrowserModule.qml`           | `CSI/S4MK3/S4MK3Browse.qml`                                                                                                             | S4 MK3 Mod (Joe Easton)            |
| `CSI/Common/DeckHelpers.js`                      | `CSI/S4MK3/S4MK3Functions.js`                                                                                                           | S4 MK3 Mod (Joe Easton)            |
| `CSI/Common/ChannelFX/FourChannelFXSelector.qml` | `CSI/S4MK3/S4MK3ChannelFXSelector.qml`                                                                                                  | S4 MK3 Mod (Joe Easton)            |
| `CSI/Common/ChannelFX/FourChannelFXSelector.qml` | `CSI/Common/ChannelFX/FourChannelFXSelectorS3.qml`                                                                                      | S3 PerformanceMod (pixel)          |
| `CSI/Common/ChannelFX` (multiple)                | `CSI/Common/ChannelFX/ChannelFXS3.qml`, `FXChannelsSequencerS3.qml`, `FXControlsS3.qml`, `FXToggleMixerS3.qml`, `FXUnitsSelectorS3.qml` | S3 PerformanceMod (pixel)          |
| `CSI/Common/ExtendedBrowserModule.qml`           | `CSI/Common/ExtendedBrowserModuleS3.qml`                                                                                                | S3 PerformanceMod (pixel)          |
| `CSI/Common/HotcuesModule.qml`                   | `CSI/Common/HotcuesModuleS3.qml`                                                                                                        | S3 PerformanceMod (pixel)          |
| `CSI/Common/ChannelFX/TwoChannelFXSelector.qml`  | (removed)                                                                                                                               | traktor-kontrol-screens (tipesoft) |

### The Fix

When installing these mods:

1. **Check if the mod replaces shared modules** -- look for new files in the controller-specific directory that have similar names to files in `CSI/Common`
2. **Don't mix mods that replace the same shared module** in different ways
3. **If combining mods**, ensure each mod's controller-specific replacements don't conflict with other controllers' imports of the shared module
4. **Backup `CSI/Common`** separately -- it's the most fragile area when combining mods

---

## Fix 5: New Hardware Support Files in TP 4.x

**Affected versions**: Mods built for TP 3.x running on TP 4.x
**Affected controllers**: Z1 MK2, MX2 (new in TP 4.x)

### The Problem

Traktor Pro 4.x added QML support for new controllers not present in TP 3.x:

- `CSI/Z1MK2` -- Z1 MK2 controller
- `CSI/MX2` -- MX2 controller
- `Screens/Z1MK2` -- Z1 MK2 screen definitions

Community mods built for TP 3.x don't include these directories. If you replace the entire `qml` folder with a mod's files, these controllers will stop working.

### The Fix

**Always use the overlay method** when installing mods:

1. Start with the current stock TP 4.x `qml` folder as your base
2. Copy only the mod's changed files on top, overwriting when prompted
3. **Never** replace the entire `qml` folder with just the mod's files

This ensures new controller support files remain intact.

---

## Fix 6: D2/S8/S5 Deck Focus Not Persisting Across Restarts

**Affected versions**: All
**Affected controllers**: D2, S8, S5 (controllers using `Deck_S8Style.qml`)
**Source**: [NI Community Forum - D2 Deck Focus](https://community.native-instruments.com/discussion/50006/d2-deck-focus)

### The Problem

When you select a deck focus on the D2 (e.g., switching from Deck A to Deck C), the selection resets to the default when Traktor restarts or the controller reconnects.

### The Fix

Change the deck focus property path from `propertiesPath` (transient `mapping.state`) to `settingsPath` (persistent `mapping.settings`).

**File 1**: `CSI/D2/Deck_S8Style.qml` (around line 100)

```qml
// Change this:
path: propertiesPath + ".deck_focus"
// To this:
path: settingsPath + ".deck_focus"
```

**File 2**: `Screens/D2/Views/Deck/DeckView.qml` (around line 54)

```qml
// Change this:
MappingProperty { id: deckFocusProp; path: screen.propertiesPath + ".deck_focus" }
// To this:
MappingProperty { id: deckFocusProp; path: "mapping.settings.deck_focus" }
```

### How It Works

Properties under `mapping.state.*` are transient — they reset when the controller disconnects. Properties under `mapping.settings.*` are saved in Traktor's mapping file and persist across restarts. Both files (CSI and Screen) must use the same path for the screen to display the correct state.

**See also**: [X1MK3 Screen Feedback](03_COMMUNITY_RESOURCES.md#x1mk3-performance-mod) for examples of state synchronization across overlays.

---

**Have a fix for a version-specific issue?** Add it to this file following the format above: Problem, Affected versions, Fix, and Explanation.

---

**Next:** [07_GLOSSARY.md](07_GLOSSARY.md)
