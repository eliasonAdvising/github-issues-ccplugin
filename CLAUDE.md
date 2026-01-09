# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Claude Code plugin for GitHub Issues workflow integration. It uses **zero-token scripts** - all GitHub operations are handled by bash scripts that return JSON, consuming no context tokens when executed.

## Commands

```bash
# Install plugin
./install.sh --global          # All projects
./install.sh --local           # Current project only

# Uninstall
./uninstall.sh

# Test scripts directly
./skills/github-integration/scripts/check-auth.sh
./skills/github-integration/scripts/list-issues.sh --label claude-todo
```

## Architecture

**Token Optimization Strategy:** Push all deterministic work to scripts (0 tokens), keep markdown files minimal.

### Component Hierarchy

```
plugin.json          → Plugin manifest, defines components
├── skills/          → Procedures (~250 tokens max)
├── agents/          → Orchestration (~60 tokens max)
├── commands/        → User-facing (~50 tokens max)
└── data/            → YAML configs (referenced, not loaded)
```

### Scripts (Zero-Token Layer)

All scripts in `skills/github-integration/scripts/` must:
- Return JSON output for programmatic use
- Use exit codes: 0=success, 1=error, 2=auth, 3=not found, 4=permission denied
- Be deterministic (same input = same output)
- Never require interactive input

### Workflow State Machine

Issue label transitions are defined in `data/workflow-states.yaml`:
- `claude-todo` → `in-progress` (start_work)
- `in-progress` → `needs-review` (complete_work)
- `in-progress` → `blocked` (block_issue)

## Line Count Limits

From `data/thresholds.yaml`:
- Skills: 100-300 lines (target ~250)
- Agents: ~60 lines
- Commands: ~50 lines
- CLAUDE.md: 60-300 lines

## Key Principle

**Always use provided scripts instead of direct `gh` commands.** The scripts are designed for consistent JSON output and proper error handling.

```bash
# CORRECT
./skills/github-integration/scripts/list-issues.sh

# WRONG
gh issue list
```
