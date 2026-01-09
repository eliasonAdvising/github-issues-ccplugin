#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const packageDir = path.resolve(__dirname, '..');

// Detect if this is a global install
const isGlobal = process.env.npm_config_global === 'true' ||
                 !process.env.INIT_CWD ||
                 process.env.INIT_CWD === packageDir;

// Determine base .claude directory
const claudeDir = isGlobal
  ? path.join(process.env.HOME, '.claude')
  : path.join(process.env.INIT_CWD, '.claude');

console.log('');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
console.log('  GitHub Issues Plugin for Claude Code');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
console.log('');
console.log(`Installing ${isGlobal ? 'globally' : 'locally'} to: ${claudeDir}`);

// Copy directories recursively
function copyDir(src, dest) {
  fs.mkdirSync(dest, { recursive: true });
  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

// Install commands to .claude/commands/
const commandsSrc = path.join(packageDir, 'commands');
const commandsDest = path.join(claudeDir, 'commands');
if (fs.existsSync(commandsSrc)) {
  fs.mkdirSync(commandsDest, { recursive: true });
  fs.readdirSync(commandsSrc).forEach(file => {
    fs.copyFileSync(
      path.join(commandsSrc, file),
      path.join(commandsDest, file)
    );
  });
  console.log('✓ Commands installed to .claude/commands/');
}

// Install skills to .claude/skills/
const skillsSrc = path.join(packageDir, 'skills');
const skillsDest = path.join(claudeDir, 'skills');
if (fs.existsSync(skillsSrc)) {
  copyDir(skillsSrc, skillsDest);
  console.log('✓ Skills installed to .claude/skills/');
}

// Install agents to .claude/agents/
const agentsSrc = path.join(packageDir, 'agents');
const agentsDest = path.join(claudeDir, 'agents');
if (fs.existsSync(agentsSrc)) {
  fs.mkdirSync(agentsDest, { recursive: true });
  fs.readdirSync(agentsSrc).forEach(file => {
    fs.copyFileSync(
      path.join(agentsSrc, file),
      path.join(agentsDest, file)
    );
  });
  console.log('✓ Agents installed to .claude/agents/');
}

// Install data to .claude/data/
const dataSrc = path.join(packageDir, 'data');
const dataDest = path.join(claudeDir, 'data');
if (fs.existsSync(dataSrc)) {
  fs.mkdirSync(dataDest, { recursive: true });
  fs.readdirSync(dataSrc).forEach(file => {
    fs.copyFileSync(
      path.join(dataSrc, file),
      path.join(dataDest, file)
    );
  });
  console.log('✓ Data installed to .claude/data/');
}

// Make scripts executable
const scriptsDir = path.join(skillsDest, 'github-integration', 'scripts');
if (fs.existsSync(scriptsDir)) {
  fs.readdirSync(scriptsDir).forEach(file => {
    if (file.endsWith('.sh')) {
      const scriptPath = path.join(scriptsDir, file);
      fs.chmodSync(scriptPath, '755');
    }
  });
  console.log('✓ Scripts made executable');
}

console.log('');
console.log('✓ Plugin installed successfully!');
console.log('');
console.log('Usage in Claude Code:');
console.log('  /list-issues claude-todo');
console.log('  /work-issue 45');
console.log('  /close-issue 45');
console.log('');
