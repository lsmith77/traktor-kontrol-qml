# Chapter 09: Mod Documentation Guide

**Purpose**: This guide teaches you how to document mod features so other users can apply, understand, and combine them with confidence.

**Audience**: Mod authors, advanced developers, and documenters creating features for community sharing.

**Connection**: After learning the basics in Chapters 01-05 and applying community mods from Chapter 03, this chapter shows you how to create documentation that helps others do the same.

---

## Philosophy: Documentation-Driven Mods

### The Core Insight

The clearest way to share a mod feature is **not** through a configuration language or build system, but through **clear documentation written in markdown**.

Why?

1. **Musicians don't code** — They need to understand what a feature does without being programmers.
2. **Conflicts are human** — When two features use the same pads, markdown lets users read both docs and decide manually.
3. **AI can read markdown** — Feature docs become input prompts for Copilot and Claude, automating code application.
4. **Git diff shows changes** — Before/after code blocks make git diffs meaningful and transparent.
5. **No dependencies on tools** — A .md file works in any editor, on any OS, forever.

### What Changed: Before and After

**Before** (Current Chaos):

- Mods shared as ZIP files on NI forum
- No clear feature listing within each mod
- Compatibility info scattered across comments
- Settings buried in code
- Difficult to apply just one feature
- No way to track which mod introduced a change
- When mods update, musicians have no idea what changed
- No incremental updating (all-or-nothing instability)

**After** (Documentation-Driven with Metadata Lock Files):

