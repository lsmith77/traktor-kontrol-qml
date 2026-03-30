# Prompt: Update a Mod (Non-Git / ZIP Format)

**When to use**: A mod from forum/ZIP release needs updating and you have side-by-side version directories.

**Prerequisites**:

- Both `mods/[ModName-vOLD]/` and `mods/[ModName-vNEW]/` directories exist side by side
- You know which features from this mod are currently integrated into your combined `/qml/`
- See [Chapter 11 — Updating Non-Git Mods](../11_COMBINING_MODS_WORKFLOW.md#updating-non-git-mods-zips-forum-posts) for setup
- **QML Linter**: Have a QML linter installed and configured (see [QML Linter setup in 01_BASICS.md](../01_BASICS.md#qml-linter))

**For git-tracked mods**: See [update-mod-git.md](update-mod-git.md)

**Workflow context**: [Chapter 11 — Updating Later](../11_COMBINING_MODS_WORKFLOW.md#updating-later-when-mods-release-new-versions)

---

## Before Running This Prompt

Fill in the "Values to use:" section at the top of the prompt block. Every customizable value lives there.

---

## How to Use This Prompt

1. Copy the entire prompt block below
2. Paste into Claude/Copilot
3. **Only update the "Values to use:" section** with your actual values
4. Leave all `[MOD_NAME]`, `[OLD_VER]`, `[NEW_VER]`, `[METADATA_LINE]`, `[FEATURES]`, `[UPDATE_SCOPE]`, and `[QML_LINTER_COMMAND]` placeholders as-is throughout the rest of the prompt — the AI will substitute them from the values you declared at the top

---

## Prompt (copy everything below into Claude/Copilot)

```
# Instructions for AI Assistant

## Values to use:

- MOD_NAME: [fill in]
- OLD_VER: [fill in]
- NEW_VER: [fill in]
- QML_LINTER_COMMAND: [fill in, or leave empty to skip linting]
- FEATURES: [list features from this mod currently integrated into your /qml/]
- UPDATE_SCOPE: [all — or name a specific feature to target only that]

### Behavior

If QML_LINTER_COMMAND is set:

- **Generate syntactically valid QML** for the target Traktor version
- **If you have CLI access**: Run the linter command directly and report results in format: `[filename]: [line#] [error type] [message]`
- **If no CLI access**: Ask user to run the command and paste output in that format
- **Actively validate using linter output**: Review results, identify violations, and fix code
- **Iterate until clean**: Loop until zero errors/warnings

If QML_LINTER_COMMAND is empty:

- **Generate syntactically valid QML** using your knowledge of QtQuick 2.15 and CSI 1.0 syntax

---

I need to update my combined QML from [MOD_NAME] [OLD_VER] → [NEW_VER].

## Roles — read carefully before acting

- **Source (read-only):** `mods/[MOD_NAME]-[OLD_VER]/` and `mods/[MOD_NAME]-[NEW_VER]/` — the upstream mod snapshots. Use them only to extract what changed between versions. Do NOT check whether changes are already present in either source directory; both are reference-only.
- **Target (read-write):** `/qml/` — my combined QML. This is the only place where you must check what's present and apply changes.

## Current State:

- METADATA.md currently records the current state
- My /qml/ includes these features from this mod: [FEATURES]
- Update scope: [UPDATE_SCOPE]
- Old mod directory: mods/[MOD_NAME]-[OLD_VER]/
- New mod directory: mods/[MOD_NAME]-[NEW_VER]/

## Task:

1. Compare `mods/[MOD_NAME]-[OLD_VER]/` and `mods/[MOD_NAME]-[NEW_VER]/` to identify what changed (structure, file additions, deletions, modifications)
2. From that diff, identify changes relevant to [UPDATE_SCOPE] — if UPDATE_SCOPE is `all`, consider all features listed above; if it names a specific feature, limit changes to that feature only
3. For each relevant change: locate the corresponding code in **my `/qml/`** and apply the change there
4. Update METADATA.md: change the version entry from [OLD_VER] to [NEW_VER]
5. List any new conflicts introduced by the new version, with recommended resolutions
6. Generate a testing checklist specific to the changed behavior
```
