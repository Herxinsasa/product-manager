---
name: feedback-writer
description: 记录用户反馈到进化系统。接收反馈信号，结构化写入 feedback/store.json。
---

# Feedback Writer — 反馈记录

## 职责

接收用户反馈信号（修正、不满、偏好、建议），结构化为标准格式写入 `feedback/store.json`。维护进化系统的数据基础。

## 触发场景

- detect-feedback-signal hook 检测到反馈关键词
- 用户说"记下来"、"记录这个"、"记住"
- 用户明确表达了修正、不满或偏好

## 工作流程

### Step 1: 收集反馈信息
确定以下信息：
1. **反馈类型**：correction / dissatisfaction / preference / suggestion
2. **用户原始表述**：用户具体说了什么
3. **涉及 skill**：当前正在执行哪个 skill
4. **摘要**：简洁的反馈摘要

### Step 2: 查询现有记录
读取 `feedback/store.json`，检查是否已有相似的反馈记录：
- 如果有相同模式 → 增加 count
- 如果没有 → 创建新条目

### Step 3: 写入存储
更新 `feedback/store.json` 中的 entries 和 skill_scores。

### Step 4: 清理信号文件
删除 `.claude/feedback/.signal.tmp`（如果存在）。

## store.json 结构

```json
{
  "feedback_entries": [
    {
      "id": "fb-001",
      "timestamp": "2026-04-28T10:30:00",
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
      "effective_date": "2026-04-28"
    }
  ]
}
```

## 输出
- 更新 `feedback/store.json`
- 反馈记录确认消息
