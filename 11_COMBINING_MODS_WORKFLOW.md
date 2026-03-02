# Chapter 11: Combining Mods — Complete Workflow

**Purpose**: Step-by-step guide for combining multiple Traktor QML mods and deploying to your controller.

**Chapter**: 11 of the Traktor QML Handbook  
**Handbook Version**: v0.4.0  
**Date**: 1 March 2026

**Use this chapter when**: You want to combine multiple mods from different authors into a single unified QML setup.

**Quick Navigation**:

- [Phase 1: Preparation (Read Only)](#phase-1-preparation-read-only--no-tools-needed)
- [Phase 2: AI Generation (Prompt → Output)](#phase-2-ai-generation-prompt--output)
- [Phase 3: Save & Deploy (Create Local Directory)](#phase-3-save--deploy-create-local-directory)
- [Phase 4: Deploy to Traktor](#phase-4-deploy-to-traktor)

---

## Complete Workflow

### Phase 1: Preparation (Read Only — No Tools Needed)

**1. Read the handbook** (this can be done online, no checkout/download required):

- [Chapter 09: Mod Documentation Guide](https://github.com/lsmith77/traktor-kontrol-qml/blob/main/09_MOD_DOCUMENTATION_GUIDE.md) — Understand versioning, metadata lock files, how to find version info
- This chapter explains the _why_ behind the workflow

**2. Gather mod information** about each mod you want to combine:

- Find version numbers (README badge, GitHub releases, ZIP filename, QML header, forum post date)
- Note sources (GitHub URLs, forum links, local files)
- List which features you're using from each mod
- Record Traktor compatibility and controller support

**→ At this point**: You have information, not code. No tools needed.

---

### Phase 2: AI Generation (Prompt → Output)

**3. Open your AI tool** (Claude, ChatGPT, Copilot):

- Web browser, desktop app, or IDE plugin — your choice
- **No need to download or check out anything** — you're just using an AI chat interface

**4. Get the prompt** from [Chapter 10: Mod Combination Prompt](10_MOD_COMBINATION_PROMPT.md#the-prompt):

- The prompt is self-contained — it doesn't reference files
- Just copy the text block

**5. Paste into your AI tool**:

- Open a new chat
- Paste the prompt template
- Fill in the `[PLACEHOLDERS]` with your mod information (versions, sources, etc.)

**6. Run the prompt**:

- Send to AI
- AI outputs:
  - Directory structure (CSI/, Defines/, Screens/, etc.)
  - Full QML file contents
  - METADATA.md with version tracking
  - Testing checklist

**→ At this point**: You have AI-generated code and directory structure (displayed in chat).

---

### Phase 3: Save & Deploy (Create Local Directory)

**7. Create a new local directory** to hold your custom setup (this is your first time creating a directory):

```bash
# Create directory on your machine
mkdir -p ~/my-traktor-setup/qml
```

**8. Save AI output to this directory**:

- Copy/paste each file from the AI output into your text editor
- Save with correct filenames in correct subdirectories:
  - `~/my-traktor-setup/qml/CSI/X1MK3/X1MK3.qml`
  - `~/my-traktor-setup/qml/Defines/...`
  - `~/my-traktor-setup/qml/METADATA.md`
  - etc.
- Or use the AI to generate file downloads (if your AI tool supports it)

**9. Initialize git** to track changes:

```bash
cd ~/my-traktor-setup
git init
git add .
git commit -m "Initial: Combined mods (D2 v1.2.3 + X1MK3 v0.12.0)"
```

**→ At this point**: You have a local directory with git tracking.

---

### Phase 4: Deploy to Traktor

**10. Backup your existing Traktor QML** (safety first):

- **macOS**: `cp -r ~/Library/Application\ Support/Native\ Instruments/Traktor\ Pro\ 4.4.1/qml ~/Library/Application\ Support/Native\ Instruments/Traktor\ Pro\ 4.4.1/qml.backup`
- **Windows**: `xcopy "%APPDATA%\Native Instruments\Traktor Pro 4.4.1\qml" "%APPDATA%\Native Instruments\Traktor Pro 4.4.1\qml.backup" /E /I`

**11. Copy your custom QML to Traktor**:

- **macOS**: `cp -r ~/my-traktor-setup/qml/* ~/Library/Application\ Support/Native\ Instruments/Traktor\ Pro\ 4.4.1/qml/`
- **Windows**: `xcopy "C:\Users\[YourUsername]\my-traktor-setup\qml\*" "%APPDATA%\Native Instruments\Traktor Pro 4.4.1\qml\" /E /Y`

**12. Test in Traktor Pro**:

- Load Traktor
- Verify controller loads without errors
- Run the testing checklist from METADATA.md

**13. Commit your deployment**:

```bash
cd ~/my-traktor-setup
git commit -m "deployed: all tests passing"
```

**→ At this point**: Your custom QML is live in Traktor Pro.

---

## Quick Reference: File Organization

After AI generates and you save:

```
Your computer home directory:
  ~/my-traktor-setup/
    ├── .git/ (created when you run "git init")
    └── qml/
        ├── CSI/
        │   ├── Common/
        │   ├── S4MK3/
        │   ├── X1MK3/
        │   └── ...
        ├── Defines/
        ├── Screens/
        └── METADATA.md

Traktor Pro installation directory (separate):
  ~/Library/Application Support/Native Instruments/Traktor Pro 4.4.1/qml/
    └── (you copy ~/my-traktor-setup/qml/* here)
```

The handbook? You just read it online — no need to have a copy in ~/my-traktor-setup/.

---

## Updating Later (When Mods Release New Versions)

When a mod you used updates (e.g., D2 v1.2.3 → v1.2.4):

```bash
# 1. See what changed
git diff v1.2.3..v1.2.4

# 2. Decide: Do I need this update?

# 3. If yes: Update your ~/my-traktor-setup/qml/
#    (Use the MOD_COMBINATION_PROMPT again with the new version)

# 4. Commit the change
git commit -m "Update: D2 v1.2.3 -> v1.2.4 (FX routing fix)"

# 5. Copy to Traktor (Step 11 above)

# 6. Test in Traktor (Step 12 above)
```

Your metadata comment in the QML file tracks which versions are installed (update the "Last Updated" date).

---

## Review Your Metadata

After deployment, check (in two places):

- **Top of main controller file** (e.g., `CSI/X1MK3/X1MK3.qml`): Shows what's included
- **METADATA.md file** in the directory root: Full version info + testing checklist

**Why metadata is embedded**: Since metadata describes your specific combination, it lives with the files that implement it. The metadata comment in the main controller file AND the METADATA.md summary ensure you always know exactly what got combined.

---

## For Background Reading

**Want to understand the full system?** See:

- [Chapter 09: Mod Documentation Guide](https://github.com/lsmith77/traktor-kontrol-qml/blob/main/09_MOD_DOCUMENTATION_GUIDE.md) — Understand versioning, metadata lock files, how to find version info, mixing versions
- [Chapter 10: Mod Combination Prompt](10_MOD_COMBINATION_PROMPT.md) — The actual prompt template to use with AI

---

## Related Chapters

- **Chapter 09** — Mod documentation, versioning, metadata patterns
- **Chapter 10** — Mod combination prompt template
- **Chapter 03** — Community resources and featured mods

---

**Last Updated**: 1 March 2026

**Location**: [Root directory of handbook](.)

**Questions?** See Chapter 09 (Mod Documentation Guide)
