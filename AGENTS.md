# AGENTS.md

## Audience

The target audience of this handbook are **musicians, not programmers**. Use music terminology over programmer lingo. Prefer simple patterns and focus on building confidence — these topics may feel intimidating. But keep it short and assume basic knowledge of the respective operating system and Traktor Pro.

## Subdirectories Are Intentionally Excluded from Git

The `.gitignore` excludes all subdirectories (`*/`) except `.github/`, `prompts/`, `scripts/`, and `handbook/`. This applies to every cloned repo — community mods (e.g. `X1MK3_PerformanceMod/`, `traktor-kontrol-d2/`) and the companion repos (`traktor-kontrol-qml-files/`, `traktor-logger/`) alike. All community mod repos are regular directory clones, not symlinks. The separate `blint` entry in `.gitignore` covers a symlink to a linting tool; symlinks are not matched by `*/`, so it needs its own rule.

Consult `handbook/02_API_REFERENCE.md` first. Use QML code from subdirectories only when the API reference is insufficient. If you discover something useful, propose an improvement to `handbook/02_API_REFERENCE.md`.

## Companion Repositories

Clone these into the handbook root (see `handbook/00_HANDBOOK.md` for setup commands):

- **`traktor-kontrol-qml-files/`** — Stock Traktor QML baseline for comparison and examples.
- **`traktor-logger/`** — Debug dashboard server.

Several handbook pages link to these using absolute GitHub URLs — if the repos are available locally, read them directly instead.

## Always Run Prompts from This Root

Run AI prompts (from `prompts/`) with this handbook directory as the working directory — even when the target mod lives in a subdirectory. Pass mod paths as relative paths from here (e.g. `traktor-kontrol-d2/qml/`). See `handbook/10_PROMPT_TEMPLATES.md` for the full prompt index and workflow order.

## Linting Generated QML

Prompt templates include a linter configuration slot and usage behavior; setup instructions are in `handbook/01_BASICS.md#qml-linter`. If the user's prompt does not provide a lint command, remind them to supply one when dealing with syntax issues.

## Script Caution

The `scripts/` directory contains `traktor-mod.sh` (primary implementation), `traktor-mod.bat` (Windows), and `manual-install.md` (step-by-step fallback for when the script fails). The scripts are intentionally described as "vibe coded via AI with minimal code review." Modify them carefully.

`traktor-mod.bat` is not yet production-tested. If the user is on Windows, warn them before suggesting any `traktor-mod` commands. No need to keep `.sh` and `.bat` in sync while debugging — ask before updating either.
