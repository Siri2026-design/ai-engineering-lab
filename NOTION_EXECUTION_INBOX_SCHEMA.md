# Notion 执行库结构（Execution Inbox）

建议字段：
- Task（Title）
- Due（Date）
- Owner（Text 或 People）
- Project（Select）
- Priority（Select: P1/P2/P3）
- Status（Select: Todo/Doing/Done）
- Source（Text，Obsidian 文件路径）

单向流规则：
- 只从 Obsidian 同步“可执行事项”字段，不同步正文。
- Notion 只做执行推进，不回写 Obsidian 全文。
