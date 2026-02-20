# Frequently Asked Questions (FAQ)

**Purpose**: Answers to common questions about QML modding, safety, compatibility, and workflow
**Use when**: You have a question about how QML works, what's safe to change, or what happens after updates

---

## General Safety & Capabilities

### Can I break my controller?

You generally can't "brick" hardware via QML edits. The typical failure mode is software-side:

- Traktor UI fails to load a screen/module
- A controller page looks wrong
- Traktor becomes unstable until you restore a backup

That's why backup/restore is the core safety net. See [01_BASICS.md](01_BASICS.md#install--backup--restore-the-safe-workflow).

### Do I need programming experience?

Not for many useful mods.

- **Safe beginner edits**: Adjusting a timer interval, swapping two wires behind a Shift condition, changing layout text, toggling `visible:` conditions.
- **Harder edits**: Building new logic systems, multi-gesture state machines, large UI redesigns.

Start with beginner edits and the examples in [03_PRACTICAL_EXAMPLES.md](03_PRACTICAL_EXAMPLES.md). Most musicians can make useful customizations without deep programming skills.

---

## Mods & Installation

### What's the difference between a "mod" and an "overlay"?

- **Mod**: A complete or partial set of changes to the QML folder.
- **Overlay**: A mod packaged as _only the files it changes_, designed to be copied on top of a standard QML folder without replacing the entire folder. Overlays are safer because they don't accidentally delete files the mod didn't intend to change.

Most community mods are shared as overlays. See [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) for details on how overlays work and how to create them.

### Can I use community mods from the forums, or only what's in this repo?

You can use community mods from anywhere—this repo is just documentation. However:

- Community mods may be outdated or broken after Traktor updates.
- **Always back up before installing any mod** (see [01_BASICS.md](01_BASICS.md#install--backup--restore-the-safe-workflow)).
- If a mod doesn't work, use the troubleshooting guide in [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) to debug it.
- This documentation will help you understand how mods work so you can adapt or fix them yourself.

### What happens if two mods try to change the same file?

They conflict. QML files are text—if two mods edit the same lines, you can't easily apply both.

**Solution**: You'll need to manually merge the changes (combine both edits into one file). This is beyond beginner scope, but [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) and [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) have guidance.

---

## Updates & Backup

### Why did my mod disappear after updating Traktor?

Traktor updates can replace the entire `qml` folder with stock files. But Native Access automatically creates a backup of the previous Traktor install, which can help restore your setup after an update.

### Can I undo changes?

Yes: restore your `qml` backup and restart Traktor. For detailed instructions, see [01_BASICS.md](01_BASICS.md#install--backup--restore-the-safe-workflow).

---

## Version Compatibility

### What Traktor versions are supported?

See [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md#version-compatibility-matrix) for a detailed matrix of which versions are stable, which have breaking changes, and which mods are confirmed working.

**Key takeaway**: Versions 3.5–3.7 are the most battle-tested for community mods. Moving to 3.8+, 3.9, or 4.x may require significant rework.

### My mod broke after a Traktor update—what do I do?

1. Check [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md) for known issues and fixes in your Traktor version.
2. If your Traktor version isn't listed, use [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) to debug the issue.
3. Compare your mod against examples in [03_PRACTICAL_EXAMPLES.md](03_PRACTICAL_EXAMPLES.md) to see if the syntax changed.

---

## Getting Help

### Where do I find examples or inspiration?

For common questions about installation, safety, etc.), see: [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)

- Debugging/testing checklists: [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)
- Version-specific gotchas: [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)

### Something isn't working—where do I start?

1. Check the **debugging checklist**: [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md#debugging-checklist)
2. Look for **syntax errors** (missing `}`, `,`, quotes)
3. Verify you edited the **correct file** for your controller model
4. **Restore your backup** if Traktor becomes unstable
5. Compare against a **working example** in [03_PRACTICAL_EXAMPLES.md](03_PRACTICAL_EXAMPLES.md)

### How do I share my mods with others?

See [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md#the-safest-packaging-style-an-overlay). The recommended approach is to package your changes as an overlay (only the files you modified) with clear install/restore instructions.

---

## Glossary & Terminology

For glossary definitions, see [07_GLOSSARY.md](07_GLOSSARY.md).

---

**Next:** [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)
