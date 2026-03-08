# Chapter 11: Combining Mods — Complete Workflow

**Purpose**: Step-by-step guide for combining multiple Traktor QML mods and deploying to your controller.

**Use this chapter when**: You want to combine multiple mods from different authors into a single unified QML setup.

---

🧭 **Navigation** — ← [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md) | **You are here** | 📖 [Back to: 00_HANDBOOK.md](00_HANDBOOK.md) | 📖 [Sharing: 08_SHARING_CHANGES.md](08_SHARING_CHANGES.md)

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

**4. Get the prompt** from [prompts/combine-mods.md](prompts/combine-mods.md):

- The prompt is self-contained — it doesn't reference files
- Just copy the text block

**5. Paste into your AI tool**:

- Open a new chat
- Paste the prompt template

Integration options (includes/excludes/conflict policies): see the `Integration Options` section in [prompts/combine-mods.md](prompts/combine-mods.md#integration-options) for the simple plain-text directives to add under **My Setup**.

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

Prompts (open the file, copy the prompt block):

- [list-features.md](prompts/list-features.md) — generate a feature list from raw file changes
- [inspect-feature.md](prompts/inspect-feature.md) — details on one specific feature
- [split-mod.md](prompts/split-mod.md) — split a mod into feature-level modules

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

**9. Initialize git with `.gitignore`**:

```bash
cd ~/my-traktor-setup

# Create .gitignore file (do this before git init)
cat > .gitignore << 'EOF'
mods/
EOF

# Initialize git to track changes
git init
git add .
git commit -m "Initial: Combined mods (D2 v1.2.3 + X1MK3 v0.12.0 + forum snippet MX2-GridAdjust)"
```

**→ At this point**: You have a local directory with git tracking at the root level, `.gitignore` preventing accidental commits of `/mods/`, and METADATA.md documenting all sources (including forum snippet URLs).

---

### Phase 4: Deploy to Traktor

Use the `install-traktor-mod` script to handle backup, installation, and testing safely. See [Chapter 01: Install / Backup / Restore](01_BASICS.md#install--backup--restore-the-safe-workflow) for complete documentation.

**Quick steps:**

**10. Install your custom QML:**

```bash
cd ~/my-traktor-setup
install-traktor-mod              # Merges your qml/ into Traktor's qml/
```

**11. Test in Traktor Pro**:

- Load Traktor
- Verify controller loads without errors
- Run the testing checklist from METADATA.md

**12. Commit your deployment**:

```bash
cd ~/my-traktor-setup
git commit -m "deployed: all tests passing"
```

**→ At this point**: Your custom QML is live in Traktor Pro.

---

## Quick Reference: File Organization

After AI generates and you save (**recommended structure**):

```
Your computer home directory:
  ~/my-traktor-setup/                 ← Git repo root
    ├── .git/                         ← Git repo lives here
    ├── .gitignore                    ← Ignores /mods/ (optional)
    ├── qml/                          ← YOUR ACTUAL QML (installation target)
    │   ├── CSI/
    │   │   ├── Common/
    │   │   ├── S4MK3/
    │   │   ├── X1MK3/
    │   │   └── ...
    │   ├── Defines/
    │   ├── Screens/
    │   └── METADATA.md
    ├── features/                     ← Feature documentation (optional)
    │   ├── vinyl-break.md
    │   └── ...
    │
    └── mods/                         ← SOURCE REFERENCE (ignored by .gitignore)
        ├── D2-v1.2.3/
        │   └── qml/
        ├── X1MK3-v0.12.0/
        │   └── qml/
        └── MX2_GridAdjustBPM/
            ├── SNIPPET_SOURCE.md
            └── qml/

Traktor Pro directory (separate, on your system):
  ~/Library/Application Support/Native Instruments/Traktor Pro 4.4.1/qml/
    └── (you copy ~/my-traktor-setup/qml/* here)
```

**Key points**:

- Git repo is at the **root** (`~/my-traktor-setup/`) — tracks your actual combined QML
- `/qml/` contains your merged mod (what deploys to Traktor)
- `/features/` can hold feature documentation for your combined mod (optional)
- `/mods/` stores source mods and forum snippets for reference (ignored by git via `.gitignore`)
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

### Updating: Mods in Git (with tags)

When a git-tracked mod updates (e.g., D2 v1.2.3 → v1.2.4):

```bash
cd ~/my-traktor-setup

# 1. See what changed in the upstream mod repo
git -C mods/D2-v1.2.3 diff v1.2.3..v1.2.4

# 2. Decide: Do I need this update?

# 3. If yes: Update your qml/ using the Mod Update Prompt for Git (prompts/update-mod-git.md)

# 4. Commit the change
git commit -m "Update: D2 v1.2.3 -> v1.2.4 (FX routing fix)"

# 5. Copy to Traktor (Step 11 above)

# 6. Test in Traktor (Step 12 above)
```

Your METADATA.md tracks which versions are installed — update it after each mod change.

---

### Updating: Non-Git Mods (ZIPs, forum posts)

For mods that don't use git, use version numbers in the directory name (this is already the recommended convention in the `/mods/` layout). When a new version is released:

```bash
# 1. Download the new version alongside the old one
unzip ModName-v1.2.4.zip -d ~/my-traktor-setup/mods/ModName-v1.2.4/

# You now have both versions side by side:
#   mods/ModName-v1.2.3/   ← old (keep during transition for comparison)
#   mods/ModName-v1.2.4/   ← new

# 2. Use the Mod Update Prompt for Non-Git (prompts/update-mod.md) — reference both directories
#    so the AI can compute what changed and update /qml/ accordingly

# 3. Commit the change
git commit -m "Update: ModName v1.2.3 -> v1.2.4 (description)"

# 4. Copy to Traktor and test (Steps 11-12 above)

# 5. Optional: remove the old version once satisfied
rm -rf ~/my-traktor-setup/mods/ModName-v1.2.3/
```

**Are separate version directories confusing?** No — the shared name prefix (`ModName-`) plus the METADATA.md entry (which records the logical mod name alongside the version) makes the old→new relationship unambiguous. The AI update prompt also references both directories explicitly, so there is no risk of treating them as separate mods.

---

## Removing or Switching Features

### Simple feature removal

To remove a single feature from your combined mod, use [prompts/remove-feature.md](prompts/remove-feature.md). Tell the AI which feature to remove and which mod it came from. The AI will:

1. Locate the relevant files and handlers introduced by that feature
2. Revert them to the baseline state
3. Update METADATA.md to reflect the removal

Commit the result with a message like:

```
git commit -m "Remove: vinyl-break from D2 v1.2.3 (no longer needed)"
```

### Cascading removal (feature required conflict resolution in another mod)

This is the more complex case. When you originally added feature X, it may have conflicted with a behavior in mod B — so the AI applied a conflict resolution (e.g., remapped a pad in mod B, disabled a toggle in mod B, or split a handler). If you now remove feature X, that conflict resolution also needs to be reverted.

**How to know if there's a cascade**: Check the `Conflict resolutions applied` section of your METADATA.md. If feature X appears there (or caused an entry there), removing it has cascading effects.

Example METADATA.md entry to look for:

```
## Conflict Resolutions Applied
- vinyl-break (D2) vs loop-roll (X1MK3): disabled loop-roll long-press on X1MK3 pad 4
  → If vinyl-break is removed, restore X1MK3 pad 4 long-press to baseline behavior
```

Use [prompts/remove-feature.md](prompts/remove-feature.md) and include the relevant `Conflict resolutions applied` entries. The AI will revert both the feature itself and the accommodations made for it.

### Switching: replace feature A with feature B from a different mod

If you want to swap one mod's implementation of a feature for another's (e.g., replace D2's loop-roll with X1MK3's implementation):

1. Check METADATA.md for any conflict resolutions tied to the feature being removed
2. Use [prompts/remove-feature.md](prompts/remove-feature.md) to remove the old implementation (including cascades)
3. Then use [prompts/combine-mods.md](prompts/combine-mods.md) to add the new implementation
4. Commit both steps separately so you can rollback cleanly if needed

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
- [Chapter 10: Prompt Templates](10_PROMPT_TEMPLATES.md) — Index of all AI prompt templates

---

## Related Chapters

- **Chapter 09** — Mod documentation, versioning, metadata patterns
- **Chapter 10** — Prompt templates index
- **Chapter 03** — Community resources and featured mods

---

## Conflict Detection Strategy

When combining multiple mods, conflicts occur when:

- **Two mods modify the same file** (exact same QML file like `X1MK3.qml`)
- **Two mods modify overlapping sections** within a file (same lines or functionally related code)
- **Two mods define the same component or property** (duplicate IDs, property names)

### Pre-Merge Detection (Before AI Combines)

Before using the [combine-mods.md](prompts/combine-mods.md) prompt, check for conflicts manually:

**Step 1: List all files each mod changes**

For each mod, run:

```bash
find ModName/qml -type f -name "*.qml" | sort
```

Compare the file lists. If two mods change the exact same files, a conflict is likely.

**Step 2: Check feature overlap**

Review each mod's feature documentation (see [Chapter 09](09_MOD_DOCUMENTATION_GUIDE.md)):

- Do both mods claim to customize the same button, pad, or screen?
- Do both mods initialize the same Timer or Handler?
- Do both mods modify the same Binding or Wire path?

If yes → conflict probable.

**Step 3: Verify with AI**

Before running the full combine prompt, ask the AI:

```
I want to combine these two mods:
1. [Mod A]: [list files it changes]
2. [Mod B]: [list files it changes]

Do these conflict? Which files overlap?
```

The AI will identify conflicts before merging.

### Resolving Conflicts (In AI or Manually)

Once conflicts are identified:

**Option A: AI Resolution** (fastest)

Provide the AI with both conflicting contributions:

```
Both mods modify X1MK3.qml.

Mod A changes: [paste relevant section]
Mod B changes: [paste relevant section]

Merge these changes into one coherent file. If they conflict, choose the one that makes more sense or combine them if possible.
```

The AI will merge intelligently based on context.

**Option B: Manual Resolution**

If AI output is unclear:

1. Pick one mod's file as the **base**
2. Manually add the other mod's changes (copy/paste, then adapt)
3. Test thoroughly using the [3-Pass Testing Approach](04_TROUBLESHOOTING.md#3-pass-testing-approach-normal--edge--reversal)
4. If your manual merge breaks something, revert and try Option A instead

### Post-Merge Verification

After combining:

1. **Verify syntax**: Use a QML validator or paste your merged file into a QML editor for syntax checking
2. **Check for duplicate IDs**: Search for `id:` to ensure no component is defined twice
3. **Review imports**: Ensure all `import` statements are present (most common cause of silent failures)
4. **Test with 3-Pass Approach**: [04_TROUBLESHOOTING.md#3-pass-testing-approach-normal--edge--reversal](04_TROUBLESHOOTING.md#3-pass-testing-approach-normal--edge--reversal)

### Preventing Conflicts (For Mod Authors)

If you're publishing mods for others to combine:

1. **Document your feature scope clearly** (see [Chapter 09](09_MOD_DOCUMENTATION_GUIDE.md#feature-documentation-template))
2. **Use unique component IDs** (prefix with your mod name: `MyModButton1`, not just `Button1`)
3. **Add comments** marking the start/end of your customizations:
   ```qml
   // === MyMod START: SYNC button glow ===
   Rectangle { /* ... */ }
   // === MyMod END ===
   ```
4. **Avoid global changes** (only modify the specific files your feature needs)

This makes it easy for others to identify and resolve conflicts.

---

**Questions?** See:

- [Chapter 04: Troubleshooting](04_TROUBLESHOOTING.md) — Testing & validation
- [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md) — Feature documentation spec
- [Chapter 10: Prompt Templates](10_PROMPT_TEMPLATES.md) — AI prompts for combining

---

**Next:** See [00_HANDBOOK.md](00_HANDBOOK.md) for the full handbook index
