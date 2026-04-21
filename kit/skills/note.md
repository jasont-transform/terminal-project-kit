---
description: Append a short note to today's logbook entry
---

You are appending a quick note to today's logbook entry for the current project.

Steps:

1. Identify the project's `design-journal/logbook/` directory. Walk up the working directory tree if needed. If none is found, tell the user they are not inside a project and stop.

2. Target file: `design-journal/logbook/YYYY-MM-DD.md` (today's date).

3. If the file does not exist, create it with YAML frontmatter (`id: logbook-YYYY-MM-DD`, `type: logbook`, `date`, `topic`, `tags`, `status: accepted`, `related: []`), a top-level heading (`# YYYY-MM-DD — <project-name>`), and a `## Notes` section.

4. Append the user's note under a `## Notes` section. If the section already exists, add the new line at the end of that section. Prefix each note with a timestamp (`- HH:MM — <note>`).

5. Do not add any other content. Keep it minimal. This is a scratchpad mechanism; the Stop hook will produce the substantive logbook entry at end of session.

User's argument (the note text): $ARGUMENTS
