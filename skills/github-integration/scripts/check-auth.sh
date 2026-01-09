#!/bin/bash
# Check GitHub CLI authentication
# Exit: 0=authenticated, 2=not authenticated

set -e

if gh auth status &> /dev/null; then
    USER=$(gh api user -q .login 2>/dev/null || echo "unknown")
    echo '{"authenticated": true, "user": "'"$USER"'"}'
    exit 0
else
    echo '{"authenticated": false, "error": "Not authenticated. Run: gh auth login"}'
    exit 2
fi
