# Chapter 10: Prompt Templates

**Purpose**: Index of all AI prompt templates for the Traktor QML mod system. Pick the prompt you need, open the file, and copy it into your AI tool (Claude, ChatGPT, Copilot).

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

**Open your workspace** at the root directory (`~/my-traktor-setup/`) in your editor. This gives the AI access to both:

- `/qml/` — your current combined QML
- `/mods/` — your mod source directories

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

## Related Chapters

- [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md) — versioning, metadata lock files, how to find version info
- [Chapter 11: Combining Mods — Complete Workflow](11_COMBINING_MODS_WORKFLOW.md) — full step-by-step workflow (preparation, AI generation, save, deploy)
