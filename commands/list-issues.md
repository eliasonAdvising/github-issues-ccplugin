---
name: list-issues
description: List GitHub issues with filtering
---

# List Issues Command

Display filtered GitHub issues via zero-token script.

## Usage

```bash
/list-issues [label]
```

## Examples

```bash
/list-issues                # All open issues
/list-issues claude-todo    # Specific label
/list-issues bug            # All bugs
```

## Process

Execute: `skills/github-integration/scripts/list-issues.sh --label {label}`

Format output using: `templates/issue-summary.md`

## Configuration

Defaults from `data/thresholds.yaml`:
- Max results: 50
- State: open
- Sort: updated (descending)
