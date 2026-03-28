# Prompt: Combine Mods

**When to use**: Combining two or more mods into a unified `/qml/` for the first time.

**Prerequisites**:

- One baseline: a `traktor-kontrol-qml-files` tag/file tree, or a legacy mod directory with a full `qml/` tree
- For each mod: either a reviewed feature list (bulleted), or the mod file tree + author feature list
- If you only have raw file changes with no feature list, run [list-features.md](list-features.md) first, review the output, then return here
- **QML Linter**: Have a QML linter installed and configured before running this prompt (see [QML Linter setup in 01_BASICS.md](../01_BASICS.md#qml-linter))

**Workflow context**: [Chapter 11 — Combining Mods Workflow](../11_COMBINING_MODS_WORKFLOW.md)

---

## Before Running This Prompt

This prompt uses section headers and inline edit zones (marked with `[...]`).

**Key placeholders** (replace these):

| Placeholder         | What it means             | Example       |
| ------------------- | ------------------------- | ------------- |
| `[MOD NAME]`        | Name of the mod           | `D2`, `X1MK3` |
| `[Traktor Version]` | Your Traktor version      | `4.4.1`       |
| `[Controllers]`     | Your hardware controllers | `D2 + X1MK3`  |

Other placeholders in the prompt (like `[e.g., v1.2.3...]`, `[...]`) are description zones — replace them with your actual data.

---

## How to Use This Prompt

1. Copy the entire prompt block below
2. **Fill in every `[...]` zone** with your actual data
3. Paste into Claude/Copilot
4. Add your mod files and documentation below the prompt

---

## Integration Options

Before running the prompt, add a short plain-text block under **My Setup** titled `Integration Options:` that lists your desired inclusions, exclusions, and conflict controls. Use simple phrases — no JSON. Example lines:

- `Include features: vinyl break, loop roll`
- `Exclude features: auto_sync`
- `Global conflict policy: prefer_baseline`
- `Per-feature policy: vinyl break -> prefer_mod:D2; loop roll -> combine_behavior: preserve baseline timing; add toggle`
- `Target controllers: X1MK3, S4MK3`

Place this block after `My Setup` and before any pasted documentation or file listings.

---

## Prompt (copy everything below into Claude/Copilot)

```
## Instructions for AI Assistant

### Configuration

QML_LINTER_COMMAND = ""  # Set to your linter command (see 01_BASICS.md for options)
# Example: "qml-linter ./qml/ --output-format compact"
# If left empty, linter validation will be skipped.

### Behavior

If QML_LINTER_COMMAND is set:

- **Generate syntactically valid QML** for the target Traktor version
- **If you have CLI access**: Run the linter command directly and report results
- **If no CLI access**: Ask the user to run the command and paste output in format: `[filename]: [line#] [error type] [message]`
- **Actively validate using linter output**: Review linter results, identify violations, and fix code
- **Iterate until clean**: Continue the feedback loop until zero errors/warnings remain

If QML_LINTER_COMMAND is empty:

- **Generate syntactically valid QML** using your knowledge of QtQuick 2.15 and CSI 1.0 syntax

---

---

## Prompt (copy and fill in all bracketed zones)

```

I'm combining multiple Traktor QML mods into a single unified QML directory.

## Mods Being Combined:

**Mod 1: [MOD NAME]**

- Version: [e.g., v1.2.3 or "unknown - from ZIP on forum"]
- Source: [GitHub URL, NI Forum link, or ZIP filename]
- Features included: [List which specific features you're using from this mod]
- Traktor compatibility: [e.g., 4.4.0+]
- Controllers: [Which controllers this mod targets: D2, X1 MK3, S4MK3, etc.]

**Mod 2: [MOD NAME]**

- Version: [version number or "unknown"]
- Source: [Where you got this mod]
- Features included: [Which capabilities]
- Traktor compatibility: [What versions]
- Controllers: [Which hardware]

**Mod 3: [MOD NAME]** (add more as needed)

- Version: [...]
- Source: [...]
- Features included: [...]
- Traktor compatibility: [...]
- Controllers: [...]

## My Setup:

- **Traktor Version**: [e.g., 4.4.1]
- **Controllers**: [e.g., D2 + X1 MK3 + Z1 MK2]
- **Goal**: [What you're trying to accomplish]

## Integration Options:

[Add your include/exclude/conflict lines here — see guidance above the prompt block]

## Optional: Paste Any Available Documentation

[Paste README.md or feature documentation from each mod, if you have it]

[Paste CHANGELOG or version history, if available]

[Note any compatibility matrices or requirements you found]

## Mod Files Location

I have downloaded the mod source files here (for reference):

./mods/
├── D2-v1.2.3/
├── X1MK3-v0.12.0/
└── Z1-unknown/

## Roles — read carefully before acting

- **Source (read-only):** `./mods/` directories — reference only. Read these to understand each mod's code. Do NOT write anything here.
- **Target (read-write):** `/qml/` — the unified output directory. All generated files go here and only here.

---

## Please generate:

1. **Version Identification**: Identify exact versions of all mods (or assign tracking IDs for unversioned ones)

2. **Compatibility Analysis**:
   - Which mods use the same QML files (potential conflicts)?
   - Which features might compete for the same pads/encoders?
   - Any known incompatibilities?

3. **Application Sequence**:
   - Order to apply each mod
   - Which changes go into which files
   - Dependencies between features

4. **Complete QML Directory with Integrated Metadata**:
   - Generate the full /qml/ directory structure (CSI/, Defines/, Screens/, etc.)
   - Include all files needed for all controllers I listed
   - Insert metadata comment block at the top of the main controller file (e.g., CSI/X1MK3/X1MK3.qml) showing:
     - Components included (name + version + source)
   - Prompt/handbook version used (e.g., v0.5.0)
     - Last updated date
     - Application order
   - Create METADATA.md in root of directory with:
   - Prompt/handbook version used (e.g., v0.5.0)
     - Full version details for each component
     - Conflict resolutions applied
     - Testing checklist (which features to test, in what order)

5. **README.md for the combined QML directory**:
   - Generate or update a README.md in the /qml/ root directory with:
     - Brief description of this combined QML setup
     - Quick list of integrated mods and versions (very brief summary; full details in METADATA.md)
     - Link to METADATA.md (relative path) for complete version and integration details
     - Link to the Traktor QML Handbook: https://github.com/lsmith77/traktor-kontrol-qml

6. **Testing Checklist**: Specific test cases for this combination
   - Which features to test first (dependencies)
   - Which interactions to verify
   - Edge cases or known limitations

7. **Conflict Resolution** (if any): For features sharing resources
   - Which takes priority
   - How to configure both if possible
   - Fallback options

```

---

## Example (Filled In)

```

I'm combining multiple Traktor QML mods into a single unified QML directory.

## Mods Being Combined:

**Mod 1: D2 Performance Mod**

- Version: v1.2.3
- Source: https://github.com/lsmith77/traktor-kontrol-d2/releases/tag/v1.2.3
- Features included: Stem Mute Pads, Serato-Style FX Filtering, Custom LEDs
- Traktor compatibility: 4.4.0+
- Controllers: D2

**Mod 2: X1MK3 Performance Mod**

- Version: v0.12.0
- Source: https://github.com/lsmith77/X1MK3_PerformanceMod/releases/tag/v0.12.0
- Features included: Tempo Control, Beatgrid Sync, Mixer Overlay, Transport LED Feedback
- Traktor compatibility: 4.4.1
- Controllers: X1 MK3

**Mod 3: Community Z1 Mod**

- Version: unknown (from NI forum post March 2026)
- Source: https://community.native-instruments.com/discussion/17167
- Features included: Custom pad mapping for Stems, FX section control
- Traktor compatibility: "tested on 4.4.1"
- Controllers: Z1 MK2

## My Setup:

- **Traktor Version**: 4.4.1
- **Controllers**: D2 + X1 MK3 + Z1 MK2
- **Goal**: Create unified control scheme across all three controllers with consistent Stem access

## Integration Options:

Include features: Stem Mute Pads, Tempo Control, Custom pad mapping for Stems
Exclude features: Custom LEDs
Global conflict policy: prefer_baseline
Target controllers: D2, X1MK3, Z1MK2

[Docs and changelogs go here if available]

```

Then continue with the "Please generate:" section above.
```
