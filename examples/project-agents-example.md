# Example: Filled-In Repository `AGENTS.md`

<!--
This is a fictional, minimal example (~40 lines) showing the right level of detail
for a real repository. Notice how it avoids duplicating linter rules or obvious directory listings.
-->

## 1. Overview and Map

- **What this repo does**: Task billing and webhook notification service (`order-billing`).
- **Stack**: TypeScript 5.x (Node 22), Fastify, PostgreSQL (Prisma), Vitest.
- **Key directories**:
  - `src/domain/`: Pure pricing and invoice state logic (no HTTP or Prisma imports).
  - `src/http/`: REST handlers and request schemas (external contract).
  - `prisma/migrations/`: Append-only SQL migrations (never edit applied migrations).
  - `src/generated/`: OpenAPI client types (**do not edit manually**; run `pnpm run codegen`).

## 2. Verification Commands

```bash
pnpm run typecheck
pnpm test              # targeted: pnpm test src/domain/invoice.test.ts
pnpm run lint
```

## 3. Invariants and Guardrails

- **Idempotency**: Every billing charge endpoint must preserve the `Idempotency-Key` contract.
- **PII & secrets**: Never log raw `customerEmail`, `cardLast4`, or webhook signing secrets.
- **Test isolation**: Unit tests must use the in-memory repository fake in `tests/fakes/`; never connect to a live database.

## 4. Local Conventions and Known Pitfalls

- **Errors**: Throw typed domain errors from `src/domain/errors.ts`; HTTP mapping lives solely in `src/http/error-handler.ts`.
- **Config**: New env vars must be added to both `src/config/env.ts` and `.env.example`.
- **Pitfall**: Webhook retries expect non-2xx responses on transient failures—do not catch and return `200 OK` on downstream timeouts.

## 5. Working Agreement

1. Run `write-plan` before changes touching both `src/domain/` and `src/http/` or adding migrations.
2. Run typecheck, tests, and lint before handoff.
3. Run an independent `review-code` pass on any billing or webhook change, then finish with `feature-ready`.
