---
name: using-tea-stack
description: Use when starting a coding session or choosing a workflow step. Routes tasks to the minimal tea-stack skill proportional to risk and enforces the 5 core production guardrails.
---

# Using tea-stack

Keep workflow overhead proportional to risk: move fast on clear small edits, and apply structure only where mistakes are expensive.

## Skill Routing

| Situation | Use Skill |
|---|---|
| Multi-file edit (3+ files), public API/schema change, or ambiguous design | `write-plan` |
| Bug, flaky behavior, or failing test | `debug` |
| Reviewing a diff/PR or auditing critical changes (prefer a fresh session or `code-reviewer` sub-agent) | `review-code` |
| Final check before opening a PR, handing off to QA, or merging | `feature-ready` |

Skip heavy ceremony for small, obvious, single-spot edits: read the code, make the minimal change, run relevant checks, and report concisely.

## Five Non-Negotiable Guardrails

1. **Minimal scope**: Fix only what the task requires. Report out-of-scope pre-existing issues instead of silently editing them.
2. **Real verification**: Run applicable build/test/lint commands. Never weaken assertions, skip tests, or swallow errors to make checks pass.
3. **Facts over guesses**: Cite `path:line` or command output for claims; label unverified points as assumptions.
4. **Independent review on critical paths**: Never rely solely on same-context self-review for public contracts, auth/security, or data integrity changes.
5. **Human owns irreversible & contract decisions**: Ask before irreversible operations, public API breaks, schema changes, or unauthorized `git commit`/`git push`.
