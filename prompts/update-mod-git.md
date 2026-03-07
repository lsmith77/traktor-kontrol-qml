# Prompt: Update a Mod (Git-Tracked)

**When to use**: A git-tracked mod in your `/mods/` directory releases a new version with tags available.

**Prerequisites**:

- The mod repo is cloned in `/mods/[ModName]/`
- Both the old and new version tags exist in the repo (e.g., `v1.0.0`, `v2.0.0`)
- You know which features from this mod are currently integrated into your combined `/qml/`

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

## Prompt (copy and fill in the placeholders above)

```
## Values to use:

- MOD_NAME: [fill in]
- OLD_TAG: [fill in]
- NEW_TAG: [fill in]

---

I need to update my combined QML from [MOD_NAME] [OLD_TAG] → [NEW_TAG].

## Current State:

- METADATA.md currently records: [paste the METADATA.md line for this mod]
- My /qml/ includes these features from this mod: [list features]
- Git repo: mods/[MOD_NAME]/

## Task:

1. Run: git diff [OLD_TAG]..[NEW_TAG] in the mod repo to see all changes
2. Identify changes in the files I'm using (only the features listed above)
3. Apply the relevant changes to my /qml/ files
4. Update METADATA.md: change the version entry from [OLD_TAG] to [NEW_TAG]
5. Create a commit: "Update [MOD_NAME] [OLD_TAG] → [NEW_TAG]"
6. List any new conflicts introduced by the new version, with recommended resolutions
7. Generate a testing checklist specific to the changed behavior

## Optional: Preview first

Run: git diff --stat [OLD_TAG]..[NEW_TAG] to see file changes before applying them.
```
