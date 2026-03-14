# Prompt: Split a Mod into Feature Modules

**When to use**: You have a reviewed feature list (from [list-features.md](list-features.md) or the mod author) and want to split a monolithic mod into separate feature-level files before merging. Recommended before combining large baseline-style mods.

**Prerequisites**:

- A reviewed, human-edited feature list — either from the mod author or produced by [list-features.md](list-features.md)
- **QML Linter**: Have a QML linter installed and configured (see [QML Linter setup in 01_BASICS.md](../01_BASICS.md#qml-linter))

**Workflow context**: [Chapter 11 — Feature extraction and splitting](../11_COMBINING_MODS_WORKFLOW.md#ai-prompt-templates-feature-extraction-and-feature-splitting)

---

## Before Running This Prompt

Replace this placeholder with your actual value:

| Placeholder         | What it means                    | Example          |
| ------------------- | -------------------------------- | ---------------- |
| `[TRAKTOR_VERSION]` | Traktor version you're targeting | `4.4.1`, `4.4.2` |

---

## How to Use This Prompt

1. Copy the entire prompt block below
2. Paste into Claude/Copilot
3. **Fill in `[TRAKTOR_VERSION]`** with your Traktor version
4. Provide the baseline tag, reviewed feature list, and mod files/changes when prompted

---

## Prompt (copy and fill in the bracketed zone)

```
## Instructions for AI Assistant

### Configuration

QML_LINTER_COMMAND = ""  # Set to your linter command (see QML_LINTER_SETUP.md for options)
# Example: "qml-linter ./module1/ ./module2/ --output-format compact"
# If left empty, linter validation will be skipped.

### Behavior

If QML_LINTER_COMMAND is set:

- **Generate syntactically valid QML** in extracted feature modules
- **If you have CLI access**: Run the linter on each split module directly and report results in format: `[module name - filename]: [line] [error]`
- **If no CLI access**: Ask user to run the commands and paste output in that format
- **Actively validate using output**: Review results and fix modules that don't pass
- **Iterate until all modules are clean**: Continue until zero errors across all split modules

If QML_LINTER_COMMAND is empty:

- **Generate syntactically valid QML** using your knowledge of QtQuick 2.15 and CSI 1.0 syntax

---

You are an expert QML refactoring assistant. Inputs:

- Baseline version: [TRAKTOR_VERSION] (baseline repo tag: traktor-kontrol-qml-files tags such as 4.4.1 or 4.4.2).
- Reviewed feature list (bulleted list) produced by the previous step or provided by the mod author.
- Consolidated change list or modified file tree for the mod.

Tasks (produce short plan + bulleted outputs):

- For each feature in the reviewed feature list: propose a target feature-file path/name and a minimal QML/JS skeleton (component names, signals, bindings), list dependencies, and list exact changed lines/files that the feature covers.
- Identify conflicts with baseline (same handler/button/mode) with severity and recommended merge strategy: pick-one, combine-behavior (describe how), toggle, namespace/adapter, or keep-separate-profile.
- Produce a commit plan: one commit per feature with commit message template and testing checklist entries.
- Output format: bulleted sections: features, conflicts, commits, tests, notes. Also include a 6-line human summary.

Practical notes:

- Use the baseline repo tags (e.g., tags/4.4.1, tags/4.4.2) from traktor-kontrol-qml-files to compute exact changes; create local branches from tags only when you need a mutable baseline copy.
- For very large change sets, run list-features.md per folder (CSI/, Defines/, Screens/) and then merge results.
```

---

**Next step**: Review the proposed feature modules and commit plan, then run [combine-mods.md](combine-mods.md) with the split feature list as input.
