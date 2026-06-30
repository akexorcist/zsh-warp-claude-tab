# zsh-warp-claude-tab

A zsh plugin and Claude Code agent skill to open a new [Warp](https://www.warp.dev/) terminal tab with a pre-loaded Claude Code session — ideal for handing off tasks between sessions without copy-pasting.

Uses Warp's `warp://tab_config` URI scheme.

## Prerequisites

- [Warp](https://www.warp.dev/) terminal
- [Claude Code](https://claude.ai/code)

---

## Installation

### 1. zsh Plugin

**oh-my-zsh**

```bash
git clone https://github.com/akexorcist/zsh-warp-claude-tab \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-warp-claude-tab
```

Then add `zsh-warp-claude-tab` to the plugins list in `~/.zshrc`:

```zsh
plugins=(... zsh-warp-claude-tab)
```

**zinit**

```zsh
zinit light akexorcist/zsh-warp-claude-tab
```

**antigen**

```zsh
antigen bundle akexorcist/zsh-warp-claude-tab
```

**zplug**

```zsh
zplug "akexorcist/zsh-warp-claude-tab"
```

**Manual**

```bash
source /path/to/zsh-warp-claude-tab.plugin.zsh
```

---

### 2. Claude Code Agent Skill

```bash
npx zsh-warp-claude-tab
```

This installs the skill to `~/.claude/skills/new-claude-tab/SKILL.md`, making it available to any Claude Code agent as `/new-claude-tab`.

---

## Usage

```bash
new-claude-tab                                   # plain new session
new-claude-tab handoff.md                        # file as first message
new-claude-tab handoff.md "extra instruction"    # file + prompt
new-claude-tab "" "just a quick task"            # prompt only
```

The new session starts in the same working directory. The hand-off file is deleted automatically after being read.

### Hand-off file format

```markdown
## Context
<what has been done and why>

## Task
<what the new session must do>

## Key files
- path/to/file
```

---

## License

Apache License 2.0 — see [LICENSE](LICENSE) for details.

---

## How it works

1. Writes the prompt/file content to a temp file
2. Generates a Warp Tab Config TOML in `~/.warp/tab_configs/`
3. Opens it via `open "warp://tab_config/<name>"` — Warp opens a new tab and runs Claude natively
4. Deletes the TOML from the calling tab after 2 seconds
5. The message temp file is deleted after being read by the new session
