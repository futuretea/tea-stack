---
name: review-code
description: Perform an independent, evidence-based P0/P1/P2 code review on a diff, PR, or set of changes.
---

# Review Code

Inspect code changes from an independent reviewer's perspective to catch real defects without nitpicking or hallucinating risks.

## Independence Rule

- **Run this in a fresh session or independent sub-agent whenever possible**, rather than reviewing in the same context that authored the code.
- Treat the actual `git diff`, source files, and test output as the only source of truth—do not trust an author's summary at face value.

## Review Dimensions (Priority Order)

1. **Correctness & Edge Cases**: Logic bugs, null/empty/zero values, off-by-one errors, swallowed errors, inconsistent state.
2. **Contracts & Compatibility**: Broken callers, schema/serialization mismatches, changed error semantics, config drift.
3. **Security & Data Integrity**: Auth/permission gaps, injection vectors, secret/PII leaks, races, partial writes leaving dirty state.
4. **Scope & Restraint**: Unrelated edits, speculative abstractions, unnecessary compatibility shims, over-defensive clutter.
5. **Verification Quality**: Missing tests for critical paths/edge cases, or weakened assertions that mask regressions.

## Severity Rubric

- **P0 (Blocker)**: Confirmed wrong behavior, data loss/corruption, security vulnerability, or broken public contract.
- **P1 (Significant)**: Likely edge-case failure, meaningful performance regression, missing verification on a critical path, or severe maintainability hazard.
- **P2 (Optional)**: Naming, readability, or minor cleanup suggestions (non-blocking).

## Evidence Discipline

- **No evidence, no severity**: Every `P0` or `P1` must include `path:line`, a concrete trigger path, and the actual impact.
- **Verify before claiming**: Before flagging a broken caller or missing guard, check the callers and upstream code. If you cannot verify a suspicion in the current environment, place it under *Unverified / Assumptions* rather than assigning `P0`/`P1`.
- **Respect scope**: Do not flood the report with `P2` style nits on untouched legacy code. If you spot a serious pre-existing defect adjacent to the diff, label it clearly as *Out-of-scope pre-existing issue*.

## Output Format

```markdown
## Review Verdict: <Pass | Pass with Notes | Request Changes>

Scope reviewed: <branch / commit range / file list>

### P0 (Blockers)
- **[P0-1] <Short title>** (`path/to/file:line`)
  - **Issue**: What is wrong and how it triggers.
  - **Impact**: Concrete consequence.
  - **Suggested fix**: Minimal direction to resolve.

### P1 (Should Address)
- ...

### P2 (Optional)
- ...

### Unverified Scope / Assumptions
- Checks not executed or hypotheses that could not be verified locally (or "None").
```

If there are no `P0`/`P1` findings, say so plainly—never invent issues to look thorough.
