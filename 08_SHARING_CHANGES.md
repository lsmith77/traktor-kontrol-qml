# Sharing your changes (basics)

**Purpose**: Minimal guide for packaging and sharing QML mods as overlays or patches
**Use when**: You've made a working mod and want to share it with others—perhaps you prefer how you've organized the interface, fixed a layout bug, or created a theme the community loves

> **For mod authors**: If you're creating features you want others to adopt and combine, see [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md) for the documentation-driven approach used by community mods.

This chapter covers the minimal "how to share a mod change with someone else" guide.

If you want advanced workflows (branches, PRs, clean history, release tags), follow a Git tutorial.

## What to share (the essentials)

Include all of this information so people know if your mod will work for them:

- **Traktor version you tested with** (e.g., TP 4.4.1) — Mods may break on different versions
- **Controller/gear model** (e.g., S4MK3, D2, X1MK3) — Your layout changes are specific to each model
- **List of files you changed** (e.g., "modified Defines/FooterPage.qml and edited one screen") — So people know the scope
- **What changed and why** (e.g., "Recolored footer to match my theme; adjusted padding on buttons to improve spacing") — Helps people decide if this is useful for them
- **(Optional) Links to feature documentation** — Link to detailed docs like in the [X1MK3 Performance Mod](03_COMMUNITY_RESOURCES.md) if your changes are substantial

## The safest packaging style: an overlay

