# MAID (Managed AI Development) — The Human Guide

> **tl;dr:** This turns GitHub Copilot from a code autocomplete into a structured engineering partner.  
> You stay in charge. It follows your process.

---

## What's Happening Here

You cloned a folder of instruction files. When VS Code opens with this folder alongside your project, GitHub Copilot reads those files and follows a structured development process instead of just winging it.

There are 7 phases. Copilot can't skip ahead without your approval. It checks quality on every output. It remembers what you were doing last session. That's it.

---

## Starting a New Project

In Copilot Chat, type:

```
/new-project
```

Copilot will ask: **"What would you like to name the new project?"**  
Give the name, and Copilot handles everything — creates the folder, sets up the workspace, and opens it in VS Code automatically.

Then do two things:
1. Fill in `.github/rules/project/policy.md` — tell Copilot your stack and any specific rules
2. Type `/maid-start` in Copilot Chat to begin

That's it.

> **Prefer the terminal?** You can also run it directly:
> ```powershell
> cd C:\Users\dori\Code\copilot_setup
> .\scripts\new-project.ps1 -Name "your-project-name"
> ```



Core Capabilities

🏗️ Project Orchestration

-Create new projects with full scaffolding (/new-project)
-Run multi-phase development workflows (Discovery → Dev → QA → Ship)
-Enforce quality gates and phase transitions


💻 Software Development

-Full-stack coding across Python, TypeScript, React, and more
-Test-driven development with automated test generation
-Code review, debugging, and technical architecture


🎨 Design & UI

-Build atomic design systems from Figma
-Create production-grade frontend interfaces
-Design review and component specifications


📋 Requirements & Planning

-Product requirements documents (PRDs)
-Technical specifications with security-first design
-Feature addition guidance for existing codebases
-Pre-launch research and competitive analysis


🧪 Quality Assurance

-Test strategy and BDD scenario development
-Bug reporting and acceptance testing


🔧 Role-Based Guidance

-Developer, Product Manager, QA Engineer, Tech Lead perspectives
-Situation-appropriate recommendations

---

## Day-to-Day Usage

**To start a session:**
```
/maid-start
```

**To check where you are:**
```
/status
```

**To move to the next phase (after Copilot finishes the current one):**
```
/phase-approve
```

**Emergency fix (skips phase rules):**
```
/fix "describe the bug"
```

**When you're done for the day:**
```
/maid-end
```

---

## The 7 Phases (quick version)

You start at Phase 0. Copilot moves forward only when you say so.

| Phase | What It's For |
|-------|--------------|
| 0 — Discovery | Is this worth building? |
| 1 — PRD | What exactly are we building? |
| 2 — Tech Spec | How will we build it? |
| 3 — Impl Plan | What's the order of work? |
| 4 — Development | Build it. Tests first. |
| 5 — QA & Ship | Is it production-ready? |
| 6 — User Feedback | Did it work? What broke? |

---

## If Something Feels Off

**Copilot is refusing to write code?**  
You're probably in Phase 0–3 (STRICT mode). Get to Phase 4 via `/phase-approve` first.

**Starting fresh on a new project?**  
Run the script above. Don't manually edit `.maid/state.json` unless you know what you're doing.

**Want to change the rules Copilot follows?**  
Edit `.github/rules/project/policy.md` in your project. That's your project-specific override.

**Want to improve the methodology itself?**  
Edit anything in `copilot_setup/.github/` — changes apply to all your projects immediately.

---

## Files That Matter (the ones you touch)

| File | When You Touch It |
|------|-------------------|
| `.github/rules/project/policy.md` | At the start of every project |
| `.maid/state.json` | When resetting a project (or never — let Copilot manage it) |
| `scripts/new-project.ps1` | Only if you want to change what gets scaffolded |

Everything else in `copilot_setup/.github/` is the methodology — edit it only if you're intentionally changing how Copilot behaves.

---

*For the full technical reference, see [.github/HUMAN.md](.github/HUMAN.md)*



