#!/bin/bash
# NOTE: This script is vibe coded via AI with minimal code review. Use with caution and review before production use.
# traktor-mod.sh — Install a QML overlay mod into Traktor Pro 4 (macOS)
#
# Synopsis:
#   Merges QML overlay mods into Traktor's live qml folder with backup and restore support.
#   Supports overlay modes (stack, fresh, symlink) and full replacement mode (--full).
#   No reinstall needed when using symlink mode — just restart Traktor after edits.
#
# Usage:
#   traktor-mod                                      — merge mod on top of current live qml (stack mode)
#   traktor-mod --fresh                              — restore stock first, then merge mod (clean mode)
#   traktor-mod --symlink                            — symlink mod files into live qml (dev mode)
#   traktor-mod --fresh --symlink                    — restore stock first, then symlink mod files
#   traktor-mod --full                               — replace entire qml with mod's qml
#   traktor-mod --full --symlink                     — symlink entire mod qml into Traktor (dev mode)
#   traktor-mod restore                              — restore stock qml and remove all mods/symlinks
#   traktor-mod restore --pull                       — fetch stock qml from GitHub (when backup is missing or to force a refresh)
#
# Specifying source directory (optional; defaults to current directory):
#   traktor-mod --source /path/to/mod                - use specific directory
#   traktor-mod -s ../traktor-kontrol-d2 --fresh     — use subdirectory, fresh mode
#   traktor-mod -s ~/my-mod --symlink                — use home directory, symlink mode
#
# Logger and server commands:
#   traktor-mod logger pull                          — download latest stable traktor-logger release
#   traktor-mod logger pull --tag v1.2.0             — pull a specific release tag
#   traktor-mod logger pull --branch dev             — pull from a specific branch
#   traktor-mod logger pull --source /path/to/logger — copy from local directory
#   traktor-mod logger pull --symlink --source /path — symlink local logger directory into cache
#   traktor-mod server start                         — launch traktor-logger server on localhost:8080
#   traktor-mod logger api D2                        — inject ApiModule into one controller file
#
# Help:
#   traktor-mod -h                                   — show this help text
#   traktor-mod --help                               — show this help text
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
set -o pipefail

