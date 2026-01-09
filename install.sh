#!/bin/bash
# GitHub Issues Plugin Installer
# Usage: ./install.sh [--local|--global] [--project PATH]

set -e

VERSION="1.0.0"
PLUGIN_NAME="github-issues"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  GitHub Issues Plugin Installer v${VERSION}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Parse arguments
INSTALL_TYPE="local"
PROJECT_PATH=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --local)
            INSTALL_TYPE="local"
            shift
            ;;
        --global)
            INSTALL_TYPE="global"
            shift
            ;;
        --project)
            PROJECT_PATH="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Usage: $0 [--local|--global] [--project PATH]"
            exit 1
            ;;
    esac
done

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine installation path
if [ "$INSTALL_TYPE" == "global" ]; then
    INSTALL_PATH="$HOME/.claude/plugins/$PLUGIN_NAME"
    echo "📦 Installing globally to: $INSTALL_PATH"
elif [ -n "$PROJECT_PATH" ]; then
    INSTALL_PATH="$PROJECT_PATH/.claude/plugins/$PLUGIN_NAME"
    echo "📦 Installing to project: $INSTALL_PATH"
else
    if [ -d ".git" ]; then
        INSTALL_PATH="./.claude/plugins/$PLUGIN_NAME"
        echo "📦 Installing to current project: $INSTALL_PATH"
    else
        echo -e "${YELLOW}⚠️  Not in a git repository. Installing globally.${NC}"
        INSTALL_PATH="$HOME/.claude/plugins/$PLUGIN_NAME"
        echo "📦 Installing to: $INSTALL_PATH"
    fi
fi

# Check prerequisites
echo ""
echo "🔍 Checking prerequisites..."

# Check for gh CLI
if ! command -v gh &> /dev/null; then
    echo -e "${RED}✗ GitHub CLI (gh) not found${NC}"
    echo "  Install from: https://cli.github.com/"
    exit 1
fi
echo -e "${GREEN}✓ GitHub CLI found: $(gh --version | head -n 1)${NC}"

# Check gh authentication
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}⚠️  GitHub CLI not authenticated${NC}"
    echo "  Run: gh auth login"
    read -p "Continue installation anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ GitHub authenticated${NC}"
fi

# Create installation directory
echo ""
echo "📁 Creating directory structure..."
mkdir -p "$INSTALL_PATH"

# Copy plugin files
echo "📋 Copying plugin files..."
cp -r "$SCRIPT_DIR/skills" "$INSTALL_PATH/"
cp -r "$SCRIPT_DIR/agents" "$INSTALL_PATH/"
cp -r "$SCRIPT_DIR/commands" "$INSTALL_PATH/"
cp -r "$SCRIPT_DIR/data" "$INSTALL_PATH/"
cp "$SCRIPT_DIR/plugin.json" "$INSTALL_PATH/"
cp "$SCRIPT_DIR/README.md" "$INSTALL_PATH/"

# Make scripts executable
echo "🔧 Setting script permissions..."
chmod +x "$INSTALL_PATH"/skills/github-integration/scripts/*.sh

# Verify installation
echo ""
echo "✅ Verifying installation..."
if [ -f "$INSTALL_PATH/plugin.json" ]; then
    echo -e "${GREEN}✓ Plugin files installed${NC}"
else
    echo -e "${RED}✗ Installation verification failed${NC}"
    exit 1
fi

# Test script execution
if "$INSTALL_PATH/skills/github-integration/scripts/check-auth.sh" &> /dev/null; then
    echo -e "${GREEN}✓ Scripts are executable${NC}"
else
    echo -e "${YELLOW}⚠️  Scripts may need manual chmod${NC}"
fi

# Success message
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Next steps:"
echo ""
echo "1. Start Claude Code in a repository:"
echo "   cd your-project && claude"
echo ""
echo "2. Use commands:"
echo "   /list-issues claude-todo"
echo "   /work-issue 45"
echo ""
echo "3. Read documentation:"
echo "   cat $INSTALL_PATH/README.md"
echo ""

# Offer to setup labels
if [ "$INSTALL_TYPE" != "global" ] && [ -d ".git" ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p "📝 Create standard labels in this repository? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Creating labels..."

        echo "  • feature (green)"
        gh label create "feature" --color "0E8A16" --description "New feature or request" 2>/dev/null || echo "    Already exists"

        echo "  • bug (red)"
        gh label create "bug" --color "D73A4A" --description "Something isn't working" 2>/dev/null || echo "    Already exists"

        echo "  • claude-todo (yellow)"
        gh label create "claude-todo" --color "FBCA04" --description "Work on with Claude Code" 2>/dev/null || echo "    Already exists"

        echo "  • in-progress (light yellow)"
        gh label create "in-progress" --color "FEF2C0" --description "Currently being worked on" 2>/dev/null || echo "    Already exists"

        echo -e "${GREEN}✓ Labels created${NC}"
    fi
fi

echo ""
echo "Happy coding with Claude! 🚀"
