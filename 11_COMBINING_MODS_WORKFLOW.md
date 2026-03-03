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

Baseline (what this means)

- A "baseline" is the upstream Traktor QML state you are comparing mods against. It can be either:
  - a `traktor-kontrol-qml-files` tag or file tree (recommended for determinism), or
  - a legacy baseline mod directory that contains a full `qml/` tree representing the Traktor version the mod targets.
- Why it matters: using a correct baseline lets you compute exactly what changed so the AI (or you) only focuses on the mod's real changes instead of unrelated upstream differences.

---

### Phase 2: AI Generation (Prompt → Output)

#### Main prompt prerequisites & options

When to use the main Mod Combination Prompt: this is the preferred path when you can provide one baseline (the Traktor QML baseline tag or file tree) plus one or more mods where each mod's features are already described as an author-provided feature list or as small, reviewable feature files. Providing reviewed feature lists makes the AI output deterministic and safe to apply.

Required inputs for the main prompt

- **Baseline**: one of the following:
  - a tag or file tree from `traktor-kontrol-qml-files` (e.g., `tags/4.4.1` or `tags/4.4.2`) — preferred; or
  - a legacy baseline mod directory containing a full `qml/` tree (the upstream QML state the mod targets). If you supply a legacy mod as baseline, include its source/version/date for traceability.
- **Mods**: for each mod give either: (A) a reviewed feature list (bulleted list), or (B) a mod file tree plus a short author feature list. If you only have raw file changes (a single consolidated change list showing exact file changes), run the feature-extraction prompts below first.

When prerequisites are missing

- If you don't have reviewed feature lists from the mod authors, run the feature-extraction prompt (or the single-feature variant) from the [AI Prompt Templates: Feature extraction and feature splitting](11_COMBINING_MODS_WORKFLOW.md#ai-prompt-templates-feature-extraction-and-feature-splitting) section. Review and edit the extracted feature lists, then re-run the main prompt with the reviewed lists.

**3. Open your AI tool** (Claude, ChatGPT, Copilot):

- Web browser, desktop app, or IDE plugin — your choice
- **No need to download or check out anything** — you're just using an AI chat interface

