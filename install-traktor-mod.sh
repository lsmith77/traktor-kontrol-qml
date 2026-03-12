#!/bin/bash
# install-traktor-mod.sh — Install a QML overlay mod into Traktor Pro 4 (macOS)
#
# Synopsis:
#   Merges QML overlay mods into Traktor's live qml folder with backup and restore support.
#   Supports overlay modes (stack, fresh, symlink) and full replacement mode (--full).
#   No reinstall needed when using symlink mode — just restart Traktor after edits.
#
# Usage:
#   install-traktor-mod                                      — merge mod on top of current live qml (stack mode)
#   install-traktor-mod --fresh                              — restore stock first, then merge mod (clean mode)
#   install-traktor-mod --symlink                            — symlink mod files into live qml (dev mode)
#   install-traktor-mod --fresh --symlink                    — restore stock first, then symlink mod files
#   install-traktor-mod --full                               — replace entire qml with mod's qml
#   install-traktor-mod --full --symlink                     — symlink entire mod qml into Traktor (dev mode)
#   install-traktor-mod restore                              — restore stock qml and remove all mods/symlinks
#
# Specifying source directory (optional; defaults to current directory):
#   install-traktor-mod --source /path/to/mod                - use specific directory
#   install-traktor-mod -s ../traktor-kontrol-d2 --fresh     — use subdirectory, fresh mode
#   install-traktor-mod -s ~/my-mod --symlink                — use home directory, symlink mode
#
# Logger and server commands:
#   install-traktor-mod logger pull                          — download traktor-logger to local cache
#   install-traktor-mod logger pull --branch dev             — pull from a specific branch
#   install-traktor-mod logger pull --local /path/to/logger  — copy from local directory
#   install-traktor-mod logger pull --symlink --local /path  — symlink local logger directory into cache
#   install-traktor-mod logger install                       — install Logger.qml and Api modules to Traktor qml
#   install-traktor-mod server start                         — launch traktor-logger server on localhost:8080
#   install-traktor-mod enable-metadata D2,S8,X1MK3         — inject ApiModule into controller files
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

Installation Modifiers:
  install-traktor-mod --with-logger          — include Logger.qml and Api modules with a mod

Standalone Commands:
  install-traktor-mod logger pull            — download traktor-logger to local cache from GitHub
  install-traktor-mod logger install         — install Logger.qml and Api modules to Traktor qml
  install-traktor-mod server start           — launch traktor-logger server on localhost:8080
  install-traktor-mod enable-metadata D2,S8,X1MK3  — inject ApiModule into controller files
  install-traktor-mod restore                — restore stock qml, remove all mods

  Logger cache options (used with 'logger pull'):
    --branch <name>                          — pull from a specific GitHub branch (default: main)
    --local /path/to/logger                  — copy from a local traktor-logger directory
    --symlink (with --local)                 — symlink local directory into cache instead of copying

  Logger and Api modules use hybrid fallback chain:
    1. Cached ~/.traktor-mod/traktor-logger/ (offline after first download)
    2. GitHub download (initial setup, requires internet)

General Options:
  install-traktor-mod -s /path/to/mod        — use specific directory
  install-traktor-mod -h                     — show this help

Notes:
  - Backup created on first install (never overwritten)
  - Restore returns to stock and removes all mods/symlinks
  - Symlinks use absolute paths; moving repo breaks them (run again to fix)
  - With --with-logger: installed to mod's Defines/ folder
  - Logger components (logger install): installed to Traktor's Defines/ folder
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

# --- logger utility (hybrid: local → cached → github) ---



