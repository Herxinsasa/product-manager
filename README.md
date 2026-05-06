# 产品经理 — 自动化产品开发工作流

> 基于 Claude Code 的三层架构自动化产品开发系统。从模糊想法到可交付代码，全流程 Skill 驱动。

```
Skill 管流程  ·  Agent 管执行  ·  Hook 负责兜底  ·  进化管成长
```

---

## 三层架构

```
┌──────────────────────────────────────────────────┐
│  ‍ Layer 1 — 项目经理 (.claude/CLAUDE.md)      │
│  智能调度中枢：按需路由 Skill，管理项目状态       │
├──────────────────────────────────────────────────┤
│  ‍ Layer 2 — 技能体系 (12 个 Skill)           │
│  ️ →  →  ️ →  →   →  →  │
├──────────────────────────────────────────────────┤
│  ‍ Layer 3 — 进化系统 (EVOLUTION.md)           │
│  静默记录 → 模式识别 → 提案升级 → 确认生效       │
└──────────────────────────────────────────────────┘
```

---

## 快速开始

```bash
# 1. 在项目目录启动 Claude Code
cd 产品经理

# 2. 说出你的需求，系统自动路由到对应 Skill
"我想做一个日志分析工具，可以拖入文件自动解析"

# 3. 或直接调用指定 Skill
/product-spec-builder
/tech-architect
/dev-planner
/code-review
```

---

## 完整开发链路

```
  ‍ 模糊想法
       │
       ▼
  structured-thinking（可选前置：苏格拉底 + 第一性原理 + 奥卡姆剃刀）
       │
       ▼
  ️ product-spec-builder ──→ Product-Spec.md（PRD + 领域术语表）
       │
       ▼
   design-brief-builder ──→ Design-Brief.md（6 维度视觉 + 逐模块 UE）
       │
       ▼
  ️ design-maker ──→ design/ 目录（Pencil / Figma / HTML / Canvas）
       │
       ▼
  ️ tech-architect ──→ Tech-Arch.md（技术选型 + ADR + 复用清单）
       │
       ▼
  ️ dev-planner ──→ Dev-Plan.md（垂直切片任务 + 设计参照绑定）
       │
       ▼
   dev-builder ──→ implementer 编码 + 需求对齐审查
       │
       ▼
   code-review ──→ 代码质量 + 视觉一致性检查
       │
       ▼
   release-builder ──→ 构建发布
```

---

## Skill 详解

### ️ 需求阶段

| Skill | 职责 | 要点 |
|-------|------|------|
| **product-spec-builder** | 需求收集与澄清 | 5 维度澄清 · 二次确认原则 · 迭代模式 · 可选前置 `structured-thinking` |

**输出：** `Product-Spec.md`（含领域术语表 §1.5、决策与错误记录）

---

###  设计阶段

| Skill | 职责 | 要点 |
|-------|------|------|
| **design-brief-builder** | 设计规范收集 | 6 维度视觉澄清（产品对标 → 配色 → 字体 → 内容呈现 → 组件风格 → 动效）· 逐模块 UE 确认 |
| **design-maker** | 设计执行 | 5 种工具（Figma MCP / Pencil MCP / HTML/CSS / Canvas / 自定义）· 统一 `design/` 目录 · 回写交付物表 |

**设计精度层级：** `MCP 结构数据` > `HTML 源文件` > `PNG 降级参照` > `Design-Brief 文字规范兜底`

**输出：** `Design-Brief.md`（含设计交付物表格） + `design/` 目录

---

### ️ 架构阶段

| Skill | 职责 | 要点 |
|-------|------|------|
| **tech-architect** | 技术架构设计 | 联网调研 · 开源复用搜索 · 每项决策写 ADR（背景→决策→备选→影响）· 可选前置 `structured-thinking` |

**输出：** `Tech-Arch.md`（架构总览 + ADR + 复用清单 + 目录结构 + 数据流）

---

###  开发阶段

| Skill | 职责 | 要点 |
|-------|------|------|
| **dev-planner** | 制定开发计划 | 垂直切片（切穿 UI+逻辑+数据）· 验收「用户可\<行为\>」· 设计参照绑定 · 6 阶段划分 |
| **dev-builder** | 项目开发 | 逐任务调度 implementer · 完成后需求对齐审查（验收逐条✔/术语一致性/ADR偏离/视觉对齐） |

**implementer 编码准则（Karpathy）：**
-   **简单优先** — 超 150 行自查，不为单一场景创建抽象
-  ️ **精准修改** — 不改相邻代码风格/格式，每行变更可追溯
-   **目标驱动** — 先定义可验证成功标准，循环直到达成

**输出：** `Dev-Plan.md` + `<project>/src/` 代码

---

###  质量阶段

| Skill | 职责 | 要点 |
|-------|------|------|
| **bug-fixer** | 系统化调试 | 5 阶段：收集证据 → 编写重现用例（确认失败）→ 分析规律 → 提出假设 → 实施修复 |
| **code-review** | 代码审查 | 质量 / 安全性 / 性能 / 架构 / 视觉一致性（色值/圆角/间距/布局 vs Design-Brief） |

---

###  发布 & 元技能

| Skill | 职责 |
|-------|------|
| **release-builder** | 构建验证 · 版本管理 · 部署发布 |
| **skill-builder** | 创建新 Skill（质量 checklist / 体积约束 / 拆分规则） |
| **feedback-writer** | 记录反馈到进化系统（hook 32 关键词检测 + 语义判断） |
| **evolution-engine** | 扫描反馈 → 频次 ≥3 升级规则 → 评分 <60 提议优化 |

---

##  可集成外部 Skill

