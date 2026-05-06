---
name: evolution-engine
description: 进化引擎。扫描 feedback/store.json 分析反馈模式，按进化层级生成进化提案。
---

# Evolution Engine — 进化引擎

## 职责

扫描 `feedback/store.json` 分析反馈模式，按照进化系统的四层架构（L1 碎片化经验 → L2 规则毕业 → L3 技能优化 → L4 能力扩充）推进进化流程，管理 evolution_tag 生命周期（L1_RAW → L2_CANDIDATE → L3_PENDING → L4_PROPOSAL → 已采纳/已关闭）。调度 `evolution-runner` sub-agent 执行分析。

## 触发场景

- 用户说"进化扫描"、"检查反馈"、"进化管理"
- 周期性的进化检查
- feedback-writer 记录新反馈后

## 工作流程

### Step 1: 加载反馈数据
读取 `feedback/store.json`，获取：
- 所有 feedback entries（关注 evolution_tag 和 frequency_count）
- 当前 skill_scores（关注评分 < 60 的技能）
- 已有 evolution_rules

### Step 2: 执行进化扫描
创建 `evolution-runner` sub-agent 实例，传入完整的 feedback 数据，执行分析：
- **L1 检查**：新 entries 中的 evolution_tag 是否为 L1_RAW
- **L2 检查**：frequency_count ≥ 3 的 entries → 标记为 L2_CANDIDATE，生成规则提案
- **L3 检查**：skill_scores 中 score < 60 的技能 → 标记相关 entries 为 L3_PENDING，生成优化提案
- **L4 检查**：同一模式出现 ≥ 5 次且无对应 skill → 标记为 L4_PROPOSAL，生成新 skill 提案

### Step 3: 呈现结果
接收 evolution-runner 的分析结果：

| 结果 | 处理方式 |
|------|----------|
| 有提案生成 | 按风险等级提示：低风险（L2）一行告知，高风险（L3/L4）展示完整提案，询问用户是否确认执行 |
| 无待处理提案 | 报告"无待处理进化提案" |

### Step 4: 执行确认的提案
如果用户确认提案：
1. **规则升级（L2）** → 将规则追加到 EVOLUTION.md 的 evolution_rules 和变更历史
2. **Skill 优化（L3）** → 更新对应 SKILL.md 的内容
3. **能力扩充（L4）** → 调用 skill-builder 创建新 SKILL.md
4. **行为约束** → 更新 CLAUDE.md 的规则部分
5. **更新存储** → 在 feedback/store.json 中更新相关 entries 的 evolution_tag 为"已采纳"

## 核心规则

- **绝不自动修改任何文件**
- 所有修改必须经用户显式确认
- 提案文件保留在 `feedback/` 目录作为审计追踪

## 输出
- 进化提案报告
- 用户确认后更新 EVOLUTION.md / SKILL.md / CLAUDE.md
- 更新 feedback/store.json

## 参考
- `.claude\EVOLUTION.md` — 进化系统规则
- `.claude\feedback\store.json` — 反馈存储
- `.claude\agents\evolution-runner.md` — 进化引擎 sub-agent
