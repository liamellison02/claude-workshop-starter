---
name: everything-claude-code-conventions
description: Development conventions and patterns for projects built during the GSU Claude Code workshop. Teaches Claude to use conventional commits, consistent naming, and clean code style. Activate when committing, adding features, or reviewing code in workshop projects.
---

# everything claude code conventions

> vendored from [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) for the GSU programming club claude code workshop (April 27, 2026).

## overview

this skill teaches claude the development patterns and conventions used in everything-claude-code, adapted for the workshop projects (portfolio site and browser price tracker).

## when to use this skill

activate this skill when:

- making commits in a workshop project
- adding new features following established patterns
- writing tests that match project conventions
- creating commits with proper message format

## commit conventions

follow **conventional commits** format for all commits.

### prefixes

- `feat:`, a new feature
- `fix:`, a bug fix
- `docs:`, documentation only
- `style:`, formatting, missing semis, etc. (no code change)
- `refactor:`, code change that neither fixes a bug nor adds a feature
- `test:`, adding or updating tests
- `chore:`, tooling, deps, build config

### message guidelines

- keep the first line concise and descriptive (aim for ~65 chars)
- use **imperative mood**: "Add feature" not "Added feature"
- scope is optional but helpful: `feat(ui): add hero animation`

### examples

```
feat(portfolio): add hero section with magic UI sparkles
feat(scraper): support og:price meta fallback
fix: handle missing product image in scrape result
docs: add setup instructions for windows
chore(deps): bump next to 15.2.0
refactor(db): extract price history query to helper
test(scraper): add selector tests for Best Buy
```

### anti-examples (don't do these)

```
updated stuff              # vague, lowercase, no prefix
Fixed the bug              # past tense, vague, no prefix
WIP                        # not useful to anyone
feat: Added new feature    # past tense + prefix + still vague
```

## code style

### naming

| element | convention | example |
|---|---|---|
| files | `camelCase` (JS/TS) or `snake_case` (python) | `priceChart.tsx`, `scraper.py` |
| react components | `PascalCase` | `PriceChart`, `HeroSection` |
| functions | `camelCase` (JS/TS) or `snake_case` (python) | `fetchPrice`, `fetch_price` |
| classes | `PascalCase` | `PriceScraper` |
| constants | `SCREAMING_SNAKE_CASE` | `MAX_RETRIES`, `DEFAULT_TIMEOUT` |
| environment variables | `SCREAMING_SNAKE_CASE` | `DATABASE_URL` |

### import style

**typescript/javascript:** prefer relative imports within a package, absolute (`@/...`) imports across packages.

```ts
// within the same feature
import { Button } from '../components/Button'
import { useAuth } from './hooks/useAuth'

// across features (next.js @ alias)
import { db } from '@/lib/db'
```

**python:** absolute imports from the package root.

```python
from app.db import get_connection
from app.scraper import scrape_product
```

## error handling

### typescript/javascript

use try/catch around anything that can throw, log with context, rethrow with a user-friendly message if the error bubbles to the UI.

```ts
try {
  const result = await fetchPrice(url)
  return result
} catch (error) {
  console.error('fetchPrice failed:', { url, error })
  throw new Error('Could not fetch the current price')
}
```

### python

catch specific exceptions, never bare `except:`.

```python
try:
    price = await scrape_product(url)
except PlaywrightTimeoutError as e:
    logger.error(f"scrape timed out for {url}: {e}")
    raise ScraperError(f"Could not load {url}") from e
except Exception as e:
    logger.exception(f"unexpected error scraping {url}")
    raise
```

## testing

- **unit tests** for pure functions and utilities
- **integration tests** for API routes and database queries
- keep test files next to the code they test, named `*.test.ts` or `test_*.py`
- aim for coverage of the critical path, not 100%

## best practices

### do

- use conventional commit format (`feat:`, `fix:`, etc.)
- use imperative mood in commit messages
- follow the naming conventions for the language you're in
- handle errors with specific exception types
- log errors with context (what was being attempted, with what inputs)

### don't

- write vague commit messages ("updated stuff", "fixes")
- mix camelCase and snake_case in the same file
- use bare `except:` in python
- swallow errors without logging
- commit `.env` files or secrets

## workshop-specific notes

- **project A (portfolio):** stick to camelCase for files, PascalCase for react components
- **project B (price tracker):** backend uses snake_case (python), frontend uses camelCase (TS)
- **package management:** always `pnpm` for node, `uv` for python, never `npm` or `pip`
- **before committing:** run `pnpm lint` (frontend) or `uv run ruff check` (backend) if configured

---

*adapted for the GSU programming club claude code workshop. original skill: [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code).*
