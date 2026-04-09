#!/usr/bin/env bash
# claude workshop setup, macOS intel
set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log() { echo -e "${BLUE}==>${NC} $1"; }
ok() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }

BREW_PREFIX="/usr/local"
export PATH="$BREW_PREFIX/bin:$PATH"

log "Claude Workshop setup, macOS Intel"

if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$($BREW_PREFIX/bin/brew shellenv)"
fi
ok "Homebrew ready"

if [ ! -d "$HOME/.nvm" ]; then
  log "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if ! command -v node >/dev/null 2>&1 || [ "$(node -v | cut -d. -f1 | tr -d v)" -lt 20 ]; then
  log "Installing Node.js 20..."
  nvm install 20 && nvm use 20
fi
ok "Node $(node -v)"

command -v pnpm >/dev/null 2>&1 || npm install -g pnpm
ok "pnpm $(pnpm -v)"

command -v python3 >/dev/null 2>&1 || brew install python@3.12
ok "Python $(python3 --version | cut -d' ' -f2)"

if ! command -v uv >/dev/null 2>&1; then
  log "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
ok "uv $(uv --version | cut -d' ' -f2)"

command -v claude >/dev/null 2>&1 || npm install -g @anthropic-ai/claude-code
ok "Claude Code installed"

command -v gh >/dev/null 2>&1 || brew install gh
ok "GitHub CLI installed"

log "Pre-installing Playwright Chromium..."
npx -y playwright install chromium >/dev/null 2>&1 || warn "Playwright install deferred"

[ -f .env ] || cp .env.example .env

echo
ok "Setup complete!"
echo
echo "Next steps:"
echo "  1. gh auth login"
echo "  2. claude login"
echo "  3. claude  (then /mcp to verify)"
echo "  4. Follow GUIDE.md"
