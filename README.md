# homebrew-latest

Homebrew tap tracking **latest** releases of CLI tools.

## Casks

| Cask | Source | Channel |
|------|--------|---------|
| `claude-code` | npm `@anthropic-ai/claude-code` | `latest` tag |
| `codex` | GitHub `openai/codex` | latest release |

## Install

```bash
brew tap h4rk8s/latest
brew install h4rk8s/latest/claude-code
brew install h4rk8s/latest/codex
```

## Auto-refresh (launchd)

```bash
cp dev.h4rk8s.homebrew-latest-refresh.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/dev.h4rk8s.homebrew-latest-refresh.plist
```

Runs daily. Checks for new versions, updates cask files, pushes to GitHub, and runs `brew upgrade`.

## Manual refresh

```bash
$(brew --repo h4rk8s/latest)/bin/refresh
```
