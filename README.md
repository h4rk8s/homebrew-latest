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

## Auto-refresh (brew services, preferred)

```bash
brew install h4rk8s/latest/homebrew-latest-refresh
brew services start h4rk8s/latest/homebrew-latest-refresh
```

Shows up in `brew services ls`, runs daily, checks for new versions, updates cask files, pushes to GitHub, and runs `brew upgrade`.

Stop it with:

```bash
brew services stop h4rk8s/latest/homebrew-latest-refresh
```

## Auto-refresh (legacy launchd plist)

```bash
cp dev.h4rk8s.homebrew-latest-refresh.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/dev.h4rk8s.homebrew-latest-refresh.plist
launchctl kickstart -k gui/$(id -u)/dev.h4rk8s.homebrew-latest-refresh
```

Do not run the legacy plist and the `brew services` service at the same time.

## Manual refresh

```bash
$(brew --repo h4rk8s/latest)/bin/refresh
```
