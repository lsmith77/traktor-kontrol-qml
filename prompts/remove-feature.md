# Prompt: Remove or Switch a Feature

**When to use**: Removing a feature from your combined mod, or swapping one mod's implementation of a feature for another's.

**Key prerequisites**:

- Check the `Conflict resolutions applied` section of your METADATA.md. If the feature you're removing caused accommodations in other mods (e.g., a pad remapping, a disabled handler), those must be reverted too — paste those entries into the prompt.
- **QML Linter**: Have a QML linter installed and configured (see [QML Linter Setup](#qml-linter-setup) below)

**Workflow context**: [Chapter 11 — Removing or Switching Features](../11_COMBINING_MODS_WORKFLOW.md#removing-or-switching-features)

---

## QML Linter Setup (Required)

Before running this prompt, have a QML linter ready to validate the modified output.

\u2192 **[See 01_BASICS.md \u2014 QML Linter for setup instructions](../01_BASICS.md#qml-linter)**

Quick summary: Choose from qml-linter (CLI), VS Code, or Qt Creator. Works on macOS and Windows.

---

## Before Running This Prompt

Replace these placeholders with your actual values:

| Placeholder      | What it means                                 | Example                       |
| ---------------- | --------------------------------------------- | ----------------------------- |
| `[FEATURE_NAME]` | Name of the feature to remove                 | `vinyl break`, `library view` |
| `[MOD_NAME]`     | Name of the mod that contributed this feature | `D2`, `X1MK3`                 |
| `[VERSION]`      | Version of that mod                           | `v1.2.3`                      |
| `[OTHER_MOD]`    | (Optional) Replacement mod name               | `Supreme Edition`             |

---

## How to Use This Prompt

1. Copy the entire prompt block below
2. Paste into Claude/Copilot
3. **Fill in every `[...]` section** with your actual data
4. Paste any METADATA.md conflict resolutions for this feature

---

## Prompt (copy and fill in all bracketed zones)

```
## Instructions for AI Assistant

### Configuration

QML_LINTER_COMMAND = ""  # Set to your linter command (see QML_LINTER_SETUP.md for options)
# Example: "qml-linter ./qml/ --output-format compact"
# If left empty, linter validation will be skipped.

### Behavior

If QML_LINTER_COMMAND is set:

- **Generate syntactically valid QML** when removing code
- **If you have CLI access**: Run the linter on modified files directly and report results in format: `[filename]: [line#] [error] [description]`
- **If no CLI access**: Ask user to run the command and paste output in that format
- **Actively validate using output**: Review results and fix broken bindings or other issues
- **Iterate until clean**: Loop until zero linter errors remain

If QML_LINTER_COMMAND is empty:

- **Generate syntactically valid QML** using your knowledge of QtQuick 2.15 and CSI 1.0 syntax

---

I need to remove the feature "[FEATURE_NAME]" that was contributed by [MOD_NAME] [VERSION] from my combined /qml/.

## Current State:

- METADATA.md conflict resolutions relevant to this feature:
  [Paste the relevant entries from "Conflict resolutions applied" in METADATA.md, or write "none"]

- Files this feature affects (from METADATA.md or your knowledge): [list files]

## Task:

1. Locate all code introduced by this feature (QML/JS changes from [MOD_NAME] that implement "[FEATURE_NAME]")
2. Revert those changes to the baseline behavior
3. If the METADATA.md conflict resolutions above show that this feature caused accommodations in other mods
   (e.g., a pad remapping, a disabled handler, a toggle added to avoid a conflict), revert those accommodations too
4. Update METADATA.md:
   - Remove "[FEATURE_NAME]" from the features list for [MOD_NAME]
   - Remove or annotate the conflict resolution entries that were tied to this feature
5. Generate a testing checklist to verify the removal didn't break other features

## Optional — Switching (replace with different implementation):

After removal is complete, I want to add [REPLACEMENT_FEATURE] from [OTHER_MOD] instead.
[Describe the replacement feature and which mod it comes from — then treat it as a new combine-mods.md run]
```
