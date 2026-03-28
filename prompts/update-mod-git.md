# Prompt: Update a Mod (Git-Tracked)

**When to use**: A git-tracked mod in your `/mods/` directory releases a new version with tags available.

**Prerequisites**:

- The mod repo is cloned in `/mods/[ModName]/`
- Both the old and new version tags exist in the repo (e.g., `v1.0.0`, `v2.0.0`)
- You know which features from this mod are currently integrated into your combined `/qml/`
- **QML Linter**: Have a QML linter installed and configured (see [QML Linter setup in 01_BASICS.md](../01_BASICS.md#qml-linter))

**For non-git mods (ZIP/Forum)**: See [update-mod.md](update-mod.md)

**Workflow context**: [Chapter 11 — Updating Later](../11_COMBINING_MODS_WORKFLOW.md#updating-later-when-mods-release-new-versions)

---

## Before Running This Prompt

Replace these placeholders with your actual values:

| Placeholder  | What it means            | Example  |
| ------------ | ------------------------ | -------- |
| `[MOD_NAME]` | Name of the mod          | `D2`     |
| `[OLD_TAG]`  | Old version tag from git | `v1.2.3` |
| `[NEW_TAG]`  | New version tag from git | `v1.2.4` |

---

## How to Use This Prompt

1. Copy the entire prompt block below
2. Paste into Claude/Copilot
3. **Only update the "Values to use:" section** with your actual values
4. Leave all the `[MOD_NAME]`, `[OLD_TAG]`, `[NEW_TAG]` placeholders as-is throughout the rest of the prompt — the AI will use the values you declared at the top

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

- **Generate syntactically valid QML** for the target Traktor version (include correct import versions)
- **If you have CLI access**: Run the linter directly on generated files and report results in format: `[filename]: [line] [error type] [message]`
- **If no CLI access**: Ask user to run the command and paste results in that format
- **Actively validate using output**: Review results and fix issues
- **Iterate until clean**: Continue until zero violations

If QML_LINTER_COMMAND is empty:

- **Generate syntactically valid QML** using your knowledge of QtQuick 2.15 and CSI 1.0 syntax

---

## Values to use:

- MOD_NAME: [fill in]
- OLD_TAG: [fill in]
- NEW_TAG: [fill in]

---

I need to update my combined QML from [MOD_NAME] [OLD_TAG] → [NEW_TAG].

## Roles — read carefully before acting

- **Source (read-only):** `mods/[MOD_NAME]/` — the upstream mod repo. Use it only to extract the diff between the two tags. Do NOT check whether changes are already present here; they will be — that's the point of a tagged release.
- **Target (read-write):** `/qml/` — my combined QML. This is the only place where you must check what's present and apply changes.

## Current State:

- METADATA.md currently records: [paste the METADATA.md line for this mod]
- My /qml/ includes these features from this mod: [list features]
- Git repo: mods/[MOD_NAME]/

## Task:

1. Run: `git diff [OLD_TAG]..[NEW_TAG]` inside `mods/[MOD_NAME]/` to extract the upstream diff
2. From that diff, identify changes relevant to the features listed above
3. For each relevant change: locate the corresponding code in **my `/qml/`** and apply the change there
4. Update METADATA.md: change the version entry from [OLD_TAG] to [NEW_TAG]
5. Create a commit: "Update [MOD_NAME] [OLD_TAG] → [NEW_TAG]"
6. List any new conflicts introduced by the new version, with recommended resolutions
7. Generate a testing checklist specific to the changed behavior

## Optional: Preview first

Run: `git diff --stat [OLD_TAG]..[NEW_TAG]` inside `mods/[MOD_NAME]/` to see which files changed before applying them.
```
