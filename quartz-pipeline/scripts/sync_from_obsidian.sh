#!/usr/bin/env bash
set -euo pipefail

VAULT="/Users/a001/Documents/创业者系统库"
TARGET="/Users/a001/.openclaw/workspace/quartz-pipeline/site/content"

mkdir -p "$TARGET"

# 仅同步可发布目录（避免隐私内容外泄）
ALLOWLIST=(
  "00-仪表盘"
  "99-System/UI"
  "2026年度计划.md"
  "ima笔记启发.md"
  "ima笔记启发-共性洞察V2.md"
)

# 清理旧内容（保留 .gitkeep）
find "$TARGET" -mindepth 1 -maxdepth 1 ! -name ".gitkeep" -exec rm -rf {} +

for item in "${ALLOWLIST[@]}"; do
  src="$VAULT/$item"
  if [ -e "$src" ]; then
    rsync -a "$src" "$TARGET/"
  fi
done

echo "Synced to: $TARGET"
ls -la "$TARGET"
