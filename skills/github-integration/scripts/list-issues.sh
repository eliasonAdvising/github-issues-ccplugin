#!/bin/bash
# List GitHub issues with filtering
# Usage: ./list-issues.sh [--label LABEL] [--state STATE] [--limit N]

set -e

LABELS=()
STATE="open"
LIMIT=50

while [[ $# -gt 0 ]]; do
    case $1 in
        --label) LABELS+=("$2"); shift 2 ;;
        --state) STATE="$2"; shift 2 ;;
        --limit) LIMIT="$2"; shift 2 ;;
        *) echo '{"error": "Unknown option: '"$1"'"}' >&2; exit 1 ;;
    esac
done

CMD="gh issue list --state $STATE --limit $LIMIT --json number,title,labels,state,createdAt,updatedAt"

if [ ${#LABELS[@]} -gt 0 ]; then
    for label in "${LABELS[@]}"; do
        CMD="$CMD --label \"$label\""
    done
fi

eval $CMD
