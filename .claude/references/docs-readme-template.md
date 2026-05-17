# docs/README.md 模板

此文件应放在开发项目的 `docs/README.md`，作为 AI 快速导航的第一入口。

```markdown
# 文档导航

> 本项目所有文档索引。AI 接手项目时先读这里。

## 快速入口

| 我想... | 去看 |
|---------|------|
| 了解产品定位和 MVP 功能 | [产品概述](requirements/overview.md) |
| 查业务术语含义 | [术语表](requirements/glossary.md) |
| 了解某个功能的交互流程 | [功能设计](design/functional/) |
| 看 UI 配色和组件风格 | [原型设计](design/visual/) |
| 了解系统架构和数据流 | [架构总览](architecture/overview.md) |
| 找到某个模块的代码位置 | [模块索引](modules/README.md) |
| 了解模块的实现细节 | [模块文档](modules/<模块名>/README.md) |
| 搭建开发环境 | [开发指南](guides/development.md) |
| 写测试/跑测试 | [测试指南](guides/testing.md) |
| 构建/部署 | [部署指南](guides/build-and-deploy.md) |
| 排查问题 | [问题排查](guides/troubleshooting.md) |
| 了解需求变更历史 | [../Product-Spec-CHANGELOG.md](../Product-Spec-CHANGELOG.md) |

## 权威源文档

> docs/ 是索引和摘要，不重复写详细内容。以下文件是权威数据源：

| 文档 | 内容 | 位置 |
|------|------|------|
| Product-Spec.md | 需求、验收标准 | 项目根目录 |
| Design-Brief.md | 设计规范 | 项目根目录 |
| Tech-Arch.md | 技术架构 + ADR | 项目根目录 |
| Dev-Plan.md | 开发计划 | 项目根目录 |

## 文档维护规范

- 所有文档使用 Markdown 格式
- 架构图使用 Mermaid 语法（AI 可读可改）
- 引用代码时标注具体路径，如 `src/components/LogViewer.tsx`
- ADR 只追加不修改（标记废弃状态即可）
- 新增模块需同步更新 `modules/README.md` 索引
```
