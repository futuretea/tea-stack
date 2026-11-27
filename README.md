# tea-stack

[English](./README.md) | [简体中文](./README.zh-CN.md)

A **lightweight, low-token-tax workflow plugin** for **Claude Code**, **Codex**, **Antigravity (`agy`)**, **Cursor**, **Kimi Code**, **Qoder CLI (`qodercli`)**, **GitHub Copilot CLI (`copilot`)**, and **DeepSeek Harness (`dsh`)**.

If heavyweight agent frameworks feel too rigid or burn too many tokens on routine work, `tea-stack` gives you the minimal production guardrails that actually prevent costly mistakes: **~4 KB of baseline rules, 5 focused skills, and a read-only independent code reviewer**.

## Why `tea-stack`?

- **Low ceremony, proportional to risk**: Move straight to edits on clear small fixes; invoke structured planning and independent review only when changes cross modules or touch contracts.
- **Low token tax, no silent truncation**: Compact rules (~4 KB) and small on-demand skills (~1.5–3 KB each) stay well below host context limits.
- **Real independence on reviews**: Ships a dedicated read-only `code-reviewer` sub-agent so critical diffs are audited outside the authoring context.
- **Native multi-tool packaging**: One clean repository supporting Claude Code, Codex, Antigravity, Cursor, Kimi Code, Qoder CLI, GitHub Copilot CLI, and DeepSeek Harness—plus a zero-magic fallback installer.

## Install (10 Seconds)

### Claude Code
```text
/plugin marketplace add futuretea/tea-stack
/plugin install tea-stack@tea-stack
```

### Antigravity (`agy`)
```bash
agy plugin install https://github.com/futuretea/tea-stack
```

### Codex
```bash
codex plugin marketplace add https://github.com/futuretea/tea-stack.git
codex plugin add tea-stack@tea-stack
```
*(Or symlink skills directly via `./install.sh --target codex`)*

### Cursor
```text
/add-plugin https://github.com/futuretea/tea-stack
```
*(Or symlink skills via `./install.sh --target cursor`)*

### Kimi Code
- **TUI Plugin Manager**: run `/plugins install https://github.com/futuretea/tea-stack` inside Kimi Code, then start a fresh session with `/new` (powered by [`.kimi-plugin/plugin.json`](./.kimi-plugin/plugin.json)).
- **Symlink or CLI Skills Directory**: symlink once via `./install.sh --target kimi`, or load directly via `kimi --skills-dir /path/to/tea-stack/skills`. Note that `--skills-dir` replaces (rather than appends to) auto-discovered user and project skill directories, so prefer `/plugins` or `./install.sh --target kimi` if you already use other skills.

### Qoder CLI (`qodercli`)
```bash
qodercli plugins marketplace add futuretea/tea-stack
qodercli plugins install tea-stack@tea-stack
```
*(Or symlink skills into `${QODER_CONFIG_DIR:-~/.qoder}/skills` via `./install.sh --target qodercli`, or shared `~/.agents/skills` via `./install.sh --target agents`.)*

### GitHub Copilot CLI (`copilot`)
```bash
copilot plugin install futuretea/tea-stack
```
*(Or symlink skills into `${COPILOT_HOME:-~/.copilot}/skills` via `./install.sh --target copilot`, or shared `~/.agents/skills` via `./install.sh --target agents`.)*

### DeepSeek Harness (`dsh`)
```bash
./install.sh --target dsh
```
*(Symlinks skills into `${DSH_HOME:-~/.dsh}/skills`—or use `./install.sh --target agents` for shared `~/.agents/skills`; merge [`rules/AGENTS.md`](./rules/AGENTS.md) into `~/.dsh/AGENTS.md` as needed.)*

### Symlink Fallback (macOS / Linux — Any Agent)
```bash
# Preview symlinks without modifying anything
./install.sh --target all --dry-run

# Supported targets: claude | codex | agy | cursor | kimi | qodercli | copilot | dsh | agents | all
./install.sh --target kimi

# Shared directory (auto-discovered by qodercli, copilot, and dsh; excluded from --target all)
./install.sh --target agents

# Or install into any custom skills directory
./install.sh --skills-dir ~/.config/agents/skills
```

> `install.sh` only symlinks `skills/*` and skips existing files/symlinks. It never overwrites your existing global `AGENTS.md` / `CLAUDE.md`.

## Core Workflow

