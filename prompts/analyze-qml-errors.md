# Analyze QML Startup Errors

**Purpose**: Parse and categorize QML errors from Traktor startup console output
**Use when**: You've captured startup errors from running Traktor in Terminal and need to understand what's broken

---

## How to Use This Prompt

1. Run Traktor from Terminal and capture the output (see [04_TROUBLESHOOTING.md](../04_TROUBLESHOOTING.md#1-run-traktor-from-terminal-and-check-startup-errors-does-it-compile))
2. Copy the entire Terminal output or save it to a file
3. Paste the output into this prompt along with your request
4. Ask the AI to analyze the errors

---

## Example Request

**Paste into GitHub Copilot Chat or your AI assistant:**

```
Analyze these QML startup errors from Traktor Pro 4.

For each error, identify:
1. The file that needs fixing
2. The line number and what's wrong (syntax, undefined variable, missing file, type mismatch, etc.)
3. The likely cause based on the error message
4. A brief fix (if obvious)

Here's the output:

[PASTE YOUR TRAKTOR STARTUP ERRORS HERE]
```

---

## What the AI Will Do

The AI will:

1. **Categorize errors** by type:
   - ReferenceError (undefined variables/properties)
   - File not found (missing images, imports, etc.)
   - Type mismatches (assigning wrong type to property)
   - Binding loops (circular dependencies)
   - Syntax errors (malformed QML)

2. **Prioritize by severity**:
   - Critical (prevents Traktor from starting)
   - Major (breaks functionality)
   - Minor (visual glitches, warnings)

3. **Suggest fixes** with code examples where applicable

4. **Group by file** so you know which files to edit and in what order

---

## Example Output Format

The AI might organize the analysis like:

**File: qml/CSI/X1MK3/X1MK3.qml**

- Line 281, 417, 485: `ReferenceError: fx_section is not defined`
  - Cause: Variable name is `fxSection` (camelCase), not `fx_section`
  - Fix: Replace `fx_section` → `fxSection`

**File: qml/Screens/X1MK3/FXScreen.qml**

- Line 927-928: `ReferenceError: faderSoftTakeoverDirection is not defined`
  - Cause: Property never declared; used but not defined
  - Fix: Add `MappingProperty` and `property alias` definitions

**File: qml/Screens/X1MK3/ModeScreen.qml**

- Line 101, 111: `QML Image: Cannot open: file:///...undefined_A.png`
  - Cause: `leftFxIdx` and `rightFxIdx` are undefined on initialization
  - Fix: Add null checks to image source bindings

---

## Tips for Sharing Errors with AI

- **Include full error messages** — Line numbers, file paths, and error text are crucial
- **Include context** — What were you testing? What mod did you install?
- **Include the file** — If you have a small file with errors, paste the relevant QML code too
- **Ask for priorities** — "Which errors are most critical to fix first?"

---

## For Developers: Interpreting Error Types

| Error Type                             | Meaning                                         | Common Fix                                                       |
| -------------------------------------- | ----------------------------------------------- | ---------------------------------------------------------------- |
| `ReferenceError: X is not defined`     | Variable/property `X` doesn't exist             | Check spelling, verify property is declared/imported             |
| `Cannot open: file:///.../X.png`       | Image file not found, often `undefined` in path | Add null check to file path binding                              |
| `Cannot assign [undefined] to QString` | Trying to assign undefined to string property   | Initialize property with default value or check before assigning |
| `Binding loop detected`                | Property binding creates circular dependency    | Remove one of the circular bindings, use `when:` conditions      |
| `Property X not found`                 | QML type doesn't have property X                | Check property name, verify correct import/type                  |
