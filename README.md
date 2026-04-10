# claude workshop starter

starter repo for the **progsu x claude code workshop** on 04-27-2026

## 60-second quickstart

```bash
git clone https://github.com/liamellison02/claude-workshop-starter.git
cd claude-workshop-starter

# pick your OS
./setup/setup-mac-silicon.sh      # apple silicon
./setup/setup-mac-intel.sh        # intel mac
./setup/setup-linux.sh            # linux
.\setup\setup-windows.ps1         # windows (powerShell as admin)

# auth
gh auth login
claude login

# go
claude
```

then open **[GUIDE.md](./GUIDE.md)** and follow along.

## what's in the box

- **GUIDE.md**, the full workshop walkthrough
- **TROUBLESHOOTING.md**, when things break
- **.mcp.json**, preconfigured MCP servers (context7, github, vercel, playwright, magic)
- **.claude/agents/**, 5 ready-to-use subagents
- **.claude/skills/**, the `everything-claude-code-conventions` skill
- **setup/**, OS-specific setup scripts (node, pnpm, python, uv, claude code, gh)
- **projects/**, two project templates to pick from

## projects

| project | difficulty | time | stack |
|---|---|---|---|
| [personal portfolio site](./projects/01-portfolio/) | easy | ~60–75 min | next.js + magic UI |
| [browser price tracker](./projects/02-price-tracker/) | hard | ~75–90 min | next.js + fastapi + playwright |

## requirements

- macOS, linux, or windows 10/11
- git and a github account
- ~2 GB free disk space (playwright chromium is chunky)
- a claude account with credits, you got $40 at check-in
