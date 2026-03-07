#!/bin/bash
# install-traktor-mod.sh — Install a QML overlay mod into Traktor Pro 4 (macOS)
#
# Synopsis:
#   Merges QML overlay mods into Traktor's live qml folder with backup and restore support.
#   Supports three modes: stack (merge), fresh (reset), and symlink (dev mode).
#   No reinstall needed when using symlink mode — just restart Traktor after edits.
#
# Usage:
#   install-traktor-mod                                      — merge mod on top of current live qml (stack mode)
#   install-traktor-mod --fresh                              — restore stock first, then merge mod (clean mode)
#   install-traktor-mod --symlink                            — symlink mod files into live qml (dev mode)
#   install-traktor-mod --fresh --symlink                    — restore stock first, then symlink mod files
#   install-traktor-mod restore                              — restore stock qml and remove all mods/symlinks
#
# Specifying source directory (optional; defaults to current directory):
#   install-traktor-mod --source /path/to/mod                - use specific directory
#   install-traktor-mod -s ../traktor-kontrol-d2 --fresh     — use subdirectory, fresh mode
#   install-traktor-mod -s ~/my-mod --symlink                — use home directory, symlink mode
#
# Help:
#   install-traktor-mod -h                                   — show this help text
#   install-traktor-mod --help                               — show this help text
#
# Stack mode (default): copies mod files into Traktor's live qml. Other installed mods remain.
#
# Fresh mode (--fresh): resets qml to stock first, then applies only this mod.
#
# Symlink mode (--symlink): creates symlinks in Traktor's qml pointing back to the files
# in this mod repo. Edit a file in your repo and restart Traktor — no reinstall needed.
# Useful during active development. Combine with --fresh for an isolated dev environment.
# Note: symlinks use absolute paths; moving this repo will break them (run again to fix).
#
# Restore: replaces the live qml with the stock backup, removing ALL mods and symlinks.
# There is no "undo just this mod" — restore always goes back to stock.
#
# The stock backup is created on first install and never overwritten. After 'restore' the
# backup is removed (moved back to qml), so the next install creates a fresh one.
#
# Install this script to your PATH once, then use it from any mod directory.
# See 08_SHARING_CHANGES.md for setup instructions.

set -e

show_help() {
    cat << 'EOF'
install-traktor-mod — Install QML mods into Traktor Pro 4 (macOS)

Two installation modes available:

OVERLAY MODE (default):
  Merges QML changes on top of existing qml. Use this to combine multiple mods.
  Supports three sub-modes: stack, fresh, and symlink.

FULL REPLACEMENT MODE (--full):
  Replaces entire qml with mod's qml. Use for complete standalone mods.
  Other mods are overwritten; not suitable for combining.
  Supports copy and symlink sub-modes.

Overlay Mode Usage:
  install-traktor-mod                        — merge mod (default)
  install-traktor-mod --fresh                — reset to stock first, then merge
  install-traktor-mod --symlink              — symlink mode (dev)
  install-traktor-mod --fresh --symlink      — reset stock, then symlink

Full Replacement Mode Usage:
  install-traktor-mod --full                 — replace entire qml
  install-traktor-mod --full --symlink       — replace with symlinks (dev mode)
  install-traktor-mod --full --fresh         — reset stock first, then replace
  install-traktor-mod --full --fresh --symlink — reset stock, then symlink with replacement

General Options:
  install-traktor-mod restore                — restore stock qml, remove all mods
  install-traktor-mod -s /path/to/mod        — use specific directory
  install-traktor-mod -h                     — show this help

Notes:
  - Backup created on first install (never overwritten)
  - Restore returns to stock and removes all mods/symlinks
  - Symlinks use absolute paths; moving repo breaks them (run again to fix)
EOF
}

# Check for help flag early
for arg in "$@"; do
    if [ "$arg" = "-h" ] || [ "$arg" = "--help" ]; then
        show_help
        exit 0
    fi
done

TRAKTOR_RESOURCES="/Applications/Native Instruments/Traktor Pro 4/Traktor Pro 4.app/Contents/Resources"
TRAKTOR_QML="$TRAKTOR_RESOURCES/qml"
TRAKTOR_QML_BACKUP="$TRAKTOR_RESOURCES/qml.mod-backup"
TRAKTOR_APP="/Applications/Native Instruments/Traktor Pro 4/Traktor Pro 4.app"

check_traktor_installed() {
    if [ ! -d "$TRAKTOR_QML" ]; then
        echo "Error: Traktor Pro 4 not found at expected path."
        echo "  Expected: $TRAKTOR_QML"
        echo "  If Traktor is installed elsewhere, edit TRAKTOR_RESOURCES in this script."
        exit 1
    fi
}

# --- parse args ---

FRESH=false
SYMLINK=false
FULL=false
MODE="install"
SOURCE_DIR="."