- One feature = one .md file (markdown)
- Clear: what it does, files changed, code snippets, dependencies
- Settings inside marked section (`// --- MOD SETTINGS ---`)
- Every feature has on/off toggle
- Users apply features one at a time
- **Metadata lock files in QML comments document the combination** (musician's package-lock.json)
- Git tracks each feature addition and version changes
- When mods update, musicians `git diff` to see exactly what changed
- Incremental updates (update one mod without replacing entire setup)

---

## The Metadata Lock File Pattern: How Mods Connect to Your QML

### The Core Problem and Solution

When you combine mods (D2 v1.2.3 + X1MK3 v0.12.0 + a community Z1 mod), musicians need to track:

- **Which version** of each mod they're using
- **What changed** when a mod updates
- **Whether to update** (does the change affect my setup?)
- **How to update incrementally** (just the changed parts, not the whole setup)

**The solution**: Metadata lock files — QML comments documenting the combination, like `package-lock.json` in Node.js.

### How the Complete System Works (Three Parts)

#### Part 1: Author Side — Semantic Versioning + Git Tags

Mod authors release versions using github releases and git tags:

```
d2-v1.2.3
├── Version: v1.2.3 (semantic: major.minor.patch)
├── Git tag: https://github.com/lsmith77/d2/releases/tag/v1.2.3
└── README badge: **Version**: v1.2.3
```

Why this works:

- Clear version numbers musicians understand
- GitHub releases automatically generated from tags
- README badges make versions easy to find
- Git tags enable `git diff v1.2.3..v1.2.4` to see exactly what changed

### How to Make Versions Discoverable (For Mod Authors)

When you release a new version, make it easy for musicians to find:

**1. GitHub README Badge** (Easiest)

Add to the top of your README.md:

```markdown
# D2 Performance Mod

**Version**: v1.2.3 | **Traktor**: 4.4.0+ | **Controllers**: D2
```

Musicians scan the README first — immediate visibility.

**2. GitHub Release Page** (Automatic)

When you create a git tag and push:

```bash
git tag -a v1.2.3 -m "Add stem mute pads, improve FX routing"
git push origin v1.2.3
```

GitHub automatically creates a release page visible on your repo's main page:

```
https://github.com/lsmith77/traktor-kontrol-d2/releases/tag/v1.2.3
```

Include release notes explaining what changed.

**3. ZIP Filename** (For Downloads)

When you distribute ZIPs (from forum, dropbox, etc.), include version in filename:

```
d2-v1.2.3.zip          ← Good: version immediately visible
d2-stem-pads-v1.2.3    ← Good: feature + version
d2-performance-mod.zip ← Bad: no version info
```

Musicians can identify versions by filename alone.

**4. QML File Header** (Optional)

In your main QML file, add a comment header:

```qml
// D2 Performance Mod v1.2.3
// Traktor: 4.4.0+
// Last Updated: 1 March 2026
// GitHub: https://github.com/lsmith77/traktor-kontrol-d2
```

Helpful when someone shares your code without context.

### Semantic Versioning Quick Guide

Use `v1.2.3` format (Major.Minor.Patch):

- **Increment MAJOR** when changes break compatibility (musicians must fully re-test)
  - Example: Changing which files to edit, changing settings format
- **Increment MINOR** when you add features without breaking old ones (safe to update)
  - Example: New pad mappings, new FX options
- **Increment PATCH** for bug fixes (always safe to update)
  - Example: Fixed LED feedback, fixed a timing bug

Example progression:

```
v1.0.0  ← First release
v1.0.1  ← Bug fix
v1.1.0  ← New feature
v2.0.0  ← Breaking change (requires re-testing)
```

Musicians reading your version number can immediately understand the impact of updating.

### How Musicians Find Version Information (For Users)

**Good news**: Mod authors _should_ make version info easy to find. If they don't yet, that's okay—this system handles both versioned and unversioned mods.

**Reality**: Not all mod developers have adopted semantic versioning yet. Some mods are unversioned, abandoned, or distributed as ZIPs from forums. Use this guide to find versions wherever they are.

#### User Perspective: Where to Look

**1. GitHub README (Easiest)**

When viewing a mod's GitHub repo, version should be at the top of README.md:

```
**Version**: v1.2.3 | **Traktor**: 4.4.0+ | **Controllers**: D2
```

✓ Copy this version to your metadata (prefix `v` included)

**2. GitHub Release URL**

Check the repo's "Releases" tab. Version is in the URL:

```
https://github.com/lsmith77/traktor-kontrol-d2/releases/tag/v1.2.3
                                                           ^^^^^^^ Version
```

✓ Use `v1.2.3` for your metadata  
✓ Read release notes to understand what this version includes

**3. ZIP Filename**

If you downloaded a ZIP, version might be in the name:

```
d2-stem-mute-v1.2.3.zip  ← Version is v1.2.3
```

✓ Extract version from filename (keep the `v` prefix)

**4. QML File Header**

If you cloned the repo or extracted the ZIP, check the top of main file:

```qml
// Version: v1.2.3
// Traktor: 4.4.0+
```

✓ Use version from comment

**5. Forum Post or Unknown Source**

If no version number exists, use a descriptive identifier:

```
forum-d2-stem-mute-2026-03-01
           ↑ mod name    ↑ post date (acts as version identifier)
```

(No `v` prefix needed for descriptive identifiers)

#### Tips for Getting Better Information

**If MOD has GitHub Release Page**:
Check the releases tab to find:

- Version number ← use this
- Testing notes ← helps verify compatibility
- Feature list ← shows what's included
- Traktor version info ← good for compatibility

**If MOD is from Forum**:
Look for:

- Post date (can use as version identifier)
- Features listed in opening post
- Comments mentioning version or Traktor testing
- Download link (filename often has version: `d2-v1.2.3.zip`)

**If MOD is from ZIP File**:
Check inside the ZIP for:

- README.md or README.txt (usually has version)
- qml-info.txt or mod-info.json (may have metadata)
- Latest modification date in file properties
- Use ZIP filename as fallback identifier

**If Version is Really Unknown**:
Document it descriptively:

- `community-forum-stem-controls-march-2026`
- `x1mk3-mod-shared-by-dj-alice-v-unknown`
- `d2-zip-local-modifications-origin-unknown`
- Include any distinguishing features so you can find it again

#### Part 2: Musician Side — Metadata Lock Files in QML

Musicians document their combined setup in QML comments:

```qml
// --- MOD COMBINATION METADATA (Lock File) ---
// Your Setup v1.0
// Updated: 1 March 2026
//
// Components Used:
// - D2: v1.2.3 (https://github.com/lsmith77/d2/releases/tag/v1.2.3)
// - X1MK3: v0.12.0 (https://github.com/lsmith77/x1mk3/releases/tag/v0.12.0)
// - Z1 Mod: forum-2026-03-01 (https://community.native-instruments.com/...)
//
// To Update D2 to v1.2.4:
//   git diff v1.2.3..v1.2.4 (see changes)
//   Update this section to v1.2.4
// ---
```

Why this works:

- **No external tool needed** — just QML comments
- **Self-documenting** — future musicians read comments and understand the history
- **Incremental upgrades** — update one mod without touching others
- **Git-integrated** — `git diff` helps understand changes
- **Works with unversioned mods** — uses descriptive IDs as fallback

#### Field Descriptions (Reference Guide)

When documenting your combination, include these fields:

**Version**:

- Ideal: `v1.2.3` (semantic versioning) from GitHub release
- Acceptable: `v0.4.0 (from README)` — shows where version came from
- When Missing: Use descriptive identifier like `forum-2026-03-01-user-d2mods` or `community-stem-controls-unknown-date`
- Source should always help you track this down later

**Source**:

- GitHub URL (include full repo path)
- NI Community Forum link
- ZIP filename (keeps identity stable)
- User/friend's mod (include their name, version info if available)

**Features Included**:

- List _specific_ features you're using, not just mod name
- Many mods have multiple features—you might not use all
- Example: "D2 v1.2.3: Stem Mute Pads + Serato-Style FX (not Filter Toggle)"

**Traktor Compatibility**:

- What Traktor versions this mod was tested with
- If mod doesn't specify, note "unknown, assuming 4.4.1"
- This helps you know if you need to test more thoroughly

**Controllers**:
Which hardware. Important because:

- Z1 MK2 and D2 often share code (S8-style)
- X1 MK3 has different architecture
- Compatibility matters for which features work where

#### System for Unversioned Mods (Fallback)

Not all mods are versioned yet. For unversioned mods, assign a tracking identifier using this pattern:

```
source-primary-identifier-date

Examples:
- forum-d2-stem-mute-2026-03-01
- github-lsmith77-namespace-untagged-branch-main-2026-03
- community-user-alex-z1mk2-mod-unknown-date
- local-custom-modifications-personal-2026-03
```

This way:

✓ You can always find the original source later
✓ Others can understand where you got it
✓ You track when you acquired it (helps with Traktor compatibility testing)
✓ It's stable (the identifier doesn't change if you reorganize files)

#### Combining Versioned + Unversioned Mods (Mixed Adoption)

**Reality check**: Not all mods are versioned yet. Your combined setup might include both:

```
Mod 1: D2               v1.2.3  (versioned ✓)
Mod 2: X1MK3           unversioned (no version ✗)
Mod 3: Community Z1    v0.8.0  (versioned ✓)
```

**This is fine.** The prompt and metadata lock file work perfectly with mixed versions:

