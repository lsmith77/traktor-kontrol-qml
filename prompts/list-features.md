# Prompt: Extract Feature List from a Mod

**When to use**: A mod has no author-provided feature list. Use this to produce a reviewable feature list before running [combine-mods.md](combine-mods.md) or [split-mod.md](split-mod.md).

**Output**: A bulleted feature list for human review. Edit it before feeding it into the next step — the AI's extraction is a starting point, not ground truth.

**Workflow context**: [Chapter 11 — Feature extraction and splitting](../11_COMBINING_MODS_WORKFLOW.md#ai-prompt-templates-feature-extraction-and-feature-splitting)

---

## Before Running This Prompt

This is a straightforward extraction prompt with no required placeholders. Just provide the baseline and mod files/changes.

---

## How to Use This Prompt

1. Copy the entire prompt block below
2. Paste into Claude/Copilot
3. Provide the baseline (tag or file tree) and the mod files/changes

---

## Prompt (copy and use as-is)

```
You are an expert Traktor QML analyst. I will provide either (A) a consolidated list of file changes (mod vs baseline) or (B) the mod file tree plus the baseline file tree. Your task: produce a concise, reviewable feature list for human verification.

Output format: bulleted feature list + short human summary:

- Features: for each feature provide an ID, title, one-line description, primary files, UI elements, key handlers/events, global side-effects, and a rough risk (low/med/high).
- Notes: list any ambiguous areas and recommended sample files to inspect.

Baseline info: include baseline tag used (e.g., traktor-kontrol-qml-files tag 4.4.1). Return a concise bulleted list and a 6-line human summary.
```

---

**Next step**: Review and edit the output, then pass it to [split-mod.md](split-mod.md) or directly to [combine-mods.md](combine-mods.md).
