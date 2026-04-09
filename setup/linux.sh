#!/usr/bin/env bash
# claude workshop setup, linux (debian/ubuntu primary, fedora/arch best-effort)
set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log() { echo -e "${BLUE}==>${NC} $1"; }
ok() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }

log "Claude Workshop setup, Linux"

# detect package manager
if command -v apt-get >/dev/null 2>&1; then
  PKG="apt"
elif command -v dnf >/dev/null 2>&1; then
  PKG="dnf"
elif command -v pacman >/dev/null 2>&1; then
  PKG="pacman"
else
  warn "Unknown package manager, you may need to install system deps manually"
  PKG="unknown"
fi
ok "Detected package manager: $PKG"

install_pkg() {
  case "$PKG" in
  apt) sudo apt-get update && sudo apt-get install -y "$@" ;;
  dnf) sudo dnf install -y "$@" ;;
  pacman) sudo pacman -Sy --noconfirm "$@" ;;
  esac
}

# base build tools + curl + git
install_pkg curl git build-essential 2>/dev/null || install_pkg curl git 2>/dev/null || true

# node via nvm
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

# python
if ! command -v python3 >/dev/null 2>&1; then install_pkg python3 python3-venv; fi
ok "Python $(python3 --version | cut -d' ' -f2)"

# uv
if ! command -v uv >/dev/null 2>&1; then
  log "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
ok "uv $(uv --version | cut -d' ' -f2)"

# claude code
command -v claude >/dev/null 2>&1 || npm install -g @anthropic-ai/claude-code
ok "Claude Code installed"

# github CLI
if ! command -v gh >/dev/null 2>&1; then
  case "$PKG" in
  apt)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update && sudo apt-get install -y gh
    ;;
  dnf) sudo dnf install -y gh ;;
  pacman) sudo pacman -Sy --noconfirm github-cli ;;
  esac
fi
ok "GitHub CLI installed"

# playwright system deps (Linux needs extra libs)
log "Pre-installing Playwright Chromium + system deps..."
npx -y playwright install --with-deps chromium >/dev/null 2>&1 || warn "Playwright install deferred"

[ -f .env ] || cp .env.example .env

echo
ok "Setup complete!"
echo
echo "Next steps:"
echo "  1. gh auth login"
echo "  2. claude login"
echo "  3. claude  (then /mcp to verify)"
echo "  4. Follow GUIDE.md"
