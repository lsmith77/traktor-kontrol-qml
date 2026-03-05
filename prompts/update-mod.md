# Prompt: Update a Mod

**When to use**: A mod you've already incorporated releases a new version. Covers both git-tracked and non-git (ZIP/forum) mods.

**Prerequisites**:
- For non-git mods: both `mods/[ModName-vOLD]/` and `mods/[ModName-vNEW]/` must exist side by side before running this prompt (see [Chapter 11 — Updating Non-Git Mods](../11_COMBINING_MODS_WORKFLOW.md#updating-non-git-mods-zips-forum-posts))
- For git-tracked mods: the mod repo clone in `/mods/` must have both tags available

**Workflow context**: [Chapter 11 — Updating Later](../11_COMBINING_MODS_WORKFLOW.md#updating-later-when-mods-release-new-versions)

---

## Prompt (copy everything in the block below)

```
I need to update my combined QML to incorporate changes from [MOD NAME] [OLD VERSION] → [NEW VERSION].

## Current State:

- METADATA.md currently records: [MOD NAME] [OLD VERSION] — paste the relevant METADATA.md entry
- My /qml/ currently includes these features from this mod: [list features]
- Old mod files location: mods/[ModName-vOLD]/
- New mod files location: mods/[ModName-vNEW]/

## Task:

1. Compare mods/[ModName-vOLD]/ and mods/[ModName-vNEW]/ to identify what changed
2. Determine which changes affect my combined /qml/ (only the features I'm using — listed above)
3. Apply the relevant changes to my /qml/ files
4. Update METADATA.md: change the version entry from [OLD VERSION] to [NEW VERSION]
5. List any new conflicts introduced by the new version, with recommended resolutions
6. Generate a testing checklist specific to the changed behavior

Note: If this is a git-tracked mod, you can also run: git diff [OLD_TAG]..[NEW_TAG] in the mod repo to see changes.
```
