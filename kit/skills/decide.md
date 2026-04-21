---
description: Scaffold a new architectural decision (ADR) file in the current project's design-journal
---

You are scaffolding a new architectural decision file for the current project.

Steps:

1. Identify the project's `design-journal/decisions/` directory. Look at the current working directory; if it does not directly contain a `design-journal/` folder, walk up the directory tree to find one. If none is found, tell the user they are not inside a project and stop.

2. List the existing files in `design-journal/decisions/` and find the highest decision number (`NNN-...`). The new number is that plus one (zero-padded to 3 digits). If none exist, start at `001`.

3. Derive a slug from the user's argument (kebab-case, lowercased, alphanumeric + hyphens only).

4. Create a new file at `design-journal/decisions/NNN-<slug>.md` with this structure, substituting appropriately:

```markdown
---
id: decision-NNN-<slug>
type: decision
date: YYYY-MM-DD
topic: <topic>
tags: [<tag1>, <tag2>]
status: proposed
related: []
---

# NNN — <title from user's argument>

**Date:** YYYY-MM-DD
**Status:** Proposed

## Context

<brief — what situation forces this decision>

## Decision

<what we are deciding>

## Why

<the reasoning>

## Consequences

<what follows from this choice>
```

5. Fill in `YYYY-MM-DD` with today's date. For `topic` and `tags`, infer from the title; if unclear, use `topic: architecture` and `tags: []`.

6. Open the file for the user to edit further. Then stop — do not write prose speculating about the decision itself; the user fills that in.

User's argument (the decision title): $ARGUMENTS