```text
Task / Requirement
  │
  ├─ Multi-file / Contract / Risky ──▶ write-plan (align scope & verification first)
  │                                        │
  └─ Small & Well-scoped ──────────────────┴──▶ Implement + Run Tests
                                                   │
                          Unexpected failure ◀─────┤
                                 │                 │
                               debug               ▼
                                             review-code (fresh session / code-reviewer)
                                                   │
                                                   ▼
                                             feature-ready (gates + PR summary)
```

## What's Inside

| Path | Purpose |
|---|---|
| [`skills/using-tea-stack/SKILL.md`](./skills/using-tea-stack/SKILL.md) | Lightweight workflow router & 5 non-negotiable guardrails |
| [`skills/write-plan/SKILL.md`](./skills/write-plan/SKILL.md) | One-page implementation plan before editing across modules or changing contracts |
| [`skills/debug/SKILL.md`](./skills/debug/SKILL.md) | Scientific debugging loop: reproduce -> hypothesize -> isolate -> minimal root-cause fix |
| [`skills/review-code/SKILL.md`](./skills/review-code/SKILL.md) | Evidence-based `P0`/`P1`/`P2` code review designed for independent review |
| [`skills/feature-ready/SKILL.md`](./skills/feature-ready/SKILL.md) | Pre-PR readiness check (diff hygiene, deterministic gates, risk review, PR summary draft) |
| [`agents/code-reviewer.md`](./agents/code-reviewer.md) | Read-only independent reviewer sub-agent definition |
| [`rules/AGENTS.md`](./rules/AGENTS.md) | Compact global rule baseline (~4 KB; auto-loaded by Antigravity plugin or merged manually) |
| [`templates/PROJECT-AGENTS.md`](./templates/PROJECT-AGENTS.md) | Fill-in-the-blank `<150-line` repo `AGENTS.md` / `CLAUDE.md` template |
| [`examples/`](./examples/) | Filled-in repo `AGENTS.md` example + concrete `review-code` output example |
| [`docs/TEAM-PLAYBOOK.md`](./docs/TEAM-PLAYBOOK.md) | Team rollout guide, anti-patterns, and 2-week pilot plan ([中文版](./docs/TEAM-PLAYBOOK.zh-CN.md)) |

### Plugin Manifests & Component Support

| Harness | Manifest | Skills (5) | `code-reviewer` Agent | `rules/AGENTS.md` | SessionStart Router |
|---|---|---|---|---|---|
| **Claude Code** | [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json) + [marketplace](./.claude-plugin/marketplace.json) | Auto | Auto (`agents/`) | Manual merge | Skill description |
| **Antigravity (`agy`)** | [`.antigravity-plugin/plugin.json`](./.antigravity-plugin/plugin.json) | Auto | Auto (`agents/`) | Auto (`rules/`) | Skill description + rules |
| **Codex** | [`.codex-plugin/plugin.json`](./.codex-plugin/plugin.json) + [marketplace](./.agents/plugins/marketplace.json) | Auto | Use fresh session / native sub-agent | Manual merge | Skill description |
| **Cursor** | [`.cursor-plugin/plugin.json`](./.cursor-plugin/plugin.json) + [marketplace](./.cursor-plugin/marketplace.json) | Auto | Use fresh session / native sub-agent | Manual merge | Skill description |
| **Kimi Code** | [`.kimi-plugin/plugin.json`](./.kimi-plugin/plugin.json) | Auto | Auto (`agents/`) | Manual merge | Auto (`sessionStart.skill`) |
| **Qoder CLI (`qodercli`)** | [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json) + [marketplace](./.claude-plugin/marketplace.json) | Auto | Auto (`agents/`) | Manual merge (`~/.qoder/AGENTS.md`) | Skill description |
| **GitHub Copilot CLI (`copilot`)** | [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json) + [marketplace](./.claude-plugin/marketplace.json) | Auto | Auto (`agents/`) | Manual merge (`~/.copilot/copilot-instructions.md`) | Skill description |
| **DeepSeek Harness (`dsh`)** | Symlink (`./install.sh --target dsh` / `agents`) | Auto (`~/.dsh/skills`, `~/.agents/skills`) | Use fresh session / native sub-agent | Manual merge (`~/.dsh/AGENTS.md`) | Skill description |

## Adopting in a Repository

1. Install the plugin in your preferred coding agent above.
2. Copy [`templates/PROJECT-AGENTS.md`](./templates/PROJECT-AGENTS.md) to your repo root as `AGENTS.md` (or `CLAUDE.md`) and fill in your build/test/lint commands (see [`examples/project-agents-example.md`](./examples/project-agents-example.md)).
3. Optionally merge clauses you like from [`rules/AGENTS.md`](./rules/AGENTS.md) into your global instructions.

## License

[MIT](./LICENSE)
