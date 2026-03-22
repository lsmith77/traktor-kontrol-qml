# Sharing your changes (basics)

**Purpose**: Minimal guide for packaging and sharing QML mods as overlays or patches
**Use when**: You've made a working mod and want to share it with others—perhaps you prefer how you've organized the interface, fixed a layout bug, or created a theme the community loves

---

🧭 **Navigation** — ← [07_GLOSSARY.md](07_GLOSSARY.md) | **You are here** | → [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) | 📖 [Backup/Restore: 01_BASICS.md](01_BASICS.md)

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

## Required mod directory structure

**All mods must have a `qml/` folder at the root**, regardless of scope:

- **Overlay Mod** (recommended — only changed files):

  ```
  MyMod-S4MK3/
  ├── qml/
  │   ├── Defines/
  │   │   └── FooterPage.qml        ← only the files you changed
  │   └── Screens/
  │       └── S4MK3/
  │           └── TestScreen.qml    ← only the files you changed
  └── README.md
  ```

- **Full Replacement Mod** (complete copy with all directories):
  ```
  MyMod-Complete-S4MK3/
  ├── qml/
  │   ├── CSI/                       ← full CSI directory
  │   ├── Screens/                   ← full Screens directory
  │   └── Defines/                   ← full Defines directory
  └── README.md
  ```

The `qml/` folder is the installation target. For **overlay mods**, its contents are merged into Traktor's `qml/` folder. For **full replacement mods**, it completely replaces Traktor's `qml/` folder. This structure gives installation scripts a clear, predictable entry point.

**Note:** The `traktor-mod` script validates this structure automatically. If you try to install a mod without a `qml/` folder, it will show an error message with the exact path it was looking for, helping you fix the structure.

## Platform-specific notes

### Windows script status

