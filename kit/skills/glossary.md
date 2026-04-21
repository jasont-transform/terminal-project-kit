---
description: Add a term to the current project's glossary
---

You are adding a new term to the current project's glossary.

Steps:

1. Identify the project's `design-journal/glossary.md` file. Look at the current working directory; walk up the tree to find a `design-journal/` folder if needed. If none is found, tell the user they are not inside a project and stop.

2. Read the existing `glossary.md`. Confirm the term the user gave is not already defined. If it is, tell the user and offer to update the existing entry instead.

3. If new, append a new `## <Term>` section at the end of the file (before any trailing placeholder text) with a one-to-three-sentence definition of the term. The definition should:
   - Be short, unambiguous, and stand alone (no "see also" chains).
   - Use a first-person-plural voice consistent with existing entries ("we consume it directly", "we use this when...").
   - If appropriate, end with "Contrast with *other-term*" to signal relationships.

4. Ask the user for a one-line definition if the term is ambiguous or project-specific and you cannot confidently define it from context.

User's argument (the term, and optionally a short definition): $ARGUMENTS
