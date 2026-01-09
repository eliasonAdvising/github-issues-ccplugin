#!/bin/bash
# Add comment to issue
# Usage: ./comment-issue.sh ISSUE_NUMBER "Comment text"

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
    echo '{"error": "Usage: '"$0"' ISSUE_NUMBER COMMENT"}' >&2
    exit 1
fi

gh issue comment "$1" --body "$2"
echo '{"issue": '"$1"', "commented": true}'