> ⚠️ **Windows users**: The `traktor-mod.bat` script is **not yet tested**. Please test it carefully and report any issues at [github.com/lsmith77/traktor-kontrol-qml/issues](https://github.com/lsmith77/traktor-kontrol-qml/issues). Your feedback helps make this tool reliable for everyone.

### macOS/Linux

The `traktor-mod.sh` script is actively maintained and used in production.

---

## Two packaging styles: overlays vs. full replacements

### Overlay Mods (Recommended for Most Use Cases)

Most mods should be shared as **overlay mods**—packaged with only the files you changed, designed to install on top of existing QML. See the **[X1MK3 Performance Mod](https://github.com/lsmith77/X1MK3_PerformanceMod)** for a reference implementation of a well-documented overlay mod.

**How it works:**

- Take your modified `qml` folder
- Extract only the files you actually edited
- Organize them exactly as they appear in Traktor's folder structure
- Share those files (in a zip) with install instructions using `traktor-mod` (default stack mode)

**Why use overlay mods:** If someone has their own customizations, installing your overlay mod means their files stay intact. Only the files you changed get updated. Users can combine multiple overlay mods without losing previous customizations.

**Combining Multiple Overlay Mods:**

```bash
traktor-mod  # Apply overlay mod 1 (stack mode)
# Restart and test
traktor-mod  # Apply overlay mod 2 on top (stack mode)
# Both mods are now active together — as long as they don't edit the same files
```

**Do not use `--fresh` when combining overlay mods** — it will reset to stock and erase the first mod. Use stack mode (the default) only.

### Full replacement mods (for standalone complete mods)

If your mod is a **complete, standalone redesign** (not meant to combine with other mods), package it as a full replacement mod.

**How it works:**

- Include the entire `qml` folder structure (CSI, Screens, Defines, etc.)
- Distribute with installation instructions using `traktor-mod --full`
- Users run `traktor-mod --full` to completely replace their `qml`
- Other installed mods are overwritten

**When to use full replacement:** Your mod is self-contained and provides a complete interface redesign. Users expect it to replace everything, not combine with existing mods.

**Important:** Clearly communicate that this is a complete replacement in your README and installation instructions.

## Testing your overlay mod

An overlay mod (one that only contains the files it changes, not the full `qml` folder) cannot be dropped directly into Traktor — it needs to be **merged** into the existing `qml` folder first. This extra step is easy to forget during iteration.

The `traktor-mod.sh` / `traktor-mod.bat` scripts solve this: install them once to your system PATH, then from any mod repo directory, run the command—it finds the `qml` folder in your current working directory and handles backup + merge + launch.

### Setup: Install script to system PATH (one-time setup)

Clone the handbook repo to a central location, then create symlinks in your PATH:

**macOS:**

```bash
# Clone the handbook repo (if you haven't already)
git clone https://github.com/lsmith77/traktor-kontrol-qml ~/traktor-kontrol-qml

# Make the script executable
chmod +x ~/traktor-kontrol-qml/scripts/traktor-mod.sh

# Create a symlink in /usr/local/bin (or another PATH directory)
# The $HOME variable expands to your absolute home directory path
sudo ln -s "$HOME/traktor-kontrol-qml/scripts/traktor-mod.sh" /usr/local/bin/traktor-mod

# Or use a user-local directory (no sudo needed)
mkdir -p ~/.local/bin
ln -s "$HOME/traktor-kontrol-qml/scripts/traktor-mod.sh" ~/.local/bin/traktor-mod
# Then add ~/.local/bin to your PATH if not already there:
# echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

**Windows:**

```bat
:: Clone the handbook repo (if you haven't already)
git clone https://github.com/lsmith77/traktor-kontrol-qml C:\traktor-kontrol-qml

:: Create a symlink in a PATH directory (requires admin PowerShell)
New-Item -ItemType SymbolicLink -Path "C:\Windows\System32\traktor-mod.bat" -Target "C:\traktor-kontrol-qml\scripts\traktor-mod.bat"

:: Or use a custom directory and add it to PATH (no admin needed for the symlink)
New-Item -ItemType Directory -Path "C:\Traktor\Scripts" -Force
New-Item -ItemType SymbolicLink -Path "C:\Traktor\Scripts\traktor-mod.bat" -Target "C:\traktor-kontrol-qml\scripts\traktor-mod.bat"
:: Then add C:\Traktor\Scripts to your PATH via System Properties > Environment Variables
```

**Keeping the script up to date:**

Since the symlink points back to your cloned repo, just pull updates:

```bash
cd ~/traktor-kontrol-qml
git pull
```

The next time you run `traktor-mod`, you'll automatically get the latest version.

### macOS: traktor-mod

Your mod repo now only needs the `qml` folder—no script needed:

```
my-mod/
├── qml/
│   └── CSI/D2/D2.qml        ← only the files you changed
└── README.md
```

**First time setup** (one-off):

The script is already installed in your PATH, so no additional setup needed. Just navigate to your mod directory and run:

```bash
cd my-mod
traktor-mod
```

**Install / test cycle:**

From your mod directory, use any of these modes:

```bash
# OVERLAY MODES (default — merge with existing qml) —————
# stack mode: merge mod on top of whatever is currently installed
traktor-mod

# fresh mode: reset to stock first, then merge only this mod
traktor-mod --fresh

# symlink mode: symlink mod files into live qml (dev mode — edit & restart, no reinstall)
traktor-mod --symlink

# fresh + symlink: reset to stock, then symlink only this mod (isolated dev environment)
traktor-mod --fresh --symlink

# FULL REPLACEMENT MODES (—full flag — replace entire qml) —————
# full replacement: replace entire qml with this complete mod
traktor-mod --full

# full replacement + symlink: replace entire qml and symlink it (dev mode for complete mods)
traktor-mod --full --symlink

# full replacement + fresh: reset to stock first, then replace with this mod
traktor-mod --full --fresh

# full replacement + fresh + symlink: reset to stock, then symlink complete mod (isolated full replacement dev)
traktor-mod --full --fresh --symlink

# RESTORE —————
# undo all mods — restore stock qml
traktor-mod restore
```

**Stack mode** (default overlay): copies overlay mod files into the current live qml. Other installed mods remain. Use this when combining multiple mods.

**Fresh mode** (`--fresh`): resets qml to stock first, then applies only this mod. Use this when you want a clean "stock + this mod only" state.

**Symlink mode** (`--symlink`): instead of copying files, creates symlinks in Traktor's qml pointing back to the files in your mod repo. Edit a file in your repo and restart Traktor — the change is live without running the script again. Useful during active development. Combine with `--fresh` for a fully isolated dev environment. Also works with `--full` to symlink complete mods. Note: symlinks use absolute paths; if you move the repo, run the script again to re-create them.

**Full replacement mode** (`--full`): completely replaces Traktor's entire `qml` folder with your mod's complete `qml`. Use only for standalone complete mods that are not meant to combine with other mods. Combine with `--fresh` to ensure a clean replacement. Combine with `--symlink` to symlink the complete mod instead of copying (useful for full-mod development). **Warning:** Other installed mods will be overwritten.

**Restore**: replaces the live qml with the stock backup, removing all mods and symlinks at once.

> **How the backup works:** The stock backup is created on first install and never overwritten — it always reflects unmodified Traktor files. `restore` removes everything back to stock in one step (no "undo just this mod"). After `restore`, the backup is removed, so the next install creates a fresh one from the now-stock qml.

### Windows: traktor-mod.bat

Your mod repo only needs the `qml` folder:

```
my-mod/
├── qml/
│   └── CSI/...
└── README.md
```

From your mod directory, use the following modes in Command Prompt or PowerShell:

```bat
rem OVERLAY MODES (default — merge with existing qml) —————
rem stack mode — merge mod on top of current live qml
traktor-mod

rem fresh mode — reset to stock first, then merge only this mod
traktor-mod /fresh

rem symlink mode — symlink mod files into live qml (dev mode)
traktor-mod /symlink

rem fresh + symlink — reset to stock, then symlink only this mod
traktor-mod /fresh /symlink

rem FULL REPLACEMENT MODES (/full flag — replace entire qml) —————
rem full replacement: replace entire qml with this complete mod
traktor-mod /full

rem full replacement + symlink: replace entire qml and symlink it (dev mode for complete mods)
traktor-mod /full /symlink

rem full replacement + fresh: reset to stock first, then replace with this mod
traktor-mod /full /fresh

rem full replacement + fresh + symlink: reset to stock, then symlink complete mod (isolated full replacement dev)
traktor-mod /full /fresh /symlink

rem RESTORE —————
rem undo all mods — restore stock qml
traktor-mod restore
```

The script auto-elevates to admin via UAC, creates a stock backup on first install, and uses `robocopy` for merging/copying. Symlink mode creates directory junctions for complete mods or individual file symlinks for overlays. Behaviour is identical to the macOS script.

### Manual installation

> ⚠️ **`traktor-mod.bat` is not yet fully tested on Windows.** If it works for you, great — please [let us know](https://github.com/lsmith77/traktor-kontrol-qml/issues). If it fails, the manual guide below covers every step the script performs, including logger and metadata setup. Your feedback (even just "it worked on Windows 11") helps make the script reliable for everyone.

Full step-by-step instructions — backup, overlay/fresh/full install, restore from GitHub, logger, metadata API, and how to report issues or fix the script yourself with AI:

**→ [scripts/manual-install.md](scripts/manual-install.md)**

---

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
   └── README.md
   ```
5. **Zip it:** Right-click the folder and select "Compress" (macOS) or "Send to > Compressed (zipped) folder" (Windows).

**Create a README file** (plain text) with the following info. Choose the template based on your mod type:

**Option A: Overlay Mod (recommended)**

```
MyMod Overlay for S4MK3
Tested with: Traktor Pro 4.4.1

INSTALL:
1. Backup your current qml folder (see 01_BASICS.md for how)
2. Extract this zip into a directory
3. From that directory, run:
   traktor-mod
   (If you don't have it installed, see 08_SHARING_CHANGES.md for setup)
4. Restart Traktor

WHAT CHANGED:
- Edited Defines/FooterPage.qml to recolor the footer
- Edited Screens/S4MK3/TestScreen.qml to adjust button spacing

COMBINE WITH OTHER MODS:
Yes! This overlay mod can be installed on top of or alongside other overlay mods,
as long as they don't modify any of the same files.

IMPORTANT: Do NOT use --fresh when combining mods. Using --fresh will reset qml to stock before applying, which removes any previously installed mods.

Run the install script from each mod's directory in sequence (stack mode only):
   traktor-mod           # Apply this mod
   # Restart and test
   traktor-mod -s ../other-mod  # Apply another mod on top
If two mods modify the same file, the later install will overwrite the earlier one.

RESTORE:
To remove all mods at once, run:
   traktor-mod restore
(This restores stock qml and removes all mods)
Then restart Traktor
```

**Option B: Full Replacement Mod** (if your mod is a complete standalone redesign)

```
MyMod Complete Edition for S4MK3
Tested with: Traktor Pro 4.4.1

⚠️ WARNING: This is a COMPLETE MOD replacement, not an overlay.
Installing this will replace your entire qml folder. Other mods will be overwritten.

INSTALL:
1. Backup your current qml folder (see 01_BASICS.md for how)
2. Extract this zip into a directory
3. From that directory, run:
   traktor-mod --full
   (If you don't have it installed, see 08_SHARING_CHANGES.md for setup)
4. Restart Traktor

WHAT'S INCLUDED:
This mod provides a complete interface redesign:
- Full CSI remapping for custom control flow
- Complete screen redesign across all layouts
- New color scheme and visual hierarchy

COMBINE WITH OTHER MODS:
No. This replaces the entire qml. If you want to combine with other mods,
use the overlay version instead (or ask the mod creator for an overlay version).

RESTORE:
To restore your previous qml, run:
   traktor-mod restore
Then restart Traktor
```

Include this README in your zip file.

### Option B: Use Git (for ongoing projects—optional)

**When to use this:** If you plan to improve your mod over time and want to track all your changes, or if you want to collaborate with others.

**Basic workflow:**

1. Initialize Git in your controller setup folder (one-time setup)
2. Make small, focused edits
3. After each completed change, "save" it with a clear message like: `"Fix: Adjust button spacing in S4MK3 screen"`
4. When ready to share, push to GitHub or send a "change file" that others can apply

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

**If you want to follow this pattern:**

1. Create a GitHub repository for your mod
2. Organize it by feature (similar to X1MK3; separate docs for each major feature)
3. Link features to each other with full GitHub URLs (with commit hash for stability)
4. Create a comprehensive README with dependency hierarchy
5. Start a forum thread to engage the community
6. Use version control saves to document what changed and why

This approach works better than zip files for long-term, community-driven development.

**Always include this with your mod:**

When someone installs your mod, include these steps (assuming they have the installation script installed in their PATH):

**Before installing:**

```
1. Back up your current qml folder (see [01_BASICS.md](01_BASICS.md#install--backup--restore-the-safe-workflow) for details)
2. Extract the zip file into a directory
3. From that directory, run: traktor-mod
4. Restart Traktor
```

**If something doesn't work:**

```
1. Restart Traktor first (often fixes UI glitches)
2. If buttons don't respond or screens look broken, restore your backup:
   traktor-mod restore
   (Close Traktor first, then restart it)
3. Let the mod creator know what went wrong (include your Traktor version and controller model)
```

**For users who don't have the script installed:**

If someone doesn't have `traktor-mod` installed yet, direct them to [the setup instructions above](#setup-install-script-to-system-path-one-time-setup).

---

**Next:** [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md)
