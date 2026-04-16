# NovadaLabs AI Configuration

<div align="center">

🌍 **Jump to your language / 跳转语言 / Ir para idioma:**

[🇺🇸 English](#en) · [🇨🇳 中文](#cn) · [🇧🇷 Português](#pt)

</div>

---

<!-- ============================================================ -->
<!--                     ENGLISH SECTION                         -->
<!-- ============================================================ -->

<a id="en"></a>

# 🇺🇸 English

> **What is this?** A ready-to-use AI agent configuration kit for NovadaLabs team members. It gives your AI assistant (Claude, Codex, or others) a shared brain — the same skills, rules, and memory system the whole team uses.

**Table of Contents**
- [Before You Start — What You Need](#en-prereqs)
- [Step 0 — What Is a Fork and Why Do I Need One?](#en-fork-explained)
- [Step 1 — Fork This Repo](#en-fork)
- [Step 2 — Clone Your Fork to Your Computer](#en-clone)
- [Step 3 — Install Claude Code](#en-install-claude)
- [Step 4 — Copy the Team Config Into Claude](#en-copy)
- [Step 5 — Create Your Personal Config File](#en-personal)
- [Step 6 — Install AgentRecall (Memory System)](#en-agentrecall)
- [Step 7 — Receive Future Team Updates](#en-updates)
- [What's Included](#en-whats-included)
- [Which AI Agent Do You Use?](#en-multiagent)
- [🤖 Using Codex? Setup Guide](#en-codex)
- [FAQ](#en-faq)

---

<a id="en-prereqs"></a>
## Before You Start — What You Need

Install these before anything else:

| What | Why | How to get it |
|---|---|---|
| **GitHub account** | To fork and store your config | Sign up free at [github.com](https://github.com) |
| **Git** | To download repos to your computer | [git-scm.com/downloads](https://git-scm.com/downloads) |
| **Node.js 20+** | To run the memory system | [nodejs.org](https://nodejs.org) — download LTS version |
| **Claude Code** | The AI agent this config is built for | See Step 3 below |

**How to open a Terminal (command line):**
- **Mac:** Press `Cmd + Space` → type `Terminal` → press Enter
- **Windows:** Press `Win + R` → type `cmd` → press Enter

**Check if Git is installed** — open Terminal and type:
```
git --version
```
You should see something like `git version 2.x.x`. If you get "command not found", go install Git first.

**Check Node.js:**
```
node --version
```
You need `v20.x.x` or higher. If you see `v18` or older, upgrade at [nodejs.org](https://nodejs.org).

---

<a id="en-fork-explained"></a>
## Step 0 — What Is a Fork and Why Do I Need One?

**Never used GitHub before? Read this first.**

This repo (`NovadaLabs/claude`) is a **shared team template**. Everyone starts from the same template, but each person needs their own personal copy — because you'll add your own projects, notes, and preferences that no one else should see.

A **Fork** creates your own copy of this repo on GitHub. It stays linked to the team version, so you can pull in team updates whenever new skills are added.

```
NovadaLabs/claude       ← Team template (you can read, not edit)
        ↓  click Fork
YOUR_NAME/claude        ← Your personal copy (you own this)
        ↓  git clone
~/.claude-team/         ← Downloaded to your computer
        ↓  cp commands
~/.claude/              ← Claude reads config from here
```

Your personal files (projects, notes) stay in YOUR copy. Team improvements flow down from the team template.

---

<a id="en-fork"></a>
## Step 1 — Fork This Repo

1. Log into [github.com](https://github.com) (create a free account if you don't have one)
2. Go to: **https://github.com/NovadaLabs/claude**
3. Click the **Fork** button — it's in the top-right corner of the page
4. On the next screen, click **Create fork** (leave all options as default)
5. Wait a few seconds — you'll land on your copy at `https://github.com/YOUR_USERNAME/claude`

> ✅ **You're done when:** the URL shows YOUR username instead of `NovadaLabs`

---

<a id="en-clone"></a>
## Step 2 — Clone Your Fork to Your Computer

"Clone" means downloading the repo from GitHub to your local computer.

1. Open Terminal
2. Type the following — **replace `YOUR_USERNAME` with your actual GitHub username:**
```
git clone https://github.com/YOUR_USERNAME/claude.git ~/.claude-team
```
Press Enter. You'll see progress messages as files download.

3. Verify it worked:
```
ls ~/.claude-team
```
You should see: `README.md  agents  hooks  rules  settings.template.json  skills`

> ✅ **You're done when:** `ls ~/.claude-team` shows those files

**If you see "git: command not found":** Install Git from [git-scm.com/downloads](https://git-scm.com/downloads), then restart your Terminal and try again.

---

<a id="en-install-claude"></a>
## Step 3 — Install Claude Code

Claude Code is the AI agent this configuration was designed for. It runs in your Terminal.

**Install it:**
```
npm install -g @anthropic-ai/claude-code
```

**If you see "npm: command not found":** You need to install Node.js first from [nodejs.org](https://nodejs.org). After installing, restart Terminal and try again.

**Verify:**
```
claude --version
```

**Log in** (you need an Anthropic account — create one free at [claude.ai](https://claude.ai)):
```
claude
```
Follow the on-screen instructions to authenticate. Once done, type `/exit` to quit for now.

> ✅ **You're done when:** `claude --version` prints a version number like `1.x.x`

---

<a id="en-copy"></a>
## Step 4 — Copy the Team Config Into Claude

Claude Code looks for its configuration in `~/.claude` on your computer. (The `~` means your home folder — on Mac it's `/Users/yourname`, on Windows it's `C:\Users\yourname`.)

We need to copy the team's skills, agents, and rules into that folder.

**First, back up your existing Claude config** (skip if you just installed Claude Code for the first time):
```
cp -r ~/.claude ~/.claude-backup-$(date +%Y%m%d)
```

**Copy the team files:**
```
cp -r ~/.claude-team/skills ~/.claude/
cp -r ~/.claude-team/agents ~/.claude/
cp -r ~/.claude-team/rules ~/.claude/
cp -r ~/.claude-team/hooks ~/.claude/
```

**Copy the settings template** (only if you don't have a settings.json yet):
```
cp ~/.claude-team/settings.template.json ~/.claude/settings.json
```

> ✅ **You're done when:** `ls ~/.claude/skills` shows a list of folder names

**What did we just copy?**
- `skills/` — 95 instruction sets for specific tasks (research, coding, deployment...)
- `agents/` — 25 specialized sub-assistants Claude can call on
- `rules/` — 8 always-on team standards for development workflow
- `hooks/` — scripts that auto-run when Claude sessions start and stop

---

<a id="en-personal"></a>
## Step 5 — Create Your Personal Config File

This is the most important step. Claude reads a file called `CLAUDE.md` to understand who you are, what you're working on, and how you like to work. Without this, Claude treats every session as if it's meeting you for the first time.

**Copy the template:**
```
cp ~/.claude-team/CLAUDE.template.md ~/.claude/CLAUDE.md
```

**Open it to edit:**
- **Mac:** `open ~/.claude/CLAUDE.md` (opens in TextEdit or your default editor)
- **VS Code users:** `code ~/.claude/CLAUDE.md`
- **Windows:** `notepad %USERPROFILE%\.claude\CLAUDE.md`

**Fill in at minimum:**
- **Current Mission** — What project are you working on right now? (1-3 sentences)
- **Key Repos** — List your GitHub repos and where they live on your computer
- **Communication Style** — Do you want responses in English or Chinese? Short or detailed?

**Example of what a filled-in section looks like:**
```
## Current Mission
Building a B2B SaaS analytics dashboard for e-commerce clients.
Key repo: ~/Projects/analytics-dashboard

## Key Repos
- `myname/analytics-dashboard` — main product, lives at ~/Projects/analytics-dashboard
- `myname/shared-components` — design system, lives at ~/Projects/shared-components

## Communication Style
- Language: English
- Responses: concise, no filler
```

> ⚠️ **Important:** This file is personal. Never push it to the team repo. The `.gitignore` already protects you, but be aware.

> ✅ **You're done when:** `~/.claude/CLAUDE.md` exists and has your real info in it

---

<a id="en-agentrecall"></a>
## Step 6 — Install AgentRecall (Memory System)

Without memory, Claude forgets everything when you close the session. AgentRecall fixes this — it automatically saves corrections you make, project context, and your preferences, then loads them the next time you open Claude.

**Install:**
```
npm install -g @agent-recall/cli
```

**Check it works:**
```
agentrecall status
```

The `settings.template.json` you copied in Step 4 already has AgentRecall wired in. If you want to verify, open `~/.claude/settings.json` and look for the `hooks` section — it should contain `agentrecall hook-start`, `agentrecall hook-correction`, and `agentrecall hook-end`.

**Start Claude and test:**
```
claude
```
You should see a message at the top of the session saying memory was loaded.

> ✅ **You're done when:** `agentrecall status` runs without error

---

<a id="en-updates"></a>
## Step 7 — Receive Future Team Updates

When the team adds new skills or improves existing ones, you can pull those updates in.

**One-time setup** (do this once, right now):
```
cd ~/.claude-team
git remote add upstream https://github.com/NovadaLabs/claude.git
```

**When you want to update** (run this whenever the team announces changes):
```
cd ~/.claude-team
git fetch upstream
git merge upstream/main
cp -r ~/.claude-team/skills ~/.claude/
cp -r ~/.claude-team/agents ~/.claude/
cp -r ~/.claude-team/rules ~/.claude/
```

---

<a id="en-whats-included"></a>
## What's Included

### Skills (95 total)
Skills are instruction sets that tell Claude how to do specific tasks. Invoke with `/skill-name` in Claude Code.

| Category | Key skills |
|---|---|
| Agent & Orchestration | `agent-recall`, `agent-browser`, `agentic-engineering`, `autonomous-loops`, `team-builder` |
| Development | `tdd-workflow`, `api-design`, `backend-patterns`, `frontend-patterns`, `database-migrations` |
| Research | `deep-research`, `market-research`, `competitive-teardown`, `exa-search` |
| Website & Content | `website-genome`, `awwwards-landing-page`, `content-engine`, `article-writing` |
| Infrastructure | `deployment-patterns`, `docker-patterns`, `postgres-patterns`, `mcp-server-patterns` |
| Security | `security-review`, `security-scan` |
| Product & Strategy | `product-discovery`, `product-strategist`, `investor-materials`, `roadmap-communicator` |
| Testing | `e2e-testing`, `webapp-testing`, `ai-regression-testing`, `verification-loop` |

### Agents (25 total)

| Agent | What it does | When Claude uses it |
|---|---|---|
| `planner` | Creates step-by-step plans before coding | You ask for a new feature |
| `architect` | Designs system architecture | Big technical decisions |
| `code-reviewer` | Reviews code for quality and bugs | After writing any code |
| `tdd-guide` | Guides test-driven development | New features, bug fixes |
| `security-reviewer` | Audits for security vulnerabilities | Before commits |
| `build-error-resolver` | Fixes build failures | When the build breaks |
| `website-builder` | Builds and replicates websites autonomously | Site build/copy tasks |

### Rules (8 files)
Always-on standards: development workflow, git commits, performance, security, testing.

---

<a id="en-multiagent"></a>
## Which AI Agent Do You Use?

| If you use... | Config file | How skills work |
|---|---|---|
| **Claude Code** | `~/.claude/CLAUDE.md` | All 95 skills work out of the box |
| **OpenAI Codex** | `AGENTS.md` in your project root | Copy skills to `~/.codex/skills/`, replace Claude tool names |
| **Gemini CLI** | `GEMINI.md` | Use `activate_skill` instead of `Skill` tool |
| **GitHub Copilot** | `AGENTS.md` | No native skill system — rules only |

---

<a id="en-codex"></a>
## 🤖 Using Codex? Setup Guide

> **If you use OpenAI Codex CLI instead of Claude Code, follow these steps.** Steps 1–2 (Fork + Clone) are identical. Everything from Step 3 onward is different.

### What's different about Codex

| | Claude Code | OpenAI Codex CLI |
|---|---|---|
| Config file | `~/.claude/CLAUDE.md` | `AGENTS.md` (in project root or `~/.codex/`) |
| Skills system | Native — 95 skills load automatically | No native loader — rules must be embedded |
| Memory | AgentRecall via hooks | Built-in conversation history |
| Install | `npm i -g @anthropic-ai/claude-code` | `npm i -g @openai/codex` |

### Step 3 (Codex) — Install Codex CLI

```
npm install -g @openai/codex
```

Set your OpenAI API key:
```
export OPENAI_API_KEY=your-key-here
```
To make this permanent, add that line to `~/.zshrc` (Mac) or `~/.bashrc` (Linux/Windows WSL).

Verify:
```
codex --version
```

### Step 4 (Codex) — Copy Rules Into Your Project

Codex reads `AGENTS.md` from your project root. Copy the team rules there:

```
# Go to your project folder first
cd ~/Projects/your-project

# Create AGENTS.md from the template
cp ~/.claude-team/CLAUDE.template.md ./AGENTS.md
```

Then copy the content of the rules you want into your `AGENTS.md`. The most useful ones are:
```
cat ~/.claude-team/rules/development-workflow.md >> ./AGENTS.md
cat ~/.claude-team/rules/git-workflow.md >> ./AGENTS.md
cat ~/.claude-team/rules/coding-style.md >> ./AGENTS.md
```

### Step 5 (Codex) — Using Skills with Codex

Codex has no automatic skill loader. To use a skill, copy its content into your prompt or into `AGENTS.md`.

**To use a skill once:**
```
# Read the skill and paste its contents into your Codex prompt
cat ~/.claude-team/skills/deep-research/skill.md
```

**To make a skill always-on**, append it to your `AGENTS.md`:
```
cat ~/.claude-team/skills/tdd-workflow/skill.md >> ./AGENTS.md
```

**Most useful skills for Codex users:**
- `tdd-workflow` — test-driven development discipline
- `api-design` — API design patterns
- `security-review` — security checklist
- `coding-standards` — code quality rules

### Step 6 (Codex) — Global Config (Optional)

To apply rules to ALL your projects (not just one), create a global config:
```
mkdir -p ~/.codex
cp ~/.claude-team/CLAUDE.template.md ~/.codex/AGENTS.md
```
Edit `~/.codex/AGENTS.md` the same way as in Step 5 of the Claude setup.

### Codex Tool Name Mapping

Skills reference Claude Code tool names. When a skill says to use a tool, translate:

| Skill says (Claude) | Use this instead (Codex) |
|---|---|
| `Read` tool | `read_file` |
| `Write` tool | `write_file` |
| `Edit` tool | `edit_file` or `patch_file` |
| `Bash` tool | `shell` |
| `Grep` tool | `search_files` |
| `Glob` tool | `list_files` |
| `Skill` tool | Not available — copy skill content manually |
| `Agent` tool | Not available — Codex is single-agent |

---

<a id="en-faq"></a>
## FAQ

**Q: I don't have a GitHub account.**
Go to [github.com](https://github.com) → Sign up → free account → done. Takes 2 minutes.

**Q: What is a terminal?**
A text interface to your computer. Mac: `Cmd + Space` → type Terminal → Enter. Windows: `Win + R` → `cmd` → Enter.

**Q: I got "permission denied" when copying files.**
Add `sudo` before the command: `sudo cp -r ~/.claude-team/skills ~/.claude/`

**Q: I already have Claude Code. Will this overwrite my settings?**
No — you only copy `skills/`, `agents/`, `rules/`, `hooks/`. Your existing `settings.json` and `CLAUDE.md` are untouched unless you explicitly copy them.

**Q: What's the difference between my fork and the team repo?**
Team repo = shared template, nobody pushes personal stuff there. Your fork = your personal copy. The `.gitignore` protects you from pushing personal files by accident.

**Q: How do I add my own skill to the team?**
Build it, test it, then open a Pull Request on `NovadaLabs/claude`. Ask a teammate to review.

[🔝 Back to language select](#en)

---
---

<!-- ============================================================ -->
<!--                      CHINESE SECTION                        -->
<!-- ============================================================ -->

<a id="cn"></a>

# 🇨🇳 中文

> **这是什么？** NovadaLabs 团队成员专用的 AI 代理配置套件。它让你的 AI 助手（Claude、Codex 等）拥有团队共享的技能库、规则体系和记忆系统。

**目录**
- [开始前 — 你需要什么](#cn-prereqs)
- [第 0 步 — 什么是 Fork，为什么需要它？](#cn-fork-explained)
- [第 1 步 — Fork 本仓库](#cn-fork)
- [第 2 步 — 将 Fork 克隆到你的电脑](#cn-clone)
- [第 3 步 — 安装 Claude Code](#cn-install-claude)
- [第 4 步 — 将团队配置复制到 Claude](#cn-copy)
- [第 5 步 — 创建你的个人配置文件](#cn-personal)
- [第 6 步 — 安装 AgentRecall（记忆系统）](#cn-agentrecall)
- [第 7 步 — 接收团队后续更新](#cn-updates)
- [包含哪些内容](#cn-whats-included)
- [你用哪个 AI 代理？](#cn-multiagent)
- [🤖 使用 Codex？配置指南](#cn-codex)
- [常见问题](#cn-faq)

---

<a id="cn-prereqs"></a>
## 开始前 — 你需要什么

在做任何操作之前，请先确认以下工具已安装：

| 工具 | 用途 | 获取方式 |
|---|---|---|
| **GitHub 账号** | Fork 和存储你的配置 | 在 [github.com](https://github.com) 免费注册 |
| **Git** | 把仓库下载到你的电脑 | [git-scm.com/downloads](https://git-scm.com/downloads) |
| **Node.js 20+** | 运行记忆系统 | [nodejs.org](https://nodejs.org) — 下载 LTS 版本 |
| **Claude Code** | 本套配置所针对的 AI 代理 | 见第 3 步 |

**如何打开终端（命令行）：**
- **Mac：** 按 `Cmd + 空格` → 输入「终端」→ 回车
- **Windows：** 按 `Win + R` → 输入 `cmd` → 回车

**检查 Git 是否已安装** — 打开终端，输入：
```
git --version
```
应该看到类似 `git version 2.x.x` 的输出。如果提示"命令未找到"，请先安装 Git。

**检查 Node.js：**
```
node --version
```
版本需要 `v20.x.x` 或以上。如果是 `v18` 或更早，请到 [nodejs.org](https://nodejs.org) 升级。

---

<a id="cn-fork-explained"></a>
## 第 0 步 — 什么是 Fork，为什么需要它？

**从未用过 GitHub？请先读这一节。**

把这个仓库（`NovadaLabs/claude`）想象成一个**共享模板**。团队里每个人都从同一个模板出发，但每个人都需要自己的个人副本——因为你会添加只属于你的项目、笔记和偏好。

**Fork** 会在 GitHub 上为你创建这个仓库的个人副本，同时保持与团队版本的连接，这样当团队新增技能时，你可以随时同步更新。

```
NovadaLabs/claude       ← 团队模板（你只能读）
        ↓  点击 Fork
你的用户名/claude       ← 你的个人副本（你完全控制）
        ↓  git clone
~/.claude-team/         ← 下载到你的电脑
        ↓  cp 命令
~/.claude/              ← Claude 从这里读取配置
```

你的个人内容（项目、笔记）存放在你的副本里。团队改进从团队模板流向你的副本。

---

<a id="cn-fork"></a>
## 第 1 步 — Fork 本仓库

1. 登录 [github.com](https://github.com)（如果还没有账号，免费注册一个）
2. 访问：**https://github.com/NovadaLabs/claude**
3. 点击页面**右上角**的 **Fork** 按钮
4. 在下一个页面点击 **Create fork**（所有选项保持默认）
5. 等几秒钟——你将进入自己的副本，地址为 `https://github.com/你的用户名/claude`

> ✅ **完成标志：** 页面左上角显示你的 GitHub 用户名，而不是 `NovadaLabs`

---

<a id="cn-clone"></a>
## 第 2 步 — 将 Fork 克隆到你的电脑

"克隆"的意思是把 GitHub 上的仓库下载到你的本地电脑。

1. 打开终端
2. 输入以下命令，**将 `YOUR_USERNAME` 替换为你的 GitHub 用户名：**
```
git clone https://github.com/YOUR_USERNAME/claude.git ~/.claude-team
```
按回车。你会看到文件下载的进度信息。

3. 验证是否成功：
```
ls ~/.claude-team
```
应该看到：`README.md  agents  hooks  rules  settings.template.json  skills`

> ✅ **完成标志：** `ls ~/.claude-team` 显示上面那些文件

**如果提示"git: 命令未找到"：** 请先从 [git-scm.com/downloads](https://git-scm.com/downloads) 安装 Git，重启终端后再试。

---

<a id="cn-install-claude"></a>
## 第 3 步 — 安装 Claude Code

Claude Code 是本套配置所针对的 AI 代理，在终端中运行。

**安装：**
```
npm install -g @anthropic-ai/claude-code
```

**如果提示"npm: 命令未找到"：** 需要先安装 Node.js，访问 [nodejs.org](https://nodejs.org)，重启终端后再试。

**验证：**
```
claude --version
```

**登录**（需要 Anthropic 账号——在 [claude.ai](https://claude.ai) 免费创建）：
```
claude
```
按屏幕提示完成认证。登录后输入 `/exit` 退出。

> ✅ **完成标志：** `claude --version` 打印出版本号，如 `1.x.x`

---

<a id="cn-copy"></a>
## 第 4 步 — 将团队配置复制到 Claude

Claude Code 在你电脑上名为 `~/.claude` 的文件夹中查找配置。（`~` 表示你的主目录——Mac 上是 `/Users/你的名字`，Windows 上是 `C:\Users\你的名字`。）

我们需要将团队的技能、代理和规则复制到该文件夹。

**首先备份现有 Claude 配置**（如果刚安装 Claude Code，可跳过）：
```
cp -r ~/.claude ~/.claude-backup-$(date +%Y%m%d)
```

**复制团队文件：**
```
cp -r ~/.claude-team/skills ~/.claude/
cp -r ~/.claude-team/agents ~/.claude/
cp -r ~/.claude-team/rules ~/.claude/
cp -r ~/.claude-team/hooks ~/.claude/
```

**复制设置模板**（仅在还没有 settings.json 时执行）：
```
cp ~/.claude-team/settings.template.json ~/.claude/settings.json
```

> ✅ **完成标志：** `ls ~/.claude/skills` 显示技能文件夹列表

**我们刚复制了什么？**
- `skills/` — 95 个特定任务的指令集（研究、编码、部署……）
- `agents/` — 25 个 Claude 可以调用的专用子助手
- `rules/` — 8 个始终生效的团队开发规范
- `hooks/` — 会话启动和停止时自动运行的脚本

---

<a id="cn-personal"></a>
## 第 5 步 — 创建你的个人配置文件

这是最重要的一步。Claude 会读取名为 `CLAUDE.md` 的文件，从中了解你是谁、你在做什么、你的工作方式。没有这个文件，Claude 每次会话都会把你当陌生人对待。

**复制模板：**
```
cp ~/.claude-team/CLAUDE.template.md ~/.claude/CLAUDE.md
```

**打开并编辑：**
- **Mac：** `open ~/.claude/CLAUDE.md`（在文本编辑器或默认编辑器中打开）
- **VS Code 用户：** `code ~/.claude/CLAUDE.md`
- **Windows：** `notepad %USERPROFILE%\.claude\CLAUDE.md`

**至少填写以下内容：**
- **Current Mission（当前使命）** — 你现在在做什么项目？（1-3 句话）
- **Key Repos（关键仓库）** — 你的 GitHub 仓库及本地路径
- **Communication Style（沟通风格）** — 中文还是英文？简洁还是详细？

**填写示例：**
```
## Current Mission
正在为电商客户构建 B2B SaaS 数据分析仪表板。
主仓库：~/Projects/analytics-dashboard

## Key Repos
- `myname/analytics-dashboard` — 主产品，本地路径：~/Projects/analytics-dashboard
- `myname/shared-components` — 设计系统，本地路径：~/Projects/shared-components

## Communication Style
- 语言：中文
- 回复：简洁，不废话
```

> ⚠️ **重要：** 这个文件是私人的。不要将它推送到团队仓库。`.gitignore` 已经阻止了这种情况，但要有意识。

> ✅ **完成标志：** `~/.claude/CLAUDE.md` 存在且包含你的真实信息

---

<a id="cn-agentrecall"></a>
## 第 6 步 — 安装 AgentRecall（记忆系统）

没有记忆时，Claude 关闭会话就会忘掉一切。AgentRecall 解决了这个问题——它自动保存你做过的纠正、项目上下文和偏好，下次打开 Claude 时自动加载。

**安装：**
```
npm install -g @agent-recall/cli
```

**验证：**
```
agentrecall status
```

你在第 4 步复制的 `settings.template.json` 已经内置了 AgentRecall 的连接配置。如果想确认，打开 `~/.claude/settings.json`，查看 `hooks` 部分——应该包含 `agentrecall hook-start`、`agentrecall hook-correction` 和 `agentrecall hook-end`。

**启动 Claude 测试：**
```
claude
```
会话顶部应该能看到记忆已加载的提示。

> ✅ **完成标志：** `agentrecall status` 运行无报错

---

<a id="cn-updates"></a>
## 第 7 步 — 接收团队后续更新

当团队新增技能或改进现有内容时，你可以将这些更新拉取到你的 Fork。

**一次性设置**（现在就做）：
```
cd ~/.claude-team
git remote add upstream https://github.com/NovadaLabs/claude.git
```

**需要更新时运行（随时可执行）：**
```
cd ~/.claude-team
git fetch upstream
git merge upstream/main
cp -r ~/.claude-team/skills ~/.claude/
cp -r ~/.claude-team/agents ~/.claude/
cp -r ~/.claude-team/rules ~/.claude/
```

---

<a id="cn-whats-included"></a>
## 包含哪些内容

### 技能（共 95 个）
技能是告诉 Claude 如何完成特定任务的指令集。在 Claude Code 中通过 `/技能名称` 调用。

| 分类 | 主要技能 |
|---|---|
| 代理与编排 | `agent-recall`、`agent-browser`、`agentic-engineering`、`autonomous-loops`、`team-builder` |
| 开发 | `tdd-workflow`、`api-design`、`backend-patterns`、`frontend-patterns`、`database-migrations` |
| 研究 | `deep-research`、`market-research`、`competitive-teardown`、`exa-search` |
| 网站与内容 | `website-genome`、`awwwards-landing-page`、`content-engine`、`article-writing` |
| 基础设施 | `deployment-patterns`、`docker-patterns`、`postgres-patterns`、`mcp-server-patterns` |
| 安全 | `security-review`、`security-scan` |
| 产品与策略 | `product-discovery`、`product-strategist`、`investor-materials`、`roadmap-communicator` |
| 测试 | `e2e-testing`、`webapp-testing`、`ai-regression-testing`、`verification-loop` |

### 代理（共 25 个）

| 代理 | 功能 | Claude 何时使用它 |
|---|---|---|
| `planner` | 编写代码前制定分步计划 | 你要求新功能时 |
| `architect` | 设计系统架构 | 重大技术决策时 |
| `code-reviewer` | 审查代码质量和 Bug | 编写任何代码后 |
| `tdd-guide` | 指导测试驱动开发 | 新功能、Bug 修复 |
| `security-reviewer` | 审计安全漏洞 | 提交前 |
| `build-error-resolver` | 修复构建失败 | 构建出错时 |
| `website-builder` | 自主构建和复制网站 | 网站构建/复制任务 |

### 规则（8 个文件）
始终生效的标准：开发流程、Git 提交、性能、安全、测试。

---

<a id="cn-multiagent"></a>
## 你用哪个 AI 代理？

| 如果你使用… | 配置文件 | 技能如何工作 |
|---|---|---|
| **Claude Code** | `~/.claude/CLAUDE.md` | 95 个技能开箱即用 |
| **OpenAI Codex** | 项目根目录的 `AGENTS.md` | 将技能复制到 `~/.codex/skills/`，替换工具名称 |
| **Gemini CLI** | `GEMINI.md` | 用 `activate_skill` 替代 `Skill` 工具 |
| **GitHub Copilot** | `AGENTS.md` | 无原生技能系统——仅使用规则 |

---

<a id="cn-codex"></a>
## 🤖 使用 Codex？配置指南

> **如果你使用 OpenAI Codex CLI 而不是 Claude Code，请按以下步骤操作。** 第 1-2 步（Fork + 克隆）完全相同，第 3 步起有所不同。

### Codex 与 Claude Code 的区别

| | Claude Code | OpenAI Codex CLI |
|---|---|---|
| 配置文件 | `~/.claude/CLAUDE.md` | `AGENTS.md`（项目根目录或 `~/.codex/`） |
| 技能系统 | 原生支持——95 个技能自动加载 | 无原生加载器——规则需手动嵌入 |
| 记忆 | AgentRecall（通过 hooks） | 内置对话历史 |
| 安装 | `npm i -g @anthropic-ai/claude-code` | `npm i -g @openai/codex` |

### 第 3 步（Codex）— 安装 Codex CLI

```
npm install -g @openai/codex
```

设置你的 OpenAI API Key：
```
export OPENAI_API_KEY=你的key
```
要使其永久生效，将这行添加到 `~/.zshrc`（Mac）或 `~/.bashrc`（Linux/Windows WSL）。

验证：
```
codex --version
```

### 第 4 步（Codex）— 将规则复制到项目中

Codex 从项目根目录读取 `AGENTS.md`。将团队规则复制到该文件：

```
# 先进入你的项目目录
cd ~/Projects/你的项目

# 从模板创建 AGENTS.md
cp ~/.claude-team/CLAUDE.template.md ./AGENTS.md
```

然后将你需要的规则内容追加到 `AGENTS.md`。最常用的：
```
cat ~/.claude-team/rules/development-workflow.md >> ./AGENTS.md
cat ~/.claude-team/rules/git-workflow.md >> ./AGENTS.md
cat ~/.claude-team/rules/coding-style.md >> ./AGENTS.md
```

### 第 5 步（Codex）— 在 Codex 中使用技能

Codex 没有自动技能加载器。要使用某个技能，需要将其内容复制到 prompt 中或 `AGENTS.md` 里。

**临时使用技能：**
```
# 读取技能内容，粘贴到 Codex prompt 中
cat ~/.claude-team/skills/deep-research/skill.md
```

**让技能永久生效**，追加到 `AGENTS.md`：
```
cat ~/.claude-team/skills/tdd-workflow/skill.md >> ./AGENTS.md
```

**Codex 用户最常用的技能：**
- `tdd-workflow` — 测试驱动开发纪律
- `api-design` — API 设计模式
- `security-review` — 安全检查清单
- `coding-standards` — 代码质量规范

### 第 6 步（Codex）— 全局配置（可选）

要将规则应用到**所有项目**（而不仅是单个项目），创建全局配置：
```
mkdir -p ~/.codex
cp ~/.claude-team/CLAUDE.template.md ~/.codex/AGENTS.md
```
编辑 `~/.codex/AGENTS.md`，方式与 Claude 配置的第 5 步相同。

### Codex 工具名称对照表

技能文件中引用 Claude Code 的工具名称。当技能说使用某个工具时，按下表转换：

| 技能中写的（Claude） | Codex 中对应使用 |
|---|---|
| `Read` 工具 | `read_file` |
| `Write` 工具 | `write_file` |
| `Edit` 工具 | `edit_file` 或 `patch_file` |
| `Bash` 工具 | `shell` |
| `Grep` 工具 | `search_files` |
| `Glob` 工具 | `list_files` |
| `Skill` 工具 | 不可用——手动复制技能内容 |
| `Agent` 工具 | 不可用——Codex 是单代理模式 |

---

<a id="cn-faq"></a>
## 常见问题

**问：我没有 GitHub 账号。**
访问 [github.com](https://github.com) → Sign up → 免费账号 → 完成。大概 2 分钟。

**问：什么是终端？**
与电脑交互的文字界面。Mac：`Cmd + 空格` → 输入"终端" → 回车。Windows：`Win + R` → `cmd` → 回车。

**问：复制文件时提示"permission denied"（权限拒绝）。**
在命令前加 `sudo`：`sudo cp -r ~/.claude-team/skills ~/.claude/`

**问：我已经有 Claude Code 了，这会覆盖我的设置吗？**
不会——你只是复制 `skills/`、`agents/`、`rules/` 和 `hooks/`。除非你明确操作，否则现有 `settings.json` 和 `CLAUDE.md` 不会被覆盖。

**问：我和团队仓库的 Fork 有什么区别？**
团队仓库 = 共享模板，不在这里推送个人内容。你的 Fork = 你的个人副本。`.gitignore` 保护你不会意外推送个人文件。

**问：如何将我开发的技能贡献给团队？**
开发并测试后，在 `NovadaLabs/claude` 上创建 Pull Request，请队友审查。

[🔝 回到顶部 / 语言选择](#cn)

---
---

<!-- ============================================================ -->
<!--                   PORTUGUESE SECTION                        -->
<!-- ============================================================ -->

<a id="pt"></a>

# 🇧🇷 Português Brasileiro

> **O que é isso?** Um kit de configuração de agente de IA pronto para uso pelos membros da equipe NovadaLabs. Dá ao seu assistente de IA (Claude, Codex ou outros) um cérebro compartilhado — as mesmas skills, regras e sistema de memória que toda a equipe usa.

**Índice**
- [Antes de Começar — O Que Você Precisa](#pt-prereqs)
- [Passo 0 — O Que É um Fork e Por Que Preciso?](#pt-fork-explained)
- [Passo 1 — Faça um Fork deste Repositório](#pt-fork)
- [Passo 2 — Clone seu Fork para o seu Computador](#pt-clone)
- [Passo 3 — Instale o Claude Code](#pt-install-claude)
- [Passo 4 — Copie a Config da Equipe para o Claude](#pt-copy)
- [Passo 5 — Crie seu Arquivo de Config Pessoal](#pt-personal)
- [Passo 6 — Instale o AgentRecall (Sistema de Memória)](#pt-agentrecall)
- [Passo 7 — Receba Atualizações Futuras da Equipe](#pt-updates)
- [O Que Está Incluído](#pt-whats-included)
- [Qual Agente de IA Você Usa?](#pt-multiagent)
- [🤖 Usando Codex? Guia de Configuração](#pt-codex)
- [Perguntas Frequentes](#pt-faq)

---

<a id="pt-prereqs"></a>
## Antes de Começar — O Que Você Precisa

Instale estas ferramentas antes de qualquer coisa:

| O Quê | Por Quê | Como obter |
|---|---|---|
| **Conta no GitHub** | Para fazer fork e guardar sua config | Crie grátis em [github.com](https://github.com) |
| **Git** | Para baixar repos para o seu computador | [git-scm.com/downloads](https://git-scm.com/downloads) |
| **Node.js 20+** | Para rodar o sistema de memória | [nodejs.org](https://nodejs.org) — baixe a versão LTS |
| **Claude Code** | O agente de IA para o qual esta config foi feita | Veja o Passo 3 abaixo |

**Como abrir o Terminal (linha de comando):**
- **Mac:** Pressione `Cmd + Espaço` → digite `Terminal` → pressione Enter
- **Windows:** Pressione `Win + R` → digite `cmd` → pressione Enter

**Verifique se o Git está instalado** — abra o Terminal e digite:
```
git --version
```
Deve aparecer algo como `git version 2.x.x`. Se der erro "comando não encontrado", instale o Git primeiro.

**Verifique o Node.js:**
```
node --version
```
Precisa ser `v20.x.x` ou superior. Se for `v18` ou mais antigo, atualize em [nodejs.org](https://nodejs.org).

---

<a id="pt-fork-explained"></a>
## Passo 0 — O Que É um Fork e Por Que Preciso?

**Nunca usou GitHub? Leia esta seção primeiro.**

Pense neste repositório (`NovadaLabs/claude`) como um **modelo compartilhado**. Todo mundo da equipe começa do mesmo modelo, mas cada pessoa precisa de uma cópia pessoal — porque você vai adicionar seus próprios projetos, notas e preferências que ninguém mais deve ver.

Um **Fork** cria sua cópia pessoal deste repositório no GitHub, mantendo conexão com a versão da equipe para que você possa receber atualizações quando novas skills forem adicionadas.

```
NovadaLabs/claude       ← Modelo da equipe (só leitura pra você)
        ↓  clique em Fork
SEU_USUARIO/claude      ← Sua cópia pessoal (você controla)
        ↓  git clone
~/.claude-team/         ← Baixado para o seu computador
        ↓  comandos cp
~/.claude/              ← Claude lê a config daqui
```

Seu conteúdo pessoal (projetos, notas) fica na SUA cópia. Melhorias da equipe vêm do modelo da equipe.

---

<a id="pt-fork"></a>
## Passo 1 — Faça um Fork deste Repositório

1. Faça login no [github.com](https://github.com) (crie uma conta gratuita se não tiver)
2. Acesse: **https://github.com/NovadaLabs/claude**
3. Clique no botão **Fork** — fica no **canto superior direito** da página
4. Na próxima tela, clique em **Create fork** (deixe todas as opções padrão)
5. Aguarde alguns segundos — você chegará na sua cópia em `https://github.com/SEU_USUARIO/claude`

> ✅ **Concluído quando:** a URL mostrar SEU nome de usuário em vez de `NovadaLabs`

---

<a id="pt-clone"></a>
## Passo 2 — Clone seu Fork para o seu Computador

"Clonar" significa baixar o repositório do GitHub para o seu computador local.

1. Abra o Terminal
2. Digite o seguinte — **substitua `SEU_USUARIO` pelo seu nome de usuário real do GitHub:**
```
git clone https://github.com/SEU_USUARIO/claude.git ~/.claude-team
```
Pressione Enter. Você verá mensagens de progresso enquanto os arquivos baixam.

3. Verifique se funcionou:
```
ls ~/.claude-team
```
Deve aparecer: `README.md  agents  hooks  rules  settings.template.json  skills`

> ✅ **Concluído quando:** `ls ~/.claude-team` mostrar esses arquivos

**Se aparecer "git: comando não encontrado":** Instale o Git em [git-scm.com/downloads](https://git-scm.com/downloads), reinicie o Terminal e tente de novo.

---

<a id="pt-install-claude"></a>
## Passo 3 — Instale o Claude Code

Claude Code é o agente de IA para o qual esta configuração foi desenvolvida. Ele roda no Terminal.

**Instale:**
```
npm install -g @anthropic-ai/claude-code
```

**Se aparecer "npm: comando não encontrado":** Instale o Node.js em [nodejs.org](https://nodejs.org). Reinicie o Terminal e tente de novo.

**Verifique:**
```
claude --version
```

**Faça login** (precisa de conta Anthropic — crie grátis em [claude.ai](https://claude.ai)):
```
claude
```
Siga as instruções na tela. Depois de logado, digite `/exit` para sair por enquanto.

> ✅ **Concluído quando:** `claude --version` mostrar um número de versão como `1.x.x`

---

<a id="pt-copy"></a>
## Passo 4 — Copie a Config da Equipe para o Claude

O Claude Code procura sua configuração em `~/.claude` no seu computador. (`~` significa sua pasta home — no Mac é `/Users/seunome`, no Windows é `C:\Users\seunome`.)

Precisamos copiar as skills, agentes e regras da equipe para essa pasta.

**Primeiro, faça backup da config existente** (pule se acabou de instalar o Claude Code):
```
cp -r ~/.claude ~/.claude-backup-$(date +%Y%m%d)
```

**Copie os arquivos da equipe:**
```
cp -r ~/.claude-team/skills ~/.claude/
cp -r ~/.claude-team/agents ~/.claude/
cp -r ~/.claude-team/rules ~/.claude/
cp -r ~/.claude-team/hooks ~/.claude/
```

**Copie o template de configurações** (só se não tiver um settings.json ainda):
```
cp ~/.claude-team/settings.template.json ~/.claude/settings.json
```

> ✅ **Concluído quando:** `ls ~/.claude/skills` mostrar uma lista de pastas

**O que acabamos de copiar?**
- `skills/` — 95 conjuntos de instruções para tarefas específicas (pesquisa, código, deploy...)
- `agents/` — 25 sub-assistentes especializados que o Claude pode acionar
- `rules/` — 8 padrões sempre ativos da equipe para desenvolvimento
- `hooks/` — scripts que rodam automaticamente quando sessões do Claude iniciam e terminam

---

<a id="pt-personal"></a>
## Passo 5 — Crie seu Arquivo de Config Pessoal

Esta é a etapa mais importante. O Claude lê um arquivo chamado `CLAUDE.md` para entender quem você é, no que está trabalhando e como você gosta de trabalhar. Sem este arquivo, o Claude trata cada sessão como se fosse a primeira vez que te conhece.

**Copie o template:**
```
cp ~/.claude-team/CLAUDE.template.md ~/.claude/CLAUDE.md
```

**Abra para editar:**
- **Mac:** `open ~/.claude/CLAUDE.md` (abre no TextEdit ou seu editor padrão)
- **VS Code:** `code ~/.claude/CLAUDE.md`
- **Windows:** `notepad %USERPROFILE%\.claude\CLAUDE.md`

**Preencha no mínimo:**
- **Current Mission** — Em qual projeto está trabalhando? (1-3 frases)
- **Key Repos** — Seus repos do GitHub e onde ficam no computador
- **Communication Style** — Prefere português ou inglês? Respostas curtas ou detalhadas?

**Exemplo de como fica preenchido:**
```
## Current Mission
Construindo um dashboard SaaS de analytics B2B para clientes de e-commerce.
Repo principal: ~/Projects/analytics-dashboard

## Key Repos
- `meuuser/analytics-dashboard` — produto principal, em ~/Projects/analytics-dashboard
- `meuuser/shared-components` — design system, em ~/Projects/shared-components

## Communication Style
- Idioma: Português
- Respostas: concisas, sem enrolação
```

> ⚠️ **Importante:** Este arquivo é pessoal. Nunca faça push dele para o repositório da equipe. O `.gitignore` já bloqueia isso, mas fique ciente.

> ✅ **Concluído quando:** `~/.claude/CLAUDE.md` existir com suas informações reais

---

<a id="pt-agentrecall"></a>
## Passo 6 — Instale o AgentRecall (Sistema de Memória)

Sem memória, o Claude esquece tudo quando você fecha a sessão. O AgentRecall resolve isso — salva automaticamente correções que você faz, contexto do projeto e suas preferências, e carrega tudo na próxima vez que você abrir o Claude.

**Instale:**
```
npm install -g @agent-recall/cli
```

**Verifique:**
```
agentrecall status
```

O `settings.template.json` que você copiou no Passo 4 já tem o AgentRecall configurado. Para confirmar, abra `~/.claude/settings.json` e procure a seção `hooks` — deve conter `agentrecall hook-start`, `agentrecall hook-correction` e `agentrecall hook-end`.

**Teste iniciando o Claude:**
```
claude
```
No início da sessão deve aparecer uma mensagem indicando que a memória foi carregada.

> ✅ **Concluído quando:** `agentrecall status` rodar sem erros

---

<a id="pt-updates"></a>
## Passo 7 — Receba Atualizações Futuras da Equipe

Quando a equipe adicionar novas skills ou melhorar as existentes, você pode trazer essas atualizações.

**Configuração única** (faça agora):
```
cd ~/.claude-team
git remote add upstream https://github.com/NovadaLabs/claude.git
```

**Quando quiser atualizar (execute quando quiser):**
```
cd ~/.claude-team
git fetch upstream
git merge upstream/main
cp -r ~/.claude-team/skills ~/.claude/
cp -r ~/.claude-team/agents ~/.claude/
cp -r ~/.claude-team/rules ~/.claude/
```

---

<a id="pt-whats-included"></a>
## O Que Está Incluído

### Skills (95 no total)
Skills são conjuntos de instruções que dizem ao Claude como fazer tarefas específicas. Use com `/nome-da-skill` no Claude Code.

| Categoria | Skills principais |
|---|---|
| Agentes e Orquestração | `agent-recall`, `agent-browser`, `agentic-engineering`, `autonomous-loops`, `team-builder` |
| Desenvolvimento | `tdd-workflow`, `api-design`, `backend-patterns`, `frontend-patterns`, `database-migrations` |
| Pesquisa | `deep-research`, `market-research`, `competitive-teardown`, `exa-search` |
| Sites e Conteúdo | `website-genome`, `awwwards-landing-page`, `content-engine`, `article-writing` |
| Infraestrutura | `deployment-patterns`, `docker-patterns`, `postgres-patterns`, `mcp-server-patterns` |
| Segurança | `security-review`, `security-scan` |
| Produto e Estratégia | `product-discovery`, `product-strategist`, `investor-materials`, `roadmap-communicator` |
| Testes | `e2e-testing`, `webapp-testing`, `ai-regression-testing`, `verification-loop` |

### Agentes (25 no total)

| Agente | O que faz | Quando o Claude usa |
|---|---|---|
| `planner` | Cria planos passo a passo antes de codar | Você pede nova feature |
| `architect` | Projeta arquitetura de sistema | Grandes decisões técnicas |
| `code-reviewer` | Revisa qualidade e bugs | Após escrever código |
| `tdd-guide` | Guia desenvolvimento orientado a testes | Novas features, correção de bugs |
| `security-reviewer` | Audita vulnerabilidades de segurança | Antes de commits |
| `build-error-resolver` | Corrige falhas de build | Quando o build quebra |
| `website-builder` | Constrói e replica sites autonomamente | Tarefas de build/replicação |

### Regras (8 arquivos)
Padrões sempre ativos: fluxo de desenvolvimento, commits git, performance, segurança, testes.

---

<a id="pt-multiagent"></a>
## Qual Agente de IA Você Usa?

| Se você usa... | Arquivo de config | Como as skills funcionam |
|---|---|---|
| **Claude Code** | `~/.claude/CLAUDE.md` | Todas as 95 skills funcionam imediatamente |
| **OpenAI Codex** | `AGENTS.md` na raiz do projeto | Copie skills para `~/.codex/skills/`, substitua nomes de tools |
| **Gemini CLI** | `GEMINI.md` | Use `activate_skill` em vez da tool `Skill` |
| **GitHub Copilot** | `AGENTS.md` | Sem sistema de skills nativo — use apenas regras |

---

<a id="pt-codex"></a>
## 🤖 Usando Codex? Guia de Configuração

> **Se você usa o OpenAI Codex CLI em vez do Claude Code, siga estes passos.** Os Passos 1–2 (Fork + Clone) são idênticos. Tudo a partir do Passo 3 é diferente.

### O que é diferente no Codex

| | Claude Code | OpenAI Codex CLI |
|---|---|---|
| Arquivo de config | `~/.claude/CLAUDE.md` | `AGENTS.md` (raiz do projeto ou `~/.codex/`) |
| Sistema de skills | Nativo — 95 skills carregam automaticamente | Sem loader nativo — regras devem ser embutidas |
| Memória | AgentRecall via hooks | Histórico de conversa integrado |
| Instalar | `npm i -g @anthropic-ai/claude-code` | `npm i -g @openai/codex` |

### Passo 3 (Codex) — Instale o Codex CLI

```
npm install -g @openai/codex
```

Configure sua chave de API da OpenAI:
```
export OPENAI_API_KEY=sua-chave-aqui
```
Para tornar permanente, adicione essa linha ao `~/.zshrc` (Mac) ou `~/.bashrc` (Linux/Windows WSL).

Verifique:
```
codex --version
```

### Passo 4 (Codex) — Copie as Regras para seu Projeto

O Codex lê `AGENTS.md` da raiz do seu projeto. Copie as regras da equipe para lá:

```
# Entre na sua pasta de projeto primeiro
cd ~/Projects/seu-projeto

# Crie AGENTS.md a partir do template
cp ~/.claude-team/CLAUDE.template.md ./AGENTS.md
```

Depois, copie as regras que quiser para o `AGENTS.md`. As mais úteis:
```
cat ~/.claude-team/rules/development-workflow.md >> ./AGENTS.md
cat ~/.claude-team/rules/git-workflow.md >> ./AGENTS.md
cat ~/.claude-team/rules/coding-style.md >> ./AGENTS.md
```

### Passo 5 (Codex) — Usando Skills com o Codex

O Codex não tem carregador automático de skills. Para usar uma skill, copie o conteúdo para o seu prompt ou para o `AGENTS.md`.

**Para usar uma skill uma vez:**
```
# Leia o conteúdo da skill e cole no seu prompt do Codex
cat ~/.claude-team/skills/deep-research/skill.md
```

**Para ativar uma skill permanentemente**, adicione ao `AGENTS.md`:
```
cat ~/.claude-team/skills/tdd-workflow/skill.md >> ./AGENTS.md
```

**Skills mais úteis para usuários do Codex:**
- `tdd-workflow` — disciplina de desenvolvimento orientado a testes
- `api-design` — padrões de design de API
- `security-review` — checklist de segurança
- `coding-standards` — regras de qualidade de código

### Passo 6 (Codex) — Config Global (Opcional)

Para aplicar regras a **todos os seus projetos** (não só um), crie uma config global:
```
mkdir -p ~/.codex
cp ~/.claude-team/CLAUDE.template.md ~/.codex/AGENTS.md
```
Edite `~/.codex/AGENTS.md` da mesma forma que no Passo 5 da configuração do Claude.

### Mapeamento de Nomes de Ferramentas do Codex

As skills referenciam nomes de ferramentas do Claude Code. Quando uma skill mencionar uma ferramenta, use a equivalência:

| A skill diz (Claude) | Use no Codex |
|---|---|
| Ferramenta `Read` | `read_file` |
| Ferramenta `Write` | `write_file` |
| Ferramenta `Edit` | `edit_file` ou `patch_file` |
| Ferramenta `Bash` | `shell` |
| Ferramenta `Grep` | `search_files` |
| Ferramenta `Glob` | `list_files` |
| Ferramenta `Skill` | Não disponível — copie o conteúdo manualmente |
| Ferramenta `Agent` | Não disponível — Codex é modo agente único |

---

<a id="pt-faq"></a>
## Perguntas Frequentes

**P: Não tenho conta no GitHub.**
Acesse [github.com](https://github.com) → Sign up → conta gratuita → pronto. Leva 2 minutos.

**P: O que é terminal?**
Uma interface de texto para interagir com seu computador. Mac: `Cmd + Espaço` → Terminal → Enter. Windows: `Win + R` → `cmd` → Enter.

**P: Apareceu "permission denied" ao copiar arquivos.**
Adicione `sudo` antes do comando: `sudo cp -r ~/.claude-team/skills ~/.claude/`

**P: Já tenho o Claude Code. Isso vai sobrescrever minhas configurações?**
Não — você copia apenas `skills/`, `agents/`, `rules/`, `hooks/`. Seu `settings.json` e `CLAUDE.md` não são sobrescritos a menos que você faça isso explicitamente.

**P: Qual a diferença entre meu fork e o repo da equipe?**
Repo da equipe = modelo compartilhado, ninguém coloca conteúdo pessoal lá. Seu fork = sua cópia pessoal. O `.gitignore` te protege de enviar arquivos pessoais por acidente.

**P: Como contribuir com uma skill minha para a equipe?**
Desenvolva, teste, e abra um Pull Request em `NovadaLabs/claude`. Peça a um colega para revisar.

[🔝 Voltar ao topo / seleção de idioma](#pt)
