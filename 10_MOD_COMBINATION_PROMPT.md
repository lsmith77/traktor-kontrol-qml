# Chapter 10: Mod Combination Prompt

**Purpose**: Copy-paste prompt template for combining multiple Traktor QML mods using AI tools.

**Chapter**: 10 of the Traktor QML Handbook  
**Handbook Version**: v0.4.0  
**Date**: 1 March 2026

---

## Quick Start

1. **Learn concepts first**: [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md) (background reading)
2. **Learn the workflow**: [Chapter 11: Combining Mods — Complete Workflow](11_COMBINING_MODS_WORKFLOW.md) (step-by-step guide)
3. **Choose your baseline**: Clean (recommended) or legacy — see below
4. **Copy the prompt below**: Paste into Claude, ChatGPT, or Copilot
5. **Fill in your mod info**: Replace placeholders with your actual versions/sources
6. **Run it**: AI generates your complete combined QML directory

---

## Choose Your Baseline Before Starting

**Option A: Clean baseline (recommended)**

```bash
git clone https://github.com/lsmith77/traktor-kontrol-qml-files
cd traktor-kontrol-qml-files
git checkout traktor-4.4.1  # or your version tag
rm -rf .git  # Remove the clone's git history — you'll start fresh with "git init"
```

This gives you the official untouched QML structure for your Traktor version. After cloning, tell the AI: `My baseline: clean traktor-kontrol-qml-files (traktor-4.4.1)`

**Option B: Legacy mod as basis**

Find an existing mod's `/qml/` directory:

```bash
# If it's a git repo, remove its git history first
rm -rf [legacy-mod-directory]/.git

# Then tell the AI about it in your prompt
```

Then in the prompt, tell the AI: `My baseline: [mod name + version] — I'll paste its structure/docs below`

**After choosing your baseline**: Copy it to your working directory and initialize git:

```bash
mkdir -p ~/my-traktor-setup
cp -r [your-baseline-directory] ~/my-traktor-setup/qml

cd ~/my-traktor-setup/qml
git init
git add .
git commit -m "Initial: baseline (traktor-kontrol-qml-files v4.4.1)"
```

**Directory structure:**

```
~/my-traktor-setup/
├── qml/                 ← git repo (baseline → AI output)
│   ├── .git/
│   ├── CSI/
│   ├── Defines/
│   ├── Screens/
│   └── METADATA.md      ← tracks which versions were combined
└── mods/                ← reference only (no git needed)
    ├── D2-v1.2.3/       ← can have its own .git, doesn't matter
    │   ├── CSI/
    │   ├── Defines/
    │   └── README.md
    ├── X1MK3-v0.12.0/
    │   ├── CSI/
    │   └── ...
    └── Z1-unknown/
```

**Download mods** (keep them as-is, `/mods/` is just a workspace reference):

```bash
# Option A: Download ZIPs from GitHub releases
# 1. Go to Release page (e.g., https://github.com/user/mod-repo/releases)
# 2. Click "Assets" → download the ZIP
# 3. Extract: unzip ModName-vX.Y.Z.zip -d ~/my-traktor-setup/mods/

# Option B: Clone directly (can keep .git if you want to track their history)
git clone https://github.com/user/mod-repo ~/my-traktor-setup/mods/ModName-vX.Y.Z

# Option C: Clone and strip .git if you prefer (optional)
git clone --depth 1 https://github.com/user/mod-repo mod-temp
rm -rf mod-temp/.git
mv mod-temp ~/my-traktor-setup/mods/ModName-vX.Y.Z
```

**Note**: Only `/qml/` is git-tracked. The `/mods/` directory is just a working reference — git doesn't need to manage it. The METADATA.md file in `/qml/` documents which mod versions were combined.

---

## Forum Snippets: Simple Approach

