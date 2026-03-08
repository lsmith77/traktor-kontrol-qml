# Prompt: Design and Create a New Feature

**When to use**: You want to design and implement an entirely new feature from scratch — something that doesn't exist in any mod yet, or you want a custom variation. Use this to guide the conversation and produce implementation-ready code.

**Output**: Complete QML code + documentation + test checklist for your new feature.

**Workflow context**: [Chapter 09 — Mod Documentation Guide](../09_MOD_DOCUMENTATION_GUIDE.md)

---

## Before Running This Prompt

Think through your feature idea and describe it in natural language. Answer these questions:

1. **What does the feature do?** (Example: "Pressing PLAY while a deck is running triggers a vinyl brake effect that ramps tempo down over 700ms then stops")
2. **Which controller(s) does it target?** (Example: "D2, MX2", or "All controllers")
3. **Which UI element triggers it?** (Example: "PLAY button", "Jog wheel", "Pad 1", or "Shift+PLAY")
4. **What visual/audio feedback happens?** (Example: "PLAY button lights up during brake", "No feedback beyond normal Traktor behavior")
5. **Is it configurable?** (Example: "Yes, braking duration (default 700ms, range 120–1200ms)", or "No")
6. **Can it be toggled on/off?** (Example: "Yes, set vinyl_brake_enabled = false", or "No")
7. **What existing behaviors might it conflict with?** (Example: "Normal PLAY button behavior, auto-stop")
8. **Test checklist**: How would you verify this works? (3-5 simple steps)

---

## Example: Vinyl Brake Feature

If you're unsure how to describe your feature, use this as a template:

**Name**: Vinyl Brake on Stop

**Description**:

- Pressing PLAY while a deck is running triggers a fixed-duration brake that ramps `tempobend.stepless` from 0 to -1, then stops playback
- Pressing PLAY while the brake is active cancels it immediately and resumes playback
- Pressing PLAY on a stopped deck starts playback normally

**Target**: D2, all decks

**Trigger**: PLAY button

**Visual Feedback**:

- PLAY button stays lit during brake
- Waveform indicator shows tempo ramp (if visible)

**Configuration**:

- `vinyl_brake_delay_ms` (default 700ms, range 120–1200ms)
- Adjustable: edit the value in code or expose as preference

**Toggleable**:

- `vinyl_brake_enabled` (default true)
- Set to false to revert to standard instant-stop behavior

**Conflicts**:

- Normal PLAY/stop behavior (requires careful state management to avoid confusion)
- Auto-stop feature (if present, needs coordination)

**Test Checklist**:

1. Load a track, press PLAY, wait for deck to play, then press PLAY again → brake ramps over ~700ms, deck stops
2. Load a track, press PLAY, press PLAY again immediately (during brake) → playback resumes instantly
3. Load a stopped track, press PLAY → deck starts normally (no brake effect)
4. Edit `vinyl_brake_enabled = false` and restart Traktor → PLAY button behavior returns to standard stop

---

## How to Use This Prompt

1. **Prepare your feature description** using the template above
2. **Copy the prompt block below**
3. **Paste into Claude/Copilot**
4. **Provide your feature description** when prompted
5. **Specify the Traktor version and baseline** (e.g., "Traktor 4.4.1, use baseline from traktor-kontrol-qml-files tag 4.4.1")
6. **Optionally provide existing code** to build upon (e.g., a modified file from another mod)

---

## Prompt (copy and use as-is)

```
## Instructions for AI Assistant

### Configuration

QML_LINTER_COMMAND = ""  # Set to your linter command (see 01_BASICS.md#qml-linter for options)
# Example: "qml-linter ./qml/ --output-format compact"
# If left empty, linter validation will be skipped.

### Behavior

If QML_LINTER_COMMAND is set:

- **Generate syntactically valid QML** for the target Traktor version (include correct import versions)
- **If you have CLI access**: Run the linter directly on generated files and report results in format: `[filename]: [line] [error type] [message]`
- **If no CLI access**: Ask user to run the command and paste results in that format
- **Actively validate using output**: Review results and fix issues
- **Iterate until clean**: Continue until zero violations

---

You are an expert Traktor QML developer. Your task: design and implement a new feature based on a user's specification.

**Feature Specification** (provided by user):
[USER DESCRIPTION GOES HERE]

**Step 1: Clarify & Validate**

Before coding, confirm with the user:
- Is the feature description clear and complete?
- Which controller model(s) and Traktor version(s)?
- Any additional constraints or preferences?

**Step 2: Design**

Produce a brief design document:
- How will the feature be triggered? (UI element, key combo, condition)
- What handlers/signals need to be modified or created?
- Which files will need changes?
- Are there dependencies on other features/modules?
- What state variables are needed? (defaults, types, ranges)
- Describe edge cases (what if user clicks during brake? what if deck stops externally?)

**Step 3: Implement**

Generate complete, production-ready QML code:
- Include all necessary imports and context
- Add inline comments explaining key logic
- Include configurable parameters with defaults
- Ensure proper state management and cleanup
- Handle edge cases gracefully

**Step 4: Document**

Create a feature documentation file (markdown format):
- **Feature Name**: [name]
- **Description**: What it does (2-3 sentences)
- **Traktor Version**: Tested on
- **Controllers**: Supported models
- **Trigger**: How to activate
- **Configuration**: Adjustable parameters + defaults
- **Toggle**: On/off setting + how to disable
- **Test Checklist**: 3-5 verification steps
- **Code Location**: Which files were modified
- **Settings/Toggles**: All variables user can adjust

**Step 5: Testing Guidance**

Provide clear test instructions:
- How to enable the feature
- Step-by-step verification (normal use, edge cases, disabled state)
- Expected behavior for each step
- How to troubleshoot if it doesn't work

**Output Format**:

1. Design document (outline)
2. Complete QML code (copy-paste ready)
3. Feature documentation (markdown, ready to save)
4. Test checklist with expected results
```

---

## Tips for a Better Prompt Response

- **Be specific about behavior**: Instead of "play fast backwards", describe: "set tempobend.stepless = -1 during 500ms ramp"
- **Mention the controller**: D2, X1MK3, S4MK3, etc. (behavior differs per model)
- **List edge cases**: What if user presses during the effect? What if they load a new track?
- **Specify UI feedback**: Should buttons light up? Should screen show anything?
- **Include config values**: Default vs. range; should users be able to adjust these?

---

## After Getting Code

1. **Review the generated code** for accuracy and completeness
2. **Lint the code** using `qmllint` to check for style issues and potential bugs
3. **Test in Traktor** using the provided test checklist
4. **Save the markdown documentation** alongside your feature code
5. **Version it**: Use semantic versioning (e.g., v1.0.0 for first release)

See [Chapter 09: Mod Documentation Guide](../09_MOD_DOCUMENTATION_GUIDE.md) for how to document and version your feature properly.
