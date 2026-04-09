# project B, browser automation price tracker

a full-stack price tracker. paste a product URL, headless chromium scrapes the price, sqlite stores history, and recharts draws the line. the `playwright` MCP lets claude drive a real browser during development to find the right selectors without guessing.

## difficulty
**medium to hard**, pick this if you want to see what MCP-driven browser automation actually feels like. it's the flashier demo.

## time
~75–90 minutes

## stack
- **frontend:** next.js 15 + typescript + tailwind + recharts (deployed to vercel)
- **backend:** fastapi (python 3.11+), managed with `uv`
- **scraper:** playwright for python, headless chromium
- **storage:** sqlite (local file)

## MCPs used
- `context7`, fastapi, playwright, recharts docs
- `github`, create the repo and push
- `vercel`, deploy the frontend
- `playwright`, **the star of the show**, drives a real browser during development

## subagents used
- `debugger`, for when a scrape fails or a selector breaks

## skills used
- `everything-claude-code-conventions`, consistent commit messages

## how to start
1. have 1–2 real product URLs ready for testing (avoid Amazon if possible, bot detection is rough)
2. launch claude code from this folder: `claude`
3. paste the prompt from [`PROMPT.md`](./PROMPT.md)
4. **use the `playwright` MCP interactively** to find selectors before writing scraper code

full walkthrough is in the root [`GUIDE.md`](../../GUIDE.md) → section 7.

## repo layout (after build)
```
.
├── frontend/          # next.js app
└── backend/           # fastapi + scraper + sqlite
    ├── app/
    │   ├── main.py
    │   ├── db.py
    │   └── scraper.py
    └── pyproject.toml
```

## running locally (after build)
```bash
# backend
cd backend
uv sync
uv run uvicorn app.main:app --reload

# frontend (new terminal)
cd frontend
pnpm install
pnpm dev
```

## deploy note
only the **frontend** is deployed to vercel tonight. the backend stays local. turning this into a fully production-deployed app is a stretch goal.

## when you're done
see the "done checklist" at the bottom of `PROMPT.md`.
