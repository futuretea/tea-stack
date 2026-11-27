---
name: debug
description: "Diagnose and fix bugs or test failures using a scientific loop: reproduce, hypothesize, isolate variables, and apply a minimal root-cause fix."
---

# Debug

Diagnose bugs, unexpected behavior, and failing tests systematically. **Never guess-and-patch blindly.**

## Workflow

### 1. Lock Down Symptoms and Minimal Reproduction
- Record the exact input/steps, expected behavior, and actual behavior (including full error messages or stack traces).
- Build the smallest, fastest deterministic reproduction (e.g., a single targeted test or minimal command).
- If the bug cannot be reproduced yet, identify the missing state or environment factor before changing production code.

### 2. Form Falsifiable Hypotheses
- Based on observations and code reading, list **2–3 plausible root causes**.
- For each hypothesis, define the distinguishing test: what should we observe if it is true, and what evidence rules it out?

### 3. Isolate Variables and Gather Evidence
- Test one hypothesis at a time (inspect call chains, check actual runtime state, run targeted tests, or add temporary minimal probes).
- Keep track of ruled-out hypotheses and why they were eliminated so you do not loop in circles.
- If two consecutive experiments contradict your mental model, pause and challenge base assumptions (wrong branch, stale build/cache, ignored config, wrong process).

### 4. Apply the Minimal Root-Cause Fix
- Fix the underlying cause rather than papering over the symptom with defensive checks.
- Check whether the same module contains sibling instances violating the same invariant; fix proven sibling defects in the same module without expanding into unrelated areas.
- Remove all temporary debug logs or probes.

### 5. Verify and Prevent Regressions
- Re-run the minimal reproduction from Step 1 to confirm the failure is gone.
- Add or update an automated test that fails before the fix and passes after.
- Run the relevant test suite and build/lint checks to verify no regressions.

## Handoff Format

- **Symptom & Repro**: Exact reproduction command or trigger.
- **Root Cause**: Verified explanation (`path:line`) plus key ruled-out hypotheses.
- **Fix**: Concise summary of the minimal change.
- **Verification**: Reproduction result + automated test/build output summary.
