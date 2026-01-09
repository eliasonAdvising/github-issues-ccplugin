---
name: github-integration
description: GitHub Issues workflow via zero-token scripts
---

# GitHub Integration Skill

Zero-token GitHub Issues management using deterministic scripts. All operations use Claude Code subscription (no API keys).

## Script Reference

Location: `scripts/` directory

All scripts return JSON for programmatic use and proper exit codes for error handling.

### Prerequisites

```bash
# Check authentication
./scripts/check-auth.sh

# Check repository access
./scripts/check-repo.sh
```

Exit codes: 0=success, 1=error, 2=not authenticated

### Issue Operations

```bash
# List issues
./scripts/list-issues.sh [--label LABEL] [--state STATE] [--limit N]

# Get issue details
./scripts/get-issue.sh ISSUE_NUMBER

# Update issue
./scripts/update-issue.sh ISSUE_NUMBER \
  [--add-label LABEL] \
  [--remove-label LABEL]

# Add comment
./scripts/comment-issue.sh ISSUE_NUMBER "Comment text"

# Close issue
./scripts/close-issue.sh ISSUE_NUMBER ["Close comment"]
```

### PR Operations

```bash
# Create pull request
./scripts/create-pr.sh \
  --title "PR title" \
  --body "PR description" \
  --base main

# Options:
#   --draft        Create as draft PR
#   --label LABEL  Add labels to PR
```

### Bulk Operations

```bash
# Update multiple issues
./scripts/bulk-update.sh \
  --source-label "claude-todo" \
  --action add \
  --target-label "sprint-1"
```

## Workflows

Reference `data/workflow-states.yaml` for state transitions.

### Start Work Workflow

```bash
# 1. Get issue
./scripts/get-issue.sh N > issue.json

# 2. Create branch
ISSUE_NUM=$(jq -r '.number' issue.json)
git checkout -b feature/issue-$ISSUE_NUM

# 3. Update status
./scripts/update-issue.sh $ISSUE_NUM \
  --remove-label "claude-todo" \
  --add-label "in-progress"

# 4. Add comment
./scripts/comment-issue.sh $ISSUE_NUM \
  "Started work with Claude Code"
```

### Complete Work Workflow

```bash
# 1. Commit changes
git add .
git commit -m "feat: implement feature (#N)"

# 2. Push branch
git push -u origin feature/issue-N

# 3. Create PR
./scripts/create-pr.sh \
  --title "feat: implement issue #N" \
  --body "Closes #N" \
  --base main

# 4. Update labels
./scripts/update-issue.sh N \
  --remove-label "in-progress" \
  --add-label "needs-review"
```

## Templates

Use templates for consistent output formatting.

### Issue Summary

Template: `templates/issue-summary.md`

```bash
# Fetch issue and format
./scripts/get-issue.sh 45 | \
  jq -r '. | @json' | \
  ./scripts/fill-template.sh templates/issue-summary.md
```

### PR Description

Template: `templates/pr-description.md`

Variables: `{changes}`, `{issue_number}`, `{testing_notes}`

## Data Configuration

### Labels

Reference: `data/default-labels.yaml`

Standard label sets:
- Type: feature, bug, enhancement, documentation
- Workflow: claude-todo, in-progress, needs-review, blocked
- Priority: p0-critical, p1-high, p2-medium, p3-low

### Workflow States

Reference: `data/workflow-states.yaml`

State transitions define which labels to add/remove during workflow changes.

### Thresholds

Reference: `data/thresholds.yaml`

Token budgets and size limits for plugin components.

## Error Handling

All scripts use consistent exit codes:
- `0` - Success
- `1` - General error
- `2` - Authentication error
- `3` - Not found (issue/PR doesn't exist)
- `4` - Permission denied

Check exit codes in workflows:

```bash
if ./scripts/get-issue.sh 999; then
    echo "Issue found"
else
    CODE=$?
    case $CODE in
        2) echo "Not authenticated" ;;
        3) echo "Issue not found" ;;
        *) echo "Error occurred" ;;
    esac
fi
```

## Examples

See `examples/workflow-examples.md` for:
- Complete feature development flow
- Bug fix workflow
- Multi-issue parallel development
- Label management examples

## Token Usage

Estimated token consumption:
- This SKILL.md: ~250 tokens (loaded on-demand)
- Scripts: 0 tokens (executed, not loaded)
- Templates: 0 tokens (filled, not loaded)
- YAML data: Referenced, loaded only when needed (~50 tokens)

Total skill overhead: ~250 tokens
