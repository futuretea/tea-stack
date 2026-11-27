---
name: write-plan
description: Use when editing 3+ files, changing contracts, or facing ambiguous scope. Drafts a concise one-page implementation plan before coding.
---

# Write Plan

Align on scope, trade-offs, and verification **before** editing code so implementation stays minimal and predictable.

## When to Use

- Changes touching 3+ files or crossing module boundaries
- Modifications to public APIs, schemas, configs, auth, or state transitions
- Tasks with multiple viable designs or unclear acceptance criteria

Skip this skill for small, obvious, single-spot edits.

## Workflow

1. **Read before designing**
   - Inspect directly relevant source files, types, call sites, and tests.
   - Never invent file paths, symbols, or existing behavior without reading them first.
2. **Define scope and open decisions**
   - State both **Goals** and explicit **Non-Goals**.
   - Surface any ambiguity affecting external contracts, compatibility, or value trade-offs with options and a recommendation.
3. **Slice into verifiable steps**
   - Order steps so each slice can be built or tested incrementally.
   - Prefer minimal edits and existing abstractions over speculative refactors.
4. **Specify deterministic verification**
   - List exact build/lint/test commands, key test cases (happy path, boundaries, failures), and any required runtime check.

## Output Template

```markdown
# Plan: <short title>

## 1. Goal and Non-Goals
- **Goal**: Concrete problem solved and acceptance criteria.
- **Non-Goals**: Related things intentionally left untouched.

## 2. Current State and Affected Scope
- Verified current behavior (with `path:line` evidence)
- Files to modify or add and each file's responsibility

## 3. Design and Trade-offs
- Chosen approach (data/control flow summary)
- Key trade-off: why A over B (omit if straightforward)
- Decisions needed from human (if any)

## 4. Implementation Steps
1. [Step 1] Edit summary -> verification check
2. [Step 2] Edit summary -> verification check

## 5. Verification Plan
- Automated gates: `<build / lint / test commands>`
- New or updated tests: key scenarios and edge cases
- Manual / runtime verification (if applicable)

## 6. Risks and Rollback
- Main risks and mitigation (or "Low risk; revert commit")
```

## Quality Bar

- **Grounded in code**: Every claim about existing behavior cites `path:line`.
- **One page max**: Dense and actionable; no filler prose.
- **Pause on open decisions**: If human sign-off is required on scope or external contracts, stop after presenting the plan instead of coding immediately.
