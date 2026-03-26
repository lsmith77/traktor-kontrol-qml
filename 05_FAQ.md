# Frequently Asked Questions (FAQ)

**Purpose**: Answers to common questions about QML modding, safety, compatibility, and workflow
**Use when**: You have a question about how QML works, what's safe to change, or what happens after updates

---

🧭 **Navigation** — ← [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) | **You are here** | → [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md) | 📖 [Troubleshooting: 04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)

---

## General Safety & Capabilities

### Can I break my controller?

You generally can't damage the hardware by editing controller files. The typical issue is software-related:

- Traktor can't load a menu or control panel
- A controller screen displays incorrectly
- Traktor becomes unstable until you restore a backup

That's why backup/restore is the core safety net. **Use the `traktor-mod` script to restore in one command** — see [Chapter 01: Install / Backup / Restore](01_BASICS.md#install--backup--restore-the-safe-workflow) for setup and all available modes.

### Do I need programming experience?

Not for many useful mods.

- **Safe beginner edits**: Adjusting timing, remapping where buttons send data, changing text labels, toggling visibility.
- **Challenging edits**: Building new interaction sequences, complex multi-touch combinations, major screen redesigns.

Start with beginner edits and the working examples in the **[X1MK3 Performance Mod](https://github.com/lsmith77/X1MK3_PerformanceMod)** (see [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md)).

### Can I access browser/playlist data (track names, current selection)?

**Short answer**: Yes — but only from the Screens layer, and only on controllers that have displays.

The **AppProperty API** does not expose browser item selection (`list_selected_item` etc. return `undefined`). However, `Traktor.Gui 1.0` (available only in the `Screens/` QML folder) provides a native `Traktor.Browser` component that gives full access to:

- ✅ Current browser path (`currentPath`)
- ✅ Selected row index (`currentIndex`)
- ✅ Full item data (track name, artist, BPM, key, rating, etc.) via `dataSet` model
- ✅ Whether a content list (tracks) or folder list is showing (`isContentList`)
- ❌ Not accessible in the CSI layer or from screen-less controllers (X1, Z1, F1, etc.)

The `traktor-logger` package's `logger api` command injects an `ApiBrowser` monitor into your controller's Screen.qml that uses this to stream live browser state to the dashboard.

**Credit**: The Screens-layer reverse engineering that made this possible was pioneered by [DJMirror](https://www.patreon.com/cw/DjMirrorTraktor/home).

**For full details**: See [04_TROUBLESHOOTING.md — Accessing Browser/Playlist Data](04_TROUBLESHOOTING.md#issue-accessing-browserplaylist-data).

---

## Mods & Installation

### What's the difference between a "mod" and an "overlay mod"?

These terms describe the **same thing** viewed from different angles:

- **Mod**: Any QML customization you make—it could be a single file change or many files combined.
- **Overlay Mod**: How a mod is _packaged_ for sharing—as only the files it changes, designed to install on top of your existing QML without replacing anything else. This approach is safer because you only get the changes the author made, nothing extra.
- **Overlay Install**: The process of merging an overlay mod into your current QML using the `traktor-mod` script (default `stack mode`).

Example: If you make changes to 3 files and package them as an overlay mod, another user can install them (via overlay install) on top of their own setup, and all their other files stay intact.

Most community mods are shared as overlay mods. See [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) for details on packaging and installation.

### Can I use community mods from the forums, or only what's in this repo?

However:

- Community customizations may stop working after Traktor updates.
- **Always back up before installing any mod** (see [Chapter 01: Install / Backup / Restore](01_BASICS.md#install--backup--restore-the-safe-workflow)).
- If a mod doesn't work, use the troubleshooting guide in [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) to debug it.
- This documentation will help you understand how mods work so you can adapt or fix them yourself.

### What happens if two mods try to change the same file?

They conflict. QML files are text—if two mods edit the same lines, you can't easily apply both.

**Solution**: You'll need to manually merge the changes (combine both edits into one file). This is beyond beginner scope, but [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) and [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) have guidance.

---

## Updates & Backup

### Why did my mod disappear after updating Traktor?

Traktor updates reset your custom changes to factory defaults. But Native Access automatically creates a backup of your previous setup, which you can restore if needed.

### Can I undo changes?

Yes: **use `traktor-mod restore`** to reset to stock QML in one command. See [Chapter 01: Install / Backup / Restore](01_BASICS.md#install--backup--restore-the-safe-workflow) for detailed instructions.

---

## Version Compatibility

### What Traktor versions are supported?

See [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md#version-compatibility-matrix) for a detailed matrix of which versions are stable, which have breaking changes, and which mods are confirmed working.

**Key takeaway**: Versions 3.5–3.7 are the most battle-tested for community mods. Moving to 3.8+, 3.9, or 4.x may require significant rework.

### My mod broke after a Traktor update—what do I do?

1. Check [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md) for known issues and fixes in your Traktor version.
2. If your Traktor version isn't listed, use [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) to debug the issue.
3. Compare your mod against working examples in [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) (like the X1MK3 mod) to see if the syntax changed.

### Why did my controller stop lighting up after I added a Timer or other standard component?

You are likely missing a `QtQuick` import. Some standard QML components (like `Timer`) require explicit imports that might not be present in the stock Traktor QML files. If you add a `Timer` to a file without importing `QtQuick`, the file will fail to load silently, and the controller will not initialize.

**Solution**: Always ensure you have the necessary imports at the top of your file when adding new QML components:

```qml
import QtQuick 2.0
```

---

## Getting Help

### Where do I find examples or inspiration?

Check these resources for common questions:

- Installation, safety, configuration: [01_BASICS.md](01_BASICS.md)
- Debugging/testing checklists: [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)
- Version-specific gotchas: [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)

### Something isn't working—where do I start?

1. Check the **debugging checklist**: [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md#debugging-checklist)
2. Look for **syntax errors** (missing `}`, `,`, quotes)
3. Verify you edited the **correct file** for your controller model
4. **Restore your backup** if Traktor becomes unstable
5. Compare against a **working example** in [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md)

### How do I share my mods with others?

See [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md#the-safest-packaging-style-an-overlay). The recommended approach is to package your changes as a customization add-on (only the files you modified) with clear install/restore instructions.

---

## Glossary & Terminology

For glossary definitions, see [07_GLOSSARY.md](07_GLOSSARY.md).

---

**Next:** [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)
