# Terminal Project Kit

A batteries-included kit for running serious work in [Claude Code](https://claude.com/claude-code) across many projects. Every project gets a self-updating design journal, a training manual, and automation that runs itself.

![clawd](https://github.com/jasont-transform/terminal-project-kit/blob/main/clawd-001.jpg)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/jasont-transform/terminal-project-kit/main/install.sh | bash
```

Open a new terminal, then:

```bash
proj-demo                  # see a pre-populated example project
proj                       # list your projects
newproj my-first-project   # create one (auto-assigns port)
proj my-first-project      # jump in, Claude Code resumes
```

That's it. No config files to edit. No hooks to wire by hand.

## Publishing your own fork

Forked the repo and want to ship it from your own GitHub org? One command:

```bash
./publish.sh <your-github-org>
```

Handles `git init`, the README org substitution, the first commit, `gh repo create`, and the push.

## What you get

### Every project, auto-configured

Run `newproj <name>` and you get a ready-to-work project with:

- `design-journal/logbook/` — one Markdown entry per Claude Code session. Written automatically at the end of each session by a `Stop` hook that re-reads the transcript and produces prose.
- `design-journal/weekly/` — Monday roll-ups. Written automatically by a `launchd` job every Monday at 09:00.
- `design-journal/decisions/` — numbered ADR-style architectural records.
- `design-journal/experiments/` — what you tried, what happened, what you concluded. Failures especially.
- `design-journal/training-manual.md` — timeless lessons, insights, techniques, and patterns for whoever joins the project next.
- `design-journal/glossary.md` — project-specific vocabulary.
- `design-journal/artefacts/` — raw prompts, code snippets, generated outputs worth preserving.
- YAML frontmatter on every Markdown file so a future AI scanner can parse the whole journal cleanly.
- Per-project `CLAUDE.md` with the working agreement.
- Per-project `.claude/settings.json` wired to the Stop hook.
- Per-project auto-memory, scoped to the project.
- Unique localhost port, auto-assigned.
- `.gitignore` and `.env.example` set up sensibly.

### Commands you'll actually use

| Command | What it does |
|---|---|
| `proj` | List all projects — name, port, last session date. |
| `proj <name>` | Jump into a project and resume the most recent Claude Code session. |
| `proj help` | Show all commands. |
| `newproj <name>` | Scaffold a new project from the template. Auto-assigns the next port. Installs the weekly launchd job. Registers the project in `INDEX.md`. |
| `preship` | Pre-ship safety gate (run from inside a project before `git push`). Scans for secrets, tracked `.env`, client data, missing README, remote-org check. |
| `proj-doctor` | Diagnostic health check — verifies every part of the kit is wired correctly. Run it when anything feels off. |
| `proj-ports` | Show which projects are currently running on which ports. |
| `proj-review` | Coaching review of the current project — runs `claude -p` over your journal and gives you a direct coaching note. |
| `proj-digest` | Weekly cross-project summary. One screen, 60-second read. |
| `proj-init-remote` | Create a private GitHub repo via `gh` and push. |
| `proj-demo` | Scaffold a pre-populated example project so you can see what a healthy journal looks like. |

### Claude Code slash commands

Available inside every Claude Code session:

- `/decide <title>` — scaffold a new decision file with frontmatter ready.
- `/experiment <title>` — scaffold a new experiment entry.
- `/glossary <term>` — add a term to the glossary.
- `/note <text>` — append a line to today's logbook without leaving the terminal.

### Status line

When you're inside Claude Code, the status line shows the current project, its port, and git branch — so you always know which project you're in.

## Why this exists

Claude Code is extraordinary on its own. But serious, multi-week projects need scaffolding that Claude Code doesn't provide out of the box: a durable memory that survives `/clear`, a record you can hand to a colleague, a structured way to capture failures and lessons.

This kit provides that scaffolding, runs it automatically, and imposes no discipline the user has to remember. The knowledge base grows itself in the background as you work.

## Requirements

- macOS (tested on Darwin 25+).
- `claude` (the Claude Code CLI). [Install docs](https://claude.com/claude-code).
- `jq` — auto-downloaded as a portable static binary if not already installed. No brew or Xcode required.
- `gh` — optional, for `proj-init-remote`. [Install docs](https://cli.github.com).
- zsh (the default shell on macOS since Catalina).

## Update

```bash
~/.claude-project-kit/update.sh
```

Pulls the latest kit version, refreshes the template and scripts. Does not touch your existing projects.

## Uninstall

```bash
~/.claude-project-kit/uninstall.sh
```

Removes the kit. Your projects under `~/projects/` are left alone.

## Design principles

1. **Zero daily friction.** The user should never have to run a hook, open a menu, or remember a configuration detail.
2. **Live writes beat post-hoc summaries.** The Stop hook is a safety net — Claude is instructed to keep the logbook live during each session.
3. **Fail loudly, recover silently.** Hooks log errors to `.hook.log`; they never block the user.
4. **Every Markdown file is AI-extractable.** Consistent YAML frontmatter, stable IDs, cross-references via `related`. A future scanner gets a graph, not prose.
5. **Convention over configuration.** One template. One way. Every project identical in structure.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT. See [LICENSE](LICENSE).
