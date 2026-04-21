#!/bin/bash
# Claude Code status line for the Claude Project Kit.
# Shows: [project · port · git-branch] when inside a project, nothing otherwise.
# Configured in ~/.claude/settings.json by the installer.

# Ensure the kit's bundled bin dir (portable jq) is on PATH.
export PATH="$HOME/.claude-project-kit/bin:$PATH"

# Read JSON from stdin (Claude Code passes session context)
INPUT=$(cat)

# Extract working directory from the input JSON (fallback to $PWD)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$CWD" ] && CWD="$PWD"

PROJECTS_DIR="$HOME/projects"
PORTS_FILE="$PROJECTS_DIR/.ports.json"

# Walk up from CWD to find a project directory (immediate child of ~/projects/)
DIR="$CWD"
PROJECT=""
while [ -n "$DIR" ] && [ "$DIR" != "/" ]; do
  if [ "$(dirname "$DIR")" = "$PROJECTS_DIR" ]; then
    PROJECT=$(basename "$DIR")
    break
  fi
  DIR=$(dirname "$DIR")
done

if [ -z "$PROJECT" ]; then
  # Not inside a project — show nothing (Claude Code shows its own default)
  exit 0
fi

# Port from registry
PORT="?"
if [ -f "$PORTS_FILE" ]; then
  PORT=$(jq -r --arg n "$PROJECT" '.projects[$n] // "?"' "$PORTS_FILE" 2>/dev/null)
fi

# Git branch
BRANCH=""
if [ -d "$PROJECTS_DIR/$PROJECT/.git" ]; then
  BRANCH=$(cd "$PROJECTS_DIR/$PROJECT" && git branch --show-current 2>/dev/null)
  [ -n "$BRANCH" ] && BRANCH=" · $BRANCH"
fi

# Output: muted colour (dim cyan-ish) via ANSI
printf "\033[36m%s\033[0m · %s%s" "$PROJECT" "$PORT" "$BRANCH"