```qml
// --- MOD COMBINATION METADATA ---
// Components:
// - D2: v1.2.3 (versioned, can use git diff when it updates)
// - X1MK3: github-lsmith77-x1mk3-mod-main-2026-02 (unversioned, stays stable)
// - Z1: v0.8.0 (versioned, can use git diff when it updates)

// When D2 updates to v1.2.4:
//   git diff v1.2.3..v1.2.4 (only D2, no issues with others)
```

**Advantage**: You only need to track updates for versioned mods. Unversioned mods stay stable; you don't touch them unless they specifically release updates.

**Expected outcome**: Over time, more mods adopt versioning. Your setup gradually becomes more updatable. Community naturally incentivizes developers to version (musicians ask "what version?").

#### Using Git to Understand Updates (Optional)

**Do you need git?**

- **For discovering and recording versions**: No ✓
  - Find version in README badge
  - Find version in ZIP filename
  - Find version in GitHub release page
  - Record in metadata comments
  - Done!

- **For understanding what changed between versions**: Optional ✓
  - Install git (free, one-time setup)
  - Run: `git diff v1.2.3..v1.2.4` at the mod repo
  - See exactly which lines changed
  - More detailed understanding

**Recommendation**: Install git (free) so you can `git diff` if needed. Not required, but helpful for detailed analysis.

#### Part 3: Tool — MOD_COMBINATION_PROMPT (Chapter 10)

Musicians use the prompt template when combining mods:

1. **Gathers version info** from each mod (README, releases, filenames)
2. **Requests missing info** if versions aren't discoverable
3. **Generates metadata** documenting the combination
4. **Creates the QML comment block** that becomes the lock file
5. **Checks compatibility** between mods
6. **Suggests updates** when versions change

**See Chapter 10** for using the prompt with AI tools (Claude, Copilot, etc.).

### Why These Three Parts Work Together

| Part                               | Who         | What                                        | Why                                                      |
| ---------------------------------- | ----------- | ------------------------------------------- | -------------------------------------------------------- |
| **Semantic Versioning + Git Tags** | Mod Authors | Release v1.2.3 with clear version numbers   | Musicians understand versions, `git diff` works          |
| **Metadata Lock File in QML**      | Musicians   | Comment block documenting combined setup    | No external tool, self-documenting, incremental updates  |
| **MOD_COMBINATION_PROMPT**         | Musicians   | Tool/template to create & maintain metadata | AI helps gather info, check compatibility, track updates |

### Real-World Example

**Month 1 (Setup Creation)**:

```
Musician combines:
- D2 v1.2.3
- X1MK3 v0.12.0
- Z1 Mod [forum-2026-03]

Uses MOD_COMBINATION_PROMPT to gather versions,
Adds this to QML file:
  // --- MOD COMBINATION METADATA ---
  // D2: v1.2.3, X1MK3: v0.12.0, Z1: forum-2026-03
  // Last Updated: 1 March 2026
```

**Month 3 (D2 Updates to v1.2.4)**:

```
Musician sees release notification
Wants to know: "What changed?"

Runs: git diff v1.2.3..v1.2.4

Sees: FX bug fix + new LED feedback
Decides: "I want the bug fix"

Updates the QML:
- Takes only the FX fix (leaves other sections untouched)
- Updates metadata: D2: v1.2.4
- Tests, it works

Months 4-12:
X1MK3 gets bug fixes too,
Metadata lock file lets musician update
just that component, when ready.
```

### The Power: Incremental Updates

Instead of "Replace entire setup with new version" (all-or-nothing, risky):

**Musician can do** (incremental, safe):

1. Understand what changed (`git diff`)
2. Update just that component
3. Leave everything else untouched
4. Update metadata comment
5. Test small change, roll back if needed

This is why metadata lock files are central to the whole system. They **enable safe, incremental updates** at scale.

---

## Core Concepts: Terminology

**Component**
: A reusable building block of code. Usually a small helper or state tracker shared across multiple features.
: Example: `StemModeDetector` (detects when deck is in stem mode) — used by multiple pad features

**Feature**
: A single user-facing capability with a clear before/after behavior.
: Example: "Stem Mute Pads" (pads mute stems instead of triggering samples)
: One .md file documents one feature

**Module**
: A collection of related features (usually in one QML file).
: Example: `Deck_S8Style.qml` (module containing all S8-style deck features)

**Mod**
: A curated collection of features one author maintains together.
: Example: "D2 Performance Mod v2.0" (collection of 6 features working well together)

**Golden Rule**: If you can apply a feature in one go (copy one code block, set one setting, test with one checklist), it's a feature. If it requires multiple separate applications, it's multiple features.

---

## How to Document a Feature: Step-by-Step

### Step 1: Create the Feature File

Create a new markdown file with a clear name: `{CONTROLLER}_{feature-name}.md`

Examples:

- `S4MK3_stem-mute-pads.md`
- `D2_colored-pads.md`
- `X1MK3_fx-depth-feedback.md`

### Step 2: Header & "What It Does" Section

**Start with a clear title and one-paragraph description** of what users will experience:

```markdown
# Stem Mute Pads for S4 MK3

## What It Does

Holding a deck in Stem mode and pressing pads 1-4 mutes/unmutes the
corresponding stems instead of triggering samples. Shift+pads toggle
stem FX send to shared FX unit.
```

**Test**: Could a non-programmer read this and know if they want this feature? If not, rewrite.

### Step 3: Features List

List the specific capabilities (bullets, clear language):

