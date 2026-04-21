# __PROJECT_NAME__

<!-- one-line description of what this project is -->

## Running locally

```
npm install
npm start
```

Opens at http://localhost:__PROJECT_PORT__.

## Environment

Copy `.env.example` to `.env` and fill in the values you need.

## Documentation

- `design-journal/training-manual.md` — codified lessons and patterns for other designers.
- `design-journal/decisions/` — architectural decisions (ADR-style).

## Before pushing to GitHub

Run `.preship` from this directory. It'll scan for secrets, client data, missing documentation, and verify the remote. Fix anything it flags.
