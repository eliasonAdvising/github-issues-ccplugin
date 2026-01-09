# Usage Guide

## Philosophy

**Manual Issue Management** - Create and manage issues via GitHub web/mobile interface.

**Claude Code Implementation** - Use Claude Code to implement issues with automated workflows.

## Commands

### /list-issues

List open issues, optionally filtered by label.

```bash
/list-issues              # All open issues
/list-issues claude-todo  # Ready for Claude
/list-issues bug          # All bugs
```

### /work-issue

Start work on a specific issue.

```bash
/work-issue 45
```

This will:
1. Fetch issue details
2. Create feature branch `feature/issue-45`
3. Update labels (claude-todo -> in-progress)
4. Add comment to issue
5. Begin implementation

### /close-issue

Complete work and create PR.

```bash
/close-issue 45
```

This will:
1. Verify changes are committed
2. Push branch to remote
3. Create pull request
4. Update labels (in-progress -> needs-review)
5. Display PR URL

## Workflow

### Daily Development

```bash
# 1. Start Claude Code
cd your-project
claude

# 2. Check available work
/list-issues claude-todo

# 3. Pick and start
/work-issue 45

# 4. Claude implements...

# 5. Complete
/close-issue 45
```

### Label Meanings

| Label | Meaning |
|-------|---------|
| `claude-todo` | Ready for Claude to implement |
| `in-progress` | Currently being worked on |
| `needs-review` | PR created, awaiting review |
| `blocked` | Cannot proceed (dependency) |

## Direct Script Usage

All scripts are in `skills/github-integration/scripts/`:

```bash
# List issues
./scripts/list-issues.sh --label bug --limit 10

# Get issue details
./scripts/get-issue.sh 45

# Update labels
./scripts/update-issue.sh 45 --add-label "p1-high"

# Add comment
./scripts/comment-issue.sh 45 "Working on this now"

# Create PR
./scripts/create-pr.sh --title "feat: new feature" --body "Closes #45"
```

## Best Practices

1. **One issue at a time** - Focus on single issues
2. **Clear acceptance criteria** - Write detailed issue descriptions
3. **Use labels consistently** - Follow the workflow labels
4. **Commit frequently** - Small, focused commits
5. **Reference issues** - Use `#N` in commits and PRs
