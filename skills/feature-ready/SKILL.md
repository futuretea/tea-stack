---
name: feature-ready
description: Run a pre-PR or pre-release readiness check covering diff hygiene, build/test/lint gates, risk surfaces, and PR summary generation.
---

# Feature Ready

Perform a structured, honest readiness check before opening a PR, handing off to QA, or merging.

## Checklist

### 1. Diff Hygiene and Scope
- Run `git status` and `git diff --stat` (or `git diff <base>...HEAD` when comparing against a base branch).
- Confirm there are no:
  - Unrelated formatting diffs or drive-by refactors
  - Leftover debug logs, commented-out dead code, or untracked scratch files
  - Secrets, tokens, machine-specific absolute paths, or sensitive fixture data

### 2. Deterministic Gates
- Run the repository's build, test, and lint commands directly—do not report "should pass" from memory.
- Record each command and its actual result. If a gate cannot run locally due to environment limits, mark it `Not Run` with the exact reason.

### 3. Risk Surface Check
Verify whether the change touches any of the following, and note the safeguard if so:
- Public APIs, exported types, serialized formats, or config keys (backward compatibility & docs)
- Persistent storage / schema migrations (migration & rollback path)
- Authentication, authorization, or sensitive data handling
- Shared utilities or cross-module primitives (call-site audit)

### 4. Independent Review Status
- For medium/high-risk or multi-file changes, verify whether an independent `review-code` pass was completed:
  - All `P0` blockers resolved
  - Any deferred `P1` items explicitly documented with rationale

### 5. Verdict and PR Summary Draft

```markdown
## Readiness Verdict: <Ready | Ready with Caveats | Not Ready>

### 1. Verification Gates
- Build: <Pass / Fail / Not Run> (`<command>`)
- Test: <Pass / Fail / Not Run> (`<command>` — summary)
- Lint: <Pass / Fail / Not Run> (`<command>`)

### 2. Blockers and Caveats
- Blockers (required if Not Ready): ...
- Known limitations / unverified scope: ...

### 3. PR Summary Draft
**Why**: One sentence on the problem or goal.
**What changed**:
- ...
**How it was verified**:
- ...
**Compatibility / Rollback**: ...
```
