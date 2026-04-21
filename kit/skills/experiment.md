---
description: Scaffold a new experiment entry in the current project's design-journal
---

You are scaffolding a new experiment entry for the current project.

Steps:

1. Identify the project's `design-journal/experiments/` directory. Look at the current working directory; if it does not directly contain a `design-journal/` folder, walk up the directory tree to find one. If none is found, tell the user they are not inside a project and stop.

2. Derive a slug from the user's argument (kebab-case, lowercased, alphanumeric + hyphens only).

3. Create a new file at `design-journal/experiments/YYYY-MM-DD-<slug>.md` (today's date) with this structure:

```markdown
---
id: experiment-YYYY-MM-DD-<slug>
type: experiment
date: YYYY-MM-DD
topic: <topic>
tags: []
status: tried
related: []
---

# <title from user's argument>

**Hypothesis** — <what we thought or wanted to test>.

**Approach** — <what we actually did>.

**Result** — <what happened>.

**Conclusion** — <what we learned, and what we will do next>.
```

4. Infer `topic` from the title; use `architecture`, `content-design`, `tooling`, `process`, or similar. If unclear, leave as `<topic>` for the user to fill.

5. Then stop. The user fills in the four body sections. Remind them: failures are the highest-value experiments. Do not filter them out.

User's argument (the experiment title): $ARGUMENTS
