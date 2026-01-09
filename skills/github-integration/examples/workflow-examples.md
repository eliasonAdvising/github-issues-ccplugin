# Workflow Examples

## Complete Feature Development Flow

```bash
# 1. Check what's ready to work on
./scripts/list-issues.sh --label claude-todo

# 2. Pick an issue and get details
./scripts/get-issue.sh 45

# 3. Create feature branch
git checkout -b feature/issue-45

# 4. Update issue status
./scripts/update-issue.sh 45 \
  --remove-label "claude-todo" \
  --add-label "in-progress"

# 5. Add start comment
./scripts/comment-issue.sh 45 "Started work with Claude Code"

# 6. ... implement feature ...

# 7. Commit and push
git add .
git commit -m "feat: implement user authentication (#45)"
git push -u origin feature/issue-45

# 8. Create PR
./scripts/create-pr.sh \
  --title "feat: implement user authentication" \
  --body "Closes #45" \
  --base main

# 9. Update labels
./scripts/update-issue.sh 45 \
  --remove-label "in-progress" \
  --add-label "needs-review"
```

## Bug Fix Workflow

```bash
# 1. Get bug details
./scripts/get-issue.sh 23

# 2. Create fix branch
git checkout -b fix/issue-23

# 3. Update status
./scripts/update-issue.sh 23 \
  --remove-label "claude-todo" \
  --add-label "in-progress"

# 4. ... fix bug ...

# 5. Commit with conventional format
git commit -m "fix: resolve login timeout error (#23)"

# 6. Create PR
./scripts/create-pr.sh \
  --title "fix: resolve login timeout error" \
  --body "Fixes #23"
```

## Multi-Issue Parallel Development

```bash
# Start multiple issues
./scripts/update-issue.sh 10 --add-label "in-progress"
./scripts/update-issue.sh 11 --add-label "in-progress"

# Work on separate branches
git checkout -b feature/issue-10
# ... work ...
git checkout -b feature/issue-11
# ... work ...

# Create PRs for each
./scripts/create-pr.sh --title "feat: issue 10" --body "Closes #10"
./scripts/create-pr.sh --title "feat: issue 11" --body "Closes #11"
```

## Label Management

```bash
# Add all claude-todo issues to sprint
./scripts/bulk-update.sh \
  --source-label "claude-todo" \
  --action add \
  --target-label "sprint-1"

# Mark blocked issues
./scripts/update-issue.sh 15 \
  --remove-label "in-progress" \
  --add-label "blocked"
./scripts/comment-issue.sh 15 "Blocked: waiting for API spec"

# Unblock and resume
./scripts/update-issue.sh 15 \
  --remove-label "blocked" \
  --add-label "in-progress"
```

## Priority Triage

```bash
# List critical issues
./scripts/list-issues.sh --label p0-critical

# List high priority bugs
./scripts/list-issues.sh --label bug --label p1-high

# Escalate issue priority
./scripts/update-issue.sh 30 \
  --remove-label "p2-medium" \
  --add-label "p1-high"
```
