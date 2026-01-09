#!/bin/bash
# GitHub Issues Plugin Uninstaller

set -e

echo "🗑️  Uninstalling GitHub Issues Plugin"
echo ""

# Files to remove
COMMANDS=(
    "list-issues.md"
    "work-issue.md"
    "close-issue.md"
)

AGENTS=(
    "issue-manager.md"
)

DATA_FILES=(
    "thresholds.yaml"
    "default-labels.yaml"
    "workflow-states.yaml"
)

# Check both global and local locations
LOCATIONS=(
    "$HOME/.claude"
    "./.claude"
)

FOUND=0

for LOC in "${LOCATIONS[@]}"; do
    if [ -d "$LOC/skills/github-integration" ]; then
        echo "Found installation in: $LOC"
        FOUND=1
    fi
done

if [ $FOUND -eq 0 ]; then
    echo "No installations found."
    exit 0
fi

echo ""
read -p "Remove plugin files? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

for LOC in "${LOCATIONS[@]}"; do
    # Remove commands
    for cmd in "${COMMANDS[@]}"; do
        if [ -f "$LOC/commands/$cmd" ]; then
            rm "$LOC/commands/$cmd"
            echo "✓ Removed $LOC/commands/$cmd"
        fi
    done

    # Remove agents
    for agent in "${AGENTS[@]}"; do
        if [ -f "$LOC/agents/$agent" ]; then
            rm "$LOC/agents/$agent"
            echo "✓ Removed $LOC/agents/$agent"
        fi
    done

    # Remove data files
    for data in "${DATA_FILES[@]}"; do
        if [ -f "$LOC/data/$data" ]; then
            rm "$LOC/data/$data"
            echo "✓ Removed $LOC/data/$data"
        fi
    done

    # Remove skills directory
    if [ -d "$LOC/skills/github-integration" ]; then
        rm -rf "$LOC/skills/github-integration"
        echo "✓ Removed $LOC/skills/github-integration/"
    fi
done

echo ""
echo "✓ Uninstall complete"
