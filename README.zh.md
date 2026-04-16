# NovadaLabs AI 配置系统

🌍 **语言：** [English](README.md) · [中文](README.zh.md) · [Português](README.pt-BR.md)

---

> NovadaLabs 团队共享 AI 代理配置系统。Fork 本仓库，叠加你的个人层，几分钟内完成配置——支持 Claude Code、Codex 或其他 AI 运行时。

---

## 目录

- [这是什么](#这是什么)
- [架构：三层模型](#架构三层模型)
- [前置要求](#前置要求)
- [快速开始 — Fork 与安装](#快速开始--fork-与安装)
- [目录结构](#目录结构)
- [技能目录](#技能目录)
- [代理定义](#代理定义)
- [规则与原则](#规则与原则)
- [AgentRecall 配置](#agentrecall-配置)
- [多代理指南](#多代理指南)
- [个人定制](#个人定制)
- [平台说明](#平台说明)
- [贡献指南](#贡献指南)

---

## 这是什么

本仓库是 NovadaLabs AI 代理的**团队共享配置层**，包含：

- **95 个技能** — 针对特定任务的可复用指令集（研究、编码、部署等）
- **代理定义** — 代码审查、规划、TDD、安全等专用子代理
- **规则** — 开发流程、Git、性能、安全等团队规范
- **Hooks** — 在会话启动/停止及工具调用时自动运行的脚本
- **AgentRecall** — 跨会话持久记忆系统，让代理记住上下文

**不包含什么：** 本仓库不存放个人记忆、凭证、日记或项目特定上下文。这些属于你的个人层（见下文说明）。

---

## 架构：三层模型

```
┌─────────────────────────────────────────┐
│  第三层：项目上下文                      │  ← 项目根目录的 CLAUDE.md、笔记
├─────────────────────────────────────────┤
│  第二层：个人层                          │  ← 你的 CLAUDE.md、memory/、journal/
├─────────────────────────────────────────┤
│  第一层：团队共享（本仓库）               │  ← skills/、agents/、rules/、hooks/
└─────────────────────────────────────────┘
```

- **第一层**（本仓库）团队共享。从上游团队仓库 pull 获取更新。
- **第二层**属于你个人。你的使命、项目、记忆。永远不要提交到团队仓库。
- **第三层**属于单个项目。项目根目录的 `CLAUDE.md` 文件为代理提供项目特定上下文。

---

## 前置要求

| 依赖项 | 版本 | 说明 |
|---|---|---|
| Node.js | 20+ | AgentRecall 和 hooks 所需 |
| Git | 任意版本 | 配置同步所需 |
| Claude Code | 最新版 | 主要支持的代理运行时 |
| macOS | 14+ | 部分工具（bb-browser、opencli）仅支持 Mac |

其他代理运行时（Codex、Copilot CLI）也受支持，有少量差异——参见[多代理指南](#多代理指南)。

---

## 快速开始 — Fork 与安装

### 第一步 — Fork 仓库

访问 `https://github.com/NovadaLabs/claude`，点击右上角 **Fork**。

> **为什么要 Fork？** Fork 给你一个独立副本。你可以把个人层（CLAUDE.md、memory/）提交到自己的 Fork，而不会影响团队仓库。当团队仓库更新时，你可以将更新拉取到自己的 Fork。

### 第二步 — Clone 你的 Fork

```bash
# 将 YOUR_USERNAME 替换为你的 GitHub 用户名
git clone https://github.com/YOUR_USERNAME/claude.git ~/.claude-team
```

### 第三步 — 安装到代理配置目录

**Claude Code：**
```bash
# 先备份现有配置
cp -r ~/.claude ~/.claude-backup-$(date +%Y%m%d)

# 复制团队技能、代理、规则、hooks
cp -r ~/.claude-team/skills ~/.claude/
cp -r ~/.claude-team/agents ~/.claude/
cp -r ~/.claude-team/rules ~/.claude/
cp -r ~/.claude-team/hooks ~/.claude/
```

**Codex / OpenAI：** 参见[多代理指南](#多代理指南)。

### 第四步 — 设置上游 remote（接收团队更新）

```bash
cd ~/.claude-team
git remote add upstream https://github.com/NovadaLabs/claude.git
```

拉取后续团队更新：
```bash
git fetch upstream
git merge upstream/main
```

### 第五步 — 创建个人 CLAUDE.md

```bash
cp ~/.claude-team/CLAUDE.template.md ~/.claude/CLAUDE.md
```

然后编辑 `~/.claude/CLAUDE.md`，填入：
- 当前使命和项目
- 关键仓库和路径
- 个人偏好

### 第六步 — 安装 AgentRecall

```bash
npm install -g @agent-recall/cli
```

然后将 AgentRecall hooks 添加到 `~/.claude/settings.json`——参见 [AgentRecall 配置](#agentrecall-配置)。

---

## 目录结构

```
~/.claude/
├── CLAUDE.md                  ← 你的个人指令（不提交到团队仓库）
├── skills/                    ← 95 个可复用技能（团队共享）
│   ├── agent-recall/          ← 记忆系统集成
│   ├── website-genome/        ← 网站复制系统
│   ├── deep-research/         ← 多源研究
│   └── ...                    ← （见技能目录）
├── agents/                    ← 专用子代理定义
│   ├── code-reviewer.md
│   ├── planner.md
│   └── ...
├── rules/                     ← 团队原则和工作流规则
│   ├── development-workflow.md
│   ├── git-workflow.md
│   ├── agent-orchestration.md
│   └── ...
├── hooks/                     ← 自动化脚本
│   ├── session-start-sync.sh
│   └── session-stop-sync.sh
├── memory/                    ← 个人专属——不在团队仓库中
│   ├── MEMORY.md              ← 所有记忆的索引
│   └── journal/               ← 会话日记
└── settings.json              ← Claude Code 配置（团队仓库提供模板版本）
```

---

## 技能目录

技能是针对特定任务的可复用指令集。在 Claude Code 中通过 `Skill` 工具调用。

### 代理与编排
| 技能 | 用途 |
|---|---|
| `agent-recall` | 跨会话持久记忆 |
| `agent-browser` | 使用用户 Chrome 的浏览器自动化 |
| `agentic-engineering` | 多代理系统设计模式 |
| `autonomous-loops` | 自运行代理循环 |
| `continuous-agent-loop` | 循环代理工作流 |
| `enterprise-agent-ops` | 生产级代理运维 |
| `team-builder` | 构建和配置代理团队 |

### 开发
| 技能 | 用途 |
|---|---|
| `tdd-workflow` | 测试驱动开发（红/绿/重构） |
| `code-to-prd` | 将代码转化为产品需求文档 |
| `api-design` | API 设计模式与评审 |
| `backend-patterns` | 服务端架构模式 |
| `frontend-patterns` | UI/UX 实现模式 |
| `database-migrations` | 安全的数据库迁移策略 |
| `coding-standards` | 团队代码风格规范 |
| `bun-runtime` | Bun.js 专项模式 |
| `nextjs-turbopack` | Next.js + Turbopack 配置 |

### 研究与发现
| 技能 | 用途 |
|---|---|
| `deep-research` | 多源结构化研究 |
| `market-research` | 竞争格局分析 |
| `competitive-teardown` | 竞争对手深度分析 |
| `exa-search` | 基于 Exa 的网络研究 |
| `iterative-retrieval` | 渐进式搜索精化 |
| `research-summarizer` | 将研究压缩为洞察 |
| `documentation-lookup` | 快速查找官方文档 |

### 网站与内容
| 技能 | 用途 |
|---|---|
| `website-genome` | 完整网站复制系统 |
| `awwwards-landing-page` | 获奖级落地页 |
| `landing-page-generator` | 快速落地页脚手架 |
| `content-engine` | 结构化内容生产 |
| `article-writing` | 长文生成 |
| `crosspost` | 多平台内容发布 |

### 基础设施与 DevOps
| 技能 | 用途 |
|---|---|
| `deployment-patterns` | CI/CD 和部署策略 |
| `docker-patterns` | Docker/容器最佳实践 |
| `postgres-patterns` | PostgreSQL 优化模式 |
| `mcp-server-patterns` | MCP 服务器设计与部署 |
| `eval-harness` | 评估框架搭建 |

### 安全
| 技能 | 用途 |
|---|---|
| `security-review` | 代码安全审计 |
| `security-scan` | 自动化漏洞扫描 |

### 产品与策略
| 技能 | 用途 |
|---|---|
| `product-discovery` | 用户研究与问题定义 |
| `product-strategist` | 战略性产品决策 |
| `product-manager-toolkit` | PM 工作流与交付物 |
| `investor-materials` | 融资材料与投资人文档 |
| `roadmap-communicator` | 路线图创建与沟通 |

### 测试与质量
| 技能 | 用途 |
|---|---|
| `e2e-testing` | 端到端测试搭建与执行 |
| `webapp-testing` | Web 应用 QA 模式 |
| `ai-regression-testing` | AI 输出回归测试 |
| `verification-loop` | 多步骤验证模式 |
| `python-testing` | Python 测试模式 |

### 自动化与工具
| 技能 | 用途 |
|---|---|
| `playwright-pro` | 高级 Playwright 自动化 |
| `playwright-cli` | Playwright CLI 使用 |
| `opencli` | 社交/网页操作 CLI 工具 |
| `tmux` | 终端多路复用工作流 |
| `x-api` | X（Twitter）API 集成 |

> **完整列表：** 在 Claude Code 中运行 `/find-skills` 搜索和发现所有技能。

---

## 代理定义

`agents/` 中的专用子代理。Claude Code 自动加载。

| 代理 | 用途 | 使用时机 |
|---|---|---|
| `planner` | 实现规划 | 开始复杂功能前 |
| `architect` | 系统设计 | 架构决策时 |
| `code-reviewer` | 代码审查 | 编写任何代码后 |
| `tdd-guide` | 测试驱动开发 | 新功能、Bug 修复 |
| `security-reviewer` | 安全审计 | 提交前、认证变更后 |
| `build-error-resolver` | 修复构建失败 | 构建失败时 |
| `e2e-runner` | E2E 测试执行 | 关键用户流程 |
| `refactor-cleaner` | 删除死代码 | 代码维护 |
| `doc-updater` | 文档更新 | 功能完成后 |
| `website-builder` | 自主网站构建 | 复制和构建任务 |

---

## 规则与原则

`rules/` 中的规则是团队标准，每次会话自动加载。

| 文件 | 内容 |
|---|---|
| `development-workflow.md` | 研究 → 规划 → TDD → 评审 → 提交 |
| `git-workflow.md` | 提交格式、PR 流程 |
| `agent-orchestration.md` | 多代理设计模式、五大支柱 |
| `core-operations.md` | 浏览器优先级、GitHub 同步 |
| `performance.md` | 模型选择、上下文窗口管理 |
| `security.md` | 安全优先编码实践 |
| `testing.md` | 测试覆盖率要求 |
| `coding-style.md` | 代码风格指南 |

---

## AgentRecall 配置

AgentRecall 为代理提供跨会话持久记忆——纠错历史、项目上下文、用户偏好。

**安装：**
```bash
npm install -g @agent-recall/cli
```

**将 hooks 添加到 `~/.claude/settings.json`：**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [{
          "type": "command",
          "command": "node $(which agentrecall) hook-start 2>/dev/null || true"
        }]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [{
          "type": "command",
          "command": "node $(which agentrecall) hook-correction 2>/dev/null || true"
        }]
      }
    ],
    "Stop": [
      {
        "hooks": [{
          "type": "command",
          "command": "node $(which agentrecall) hook-end 2>/dev/null || true"
        }]
      }
    ]
  }
}
```

**验证：**
```bash
agentrecall status
```

AgentRecall 将记忆存储在 `~/.claude/projects/<project>/memory/` — 这是个人数据，不应提交到团队仓库。

---

## 多代理指南

### 哪个文件配置代理？

| 代理运行时 | 配置文件 | 技能位置 |
|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/skills/` |
| OpenAI Codex | `AGENTS.md`（项目根目录） | `~/.codex/skills/` |
| GitHub Copilot CLI | `AGENTS.md` | 无技能系统 |
| Gemini CLI | `GEMINI.md` | 通过 `activate_skill` 使用技能 |

### 工具名称对照表

技能文件引用 Claude Code 工具名称。如使用其他运行时，请按下表对应转换：

| Claude Code | Codex | Copilot CLI | Gemini CLI |
|---|---|---|---|
| `Skill` 工具 | `skill` 工具 | 不支持 | `activate_skill` |
| `Agent` 工具 | 子代理派发 | 不支持 | 不支持 |
| `Read` 工具 | `read_file` | `read_file` | `read_file` |
| `Bash` 工具 | `shell` | `shell` | `shell` |

### 如何选择

**使用 Claude Code：** 按快速开始步骤操作，95 个技能开箱即用。

**使用 Codex：** 将技能复制到 `~/.codex/skills/`，编辑每个技能文件，按对照表替换工具名称。用 `AGENTS.md` 替换 `CLAUDE.md`。

**两者都用：** 在 `~/.claude/` 和 `~/.codex/` 分别保留各自技能副本。

---

## 个人定制

**这些文件属于你——不要推送到团队仓库：**

| 文件/目录 | 内容 |
|---|---|
| `~/.claude/CLAUDE.md` | 你的使命、项目、个人规则、关键路径 |
| `~/.claude/memory/` | AgentRecall 记忆（自动管理） |
| `~/.claude/settings.local.json` | 个人 API Key、本地覆盖配置 |

**模板：** 复制 `CLAUDE.template.md` 并填写：
- `## Current Mission` — 当前在做什么
- `## Key Repos` — 你的 GitHub 仓库和本地路径
- `## Communication Style` — 语言偏好、响应格式

**将个人技能贡献给团队：** 如果你开发了整个团队都能受益的技能，提交 PR 到团队仓库。参见[贡献指南](#贡献指南)。

---

## 平台说明

**仅支持 Mac 的工具：**
- `bb-browser` — 通过 AppleScript 连接用户 Chrome，仅限 Mac
- `opencli` — 使用 macOS Chrome 配置文件，仅限 Mac

**需要 Node.js：**
- AgentRecall hooks 需要 Node.js 20+
- 会话同步 hooks 需要 Node.js

**Windows/Linux 用户：**
- 技能完全可用（Markdown 指令文件）
- 代理定义完全可用
- 用 `playwright-pro` 替代 `bb-browser` 做浏览器自动化
- 用直接 API 调用替代 `opencli`

---

## 贡献指南

1. Fork 团队仓库（`NovadaLabs/claude`）
2. 创建分支：`git checkout -b skill/my-new-skill`
3. 将你的技能添加到 `skills/my-new-skill/`，包含 `skill.md` 文件
4. 测试：在 Claude Code 会话中调用，验证效果
5. 提交 PR，说明：技能用途、使用时机、调用示例

**技能文件格式：**
```markdown
---
name: my-skill-name
description: 一行说明，用于技能发现
---

# 我的技能

## 适用场景
...

## 步骤
...
```

---

*由 NovadaLabs 维护，基于 [Superpowers](https://github.com/superpowers) harness 构建。*
