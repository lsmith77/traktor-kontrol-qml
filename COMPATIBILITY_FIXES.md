# Traktor QML Version Compatibility Fixes

**Purpose**: Fixes for bugs and breaking changes between Traktor versions. Apply these patches based on your specific Traktor version.

## Quick Navigation

- [Version Compatibility Matrix](#version-compatibility-matrix) - Which versions break what
- [Fix 1: Flux Marker on Hardware Screens](#fix-1-flux-marker-not-appearing-on-hardware-screens) - Traktor 3.5+
- [Fix 2: QML Mod Base Version Requirements](#fix-2-qml-mod-base-version-requirements) - Overlay installation method
- [General Version Migration Tips](#general-version-migration-tips) - What to check after updates

---

## Version Compatibility Matrix

QML mods can break between Traktor versions. This matrix documents known compatibility boundaries based on community experience.

| Traktor Version | QML Status | Notes |
| --------------- | ---------- | ----- |
| 3.0 - 3.4 | Stable | Original QML structure, most mods originate here |
| 3.5 | Breaking changes | `followFluxPosition` property broken ([Fix 1](#fix-1-flux-marker-not-appearing-on-hardware-screens)) |
| 3.5 - 3.7 | Stable with fixes | Community mods (Supreme Edition, SupremeModEdit) confirmed working |
| 3.8+ | Breaking changes | QML folder structure changes; many mods require rework |
| 3.9 | Unconfirmed | Community mods not yet ported as of last report |
| 4.x (TP4) | New features | Adds `ButtonGestures` module, new load modes, new property paths; older mods may need updates |

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

**File**: `Screens/S8/Views/Deck/WaveformContainer.qml` (path varies by controller — check your controller's `Screens/[Controller]/Views/Deck/` folder)

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

| Component | Purpose |
| --------- | ------- |
| `fluxPosition.value - playheadPosition.value` | Distance between flux return point and current playhead |
| `/ wfPosition.sampleWidth` | Normalize to waveform's visible sample range |
| `* 0x1f80000` | Scale to pixel coordinates in **normal playback mode** |
| `* 0x13d8000` | Scale to pixel coordinates in **freeze/slicer mode** |

The two hex multipliers (`0x1f80000` = 33,095,680 and `0x13d8000` = 20,742,144) account for different waveform display scales between normal and freeze modes.

### Tuning

This is described by the original author as "an eyeball fix." If the marker position seems slightly off on your hardware:

- Increase the multiplier to move the marker further from the playhead
- Decrease it to move the marker closer
- The ratio between the two multipliers should stay roughly the same (freeze multiplier is ~63% of normal)

### New AppProperty Paths

This fix introduces three properties not commonly used elsewhere:

| Property Path | Type | Description |
| ------------- | ---- | ----------- |
| `app.traktor.decks.X.track.player.playhead_position` | float | Current playhead position in the track |
| `app.traktor.decks.X.track.player.flux_position` | float | Position where flux mode will return to |
| `app.traktor.decks.X.freeze.enabled` | bool | Whether freeze/slicer mode is active |

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

QML mods typically modify 10-30 files out of hundreds in the `qml/` folder. The unmodified files must come from the version the mod was designed for, because:

- Internal `import` paths may change between versions
- Component APIs (available properties, signals) can change
- New files added in updates won't be present if you only use mod files
- File structure reorganizations between major versions break relative paths

---

## General Version Migration Tips

When updating Traktor and re-applying your QML mods:

### Before Updating

1. **Backup your modded `qml/` folder** outside the Traktor directory
2. **Document your changes** — keep a list of which files you modified and why
3. **Use Git** to track your modifications (see [README.md](README.md#use-git-for-version-control-recommended))

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

| Version | Added | Changed/Removed |
| ------- | ----- | --------------- |
| TP4 (4.x) | `app.traktor.decks.X.load_secondary.selected`, `app.traktor.decks.X.load_track.selected`, `app.traktor.decks.X.load_stems.selected` | - |
| TP4 (4.x) | `ButtonGestures` module (native gesture detection) | - |
| 3.5+ | - | `followFluxPosition` broken on WaveformTranslator ([Fix 1](#fix-1-flux-marker-not-appearing-on-hardware-screens)) |

---

**Have a fix for a version-specific issue?** Add it to this file following the format above: Problem, Affected versions, Fix, and Explanation.