# GitHub — Quick Reference

> This guide covers everything you need for daily GitHub use with MAID projects.

---

## The 3-Command Workflow

When it's time to push (after Phase 6 user acceptance), run:

```powershell
git add .                          # 1. Stage all changed files
git commit -m "describe what you did"  # 2. Save a local snapshot
git push                           # 3. Upload to GitHub
```

**In MAID projects:** `git add` and `git commit` happen freely during development. `git push` only runs after you explicitly approve it — Copilot will always ask first via the confirmation dialog before pushing.

---

## What Each Command Does

| Command | Analogy | What it really does |
|---------|---------|---------------------|
| `git add .` | Packing a box | Marks files as "ready to save" |
| `git commit -m "…"` | Sealing the box with a label | Creates a permanent snapshot |
| `git push` | Shipping the box to the cloud | Uploads to github.com |

---

## Checking What's Going On

```powershell
git status          # What files changed since last commit?
git log --oneline   # Show history of commits (most recent first)
git diff            # Show exactly what text changed
```

---

## Starting a New MAID Project with GitHub

When you create a new project with `/new-project`, the script now asks if you want a GitHub repo. Say yes and it handles everything automatically.

**Manual version (if needed):**
```powershell
cd C:\Users\dori\Code\my-project
git init
git add .
git commit -m "chore: initial commit"
gh repo create megori/my-project --public --source . --remote origin --push
```

---

## VS Code Source Control Panel

You don't have to use the terminal. VS Code has a built-in visual interface:

1. Click the **branch icon** in the left sidebar (or press `Ctrl+Shift+G`)
2. You'll see all changed files with green (added) and red (removed) highlights
3. Click `+` next to a file to stage it (= `git add`)
4. Type a message in the box and click ✓ to commit
5. Click **Sync Changes** / **Push** when you are ready to send to GitHub

> **Tip:** The green/red change indicators stay visible as long as you haven't committed. Commit at the end of each MAID phase, push only after Phase 6 approval.

---

## Write Good Commit Messages

A good commit message completes this sentence: *"This commit will..."*

```
✅  chore: initial MAID project scaffold
✅  feat: add user login page
✅  fix: button not responding on mobile
✅  docs: update README with setup steps
❌  update
❌  stuff
❌  asdf
```

**Prefixes:**
| Prefix | When to use |
|--------|-------------|
| `feat:` | A new feature |
| `fix:` | A bug fix |
| `chore:` | Setup, config, tooling |
| `docs:` | Documentation only |
| `refactor:` | Code restructure, no new feature |

---

## Repository vs Project

| | **Repository** (repo) | **GitHub Project** |
|-|-----------------------|--------------------|
| What it is | A versioned folder of code | A Kanban task board |
| Analogy | Google Drive with undo history | Trello / Jira |
| You need it? | Yes — always | Optional |
| For MAID? | One repo per project | Could track phases as cards |

---

## Key Concepts in 1 Line Each

- **Branch** — a separate copy of the code to work in without breaking the main version
- **Main / Master** — the primary branch (your stable, working version)
- **Pull Request (PR)** — a proposal to merge a branch into main, with review
- **Clone** — download a repo from GitHub to your computer
- **Fork** — copy someone else's repo to your own GitHub account
- **Remote** — the GitHub.com version of your repo (`origin`)
- **Origin** — the default name for your GitHub remote

---

## Useful `gh` CLI Commands

```powershell
gh repo list megori           # List all your repos
gh repo view --web            # Open current repo in browser
gh repo create NAME --public  # Create a new GitHub repo
gh auth status                # Check if you're logged in
gh auth login                 # Log in to GitHub
```

---

## Your Setup

| What | Value |
|------|-------|
| GitHub username | `megori` |
| Git commit name | `megori` |
| Git commit email | `24620866+megori@users.noreply.github.com` |
| MAID methodology repo | `github.com/megori/copilot_setup` |
| GitHub CLI | `gh` (v2.88.1, installed March 2026) |
