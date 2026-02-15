# Sharing your changes (basics)

**Purpose**: Minimal guide for packaging and sharing QML mods as overlays or patches
**Use when**: You've made a working mod and want to share it with others—perhaps you prefer how you've organized the interface, fixed a layout bug, or created a theme the community loves
This is the minimal “how to share a mod change with someone else” guide.

If you want advanced workflows (branches, PRs, clean history, release tags), follow a Git tutorial.

## What to share (the essentials)

Include all of this information so people know if your mod will work for them:

- **Traktor version you tested with** (e.g., TP 4.4.1) — Mods may break on different versions
- **Controller/gear model** (e.g., S4MK3, D2, X1MK3) — Your layout changes are specific to each model
- **List of files you changed** (e.g., "modified Defines/FooterPage.qml and edited one screen") — So people know the scope
- **What changed and why** (e.g., "Recolored footer to match my theme; adjusted padding on buttons to improve spacing") — Helps people decide if this is useful for them

## The safest packaging style: an overlay

Think of an overlay like giving someone a **single edited page from a song arrangement**—not the entire score. You only share the files you changed, so the person receiving them keeps all their other customizations intact.

Most mods should be shared as an **overlay**, not a complete `qml` folder replacement.

**How it works:**

- Take your modified `qml` folder
- Extract only the files you actually edited
- Organize them exactly as they appear in Traktor's folder structure
- Share those files (in a zip) with clear install instructions like: "Copy these files over your current `qml` folder and restart Traktor"

**Why this matters:** If someone has their own customizations, overlaying your changes means their files stay intact. Only the ones you changed get updated.

**macOS reminder:** When copying folders in Finder, it will ask "Merge" or "Replace." You want **Merge**—this overlays your changes without erasing anything else. See the section on [overlaying folders](01_BASICS.md#install--backup--restore-the-safe-workflow) in [01_BASICS.md](01_BASICS.md) for a visual walkthrough.

## How to capture your changes (two common options)

### Option A: Zip the changed files (easiest—no Git required)

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

1. Initialize Git in your `qml` folder (one-time setup)
2. Make small, focused edits
3. After each completed change, "commit" it with a clear message like: `"Fix: Adjust button spacing in S4MK3 screen"`
4. When ready to share, push to GitHub or send a "patch file" that others can apply

**Don't worry if this is new.** Start with Option A (zip) until you're comfortable. Git is optional.

**Learn more (if curious):**

- Git basics: https://git-scm.com/book/en/v2
- GitHub quick start: https://docs.github.com/en/get-started

## Safety first: backup and restore instructions

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
