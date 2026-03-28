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

Replace these placeholders with your actual values:

| Placeholder  | What it means      | Example  |
| ------------ | ------------------ | -------- |
| `[MOD_NAME]` | Name of the mod    | `D2`     |
| `[OLD_VER]`  | Old version number | `v1.2.3` |
| `[NEW_VER]`  | New version number | `v1.2.4` |

---

## How to Use This Prompt

1. Copy the entire prompt block below
2. Paste into Claude/Copilot
3. **Only update the "Values to use:" section** with your actual values
4. Leave all the `[MOD_NAME]`, `[OLD_VER]`, `[NEW_VER]` placeholders as-is throughout the rest of the prompt — the AI will use the values you declared at the top

---

## Prompt (copy everything below into Claude/Copilot)

```
## Instructions for AI Assistant

### Configuration

QML_LINTER_COMMAND = ""  # Set to your linter command (see QML_LINTER_SETUP.md for options)
# Example: "qml-linter ./qml/ --output-format compact"
# If left empty, linter validation will be skipped.

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

## Values to use:

- MOD_NAME: [fill in]
- OLD_VER: [fill in]
- NEW_VER: [fill in]

---

I need to update my combined QML from [MOD_NAME] [OLD_VER] → [NEW_VER].

## Roles — read carefully before acting

- **Source (read-only):** `mods/[MOD_NAME]-[OLD_VER]/` and `mods/[MOD_NAME]-[NEW_VER]/` — the upstream mod snapshots. Use them only to extract what changed between versions. Do NOT check whether changes are already present in either source directory; both are reference-only.
- **Target (read-write):** `/qml/` — my combined QML. This is the only place where you must check what's present and apply changes.

## Current State:

- METADATA.md currently records: [paste the METADATA.md line for this mod]
- My /qml/ includes these features from this mod: [list features]
- Old mod directory: mods/[MOD_NAME]-[OLD_VER]/
- New mod directory: mods/[MOD_NAME]-[NEW_VER]/

## Task:

1. Compare `mods/[MOD_NAME]-[OLD_VER]/` and `mods/[MOD_NAME]-[NEW_VER]/` to identify what changed (structure, file additions, deletions, modifications)
2. From that diff, identify changes relevant to the features listed above
3. For each relevant change: locate the corresponding code in **my `/qml/`** and apply the change there
4. Update METADATA.md: change the version entry from [OLD_VER] to [NEW_VER]
5. List any new conflicts introduced by the new version, with recommended resolutions
6. Generate a testing checklist specific to the changed behavior

## Optional: Preview first

Walk me through the key file differences between the two source directories before applying changes to /qml/.
```