get_logger_qml() {
    # Returns path to Logger.qml using hybrid fallback chain: cache → GitHub
    local logger_path="$SERVER_CACHE_DIR/qml/Logger.qml"
    local logger_url="$SERVER_GITHUB_REPO/qml/Logger.qml"
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
SERVER_GITHUB_REPO="https://raw.githubusercontent.com/lsmith77/traktor-logger/main"

_download_traktor_logger_from_github() {
    # Download entire traktor-logger repo from GitHub as a tarball
    local branch="$1"
    local archive_url="https://github.com/lsmith77/traktor-logger/archive/refs/heads/${branch}.tar.gz"
    echo "Downloading traktor-logger from GitHub (branch: ${branch})..." >&2
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

    # 2. Check cache
    if [ -f "$SERVER_CACHE_DIR/server.py" ] && [ -f "$SERVER_CACHE_DIR/qml/Logger.qml" ]; then
        echo "$SERVER_CACHE_DIR"
        return 0
    fi

    # 3. Download from GitHub
    if ! _download_traktor_logger_from_github "$BRANCH" >&2; then
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

get_logger_version() {
    # Extract version from traktor-logger README (deterministic marker: "Version: X")
    local server_dir readme version
    if ! server_dir=$(get_server_package 2>/dev/null); then
        echo "unknown"
        return 0
    fi
    readme="$server_dir/README.md"
    if [ -f "$readme" ]; then
        version=$(grep -E '^Version:[[:space:]]*' "$readme" | head -n 1 | sed -E 's/^Version:[[:space:]]*//')
    fi
    if [ -z "$version" ]; then
        version="unknown"
    fi
    echo "$version"
    return 0
}

install_logger_qml() {
    # Install Logger.qml and Api modules into mod's qml/
    if [ ! -d "$MOD_QML/Defines" ]; then
        mkdir -p "$MOD_QML/Defines"
    fi
    
    local logger_src
    if ! logger_src=$(get_logger_qml); then
        echo "Error: Could not obtain Logger.qml"
        return 1
    fi
    
    # Create qmldir if it doesn't exist
    if [ ! -f "$MOD_QML/Defines/qmldir" ]; then
        cat > "$MOD_QML/Defines/qmldir" << 'QMLDIR'
module Traktor.Defines
Logger 1.0 Logger.qml
QMLDIR
    fi
    
    # Copy Logger.qml to mod
    cp "$logger_src" "$MOD_QML/Defines/Logger.qml"
    echo "  ✓ Logger.qml: $MOD_QML/Defines/Logger.qml"
    
    # Copy Api modules to mod
    local api_src
    if api_src=$(get_api_modules_path 2>/dev/null) && [ -d "$api_src" ] && [ -n "$(ls -A "$api_src" 2>/dev/null)" ]; then
        mkdir -p "$MOD_QML/CSI/Common/Api"
        if cp -r "$api_src"/* "$MOD_QML/CSI/Common/Api/" 2>&1; then
            echo "  ✓ Api modules: $MOD_QML/CSI/Common/Api/"
        else
            echo "  ⚠ Api modules: could not copy (but Logger.qml is installed)"
        fi
    else
        echo "  ⚠ Api modules: not available (Logger.qml is installed)"
    fi
    
    return 0
}

enable_metadata_for_traktor() {
    # Enable metadata for Traktor's installed qml (standalone operation)
    # Injects ApiModule into controller files
    # Note: Api modules must be installed first via 'logger pull' + 'logger install'
    local controller_list="$1"
    
    if [ -z "$controller_list" ]; then
        echo "Error: No controllers specified for metadata"
        return 1
    fi
    
    check_traktor_installed
    
    # Verify Api modules are already installed in Traktor qml
    if [ ! -d "$TRAKTOR_QML/CSI/Common/Api" ] || [ -z "$(ls -A "$TRAKTOR_QML/CSI/Common/Api" 2>/dev/null)" ]; then
        echo "Error: Api modules not found in Traktor qml"
        echo ""
        echo "Install them first with:"
        echo "  install-traktor-mod logger install"
        echo ""
        echo "Or pull and install with:"
        echo "  install-traktor-mod logger pull && install-traktor-mod logger install"
        return 1
    fi
    
    # Now enable metadata on the controllers
    enable_metadata_for_controllers "$controller_list" "$TRAKTOR_QML"
}

enable_metadata_for_controllers() {
    # Enable metadata collection for specified controllers (comma-separated list)
    # Uses safe insertion with validation to prevent file corruption
    local controller_list="$1"
    local target_dir="${2:-$TRAKTOR_QML}"
    
    if [ -z "$controller_list" ]; then
        echo "Error: No controllers specified for metadata"
        return 1
    fi
    
    echo "Enabling metadata collection for controllers: $controller_list"
    echo "Target: $target_dir"
    
    # Parse comma-separated list
    IFS=',' read -ra CONTROLLERS <<< "$controller_list"
    
    for controller in "${CONTROLLERS[@]}"; do
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
        
        # Need to modify - use sudo if target is Traktor qml
        local use_sudo=""
        if [[ "$target_dir" == "$TRAKTOR_QML"* ]]; then
            use_sudo="sudo"
        fi
        
        # Step 1: Ensure import for ApiModule is present (add if missing)
        if ! grep -q 'import.*"\.\./Common/Api"' "$controller_file"; then
            # Use awk to insert import after last import statement
            local temp_file="${controller_file}.tmp1"
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
            
            $use_sudo mv "$temp_file" "$controller_file"
            echo "  → Added import for ApiModule"
        fi
        
        # Step 2: Inject ApiModule into Mapping block
        local temp_file="${controller_file}.tmp2"
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
        
        # Validate the temp file has balanced braces (basic check)
        local open_braces=$(grep -o '{' "$temp_file" | wc -l)
        local close_braces=$(grep -o '}' "$temp_file" | wc -l)
        
        if [ "$open_braces" -ne "$close_braces" ]; then
            echo "  ✗ $controller: validation failed - brace mismatch"
            rm -f "$temp_file"
            continue
        fi
        
        # Replace original with temp
        $use_sudo mv "$temp_file" "$controller_file"
        echo "  ✓ $controller: metadata enabled (validated)"
    done
    
    return 0
}

install_logger_to_traktor() {
    # Install Logger.qml and Api modules directly to Traktor's live QML (not to a mod)
    check_traktor_installed
    
    # Create backup on first install
    if [ ! -d "$TRAKTOR_QML_BACKUP" ]; then
        echo "Creating backup of stock qml..."
        sudo cp -r "$TRAKTOR_QML" "$TRAKTOR_QML_BACKUP"
        echo "  Backup saved: $TRAKTOR_QML_BACKUP"
    else
        echo "Backup exists: $TRAKTOR_QML_BACKUP"
    fi
    
    # Get Logger.qml using hybrid fallback
    local logger_src
    if ! logger_src=$(get_logger_qml); then
        echo "Error: Could not obtain Logger.qml"
        return 1
    fi

    # Create Defines folder in Traktor's live QML if it doesn't exist
    if [ ! -d "$TRAKTOR_QML/Defines" ]; then
        sudo mkdir -p "$TRAKTOR_QML/Defines"
    fi

    # Register Logger in qmldir
    if [ ! -f "$TRAKTOR_QML/Defines/qmldir" ]; then
        # Create new qmldir if missing
        sudo tee "$TRAKTOR_QML/Defines/qmldir" > /dev/null << 'QMLDIR'
module Traktor.Defines
Logger 1.0 Logger.qml
QMLDIR
    else
        # Append Logger to existing qmldir if not already there
        if ! grep -q "^Logger" "$TRAKTOR_QML/Defines/qmldir"; then
            echo "Logger 1.0 Logger.qml" | sudo tee -a "$TRAKTOR_QML/Defines/qmldir" > /dev/null
        fi
    fi

    # Copy Logger.qml to Traktor's live QML
    sudo cp "$logger_src" "$TRAKTOR_QML/Defines/Logger.qml"
    echo "  ✓ Logger.qml: $TRAKTOR_QML/Defines/Logger.qml"
    
    # Copy Api modules to Traktor's live QML
    local api_src
    if api_src=$(get_api_modules_path 2>/dev/null) && [ -d "$api_src" ] && [ -n "$(ls -A "$api_src" 2>/dev/null)" ]; then
        sudo mkdir -p "$TRAKTOR_QML/CSI/Common/Api"
        if sudo cp -r "$api_src"/* "$TRAKTOR_QML/CSI/Common/Api/" 2>&1; then
            echo "  ✓ Api modules: $TRAKTOR_QML/CSI/Common/Api/"
        else
            echo "  ⚠ Api modules: could not copy (but Logger.qml is installed)"
        fi
    else
        echo "  ⚠ Api modules: not available in cache (Logger.qml is installed)"
    fi
    
    echo ""
    echo "✓ Logger installation complete!"
    echo ""
    echo "For simple debug logging in your controller:"
    echo "  import Traktor.Defines 1.0"
    echo "  Logger { id: logger }"
    echo "  logger.info('Message', { data: 'value' })"
    echo ""
    echo "For automatic metadata collection (deck state, channels, tempo):"
    echo "  Use: install-traktor-mod enable-metadata ControllerName"
    echo "  Example: install-traktor-mod enable-metadata D2,S8,X1MK3"
    echo "  Then open the Logger Web Dashboard at http://localhost:8080"
    echo ""
    echo "Components installed:"
    echo "  • Logger.qml: $TRAKTOR_QML/Defines/Logger.qml"
    echo "  • Api modules: $TRAKTOR_QML/CSI/Common/Api/"
    return 0
}



# --- parse args ---

FRESH=false
SYMLINK=false
FULL=false
WITH_LOGGER=false
START_SERVER=false
MODE="install"
SOURCE_DIR="."


# --- argument parsing with --branch and --local ---
BRANCH="main"
LOGGER_LOCAL_PATH=""
while [ $# -gt 0 ]; do
    arg="$1"
    case "$arg" in
        restore)   MODE="restore"; shift ;;
        logger)
            shift
            if [ -z "$1" ]; then
                echo "Error: 'logger' requires a subcommand (pull or install)"
                exit 1
            fi
            subarg="$1"
            case "$subarg" in
                pull) MODE="pull-logger" ;;
                install) MODE="install-logger-only" ;;
                *) echo "Error: Unknown logger subcommand: $subarg"; exit 1 ;;
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
        enable-metadata)
            shift
            if [ -z "$1" ]; then
                echo "Error: 'enable-metadata' requires controller names"
                exit 1
            fi
            enable_metadata_for_traktor "$1"
            exit 0
            ;;
        --fresh)   FRESH=true; shift ;;
        --symlink) SYMLINK=true; shift ;;
        --full)    FULL=true; shift ;;
        --with-logger) WITH_LOGGER=true; shift ;;
        --branch)
            shift
            if [ -z "$1" ] || [[ "$1" =~ ^- ]]; then
                echo "Error: --branch requires a branch name"
                exit 1
            fi
            BRANCH="$1"
            shift
            ;;
        --local)
            shift
            if [ -z "$1" ] || [[ "$1" =~ ^- ]]; then
                echo "Error: --local requires a path to local traktor-logger directory"
                exit 1
            fi
            LOGGER_LOCAL_PATH="$1"
            shift
            ;;
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


# --- logger pull logic ---
SERVER_GITHUB_REPO="https://raw.githubusercontent.com/lsmith77/traktor-logger/${BRANCH}"

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
    if ! _download_traktor_logger_from_github "$BRANCH"; then
        return 1
    fi
    echo "Downloaded to: $SERVER_CACHE_DIR"
    return 0
}


# --- start server only (if 'server start' with no other action flags) ---

if [ "$START_SERVER" = "true" ] && [ "$MODE" = "install" ] && [ "$FRESH" = "false" ] && [ "$SYMLINK" = "false" ] && [ "$FULL" = "false" ] && [ "$WITH_LOGGER" = "false" ]; then
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
    
    server_path=$(get_server_path)
    if [ $? -eq 0 ]; then
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

# --- install logger only ---


if [ "$MODE" = "pull-logger" ]; then
    logger_pull
    exit $?
fi

if [ "$MODE" = "install-logger-only" ]; then
    echo "Installing Logger.qml and Api modules to Traktor qml from cache..."
    if install_logger_to_traktor; then
        logger_version=$(get_logger_version)
        server_path=$(get_server_path 2>/dev/null || true)
        echo ""
        echo "traktor-logger version: $logger_version"
        if [ -n "$server_path" ]; then
            echo "Server path: $server_path"
        fi
        # If 'server start' was specified, start the server; otherwise prompt to launch Traktor
        if [ "$START_SERVER" = "true" ]; then
            echo ""
            echo "Starting traktor-logger server..."
            echo ""
            if command -v python3 &> /dev/null; then
                echo "Server running on http://localhost:8080"
                echo "Press Ctrl+C to stop the server"
                echo ""
                python3 "$server_path"
                exit 0
            else
                echo "Error: python3 is not installed or not in PATH"
                exit 1
            fi
        fi
        echo ""
        read -rp "Launch Traktor now? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            open "$TRAKTOR_APP"
        fi
    else
        echo "Error: Installation failed"
        exit 1
    fi
    exit 0
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
fi

# Optional: Install Logger.qml
if [ "$WITH_LOGGER" = "true" ]; then
    echo ""
    echo "Installing Logger.qml and Api modules for debugging..."
    if install_logger_qml; then
        echo ""
        echo "Usage in your QML:"
        echo "  import Traktor.Defines 1.0"
        echo "  Logger { id: logger }"
        echo "  logger.info('Message', { data: 'value' })"
        echo ""
        echo "Components installed:"
        echo "  • Logger.qml: $MOD_QML/Defines/"
        echo "  • Api modules: $MOD_QML/CSI/Common/Api/"
    else
        echo "Warning: Installation failed"
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
    
    server_path=$(get_server_path)
    if [ $? -eq 0 ]; then
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
echo "To undo all mods:  install-traktor-mod restore"

read -rp "Launch Traktor now? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    open "$TRAKTOR_APP"
fi