show_help() {
    cat << 'EOF'
traktor-mod — Install QML mods into Traktor Pro 4 (macOS)

Two installation modes available:

OVERLAY MODE (default):
  Merges QML changes on top of existing qml. Use this to combine multiple mods.
  Supports three sub-modes: stack, fresh, and symlink.

FULL REPLACEMENT MODE (--full):
  Replaces entire qml with mod's qml. Use for complete standalone mods.
  Other mods are overwritten; not suitable for combining.
  Supports copy and symlink sub-modes.

Overlay Mode Usage:
  traktor-mod                        — merge mod (default)
  traktor-mod --fresh                — reset to stock first, then merge
  traktor-mod --symlink              — symlink mode (dev)
  traktor-mod --fresh --symlink      — reset stock, then symlink

Full Replacement Mode Usage:
  traktor-mod --full                 — replace entire qml
  traktor-mod --full --symlink       — replace with symlinks (dev mode)
  traktor-mod --full --fresh         — reset stock first, then replace
  traktor-mod --full --fresh --symlink — reset stock, then symlink with replacement

Standalone Commands:
  traktor-mod logger pull            — download latest stable traktor-logger release from GitHub
  traktor-mod server start           — launch traktor-logger server on localhost:8080
  traktor-mod logger api D2          — inject ApiModule into one controller file
  traktor-mod restore                — restore stock qml from backup, remove all mods
  traktor-mod restore --pull         — fetch stock qml from GitHub (ignores backup)

  Logger cache options (used with 'logger pull'):
    --tag <name>                             — pull a specific release tag (e.g. v1.2.0)
    --branch <name>                          — pull from a specific branch instead of latest release
    --source /path/to/logger                 — copy from a local traktor-logger directory
    --symlink (with --source)                — symlink local directory into cache instead of copying

  Logger and Api modules use hybrid fallback chain:
    1. Cached ~/.traktor-mod/traktor-logger/ (offline after first download)
    2. GitHub download (initial setup, requires internet)

General Options:
  traktor-mod -s /path/to/mod        — use specific directory
  traktor-mod -h                     — show this help

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

# Run a command with sudo if $TRAKTOR_QML is not writable by the current user.
# Used for writes *into* qml subdirectories — when qml is a user-owned symlink
# no sudo is needed; when it is a root-owned directory sudo is required.
qml_cmd() {
    if [ -w "$TRAKTOR_QML" ]; then
        "$@"
    else
        sudo "$@"
    fi
}

check_traktor_installed() {
    if [ ! -d "$TRAKTOR_QML" ]; then
        echo "Error: Traktor Pro 4 not found at expected path."
        echo "  Expected: $TRAKTOR_QML"
        echo "  If Traktor is installed elsewhere, edit TRAKTOR_RESOURCES in this script."
        exit 1
    fi
}

# --- logger utility (hybrid: local → cached → github) ---



get_logger_qml() {
    # Returns path to Logger.qml using hybrid fallback chain: cache → GitHub
    local logger_path="$SERVER_CACHE_DIR/qml/Defines/Logger.qml"
    local logger_url="$SERVER_GITHUB_REPO/qml/Defines/Logger.qml"
    # 1. Check cache (for offline use, one-time download)
    if [ -f "$logger_path" ]; then
        echo "$logger_path"
        return 0
    fi
    # 2. Download from GitHub (first-time setup, requires internet)
    echo "Downloading Logger.qml from GitHub..." >&2
    mkdir -p "$(dirname "$logger_path")"
    if ! curl -sS -o "$logger_path" "$logger_url"; then
        echo "Error: Failed to download Logger.qml from GitHub" >&2
        echo "URL: $logger_url" >&2
        return 1
    fi
    echo "Downloaded to: $logger_path" >&2
    echo "$logger_path"
    return 0
}


# --- traktor-logger server caching (metadata + manual logging system) ---

SERVER_CACHE_DIR="$HOME/.traktor-mod/traktor-logger"

_fetch_latest_traktor_logger_tag() {
    # Returns the tag_name of the latest release, or empty string if none
    local api_url="https://api.github.com/repos/lsmith77/traktor-logger/releases/latest"
    local release_json
    if ! release_json=$(curl -sS --fail "$api_url" 2>/dev/null); then
        return 1
    fi
    echo "$release_json" | grep '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]*)".*/\1/' | head -1
}

_download_traktor_logger_from_github() {
    # Download entire traktor-logger repo from GitHub as a tarball
    # $1: ref value (branch name or tag name)
    # $2: ref type — "heads" (branch) or "tags" (tag), defaults to "heads"
    local ref="$1"
    local ref_type="${2:-heads}"
    local archive_url="https://github.com/lsmith77/traktor-logger/archive/refs/${ref_type}/${ref}.tar.gz"
    echo "Downloading traktor-logger from: $archive_url" >&2
    rm -rf "$SERVER_CACHE_DIR"
    mkdir -p "$SERVER_CACHE_DIR"
    if ! curl -sS -L "$archive_url" | tar xz --strip-components=1 -C "$SERVER_CACHE_DIR"; then
        echo "Error: Failed to download traktor-logger from GitHub" >&2
        rm -rf "$SERVER_CACHE_DIR"
        return 1
    fi
    chmod +x "$SERVER_CACHE_DIR/server.py" 2>/dev/null || true
    return 0
}

get_server_package() {
    # Returns path to cached traktor-logger or downloads it
    # Uses hybrid chain: local repo → cache → GitHub

    # 1. Check if src is specified and contains traktor-logger
    if [ -d "$SOURCE_DIR/traktor-logger" ]; then
        echo "$SOURCE_DIR/traktor-logger"
        return 0
    fi

    # 2. Check cache (presence of qml/Defines/Logger.qml implicitly requires v1.2.0+ layout)
    if [ -f "$SERVER_CACHE_DIR/server.py" ] && [ -f "$SERVER_CACHE_DIR/qml/Defines/Logger.qml" ]; then
        echo "$SERVER_CACHE_DIR"
        return 0
    fi

    # 3. Download from GitHub
    if ! _download_traktor_logger_from_github "$BRANCH" "$BRANCH_REF_TYPE" >&2; then
        return 1
    fi
    echo "Downloaded to: $SERVER_CACHE_DIR" >&2
    echo "$SERVER_CACHE_DIR"
    return 0
}


get_server_path() {
    # Get path to server.py (local, cached, or download)
    local server_dir
    if ! server_dir=$(get_server_package); then
        return 1
    fi
    echo "$server_dir/server.py"
    return 0
}

get_api_modules_path() {
    # Get path to Api modules directory
    local server_dir
    if ! server_dir=$(get_server_package); then
        return 1
    fi
    echo "$server_dir/qml/CSI/Common/Api"
    return 0
}

get_screen_modules_path() {
    # Get path to Screens/Common directory (contains ApiBrowser for screen-capable controllers)
    local server_dir
    if ! server_dir=$(get_server_package); then
        return 1
    fi
    echo "$server_dir/qml/Screens/Common"
    return 0
}

enable_metadata_for_traktor() {
    # Enable metadata for Traktor's installed qml (standalone operation)
    # Injects ApiModule into a single controller file
    # Note: Api modules must be installed first via 'logger pull' + '--source ~/.traktor-mod/traktor-logger'
    local controller_list="$1"

    if [ -z "$controller_list" ]; then
        echo "Error: No controller specified for metadata"
        return 1
    fi
    
    check_traktor_installed
    
    # Verify Api modules are already installed in Traktor qml
    if [ ! -d "$TRAKTOR_QML/CSI/Common/Api" ] || [ -z "$(ls -A "$TRAKTOR_QML/CSI/Common/Api" 2>/dev/null)" ]; then
        echo "Error: Api modules not found in Traktor qml"
        echo ""
        echo "Install them first with:"
        echo "  traktor-mod logger pull"
        echo "  traktor-mod --source ~/.traktor-mod/traktor-logger"
        return 1
    fi

    # Install Screens/Common/ApiBrowser.qml (required for browser monitoring)
    local screen_src
    if screen_src=$(get_screen_modules_path) && [ -d "$screen_src" ]; then
        qml_cmd mkdir -p "$TRAKTOR_QML/Screens/Common"
        qml_cmd cp -r "$screen_src/." "$TRAKTOR_QML/Screens/Common/"
        echo "  ✓ Screens/Common: browser modules installed"
    else
        echo "  ⚠ Screens/Common source not found — browser monitoring may be unavailable"
    fi

    # Enable CSI metadata collection per-controller
    enable_metadata_for_controllers "$controller_list" "$TRAKTOR_QML"
    # Enable browser monitoring in all Screen.qml files (shared across controllers)
    enable_browser_in_all_screens "$TRAKTOR_QML"

    if echo "$controller_list" | grep -qi "^S8$"; then
        echo ""
        echo "Configure Traktor S8 Controller (only needed if no physical S8 is connected)"
        echo ""
        echo "  Traktor only loads a controller's QML when it is registered."
        echo "  Add S8 as a pre-mapped controller:"
        echo ""
        echo "  1. Launch Traktor Pro"
        echo "  2. Go to Preferences (Cmd+, on macOS or Ctrl+, on Windows)"
        echo "  3. Select the Controller Manager tab"
        echo "  4. Click Add > Pre-Mapped > Traktor Kontrol > S8"
        echo ""
    fi
}

enable_metadata_for_controllers() {
    # Enable metadata collection for a single controller
    # Uses safe insertion with validation to prevent file corruption
    local controller_list="$1"
    local target_dir="${2:-$TRAKTOR_QML}"

    if [ -z "$controller_list" ]; then
        echo "Error: No controller specified for metadata"
        return 1
    fi

    echo "Enabling metadata collection for controller: $controller_list"
    echo "Target: $target_dir"

    for controller in "$controller_list"; do
        controller=$(echo "$controller" | xargs)  # trim whitespace
        local controller_file="$target_dir/CSI/${controller}/${controller}.qml"
        
        if [ ! -f "$controller_file" ]; then
            echo "  ⚠ $controller: file not found ($controller_file)"
            continue
        fi
        
        # Check if ApiModule is already instantiated (idempotent)
        if grep -q "ApiModule" "$controller_file"; then
            echo "  ✓ $controller: metadata already enabled"
            continue
        fi
        
        # Step 1: Ensure import for ApiModule is present (add if missing)
        if ! grep -q 'import.*"\.\./Common/Api"' "$controller_file"; then
            # Use awk to insert import after last import statement
            local temp_file
            temp_file=$(mktemp /tmp/traktor-mod.XXXXXX)
            awk '
                /^import / {
                    print $0
                    need_import = 1
                    next
                }
                need_import && !/^import / && !/^$/ {
                    # First non-import, non-blank line after imports
                    print "import \"../Common/Api\""
                    print $0
                    need_import = 0
                    next
                }
                { print }
            ' "$controller_file" > "$temp_file"

            qml_cmd mv "$temp_file" "$controller_file"
            echo "  → Added import for ApiModule"
        fi

        # Step 2: Inject ApiModule into Mapping block
        local temp_file
        temp_file=$(mktemp /tmp/traktor-mod.XXXXXX)
        awk '
            /^Mapping\s*$/ {
                # "Mapping" on its own line - look for opening brace next
                print $0
                getline
                print $0
                if ($0 ~ /^\s*{/) {
                    print "  // Automatic metadata collection"
                    print "  ApiModule {}"
                }
                next
            }
            /^\s*Mapping\s*{/ {
                # "Mapping {" on same line
                print $0
                print "  // Automatic metadata collection"
                print "  ApiModule {}"
                next
            }
            { print }
        ' "$controller_file" > "$temp_file"
        
        # Validate the injection was actually inserted
        if ! grep -q "ApiModule" "$temp_file"; then
            echo "  ✗ $controller: injection failed — ApiModule not found in output"
            rm -f "$temp_file"
            continue
        fi
        
        # Replace original with temp
        qml_cmd mv "$temp_file" "$controller_file"
        echo "  ✓ $controller: metadata enabled (validated)"
    done

    return 0
}

enable_browser_in_all_screens() {
    # Inject ApiBrowser into every Screen.qml found under the Screens/ directory.
    # Screen files are shared across controllers (e.g. D2 and S8 both use Screens/S8/Views/Screen.qml),
    # so we inject into all of them rather than guessing a per-controller path.
    local target_dir="${1:-$TRAKTOR_QML}"
    local screens_dir="$target_dir/Screens"

    if [ ! -d "$screens_dir" ]; then
        echo "  ⚠ No Screens directory found at $screens_dir — browser monitoring skipped"
        return 0
    fi

    local found=0
    while IFS= read -r screen_file; do
        found=1

        # Idempotent check
        if grep -q "ApiBrowser" "$screen_file"; then
            echo "  ✓ ${screen_file#$target_dir/}: browser monitoring already enabled"
            continue
        fi

        # Compute the import path to Screens/Common relative to this Screen.qml's directory.
        # e.g. Screens/S4MK3/Screen.qml      → ../Common
        #      Screens/S8/Views/Screen.qml   → ../../Common
        local rel_dir
        rel_dir=$(dirname "${screen_file#$screens_dir/}")
        local depth
        depth=$(echo "$rel_dir" | tr -cd '/' | wc -c)
        local import_path
        import_path=$(printf '../%.0s' $(seq 1 $((depth + 1))))Common

        # For multi-screen controllers (those with isLeftScreen), only the left
        # instance should send to avoid duplicate POSTs.
        local browser_instance='  LoggerScreens.ApiBrowser {}'
        if grep -q "isLeftScreen" "$screen_file"; then
            browser_instance='  LoggerScreens.ApiBrowser { active: isLeftScreen }'
        fi

        # Step 1: Add import for Screens/Common if not already present
        local import_quoted="\"${import_path}\""
        if ! grep -q "\"${import_path}\"" "$screen_file" && ! grep -q "'${import_path}'" "$screen_file"; then
            local temp_file
            temp_file=$(mktemp /tmp/traktor-mod.XXXXXX)
            awk -v imp="import ${import_quoted} as LoggerScreens" '
                /^import / {
                    print $0
                    need_import = 1
                    next
                }
                need_import && !/^import / && !/^$/ {
                    print imp
                    print $0
                    need_import = 0
                    next
                }
                { print }
            ' "$screen_file" > "$temp_file"
            qml_cmd mv "$temp_file" "$screen_file"
        fi

        # Step 2: Inject ApiBrowser after the first { that follows all import lines.
        # That { is always the root Item's opening brace in a Screen.qml file.
        # Avoids \s which is not portable across awk implementations (BSD awk on macOS).
        local temp_file
        temp_file=$(mktemp /tmp/traktor-mod.XXXXXX)
        awk -v component="$browser_instance" '
            BEGIN { past_imports = 0; done = 0 }
            /^import /  { past_imports = 1; print; next }
            past_imports && !done && /\{/ {
                print
                print component
                done = 1
                next
            }
            { print }
        ' "$screen_file" > "$temp_file"

        # Validate that ApiBrowser was actually inserted
        if ! grep -q "ApiBrowser" "$temp_file"; then
            echo "  ✗ ${screen_file#$target_dir/}: injection failed — ApiBrowser not found in output, skipping"
            rm -f "$temp_file"
            continue
        fi

        qml_cmd mv "$temp_file" "$screen_file"
        echo "  ✓ ${screen_file#$target_dir/}: browser monitoring enabled"
    done < <(find "$screens_dir" -name "Screen.qml" 2>/dev/null)

    if [ "$found" -eq 0 ]; then
        echo "  ⚠ No Screen.qml files found under $screens_dir — browser monitoring skipped"
    fi

    return 0
}



# --- restore from GitHub helpers ---

detect_traktor_version() {
    # Try to read the installed Traktor version from the app bundle Info.plist
    if [ -f "$TRAKTOR_APP/Contents/Info.plist" ]; then
        defaults read "$TRAKTOR_APP/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || true
    fi
}

fetch_qml_tags_from_github() {
    # Return available tags (one per line) from traktor-kontrol-qml-files repo
    local api_url="https://api.github.com/repos/lsmith77/traktor-kontrol-qml-files/tags?per_page=100"
    local tags_json
    if ! tags_json=$(curl -sS --fail "$api_url" 2>/dev/null); then
        return 1
    fi
    # Extract tag names without jq
    echo "$tags_json" | grep '"name"' | sed -E 's/.*"name": *"([^"]*)".*/\1/'
}

restore_from_github() {
    local api_url="https://api.github.com/repos/lsmith77/traktor-kontrol-qml-files/tags?per_page=100"
    echo "Fetching available QML versions from: $api_url"
    local tags_raw
    if ! tags_raw=$(fetch_qml_tags_from_github); then
        echo "Error: Could not fetch available versions from GitHub."
        echo "  Check your internet connection and try again."
        return 1
    fi
    if [ -z "$tags_raw" ]; then
        echo "Error: No versions found in the GitHub repository."
        return 1
    fi

    # Build tag array
    local tag_array=()
    while IFS= read -r tag; do
        [ -n "$tag" ] && tag_array+=("$tag")
    done <<< "$tags_raw"

    # Try to auto-detect installed Traktor version
    local detected_version
    detected_version=$(detect_traktor_version)

    echo ""
    echo "Available QML versions:"
    local i=1
    local default_idx=0
    for tag in "${tag_array[@]}"; do
        local marker=""
        local version_short="${detected_version%% *}"  # strip build number (e.g. "4.4.2 158" → "4.4.2")
        if [ -n "$version_short" ] && [[ "$tag" == *"$version_short"* ]]; then
            marker=" ← your version"
            default_idx=$i
        fi
        printf "  %2d) %s%s\n" "$i" "$tag" "$marker"
        ((i++))
    done

    echo ""
    if [ -n "$detected_version" ]; then
        echo "Detected Traktor version: $detected_version"
    fi
    if [ "$default_idx" -gt 0 ]; then
        read -rp "Enter a number (default: $default_idx) or type a tag name: " selection
    else
        read -rp "Enter a number or type a tag name: " selection
    fi

    # Use detected default if user pressed Enter
    if [ -z "$selection" ] && [ "$default_idx" -gt 0 ]; then
        selection="$default_idx"
    fi

    local selected_tag=""
    if [[ "$selection" =~ ^[0-9]+$ ]]; then
        local idx=$((selection - 1))
        if [ "$idx" -ge 0 ] && [ "$idx" -lt "${#tag_array[@]}" ]; then
            selected_tag="${tag_array[$idx]}"
        else
            echo "Error: Invalid selection: $selection"
            return 1
        fi
    else
        selected_tag="$selection"
    fi

    if [ -z "$selected_tag" ]; then
        echo "Error: No version selected."
        return 1
    fi

    local archive_url="https://github.com/lsmith77/traktor-kontrol-qml-files/archive/refs/tags/${selected_tag}.tar.gz"
    echo ""
    echo "Downloading QML files from: $archive_url"
    local tmp_dir
    tmp_dir=$(mktemp -d)

    if ! curl -sS -L --fail "$archive_url" | tar xz --strip-components=1 -C "$tmp_dir"; then
        echo "Error: Failed to download QML files for tag: $selected_tag"
        rm -rf "$tmp_dir"
        return 1
    fi

    if [ ! -d "$tmp_dir/qml" ]; then
        echo "Error: Downloaded archive does not contain a 'qml' folder."
        echo "  Verify that tag '$selected_tag' exists and is valid."
        rm -rf "$tmp_dir"
        return 1
    fi

    echo "Restoring stock qml from GitHub (tag: $selected_tag)..."
    sudo rm -rf "$TRAKTOR_QML"
    sudo rm -rf "$TRAKTOR_QML_BACKUP"
    sudo cp -r "$tmp_dir/qml" "$TRAKTOR_QML"
    rm -rf "$tmp_dir"
    echo "Done. Restart Traktor to apply."
    return 0
}

# --- parse args ---

FRESH=false
SYMLINK=false
FULL=false
START_SERVER=false
PULL_RESTORE=false
MODE="install"
SOURCE_DIR="."


# --- argument parsing ---
BRANCH=""
BRANCH_REF_TYPE="heads"
SERVER_GITHUB_REPO="https://raw.githubusercontent.com/lsmith77/traktor-logger/main"
LOGGER_LOCAL_PATH=""
while [ $# -gt 0 ]; do
    arg="$1"
    case "$arg" in
        restore)   MODE="restore"; shift ;;
        logger)
            shift
            if [ -z "$1" ]; then
                echo "Error: 'logger' requires a subcommand (pull)"
                exit 1
            fi
            subarg="$1"
            case "$subarg" in
                pull) MODE="pull-logger" ;;
                api)
                    shift
                    if [ -z "$1" ]; then
                        echo "Error: 'logger api' requires a controller name"
                        exit 1
                    fi
                    enable_metadata_for_traktor "$1"
                    exit 0
                    ;;
                *) echo "Error: Unknown logger subcommand: $subarg (valid: pull, api)"; exit 1 ;;
            esac
            shift
            ;;
        server)
            shift
            if [ -z "$1" ]; then
                echo "Error: 'server' requires a subcommand (start)"
                exit 1
            fi
            subarg="$1"
            case "$subarg" in
                start) START_SERVER=true ;;
                *) echo "Error: Unknown server subcommand: $subarg"; exit 1 ;;
            esac
            shift
            ;;
        --fresh)   FRESH=true; shift ;;
        --symlink) SYMLINK=true; shift ;;
        --full)    FULL=true; shift ;;
        --pull)    PULL_RESTORE=true; shift ;;
        --branch=*)
            BRANCH="${arg#--branch=}"
            BRANCH_REF_TYPE="heads"
            shift
            ;;
        --branch)
            shift
            if [ -z "$1" ] || [[ "$1" =~ ^- ]]; then
                echo "Error: --branch requires a branch name"
                exit 1
            fi
            BRANCH="$1"
            BRANCH_REF_TYPE="heads"
            shift
            ;;
        --tag=*)
            BRANCH="${arg#--tag=}"
            BRANCH_REF_TYPE="tags"
            shift
            ;;
        --tag)
            shift
            if [ -z "$1" ] || [[ "$1" =~ ^- ]]; then
                echo "Error: --tag requires a tag name"
                exit 1
            fi
            BRANCH="$1"
            BRANCH_REF_TYPE="tags"
            shift
            ;;
        -h|--help) show_help; exit 0 ;;
        --source=*)
            if [ "$MODE" = "pull-logger" ]; then
                LOGGER_LOCAL_PATH="${arg#--source=}"
            else
                SOURCE_DIR="${arg#--source=}"
            fi
            shift
            ;;
        -s|--source)
            shift
            if [ -z "$1" ] || [[ "$1" =~ ^- ]]; then
                echo "Error: -s/--source requires a directory path"
                exit 1
            fi
            if [ "$MODE" = "pull-logger" ]; then
                LOGGER_LOCAL_PATH="$1"
            else
                SOURCE_DIR="$1"
            fi
            shift
            ;;
        *)
            echo "Unknown argument: $arg"
            exit 1
            ;;
    esac
