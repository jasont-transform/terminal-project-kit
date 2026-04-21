#!/bin/bash
# Claude Project Kit — installer.
# Idempotent: safe to re-run. Does not touch existing projects in ~/projects/.

set -eu

# Where the kit lives after install
KIT_DIR="${CLAUDE_KIT_DIR:-$HOME/.claude-project-kit}"
PROJECTS_DIR="$HOME/projects"
ZSHRC="$HOME/.zshrc"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
CLAUDE_COMMANDS="$HOME/.claude/commands"

BOLD='\033[1m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

info()  { printf "${BOLD}%s${RESET}\n" "$1"; }
ok()    { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
warn()  { printf "  ${YELLOW}⚠${RESET} %s\n" "$1"; }
fatal() { printf "  ${RED}✗${RESET} %s\n" "$1" >&2; exit 1; }

echo ""
info "Claude Project Kit — installer"
echo ""

# ---------- Preflight checks ----------
info "Preflight"

if [[ "$(uname)" != "Darwin" ]]; then
  warn "Not macOS (detected $(uname)). The kit targets macOS; install will likely work but is unsupported."
fi

if ! command -v claude >/dev/null 2>&1; then
  warn "claude CLI not found. Install from https://claude.com/claude-code, then re-run."
fi

# jq: use system jq if available; otherwise download a static binary into the kit dir.
# The static binary is a single file from jq's official GitHub releases — no brew, no Xcode required.
KIT_BIN="$HOME/.claude-project-kit/bin"
if command -v jq >/dev/null 2>&1; then
  ok "jq present ($(command -v jq))"
else
  info "jq not found — downloading a portable static binary"
  mkdir -p "$KIT_BIN"
  ARCH=$(uname -m)
  case "$ARCH" in
    arm64)  JQ_ASSET="jq-macos-arm64" ;;
    x86_64) JQ_ASSET="jq-macos-amd64" ;;
    *)      fatal "Unsupported architecture: $ARCH (expected arm64 or x86_64)" ;;
  esac
  JQ_URL="https://github.com/jqlang/jq/releases/download/jq-1.7.1/$JQ_ASSET"
  if ! curl -fsSL "$JQ_URL" -o "$KIT_BIN/jq"; then
    fatal "Failed to download jq from $JQ_URL. Check your network, or install jq manually (brew install jq)."
  fi
  chmod +x "$KIT_BIN/jq"
  ok "jq downloaded to $KIT_BIN/jq"
fi

# Make the kit's bundled bin dir take precedence so later steps (and kit scripts) find our jq.
export PATH="$KIT_BIN:$PATH"

if [ ! -f "$ZSHRC" ]; then
  warn "~/.zshrc not found — creating it."
  touch "$ZSHRC"
fi
ok "~/.zshrc present"

# ---------- Locate source ----------
# Support two install modes:
#  1. Running from an unpacked copy of the repo (the script is inside the repo) — SOURCE = repo root.
#  2. Running via curl | bash — download the tarball into $KIT_DIR. Uses curl + tar (built into macOS) — no git required.
SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd 2>/dev/null || echo "")"

if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/kit" ] && [ -f "$SCRIPT_DIR/VERSION" ]; then
  SOURCE="$SCRIPT_DIR"
  ok "Running from local repo: $SOURCE"
else
  # curl | bash mode — download the tarball (no git needed)
  TARBALL_URL="${CLAUDE_KIT_TARBALL:-https://github.com/jasont-transform/terminal-mode-project-kit/archive/refs/heads/main.tar.gz}"
  info "Downloading kit from $TARBALL_URL"
  TMPDIR_KIT=$(mktemp -d)
  trap 'rm -rf "$TMPDIR_KIT"' EXIT
  if ! curl -fsSL "$TARBALL_URL" | tar -xz -C "$TMPDIR_KIT"; then
    fatal "Download or extraction failed. Check your network and the URL above."
  fi
  # Tarball extracts into a single top-level dir like 'terminal-mode-project-kit-main/'
  EXTRACTED=$(find "$TMPDIR_KIT" -mindepth 1 -maxdepth 1 -type d | head -1)
  if [ -z "$EXTRACTED" ] || [ ! -d "$EXTRACTED/kit" ] || [ ! -f "$EXTRACTED/VERSION" ]; then
    fatal "Downloaded archive does not look like the kit (missing kit/ or VERSION)."
  fi
  rm -rf "$KIT_DIR"
  mkdir -p "$KIT_DIR"
  cp -R "$EXTRACTED/." "$KIT_DIR/"
  ok "Downloaded and extracted to $KIT_DIR"
  SOURCE="$KIT_DIR"
fi

# If SOURCE is not already $KIT_DIR, mirror it there so runtime paths are stable
if [ "$SOURCE" != "$KIT_DIR" ]; then
  mkdir -p "$KIT_DIR"
  rsync -a --delete "$SOURCE/" "$KIT_DIR/" 2>/dev/null || cp -R "$SOURCE/." "$KIT_DIR/"
  ok "Kit files staged to $KIT_DIR"
