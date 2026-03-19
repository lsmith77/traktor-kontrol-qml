# AGENTS.md

## Audience

The target audience of this handbook are **musicians, not programmers**. Use music terminology over programmer lingo. Prefer simple patterns and focus on building confidence — these topics may feel intimidating. But keep it short and assume basic knowledge of the respective operating system and Traktor Pro.

## Subdirectories Are Intentionally Excluded from Git

The `.gitignore` excludes all subdirectories (`*/`) except `.github/`, `prompts/`, and `scripts/`. Community mod repos (e.g. `X1MK3_PerformanceMod/`, `traktor-kontrol-d2/`) are checked out locally as symlinks or clones and intentionally not tracked.

Use QML code in these subdirectories as examples when the API reference falls short. If you discover something useful, propose an improvement to `02_API_REFERENCE.md`.

## Companion Repositories

These should be cloned as subdirectories of this handbook root:

```bash
git clone https://github.com/lsmith77/traktor-kontrol-qml-files
git clone https://github.com/lsmith77/traktor-logger
```

- **`traktor-kontrol-qml-files/`** — Stock Traktor QML baseline for comparison and examples.
- **`traktor-logger/`** — Debug dashboard server.

Several handbook pages link to these using absolute GitHub URLs — if the repos are available locally, read them directly instead.

## Always Run Prompts from This Root

Run AI prompts (from `prompts/`) with this handbook directory as the working directory — even when the target mod lives in a subdirectory. Pass mod paths as relative paths from here (e.g. `traktor-kontrol-d2/qml/`).

## Linting Generated QML

Prompt templates include linter setup and usage instructions. If the user's prompt does not provide a lint command, remind them to supply one when dealing with syntax issues.

## Script Caution

The `traktor-mod` scripts are intentionally described as "vibe coded via AI with minimal code review." Modify them carefully. The Windows batch script (`traktor-mod.bat`) is not yet production-tested — the `.sh` script is the primary implementation. No need to always keep them in sync while debugging so ask before updating.
