#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const PLUGIN_NAME = 'github-issues';
const packageDir = path.resolve(__dirname, '..');

// Detect if this is a global install
const isGlobal = process.env.npm_config_global === 'true' ||
                 !process.env.INIT_CWD ||
                 process.env.INIT_CWD === packageDir;

// Determine install location
const installPath = isGlobal
  ? path.join(process.env.HOME, '.claude', 'plugins', PLUGIN_NAME)
  : path.join(process.env.INIT_CWD, '.claude', 'plugins', PLUGIN_NAME);

console.log('');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
console.log('  GitHub Issues Plugin for Claude Code');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
console.log('');
console.log(`Installing ${isGlobal ? 'globally' : 'locally'} to: ${installPath}`);

// Create directory structure
fs.mkdirSync(installPath, { recursive: true });

// Copy plugin files
const filesToCopy = [
  'plugin.json',
  'README.md'
];

const dirsToCopy = [
  'skills',
  'agents',
  'commands',
  'data'
];

// Copy individual files
filesToCopy.forEach(file => {
  const src = path.join(packageDir, file);
  const dest = path.join(installPath, file);
  if (fs.existsSync(src)) {
    fs.copyFileSync(src, dest);
  }
});

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

dirsToCopy.forEach(dir => {
  const src = path.join(packageDir, dir);
  const dest = path.join(installPath, dir);
  if (fs.existsSync(src)) {
    copyDir(src, dest);
  }
});

// Make scripts executable
const scriptsDir = path.join(installPath, 'skills', 'github-integration', 'scripts');
if (fs.existsSync(scriptsDir)) {
  fs.readdirSync(scriptsDir).forEach(file => {
    if (file.endsWith('.sh')) {
      const scriptPath = path.join(scriptsDir, file);
      fs.chmodSync(scriptPath, '755');
    }
  });
}

console.log('');
console.log('✓ Plugin installed successfully!');
console.log('');
console.log('Usage in Claude Code:');
console.log('  /list-issues claude-todo');
console.log('  /work-issue 45');
console.log('  /close-issue 45');
console.log('');
