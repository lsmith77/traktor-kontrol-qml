# Prompt: Extract Details for a Single Feature

**When to use**: You only need information about one specific feature from a mod — not the full feature list. Useful for targeted investigation before a partial merge or conflict analysis.

**Workflow context**: [Chapter 11 — Feature extraction and splitting](../11_COMBINING_MODS_WORKFLOW.md#ai-prompt-templates-feature-extraction-and-feature-splitting)

---

## Prompt (copy everything in the block below)

```
You are an expert Traktor QML analyst. I will provide a baseline (tag or file tree) and either a consolidated list of file changes or the mod file tree. I only want information about one specific feature: [FEATURE_NAME] (e.g., vinyl break, library view in Browse mode, screen display in REL mode).

Tasks:

- Locate files and exact changed lines implementing or affecting [FEATURE_NAME].
- List UI elements, key handlers/events, signals, and any global state affected by this feature.
- Describe dependencies (other features, helper modules) and a short risk rating (low/med/high).
- Produce a 3-step test checklist to verify the feature in Traktor.

Output: bulleted feature details (id, title, description, primary_files, key_handlers, ui_elements, side_effects, risk) and notes. Return a concise bulleted list and a 4-line human summary.
```
