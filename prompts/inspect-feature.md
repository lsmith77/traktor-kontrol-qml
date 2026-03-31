# Prompt: Extract Details for a Single Feature

**When to use**: You only need information about one specific feature from a mod — not the full feature list. Useful for targeted investigation before a partial merge or conflict analysis.

**Prerequisites**:

- **QML Linter**: Have a QML linter installed (optional but recommended, see [QML Linter Setup](#qml-linter-setup) below)

**Workflow context**: [Chapter 11 — Feature extraction and splitting](../11_COMBINING_MODS_WORKFLOW.md#ai-prompt-templates-feature-extraction-and-feature-splitting)

---

---

## Before Running This Prompt

Replace this placeholder with your actual value:

| Placeholder      | What it means                            | Example                                           |
| ---------------- | ---------------------------------------- | ------------------------------------------------- |
| `[FEATURE_NAME]` | The specific feature you want to inspect | `vinyl break`, `library view`, `REL mode display` |

---

## How to Use This Prompt

1. Copy the entire prompt block below
2. Paste into Claude/Copilot
3. **Fill in `[FEATURE_NAME]`** with the feature you want to inspect
4. Provide the baseline and mod files/changes when prompted

---

## Prompt (copy and fill in the bracketed zone)

```
## Instructions for AI Assistant

### Configuration

QML_LINTER_COMMAND = ""  # Set to your linter command (see QML_LINTER_SETUP.md for options)
# Example: "qml-linter ./feature_code/ --output-format compact"
# If left empty, linter validation will be skipped.

### Behavior

If QML_LINTER_COMMAND is set:

- **Generate or analyze QML code** for the feature
- **If you have CLI access**: Run the linter on the extracted code directly and report results in format: `[filename]: [line] [error type] [message]`
- **If no CLI access**: Ask user to run the command and paste results in that format
- **Actively use the output**: Review linter findings and explain implications for feature integration
- **Reference linter findings**: Distinguish between issues the linter caught (syntax, types) vs. logic errors requiring manual review

If QML_LINTER_COMMAND is empty:

- **Analyze QML code** for the feature using your knowledge of QtQuick 2.15 and CSI 1.0 syntax

---

**Output only — do not write or modify any files.** This is a read-only analysis step. Return a report for human review; no code changes should be applied to any directory.

You are an expert Traktor QML analyst. I will provide a baseline (tag or file tree) and either a consolidated list of file changes or the mod file tree. I only want information about one specific feature: [FEATURE_NAME] (e.g., vinyl break, library view in Browse mode, screen display in REL mode).

Tasks:

- Locate files and exact changed lines implementing or affecting [FEATURE_NAME].
- List UI elements, key handlers/events, signals, and any global state affected by this feature.
- Describe dependencies (other features, helper modules) and a short risk rating (low/med/high).
- Produce a 3-step test checklist to verify the feature in Traktor.

Output: bulleted feature details (id, title, description, primary_files, key_handlers, ui_elements, side_effects, risk) and notes. Return a concise bulleted list and a 4-line human summary.
```
