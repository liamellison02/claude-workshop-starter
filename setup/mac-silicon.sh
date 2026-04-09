#!/usr/bin/env bash
# claude workshop setup, macOS apple silicon (M1/M2/M3/M4)
set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
log() { echo -e "${BLUE}==>${NC} $1"; }
ok() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err() { echo -e "${RED}✗${NC} $1" >&2; }

BREW_PREFIX="/opt/homebrew"
export PATH="$BREW_PREFIX/bin:$PATH"

log "Claude Workshop setup, macOS Apple Silicon"

# homebrew
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$($BREW_PREFIX/bin/brew shellenv)"
fi
ok "Homebrew ready"

# node via nvm
if ! command -v nvm >/dev/null 2>&1 && [ ! -d "$HOME/.nvm" ]; then
  log "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if ! command -v node >/dev/null 2>&1 || [ "$(node -v | cut -d. -f1 | tr -d v)" -lt 20 ]; then
  log "Installing Node.js 20..."
  nvm install 20
  nvm use 20
fi
ok "Node $(node -v)"

# pnpm
if ! command -v pnpm >/dev/null 2>&1; then
  log "Installing pnpm..."
  npm install -g pnpm
fi
ok "pnpm $(pnpm -v)"

# python + uv
if ! command -v python3 >/dev/null 2>&1; then
  brew install python@3.12
fi
ok "Python $(python3 --version | cut -d' ' -f2)"

if ! command -v uv >/dev/null 2>&1; then
  log "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
ok "uv $(uv --version | cut -d' ' -f2)"

# claude code
if ! command -v claude >/dev/null 2>&1; then
  log "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
fi
ok "Claude Code installed"

# github CLI
if ! command -v gh >/dev/null 2>&1; then
  log "Installing GitHub CLI..."
  brew install gh
fi
ok "GitHub CLI $(gh --version | head -1 | cut -d' ' -f3)"

# playwright browsers (for project B)
log "Pre-installing Playwright Chromium (for Project B)..."
npx -y playwright install chromium >/dev/null 2>&1 || warn "Playwright install deferred, run later if you pick Project B"

# .env
if [ ! -f .env ]; then
  cp .env.example .env
  ok "Created .env from .env.example"
fi

echo
ok "Setup complete!"
echo
echo "Next steps:"
echo "  1. Run: gh auth login"
echo "  2. Run: claude login"
echo "  3. From the repo root, run: claude"
echo "  4. Inside Claude Code, run: /mcp  (verify all 5 servers are connected)"
echo "  5. Follow GUIDE.md to pick and build your project"
