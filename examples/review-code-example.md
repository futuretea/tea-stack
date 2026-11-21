# Example: Independent `review-code` Output

<!--
Fictional example demonstrating evidence-based P0/P1/P2 findings without filler or speculation.
-->

## Review Verdict: Request Changes

Scope reviewed: `git diff main...feat/invoice-retry` (`src/domain/retry.ts`, `src/http/webhooks.ts`, `src/domain/retry.test.ts`)

### P0 (Blockers)
- **[P0-1] Retry handler returns `200 OK` on downstream timeout, silently dropping failed webhooks** (`src/http/webhooks.ts:64-71`)
  - **Issue**: The new `catch (err)` block logs `TimeoutError` and returns `reply.code(200).send({ ok: true })`.
  - **Impact**: Per repo contract, the webhook dispatcher only retries on non-2xx responses; returning `200` permanently drops billing events during transient outages.
  - **Suggested fix**: Re-throw or return `503` for retryable timeouts and add a handler test asserting non-2xx status.

### P1 (Should Address)
- **[P1-1] Retry delay overflows when `attempt` exceeds 30** (`src/domain/retry.ts:19`)
  - **Issue**: `Math.pow(2, attempt) * BASE_MS` is capped only after multiplication, and callers in `src/http/webhooks.ts:48` do not bound `attempt` parsed from headers.
  - **Impact**: Malformed or large `attempt` values can compute `Infinity` / `NaN`, causing immediate spin retries.
  - **Suggested fix**: Clamp `attempt` before exponentiation (e.g., `Math.min(Math.max(attempt, 0), MAX_ATTEMPT)`) and cover negative/large values in `src/domain/retry.test.ts`.

### P2 (Optional)
- **[P2-1] Extract duplicate header parsing helper** (`src/http/webhooks.ts:44,82`)
  - `x-retry-attempt` parsing is duplicated across two routes; optional to consolidate later.

### Unverified Scope / Assumptions
- Live integration against the external webhook sandbox was not executed locally (unit tests only).
