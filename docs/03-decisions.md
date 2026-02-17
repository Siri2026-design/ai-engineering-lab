# 03 Decisions

## 核心决策
1. Obsidian 作为唯一事实源（SSOT）
2. OpenClaw 承担执行与自动化
3. 任务使用结构化字段（Task/Due/Owner/Project/Priority/Status/Source/task_id）
4. 执行日志统一落盘，支持追责与复盘
5. 对外系统最小化依赖（Notion 可阶段忽略）

## 边界决策
- 外发/高风险动作默认确认
- agent 仅写指定目录，避免污染核心笔记
- 失败要有重试、超时与人工接管
