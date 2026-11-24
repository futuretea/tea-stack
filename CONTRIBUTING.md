# Contributing to tea-stack

`tea-stack` is intentionally lightweight and zero-dependency. Keep changes compact, self-contained, and compatible across all five supported harnesses.

## Size and Format Budgets

- **`rules/AGENTS.md`**: target ~4 KB (hard cap 5 KB). When adding a rule at budget, merge or replace an older clause instead of expanding the file.
- **`skills/*/SKILL.md`**: target 1.5–3 KB (hard cap 3.5 KB). YAML frontmatter must contain only `name` and `description`.
- **Language**: keep `rules/`, `skills/`, `agents/`, `templates/`, and `examples/` in concise English. When updating `README.md` or `docs/TEAM-PLAYBOOK.md`, update the matching `.zh-CN.md` file in the same change.
- **Self-contained**: every referenced skill name, agent name, relative path, and command must exist inside this repository or be standard tooling. Never include machine-local absolute paths or secrets.

## Multi-Harness Plugin Manifests

When touching plugin manifests, preserve each harness's schema constraints:

- **Claude Code**: `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
- **Antigravity (`agy`)**: `.antigravity-plugin/plugin.json`
- **Codex**: `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json` — keep `"hooks": {}` so Codex does not scan for hooks and trigger install-time trust prompts.
- **Cursor**: `.cursor-plugin/plugin.json` and `.cursor-plugin/marketplace.json` — keep top-level `"skills": "./skills/"` and object-form `"author": { "name": "..." }`.
- **Kimi Code**: `.kimi-plugin/plugin.json` — keep only supported fields (`skills`, `sessionStart`, `interface`; `agents/` is auto-discovered). Do not add unsupported keys (`tools`, `apps`, `inject`, `configFile`, `config_file`, `bootstrap`).

## Verification Before Opening a PR

Run these checks locally (also enforced by `.github/workflows/validate.yml`):

```bash
bash -n install.sh
./install.sh --target all --dry-run
```

If you have the corresponding CLIs installed and edited plugin manifests, also verify with `claude plugin validate`, `agy plugin validate --strict`, and Codex marketplace install in a temporary `CODEX_HOME`.
