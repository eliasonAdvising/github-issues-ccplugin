# GitHub Issues Plugin for Claude Code

Zero-token GitHub Issues workflow integration using deterministic scripts. Designed for manual issue management via GitHub web/mobile with Claude Code assistance for implementation.

## Features

- List and filter issues (0 tokens - script execution)
- Automated workflow transitions (0 tokens - script execution)
- Label management via YAML config
- Consistent formatting via templates
- PR creation with issue linking
- Token-optimized (460 token total budget)

## Philosophy

**Push work to deterministic layers:**
- Scripts: 100% reliable, 0 tokens (8 scripts included)
- Templates: Consistent output, 0 tokens
- YAML: Configuration, minimal tokens
- Skills: Procedures only, ~250 tokens
- Agents: Minimal orchestration, ~60 tokens

## Prerequisites

- **GitHub CLI**: `gh` installed and authenticated
- **Claude Code**: Subscription (no API key needed)
- **Git repository**: Connected to GitHub

## Installation

### Via npm (Recommended)

```bash
# Install globally (available in all projects)
npm install -g @eliason/github-issues-claude-plugin

# Or install locally in a project
cd your-project
npm install --save-dev @eliason/github-issues-claude-plugin
```

The plugin automatically installs to the correct Claude Code plugin directory.

### Via Git Clone

```bash
git clone https://github.com/ieliason/github-issues-claude-plugin.git
cd github-issues-claude-plugin
./install.sh --global    # or --local for current project
```

## Usage

### In GitHub (Web/Mobile)

1. **Create issues** with clear descriptions and acceptance criteria
2. **Label them**: Add `claude-todo` when ready to implement
3. **Manage manually**: Use GitHub interface for creation/triage

### In Claude Code

```bash
# Navigate to your project
cd your-project
claude

# List issues ready to work on
/list-issues claude-todo

# Start work on specific issue
/work-issue 45

# Claude implements based on acceptance criteria
# ...

# When complete
/close-issue 45
```

## Commands

### `/list-issues [label]`

List issues, optionally filtered by label.

```bash
/list-issues              # All open
/list-issues claude-todo  # Specific label
/list-issues bug          # All bugs
```

**Token cost:** ~30 (command only, script execution = 0)

### `/work-issue N`

Start work on issue #N with automated workflow:
1. Fetches issue details
2. Creates feature branch
3. Updates labels (claude-todo -> in-progress)
4. Adds comment to issue
5. Begins implementation

**Token cost:** ~30 (command only)

### `/close-issue N`

Complete issue work:
1. Commits changes
2. Creates PR
3. Updates labels (in-progress -> needs-review)

**Token cost:** ~30 (command only)

## Configuration

### Default Labels

Automatically created on install (optional):

**Types:** feature, bug, enhancement, documentation
**Workflow:** claude-todo, in-progress, needs-review, blocked
**Priority:** p0-critical, p1-high, p2-medium, p3-low

Customize in: `data/default-labels.yaml`

### Workflow States

Define label transitions during workflow changes.

Customize in: `data/workflow-states.yaml`

### Thresholds

Token budgets and size limits for optimization.

Reference: `data/thresholds.yaml`

## Token Budget

```
Total plugin budget: 460 tokens
├── Skills: 250 tokens (loaded on-demand)
├── Agents: 60 tokens (loaded when activated)
└── Commands: 150 tokens (loaded when invoked)

Scripts: 0 tokens (executed, never loaded into context)
Templates: 0 tokens (filled, never loaded)
YAML: Minimal (referenced, not duplicated)
```

## Project Structure

```
github-issues/
├── skills/github-integration/    # Core skill (~250 tokens)
│   ├── SKILL.md                  # Procedures
│   ├── scripts/                  # 8 scripts (0 tokens)
│   ├── templates/                # Output formats (0 tokens)
│   └── examples/                 # Usage examples
├── agents/                       # Issue manager (~60 tokens)
├── commands/                     # 3 commands (~50 tokens each)
└── data/                         # YAML configs
```

## Scripts Included

All scripts in `skills/github-integration/scripts/`:

- `check-auth.sh` - Verify GitHub authentication
- `check-repo.sh` - Verify repository access
- `list-issues.sh` - List/filter issues
- `get-issue.sh` - Get issue details
- `update-issue.sh` - Update issue labels
- `comment-issue.sh` - Add comments
- `create-pr.sh` - Create pull requests
- `bulk-update.sh` - Batch operations

**All scripts:**
- Return JSON for programmatic use
- Use proper exit codes (0=success, 1=error, 2=auth, 3=not found)
- Are deterministic (same input = same output)
- Cost zero tokens (executed, not loaded)

## Examples

### Daily Workflow

```bash
# Morning: Check what's ready
/list-issues claude-todo

# Pick issue and start
/work-issue 45

# Claude implements feature...

# Complete and create PR
/close-issue 45
```

### Custom Workflow

```bash
# In Claude Code
"Show me all high-priority bugs"
# Claude executes: scripts/list-issues.sh --label bug --label p1-high

"Let's work on the most critical one"
# Claude executes start-work workflow
```

## Troubleshooting

### Plugin Not Loading

```bash
# Verify installation
ls ~/.claude/plugins/github-issues
# or
ls ./.claude/plugins/github-issues

# Check permissions
ls -la ~/.claude/plugins/github-issues/skills/github-integration/scripts/
# All .sh files should be executable (rwxr-xr-x)
```

### GitHub CLI Issues

```bash
# Check authentication
gh auth status

# Re-authenticate if needed
gh auth login

# Check repo access
gh repo view
```

### Scripts Not Executing

```bash
# Make scripts executable
chmod +x ~/.claude/plugins/github-issues/skills/github-integration/scripts/*.sh
```

## Uninstall

```bash
# Remove plugin files, then uninstall npm package
gh-issues-uninstall
npm uninstall -g @eliason/github-issues-claude-plugin
```

## Contributing

This plugin is optimized for:
- Zero-token script execution
- Minimal context window usage
- Manual issue management workflow
- Claude Code subscription (no API keys)

Pull requests welcome for:
- Additional scripts (keep them deterministic)
- Template improvements
- Documentation enhancements
- Bug fixes

## License

MIT License - See LICENSE file

## Author

Ian Eliason

---

**Plugin Stats:**
- Total token budget: 460
- Scripts: 8 (0 tokens)
- Components: Optimized for <300 line limits
- Installation: <2 minutes