| Skill | 集成位置 | 作用 |
|-------|---------|------|
| **structured-thinking** | product-spec-builder 前置 · tech-architect 前置 | 苏格拉底提问 + 第一性原理 + 奥卡姆剃刀 |

---

##   Sub-Agents

| Agent | 职责 | 调用者 |
|-------|------|--------|
| **implementer** | 编码实现（Karpathy 准则） | dev-builder |
| **code-reviewer** | 代码审查（质量 + 视觉一致性） | code-review |
| **feedback-observer** | 分析反馈信号 | feedback-writer |
| **evolution-runner** | 生成进化提案 | evolution-engine |

>  **隔离执行：** 每个 sub-agent 每次任务全新实例，不继承上下文。

---

##   Hooks

| Hook | 事件 | 功能 |
|------|------|------|
| **detect-feedback-signal** | `UserPromptSubmit` | 检测 32 个反馈关键词 → 写入 `.signal.tmp` |
| **stop-gate** | `Stop` | 检测未审查代码修改 → 阻止 Agent 停止 |
| **auto-push** | Git `post-commit` | 自动推送到远程仓库 |
| **pre-commit-check** | Git `pre-commit` | 编译检查 → 失败阻止提交 |

>  **路径可移植：** 所有 hook 命令使用 `$CLAUDE_PROJECT_DIR`，项目移动无需改配置。

---

##  设计到代码追溯链

```
design-maker 产出 → design/ 目录
         │
         ▼
回写 Design-Brief.md「设计交付物」表格（源文件路径 + 降级参照）
         │
         ▼
dev-planner 读表 → 任务绑定「设计参照」字段
         │
         ▼
implementer 读取设计源 → MCP 结构数据 > PNG > 文字规范
         │
         ▼
dev-builder 需求对齐审查 → 逐条验收✔ + 视觉对齐✔
         │
         ▼
code-review 视觉一致性检查清单
```

---

##   Session 持久化与回档

```
重启 Session
     │
     ▼
读 progress.json → human_summary
     │  "设计阶段 — design-brief-builder — 模块 3/7 UE 确认中"
     ▼
扫描文档状态 + feedback/store.json + .signal.tmp
     │
     ▼
回档摘要 → 用户选择：  继续 /  重来 /  跳阶段
```

>  **决策不丢失：** 所有产出文档末尾有「决策与错误记录」区，记录做的决定和踩的坑。

---

##  目录结构

```
产品经理/
├──  README.md                     # 本文件
├──  CLAUDE.md                     # 入口 → .claude/CLAUDE.md
├──  Product-Spec.md               # 产品需求文档
├──  Product-Spec-CHANGELOG.md     # 需求变更记录
├──  Design-Brief.md               # 设计规范
├──  Tech-Arch.md                  # 技术架构（ADR）
├──  Dev-Plan.md                   # 开发计划
├──  .out-of-scope/                # 已否决的功能记录
├──  design/                       # 设计交付物
│   ├──  pencil/                   # Pencil .pen + 截图
│   ├──  figma/                    # Figma 链接 + 截图
│   └──  prototypes/               # HTML/CSS 原型
├──  <project>/                    # 项目代码
│
└──  .claude/
    ├──  CLAUDE.md                 # Layer 1：项目经理角色定义
    ├──  EVOLUTION.md              # Layer 3：进化系统规范
    ├──  progress.json             # Session 进度存档
    ├──  settings.local.json       # 权限与 Hooks 配置
    ├──  agents/                   # Sub-agents 定义
    │   ├── implementer.md
    │   ├── code-reviewer.md
    │   ├── feedback-observer.md
    │   └── evolution-runner.md
    ├──  feedback/                 # 反馈存储
    │   └── store.json
    ├──  skills/                   # 12 个 Skill
    │   ├── product-spec-builder/
    │   ├── design-brief-builder/
    │   ├── design-maker/
    │   ├── tech-architect/
    │   ├── dev-planner/
    │   ├── dev-builder/
    │   ├── bug-fixer/
    │   ├── code-review/
    │   ├── release-builder/
    │   ├── skill-builder/
    │   ├── feedback-writer/
    │   └── evolution-engine/
    └──  hooks/                    # 4 个 Hook 脚本
        ├── detect-feedback-signal.ps1
        ├── stop-gate.ps1
        ├── auto-push.ps1
        └── pre-commit-check.ps1
```

---

##  设计原则

| # | 原则 | 说明 |
|---|------|------|
| 1 |  **按需调用** | 不是固定流水线，根据需要精准调起 Skill |
| 2 |  **隔离执行** | Sub-agent 全新实例，不继承上下文 |
| 3 |  **先重现再修复** | Bug 修复前必须用重现用例确认 Bug 存在 |
| 4 |  **垂直切片** | 任务拆分切穿全层（UI+逻辑+数据），完成后可独立演示 |
| 5 |  **设计可追溯** | 设计稿 → 任务绑定 → implementer 读取 → 审查验证 |
| 6 |  **Session 持久化** | progress.json 确保重启可恢复进度 |
| 7 |  **术语统一** | 所有代码命名以 Product-Spec 领域术语表为准 |
| 8 |  **需求对齐审查** | 每个任务完成后对照验收标准逐条打勾 |
| 9 |  **进化不革命** | 渐进式优化，每一步都需人确认 |

---

##  参考来源

| 来源 | 借鉴 |
|------|------|
| **Andrej Karpathy** | 简单优先、精准修改、目标驱动的编码准则 |
| **Matt Pocock** | grill-with-docs 需求对齐审查、to-issues 垂直切片、.out-of-scope 拒绝记录、领域术语表 |
| **Manus / planning-with-files** | 文件系统作为外部记忆、进度持久化、5-Question Reboot Test |
| **Darwin Skill** | 8 维评分 Rubric、独立子 Agent 评分、results.tsv 实验日志 |
