# Team Playbook

A practical guide for adopting AI coding agents in production engineering teams without trading away code quality.

---

## 1. The Real Goal: Predictable Production Quality, Not Just Speed

Most teams see fast wins on demos, boilerplate, and one-off scripts—then hit friction on real production work:
- Agents edit files outside the task scope.
- Failing tests get "fixed" by loosening assertions.
- Plausible-looking diffs hide subtle contract or concurrency bugs that shift the cost onto human reviewers.

Fixing this rarely requires heavier prompts. It requires **four engineering habits**:

1. **High-signal, compact rules**: Document only what an agent cannot infer from code; keep instructions short enough to avoid context bloat and silent truncation.
2. **Plan before editing**: Spending 3 minutes aligning on a one-page plan for cross-module work prevents rewriting 500 lines later.
3. **Separate authoring from review (Producer != Reviewer)**: Run code review in a fresh session or independent sub-agent from raw diff and source.
4. **Deterministic gates over prose**: Compilers, type checkers, linters, and tests are the enforcement layer—never rely on "looks good to me" prose.

---

## 2. The 4-Step Delivery Loop

| Stage | Skill / Asset | Purpose | Human Checkpoint |
|---|---|---|---|
| 1. Align | `write-plan` | Define goals, non-goals, affected files, trade-offs, verification | Approve scope & external contracts |
| 2. Build | Agent + repo `AGENTS.md` | Minimal sliced edits + matching tests | Unblock ambiguities |
| 3. Debug (if needed) | `debug` | Reproduce -> hypothesize -> isolate -> minimal root-cause fix | Collaborate on complex root causes |
| 4. Review & Ship | `review-code` + `feature-ready` | Fresh-context `P0`/`P1` audit, deterministic gates, PR summary | Final merge & release decision |

> Keep it proportional: small, clear edits can go straight from edit -> test -> handoff. Reserve the full loop for multi-file, contract, or high-risk work.

---

## 3. Human vs. AI Responsibility Split

| Humans Own (Value & Accountability) | Agents Own (Investigation & Execution) |
|---|---|
| Scope trade-offs and explicit non-goals | Tracing call sites and reading existing code |
| Public API, schema, and external contract changes | Sliced implementation and test updates |
| Risk acceptance (e.g., deferring a `P1`) | Evidence-based diff review (`path:line`) |
| Final merge, deployment, and rollback calls | Reproducing bugs and running build/test/lint gates |

---

## 4. Five Common Anti-Patterns

1. **Turning `AGENTS.md` into a company encyclopedia**
   - *Symptom*: 10k-word rules files that burn tokens, get truncated, and get ignored.
   - *Fix*: Cap repo `AGENTS.md` at ~150 lines; move style/formatting rules to linters.

2. **Installing 100+ skills on day one**
   - *Symptom*: Trigger collisions, inconsistent behavior, and nobody remembers what exists.
   - *Fix*: Start with these 4 core skills. Add a team skill only after the same workflow pain recurs 3+ times.

3. **Reviewing code in the same session that wrote it**
   - *Symptom*: The model rationalizes its own decisions and misses real edge cases.
   - *Fix*: Always run `review-code` in a fresh session or independent sub-agent on critical changes.

4. **Allowing drive-by refactors**
   - *Symptom*: Small bug fixes balloon into noisy diffs that hide regressions.
   - *Fix*: Enforce "report out-of-scope issues, do not silently fix them" and check `git diff --stat` in `feature-ready`.

5. **Tolerating weakened tests to get green CI**
   - *Symptom*: Relaxed assertions or skipped specs silently disable safety nets.
   - *Fix*: Make "never weaken assertions or skip tests to pass" a hard rule in both global rules and PR review.

---

## 5. Two-Week Low-Friction Pilot

Avoid rolling out across an entire org at once. Run a small two-week pilot instead:

- **Week 1 (One repo, one champion)**: Pick one active repo with a working test suite. Add a lean `AGENTS.md` (<150 lines). Run 2–3 real tasks through the full loop and collect 1–2 concrete examples of bugs caught by independent review.
- **Week 2 (2–3 teammates)**: Have 2–3 engineers use the exact same baseline on real tickets. Track:
  - Which rules actually prevented mistakes vs. which felt like noise?
  - What real `P0`/`P1` issues did independent review catch (and any false positives)?
  - Where did friction remain (slow tests, missing domain docs, flaky environments)?
- **End of Week 2 (Prune & decide)**: Delete unused rules, add only verified recurring pitfalls to the repo `AGENTS.md`, and decide whether to expand to the next repository.
