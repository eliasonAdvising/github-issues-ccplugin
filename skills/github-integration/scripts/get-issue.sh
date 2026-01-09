#!/bin/bash
# Get issue details
# Usage: ./get-issue.sh ISSUE_NUMBER
# Exit: 0=success, 3=not found

set -e

if [ -z "$1" ]; then
    echo '{"error": "Issue number required"}' >&2
    exit 1
fi

if ! gh issue view "$1" --json number &> /dev/null; then
    echo '{"error": "Issue #'"$1"' not found"}' >&2
    exit 3
fi

gh issue view "$1" --json number,title,body,labels,state,createdAt,updatedAt,author
