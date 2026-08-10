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

Shows up in `brew services ls`, checks for new versions on its configured
interval, validates Codex package assets and checksums, updates cask files, and
pushes to GitHub. Local upgrades remain opt-in with `--upgrade`.

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
$(brew --repo h4rk8s/latest)/bin/refresh --check
$(brew --repo h4rk8s/latest)/bin/refresh
$(brew --repo h4rk8s/latest)/bin/refresh --upgrade
```

`--check` is read-only. It verifies that the cask matches the latest stable
release and validates both macOS Codex packages, including their layouts,
checksums, architectures, OpenAI signatures, and helper binaries. Native
executables are also smoke-tested, without committing, pushing, or upgrading
anything.
