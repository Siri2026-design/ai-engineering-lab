# MEMORY

## 运维经验：Feishu 间歇性不回消息（2026-02-13）

- 高频问题：Feishu 通道偶发不回复。
- 已确认可复现根因：`feishu` 插件重复加载（内置 + 用户扩展）触发冲突。
- 稳定修复：保留内置插件，移除/迁出用户扩展目录中的重复 feishu，并清理 `plugins.installs.feishu`。
- 复核标准：
  - `openclaw plugins list` 中 `feishu` 仅一份 loaded
  - `openclaw status --deep` 中 Feishu 为 OK
  - 日志无 `duplicate plugin id`。
- 对 Siri 的执行约束：shell/文件/网络操作必须先提示再执行。
