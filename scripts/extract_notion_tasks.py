#!/usr/bin/env python3
import csv
import re
from pathlib import Path

VAULT = Path('/Users/a001/Documents/Obsidian Vault')
SEARCH_ROOT = VAULT / '00-Daily' / 'Reviews'
OUT_DIR = VAULT / '00-Daily' / 'Exports'
OUT_CSV = OUT_DIR / 'notion_tasks.csv'

section_re = re.compile(r'^##\s*→\s*Notion Tasks\s*$', re.M)
task_re = re.compile(r'^- \[ \]\s*任务：\s*(.*)\s*$')
field_re = re.compile(r'^\s*-\s*(截止|责任|项目|优先级)：\s*(.*)\s*$')

rows = []

for md in SEARCH_ROOT.rglob('*.md'):
    text = md.read_text(encoding='utf-8', errors='ignore')
    lines = text.splitlines()

    in_section = False
    current = None

    for line in lines:
        if line.startswith('## ') and '→ Notion Tasks' in line:
            in_section = True
            current = None
            continue
        elif line.startswith('## ') and in_section:
            in_section = False
            current = None

        if not in_section:
            continue

        m_task = task_re.match(line)
        if m_task:
            if current and current.get('Task'):
                rows.append(current)
            current = {
                'Task': m_task.group(1).strip(),
                'Due': '',
                'Owner': '',
                'Project': '',
                'Priority': '',
                'Status': 'Todo',
                'Source': str(md.relative_to(VAULT))
            }
            continue

        if current:
            m_field = field_re.match(line)
            if m_field:
                k, v = m_field.group(1), m_field.group(2).strip()
                if k == '截止':
                    current['Due'] = v
                elif k == '责任':
                    current['Owner'] = v
                elif k == '项目':
                    current['Project'] = v
                elif k == '优先级':
                    current['Priority'] = v

    if current and current.get('Task'):
        rows.append(current)

OUT_DIR.mkdir(parents=True, exist_ok=True)
with OUT_CSV.open('w', newline='', encoding='utf-8-sig') as f:
    writer = csv.DictWriter(f, fieldnames=['Task', 'Due', 'Owner', 'Project', 'Priority', 'Status', 'Source'])
    writer.writeheader()
    writer.writerows(rows)

print(f'Exported {len(rows)} tasks to: {OUT_CSV}')
