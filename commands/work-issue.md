---
name: work-issue
description: Start work on GitHub issue
---

# Work on Issue Command

Automates starting work on an issue via workflow scripts.

## Usage

```bash
/work-issue N
```

## Process

Executes complete start-work workflow from `data/workflow-states.yaml`:

1. Fetch issue: `scripts/get-issue.sh N`
2. Create branch: `feature/issue-N`
3. Update labels: Remove claude-todo, add in-progress
4. Add comment: "Started work with Claude Code"
5. Activate issue-manager agent

## Configuration

Branch prefix from `data/thresholds.yaml` (default: "feature")

Workflow from `data/workflow-states.yaml`
