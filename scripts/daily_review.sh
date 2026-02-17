#!/usr/bin/env bash
set -euo pipefail

VAULT_PATH="${1:-/Users/a001/Documents/Obsidian Vault}"
REVIEW_DIR="${2:-00-Daily/Reviews}"
DATE_STR="$(date +%F)"
OUT_DIR="$VAULT_PATH/$REVIEW_DIR"
OUT_FILE="$OUT_DIR/${DATE_STR}-每日复盘.md"
TEMPLATE="/Users/a001/.openclaw/workspace/templates/daily_review.md"

mkdir -p "$OUT_DIR"

if [[ -f "$OUT_FILE" ]]; then
  echo "已存在：$OUT_FILE"
  exit 0
fi

sed "s/{{DATE}}/${DATE_STR}/g" "$TEMPLATE" > "$OUT_FILE"

echo "已创建：$OUT_FILE"
