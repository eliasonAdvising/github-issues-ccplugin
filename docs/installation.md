# Installation Guide

## Prerequisites

1. **GitHub CLI** - Install from https://cli.github.com/
2. **Claude Code** - Active subscription
3. **Git repository** - Connected to GitHub

## Verify Prerequisites

```bash
# Check GitHub CLI
gh --version

# Check authentication
gh auth status

# If not authenticated
gh auth login
```

## Installation Methods

### Global Installation (Recommended)

Available in all projects:

```bash
git clone https://github.com/ieliason/github-issues-claude-plugin.git
cd github-issues-claude-plugin
./install.sh --global
```

### Project-Specific Installation

Only available in one project:

```bash
cd your-project
git clone https://github.com/ieliason/github-issues-claude-plugin.git /tmp/gh-plugin
/tmp/gh-plugin/install.sh --local
rm -rf /tmp/gh-plugin
```

### Custom Location

```bash
./install.sh --project /path/to/your/project
```

## Post-Installation

### Create Labels (Optional)

During local install, you'll be prompted to create standard labels.

Or manually:

```bash
gh label create "claude-todo" --color "FBCA04" --description "Work on with Claude Code"
gh label create "in-progress" --color "FEF2C0" --description "Currently being worked on"
```

### Verify Installation

```bash
# Check plugin files exist
ls ~/.claude/plugins/github-issues/

# Test auth script
~/.claude/plugins/github-issues/skills/github-integration/scripts/check-auth.sh
```

## Uninstallation

```bash
./uninstall.sh
```

Or manually:

```bash
rm -rf ~/.claude/plugins/github-issues
rm -rf ./.claude/plugins/github-issues
```
