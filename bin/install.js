#!/usr/bin/env node

const fs = require('fs')
const path = require('path')
const os = require('os')

const skillDir = path.join(os.homedir(), '.claude', 'skills', 'new-claude-tab')
const skillDest = path.join(skillDir, 'SKILL.md')
const skillSrc = path.join(__dirname, '..', 'skill', 'SKILL.md')

fs.mkdirSync(skillDir, { recursive: true })
fs.copyFileSync(skillSrc, skillDest)
console.log(`✓ Claude Code skill installed → ${skillDest}`)
