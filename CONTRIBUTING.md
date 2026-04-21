# Contributing

The kit is small and opinionated by design. Contributions welcome, with a few principles:

## Principles

1. **Zero daily friction.** A new feature must not require the user to remember to do anything.
2. **Idempotent installs.** `install.sh` re-run must be safe.
3. **Conventional over configurable.** If it needs a config knob, challenge whether it should be in the kit at all.
4. **macOS first.** Linux compat would be welcome but is not a blocker for v1.

## Development workflow

1. Fork and clone.
2. Make changes in a feature branch.
3. Test against a clean-ish environment:
   - `./install.sh` on a test Mac account if possible.
   - At minimum, `bash -n` on every shell script you touch.
4. Update `CHANGELOG.md`.
5. Open a PR.

## What lives where

- `install.sh`, `update.sh`, `uninstall.sh` — top-level lifecycle scripts.
- `kit/template/` — the per-project template. Every new project is a copy of this with placeholders substituted.
- `kit/scripts/` — the commands a user runs (`newproj`, `preship`, `proj-doctor`, etc.).
- `kit/shell/proj.zsh` — the `proj` shell function + aliases, sourced from user's `.zshrc`.
- `kit/skills/` — Claude Code slash commands (user-level, installed into `~/.claude/commands/`).
- `kit/defaults/` — files seeded once at install into `~/projects/`.
- `kit/demo/` — content for the example/demo project.

## Bug reports

Include output of `proj-doctor`. It covers 90% of issues.
