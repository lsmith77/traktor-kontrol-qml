# Windows: Manual Installation Guide

This guide covers everything `traktor-mod.bat` does, step by step, using only File Explorer and a text editor.

> **The script needs testers.** If you run `traktor-mod.bat` and something goes wrong, please report it — see [Reporting issues and fixing the script](#reporting-issues-and-fixing-the-script) at the bottom of this page. Your report helps make the script reliable for everyone.

---

## macOS users

This guide is written for Windows, but the steps translate directly to macOS. Two things to be aware of:

**QML folder location** — on macOS, Traktor's QML folder is inside the application bundle:

`/Applications/Native Instruments/Traktor Pro 4/Traktor Pro 4.app/Contents/Resources/qml`

To open it in Finder, right-click `Traktor Pro 4.app` → **Show Package Contents**, then navigate to `Contents/Resources/qml`.

**Copying files into a folder works differently on macOS** — unlike Windows, dragging a folder onto an existing folder in Finder *replaces* the destination folder entirely rather than merging the contents. To overlay only the mod's files without wiping everything else, use Terminal:

```sh
cp -R /path/to/mod/qml/ "/Applications/Native Instruments/Traktor Pro 4/Traktor Pro 4.app/Contents/Resources/qml/"
```

The trailing slash on the source path is important — it copies the *contents* of the mod's `qml` folder into the destination rather than nesting the folder inside it.

---

## Before you start

Close Traktor Pro 4 before making any changes.

**Find your Traktor QML folder** — open File Explorer and navigate to:

`C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml`

---

## Step 1 — Back up the stock QML folder (first time only)

The scripts use `qml.mod-backup` as the backup folder name
Alternatively you can fetch a backup for recent Traktor Pro version from https://github.com/lsmith77/traktor-kontrol-qml-files

---

## Step 2 — Install the mod

Check [Chapter 03: Community Resources](../03_COMMUNITY_RESOURCES.md) to see whether your mod is an overlay or a full replacement. If it's not listed there, check the mod's README.

For full replacements, just replace the the full `qml` directory. Remember when switching overlay mods, you might want to reset to your backup first unless you explicitly want to layer your overlay mods. But be aware that if overlay mods modify the same file, you might need to merge then manually to not break one of the overlay mods.

Use this when combining multiple mods, or when you want to keep other files intact.

1. Open the mod's `qml\` folder in File Explorer
2. Select all files and folders inside it (Ctrl+A) and Copy them (Ctrl+C)
3. Navigate to `C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml` and Paste (Ctrl+V)
4. When Windows asks what to do with conflicting files, choose **Replace the files in the destination** for each file (or "Do this for all conflicts" if offered)
5. Restart Traktor and verify the mod is active.

> Only the mod's files are overwritten. Files not in the mod are left untouched.

---

## Step 3 — Install the Logger (optional, for debugging)

[traktor-logger](https://github.com/lsmith77/traktor-logger) adds real-time logging and a browser dashboard. To install manually:

1. Download: **https://github.com/lsmith77/traktor-logger/archive/refs/heads/main.zip**
2. Extract the zip — you'll get a folder like `traktor-logger-main\`

Then copy these three things into Traktor's live `qml\` folder:

### Logger.qml

- Source: `traktor-logger-main\qml\Logger.qml`
- Destination: `C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml\Defines\Logger.qml`
- Create the `Defines\` folder if it doesn't exist

Open `...\qml\Defines\qmldir` in Notepad (create the file if it doesn't exist):

- If creating fresh, paste:
  ```
  module Traktor.Defines
  Logger 1.0 Logger.qml
  ```
- If the file already exists but has no line starting with `Logger`, add:
  ```
  Logger 1.0 Logger.qml
  ```

### Api modules

- Source: everything inside `traktor-logger-main\qml\CSI\Common\Api\`
- Destination: `C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml\CSI\Common\Api\`
- Create the `Api\` folder if it doesn't exist

### Screens modules

- Source: everything inside `traktor-logger-main\qml\Screens\Common\`
- Destination: `C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml\Screens\Common\`
- Create the `Common\` folder if it doesn't exist
- Also copy `traktor-logger-main\qml\CSI\Common\Api\ApiClient.js` to `...\qml\Screens\Common\ApiClient.js`

Restart Traktor. The logger is now available via `import Traktor.Defines 1.0` in any QML file.

---

## Step 4 — Enable metadata collection (optional)

Metadata lets the logger automatically report deck state, tempo, channel info, and browser activity. Requires the Api modules from Step 3.

### Enable for one controller (e.g., D2, S8, X1MK3)

Pick one controller that will always be connected. `ApiModule` monitors all decks and channels globally — injecting it into more than one controller causes every event to be reported multiple times.

For the controller you want to use:

1. Open its main QML file in a text editor (Notepad++ recommended):
   `C:\Program Files\Native Instruments\Traktor Pro 4\Resources64\qml\CSI\D2\D2.qml`
   (replace `D2` with your controller name: S4MK3, S8, X1MK3, etc.)

2. Find the block of `import` lines at the top. Add this line immediately after the last import:

   ```qml
   import "../Common/Api"
   ```

   Skip if the file already contains `Common/Api`.

3. Find the `Mapping {` line. Add `ApiModule {}` on the very next line:

   ```qml
   Mapping {
     // Automatic metadata collection
     ApiModule {}
   ```

   Skip if the file already contains `ApiModule`.

4. Save the file.

### Enable browser monitoring

For each `Screen.qml` under `qml\Screens\` (e.g., `Screens\S4MK3\Screen.qml`):

1. Open the file in a text editor.

2. Add an import after the last `import` line. The path is relative — count how many folders deep the file sits below `qml\Screens\`:
   - One folder deep (e.g., `Screens\S4MK3\Screen.qml`): `import "../Common" as LoggerScreens`
   - Two folders deep: `import "../../Common" as LoggerScreens`

3. Find the first `{` after the imports (the root element's opening brace). Add on the next line:

   ```qml
   LoggerScreens.ApiBrowser {}
   ```

   If the file contains `isLeftScreen`, use this instead (only one screen reports browser data):

   ```qml
   LoggerScreens.ApiBrowser { active: isLeftScreen }
   ```

4. Save the file.

Restart Traktor, then open the logger dashboard at `http://localhost:8080`.

---

## Reporting issues and fixing the script

### Report a bug

If `traktor-mod.bat` fails, file an issue at:

**https://github.com/lsmith77/traktor-kontrol-qml/issues**

Include:

- Your Windows version (e.g., Windows 11 22H2)
- Your Traktor Pro 4 version (Traktor → Help → About)
- The exact command you ran
- The full output — copy/paste everything that appeared in the window. If the window closed immediately, run the script from a Command Prompt so the output stays visible:
  1. Press **Win+R**, type `cmd`, press Enter
  2. Drag `traktor-mod.bat` into the Command Prompt window and press Enter
  3. Copy the full output (right-click → Select All, then right-click → Copy)

### Attempt to fix it yourself with AI

`traktor-mod.bat` is a Windows batch script. If you're comfortable with AI tools (Claude, ChatGPT, Copilot), you can paste the script and the error output and ask for a fix:

1. Open `traktor-mod.bat` in a text editor and copy the full contents
2. Run the script from Command Prompt (as above) and copy the full output
3. Paste both into Claude, ChatGPT, or Copilot with a prompt like:

   > Here is a Windows batch script (`traktor-mod.bat`) and the error output I get when I run it. Please identify what's failing and suggest a fix.
   >
   > **Script:**
   > [paste script contents]
   >
   > **Error output:**
   > [paste command prompt output]

The script is intentionally straightforward — it backs up a folder, copies files, and (optionally) creates symlinks. Most failures come down to path detection, permissions, or a missing dependency. A capable AI model can usually diagnose and fix these in one pass.

If you get a working fix, please share it as a pull request or paste it into the GitHub issue — it helps everyone on Windows.
