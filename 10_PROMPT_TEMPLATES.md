# Chapter 10: Prompt Templates

**Purpose**: Index of all AI prompt templates for the Traktor QML mod system. Pick the prompt you need, open the file, and copy it into your AI tool (Claude, ChatGPT, Copilot).

---

🧭 **Navigation** — ← [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) | **You are here** | → [11_COMBINING_MODS_WORKFLOW.md](11_COMBINING_MODS_WORKFLOW.md) | 📖 [Documentation: 09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md)

---

## Prompt Index

| Prompt               | When to use                                                      | File                                                     |
| -------------------- | ---------------------------------------------------------------- | -------------------------------------------------------- |
| **Create (New)**     | Design and implement a brand-new feature from scratch            | [prompts/create-feature.md](prompts/create-feature.md)   |
| **Combine**          | First-time combination of two or more mods                       | [prompts/combine-mods.md](prompts/combine-mods.md)       |
| **Update (Non-Git)** | A mod from forum/ZIP releases a new version                      | [prompts/update-mod.md](prompts/update-mod.md)           |
| **Update (Git)**     | A git-tracked mod with tags releases a new version               | [prompts/update-mod-git.md](prompts/update-mod-git.md)   |
| **Remove / Switch**  | Remove a feature or swap one mod's implementation for another's  | [prompts/remove-feature.md](prompts/remove-feature.md)   |
| **List Features**    | No author feature list exists — generate one for review          | [prompts/list-features.md](prompts/list-features.md)     |
| **Inspect Feature**  | Need details on one specific feature only                        | [prompts/inspect-feature.md](prompts/inspect-feature.md) |
| **Split**            | Split a monolithic mod into feature-level modules before merging | [prompts/split-mod.md](prompts/split-mod.md)             |

---

## Typical Workflow Order

**Creating a brand-new custom feature**:

1. [create-feature.md](prompts/create-feature.md) — describe your idea, get implementation code + docs

**First-time combination (mods with author feature lists)**:

1. [combine-mods.md](prompts/combine-mods.md) → done

**First-time combination (mods without feature lists)**:

1. [list-features.md](prompts/list-features.md) — generate + review feature list
2. (optional) [split-mod.md](prompts/split-mod.md) — split into modules if mod is large
3. [combine-mods.md](prompts/combine-mods.md) — combine with reviewed feature list

**After initial combination**:

- Mod updates (non-git) → [update-mod.md](prompts/update-mod.md)
- Mod updates (git) → [update-mod-git.md](prompts/update-mod-git.md)
- Remove or swap a feature → [remove-feature.md](prompts/remove-feature.md)

---

## Before Running Any Prompt

**Open this handbook folder as your workspace root** in your editor — even if the mod you're working on lives in a subdirectory. This gives the AI access to everything it needs in one session:

- The handbook chapters (API reference, troubleshooting, compatibility fixes)
- Stock QML baseline in `traktor-kontrol-qml-files/` (if cloned — see [setup guide](00_HANDBOOK.md#companion-repositories-recommended-setup))
- Any community mod repos cloned as subdirectories (e.g. `traktor-kontrol-d2/qml/`)
- The logger in `traktor-logger/`

When a prompt asks for a mod path, give it as a relative path from this root (e.g. `traktor-kontrol-d2/qml/`).

---

## Choosing a Baseline

Every combination needs a baseline — the upstream Traktor QML state you're comparing mods against.

**Option A: Clean baseline (recommended)**

```bash
git clone https://github.com/lsmith77/traktor-kontrol-qml-files
cd traktor-kontrol-qml-files
git checkout traktor-4.4.1  # or your version tag
rm -rf .git
```

Tell the AI: `My baseline: clean traktor-kontrol-qml-files (traktor-4.4.1)`

**Option B: Legacy mod as basis**

Use an existing mod's `/qml/` directory as your baseline. Tell the AI: `My baseline: [mod name + version]`

---

## Forum Snippets

If using code snippets from NI forum discussions (e.g., the [MX2 QML Mods thread](https://community.native-instruments.com/discussion/50150/mx2-qml-mods-discussion)):

1. Create a minimal `SNIPPET_SOURCE.md` in `/mods/` with the forum link (see [Chapter 09](09_MOD_DOCUMENTATION_GUIDE.md#forum-snippets-simple-approach))
2. Reference the forum URL in the prompt like any other mod source
3. Paste the code snippet directly from the forum into the prompt

---

## AI Prompts FAQ

### Can I use these prompts with other AI tools (ChatGPT, etc.)?

Yes. Each prompt is designed to work with Claude, ChatGPT, Copilot, or any text-based AI. Simply copy the prompt text into your AI tool's chat window.

**Note**: Results may vary by AI model and version.

### What if the AI output doesn't work?

1. **Copy the full error message** from Traktor's startup output (or use the [Debugging Workflow](04_TROUBLESHOOTING.md#debugging-workflow) to capture it)
2. **Include the error in a follow-up**: "This code doesn't work: [paste your code]. Error: [paste error]. Fix it."
3. **Reference working examples**: "Compare against this working example: [paste code from 03_COMMUNITY_RESOURCES.md]"

### Should I use the prompts for combining mods?

**Yes**, but follow the workflow order in [Typical Workflow Order](#typical-workflow-order):

- If mods have **feature documentation** → use [combine-mods.md](prompts/combine-mods.md) directly
- If mods **lack documentation** → use [list-features.md](prompts/list-features.md) first, then combine
- For **large monolithic mods** → use [split-mod.md](prompts/split-mod.md) before combining

This prevents conflicts and ensures clear tracking of what came from which mod.

### Can these prompts generate documentation for my mod?

Yes. Use the combination of:

1. [list-features.md](prompts/list-features.md) — to generate a feature list from your code
2. [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md) — to structure that feature list into proper documentation

Then publish your mod with clear feature documentation so others can combine it safely.

### What's the difference between "Update (Non-Git)" and "Update (Git)" prompts?

- **Non-Git**: For mods distributed as ZIP files or forum uploads. Uses manual version tracking via comments.
- **Git**: For mods with git tags and releases. Automatically extracts version info from git history.

If unsure, use "Non-Git" (it's more general).

---

## Related Chapters

- [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md) — versioning, metadata lock files, how to find version info
- [Chapter 11: Combining Mods — Complete Workflow](11_COMBINING_MODS_WORKFLOW.md) — full step-by-step workflow (preparation, AI generation, save, deploy)

---

**Next:** [11_COMBINING_MODS_WORKFLOW.md](11_COMBINING_MODS_WORKFLOW.md)
