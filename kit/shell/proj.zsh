# Claude Project Kit — shell integration
# Sourced from ~/.zshrc by the installer. DO NOT EDIT in place; it is
# overwritten by install.sh and update.sh. Instead, edit the source in the
# Claude Project Kit repository.

# ---- CLAUDE_PROJECT_KIT_BEGIN ----

# Put the kit's bundled bin dir (portable jq) on PATH.
export PATH="$HOME/.claude-project-kit/bin:$PATH"

proj() {
  local PROJECTS_DIR="$HOME/projects"
  local PORTS_FILE="$PROJECTS_DIR/.ports.json"

  case "$1" in
    help|-h|--help)
      cat <<'HELP'
  proj                   list all projects
  proj <name>            jump into a project and resume Claude Code
  newproj <name>         create a new project (auto-assigns next port)
  preship                pre-ship safety gate (run from inside a project)
  proj-doctor            health check for the kit
  proj-ports             show which projects are running on which ports
  proj-review            coaching review of the current project
  proj-digest            one-screen weekly cross-project summary
  proj-init-remote       create a GitHub repo and push the current project
  proj-demo              scaffold a pre-populated example project
HELP
      return 0
      ;;
  esac

  # Jump into a named project
  if [ $# -ge 1 ]; then
    local name="$1"
    if [ ! -d "$PROJECTS_DIR/$name" ]; then
      echo "No project '$name'. Run 'proj' to list available."
      return 1
    fi
    cd "$PROJECTS_DIR/$name" && claude -c
    return $?
  fi

  # List mode
  echo ""
  printf "  %-30s  %-5s  %-14s\n" "PROJECT" "PORT" "LAST SESSION"
  printf "  %-30s  %-5s  %-14s\n" "------------------------------" "-----" "--------------"

  local count=0
  for dir in "$PROJECTS_DIR"/*/; do
    [ -d "$dir" ] || continue
    local name=$(basename "$dir")
    [[ "$name" = .* ]] && continue
    count=$((count + 1))

    local port="—"
    if [ -f "$PORTS_FILE" ]; then
      port=$(jq -r --arg n "$name" '.projects[$n] // "—"' "$PORTS_FILE" 2>/dev/null)
      [ -z "$port" ] && port="—"
    fi

    local last="never"
    local latest=$(/bin/ls -1 "$dir"design-journal/logbook/*.md 2>/dev/null | sort | tail -1)
    [ -n "$latest" ] && last=$(basename "$latest" .md)

    printf "  %-30s  %-5s  %-14s\n" "$name" "$port" "$last"
  done

  echo ""
  if [ "$count" -eq 0 ]; then
    echo "  No projects yet.  Create one with:  newproj <name>"
    echo ""
    return 0
  fi

  echo "  proj <name>       jump in and resume"
  echo "  newproj <name>    create a new project"
  echo "  proj help         show all commands"
  echo ""
}

# Aliases for kit scripts
alias newproj="$HOME/projects/.newproj"
alias preship="$HOME/projects/.preship"
alias proj-doctor="$HOME/.claude-project-kit/kit/scripts/proj-doctor"
alias proj-ports="$HOME/.claude-project-kit/kit/scripts/proj-ports"
alias proj-review="$HOME/.claude-project-kit/kit/scripts/proj-review"
alias proj-digest="$HOME/.claude-project-kit/kit/scripts/proj-digest"
alias proj-init-remote="$HOME/.claude-project-kit/kit/scripts/proj-init-remote"
alias proj-demo="$HOME/.claude-project-kit/kit/scripts/proj-demo"

# ---- CLAUDE_PROJECT_KIT_END ----