done


# --- logger pull logic ---
logger_pull() {
    # Pull traktor-logger into ~/.traktor-mod/traktor-logger from GitHub or local
    if [ -n "$LOGGER_LOCAL_PATH" ]; then
        local local_resolved
        if local_resolved=$(cd "$LOGGER_LOCAL_PATH" 2>/dev/null && pwd 2>/dev/null); then
            echo "Copying traktor-logger from local: $local_resolved -> $SERVER_CACHE_DIR"
            mkdir -p "$(dirname "$SERVER_CACHE_DIR")"
            rm -rf "$SERVER_CACHE_DIR"
            if [ "$SYMLINK" = true ]; then
                ln -s "$local_resolved" "$SERVER_CACHE_DIR"
                echo "Symlinked entire traktor-logger directory from local path."
            else
                mkdir -p "$SERVER_CACHE_DIR"
                cp -R "$local_resolved/". "$SERVER_CACHE_DIR/"
                echo "Copied entire traktor-logger directory from local path."
            fi
            return 0
        else
            echo "Error: Could not resolve local logger path: $LOGGER_LOCAL_PATH"
            return 1
        fi
    fi
    # Otherwise, pull from GitHub
    local ref="$BRANCH"
    local ref_type="$BRANCH_REF_TYPE"
    if [ -z "$ref" ]; then
        echo "Fetching latest traktor-logger release..."
        local latest_tag
        if latest_tag=$(_fetch_latest_traktor_logger_tag) && [ -n "$latest_tag" ]; then
            echo "Latest release: $latest_tag"
            ref="$latest_tag"
            ref_type="tags"
        else
            echo "No releases found, falling back to main branch."
            ref="main"
            ref_type="heads"
        fi
    fi
    if ! _download_traktor_logger_from_github "$ref" "$ref_type"; then
        return 1
    fi
    echo "Downloaded to: $SERVER_CACHE_DIR"
    return 0
}


