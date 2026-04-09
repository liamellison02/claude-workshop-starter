# troubleshooting

common problems from past workshops, in rough order of frequency.

## setup issues

### `claude: command not found` after running the setup script

**cause:** your shell's `PATH` wasn't reloaded.

**fix:**
```bash
# mac/linux
source ~/.zshrc   # or ~/.bashrc
# or just close and reopen your terminal

# windows
# close and reopen PowerShell
```

if still broken:
```bash
# check where claude was installed
npm root -g
# add that bin dir to your PATH manually
```

### `pnpm: command not found`

you skipped or broke the pnpm install step. manually:
```bash
npm install -g pnpm
```

### `uv: command not found`

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
# then reload your shell
```

windows:
```powershell
irm https://astral.sh/uv/install.ps1 | iex
```

### setup script fails on homebrew install (mac)

run it manually first, then re-run the setup script:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### `nvm: command not found` after install

`nvm` is shell-scoped, it gets added to `~/.zshrc` or `~/.bashrc`. close and reopen your terminal, or:
```bash
source ~/.nvm/nvm.sh
```

### windows: "script cannot be loaded because running scripts is disabled"

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
then re-run the setup script.

---

## MCP issues

### `/mcp` shows servers as disconnected

**most common cause:** you're running `claude` from the wrong directory. `.mcp.json` is per-directory. make sure you're in the repo root:

```bash
cd claude-workshop-starter
claude
```

then inside claude code:
```
/mcp
```

### `claude mcp list` shows nothing

same fix, run it from the repo root.

### github MCP: "authentication failed"

the github MCP uses the `gh` CLI's credentials. check:
```bash
gh auth status
```

if not logged in:
```bash
gh auth login
# pick: GitHub.com → HTTPS → Login with web browser
```

alternatively, set a personal access token in `.env`:
```
GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```
get one at https://github.com/settings/tokens (classic, with `repo` scope).

### vercel MCP: "not authenticated"

first time you use it, the MCP walks you through a device-code auth flow. you'll get a URL to open in your browser. make sure you're logged into vercel.com in that browser first.

### playwright MCP: "browser not installed" or "executable doesn't exist"

```bash
npx -y playwright install chromium
```

on linux you may also need system deps:
```bash
npx -y playwright install --with-deps chromium
```

### magic MCP: doesn't return any components

make sure you're actually asking claude to use it. try:
> "Use the magic MCP to list available hero section components."

if that still doesn't work, check `claude mcp list`, if `magic` isn't there, your `.mcp.json` didn't load (you're in the wrong directory).

---

## project A, portfolio

### `pnpm dev` fails with "Cannot find module"

```bash
rm -rf node_modules .next
pnpm install
pnpm dev
```

### vercel build fails with "Module not found" but it works locally

almost always a case-sensitivity issue. macOS is case-insensitive, linux (vercel's build env) isn't.

**check:**
```bash
# this import:
import Button from './components/button'
# won't match this file:
components/Button.tsx
```

fix the import or rename the file so cases match.

### magic UI components look broken / unstyled

make sure tailwind is actually processing the magic UI files. check your `tailwind.config.ts`:
```ts
content: [
  "./src/**/*.{ts,tsx}",
  "./node_modules/@magicuidesign/**/*.{ts,tsx}",  // <-- this line
],
```

---

## project B, price tracker

### `uv run` fails with "no virtual environment found"

from the backend folder:
```bash
uv sync
# then
uv run uvicorn app.main:app --reload
```

### playwright scrape times out

**step 1:** use the `playwright` MCP to open the same URL interactively and see what's actually rendered. you're probably hitting a CAPTCHA page, not your target page.

**step 2:** if it IS the right page, your selector is wrong. ask claude:
> "Use the playwright MCP to open [url] and tell me the most stable CSS selector for the product price."

**step 3:** Amazon, Walmart, and Best Buy have aggressive bot detection. for the workshop, try a smaller site or use the og-meta fallback.

### CORS error from the frontend calling the backend

add CORS middleware to fastapi:
```python
from fastapi.middleware.cors import CORSMiddleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### sqlite "database is locked"

you have two processes writing at once. stop one of them. for the workshop, a single uvicorn process is enough.

---

## claude code issues

### "rate limit exceeded" or "insufficient credits"

check your balance at https://console.anthropic.com → Billing. if you're at $0, the credits from check-in haven't been applied yet, grab a floater.

### subagents aren't loading

```
/agents
```
should list all 5. if empty, check that `.claude/agents/*.md` files exist in your current directory. they're per-directory, just like MCPs.

### skills aren't loading

```
/skills
```
should list `everything-claude-code-conventions`. if not, the skill file is missing from `.claude/skills/`, re-clone the repo or copy the file back.

### claude code is just… slow

first response in a session builds context and is always slower. subsequent responses should be faster. if it's stuck for 2+ minutes, Ctrl+C and try a smaller prompt.

---

## deploy issues

### vercel build succeeds but the site is blank

open DevTools → Console on the deployed URL. you're probably hitting a client-side error. common culprits:
- env var that's set locally but not on vercel
- an API route that works locally but not in production
- hardcoded `localhost:3000` somewhere

### vercel deploy works, domain shows "DEPLOYMENT_NOT_FOUND"

wait 30 seconds. vercel's edge network takes a moment to propagate.

### can't find the live URL

```
# tell claude:
> Use the vercel MCP to list my projects and show me the production URL for <project-name>.
```

---

## still stuck?

**raise your hand.** that's what the floaters are for. seriously, don't burn 20 minutes on a setup issue when someone can fix it in 2.

after the workshop, drop it in the discord and we'll get back to you.
