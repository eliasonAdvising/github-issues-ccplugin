# Contributing

## Development Setup

```bash
git clone https://github.com/ieliason/github-issues-claude-plugin.git
cd github-issues-claude-plugin
./setup-repo.sh
```

## Guidelines

### Scripts

- Return JSON for programmatic use
- Use consistent exit codes (0=success, 1=error, 2=auth, 3=not found)
- Keep scripts deterministic (same input = same output)
- No interactive prompts

### Token Optimization

- Skills: 100-300 lines
- Agents: ~60 lines
- Commands: ~50 lines
- Push logic to scripts (0 tokens)

### Testing

```bash
# Test auth
./skills/github-integration/scripts/check-auth.sh

# Test repo access
./skills/github-integration/scripts/check-repo.sh

# Test list issues
./skills/github-integration/scripts/list-issues.sh --limit 5
```

## Pull Requests

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test locally
5. Submit PR

## Code of Conduct

Be respectful and constructive.