# --- start server only (if 'server start' with no other action flags) ---

if [ "$START_SERVER" = "true" ] && [ "$MODE" = "install" ] && [ "$FRESH" = "false" ] && [ "$SYMLINK" = "false" ] && [ "$FULL" = "false" ]; then
    # Just start the server without modifying qml
    echo "Starting traktor-logger server..."
    
    if ! command -v python3 &> /dev/null; then
        echo "Error: python3 is not installed or not in PATH"
        echo ""
        echo "To install Python 3:"
        echo "  macOS (Homebrew): brew install python3"
        echo "  macOS (MacPorts):  sudo port install python311"
        echo ""
        echo "Or install manually from: https://www.python.org/"
        exit 1
    fi
    
    if server_path=$(get_server_path); then
        echo "Server running on http://localhost:8080"
        echo "Press Ctrl+C to stop the server"
        echo ""
        python3 "$server_path"
        exit 0
    else
        echo "Error: Could not locate traktor-logger server."
        echo "Tried cache: $SERVER_CACHE_DIR"
        exit 1
    fi
fi

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
    if [ "$PULL_RESTORE" = "true" ]; then
        echo "This will replace the live qml, removing ALL mods and symlinks."
        read -rp "Are you sure? [y/N] " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo "Restore cancelled."
            exit 0
        fi
        restore_from_github
        exit $?
    fi
    if [ ! -d "$TRAKTOR_QML_BACKUP" ]; then
        echo "No backup found at: $TRAKTOR_QML_BACKUP"
        echo "Cannot restore — was the mod installed with this script?"
        echo ""
        echo "To fetch stock QML from GitHub instead, run:"
        echo "  traktor-mod restore --pull"
        exit 1
    fi
    echo "This will restore stock qml, removing ALL mods and symlinks."
    read -rp "Are you sure? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Restore cancelled."
        exit 0
    fi
    echo "Restoring stock qml from backup..."
    sudo rm -rf "$TRAKTOR_QML"
    sudo mv "$TRAKTOR_QML_BACKUP" "$TRAKTOR_QML"
    echo "Done. Restart Traktor to apply."
    exit 0
