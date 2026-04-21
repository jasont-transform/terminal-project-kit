---
description: Pre-ship safety gate — scans the current project for secrets, tracked .env, client data, missing docs, and remote org
---

Run this Bash command from the user's current working directory and show its output verbatim:

```bash
~/.claude-project-kit/kit/scripts/preship
```

If the command exits non-zero, summarise the issues found and suggest concrete next steps the user can take before pushing.