If using forum snippets (from discussions like the [MX2 QML Mods thread](https://community.native-instruments.com/discussion/50150/mx2-qml-mods-discussion)):

1. **Create SNIPPET_SOURCE.md** minimal file with the forum link (see [Chapter 09](09_MOD_DOCUMENTATION_GUIDE.md#forum-snippets-simple-approach) for example)
2. **In your prompt**, reference like any other mod with the forum URL
3. **Paste the code snippet** directly from the forum into the prompt

No complex files needed — the forum URL is the documentation.

---

## Copy This Entire Prompt

**Before running the prompt**: Open your workspace at the root directory (`~/my-traktor-setup/`) in your editor (VS Code, etc.). This gives the prompt access to both:

- `/qml/` (your baseline)
- `/mods/` (your mod sources, including forum snippets)

**Copy everything between the triple backticks below** (from `I'm combining...` to `...Fallback options`) **and paste into your AI tool (Claude, ChatGPT, Copilot):**

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
- **Goal**: [What you're trying to accomplish — "unified pad behavior across controllers", "add Stem controls", etc.]

## Optional: Paste Any Available Documentation

[Paste README.md or feature documentation from each mod, if you have it]

[Paste CHANGELOG or version history, if available]

[Note any compatibility matrices or requirements you found]

## Mod Files Location

I have downloaded the mod source files here (for reference):

```

./mods/
├── D2-v1.2.3/
├── X1MK3-v0.12.0/
└── Z1-unknown/

```

Provide the directory listing or key file paths from `/mods/` so I can generate the combined QML directly from the actual mod sources.

---

## Please generate:

---

### Integration Options (how to state them in the prompt)

When you paste the prompt, add a short plain-text block under **My Setup** titled `Integration Options:` that lists your desired inclusions, exclusions, and conflict controls. Use simple phrases — no JSON. Example lines to include verbatim:

- `Include features: vinyl break, loop roll`
- `Exclude features: auto_sync`
- `Global conflict policy: prefer_baseline`
- `Per-feature policy: vinyl break -> prefer_mod:D2; loop roll -> combine_behavior: preserve baseline timing; add toggle`
- `Target controllers: X1MK3, S4MK3`

Place this `Integration Options:` block after `My Setup` and before any pasted documentation or file listings. The AI will use these plain-text directives when producing the combined QML.

---

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
   - Generate the full `/qml/` directory structure (CSI/, Defines/, Screens/, etc.)
   - Include all files needed for all controllers I listed
   - Insert metadata comment block at the top of the main controller file (e.g., `CSI/X1MK3/X1MK3.qml`) showing:
     - Components included (name + version + source)
     - Prompt version used (v1.0.0)
     - Last updated date
     - Application order
   - Create `METADATA.md` in root of directory with:
     - Prompt version used (v1.0.0)
     - Full version details for each component
     - Conflict resolutions applied
     - Testing checklist (which features to test, in what order)

5. **README.md for the combined QML directory**:
   - Generate or update a README.md in the `/qml/` root directory with:
     - Brief description of this combined QML setup
     - Quick list of integrated mods and versions (very brief summary; full details in METADATA.md)
     - Link to METADATA.md (relative path) for complete version and integration details
     - Link to the Traktor QML Handbook: https://github.com/lsmith77/traktor-kontrol-qml (contains installation, troubleshooting, mod merging, and API reference)

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

Here's what a real prompt looks like (D2 + X1MK3 + Z1 community mod):

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

[Docs and changelogs go here if available]
```

Then continue with the "Please generate:" instructions...

---

## Next Steps After AI Generates

The AI outputs your complete QML directory with all files and METADATA.md.

**For detailed instructions on how to save, test, and deploy to Traktor**, see:
→ [Chapter 11: Combining Mods — Complete Workflow](11_COMBINING_MODS_WORKFLOW.md)

---

## For Background Reading

Before or after using this prompt, read:

- [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md) — Understanding versioning, metadata lock files, where to find version info, mixing versions
- [Chapter 11: Combining Mods — Complete Workflow](11_COMBINING_MODS_WORKFLOW.md) — Saving, testing, and deploying your generated QML

---

## Changelog

### v1.0.0 (1 March 2026)

- Initial release
- Standardized prompt for Claude, ChatGPT, Copilot
- Integrated metadata generation (comment block + METADATA.md)
- Clean/legacy baseline options
- Example filled-in prompt included

---

**Location**: [Root of handbook](.)  
**Questions?** See [Chapter 09: Mod Documentation Guide](09_MOD_DOCUMENTATION_GUIDE.md)