fi

if [ "$MODE" = "pull-logger" ]; then
    logger_pull
    exit $?
fi

# --- install ---

check_traktor_installed

# Detect if we're doing a mod installation (vs. metadata/logger-only)
IS_MOD_INSTALL=false
if [ "$FRESH" = "true" ] || [ "$FULL" = "true" ] || [ "$SYMLINK" = "true" ]; then
    IS_MOD_INSTALL=true
elif [ -d "$MOD_QML" ]; then
    # qml folder exists, assume we're installing a mod
    IS_MOD_INSTALL=true
fi

# If doing mod install, require qml folder
if [ "$IS_MOD_INSTALL" = "true" ] && [ ! -d "$MOD_QML" ]; then
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

# Install mod files if doing mod installation
if [ "$IS_MOD_INSTALL" = "true" ]; then
    # In fresh mode, reset live qml to stock before applying
    if [ "$FRESH" = "true" ]; then
        echo "Fresh mode: resetting live qml to stock..."
        # If qml is a symlink (e.g. from a prior --full --symlink), remove it first
        # so rsync creates a real directory rather than writing through the symlink
        if [ -L "$TRAKTOR_QML" ]; then
            sudo rm "$TRAKTOR_QML"
        fi
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
            qml_cmd mkdir -p "$(dirname "$dst")"
            qml_cmd rm -f "$dst"
            qml_cmd ln -s "$src" "$dst"
        done < <(find "$MOD_QML" -type f -print0)
        echo "Done."
        echo ""
        echo "Symlinks point to: $MOD_QML"
        echo "Edit files there and restart Traktor — no reinstall needed."
    else
        echo "Installing mod (merging overlay into Traktor qml)..."
        qml_cmd rsync -a "$MOD_QML/" "$TRAKTOR_QML/"
        echo "Done."
    fi
fi

# Optional: Start the server
if [ "$START_SERVER" = "true" ]; then
    echo ""
    echo "Starting traktor-logger server..."
    
    # Check if Python is available
    if ! command -v python3 &> /dev/null; then
        echo "Error: python3 is not installed or not in PATH"
        echo ""
        echo "To install Python 3:"
        echo "  macOS (Homebrew): brew install python3"
        echo "  macOS (MacPorts):  sudo port install python311"
        echo ""
        echo "Or install manually from: https://www.python.org/"
        exit 1
    fi
    
    if server_path=$(get_server_path); then
        echo "Server running on http://localhost:8080"
        echo "Press Ctrl+C to stop the server"
        echo ""
        python3 "$server_path"
        exit 0
    else
        echo "Error: Could not locate traktor-logger server"
        echo "Tried cache: $SERVER_CACHE_DIR"
        exit 1
    fi
fi

echo ""
echo "To undo all mods:  traktor-mod restore"
echo "Restart Traktor to apply changes."

