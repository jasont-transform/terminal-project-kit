# Changelog

All notable changes to this project will be documented here. Format loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.1.0] — 2026-04-19

First release.

### Added
- Per-project design journal with logbook, weekly digest, decisions, experiments, artefacts, glossary, training manual.
- YAML frontmatter convention across all Markdown files (AI-extractable).
- Stop hook — auto-updates logbook and training manual at the end of every Claude Code session.
- Weekly `launchd` job — rolls up the week every Monday 09:00.
- `newproj` command — scaffold a new project with auto-assigned port and wired automation.
- `preship` command — pre-ship safety gate (secrets, client data, README, remote-org check).
- `proj` shell function — list and jump between projects.
- `proj-doctor` — diagnostic health check.
- `proj-ports` — show which projects are running on which ports.
- `proj-review` — coaching review via `claude -p` across the current project.
- `proj-digest` — weekly cross-project summary.
- `proj-init-remote` — one-command GitHub repo creation and push.
- `proj-demo` — scaffold a pre-populated example project.
- Claude Code slash commands: `/decide`, `/experiment`, `/glossary`, `/note`.
- Claude Code status line showing current project, port, and git branch.
