# tea-stack

[English](./README.md) | [简体中文](./README.zh-CN.md)

一套面向 **Claude Code**、**Codex**、**Antigravity (`agy`)**、**Cursor** 和 **Kimi Code** 的**轻量、低 Token 税生产研发工作流插件**。

如果你觉得重型 Agent 框架流程太繁琐、日常改动仪式感太重或 Token 消耗过高，`tea-stack` 只保留真正守住生产代码质量下限的最小闭环：**~4 KB 精简基线 + 5 个聚焦 Skill + 1 个只读独立审查员**，10 秒装完即可上手。

## 为什么做 `tea-stack`？

- **按风险伸缩，低仪式感**：明确小改动直接做完验证；跨模块、改契约或高风险任务才启用计划与独立审查，不打断开发节奏。
- **低 Token 税，不触发截断**：全局基线仅 ~4 KB，单个 Skill 仅 1.5–3 KB 按需加载，远离宿主规则截断红线。
- **把“写与审隔离”做成开箱能力**：内置只读 `code-reviewer` sub-agent，让关键改动天然在独立上下文里做证据化 `P0`/`P1`/`P2` 审查。
- **原生五端一键安装**：单个干净仓库同时原生支持 Claude Code、Codex、Antigravity、Cursor、Kimi Code，并附零副作用软链脚本兜底。

## 10 秒快速安装

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
*（或使用脚本软链安装：`./install.sh --target codex`）*

### Cursor
```text
/add-plugin https://github.com/futuretea/tea-stack
```
*（或使用脚本软链安装：`./install.sh --target cursor`）*

### Kimi Code
- **TUI 插件管理**：在 Kimi Code 内执行 `/plugins install https://github.com/futuretea/tea-stack`，安装后用 `/new` 开启新会话生效（读取 [`.kimi-plugin/plugin.json`](./.kimi-plugin/plugin.json)）。
- **软链或 CLI Skills 目录**：运行 `./install.sh --target kimi` 建立一次软链，或用 `kimi --skills-dir /path/to/tea-stack/skills` 临时加载。注意 `--skills-dir` 会替代（而非追加）自动发现的用户与项目 Skills 目录，如果已有其他 Skill 建议优先用 `/plugins` 或 `./install.sh --target kimi`。

### 通用软链脚本（macOS / Linux — 任意 Agent）
```bash
# 预览软链动作，不做任何修改
./install.sh --target all --dry-run

# 支持目标：claude | codex | agy | cursor | kimi | all
./install.sh --target kimi

# 或安装到任意自定义 Skills 目录
./install.sh --skills-dir ~/.config/agents/skills
```

> `install.sh` 仅对 `skills/*` 建立软链，遇到已有文件或软链会自动跳过，不会覆盖你现有的全局 `AGENTS.md` / `CLAUDE.md`。

## 核心工作流

```text
需求 / 任务
  │
  ├─ 跨模块 / 契约变更 / 高风险 ──▶ write-plan（先对齐范围与验证方式）
  │                                    │
  └─ 明确小改动 ───────────────────────┴──▶ 编码实现 + 运行测试
                                               │
                         遇到异常 / 失败 ◀─────┤
                                │              │
                              debug            ▼
                                         review-code（独立会话 / code-reviewer）
                                               │
                                               ▼
                                         feature-ready（门禁体检 + PR 摘要）
```

## 仓库内容

| 路径 | 用途 |
|---|---|
| [`skills/using-tea-stack/SKILL.md`](./skills/using-tea-stack/SKILL.md) | 轻量工作流路由与 5 条不可违反的生产红线 |
| [`skills/write-plan/SKILL.md`](./skills/write-plan/SKILL.md) | 跨模块或契约改动前的一页纸可执行实现计划 |
| [`skills/debug/SKILL.md`](./skills/debug/SKILL.md) | 科学方法排障：复现 → 假说 → 控制变量取证 → 最小根因修复 |
| [`skills/review-code/SKILL.md`](./skills/review-code/SKILL.md) | 独立视角、证据驱动的 `P0`/`P1`/`P2` 代码审查 |
| [`skills/feature-ready/SKILL.md`](./skills/feature-ready/SKILL.md) | 提 PR / 交测前的交付体检与 PR 摘要草稿 |
| [`agents/code-reviewer.md`](./agents/code-reviewer.md) | 只读独立代码审查 sub-agent 定义 |
| [`rules/AGENTS.md`](./rules/AGENTS.md) | 精简全局规则基线（~4 KB；Antigravity 插件自动加载，其余工具可按需合入） |
| [`templates/PROJECT-AGENTS.md`](./templates/PROJECT-AGENTS.md) | 放到业务仓库根目录的 150 行内 `AGENTS.md` / `CLAUDE.md` 模板 |
| [`examples/`](./examples/) | 填好的项目 `AGENTS.md` 样例 + 证据驱动 Review 输出样例 |
| [`docs/TEAM-PLAYBOOK.zh-CN.md`](./docs/TEAM-PLAYBOOK.zh-CN.md) | 团队落地指南、常见翻车模式与两周试点方案（[English](./docs/TEAM-PLAYBOOK.md)） |

### 内置五端插件清单与组件支持矩阵

| 宿主 | 清单 | 5 个 Skills | `code-reviewer` Agent | `rules/AGENTS.md` | 启动路由 |
|---|---|---|---|---|---|
| **Claude Code** | [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json) + [marketplace](./.claude-plugin/marketplace.json) | 自动加载 | 自动加载（`agents/`） | 按需手动合入 | Skill description |
| **Antigravity (`agy`)** | [`.antigravity-plugin/plugin.json`](./.antigravity-plugin/plugin.json) | 自动加载 | 自动加载（`agents/`） | 自动加载（`rules/`） | Skill description + 规则 |
| **Codex** | [`.codex-plugin/plugin.json`](./.codex-plugin/plugin.json) + [marketplace](./.agents/plugins/marketplace.json) | 自动加载 | 新会话 / 原生子代理跑 `review-code` | 按需手动合入 | Skill description |
| **Cursor** | [`.cursor-plugin/plugin.json`](./.cursor-plugin/plugin.json) + [marketplace](./.cursor-plugin/marketplace.json) | 自动加载 | 新会话 / 原生子代理跑 `review-code` | 按需手动合入 | Skill description |
| **Kimi Code** | [`.kimi-plugin/plugin.json`](./.kimi-plugin/plugin.json) | 自动加载 | 自动加载（`agents/`） | 按需手动合入 | 自动加载（`sessionStart.skill`） |

## 在具体项目中落地

1. 按上面对应工具的命令安装 `tea-stack` 插件。
2. 将 [`templates/PROJECT-AGENTS.md`](./templates/PROJECT-AGENTS.md) 复制到你的业务仓库根目录，改名为 `AGENTS.md`（或 `CLAUDE.md`），花 10 分钟填好构建/测试/Lint 命令（参考 [`examples/project-agents-example.md`](./examples/project-agents-example.md)）。
3. 按需把 [`rules/AGENTS.md`](./rules/AGENTS.md) 中认同的条款合入你的全局规则文件。

## License

[MIT](./LICENSE)
