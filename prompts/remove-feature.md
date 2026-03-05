# Prompt: Remove or Switch a Feature

**When to use**: Removing a feature from your combined mod, or swapping one mod's implementation of a feature for another's.

**Key prerequisite**: Before running this prompt, check the `Conflict resolutions applied` section of your METADATA.md. If the feature you're removing caused accommodations in other mods (e.g., a pad remapping, a disabled handler), those must be reverted too — paste those entries into the prompt.

**Workflow context**: [Chapter 11 — Removing or Switching Features](../11_COMBINING_MODS_WORKFLOW.md#removing-or-switching-features)

---

## Prompt (copy everything in the block below)

```
I need to remove the feature "[FEATURE NAME]" that was contributed by [MOD NAME] [VERSION] from my combined /qml/.

## Current State:

- METADATA.md conflict resolutions relevant to this feature:
  [Paste the relevant entries from "Conflict resolutions applied" in METADATA.md, or write "none"]

- Files this feature affects (from METADATA.md or your knowledge): [list files]

## Task:

1. Locate all code introduced by this feature (QML/JS changes from [MOD NAME] that implement "[FEATURE NAME]")
2. Revert those changes to the baseline behavior
3. If the METADATA.md conflict resolutions above show that this feature caused accommodations in other mods
   (e.g., a pad remapping, a disabled handler, a toggle added to avoid a conflict), revert those accommodations too
4. Update METADATA.md:
   - Remove "[FEATURE NAME]" from the features list for [MOD NAME]
   - Remove or annotate the conflict resolution entries that were tied to this feature
5. Generate a testing checklist to verify the removal didn't break other features

## Optional — Switching (replace with different implementation):

After removal is complete, I want to add [REPLACEMENT FEATURE] from [OTHER MOD] instead.
[Describe the replacement feature and which mod it comes from — then treat it as a new combine-mods.md run]
```
