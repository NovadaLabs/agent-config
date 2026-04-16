# NovadaLabs AI Configuração

🌍 **Idioma:** [English](README.md) · [中文](README.zh.md) · [Português](README.pt-BR.md)

---

> Sistema de configuração de agentes de IA compartilhado pela equipe NovadaLabs. Faça um fork deste repositório, aplique sua camada pessoal e tenha um agente de IA totalmente configurado em minutos — seja Claude Code, Codex ou outro runtime.

---

## Índice

- [O que é isso](#o-que-é-isso)
- [Arquitetura: Três Camadas](#arquitetura-três-camadas)
- [Pré-requisitos](#pré-requisitos)
- [Início Rápido — Fork e Instalação](#início-rápido--fork-e-instalação)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Catálogo de Skills](#catálogo-de-skills)
- [Definições de Agentes](#definições-de-agentes)
- [Regras e Princípios](#regras-e-princípios)
- [Configuração do AgentRecall](#configuração-do-agentrecall)
- [Guia Multi-Agente](#guia-multi-agente)
- [Personalização](#personalização)
- [Notas de Plataforma](#notas-de-plataforma)
- [Como Contribuir](#como-contribuir)

---

## O que é isso

Este repositório é a **camada de configuração compartilhada** dos agentes de IA da NovadaLabs. Ele contém:

- **95 skills** — conjuntos de instruções reutilizáveis para tarefas específicas (pesquisa, código, deploy, etc.)
- **Definições de agentes** — subagentes especializados em revisão de código, planejamento, TDD, segurança e mais
- **Regras** — padrões da equipe para fluxo de desenvolvimento, Git, performance e segurança
- **Hooks** — scripts que executam automaticamente no início/fim da sessão e no uso de ferramentas
- **AgentRecall** — sistema de memória persistente que dá aos agentes contexto entre sessões

**O que NÃO está aqui:** Este repositório não contém memória pessoal, credenciais, diários ou contexto específico de projeto. Esses ficam na sua camada pessoal (explicada abaixo).

---

## Arquitetura: Três Camadas

```
┌─────────────────────────────────────────┐
│  Camada 3: Contexto do Projeto          │  ← CLAUDE.md na raiz do projeto
├─────────────────────────────────────────┤
│  Camada 2: Camada Pessoal               │  ← Seu CLAUDE.md, memory/, journal/
├─────────────────────────────────────────┤
│  Camada 1: Equipe Compartilhada (aqui)  │  ← skills/, agents/, rules/, hooks/
└─────────────────────────────────────────┘
```

- **Camada 1** (este repositório) é compartilhada. Receba atualizações fazendo pull do repositório upstream da equipe.
- **Camada 2** é só sua. Sua missão, seus projetos, sua memória. Nunca faça commit disso no repositório da equipe.
- **Camada 3** é por projeto. Um arquivo `CLAUDE.md` na raiz do projeto dá ao agente contexto específico do projeto.

---

## Pré-requisitos

| Requisito | Versão | Observações |
|---|---|---|
| Node.js | 20+ | Necessário para AgentRecall e hooks |
| Git | qualquer | Necessário para sincronizar configuração |
| Claude Code | mais recente | Runtime de agente principal suportado |
| macOS | 14+ | Algumas ferramentas (bb-browser, opencli) são exclusivas do Mac |

Outros runtimes (Codex, Copilot CLI) são suportados com pequenas diferenças — veja [Guia Multi-Agente](#guia-multi-agente).

---

## Início Rápido — Fork e Instalação

### Passo 1 — Faça um Fork do repositório

Acesse `https://github.com/NovadaLabs/claude` e clique em **Fork** (canto superior direito).

> **Por que fazer Fork?** O Fork cria sua cópia independente. Você pode fazer commit da sua camada pessoal (CLAUDE.md, memory/) no seu fork sem afetar o repositório da equipe. Quando o repositório da equipe for atualizado, você pode trazer essas mudanças para o seu fork.

### Passo 2 — Clone o seu Fork

```bash
# Substitua YOUR_USERNAME pelo seu nome de usuário do GitHub
git clone https://github.com/YOUR_USERNAME/claude.git ~/.claude-team
```

### Passo 3 — Instale no diretório de configuração do agente

**Claude Code:**
```bash
# Faça backup da sua configuração existente primeiro
cp -r ~/.claude ~/.claude-backup-$(date +%Y%m%d)

# Copie skills, agents, rules e hooks da equipe
cp -r ~/.claude-team/skills ~/.claude/
cp -r ~/.claude-team/agents ~/.claude/
cp -r ~/.claude-team/rules ~/.claude/
cp -r ~/.claude-team/hooks ~/.claude/
```

**Codex / OpenAI:** Veja [Guia Multi-Agente](#guia-multi-agente).

### Passo 4 — Configure o remote upstream (para receber atualizações da equipe)

```bash
cd ~/.claude-team
git remote add upstream https://github.com/NovadaLabs/claude.git
```

Para trazer atualizações futuras da equipe:
```bash
git fetch upstream
git merge upstream/main
```

### Passo 5 — Crie seu CLAUDE.md pessoal

```bash
cp ~/.claude-team/CLAUDE.template.md ~/.claude/CLAUDE.md
```

Edite `~/.claude/CLAUDE.md` com:
- Sua missão e projetos atuais
- Repositórios e caminhos importantes
- Suas preferências pessoais

### Passo 6 — Instale o AgentRecall

```bash
npm install -g @agent-recall/cli
```

Adicione os hooks do AgentRecall ao `~/.claude/settings.json` — veja [Configuração do AgentRecall](#configuração-do-agentrecall).

---

## Estrutura de Pastas

```
~/.claude/
├── CLAUDE.md                  ← Suas instruções pessoais (NÃO fazer commit no repositório da equipe)
├── skills/                    ← 95 skills reutilizáveis (compartilhadas pela equipe)
│   ├── agent-recall/          ← Integração com sistema de memória
│   ├── website-genome/        ← Sistema de replicação de sites
│   ├── deep-research/         ← Pesquisa multi-fonte
│   └── ...                    ← (veja Catálogo de Skills)
├── agents/                    ← Definições de subagentes especializados
│   ├── code-reviewer.md
│   ├── planner.md
│   └── ...
├── rules/                     ← Princípios da equipe e regras de fluxo
│   ├── development-workflow.md
│   ├── git-workflow.md
│   ├── agent-orchestration.md
│   └── ...
├── hooks/                     ← Scripts de automação
│   ├── session-start-sync.sh
│   └── session-stop-sync.sh
├── memory/                    ← PESSOAL — não está no repositório da equipe
│   ├── MEMORY.md              ← Índice de todas as memórias
│   └── journal/               ← Diário de sessão
└── settings.json              ← Configuração do Claude Code (versão template no repositório da equipe)
```

---

## Catálogo de Skills

Skills são conjuntos de instruções reutilizáveis para tarefas específicas. Invoque com a ferramenta `Skill` no Claude Code.

### Agentes e Orquestração
| Skill | Finalidade |
|---|---|
| `agent-recall` | Memória persistente entre sessões |
| `agent-browser` | Automação de browser com o Chrome do usuário |
| `agentic-engineering` | Padrões de design de sistemas multi-agente |
| `autonomous-loops` | Loops de agentes auto-executáveis |
| `continuous-agent-loop` | Fluxos de agentes recorrentes |
| `enterprise-agent-ops` | Operações de agentes em produção |
| `team-builder` | Construir e configurar equipes de agentes |

### Desenvolvimento
| Skill | Finalidade |
|---|---|
| `tdd-workflow` | Desenvolvimento orientado a testes (vermelho/verde/refatoração) |
| `code-to-prd` | Converter código em requisitos de produto |
| `api-design` | Padrões de design de API e revisão |
| `backend-patterns` | Padrões de arquitetura server-side |
| `frontend-patterns` | Padrões de implementação UI/UX |
| `database-migrations` | Estratégias seguras de migração de banco de dados |
| `coding-standards` | Padronização de estilo de código da equipe |
| `bun-runtime` | Padrões específicos do Bun.js |
| `nextjs-turbopack` | Configuração Next.js + Turbopack |

### Pesquisa e Descoberta
| Skill | Finalidade |
|---|---|
| `deep-research` | Pesquisa estruturada multi-fonte |
| `market-research` | Análise de panorama competitivo |
| `competitive-teardown` | Análise detalhada de concorrentes |
| `exa-search` | Pesquisa web com Exa |
| `iterative-retrieval` | Refinamento progressivo de buscas |
| `research-summarizer` | Condensar pesquisa em insights |
| `documentation-lookup` | Encontrar documentação oficial rapidamente |

### Sites e Conteúdo
| Skill | Finalidade |
|---|---|
| `website-genome` | Sistema completo de replicação de sites |
| `awwwards-landing-page` | Landing pages de nível premiado |
| `landing-page-generator` | Scaffolding rápido de landing pages |
| `content-engine` | Produção estruturada de conteúdo |
| `article-writing` | Geração de artigos longos |
| `crosspost` | Publicação multi-plataforma de conteúdo |

### Infraestrutura e DevOps
| Skill | Finalidade |
|---|---|
| `deployment-patterns` | Estratégias de CI/CD e deploy |
| `docker-patterns` | Boas práticas com Docker/contêineres |
| `postgres-patterns` | Padrões de otimização do PostgreSQL |
| `mcp-server-patterns` | Design e deploy de servidores MCP |
| `eval-harness` | Configuração de framework de avaliação |

### Segurança
| Skill | Finalidade |
|---|---|
| `security-review` | Auditoria de segurança de código |
| `security-scan` | Varredura automatizada de vulnerabilidades |

### Produto e Estratégia
| Skill | Finalidade |
|---|---|
| `product-discovery` | Pesquisa com usuário e definição de problema |
| `product-strategist` | Decisões estratégicas de produto |
| `product-manager-toolkit` | Fluxo e artefatos de PM |
| `investor-materials` | Materiais para pitch e investidores |
| `roadmap-communicator` | Criação e comunicação de roadmap |

### Testes e Qualidade
| Skill | Finalidade |
|---|---|
| `e2e-testing` | Configuração e execução de testes E2E |
| `webapp-testing` | Padrões de QA para aplicações web |
| `ai-regression-testing` | Testes de regressão de saída de IA |
| `verification-loop` | Padrões de verificação em múltiplas etapas |
| `python-testing` | Padrões de testes em Python |

### Automação e Ferramentas
| Skill | Finalidade |
|---|---|
| `playwright-pro` | Automação avançada com Playwright |
| `playwright-cli` | Uso do Playwright CLI |
| `opencli` | Ferramenta CLI para ações sociais/web |
| `tmux` | Fluxos de trabalho com multiplexador de terminal |
| `x-api` | Integração com a API do X (Twitter) |

> **Lista completa:** Execute `/find-skills` no Claude Code para pesquisar e descobrir todas as skills.

---

## Definições de Agentes

Subagentes especializados em `agents/`. O Claude Code os carrega automaticamente.

| Agente | Finalidade | Quando usar |
|---|---|---|
| `planner` | Planejamento de implementação | Antes de começar features complexas |
| `architect` | Design de sistemas | Decisões de arquitetura |
| `code-reviewer` | Revisão de código | Após escrever qualquer código |
| `tdd-guide` | Desenvolvimento orientado a testes | Novas features, correção de bugs |
| `security-reviewer` | Auditoria de segurança | Antes de commits, após mudanças em autenticação |
| `build-error-resolver` | Corrigir falhas de build | Quando o build falha |
| `e2e-runner` | Execução de testes E2E | Fluxos críticos do usuário |
| `refactor-cleaner` | Remoção de código morto | Manutenção de código |
| `doc-updater` | Atualização de documentação | Após conclusão de feature |
| `website-builder` | Construtor autônomo de sites | Tarefas de replicação e construção |

---

## Regras e Princípios

As regras em `rules/` são padrões sempre ativos da equipe, carregados em cada sessão.

| Arquivo | Cobertura |
|---|---|
| `development-workflow.md` | Pesquisa → Planejar → TDD → Revisar → Commit |
| `git-workflow.md` | Formato de commit, processo de PR |
| `agent-orchestration.md` | Padrões de design multi-agente, Cinco Pilares |
| `core-operations.md` | Prioridade de browser, sincronização com GitHub |
| `performance.md` | Seleção de modelo, gestão de janela de contexto |
| `security.md` | Práticas de código com segurança em primeiro lugar |
| `testing.md` | Requisitos de cobertura de testes |
| `coding-style.md` | Diretrizes de estilo de código |

---

## Configuração do AgentRecall

O AgentRecall dá aos agentes memória persistente entre sessões — histórico de correções, contexto do projeto, preferências do usuário.

**Instalação:**
```bash
npm install -g @agent-recall/cli
```

**Adicione os hooks ao `~/.claude/settings.json`:**
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

**Verificação:**
```bash
agentrecall status
```

O AgentRecall armazena a memória em `~/.claude/projects/<project>/memory/` — isso é pessoal e não deve ser enviado ao repositório da equipe.

---

## Guia Multi-Agente

### Qual arquivo configura o agente?

| Runtime do Agente | Arquivo de Configuração | Localização das Skills |
|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/skills/` |
| OpenAI Codex | `AGENTS.md` (raiz do projeto) | `~/.codex/skills/` |
| GitHub Copilot CLI | `AGENTS.md` | Sem sistema de skills |
| Gemini CLI | `GEMINI.md` | Skills via `activate_skill` |

### Mapeamento de nomes de ferramentas

As skills referenciam nomes de ferramentas do Claude Code. Se você usar outro runtime, faça a correspondência:

| Claude Code | Codex | Copilot CLI | Gemini CLI |
|---|---|---|---|
| Ferramenta `Skill` | ferramenta `skill` | Não suportado | `activate_skill` |
| Ferramenta `Agent` | despacho de subagente | Não suportado | Não suportado |
| Ferramenta `Read` | `read_file` | `read_file` | `read_file` |
| Ferramenta `Bash` | `shell` | `shell` | `shell` |

### Como escolher

**Usando Claude Code:** Siga o Início Rápido exatamente. Todas as 95 skills funcionam imediatamente.

**Usando Codex:** Copie as skills para `~/.codex/skills/`. Edite cada arquivo de skill e substitua os nomes das ferramentas usando a tabela de mapeamento acima. O `AGENTS.md` substitui o `CLAUDE.md`.

**Usando ambos:** Mantenha `~/.claude/` para Claude Code e `~/.codex/` para Codex. Copie as skills relevantes para ambos os locais.

---

## Personalização

**Estes arquivos são seus — não envie para o repositório da equipe:**

| Arquivo/Pasta | O que colocar |
|---|---|
| `~/.claude/CLAUDE.md` | Sua missão, projetos, regras pessoais, caminhos importantes |
| `~/.claude/memory/` | Memória do AgentRecall (gerenciada automaticamente) |
| `~/.claude/settings.local.json` | Chaves de API pessoais, sobrescritas locais |

**Template:** Copie `CLAUDE.template.md` e preencha:
- `## Current Mission` — no que você está trabalhando agora
- `## Key Repos` — seus repositórios GitHub e caminhos locais
- `## Communication Style` — preferências de idioma, formato de resposta

**Contribuindo skills pessoais para a equipe:** Se você criar uma skill que toda a equipe pode se beneficiar, envie um PR para o repositório da equipe. Veja [Como Contribuir](#como-contribuir).

---

## Notas de Plataforma

**Ferramentas exclusivas do Mac:**
- `bb-browser` — conecta ao Chrome do usuário via AppleScript. Somente Mac.
- `opencli` — usa perfil Chrome do macOS. Somente Mac.

**Node.js obrigatório:**
- Hooks do AgentRecall requerem Node.js 20+
- Hooks de sincronização de sessão requerem Node.js

**Usuários Windows/Linux:**
- Skills funcionam completamente (são arquivos Markdown de instrução)
- Definições de agentes funcionam completamente
- Substitua `bb-browser` por `playwright-pro` para automação de browser
- Substitua `opencli` por chamadas diretas à API

---

## Como Contribuir

1. Faça fork do repositório da equipe (`NovadaLabs/claude`)
2. Crie uma branch: `git checkout -b skill/minha-nova-skill`
3. Adicione sua skill em `skills/minha-nova-skill/` com um arquivo `skill.md`
4. Teste: invoque no Claude Code, verifique se funciona como esperado
5. Envie um PR com: o que a skill faz, quando usar, exemplo de invocação

**Formato do arquivo de skill:**
```markdown
---
name: minha-skill
description: Descrição em uma linha para descoberta de skills
---

# Minha Skill

## Quando usar
...

## Passos
...
```

---

*Mantido pela NovadaLabs. Construído com o harness [Superpowers](https://github.com/superpowers).*