while [ $# -gt 0 ]; do
    arg="$1"
    case "$arg" in
        restore)   MODE="restore"; shift ;;
        --fresh)   FRESH=true; shift ;;
        --symlink) SYMLINK=true; shift ;;
        --full)    FULL=true; shift ;;
        -h|--help) show_help; exit 0 ;;
        -s|--source)
            shift
            if [ -z "$1" ] || [[ "$1" =~ ^- ]]; then
                echo "Error: -s/--source requires a directory path"
                exit 1
            fi
            SOURCE_DIR="$1"
            shift
            ;;
        *)
            echo "Unknown argument: $arg"
            exit 1
            ;;
    esac
done

if ! RESOLVED_SOURCE="$(cd "$SOURCE_DIR" 2>/dev/null && pwd)"; then
    echo "Error: Cannot access source directory: $SOURCE_DIR"
    exit 1
fi
if [ -z "$RESOLVED_SOURCE" ]; then
    echo "Error: Cannot access source directory: $SOURCE_DIR"
    exit 1
fi
MOD_QML="$RESOLVED_SOURCE/qml"

# --- restore ---

if [ "$MODE" = "restore" ]; then
    check_traktor_installed
    if [ ! -d "$TRAKTOR_QML_BACKUP" ]; then
        echo "No backup found at: $TRAKTOR_QML_BACKUP"
        echo "Cannot restore — was the mod installed with this script?"
        exit 1
    fi
    echo "Restoring stock qml from backup..."
    sudo rm -rf "$TRAKTOR_QML"
    sudo mv "$TRAKTOR_QML_BACKUP" "$TRAKTOR_QML"
    echo "Done. Restart Traktor to apply."
    exit 0
fi

# --- install ---

check_traktor_installed

if [ ! -d "$MOD_QML" ]; then
    RESOLVED_PATH="$(cd "$SOURCE_DIR" 2>/dev/null && pwd 2>/dev/null)" || RESOLVED_PATH="<unresolvable>"
    echo "Error: No 'qml' folder found."
    echo "  Source: $SOURCE_DIR"
    echo "  Resolved: $RESOLVED_PATH"
    echo "  Looking for: $MOD_QML"
    echo ""
    echo "Make sure the mod directory contains a 'qml' subfolder with your changes."
    exit 1
fi

# Create backup on first install (only when it doesn't exist yet)
if [ ! -d "$TRAKTOR_QML_BACKUP" ]; then
    echo "Creating backup of stock qml..."
    sudo cp -r "$TRAKTOR_QML" "$TRAKTOR_QML_BACKUP"
    echo "  Backup saved: $TRAKTOR_QML_BACKUP"
else
    echo "Backup exists: $TRAKTOR_QML_BACKUP"
fi

# In fresh mode, reset live qml to stock before applying
if [ "$FRESH" = "true" ]; then
    echo "Fresh mode: resetting live qml to stock..."
    sudo rsync -a --delete "$TRAKTOR_QML_BACKUP/" "$TRAKTOR_QML/"
fi

if [ "$FULL" = "true" ]; then
    if [ "$SYMLINK" = "true" ]; then
        echo "Full replacement mode (symlinks): symlinking entire mod qml into Traktor..."
        sudo rm -rf "$TRAKTOR_QML"
        MOD_QML_ABS="$(cd "$MOD_QML" && pwd)"
        sudo ln -s "$MOD_QML_ABS" "$TRAKTOR_QML"
        echo "Done."
        echo ""
        echo "Symlink: $TRAKTOR_QML -> $MOD_QML_ABS"
        echo "Edit files there and restart Traktor — no reinstall needed."
    else
        echo "Full replacement mode: replacing entire qml with mod's qml..."
        sudo rm -rf "$TRAKTOR_QML"
        sudo cp -r "$MOD_QML" "$TRAKTOR_QML"
        echo "Done."
    fi
elif [ "$SYMLINK" = "true" ]; then
    echo "Installing mod (symlinking overlay files into Traktor qml)..."
    while IFS= read -r -d '' src; do
        rel="${src#${MOD_QML}/}"
        dst="$TRAKTOR_QML/$rel"
        sudo mkdir -p "$(dirname "$dst")"
        sudo rm -f "$dst"
        sudo ln -s "$src" "$dst"
    done < <(find "$MOD_QML" -type f -print0)
    echo "Done."
    echo ""
    echo "Symlinks point to: $MOD_QML"
    echo "Edit files there and restart Traktor — no reinstall needed."
else
    echo "Installing mod (merging overlay into Traktor qml)..."
    sudo rsync -a "$MOD_QML/" "$TRAKTOR_QML/"
    echo "Done."
fi

echo ""
echo "To undo all mods:  install-traktor-mod restore"

read -rp "Launch Traktor now? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    open "$TRAKTOR_APP"
fi
