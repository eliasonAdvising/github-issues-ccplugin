---
name: close-issue
description: Complete work and create PR
---

# Close Issue Command

Completes issue work: commits, creates PR, updates status.

## Usage

```bash
/close-issue N
```

## Process

Executes complete-work workflow from `data/workflow-states.yaml`:

1. Verify changes committed
2. Push branch
3. Create PR: `scripts/create-pr.sh`
4. Update labels: Remove in-progress, add needs-review
5. Display PR URL

## Configuration

PR template from `templates/pr-description.md`

Workflow from `data/workflow-states.yaml`
