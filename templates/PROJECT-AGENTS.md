# Repository Agent Instructions Template

<!--
Copy this file to your repository root as `AGENTS.md` (or `CLAUDE.md`) and replace placeholders.
Guideline: Keep it under ~150 lines. Only document what an agent cannot infer from reading the code.
Push formatting, import order, and style rules to linters/CI instead of prose.
-->

## 1. Overview and Map

- **What this repo does**: <one-sentence summary of the app, service, or library>
- **Stack**: <language/runtime version, main framework, key datastore or build tool>
- **Key directories**:
  - `<src/core/>`: Core domain/business logic (keep decoupled from I/O or UI details)
  - `<src/interfaces/>`: Public APIs, routes, components, or CLI entrypoints
  - `<tests/>`: Test suites and fixtures
  - `<generated/>`: Generated artifacts (**do not edit manually**; run `<codegen command>`)

## 2. Verification Commands

```bash
# Build / typecheck
<build-or-typecheck-command>

# Unit / targeted tests (run affected scope during iteration, full suite before handoff)
<test-command>

# Lint / static checks
<lint-command>
```

## 3. Invariants and Guardrails

- **External contracts**: Confirm before breaking public interfaces, exported types, serialized formats, or persistent schemas.
- **Security & privacy**: Never log secrets, credentials, or PII; never bypass the standard auth/permission boundary.
- **Generated & lock files**: Update only through package/codegen commands, not manual edits.
- **Test isolation**: Unit tests must not hit live external services or shared environments; stub/fake external boundaries.

## 4. Local Conventions and Known Pitfalls

- **Error handling**: <briefly describe the convention and link 1 canonical example file>
- **Configuration**: <where new env vars / config keys must be registered or documented>
- **Known pitfalls**: <list only real recurring traps in this repo; delete if none>

## 5. Working Agreement

1. For multi-file or contract changes, draft a brief plan (`write-plan`) before coding.
2. Run the commands in Section 2 before finishing; report any check that could not run.
3. For high-risk changes, run an independent `review-code` pass and finish with `feature-ready`.