```markdown
## Features

- Pad 1 = Stem 1 Mute Toggle
- Pad 2 = Stem 2 Mute Toggle
- Pad 3 = Stem 3 Mute Toggle
- Pad 4 = Stem 4 Mute Toggle
- Shift+Pad = Toggle FX Send for Stem
- Works with any S8-style controller (D2, Z1MK2, etc.)
- Toggle on/off in settings
```

### Step 4: Modified Files

List exactly which files change:

```markdown
## Modified Files

- `CSI/Common/Deck_S8Style.qml` (single file modified)
```

Or if multiple files:

```markdown
## Modified Files

- `CSI/S4MK3/S4MK3.qml` (MOD SETTINGS section added)
- `CSI/Common/Deck_S8Style.qml` (helper functions added)
- `Screens/S4MK3/S4MK3_Screen.qml` (mute indicators added)
```

### Step 5: Centralized Settings Block

Every feature must have a settings section marked with comments. This is where users can enable/disable the feature:

````markdown
## Configuration

### MOD Settings

Add this to your main controller file (e.g., `CSI/S4MK3/S4MK3.qml`):

```qml
// --- MOD SETTINGS: Stem Mute Pads ---
MappingPropertyDescriptor {
    id: stemMuteToggleEnabledProp
    path: "app.traktor.settings.stem_mute_pads_enabled"
    initialValue: true  // Set to false to disable feature
}
MappingPropertyDescriptor {
    id: stemFxSendToggleEnabledProp
    path: "app.traktor.settings.stem_fx_toggle_enabled"
    initialValue: true
}
// --- END MOD SETTINGS ---
```
````

### Pass Settings to Modules

In your deck instantiation:

```qml
Deck {
    id: deck1
    deckPropertiesPath: "app.traktor.decks.1"

    // Mod Settings
    stemMuteToggleEnabled: stemMuteToggleEnabledProp.value
    stemFxToggleEnabled: stemFxSendToggleEnabledProp.value
}
```

````

**Critical**: The `// --- MOD SETTINGS: ---` markers must be EXACTLY as shown. They make it possible for AI tools and users to find and modify settings automatically.

### Step 6: Code Changes (Before/After Format)

For EACH file that changes, create a section showing exactly what changes:

```markdown
## Code Changes

### In `CSI/Common/Deck_S8Style.qml`

**Add stem state detection** (after the existing `currentPadBank` property):

**Before:**

```qml
property bool padMode: false
property int currentPadBank: 0
````

**After:**

```qml
property bool padMode: false
property int currentPadBank: 0
property bool stemMode: false  // NEW: Track if in stem mode
property var stemMuteStates: [false, false, false, false]  // NEW: Track mutes

onPropertyChanged: {
    if (path === "app.traktor.stems.active_stem_mode") {
        stemMode = value
    }
}
```

