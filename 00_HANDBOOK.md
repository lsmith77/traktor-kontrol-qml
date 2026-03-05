# Traktor QML Modder’s Handbook
**Handbook Version**: v0.6.0
**Purpose**: Index and reading guide for the handbook docs
**Use when**: Starting your QML modding journey or navigating between docs
This handbook is for people who want to **create, understand, or maintain Traktor QML mods** in a structured way.

> **New & Easy**: Want to combine mods without coding? Check out the **Mod Combination System** section below. It’s designed for musicians, not programmers.

## How this handbook is organized

**Core modding guides**:

1. [01_BASICS.md](01_BASICS.md) — Basics (QML fundamentals + Traktor's folder structure + install/restore)
2. [02_API_REFERENCE.md](02_API_REFERENCE.md) — API reference (Traktor building blocks + control value paths)
3. [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) — Community mods + working examples (GitHub repos and forum discussions)
4. [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md) — Troubleshooting (debugging + testing)
5. [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md) — Compatibility fixes (version-specific issues)

**Advanced guides**:

- How to document mods for sharing: [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md)
- How to combine multiple mods (musician's guide): [11_COMBINING_MODS_WORKFLOW.md](11_COMBINING_MODS_WORKFLOW.md)
- Prompt templates (AI prompts for combining, updating, removing): [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md)

**Appendices**:

- Frequently asked questions: [05_FAQ.md](05_FAQ.md)
- Glossary: [07_GLOSSARY.md](07_GLOSSARY.md)
- Sharing changes: [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md)

## Suggested learning path

**For individual mod creation**:

- Start with [01_BASICS.md](01_BASICS.md) (you only need the first half to do safe edits)
- Keep [02_API_REFERENCE.md](02_API_REFERENCE.md) open while making changes
- Pick one small change from a [community mod example](03_COMMUNITY_RESOURCES.md) (like X1MK3)
- If a change doesn't work, go to [04_TROUBLESHOOTING.md](04_TROUBLESHOOTING.md)
- For common questions, check [05_FAQ.md](05_FAQ.md)
- If anything breaks after a Traktor update, go to [06_COMPATIBILITY_FIXES.md](06_COMPATIBILITY_FIXES.md)

**For combining multiple community mods**:

- Read [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) to understand the **metadata lock file** pattern — your key to safe, incremental updates
- Follow the complete workflow in [11_COMBINING_MODS_WORKFLOW.md](11_COMBINING_MODS_WORKFLOW.md) (4 phases: preparation, AI generation, save, deploy)
- Use the prompt templates in [10_PROMPT_TEMPLATES.md](10_PROMPT_TEMPLATES.md) with Claude or Copilot to:
  - Gather version information and combine mods ([prompts/combine-mods.md](prompts/combine-mods.md))
  - Update a mod to a new version ([prompts/update-mod.md](prompts/update-mod.md))
  - Remove or swap a feature ([prompts/remove-feature.md](prompts/remove-feature.md))
- Learn from professional implementations in [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md)
- When mods update, use metadata lock files to understand which components changed and whether you need the update

**For mod authors creating features for community**:

- Read [09_MOD_DOCUMENTATION_GUIDE.md](09_MOD_DOCUMENTATION_GUIDE.md) to understand the documentation-first approach used by community feature creators
- Follow the feature documentation template to create shareable .md files
- Use AI tools (Copilot, Claude) with your documentation to generate code
- See [03_COMMUNITY_RESOURCES.md](03_COMMUNITY_RESOURCES.md) for real examples of documented features
- Use [08_SHARING_CHANGES.md](08_SHARING_CHANGES.md) to track and share your mods via git

---

## Visual Guide: Emoji System

The handbook uses emoji consistently to aid quick scanning:

| Symbol   | Meaning                                          | Used In                  |
| -------- | ------------------------------------------------ | ------------------------ |
| 🧭       | Quick Navigation section header                  | All main docs            |
| 🟢🟡🟠🔴 | Difficulty rating (Beginner → Advanced → Expert) | Practical Examples       |
| 🎯🔄📊   | Example category icons                           | Practical Examples       |
| ⚡💡🔍✅ | Troubleshooting sections                         | Troubleshooting doc      |
| 📖🗂️🎯   | Guide section categories                         | Practical Examples intro |

Not all sections use emoji — some use **bold titles** instead. Emoji are added where visual scanning speed helps.

---

**Next:** [01_BASICS.md](01_BASICS.md)
