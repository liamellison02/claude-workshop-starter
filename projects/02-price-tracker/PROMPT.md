# project B, browser automation price tracker

**difficulty:** medium to hard
**estimated time:** 75–90 minutes
**stack:** next.js frontend + fastapi backend + playwright scraper + sqlite

## what you're building

a tool where you paste a product URL, a headless browser scrapes the price, and you get a chart of price history for every item you're tracking. the `playwright` MCP lets you use a real browser interactively during development to find the right selectors without a million trial-and-error runs.

## before you paste the prompt

1. make sure you're in this folder: `projects/02-price-tracker`
2. launch claude code: `claude`
3. have 1-2 real product URLs ready (Amazon, Best Buy, or anything with a visible price) for testing

## your starter prompt

copy everything between the triple-dashes into claude code:

---

Build a price tracker web application with a next.js frontend and a python backend.

**architecture:**
- **frontend:** next.js 15 + typescript + tailwind + recharts, deployed to vercel
- **backend:** fastapi (python 3.11+), managed with `uv`
- **scraper:** playwright for python, headless chromium
- **storage:** sqlite (local file, no cloud DB tonight)
- **package managers:** `uv` for python, `pnpm` for node. do not use `pip` or `npm`.

**repo layout:**
```
.
├── frontend/          # next.js app
├── backend/           # fastapi + scraper + sqlite
│   ├── app/
│   │   ├── main.py
│   │   ├── db.py
│   │   └── scraper.py
│   └── pyproject.toml
└── README.md
```

**backend features:**
- `POST /items`, body: `{ "url": "..." }`, triggers a scrape, stores `{id, url, title, image_url, created_at}` and the first price point
- `GET /items`, returns all tracked items with their latest price
- `GET /items/{id}/history`, returns the full price history for charting
- `POST /items/{id}/refresh`, re-scrapes and appends a new price point
- `POST /refresh-all`, re-scrapes all items

**scraper logic:**
- use playwright headless chromium
- try these strategies in order for price extraction:
  1. site-specific selectors for Amazon and Best Buy (look them up using the `playwright` MCP interactively, do not guess)
  2. fallback: `og:price:amount` or `product:price:amount` meta tags
  3. fallback: any element matching a currency regex near a heading
- also extract the page title and the main product image URL
- handle failures gracefully, return a clear error, don't crash

**frontend features:**
- input box at the top: paste a URL, click "Track"
- list of tracked items below, each showing image, title, current price, and a sparkline
- click an item to expand it into a full line chart using recharts
- "Refresh" button per item and a "Refresh all" button at the top
- loading states while scrapes run
- point it at `http://localhost:8000` for the backend (configurable via env var)

**workflow requirements:**
- before writing scraper code, use the `context7` MCP to fetch the current playwright python API docs and fastapi async docs
- **use the `playwright` MCP interactively during development** to open real product pages, inspect the DOM, and find stable selectors. this is the most important part, do not guess selectors from memory.
- when a scrape fails, delegate to the `debugger` subagent with the error and the target URL
- follow commit conventions from the `everything-claude-code-conventions` skill (conventional commits)

**deployment:**
- only the **frontend** is deployed tonight. use the `github` MCP to create a new public repo and push everything. use the `vercel` MCP to deploy just the `frontend/` directory (set the root directory in the vercel project settings).
- the backend runs locally via `uv run uvicorn app.main:app --reload --app-dir backend`
- print a clear README with instructions for running both halves locally

**test it with these URLs when the build is done:**
1. `[YOUR TEST URL 1]`
2. `[YOUR TEST URL 2]`

---

## tips while building

- **the `playwright` MCP is the star of this project.** use it like this: "Use the playwright MCP to open [url], find the element that contains the price, and tell me the most specific and stable CSS selector." you'll save 30+ minutes.
- **Amazon and Best Buy have bot detection.** if you hit a CAPTCHA page, that's the real error, not a selector issue. ask the `debugger` subagent to help you detect and handle it.
- **don't over-engineer the DB.** a single `items` table + a `price_history` table is enough.
- **`uv add fastapi[standard] playwright recharts ...`**, use `uv add` to install python packages, never `pip install`.

## done checklist

- [ ] backend runs via `uv run uvicorn app.main:app --reload --app-dir backend`
- [ ] frontend runs via `pnpm dev` in `frontend/`
- [ ] you can paste a URL and see a successful scrape with price + title + image
- [ ] at least one item has 2+ price points so the chart has something to draw
- [ ] `playwright` MCP was used interactively at least once during development
- [ ] `debugger` subagent was invoked at least once
- [ ] pushed to github via the `github` MCP
- [ ] frontend deployed to vercel via the `vercel` MCP
- [ ] README has clear "how to run locally" instructions