Most mods should be shared as a **customization package**, not a complete `qml` folder replacement. See the **[X1MK3 Performance Mod](https://github.com/lsmith77/X1MK3_PerformanceMod)** for a reference implementation of a well-documented, feature-complete mod.

**How it works:**

- Take your modified `qml` folder
- Extract only the files you actually edited
- Organize them exactly as they appear in Traktor's folder structure
- Share those files (in a zip) with clear install instructions like: "Copy these files over your current `qml` folder and restart Traktor"

**Why this matters:** If someone has their own customizations, installing your package means their files stay intact. Only the ones you changed get updated.

**macOS reminder:** When copying folders in Finder, it will ask "Merge" or "Replace." You want **Merge**—this installs your changes without erasing anything else. See the section on [merging folders](01_BASICS.md#install--backup--restore-the-safe-workflow) in [01_BASICS.md](01_BASICS.md) for a visual walkthrough.

## How to capture your changes (two common options)

### Option A: Zip the changed files (safest—no version control needed)

**Step-by-step:**

1. **Start with a clean base:** Take a fresh copy of your Traktor's stock `qml` folder (the one in Traktor's installation directory).
2. **Apply your edits:** Make your changes to this copy.
3. **Identify what you changed:** Open Finder/Explorer and look for just the files you edited. For example:
   - `qml/Defines/FooterPage.qml`
   - `qml/Screens/S4MK3/TestScreen.qml`
4. **Recreate the folder structure:** Create a new folder called (for example) `MyMod-TraktorS4MK3`. Inside it, recreate the exact same folder structure as in the original. Paste only your changed files. Your final structure should look like:
   ```
   MyMod-TraktorS4MK3/
   ├── qml/
   │   ├── Defines/
   │   │   └── FooterPage.qml
   │   └── Screens/
   │       └── S4MK3/
   │           └── TestScreen.qml
   └── README.txt
   ```
5. **Zip it:** Right-click the folder and select "Compress" (macOS) or "Send to > Compressed (zipped) folder" (Windows).

**Create a README file** (plain text) with the following info:

```
MyMod for S4MK3
Tested with: Traktor Pro 4.4.1

INSTALL:
1. Backup your current qml folder (see 01_BASICS.md for how)
2. Extract this zip
3. Copy the contents of the 'qml' folder over your Traktor qml folder
   - macOS: Choose "Merge" when Finder asks
4. Restart Traktor

WHAT CHANGED:
- Edited Defines/FooterPage.qml to recolor the footer
- Edited Screens/S4MK3/TestScreen.qml to adjust button spacing

RESTORE:
- Delete the modified files or restore your backup (see 01_BASICS.md)
- Restart Traktor
```

Include this README in your zip file.

### Option B: Use Git (for ongoing projects—optional)

**When to use this:** If you plan to improve your mod over time and want to track all your changes, or if you want to collaborate with others.

Think of Git like **version history in your DAW**—every time you make changes, you record what changed and why. Later, you (or someone else) can see the full timeline of edits and even undo changes if needed.

**Basic workflow:**

1. Initialize Git in your controller setup folder (one-time setup)
2. Make small, focused edits
3. After each completed change, "save" it with a clear message like: `"Fix: Adjust button spacing in S4MK3 screen"`
4. When ready to share, push to GitHub or send a "change file" that others can apply

**Don't worry if this is new.** Start with Option A (zip) until you're comfortable. Git is optional.

**Learn more (if curious):**

- Git Mastery (beginner-friendly interactive guide): https://www.gitmastery.me
- Git basics: https://git-scm.com/book/en/v2
- GitHub quick start: https://docs.github.com/en/get-started

---

## Next: Create Shareable Features for Community

Once you've packaged a working mod, you might want to document and publish it so others can apply individual features independently.

For that workflow, see [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md), which covers:

- How to document a feature so non-programmers can understand it
- Feature template with before/after code blocks
- Testing checklists and compatibility documentation
- Centralized settings patterns
- AI-assisted code generation workflows
- Real examples from the X1MK3 Performance Mod

Chapter 09 is the professional standard for features that go into community mod repositories.

## Real-world example: How X1MK3 Performance Mod shares changes

The **X1MK3 Performance Mod** is a professional example of how to structure and share a complete mod system:

**What makes it effective:**

✅ **Each feature has its own documentation file** (X1_infrastructure.md, X1_tempo-control.md, etc.)  
✅ **Features link to each other** with canonical GitHub URLs (not relative paths)  
✅ **README.md explains the entire mod** with dependency hierarchy  
✅ **Hosted on GitHub** with clear commit history  
✅ **Community forum discussion** alongside the GitHub repo  
✅ **Version tracking** (Traktor 4.4.1 clearly stated)

**Resources:**

- **GitHub Repository**: https://github.com/lsmith77/X1MK3_PerformanceMod
- **Main Thread**: https://community.native-instruments.com/discussion/17167/x1mk3-community-performance-mod-qml-coding
- **Installation Instructions**: In GitHub README

**Why this pattern works:**

- Users can clone the entire mod or just study individual features
- Git history shows feature evolution and debugging
- Community forum provides real-world support and feedback
- Cross-links make it easy to understand feature dependencies
- GitHub provides automatic backup and change history

**If you want to follow this pattern:**

1. Create a GitHub repository for your mod
2. Organize it by feature (similar to X1MK3; separate docs for each major feature)
3. Link features to each other with full GitHub URLs (with commit hash for stability)
4. Create a comprehensive README with dependency hierarchy
5. Start a forum thread to engage the community
6. Use version control saves to document what changed and why

This approach works better than zip files for long-term, community-driven development.

**Always include this with your mod:**

When someone installs your mod, include these steps:

**Before installing:**

```
1. Back up your current qml folder (see [01_BASICS.md](01_BASICS.md#install--backup--restore-the-safe-workflow) for details)
2. Extract the zip file
3. Copy the files over your qml folder and restart Traktor
```

**If something doesn't work:**

```
1. Restart Traktor first (often fixes UI glitches)
2. If buttons don't respond or screens look broken, restore your backup:
   - Close Traktor
   - Delete or rename your current qml folder
   - Move your backup back in place
   - Restart Traktor
3. Let the mod creator know what went wrong (include your Traktor version and controller model)
```

This takes 30 seconds but prevents frustration.
