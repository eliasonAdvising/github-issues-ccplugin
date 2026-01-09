#!/bin/bash
# GitHub Issues Plugin Uninstaller

set -e

PLUGIN_NAME="github-issues"

echo "🗑️  Uninstalling GitHub Issues Plugin"
echo ""

# Find installations
GLOBAL_PATH="$HOME/.claude/plugins/$PLUGIN_NAME"
LOCAL_PATH="./.claude/plugins/$PLUGIN_NAME"

FOUND=0

if [ -d "$GLOBAL_PATH" ]; then
    echo "Found global installation: $GLOBAL_PATH"
    FOUND=1
fi

if [ -d "$LOCAL_PATH" ]; then
    echo "Found local installation: $LOCAL_PATH"
    FOUND=1
fi

if [ $FOUND -eq 0 ]; then
    echo "No installations found."
    exit 0
fi

echo ""
read -p "Remove all found installations? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Remove installations
if [ -d "$GLOBAL_PATH" ]; then
    rm -rf "$GLOBAL_PATH"
    echo "✓ Removed global installation"
fi

if [ -d "$LOCAL_PATH" ]; then
    rm -rf "$LOCAL_PATH"
    echo "✓ Removed local installation"
fi

echo ""
echo "✓ Uninstall complete"
