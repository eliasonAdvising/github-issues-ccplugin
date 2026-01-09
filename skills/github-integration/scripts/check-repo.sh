#!/bin/bash
# Check GitHub repository access
# Exit: 0=success, 1=not in repo, 3=no access

set -e

if ! git rev-parse --git-dir &> /dev/null; then
    echo '{"error": "Not in a git repository"}'
    exit 1
fi

if ! gh repo view &> /dev/null; then
    echo '{"error": "Repository not accessible or not on GitHub"}'
    exit 3
fi

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
echo '{"repository": "'"$REPO"'", "accessible": true}'
exit 0
