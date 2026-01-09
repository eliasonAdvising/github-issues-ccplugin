#!/bin/bash
# Bulk update issues
# Usage: ./bulk-update.sh --source-label L --action [add|remove] --target-label L

set -e

SOURCE_LABEL=""
ACTION=""
TARGET_LABEL=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --source-label) SOURCE_LABEL="$2"; shift 2 ;;
        --action) ACTION="$2"; shift 2 ;;
        --target-label) TARGET_LABEL="$2"; shift 2 ;;
        *) echo '{"error": "Unknown option: '"$1"'"}' >&2; exit 1 ;;
    esac
done

if [ -z "$SOURCE_LABEL" ] || [ -z "$ACTION" ] || [ -z "$TARGET_LABEL" ]; then
    echo '{"error": "Missing required arguments"}' >&2
    exit 1
fi

ISSUES=$(gh issue list --label "$SOURCE_LABEL" --json number --jq '.[].number')

if [ -z "$ISSUES" ]; then
    echo '{"updated": 0, "issues": []}'
    exit 0
fi

COUNT=0
UPDATED=()

for ISSUE in $ISSUES; do
    if [ "$ACTION" == "add" ]; then
        gh issue edit $ISSUE --add-label "$TARGET_LABEL" &> /dev/null
    elif [ "$ACTION" == "remove" ]; then
        gh issue edit $ISSUE --remove-label "$TARGET_LABEL" &> /dev/null
    fi
    COUNT=$((COUNT + 1))
    UPDATED+=($ISSUE)
done

# Format as JSON array
ISSUES_JSON=$(printf '%s\n' "${UPDATED[@]}" | jq -R . | jq -s .)
echo '{"updated": '"$COUNT"', "issues": '"$ISSUES_JSON"'}'