fi

VERSION=$(cat "$KIT_DIR/VERSION" 2>/dev/null || echo "unknown")
echo ""
info "Installing kit v$VERSION"

# ---------- Seed ~/projects/ ----------
echo ""
info "Setting up ~/projects/"
mkdir -p "$PROJECTS_DIR"

# Template — always refresh to the latest version
rm -rf "$PROJECTS_DIR/.template"
cp -R "$KIT_DIR/kit/template" "$PROJECTS_DIR/.template"
ok "Template installed"

# Top-level scripts (bootstrap + pre-ship) — always refresh
cp "$KIT_DIR/kit/scripts/newproj" "$PROJECTS_DIR/.newproj"
cp "$KIT_DIR/kit/scripts/preship" "$PROJECTS_DIR/.preship"
chmod +x "$PROJECTS_DIR/.newproj" "$PROJECTS_DIR/.preship"
ok "newproj + preship installed"

# Ports registry — only seed if missing
if [ ! -f "$PROJECTS_DIR/.ports.json" ]; then
  cp "$KIT_DIR/kit/defaults/ports.json" "$PROJECTS_DIR/.ports.json"
  ok "ports.json seeded"
else
  ok "ports.json already exists (preserved)"
fi

# INDEX.md — only seed if missing
if [ ! -f "$PROJECTS_DIR/INDEX.md" ]; then
  cp "$KIT_DIR/kit/defaults/INDEX.md" "$PROJECTS_DIR/INDEX.md"
  ok "INDEX.md seeded"
else
  ok "INDEX.md already exists (preserved)"
fi

# Cross-project training manual — only seed if missing
if [ ! -f "$PROJECTS_DIR/training-manual.md" ]; then
  cp "$KIT_DIR/kit/defaults/training-manual.md" "$PROJECTS_DIR/training-manual.md"
  ok "cross-project training-manual.md seeded"
else
  ok "cross-project training-manual.md already exists (preserved)"
fi

# ---------- Install Claude Code slash commands ----------
echo ""
info "Installing Claude Code slash commands"
mkdir -p "$CLAUDE_COMMANDS"
for f in "$KIT_DIR"/kit/skills/*.md; do
  [ -f "$f" ] || continue
  cp "$f" "$CLAUDE_COMMANDS/$(basename "$f")"
done
ok "Slash commands installed to $CLAUDE_COMMANDS (/decide, /experiment, /glossary, /note)"

# ---------- Configure Claude Code status line ----------
echo ""
info "Configuring Claude Code status line"
mkdir -p "$(dirname "$CLAUDE_SETTINGS")"
if [ ! -f "$CLAUDE_SETTINGS" ]; then
  echo "{}" > "$CLAUDE_SETTINGS"
fi
STATUSLINE_CMD="$KIT_DIR/kit/statusline.sh"
chmod +x "$STATUSLINE_CMD"
# Merge statusLine into settings.json (preserves other keys)
tmp=$(mktemp)
jq --arg cmd "$STATUSLINE_CMD" '.statusLine = {type: "command", command: $cmd}' "$CLAUDE_SETTINGS" > "$tmp" && mv "$tmp" "$CLAUDE_SETTINGS"
ok "Status line configured in $CLAUDE_SETTINGS"

# ---------- Patch ~/.zshrc ----------
echo ""
info "Patching ~/.zshrc"
MARKER_BEGIN="# ---- CLAUDE_PROJECT_KIT_BEGIN ----"
MARKER_END="# ---- CLAUDE_PROJECT_KIT_END ----"

if grep -q "$MARKER_BEGIN" "$ZSHRC"; then
  # Remove existing block
  tmp=$(mktemp)
  awk -v b="$MARKER_BEGIN" -v e="$MARKER_END" '
    $0 == b { skip = 1; next }
    $0 == e { skip = 0; next }
    !skip
  ' "$ZSHRC" > "$tmp" && mv "$tmp" "$ZSHRC"
  ok "Removed previous kit block from ~/.zshrc"
fi

# Append fresh block
{
  echo ""
  echo "# Claude Project Kit — installed $(date +%Y-%m-%d)"
  cat "$KIT_DIR/kit/shell/proj.zsh"
} >> "$ZSHRC"
ok "Added kit shell integration to ~/.zshrc"

# ---------- Done ----------
echo ""
echo ""
printf "${GREEN}${BOLD}Kit installed.${RESET}\n"
echo ""
echo "Next step:"
echo ""
echo "  Close this terminal and open a new one (to pick up the shell changes)."
echo "  Then run:"
echo ""
echo "    proj                       # list projects (none yet)"
echo "    newproj my-first-thing     # scaffold your first project"
echo "    proj-demo                  # or: see a pre-populated example"
echo "    proj-doctor                # verify everything is wired"
echo ""
echo "Kit files:              $KIT_DIR"
echo "Projects home:          $PROJECTS_DIR"
echo "Update later:           $KIT_DIR/update.sh"
echo "Uninstall:              $KIT_DIR/uninstall.sh"
echo ""
