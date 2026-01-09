#!/bin/bash
# Update issue labels
# Usage: ./update-issue.sh ISSUE_NUMBER [--add-label L] [--remove-label L]

set -e

if [ -z "$1" ]; then
    echo '{"error": "Issue number required"}' >&2
    exit 1
fi

ISSUE_NUMBER=$1
shift

ADD_LABELS=()
REMOVE_LABELS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --add-label) ADD_LABELS+=("$2"); shift 2 ;;
        --remove-label) REMOVE_LABELS+=("$2"); shift 2 ;;
        *) echo '{"error": "Unknown option: '"$1"'"}' >&2; exit 1 ;;
    esac
done

for label in "${REMOVE_LABELS[@]}"; do
    gh issue edit "$ISSUE_NUMBER" --remove-label "$label" 2>/dev/null || true
done

for label in "${ADD_LABELS[@]}"; do
    gh issue edit "$ISSUE_NUMBER" --add-label "$label"
done

echo '{"issue": '"$ISSUE_NUMBER"', "updated": true}'
