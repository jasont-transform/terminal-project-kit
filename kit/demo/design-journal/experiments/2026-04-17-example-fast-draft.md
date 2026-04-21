---
id: experiment-2026-04-17-example-fast-draft
type: experiment
date: 2026-04-17
topic: architecture
tags: [example, tour, negative-result]
status: failed
related: [decision-001-example-runtime-choice]
---

# Fast-draft: skip the intermediate model

This is an **example experiment** showing what a failure record looks like.

**Hypothesis** — The project can go straight from user prompt to rendered output, skipping the intermediate structured-model layer. Simpler code path, fewer moving parts.

**Approach** — Wired up a direct prompt-to-render path. Used it on a trivial case (single-page service) and a non-trivial case (branching service with conditional state).

**Result** — Trivial case worked. Non-trivial case produced disjointed output — each screen was locally fine but the narrative across screens was incoherent, and the branching logic came out inconsistent between runs.

**Conclusion** — The intermediate model is not optional ceremony; it is what carries coherence across a multi-screen journey. Record this so future-us does not re-try the shortcut when the codebase gets complicated and the shortcut looks tempting again. Decision: keep the intermediate model in the architecture permanently.