**Modify pad handlers** (in the pad button's `onTriggered` handler):

**Before:**

```qml
onTriggered: {
    if (padMode) {
        var padIndex = (currentPadBank * 4) + padNumber
        triggerSample(padIndex)
    }
}
```

**After:**

```qml
onTriggered: {
    if (stemMode && stemMuteToggleEnabled) {
        if (shiftPressed) {
            toggleStemFxSend(padNumber - 1)
        } else {
            toggleStemMute(padNumber - 1)
        }
    } else if (padMode) {
        var padIndex = (currentPadBank * 4) + padNumber
        triggerSample(padIndex)
    }
}
```

**Add helper functions** (at end of file):

**Before:**

```qml
function triggerSample(index) {
    // Existing code
}
// End of Deck
```

**After:**

```qml
function triggerSample(index) {
    // Existing code
}

// NEW: Stem control functions
function toggleStemMute(stemIndex) {
    if (stemIndex >= 0 && stemIndex < 4) {
        stemMuteStates[stemIndex] = !stemMuteStates[stemIndex]
        var muteValue = stemMuteStates[stemIndex] ? 1.0 : 0.0
        var stemPath = "app.traktor.stems." + (stemIndex + 1) + ".mute"
        engine.setValue(stemPath, muteValue)
    }
}

function toggleStemFxSend(stemIndex) {
    if (stemIndex >= 0 && stemIndex < 4) {
        var sendPath = "app.traktor.stems." + (stemIndex + 1) + ".fx_unit_4.send"
        var currentSend = engine.getValue(sendPath)
        var newSend = (currentSend > 0.5) ? 0.0 : 1.0
        engine.setValue(sendPath, newSend)
    }
}
// End of Deck
```

````

**Key principles**:
- Use conceptual descriptions ("after X property", "in the Y function") rather than line numbers. QML is declarative; position is flexible.
- Mark NEW code with `// NEW: Comment` so it stands out
- Keep code blocks short (easier to review, easier for users to copy)

### Step 7: Testing Checklist

Users need to know how to verify it works:

```markdown
## Testing Checklist

- [ ] Load controller with mod installed
- [ ] Switch deck to Stem mode (see stem display)
- [ ] Press pads 1-4 → Verify stems mute and unmute when toggled
- [ ] Press Shift+pads 1-4 → Verify FX send toggles (watch deck FX indicator)
- [ ] Toggle `stemMuteToggleEnabled: false` in settings → Verify pads trigger samples again
- [ ] Test with multiple stem tracks (hot cue different stems, test muting each)
- [ ] Disable feature: set `stemMuteToggleEnabled: false` → Verify pads revert to sample triggers
````

### Step 8: Compatibility & Dependencies

Document what this feature requires and conflicts with:

```markdown
## Compatibility

### Requires (Prerequisites)

- **Stem Mode Detection** — This feature depends on the controller correctly detecting when in Stem mode
  - D2, Z1MK2: Uses `app.traktor.stems.active_stem_mode` (built-in)
  - X1MK3: Must use [X1MK3 stem-mode-detection.md](https://github.com/example/traktor-kontrol-x1mk3/blob/COMMIT_HASH/stem-mode-detection.md) first
- **Traktor Pro 4.3+** — Stems feature required in Traktor API

### Works Alongside

- **Serato-Style FX Routing** (`stem-fx-serato.md`)
  - Stem Mute Pads use pads 1-4
  - FX Routing uses pads 5-8
  - No conflict

- **Shift+Pad Hotcue Controls** (`shift-pad-hotcues.md`)
  - Different pad bank, no conflict

### Conflicts With

- **Pad 1-4 Sample Triggers** (original behavior)
  - Cannot have pads trigger samples AND mute stems at same time
  - Choose one behavior in settings

- **Custom Pad Menus** that use pads 1-4
  - Stem Mute will override custom pad menu behavior

### Tested On

- S4 MK3 with Traktor Pro 4.4.1
- Z1 MK2 with Traktor Pro 4.4.1
- D2 with Traktor Pro 4.4.1

### NOT Tested On

- MX2, S3, S5 (different pad architecture)
- CDJ3000 (no stem support)
```

**Critical**: Use COMMIT HASH URLs, not branch URLs. Example:

- ✗ Wrong: `https://github.com/example/traktor-kontrol-d2/blob/main/stem-mode-detection.md`
- ✓ Right: `https://github.com/example/traktor-kontrol-d2/blob/34be413/stem-mode-detection.md`

### Step 9: Author Notes (Optional)

Add context about where this feature came from:

```markdown
## Author Notes

- Extracted from D2 repository (git commit bd304ba)
- Tested with D2, Z1MK2 controllers
- S8-style controller architecture used because shared across multiple S8-style controllers
- Pattern: All changes in **one file** (easier to track and merge)
```

---

## AI-Assisted Feature Development

### Using AI Tools (Copilot, Claude) to Generate Code

Your feature documentation becomes a prompt for AI. Here's how to use it effectively:

### For Individual Features

**Step 1: Prepare Your Documentation**

Write your feature .md file (Steps 1-5 above: title, features, files, settings, testing).

### For Combining Multiple Mods

**When combining features from different mods**, use the standardized prompt:

**→ [MOD_COMBINATION_PROMPT.md](MOD_COMBINATION_PROMPT.md)**

This prompt helps you document which versions you're combining and identify conflicts. Copy it fresh each time (it updates as the versioning ecosystem evolves).

#### After AI Generates: Add Metadata Loc Filter File

When your combined QML is ready, add this metadata comment block at the **very top** of the file:

```qml
// --- MOD COMBINATION METADATA (Lock File) ---
// Generated: [DATE]
// Traktor Version: [YOUR VERSION]
// Last Updated: [DATE]
//
// Components Used:
// - [MOD NAME]: [VERSION] ([LINK])
// - [MOD NAME]: [VERSION] ([LINK])
//
// Update Notes:
// When a component updates, use: git diff [OLD_VERSION]..[NEW_VERSION]
// Then decide if you need the update.
// ---
```

This is like `package-lock.json` in software—when a mod updates:

1. Your metadata shows which version you used
2. Run `git diff` to see what changed
3. Decide: update or skip
4. Edit this comment if you update

This pattern is explained in [The Metadata Lock File Pattern](#the-metadata-lock-file-pattern-how-mods-connect-to-your-qml) section above.

### Step 2: Prompt the AI

Use a clear prompt like this:

```
I'm modifying Traktor QML files to implement a new feature.

Feature: Stem Mute Pads for S4 MK3

[PASTE YOUR FEATURE MARKDOWN FROM STEPS 1-5 ABOVE]

Settings section is provided above with MOD SETTINGS markers.

Please generate the code changes needed for CSI/Common/Deck_S8Style.qml following this pattern:

1. Add state properties to track stem mode and mute states
2. Modify the pad trigger handler to check stemMode first
3. If stemMode active: toggle stem mute or FX send based on Shift
4. If stemMode inactive: revert to original sample triggering
5. Add helper functions (toggleStemMute, toggleStemFxSend) at end

Show code in "Before:" and "After:" blocks as shown above.
```

### Step 3: Review AI Output

AI will generate code blocks. Check:

- **Settings markers**: Are `// --- MOD SETTINGS ---` exact?
- **Toggle switches**: Does every setting have a boolean flag?
- **Before/After blocks**: Can you see exactly what changed?
- **Code quality**: Is it English, meaningful names, no gibberish comments?
- **Documentation**: Does it reference external docs? (Should be self-contained)

### Step 4: Incorporate into Feature Doc

Copy AI's "Before/After" blocks into your feature .md file under Section 6 (Code Changes).

### Step 5: Test the Feature

See Testing Checklist (Step 7 above). If tests fail:

- Ask AI to debug
- Provide error messages from Traktor
- Ask AI to regenerate with fixes

### AI-Assisted Pattern Example: MOD SETTINGS

Here's the pattern AI should follow for centralized settings:

```qml
// --- MOD SETTINGS: Feature Name ---
MappingPropertyDescriptor {
    id: featureEnabledProp
    path: "app.traktor.settings.feature_name_enabled"
    initialValue: true
}
MappingPropertyDescriptor {
    id: featureParameter1Prop
    path: "app.traktor.settings.feature_param1"
    initialValue: 0.5
}
// --- END MOD SETTINGS ---
```

**Why this matters**: This pattern is machine-readable. Tools can:

- Automatically extract all settings
- Let users toggle features on/off in a UI
- Validate settings are in the right place

### Code Quality Standards

When using AI tools, enforce these standards:

1. **English only**: All variable names, comments, function names in English
   - ✓ `stemMuteToggle`, `toggleStemMute()`
   - ✗ `stampaMute`, `alterarMute()` (other languages)

2. **Meaningful names**: Names describe what they do
   - ✓ `function toggleStemMute(stemIndex)` (clear: toggles stem mute)
   - ✗ `function t(x)` (unclear)

3. **Minimal comments**: Let code speak for itself
   - ✓ Property name `stemMode` is self-documenting
   - ✗ Every line has comments (noise)

4. **Short docstrings only**: For complex functions, add one-liner docstring
   - ✓ `// Toggles mute state for specified stem (0-3) and updates Traktor API`
   - ✗ Multi-line comment block (belongs in documentation, not code)

5. **No external references**: All necessary code in feature .md
   - ✓ Helper functions defined in "Code Changes" section
   - ✗ "See file XYZ for stem detection" (user can't copy your code standalone)

---

## Feature Documentation Template

Use this template to structure your feature .md files:

````markdown
# [Controller] [Feature Name]

## What It Does

[One paragraph: what users experience. Can a non-programmer understand?]

## Features

- [Capability 1]
- [Capability 2]
- [Capability 3]

## Modified Files

- `File1.qml` (brief description of changes)
- `File2.qml` (brief description of changes)

## Configuration

### MOD Settings

[Code block with MOD SETTINGS markers]

### Pass Settings to Modules

[Code block showing how to pass settings to components]

## Code Changes

### In `File1.qml`

**Description of change** (e.g., "after the `stemMode` property", "in the `onPropertyChanged` handler"):

**Before:**

```qml
[exact code before]
```

**After:**

```qml
[exact code after, marked with // NEW comments]
```

### In `File2.qml`

[Repeat pattern for each file]

## Testing Checklist

- [ ] Test 1
- [ ] Test 2
- [ ] Test 3

## Compatibility

### Requires

- [Prerequisite feature or capability]

### Works Alongside

- [Compatible feature doc](URL with COMMIT HASH)

### Conflicts With

- [Incompatible feature or behavior]

### Tested On

- Controller + Traktor version

### NOT Tested On

- Controllers not tested

## Author Notes

[Optional: where this came from, extraction info, etc.]
````

---

## Single-File Modification Pattern (Best Practice)

### Why Keep Mods in One File?

**QML is declarative**, meaning code order is flexible—logic can be inserted anywhere that's syntactically correct. This is why **line numbers are implementation details**, not requirements.

When possible, keep all changes in a **single QML file**. This makes mods:

- **Easier to understand** (all logic in one place)
- **Easier to review** (one git diff instead of three)
- **Easier to merge** (fewer git conflicts when combining features)
- **Easier for AI** (concentrated code context)
- **Flexible for musicians** (they can reorganize code as needed)

### The S8-Style Architecture

The S8-style controllers (D2, Z1MK2, S4MK3, X1) share a common deck architecture:

- `CSI/Common/Deck_S8Style.qml` = shared deck logic for all S8-style controllers
- Mods go here → automatically apply to all S8-style controllers
- Each controller also has its own screen file but shares deck logic

Most features fit in `CSI/Common/Deck_S8Style.qml`. Example mods:

- Stem Mute Pads → one module file
- Colored Pads → one module file
- FX Depth Feedback → one module file

### When You Need Multiple Files

Some rare mods span multiple files. Document clearly:

```markdown
## Modified Files

- `CSI/S4MK3/S4MK3.qml` (MOD SETTINGS section)
- `CSI/Common/Deck_S8Style.qml` (main logic)
- `Screens/S4MK3/S4MK3_Screen.qml` (visual feedback)
```

**Avoid if possible**: Multi-file mods have higher conflict risk and are harder for users to understand.

### Controllers Beyond S8-Style

MX2, S3, S5, CDJ3000 have different architectures and usually require different mod patterns. Document clearly which controllers are supported:

```markdown
## Tested On

- S4 MK3 with Traktor 4.4.1
- Z1 MK2 with Traktor 4.4.1

## NOT Tested On

- MX2 (different pad architecture)
- S3, S5, CDJ3000 (not tested)
```

---

## Community Feature Registry

### How Features Get Indexed

When you submit a feature, it gets added to a mod repository's feature listing:

**Example: `FEATURES.md` in D2 mod repo**

```markdown
# D2 Performance Mod Features

## Pads

- [Stem Mute Pads](stem-mute-pads.md) — Pads mute stems instead of triggering samples
- [Colored Pads](colored-pads.md) — LED feedback shows pad state (muted, hot cue, etc.)
- [Shift Pad Menus](shift-pad-menus.md) — Shift+pads open custom menus

## Deck Display

- [FX Depth Feedback](fx-depth-feedback.md) — Numeric display of FX depth setting
- [Stem Level Meters](stem-level-meters.md) — Visual stems level display

## Navigation

- [Quick Preset Switch](quick-preset-switch.md) — Hotkeys to load presets
```

**Example: `COMPATIBILITY.md`**

```markdown
# D2 Feature Compatibility Matrix

## Pad Features (Conflict Risk)

| Feature         | Pads Used | Conflicts With                   |
| --------------- | --------- | -------------------------------- |
| Stem Mute Pads  | 1-4       | Pad Sample Triggers              |
| Colored Pads    | All       | Custom Pad Menus (manual choice) |
| Shift Pad Menus | Shift+1-8 | Other Shift behaviors            |

## Non-Conflicting Features (Safe to Combine)

- FX Depth Feedback + Stem Level Meters (different display areas)
- Quick Preset Switch + Pad features (different inputs)
```

### How to Get Your Feature Indexed

1. Create feature .md file (follow template above)
2. Submit to mod repository maintainer
3. They add it to FEATURES.md (listing) and COMPATIBILITY.md (conflicts)
4. Users can now discover and apply your feature

### Central Mod Directory

A simple directory shows where to find all mods:

```markdown
# Traktor Kontrol QML Mods

## D2

- **D2 Performance Mod v2.0** — 8 features for pads, deck, FX
  - Repo: github.com/author/traktor-kontrol-d2
  - Forum: NI Forum #12345
  - Features: [FEATURES.md](github.com/author/traktor-kontrol-d2/blob/HASH/FEATURES.md)

## X1MK3

- **X1MK3 Performance Mod v1.0** — 11 features for stems, FX, navigation
  - Repo: github.com/author/traktor-kontrol-x1mk3
  - Features: [FEATURES.md](github.com/author/traktor-kontrol-x1mk3/blob/HASH/FEATURES.md)

## S4MK3

- **S4 Performance Mod Collection** — Multi-controller features
  - Repo: github.com/author/traktor-s4mk3-mods
  - Forum: NI Forum #54321
```

One-click → user finds all D2 features and knows where they live.

---

## Real Example: X1MK3 Stem Mute Feature

Here's a real feature taken from the X1MK3 Performance Mod to show what good documentation looks like.

See: [X1MK3_stem-mute-pads.md](../X1MK3_TP4.4.1_PerformanceMod_12/stem-mute-pads.md)

Key points from this real example:

1. **Clear title**: "Stem Mute Pads for X1MK3" (not "stem feature mod thing")
2. **What it does**: One paragraph explaining user experience
3. **Features list**: Exactly what capabilities
4. **Modified files**: Just `CSI/Common/Deck_S8Style.qml` (single file!)
5. **Settings block**: Marked with exact `// --- MOD SETTINGS ---` delimiters
6. **Before/After blocks**: Each change shown explicitly
7. **Testing checklist**: Clear pass/fail tests
8. **Compatibility**: What it conflicts with, what it requires

This is the standard every feature should follow.

---

## Workflow: From Idea to Community

### For Feature Authors

1. **Idea** → Write feature .md documenting what user will see
2. **Code** → Implement in your QML setup, test thoroughly
3. **Documentation** → Create feature .md following template (Steps 1-9 above)
4. **Testing** → Run checklist, verify on hardware
5. **Submit** → Add to mod repository (fork/branch/PR)
6. **Community** → Users apply, give feedback, you iterate

### For Users Applying Features

1. **Find** → Browse mod repo's FEATURES.md
2. **Read** → Skim "What It Does" to understand
3. **Check** → Look at "Code Changes" to see impact
4. **Apply** → Copy code block or use AI assistance
5. **Test** → Run testing checklist
6. **Commit** → `git commit -m "Add X1MK3 stem mute pads"`

### For Maintainers

1. **Review** → Check feature .md follows template
2. **Test** → Run checklist on hardware
3. **Merge** → Accept feature submission
4. **Index** → Add to FEATURES.md and COMPATIBILITY.md
5. **Announce** → Link in mod repo README

---

## Common Pitfalls

### ❌ Pitfall 1: Settings Not Marked

```qml
// BAD: Settings scattered, no markers
var stemMuteEnabled = true;  // Somewhere in code
property bool useNewLogic: false;  // Somewhere else
```

**Fix**: Use exact markers:

```qml
// --- MOD SETTINGS: Feature Name ---
MappingPropertyDescriptor {
    id: stemMuteEnabledProp
    path: "app.traktor.settings.stem_mute_pads_enabled"
    initialValue: true
}
// --- END MOD SETTINGS ---
```

### ❌ Pitfall 2: No Toggle Switch

```qml
// BAD: Feature always on, no way to disable
if (stemMode) {
    toggleStemMute();
}
```

**Fix**: Always check a boolean:

```qml
// GOOD: User can disable in settings
if (stemMode && stemMuteToggleEnabled) {
    toggleStemMute();
}
```

### ❌ Pitfall 3: External Documentation References

Feature .md says: "For configuration, see the handbook chapter 02"

**Problem**: User can't apply feature standalone, must hunt for other docs.

**Fix**: Self-contained .md files. Include all code necessary.

```markdown
// Include everything they need, no external references

## Code Changes

### In CSI/Common/Deck_S8Style.qml

[All code here, no "see other doc"]
```

### ❌ Pitfall 4: Vague Compatibility Info

```markdown
## Compatibility

Works with most mods. Might conflict with FX features.
```

**Problem**: User doesn't know if they can combine features safely.

**Fix**: Explicit compatibility list:

```markdown
## Compatibility

### Works Alongside

- FX Depth Feedback (different display)
- Colored Pads (pads 5-8, no conflict)

### Conflicts With

- Custom Pad Menus (uses same pads 1-4)
```

### ❌ Pitfall 5: No Testing Checklist

**Problem**: User applies feature, doesn't know if it works.

**Fix**: Give exact steps:

```markdown
## Testing Checklist

- [ ] Load controller
- [ ] Enter Stem mode
- [ ] Press pad 1 → Verify stem 1 mutes/unmutes
- [ ] Check dashboard → FX indicator updates
```

### ❌ Pitfall 6: Multi-File Mods Without Clear Documentation

**Problem**: User applies one file, feature doesn't work, blames your code.

**Fix**: Clear multi-file documentation:

```markdown
## Modified Files

- `CSI/S4MK3/S4MK3.qml` (settings section)
- `CSI/Common/Deck_S8Style.qml` (mute logic)
- `Screens/S4MK3/S4MK3_Screen.qml` (LEDs)

All three files MUST be modified for feature to work.
```

### ❌ Pitfall 7: Branch URLs Instead of Commit Hashes

Feature docs link to: `github.com/author/repo/blob/main/feature.md`

**Problem**: Main branch updates, link now points to v2.0, user gets different feature than documented.

**Fix**: Use commit hash:

```markdown
// BAD
[My Dependency](https://github.com/author/repo/blob/main/feature.md)

// GOOD
[My Dependency](https://github.com/author/repo/blob/34be413abc/feature.md)
```

---

## Summary: Creating Shareable Mods

### Checklist: Your Feature is Ready to Share When...

- ✓ Feature .md file created with exact template
- ✓ Title clearly names feature and controller
- ✓ "What It Does" is one paragraph a non-programmer understands
- ✓ Features list shows specific capabilities
- ✓ Modified files listed clearly
- ✓ MOD SETTINGS section marked with exact delimiters
- ✓ Code changes shown in Before/After blocks with conceptual markers ("after X property", "in Y function")
- ✓ Testing checklist has concrete, testable steps
- ✓ Compatibility section lists conflicts and requirements
- ✓ All dependency URLs use commit hashes, not branches
- ✓ Documentation is self-contained (no external references)
- ✓ All code for applying feature is in the .md file
- ✓ Feature tested on actual hardware
- ✓ One feature per .md file (not multiple features combined)

### Next Steps

1. **Apply this template** to your next mod feature
2. **Get feedback** from a friend or community
3. **Submit** to a community mod repository
4. **Help others** apply your feature using this format

---

## Why This Approach (And Alternatives Considered)

This handbook recommends **semantic versioning + metadata lock files** for tracking mod combinations. This approach was selected after evaluating 8 different strategies:

### Approaches Considered and Why They Were Rejected

**Option 2: Branch-Based Stability** (separate branches per Traktor version)

- ❌ Requires maintaining multiple branches for each Traktor version
- ❌ Impossible for community mods (ZIP files, distributed sources)
- ❌ Steep learning curve for musician-contributors

**Option 3: Git Submodules** (pinning dependencies in source)

- ❌ Too complex for musicians who aren't professional developers
- ❌ `git clone`, `git pull` become complicated
- ❌ Incompatible with ZIP file distributions

**Option 4: Tags + Commit Hashes** (dual references for verification)

- ⚠️ Adds complexity without much benefit for this community
- ⚠️ Musicians don't need cryptographic verification; semantic versions suffice

**Option 5: Version Manifests** (JSON metadata files)

- ❌ Requires additional infrastructure
- ❌ Another file format to maintain and parse
- ❌ Simpler to track versions in QML comments

**Option 6: Time-Based Stability** ("known good" dated releases)

- ❌ Less clear than semantic versioning
- ❌ Musicians can't tell if "2026-03-01" is old or current
- ❌ Doesn't convey compatibility info (major vs. minor change)

**Option 7: Inline Code Snapshots** (embed full code in docs)

- ❌ Massive documentation bloat
- ❌ Hard to see actual changes across versions
- ❌ Difficult to use `git diff` to understand updates

### Why Semantic Versioning + Metadata Lock Files ✅

**Musicians understand version numbers** — They already use Traktor 4.4.1, firmware v2.3.0. The `v1.2.3` format is native to their vocabulary.

**Self-contained system** — No custom infrastructure required. Authors use GitHub releases (built-in). Musicians track versions in QML comments (no external tool).

**Enables incremental updates** — Metadata lock files let musicians understand what each component version does and update only what changed, without replacing entire setups.

**Works with any distribution** — Semantic versions work in GitHub repos, ZIP files, forum links, personal email — anywhere mods are shared.

**Community-proven** — WordPress (60,000 plugins), Node.js (millions of packages), Arduino (10,000+ libraries), and Max for Live all use semantic versioning successfully at scale.

**Graceful with incomplete adoption** — If some mods aren't versioned yet, the system still works. Unversioned mods use descriptive identifiers as fallback. No single point of failure.

### Referenced Standards

This approach follows community best practices from:

- **Semantic Versioning** (semver.org) — Version numbering convention
- **Package-Lock Pattern** — Metadata files for tracking component combinations (npm, pip, poetry)
- **GitHub Releases** — Standard versioning distribution mechanism
- **Git Tags** — Native version markers in version control

---

### Related Chapters

- **Chapter 08** — Sharing code changes (basic git workflow)
- **Chapter 09** _(this chapter)_ — How to document mods + metadata lock files
- **Chapter 10** — Using MOD_COMBINATION_PROMPT to combine mods and create metadata
- **Chapter 03** — Learning from community mods (where to find shared features)
- **Chapter 02** — API reference for property paths you'll document
