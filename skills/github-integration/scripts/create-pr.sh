#!/bin/bash
# Create pull request
# Usage: ./create-pr.sh --title "Title" --body "Body" --base BRANCH

set -e

TITLE=""
BODY=""
BASE="main"
DRAFT=false
LABELS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --title) TITLE="$2"; shift 2 ;;
        --body) BODY="$2"; shift 2 ;;
        --base) BASE="$2"; shift 2 ;;
        --draft) DRAFT=true; shift ;;
        --label) LABELS+=("$2"); shift 2 ;;
        *) echo '{"error": "Unknown option: '"$1"'"}' >&2; exit 1 ;;
    esac
done

if [ -z "$TITLE" ]; then
    echo '{"error": "Title required"}' >&2
    exit 1
fi

CMD="gh pr create --title \"$TITLE\" --base $BASE"

if [ -n "$BODY" ]; then
    CMD="$CMD --body \"$BODY\""
fi

if [ "$DRAFT" = true ]; then
    CMD="$CMD --draft"
fi

if [ ${#LABELS[@]} -gt 0 ]; then
    for label in "${LABELS[@]}"; do
        CMD="$CMD --label \"$label\""
    done
fi

RESULT=$(eval $CMD 2>&1)
PR_URL=$(echo "$RESULT" | grep -o 'https://github.com/[^ ]*' | head -1)

if [ -n "$PR_URL" ]; then
    PR_NUM=$(echo "$PR_URL" | grep -o '[0-9]*$')
    echo '{"pr": '"$PR_NUM"', "url": "'"$PR_URL"'", "created": true}'
else
    echo '{"error": "Failed to create PR", "output": "'"$RESULT"'"}'
    exit 1
fi
