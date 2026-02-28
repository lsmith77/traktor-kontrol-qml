# Frequently Asked Questions (FAQ)

**Purpose**: Answers to common questions about QML modding, safety, compatibility, and workflow
**Use when**: You have a question about how QML works, what's safe to change, or what happens after updates

---

## General Safety & Capabilities

### Can I break my controller?

You generally can't damage the hardware by editing controller files. The typical issue is software-related:

- Traktor can't load a menu or control panel
- A controller screen displays incorrectly
- Traktor becomes unstable until you restore a backup

That's why backup/restore is the core safety net. See [01_BASICS.md](01_BASICS.md#install--backup--restore-the-safe-workflow).

### Do I need programming experience?

Not for many useful mods.

- **Safe beginner edits**: Adjusting timing, remapping where buttons send data, changing text labels, toggling visibility.
- **Challenging edits**: Building new interaction sequences, complex multi-touch combinations, major screen redesigns.

Start with beginner edits and the working examples in the **[X1MK3 Performance Mod](https://github.com/lsmith77/X1MK3_PerformanceMod)** (see [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md)). Most musicians can make useful customizations without deep programming skills.

---

## Mods & Installation

### What's the difference between a "mod" and an "overlay"?

- **Mod**: A customization or collection of changes to your controller setup.
- **Customization Package** (overlay): A mod packaged as _only the files it changes_, designed to be installed on top of your standard controller files without replacing everything. This approach is safer because it doesn't accidentally remove files the customization didn't intend to touch.

Most community customizations are shared as add-on packages. See [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) for details on how to package and install them.

### Can I use community mods from the forums, or only what's in this repo?

You can use community mods from anywhere—this repo is just documentation. However:

- Community customizations may stop working after Traktor updates.
- **Always back up before installing any mod** (see [01_BASICS.md](01_BASICS.md#install--backup--restore-the-safe-workflow)).
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

Yes: restore your `qml` backup and restart Traktor. For detailed instructions, see [01_BASICS.md](01_BASICS.md#install--backup--restore-the-safe-workflow).

---

## Version Compatibility

### What Traktor versions are supported?

See [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md#version-compatibility-matrix) for a detailed matrix of which versions are stable, which have breaking changes, and which mods are confirmed working.

**Key takeaway**: Versions 3.5–3.7 are the most battle-tested for community mods. Moving to 3.8+, 3.9, or 4.x may require significant rework.

### My mod broke after a Traktor update—what do I do?

1. Check [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md) for known issues and fixes in your Traktor version.
2. If your Traktor version isn't listed, use [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) to debug the issue.
3. Compare your mod against working examples in [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) (like the X1MK3 mod) to see if the syntax changed.

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
