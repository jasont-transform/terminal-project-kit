# Projects

A single page that knows where every project is, what port it runs on, and when it was last touched.

## Active

| Project | Port | Created | Notes |
|---------|------|---------|-------|

## Archived

_None yet._

## How this works

Every project under `~/projects/` follows the same kit:

- Its own `design-journal/` (logbook, weekly digests, decisions, experiments, artefacts, glossary, training manual).
- Its own `CLAUDE.md` with project-specific rules.
- Its own `.claude/settings.json` with a project-scoped Stop hook.
- Its own unique localhost port (registered in `.ports.json`).
- Its own weekly launchd job that rolls up the week.
- Memory and conversation history kept inside the project directory so nothing spills between projects.

## Commands

- `proj` — list your projects.
- `proj <name>` — jump into a project and resume Claude Code.
- `newproj <name>` — scaffold a new project (auto-assigns next port).
- `preship` — pre-ship safety gate, run from inside a project before `git push`.
- `proj-doctor` — diagnostic health check.
- `proj help` — show all commands.
