# EVOLUTION.md — 进化引擎系统规范

本文件定义了 Agent 系统的自我迭代逻辑。通过持续观测用户行为与任务结果，系统将实现从"经验积累"到"技能自动生成"的闭环进化。

> **设计哲学**：进化是**养成式**而非**侵入式**的。Agent 应当像影子一样学习，在用户最需要的时候，以最轻量的姿态展现进步。

---

## 1. 核心角色与职责

| 角色 | 职能描述 | 核心 Skill 依赖 |
|------|----------|----------------|
| **feedback-observer** | **经验捕获者**：静默监控用户对 Agent 输出的修正、评价及追问，将其转化为结构化的反馈条目 | feedback-writer |
| **evolution-runner** | **进化驱动者**：周期性扫描反馈库，执行模式识别、逻辑抽象及 Skill/Rule 的提议与优化 | evolution-engine |

## 2. 进化层级 (Evolution Hierarchy)

系统遵循**四层递进**的进化路径，确保从碎片化经验到系统化能力的沉淀。

### L1：碎片化经验 (Experience Collection)

**触发机制**：检测到用户对输出的显式修正（如"改一下"、"不对"、"不是这样"）或对逻辑的补全。

**动作**：`feedback-observer` 将反馈结构化记录到 `feedback/store.json`。

**记录字段**：

| 字段 | 说明 | 示例 |
|------|------|------|
| `type` | 反馈类型 | `correction` / `dissatisfaction` / `preference` / `suggestion` |
| `context` | 当前上下文 | `Embedded Linux / RK3588 Service Deployment` |
| `issue` | 用户指出的问题 | `Systemd failed to start due to missing dependency` |
| `resolution` | 采用的解决方式 | `Added 'After=network.target' to service file` |
| `frequency_count` | 累计出现次数 | 1 |
| `evolution_tag` | 当前进化标记 | `L1_RAW` / `L2_CANDIDATE` / `L3_PENDING` |

**触发方式**：
- 被动：`detect-feedback-signal` hook 自动扫描用户输入中的关键词
- 主动：用户直接说"记下来"或调用 `feedback-writer` skill

### L2：规则毕业 (Rule Graduation)

**触发机制**：同一模式或痛点在反馈记录中重复出现 ≥ 3 次。

**动作**：`evolution-runner` 提议将该模式固化为系统约束（Guidelines），更新到 `CLAUDE.md` 或 `EVOLUTION.md`。

**目标**：消除重复性低级错误，将临时经验变为持久规则。

**进化标记变更**：`L1_RAW` → `L2_CANDIDATE`

### L3：技能优化 (Skill Refinement)

**触发机制**：某特定 Skill 的反馈评分（Confidence Score）持续低于阈值（< 60），或出现逻辑执行中断。

**动作**：分析失败案例，`evolution-runner` 提议修改 `skills/` 下对应 SKILL.md 的逻辑或 Prompt。

**目标**：提升现有工具链的鲁棒性和准确率。

**进化标记变更**：`L2_CANDIDATE` → `L3_PENDING`

### L4：能力扩充 (Skill Auto-Generation)

**触发机制**：某类复杂操作模式频繁出现（≥ 5 次）且当前无任何专用 Skill 覆盖。

**动作**：`evolution-runner` 进行架构抽象，提议在 `skills/` 下创建全新的 SKILL.md，或引入新的 sub-agent。

**目标**：实现系统能力的边界扩张，自适应新需求场景。

**进化标记变更**：`L3_PENDING` → `L4_PROPOSAL`

---

## 3. 置信度与评分系统

每次反馈携带一个 `confidence_score`，反映该反馈的可信度和影响力。

### 反馈评分计算

```
技能评分 = 正面反馈数 / (正面反馈数 + 负面反馈数) × 100
```

| 评分区间 | 状态 | 动作 |
|----------|------|------|
| ≥ 80 | 健康 | 无需干预，持续监控 |
| 60 - 79 | 观察 | 标记为观察对象，追踪趋势 |
| < 60 | 告警 | 生成 L3 技能优化提案 |

### 进化标记生命周期

```
L1_RAW → L2_CANDIDATE → L3_PENDING → L4_PROPOSAL → [已采纳/已关闭]
```

- **L1_RAW**：新采集的原始反馈，未经分析
- **L2_CANDIDATE**：频次 ≥ 3，候选规则升级
- **L3_PENDING**：评分低于阈值，待优化
- **L4_PROPOSAL**：新模式识别，提案新能力
- **已采纳**：用户确认，变更已执行
- **已关闭**：用户拒绝或不再适用

---

## 4. 工作流与集成 (Workflow & Integration)

进化过程深度集成于开发生命周期，确保"进化"不干扰"生产"。

### 静默采集

在用户交互过程中，`feedback-observer` 以低优先级后台进程运行，实现交互无感。不打断用户当前工作流。

### 冷启动扫描

每次 Session 初始化时，`evolution-engine` 执行轻量级增量扫描：
1. 读取 `feedback/store.json`，检查新增 entries
2. 更新 `evolution_tag` 状态（检查是否有满足 L2/L3/L4 触发条件的条目）
3. 如果检测到满足条件的条目，生成提案摘要

### 变更审批

| 风险等级 | 对应层级 | 提示方式 | 说明 |
|----------|----------|----------|------|
| **低风险** | L1 → L2（规则毕业） | Toast 式一行提示 | "检测到重复模式，已更新规则" |
| **高风险** | L3（技能优化）/ L4（能力扩充） | 显式确认对话框 | 展示完整提案，要求用户 Review 并确认 |

> **核心约束**：所有变更必须经用户显式确认。进化系统绝不自动修改任何文件。

---

## 5. 反馈数据结构

```json
{
  "feedback_entries": [
    {
      "id": "fb-001",
      "timestamp": "2026-04-29T10:30:00",
      "type": "correction",
      "skill": "dev-builder",
      "summary": "反馈摘要",
      "context": "当前任务上下文描述",
      "issue": "用户指出的具体问题",
      "resolution": "采用的解决方式",
      "frequency_count": 1,
      "evolution_tag": "L1_RAW",
      "confidence_score": 0.85
    }
  ],
  "skill_scores": {
    "dev-builder": {
      "positive": 10,
      "negative": 2,
      "score": 83.3,
      "status": "healthy"
    }
  },
  "evolution_rules": [
    {
      "id": "rule-001",
      "source_feedback": ["fb-001", "fb-003", "fb-007"],
      "rule_summary": "规则描述",
      "target_file": ".claude/CLAUDE.md",
      "status": "active",
      "effective_date": "2026-04-29"
    }
  ]
}
```

---

## 6. 变更历史

| 日期 | 变更内容 | 类型 | 触发反馈 |
|------|----------|------|----------|
<!-- 每次确认进化提案后在此追加记录 -->
