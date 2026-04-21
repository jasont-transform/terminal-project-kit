---
description: List all Claude Project Kit projects with their assigned ports and last session date
argument-hint: [optional: project-name]
---

If `$ARGUMENTS` is empty, run this Bash command to list all projects and show the output verbatim:

```bash
bash -c '
PROJECTS_DIR="$HOME/projects"
PORTS_FILE="$PROJECTS_DIR/.ports.json"
printf "\n  %-30s  %-5s  %-14s\n" "PROJECT" "PORT" "LAST SESSION"
printf "  %-30s  %-5s  %-14s\n" "------------------------------" "-----" "--------------"
count=0
for dir in "$PROJECTS_DIR"/*/; do
  [ -d "$dir" ] || continue
  name=$(basename "$dir")
  [[ "$name" = .* ]] && continue
  count=$((count + 1))
  port="—"
  [ -f "$PORTS_FILE" ] && port=$(/usr/bin/jq -r --arg n "$name" ".projects[\$n] // \"—\"" "$PORTS_FILE" 2>/dev/null)
  [ -z "$port" ] && port="—"
  last="never"
  latest=$(/bin/ls -1 "$dir"design-journal/logbook/*.md 2>/dev/null | sort | tail -1)
  [ -n "$latest" ] && last=$(basename "$latest" .md)
  printf "  %-30s  %-5s  %-14s\n" "$name" "$port" "$last"
done
echo ""
if [ "$count" -eq 0 ]; then
  echo "  No projects yet.  Create one with:  /newproj <name>"
fi
exit 0
'
```

If `$ARGUMENTS` is non-empty, it names a project. Tell the user: to jump into that project, exit this Claude session and re-open Claude Code with `~/projects/$ARGUMENTS/` as the working directory — Claude cannot switch its own cwd mid-session. Then list the exact path so they can copy it.
