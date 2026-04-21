#!/bin/bash
# Claude Project Kit — uninstaller.
# Removes the kit from ~/.claude-project-kit and ~/.zshrc.
# Does NOT touch ~/projects/<your-projects>/ or its weekly launchd jobs.

set -u

KIT_DIR="${CLAUDE_KIT_DIR:-$HOME/.claude-project-kit}"
ZSHRC="$HOME/.zshrc"
PROJECTS_DIR="$HOME/projects"
CLAUDE_COMMANDS="$HOME/.claude/commands"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

MARKER_BEGIN="# ---- CLAUDE_PROJECT_KIT_BEGIN ----"
MARKER_END="# ---- CLAUDE_PROJECT_KIT_END ----"

echo ""
echo "Claude Project Kit — uninstall"
echo ""
echo "This will remove:"
echo "  - $KIT_DIR"
echo "  - Shell block between $MARKER_BEGIN and $MARKER_END in $ZSHRC"
echo "  - Slash commands (/decide, /experiment, /glossary, /note) from $CLAUDE_COMMANDS"
echo "  - statusLine setting from $CLAUDE_SETTINGS"
echo "  - $PROJECTS_DIR/.template, .newproj, .preship"
echo ""
echo "It will NOT touch:"
echo "  - Any of your projects under $PROJECTS_DIR/<name>/"
echo "  - Their weekly launchd jobs (remove manually if you want:"
echo "      launchctl remove com.jasont.design-journal-weekly-<name>"
echo "      rm ~/Library/LaunchAgents/com.jasont.design-journal-weekly-<name>.plist )"
echo ""
read -p "Continue? [y/N] " answer
case "$answer" in
  y|Y|yes|YES) ;;
  *) echo "Aborted."; exit 0 ;;
esac

# Remove kit dir
rm -rf "$KIT_DIR"
echo "  ✓ Removed $KIT_DIR"

# Strip shell block
if [ -f "$ZSHRC" ] && grep -q "$MARKER_BEGIN" "$ZSHRC"; then
  tmp=$(mktemp)
  awk -v b="$MARKER_BEGIN" -v e="$MARKER_END" '
    $0 == b { skip = 1; next }
    $0 == e { skip = 0; next }
    !skip
  ' "$ZSHRC" > "$tmp" && mv "$tmp" "$ZSHRC"
  echo "  ✓ Removed kit block from $ZSHRC"
fi

# Remove slash commands
for cmd in decide experiment glossary note; do
  rm -f "$CLAUDE_COMMANDS/$cmd.md"
done
echo "  ✓ Removed slash commands"

# Strip statusLine from settings.json
if [ -f "$CLAUDE_SETTINGS" ] && command -v jq >/dev/null 2>&1; then
  tmp=$(mktemp)
  jq 'del(.statusLine)' "$CLAUDE_SETTINGS" > "$tmp" && mv "$tmp" "$CLAUDE_SETTINGS"
  echo "  ✓ Removed statusLine from $CLAUDE_SETTINGS"
fi

# Remove top-level project-dir artefacts
rm -rf "$PROJECTS_DIR/.template" "$PROJECTS_DIR/.newproj" "$PROJECTS_DIR/.preship"
echo "  ✓ Removed kit artefacts from $PROJECTS_DIR"

echo ""
echo "Kit uninstalled. Your projects are intact at $PROJECTS_DIR/"
echo "Open a new terminal for the shell changes to take effect."
