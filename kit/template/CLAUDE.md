# Working agreement — __PROJECT_NAME__

Terse responses. No trailing summaries. Match scope to what was asked.

## Project context

This is the `__PROJECT_NAME__` project. It runs on `localhost:__PROJECT_PORT__`. The project directory is `__PROJECT_DIR__`. Its design journal lives at `__PROJECT_DIR__/design-journal/`.

## Live during the session — do these without being asked

- Extend today's logbook at `__PROJECT_DIR__/design-journal/logbook/YYYY-MM-DD.md` as we work. Prose, chronological, blow-by-blow.
- Create a new `__PROJECT_DIR__/design-journal/decisions/NNN-slug.md` whenever a real architectural call is made. ADR-style matching the existing files. Number sequentially.
- Add to `__PROJECT_DIR__/design-journal/training-manual.md` when the discussion produces a durable lesson, insight, technique, or reusable pattern. Bar: "would a designer joining the project in six months thank me for this entry?" Read the existing manual first; reuse topic headings. Most sessions add 0–2 entries; weak filler degrades the manual.
- Add a new `__PROJECT_DIR__/design-journal/experiments/YYYY-MM-DD-slug.md` whenever we try something with a specific hypothesis and outcome — **including failures and botched attempts**. Use the Hypothesis / Approach / Result / Conclusion structure.
- Save raw artefacts (prompts, code snippets, generated outputs, schemas we discuss) into `__PROJECT_DIR__/design-journal/artefacts/` with naming `YYYY-MM-DD-slug.ext`.
- Update `__PROJECT_DIR__/design-journal/glossary.md` with a new `## Term` section whenever a project-specific word or phrase enters our vocabulary.
- Never write to `__PROJECT_DIR__/design-journal/weekly/` — that file is maintained by a separate scheduled job.

## Knowledge-base conventions (AI-extractable)

Everything we record is shaped for future AI scanning and machine-learning. Follow without being asked:

- **Every markdown file starts with YAML frontmatter**: `id`, `type`, `date`, `topic`, `tags`, `status`, `related`.
- **Cross-reference via `related`** using stable IDs.
- **Capture failures on purpose.** The highest-value experiments are the ones that did not work.

## Memory model (read carefully)

This project's memory is structured to keep the context window lean:

- **Always in context at session start:** the topline `design-journal/overview.md` (one-screen project state) and the single most recent logbook entry. These are injected by the SessionStart hook — you don't read them explicitly.
- **On demand:** everything else — training manual, decisions, experiments, weekly digests, glossary, older logbook entries. The SessionStart injection includes an index of what exists. When the user asks about one of them, `Read` the specific file rather than guessing.
- **Do not auto-summarise the full journal into context.** Only pull what's actually needed for the current question.
- **Keep `overview.md` current.** When the project enters a new phase, a goal changes, or a stakeholder shifts, edit `overview.md` to reflect the new reality. One screen only — detail belongs in decisions/experiments/logbook, not here.

## Automation already in place

- **Per-project SessionStart hook** (`.claude/settings.json` → `.claude/hooks/session-start.sh`): loads the lean memory block described above.
- **Per-project Stop hook** (`.claude/settings.json` → `design-journal/.journal-hook.sh`): after every session, a sub-claude updates the logbook, training manual, and decisions if the live writes missed anything. Keyword-filtered so unrelated sessions no-op cheaply. Recursion-guarded via `CLAUDE_JOURNAL_HOOK=1`.
- **Weekly launchd** (`~/Library/LaunchAgents/com.jasont.design-journal-weekly-__PROJECT_NAME__.plist`): Mondays 09:00, rolls up the week into `weekly/YYYY-WNN.md` and performs light housekeeping on the training manual.
- **Logs**: `design-journal/.hook.log`, `design-journal/.weekly.log`.

## Before shipping to GitHub

- Run `.preship` from the project root. It checks for secrets, missing README, tracked `.env` files, client data, and the remote org. Fix anything it flags before pushing.

## Never ask the user to

- run hooks, open the `/hooks` menu, restart Claude Code, check logs, or verify settings.
- remember configuration details.
- manually invoke any part of the journal or training-manual automation.

The system is fully self-running. If something needs fixing, fix it silently and move on, or flag the specific issue — but never hand the user a checklist of setup steps.
