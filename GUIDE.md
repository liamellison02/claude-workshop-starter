# workshop guide

welcome! by the end of this workshop, you'll have a real project built with claude code, MCPs, subagents, and skills, AND it'll be deployed live, accessible by anyone!

**time:** ~2 hours of building
**what you need:** a laptop, a terminal, a github account, and the free $40 in claude credits

---

## table of contents

1. [before you begin](#1-before-you-begin)
2. [setup](#2-setup)
3. [mental model: what is all this stuff?](#3-mental-model-what-is-all-this-stuff)
4. [verify your environment](#4-verify-your-environment)
5. [pick your project](#5-pick-your-project)
6. [project A, personal portfolio site](#6-project-a--personal-portfolio-site)
7. [project B, browser automation price tracker](#7-project-b--browser-automation-price-tracker)
8. [using subagents](#8-using-subagents)
9. [deploying with the vercel MCP](#9-deploying-with-the-vercel-mcp)
10. [stretch goals](#10-stretch-goals)
11. [troubleshooting](#11-troubleshooting)

---

## 1. before you start

### redeem your credits

1. go to https://console.anthropic.com
2. sign in (or create an account, use the same email you gave us at check-in)
3. go to **Billing → Credits** and paste the code from your card
4. confirm the $40 balance shows up before moving on

### accounts you'll need

- **claude/anthropic console** (above), for claude code auth
- **github**: you'll push your project here and the github MCP will read from it
- **vercel**: free tier is fine, sign in using github at https://vercel.com
> note: if you don't sign into vercel using your github account, you'll need to make sure your github is linked to your vercel account before continuing. if this is you, follow the steps below:
> in vercel, click on your profile/account in the bottom left and then go to **Settings → Authentication** and click **'Connect'** next to github under the **'Sign-In Methods'** section.

---

## 2. setup

### step 1: clone the starter repo

```bash
git clone https://github.com/liamellison02/claude-workshop-starter.git
cd claude-workshop-starter
```

### step 2: run the setup script for your OS

pick the one that matches your machine:

**macOS (apple silicon, M1/M2/M3/M4):**
```bash
chmod 711 ./setup/mac-silicon.sh
./setup/mac-silicon.sh
```

**macOS (intel):**
```bash
chmod 711 ./setup/mac-intel.sh
./setup/mac-intel.sh
```

**linux:**
```bash
chmod 711 ./setup/linux.sh
./setup/linux.sh
```

**windows (powerShell, run as admin):**
```powershell
.\setup\windows.ps1
```

the script will install or verify:
- **node.js 20+** (via `nvm`)
- **pnpm**, our node package manager for the workshop
- **python 3.11+**
- **uv**, our python package manager for the workshop
- **claude code CLI**
- **github CLI (`gh`)**

### verify your installations

after the setup script finishes, confirm everything actually installed:

```bash
node -v          # should be v20.x.x or higher
pnpm -v          # should be 10.x.x
python --version # should be 3.11.x or higher
claude --version
```

if any of these fail or show the wrong version, re-run the setup script or install manually — see [troubleshooting](#11-troubleshooting).

> **why `pnpm` and `uv` specifically?** both are drop-in replacements for `npm` and `pip` that are dramatically faster and have better dependency resolution. the workshop uses them everywhere. If you normally use `npm` or `pip`, that's fine for your own projects, but please use `pnpm` and `uv` tonight so everyone's commands look the same.

### step 3: copy the env file

```bash
cp .env.example .env
```

(you'll fill this in as you go. don't worry about it yet.)

### step 4: authenticate

```bash
claude login
gh auth login
```

for `gh auth login`, pick **GitHub.com → HTTPS → Login with a web browser**.

---

## 3. mental model: what is all this stuff?

before you start building, spend 2 minutes on this. it'll save you 20 minutes later.

| thing | what it is | think of it as |
|---|---|---|
| **claude code** | the CLI tool running claude in your terminal, with access to your files and shell | the brain |
| **MCP** (Model Context Protocol) | a standard way for claude code to talk to external tools (vercel, github, browsers, docs, etc.) | hands, lets claude reach out into the world |
| **skill** | a scoped set of instructions + helper files claude loads when it detects a relevant task | a recipe card claude grabs when needed |
| **subagent** | a specialized claude instance you can delegate a task to, with its own prompt and tools | a teammate you hand work to |
| **plugin** | a package that bundles MCPs, skills, subagents, and commands together | a toolbox you install all at once |

**the key insight:** claude code alone is already good. claude code with the right MCPs and subagents for your task is several leagues above the former because it stops guessing and starts *looking things up* & *delegating appropriately*.

---

## 4. verify your environment

from the repo root:

```bash
claude
```

once claude code launches, run this in the claude code prompt:

```
/mcp
```

you should see these MCP servers listed as connected:

- `context7`, live library docs
- `github`, read/write github repos
- `vercel`, deploy and manage vercel projects
- `playwright`, browser automation (for project B)
- `magic`, magic UI components (for project A)

if any show as disconnected, see [troubleshooting](#11-troubleshooting).

also check the loaded subagents:

```
/agents
```

you should see: `ui-designer`, `code-reviewer`, `debugger`, `deploy-helper`, `docs-writer`.

and the skills:

```
/skills
```

you should see: `everything-claude-code-conventions` (and anything else we ship in `.claude/skills/`).

all good? great! now go ahead and pick a project.

---

## 5. pick your project

we have two projects tonight. pick the one that sounds more fun, there's no "right" one.

**project A, personal portfolio site**
a real developer portfolio you can put on your resume. heavy on UI, uses magic UI components, deployed to a custom vercel URL. easier, higher polish.

**project B, browser automation price tracker**
a tool that scrapes product prices from any URL, stores them, and shows a chart. uses playwright MCP to drive a real browser. harder, more impressive demo, and can modify to fit your own idea.

now jump to whichever one you picked.

---

## 6. project A, personal portfolio site

### what you're building

a single-page personal site with:
- hero section with your name, title, and a one-liner
- projects grid (3 cards minimum)
- about section
- contact links
- animated components from magic UI
- deployed to `your-name.vercel.app`

### MCPs and plugins active for this project

- `context7`, for next.js, tailwind, magic UI docs
- `github`, to push your repo
- `vercel`, to deploy
- `magic`, magic UI component library MCP
- `ui-designer` subagent, for focused styling work
- `everything-claude-code-conventions` skill, for consistent commit messages and code style

### step-by-step

**1. create the project folder**

```bash
cd projects/01-portfolio
```

open `PROMPT.md` in that folder. this is your starter prompt, read it, tweak it with your own info (name, interests, projects you want to feature), and keep it open.

**2. launch claude code in this folder**

```bash
claude
```

**3. paste the starter prompt**

copy the full contents of `PROMPT.md` into claude code. starter prompt looks roughly like this, customize before pasting:

```
Build a personal developer portfolio for [YOUR NAME], a [YOUR MAJOR] student at [YOUR SCHOOL].

Requirements:
- Next.js 15 with App Router and TypeScript
- Tailwind CSS
- Use Magic UI components via the magic MCP for animated elements
  (hero text animation, project card hover effects, animated background)
- Single page, sections: Hero, Projects (3 cards), About, Contact
- Dark mode by default, clean and minimal
- Use pnpm for all package management
- Before writing code, use context7 to fetch the latest Next.js 15 App Router docs
  and the latest Magic UI component list
- When you need UI design decisions, delegate to the ui-designer subagent
- Follow the commit conventions from the everything-claude-code-conventions skill

Project details to feature:
- Project 1: [describe]
- Project 2: [describe]
- Project 3: [describe]

About me: [2-3 sentences]

Contact: GitHub, LinkedIn, email

When done, initialize git, create a new GitHub repo via the github MCP,
push, and deploy to Vercel via the vercel MCP.
```

**4. work with claude, don't just watch**

as claude builds, review what it's doing.
when it asks for confirmation, actually read the diff.
if you see something you don't like, say so, "make the hero font bigger," "I don't like that color, use a warmer tone," "the project cards should be in a 3-column grid on desktop."

**5. checkpoints to hit**

- [ ] `pnpm dev` runs locally and the site loads
- [ ] magic UI animations are visible on the hero
- [ ] all 3 project cards are populated with your real projects
- [ ] `ui-designer` subagent was invoked at least once
- [ ] pushed to a new github repo via the github MCP
- [ ] deployed to vercel via the vercel MCP
- [ ] live URL loads and looks good on mobile

skip to [section 9](#9-deploying-with-the-vercel-mcp) when you're ready to deploy.

---

## 7. project B, browser automation price tracker

### what you're building

a web app where you paste a product URL, the backend uses playwright (driven by claude code via the playwright MCP during development, and by a python script at runtime) to scrape the price, store it, and display a chart of price history over time.

### MCPs and plugins active for this project

- `context7`, for fastapi, playwright, recharts docs
- `github`, to push your repo
- `vercel`, to deploy the frontend
- `playwright`, browser automation (this is the star of the show)
- `everything-claude-code-conventions` skill, for consistent commit messages

### architecture

```
Frontend (Next.js on Vercel)
    ↓ HTTP
Backend API (FastAPI, Python, uv-managed)
    ↓ subprocess
Playwright scraper (Python, headless Chromium)
    ↓
SQLite (dev) / Postgres (prod)
```

for tonight we'll keep it simple: frontend on vercel, backend running locally, sqlite. you can harden it into a full production deploy as a stretch goal.

### step-by-step

**1. create the project folder**

```bash
cd projects/02-price-tracker
```

open `PROMPT.md` and read it.

**2. launch claude code**

```bash
claude
```

**3. starter prompt**

roughly:

```
Build a price tracker web app.

Stack:
- Frontend: Next.js 15 + TypeScript + Tailwind + Recharts, deployed to Vercel
- Backend: FastAPI (Python 3.11+), managed with uv
- Scraper: Playwright (Python), headless Chromium
- Storage: SQLite for dev

Features:
- User pastes a product URL (support at least: Amazon, Best Buy, generic og:price meta)
- Backend kicks off a Playwright scrape, extracts price + title + image
- Store in SQLite with a timestamp
- Frontend shows a list of tracked items and a line chart of price history per item
- "Refresh now" button re-scrapes on demand
- Manual "refresh all" endpoint (no cron needed tonight)

Workflow:
- Use uv for all Python deps: `uv init`, `uv add fastapi playwright ...`
- Use pnpm for all Node deps
- Use context7 to look up docs for every library BEFORE writing any backend code: FastAPI, aiosqlite, Playwright,
  and any other dependency you add. Don't rely on Claude's memory for API shapes or usage patterns, it will guess and get it wrong.
- Use the playwright MCP to interactively test selectors on real pages during development
- When debugging failed scrapes, delegate to the debugger subagent
- Follow commit conventions from the everything-claude-code-conventions skill

When done, push to a new GitHub repo via the github MCP, deploy the frontend to
Vercel via the vercel MCP, and print clear instructions for running the backend locally.
```

**4. the playwright MCP is your secret weapon**

instead of writing a selector and running your script 15 times, ask claude something like: "Use the playwright MCP to open amazon.com/dp/B08N5WRWNW, find the price element, and tell me the most stable selector." claude will actually drive a real browser, inspect the DOM, and come back with a working answer. this alone is worth the entire workshop.

**5. checkpoints to hit**

- [ ] `uv run uvicorn app.main:app --reload` starts the backend
- [ ] `pnpm dev` starts the frontend
- [ ] you can paste a URL and see a scrape succeed
- [ ] price history chart renders for at least one item
- [ ] `debugger` subagent was invoked at least once
- [ ] pushed to a new github repo via the github MCP
- [ ] frontend deployed to vercel via the vercel MCP

---

## 8. using subagents

subagents live in `.claude/agents/`. you have five pre-loaded:

| subagent | when to use it |
|---|---|
| `ui-designer` | "make this look better," color/layout/spacing decisions, picking components |
| `code-reviewer` | "review my last 10 commits," catching issues before push |
| `debugger` | a test is failing, a scraper broke, a stack trace you don't understand |
| `deploy-helper` | vercel build errors, env var problems, domain setup |
| `docs-writer` | writing your README, inline comments, API docs |

**how to invoke one:**

in claude code, just ask:
> "Use the debugger subagent to figure out why the Playwright scrape times out on bestbuy.com."

or explicitly:
> "Delegate this to the code-reviewer subagent: review the last commit and flag any issues."

**why bother with subagents instead of just asking claude directly?** two reasons: (1) each subagent has a focused system prompt so it doesn't get distracted by everything else in your session, and (2) it keeps your main conversation context clean for the high-level build.

---

## 9. deploying with the vercel MCP

the workflow is roughly:

1. make sure your project is pushed to github (use the `github` MCP, just tell claude to create the repo and push)
2. tell claude: "Use the vercel MCP to create a new vercel project from my github repo `<username>/<reponame>`, deploy it, and give me the production URL"
3. if there are build errors, delegate to the `deploy-helper` subagent
4. once it's live, open the URL on your phone to check mobile

for project B, you're only deploying the **frontend** to vercel. the backend stays local tonight.

---

## 10. stretch goals

finished early? pick one:

- **claude swarm**, spin up multiple agents working in parallel on different parts of your project. great for "build the API and the frontend at the same time" workflows.
- **superpowers plugin**, adds a pile of extra skills and commands. install it and explore what it gives you.
- **add a second MCP**, try adding the context7 upstash or a weather/stocks MCP and integrate it into your project
- **polish pass**, delegate to `ui-designer` for a full aesthetic review
- **README pass**, delegate to `docs-writer` for a beautiful README with badges, screenshots, and a demo GIF
- **custom subagent**, write your own subagent in `.claude/agents/my-agent.md` and invoke it

---

## 11. troubleshooting

**`claude` command not found after setup**
restart your terminal. if still broken, check that `~/.local/bin` (or the equivalent) is in your `PATH`.

**MCPs show as disconnected in `/mcp`**
run `claude mcp list` from the repo root. look at `.mcp.json`, make sure you're running `claude` from the repo root, not a parent directory. MCP configs are per-directory.

**github MCP can't authenticate**
run `gh auth status`. if not logged in, `gh auth login`. the github MCP reads from the `gh` CLI credentials.

**vercel MCP can't deploy**
make sure you've signed into vercel.com at least once in a browser. the MCP will walk you through a device-code auth flow on first use.

**playwright says "browser not installed"**
run `uv run playwright install chromium` from your project folder.

**`pnpm` or `uv` not found**
re-run the setup script for your OS. if that fails, install manually:
- pnpm: https://pnpm.io/installation
- uv: https://docs.astral.sh/uv/getting-started/installation/

**i'm completely stuck**
raise your hand. we will have floaters to come help you.

---

good luck. try to build something you'd actually want to show your friends.
