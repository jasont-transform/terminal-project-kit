---
id: decision-001-example-runtime-choice
type: decision
date: 2026-04-15
topic: architecture
tags: [example, tour, runtime]
status: accepted
related: []
---

# 001 — Use a Node runtime for the tour demo

**Date:** 2026-04-15
**Status:** Accepted

## Context

This is an **example decision** showing what an ADR looks like in this kit. The tour demo needs a runtime. Two options were on the table: a pure-static HTML page, or a small Node service that can demonstrate end-to-end features.

## Decision

Use a thin Node service hosted on the Kit's assigned port.

## Why

A static page cannot demonstrate the live-edit flow that makes the Kit interesting. A Node service matches how real projects will be structured. Cost is low — the Kit already assigns a port per project.

## Consequences

- The tour assumes Node is installed locally. Add a check in the Kit's `proj-doctor`.
- Future tour features (server-rendered view, persistence) are unblocked.
