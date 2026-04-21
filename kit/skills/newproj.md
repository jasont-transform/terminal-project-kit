---
description: Scaffold a new project at ~/projects/<name> with the full kit layout, assigned port, and weekly digest job
argument-hint: <project-name>
---

Run this Bash command and show the user its output verbatim:

```bash
~/projects/.newproj $ARGUMENTS
```

If `$ARGUMENTS` is empty, tell the user: `Usage: /newproj <project-name>` and stop. Do not run the command.

After the script succeeds, remind the user they'll need to open a new Claude Code session with cwd set to `~/projects/<name>/` for the per-project hooks and status line to take effect in that project.
