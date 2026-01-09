#!/bin/bash
# Quick repository setup script

echo "🚀 GitHub Issues Plugin - Repository Setup"
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Make install scripts executable
chmod +x install.sh
chmod +x uninstall.sh

# Make all skill scripts executable
chmod +x skills/github-integration/scripts/*.sh

# Initialize git if not already
if [ ! -d ".git" ]; then
    git init
    echo "✓ Git initialized"
fi

# Create .gitignore if needed
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'EOF'
node_modules/
*.log
.DS_Store
EOF
    echo "✓ Created .gitignore"
fi

# Show next steps
echo ""
echo "✅ Repository setup complete!"
echo ""
echo "Next steps:"
echo "1. Create GitHub repo:"
echo "   gh repo create github-issues-claude-plugin --public --source=. --push"
echo ""
echo "2. Test installation:"
echo "   ./install.sh --local"
echo ""
echo "3. Or install globally:"
echo "   ./install.sh --global"
