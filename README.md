<div align="center">

# MAID — Managed AI Development 
### A structured overlay for GitHub Copilot

*Stop getting random code from an AI. Start getting a disciplined engineering partner.*

---

**Built on top of GitHub Copilot. No new tools. No subscriptions. Just process.**

</div>

---

## What Is This?

This repo is a **methodology setup** for GitHub Copilot. Clone it once, open it alongside any project, and Copilot will follow a structured 7-phase development process — from idea to shipped product — with phase gates, quality checks, and sub-agents you control.

It does **not** replace your Copilot subscription or install anything new. It's a folder of instruction files that shapes how Copilot behaves.

---

## What You Need

- [Visual Studio Code](https://code.visualstudio.com/)
- [GitHub Copilot](https://github.com/features/copilot) (subscription required)
- [Git](https://git-scm.com/) + [PowerShell](https://github.com/PowerShell/PowerShell) (Windows — included by default)

---

## Quick Start

### Step 1: Clone this repo once

```powershell
git clone https://github.com/your-username/copilot_setup.git C:\Users\<you>\Code\copilot_setup
```

> This is your **permanent** MAID installation. You never clone it again — it's shared across all projects.

---

### Step 2: Create a new project

In Copilot Chat, type:
```
/new-project
```
This will open a UI prompt asking for your project name and setup preferences (Virtual Environment, GitHub repository, etc.).

Alternatively, you can run the script manually:
```powershell
cd C:\Users\<you>\Code\copilot_setup
.\scripts\new-project.ps1 -Name "my-project-name" -Venv yes -VenvLang python -GitHub public
```

**What gets created:**

```
my-project-name/
├── .github/rules/project/policy.md   ← Fill this in (your stack, your rules)
├── .maid/                              ← Phase folders + session state
├── my-project-name.code-workspace    ← Linked to this copilot_setup repo
├── .gitignore                         ← MAID-aware
└── README.md
```

---

### Step 3: Fill in your project policy

Open `.github/rules/project/policy.md` and fill in:
- Your tech stack (Next.js? FastAPI? React Native?)
- Any domain-specific rules
- Exceptions to the defaults

Copilot reads this file for every response in your project.

---

### Step 4: Start working

In VS Code with the workspace open, type in Copilot Chat:

```
/maid-start
```

Pick your role (PM / Developer / QA / Tech Lead), confirm you're in Phase 0, and go.

---

## The 7-Phase Process

```
0: Discovery → 1: PRD → 2: Tech Spec → 3: Impl Plan → 4: Dev → 5: QA & Ship → 6: User Feedback
```

| Phase | What Copilot Does | Your Job |
|-------|-------------------|---------|
| 0 — Discovery | Runs research, Go/No-Go analysis | Approve or kill the idea |
| 1 — PRD | Writes user stories and requirements | Sign off on scope |
| 2 — Tech Spec | Designs architecture and APIs | Approve or adjust |
| 3 — Impl Plan | Creates task breakdown | Confirm the plan |
| 4 — Dev | Writes code TDD-first, per task | Review and merge |
| 5 — QA & Ship | Validates quality, prepares release | Approve ship |
| 6 — User Feedback | Collects feedback, closes the loop | Confirm resolved |

> You advance phases with `/phase-approve`. Copilot cannot skip ahead without your sign-off.

---

## How the Two-Folder System Works

```
C:\Users\<you>\Code\
├── copilot_setup/          ← MAID Methodology (this repo — never changes per project)
│   └── .github/            ← All skills, agents, commands, rules
│
└── my-project/             ← Your actual project (separate repo, pushed to GitHub)
    ├── .github/rules/project/policy.md   ← Only project-specific standards
    ├── .maid/               ← Session state (phase, tasks, decisions)
    └── src/                ← Your code
```

VS Code opens both folders as a **multi-root workspace**. Copilot reads instructions from both.
Update the methodology once in `copilot_setup` — all projects benefit immediately.

---

## Key Commands

| Command | What It Does |
|---------|-------------|
| `/new-project` | Walk through creating a new project scaffold |
| `/maid-start` | Begin a session — pick role and confirm phase |
| `/maid-end` | End session — log what you did |
| `/gate-check` | Validate readiness to advance to next phase |
| `/phase-approve` | Sign off and advance |
| `/status` | What phase, what's blocking |
| `/fix "bug"` | Urgent fix — bypasses phase gates |
| `/reflect` | Show last quality check score |

---

## Deep Dive

For a full walkthrough of every folder and file:

→ [.github/HUMAN.md](.github/HUMAN.md)

---

<div align="center">

*Created by Ilan Dahan*

</div>