**4. Get the prompt** from [Chapter 10: Mod Combination Prompt](10_MOD_COMBINATION_PROMPT.md#the-prompt):

- The prompt is self-contained — it doesn't reference files
- Just copy the text block

**5. Paste into your AI tool**:

- Open a new chat
- Paste the prompt template

Integration options (includes/excludes/conflict policies): see the `Integration Options` section in [Chapter 10: Mod Combination Prompt](10_MOD_COMBINATION_PROMPT.md#integration-options) for the simple plain-text directives to add under **My Setup**. Keep Chapter 11 concise — the detailed option examples live in Chapter 10.

How to phrase integration instructions in the prompt

- Be explicit: "Include features X,Y; exclude feature Z because it conflicts with baseline feature B." or "Prefer D2 implementation of loop-roll; keep X1MK3 screen behavior from mod B." The main template will use these directives when producing the combined directory and METADATA.

**6. Run the prompt**:

- Send to AI
- AI outputs:
  - Directory structure (CSI/, Defines/, Screens/, etc.)
  - Full QML file contents
  - METADATA.md with version tracking
  - Testing checklist

**→ At this point**: You have AI-generated code and directory structure (displayed in chat).

### Expectation Management — merging large "baseline" mods

- **Realistic effort:** Merging two large, baseline-style mods is often non-trivial. AI can accelerate refactoring and generation, but expect manual work: splitting monolithic files, reconciling behavior, and thorough testing.
- **Recommended first step:** Use AI (or manual refactoring) to separate at least one mod into smaller feature modules (feature-level QML/JS files) before attempting a merge. Smaller units make conflicts visible and easier to resolve.
- **Handling overlapping modifications:** If both mods change the same button/mode/handler, follow a disciplined approach:
  - Extract both implementations into separate feature files so you can compare behavior side-by-side.
  - Decide on a merge strategy: pick one implementation, combine behaviors behind a toggle, or namespace/adapter-wrap one so both can coexist.
  - Prefer preserving metadata and authorship in comments so you can revert or trace choices.
- **Merge process:** Integrate feature modules incrementally (one feature at a time), run Traktor tests after each change, and keep small commits/branches so you can rollback easily.
- **When to stop:** If resolving semantic conflicts would require rewriting large portions of either mod (hundreds of lines or core architecture changes), consider keeping the mods as separate profiles or contacting the authors for guidance.

#### AI Prompt Templates: Feature extraction and feature splitting

Note: If the mod author provides a detailed feature list, use that instead of running extraction — it's the most accurate split source. If not, run the feature-extraction prompt first and review the result, then feed the reviewed feature list into the feature-splitting prompt.

Quick links to prompts (jump to the prompt you need):

- [Feature-extraction prompt](11_COMBINING_MODS_WORKFLOW.md#feature-extraction-prompt)
- [Single-feature extraction variant](11_COMBINING_MODS_WORKFLOW.md#feature-extraction-prompt---single-feature-variant)
- [Feature-splitting prompt](11_COMBINING_MODS_WORKFLOW.md#feature-splitting-prompt)

1. Feature-extraction prompt (use this when no author feature list exists)

##### Feature-extraction prompt

Use this when no author feature list exists. Provide either a consolidated list of file changes (mod vs baseline) or the mod file tree plus the baseline file tree. The AI should return a concise, reviewable feature list for human verification.

Prompt:
"You are an expert Traktor QML analyst. I will provide either (A) a consolidated list of file changes (mod vs baseline) or (B) the mod file tree plus the baseline file tree. Your task: produce a concise, reviewable feature list for human verification.

Output format: bulleted feature list + short human summary:

- Features: for each feature provide an ID, title, one-line description, primary files, UI elements, key handlers/events, global side-effects, and a rough risk (low/med/high).
- Notes: list any ambiguous areas and recommended sample files to inspect.

Baseline info: include baseline tag used (e.g., `traktor-kontrol-qml-files` tag `4.4.1`). Return a concise bulleted list and a 6-line human summary.
"

##### Feature-extraction prompt — single-feature variant

Use this variant when you only need details about one feature. Provide the baseline and either a consolidated list of file changes or the mod file tree, and specify the feature name.

Prompt:
"You are an expert Traktor QML analyst. I will provide a baseline (tag or file tree) and either a consolidated list of file changes or the mod file tree. I only want information about one specific feature: `[FEATURE_NAME]` (e.g., `vinyl break`, `library view in Browse mode`, `screen display in REL mode`).

Tasks:

- Locate files and exact changed lines implementing or affecting `[FEATURE_NAME]`.
- List UI elements, key handlers/events, signals, and any global state affected by this feature.
- Describe dependencies (other features, helper modules) and a short risk rating (low/med/high).
- Produce a 3-step test checklist to verify the feature in Traktor.

Output: bulleted feature details (`id, title, description, primary_files, key_handlers, ui_elements, side_effects, risk`) and `notes`. Return a concise bulleted list and a 4-line human summary.
"

2. Feature-splitting prompt

Use this prompt after you have an author feature list OR a reviewed feature list from step 1.

Prompt:
"You are an expert QML refactoring assistant. Inputs:

- Baseline version: `[TRAKTOR_VERSION]` (baseline repo tag: `traktor-kontrol-qml-files` tags such as `4.4.1` or `4.4.2`).
  -- Reviewed feature list (bulleted list) produced by the previous step or provided by the mod author.

Consolidated change list or modified file tree for the mod.

Tasks (produce short plan + bulleted outputs):

- For each feature in the reviewed feature list: propose a target feature-file path/name and a minimal QML/JS skeleton (component names, signals, bindings), list dependencies, and list exact changed lines/files that the feature covers.
- Identify conflicts with baseline (same handler/button/mode) with severity and recommended merge strategy: `pick-one`, `combine-behavior` (describe how), `toggle`, `namespace/adapter`, or `keep-separate-profile`.
- Produce a commit plan: one commit per feature with commit message template and testing checklist entries.
  -- Output format: bulleted sections: `features`, `conflicts`, `commits`, `tests`, `notes`. Also include a 6-line human summary.

Placeholders:

- `[TRAKTOR_VERSION]` → e.g., `4.4.1`
- Attach the consolidated change list or a list of changed files when invoking.

Practical notes:

- Use the baseline repo tags (e.g., `tags/4.4.1`, `tags/4.4.2`) from `traktor-kontrol-qml-files` to compute exact changes; create local branches from tags only when you need a mutable baseline copy.
- For very large change sets, run the feature-extraction prompt per folder (CSI/, Defines/, Screens/) and then merge results.

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
cd ~/my-traktor-setup/qml
git init
git add .
git commit -m "Initial: Combined mods (D2 v1.2.3 + X1MK3 v0.12.0 + forum snippet MX2-GridAdjust)"
```

**→ At this point**: You have a local directory with git tracking and METADATA.md documenting all sources (including forum snippet URLs).

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
cd ~/my-traktor-setup/qml
git commit -m "deployed: all tests passing"
```

**→ At this point**: Your custom QML is live in Traktor Pro.

---

## Quick Reference: File Organization

After AI generates and you save (**recommended structure with git inside /qml/**):

```
Your computer home directory:
  ~/my-traktor-setup/
    ├── qml/                    (YOUR ACTUAL QML — has its own .git/)
    │   ├── .git/              ← Git repo lives here only
    │   ├── CSI/
    │   │   ├── Common/
    │   │   ├── S4MK3/
    │   │   ├── X1MK3/
    │   │   └── ...
    │   ├── Defines/
    │   ├── Screens/
    │   └── METADATA.md
    │
    └── mods/                   (SOURCE REFERENCE — no git tracking)
        ├── D2-v1.2.3/
        │   └── qml/
        │
        ├── X1MK3-v0.12.0/
        │   └── qml/
        │
        └── MX2_GridAdjustBPM/
          ├── SNIPPET_SOURCE.md
          └── qml/

Traktor Pro directory (separate, on your system):
  ~/Library/Application Support/Native Instruments/Traktor Pro 4.4.1/qml/
    └── (you copy ~/my-traktor-setup/qml/* here)
```

**Key points**:

- Only `/qml/` has `.git/` — contains your actual combined QML (what deploys to Traktor)
- `/mods/` is completely separate — stores source mods and forum snippets for reference
- METADATA.md (in `/qml/`) documents all mod sources, including direct forum links
- This structure is clean, simple, and works perfectly with git

---

## Optional: Organizing Forum Snippets

If using forum snippets, create a minimal entry in `/mods/`:

```
~/my-traktor-setup/mods/MX2_GridAdjustBPM/
└── SNIPPET_SOURCE.md    # Just the forum link
```

(See [Chapter 09 — Forum Snippets](09_MOD_DOCUMENTATION_GUIDE.md#forum-snippets-simple-approach) for the format)

No need for complex patch files — reference the forum URL directly in your prompt, and paste the code snippet from the forum itself.

---

## Updating Later (When Mods Release New Versions)

When a mod you used updates (e.g., D2 v1.2.3 → v1.2.4):

```bash
cd ~/my-traktor-setup/qml

# 1. See what changed
git diff v1.2.3..v1.2.4

# 2. Decide: Do I need this update?

# 3. If yes: Update your qml/ directory
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
