# MAID - Managed AI Development 

*A structured overlay for GitHub Copilot that gives your agent a repeatable,  
phase-gated process — from idea to shipped product.*

---

## Who It's For

> Any developer who wants Copilot to act as a disciplined **PM → Dev → QA** team member —  
> not just a code autocomplete.  
>  
> Especially useful for **solo developers** who want the structure of a team process  
> without needing a team.


**Your API key. Your repos. Your rules.**


---

## The 7 Phases

```
  0           1         2           3          4          5           6
Discovery → PRD → Tech Spec → Impl Plan → Dev → QA & Ship → User Feedback
   ✓          ✓        ✓           ✓         ✓       ✓            ↺
```

| # | Phase | Question It Answers | Output |
|---|-------|---------------------|--------|
| **0** | Discovery | Is this worth building? | Research report, Go/No-Go |
| **1** | PRD | What exactly are we building? | Requirements, user stories |
| **2** | Tech Spec | How will we build it? | Architecture, APIs, security |
| **3** | Impl Plan | Who does what, when? | Task breakdown, sprint plan |
| **4** | Dev | Build it — tests first | Production code + passing tests |
| **5** | QA & Ship | Is it production-ready? | Release, deployment |
| **6** | User Feedback | Did it land well? | Resolved issues, closed loop |

> Every phase transition requires your `/phase-approve`. Copilot cannot advance alone.

---

## How It Works

### Skills
Specialized instruction sets stored in `.github/skills/`.  
Copilot loads the right skills automatically based on your current phase and role.

```
Phase 0  →  0-maid-discovery
Phase 1  →  1-maid-prd
Phase 2  →  2-maid-tech-spec
Phase 3  →  3-maid-impl-plan
Phase 4  →  4-maid-development
Phase 5  →  5-maid-qa-ship
Phase 6  →  6-maid-user-feedback
```

### State Files
Copilot reads these **before every response** — your session never loses context.

```
.maid/
├── state.json        ← current phase, project name, phase statuses
└── context.json      ← active task, decisions made, session log
```

### Phase Gates
Copilot is blocked from phase N+1 until you approve phase N:

```
/gate-check      → Verify you're ready to advance
/phase-approve   → Sign off and advance
/maid-start       → Begin a session (pick role + phase)
/maid-end         → End session and record feedback
```

### Sub-Agents
Isolated AI processes that evaluate your work objectively:

| Agent | Triggered By | What It Does |
|-------|-------------|--------------|
| `reflection-agent` | Automatic | Quality check every significant output |
| `phase-review-agent` | `/gate-check` | Validates phase exit criteria |
| `qa-validator-agent` | Phase 4 | Per-task completion validation |
| `memory-analysis-agent` | `/maid-improve` | Learns from session feedback |

---

## File Structure

```
copilot_setup/
├── .github/                    ← The methodology (never project-specific)
│   ├── skills/                 ← 30 specialized skills
│   ├── agents/                 ← 4 sub-agents
│   ├── commands/               ← Slash commands (/prd, /gate-check, ...)
│   ├── rules/                  ← Behavioral guardrails
│   └── copilot-instructions.md ← Global Copilot rules (loaded every session)
│
└── .maid/                       ← Your project's runtime state (reset per project)
    ├── state.json              ← Current phase
    ├── context.json            ← Active task context
    ├── SYSTEM_POLICY.md        ← Developer coding standards
    ├── 0_discovery/            ← Phase artifacts
    ├── 1_prd/
    ├── 2_tech-spec/
    ├── 3_impl-plan/
    ├── 4_dev/
    ├── 5_qa/
    └── 6_user-feedback/
```

---


.maid

This folder is project-specific — it gets reset when you start a new project. It's where Copilot stores what's happening right now: which phase you're in, what you're working on, and your artifacts per phase.

.maid/
├── state.json          ← "I'm in Phase 0, project name, which phases are done"
├── context.json        ← "Active task, decisions made, session log"
├── SYSTEM_POLICY.md    ← Your personal dev standards (applied to all projects)
│
├── 0_discovery/        ── Phase 0 artifacts (research reports, Go/No-Go)
├── 1_prd/              ── Phase 1 artifacts (PRD documents)
├── 2_tech-spec/        ── Phase 2 artifacts (tech specs)
├── 3_impl-plan/        ── Phase 3 artifacts (implementation plans, task breakdowns)
├── 4_dev/              ── Phase 4 artifacts (nothing here by default — code goes in your project)
├── 5_qa/               ── Phase 5 artifacts (QA criteria YAML files per task)
├── 6_user-feedback/    ── Phase 6 artifacts (feedback log, triage, fix summary)
│
├── design/             ── Visual/design assets (Figma prep notes, etc.)
├── docs/               ── General docs that don't fit a specific phase
├── meta-agent/         ── Internal MAID system proposals and manifests
└── reflection/         ── Quality check outputs from the reflection sub-agent

The 3 most important files:

state.json — Copilot reads this first thing every session to know where you are
context.json — tracks active work so you never restart from zero mid-project
SYSTEM_POLICY.md — your personal coding standards (no hardcoded keys, typed errors, etc.)









.github — The MAID Methodology
This folder holds the methodology itself — never project-specific. It's what makes Copilot follow the MAID process across any project you work on.

.github/
├── copilot-instructions.md   ← Global rules Copilot follows in every session
├── README.md                 ← Full MAID documentation
├── settings.json             ← VS Code Copilot permissions + hooks config
│
├── skills/                   ← 30 specialized instruction sets (the core of MAID)
├── agents/                   ← 4 sub-agents (reflection, phase-review, qa, memory)
├── commands/                 ← Slash commands (/prd, /gate-check, /maid-start...)
├── core/                     ← Always-loaded skill manifest
├── hooks/                    ← Automation scripts (QA gate, notifications)
├── references/               ← Role/phase terminology, best practices guides
├── rules/                    ← Behavioral rules for agents
└── templates/                ← Reusable templates (PRD, skill, agent, .gitignore)







1. copilot-instructions.md — The Always-On Rules
This is the most important file. GitHub Copilot loads it automatically at the start of every conversation. It sets the ground rules Copilot always follows, regardless of which project you're in.

What's in it right now:

State Protocol — "Read state.json before every response"
Phase header — Every response starts with [Phase: X] [Goal: Y]
STRICT mode — No code changes until Phase 4
Phase Lifecycle — 0: Discovery → 1: PRD → 2: Tech Spec → 3: Impl Plan → 4: Dev → 5: QA & Ship → 6: User Feedback
Quality threshold — All significant outputs go through the reflection sub-agent, pass threshold 7.0/10
Dev standards — Python type hints, Pydantic v2, TDD mandatory in Phase 4
File access policy — Agents read from .github, write to .maid
Key commands reference — /fix, /status, /approve, /reflect
Think of it as the system prompt for GitHub Copilot — it shapes every interaction.







2. skills/ — The 30 Instruction Sets
Skills are the brain of MAID. Each skill is a folder with one or more .md files that tell Copilot how to behave in a specific domain. They're loaded on demand — never all at once.

The 3 categories:

Phase Skills (7 — the MAID lifecycle)

Folder	When loaded	What it teaches Copilot
0-maid-discovery/	Phase 0	How to run discovery: SCQ format, stakeholder questions, Go/No-Go
1-maid-prd/	Phase 1	How to write PRDs: user stories, acceptance criteria, scope
2-maid-tech-spec/	Phase 2	Architecture decisions, API contracts, security design
3-maid-impl-plan/	Phase 3	Task breakdown, Jira population, contradiction resolution
4-maid-development/	Phase 4	TDD workflow, per-task QA gate, code standards
5-maid-qa-ship/	Phase 5	QA checklist, release process, deployment readiness
6-maid-user-feedback/	Phase 6	Feedback collection, issue triage, fix loop
Core Skills (always active, lightweight)

Folder	Purpose
why-driven-decision/	Run WHY analysis before any action
phase-enforcement/	Block out-of-phase work, enforce gates
context-tracking/	Track tasks/steps, persist progress
reflection/	Quality check every significant output
Specialty Skills (loaded when relevant)

Role: role-product-manager, role-developer, role-qa-engineer, role-tech-lead
Design: atomic-design, atomic-page-builder, frontend-design, ui-ux-pro-max, figma-design-review, building-native-ui
Dev: test-driven, code-review, system-architect, pre-prd-research
Orchestrators: maid-lifecycle-orchestrator, maid-feature-add








3. agents/ — The 4 Sub-Agents
Sub-agents are isolated AI processes spawned to evaluate your work objectively. They're separate from the main conversation — they don't carry the full context, so they can't "agree with themselves."

agents/
├── AGENT-STANDARD.md           ← Standard structure all agents follow
├── reflection-agent/           ← Quality evaluator
├── phase-review-agent/         ← Phase gate validator
├── qa-validator-agent/         ← Per-task completion checker
└── memory-analysis-agent/      ← Learns from session feedback

Agent	Triggered By	What It Does
reflection-agent	Automatic (any output >10 lines)	Scores your output 1–10 on WHY alignment, correctness, security, completeness. Blocks advancement if score < 7.0
phase-review-agent	/gate-check	Checks all exit criteria for the current phase — returns PASS/FAIL with specific blockers
qa-validator-agent	End of each Phase 4 task	Validates task against .maid/5_qa/{task-id}.yaml acceptance criteria
memory-analysis-agent	/maid-improve	Reads session feedback logs, identifies patterns, suggests improvements to skills
Why isolated? The main Copilot agent knows what it built and why. A sub-agent gets only what you pass it — so it evaluates based on the output alone, not the reasoning that created it. This catches issues the main agent would rationalize away.

Practically: You mostly interact with reflection-agent (automatic) and phase-review-agent (via /gate-check). The others run in the background.





4. commands/ — Slash Commands
These are prompt files that Copilot loads when you type a /command in chat. They tell Copilot exactly how to handle that command — what to do, in what order, what to ask you.

The daily workflow commands:

Command	File	What It Does
/maid-start	maid-start.md	Session startup — pick your role (PM/Dev/QA/Lead) and phase, load relevant skills
/maid-end	maid-end.md	End session — logs what you did, prompts for feedback (1–5 rating)
/good-morning	good-morning.md	Morning check — reads state.json, shows where you left off
/status	maid-status.md	What phase, what's done, what's blocking
Phase management:

Command	What It Does
/gate-check	Spawns phase-review-agent, checks all exit criteria for current phase
/phase-approve	Your sign-off — advances state.json to next phase
/phase-advance	Same as approve (alias)
/phase	Show current phase details
Work commands:

Command	What It Does
/prd	Create a PRD (loads 1-maid-prd skill)
/tech-spec	Create a Tech Spec
/discovery	Start Phase 0 research
/full-feature	Start a full feature with maid-feature-add orchestrator
/write-tests	Write tests TDD-first
/code-review	Quality review of current code
Quick fixes:

Command	What It Does
/fix "bug description"	Urgent fix — bypasses phase gates
/reflect	Show the last quality check score breakdown
/maid-improve	Run the memory-analysis-agent learning cycle
You can also create your own commands — just add a .md file in commands/ and describe what you want Copilot to do when it's invoked.









core/ — Always-Loaded Manifest
One file: MANIFEST.md. It lists the 4 skills that should be active in every session (why-driven-decision, reflection, phase-enforcement, context-tracking). It's basically a reminder to Copilot and to you about what's always on. No standalone value — just documentation of the "always-on" set.

hooks/ — Automation Scripts
These run automatically at specific events (not Copilot-triggered — these are shell/Python scripts for your local machine):

File	When It Runs	What It Does
bip-notification.py	After every Copilot session ends	Plays a sound notification (so you know Copilot finished)
qa-gate.sh	Phase 4 → Phase 5 transition	Runs tests, checks coverage, blocks advancement if failing
validate-qa-gate.py	Called by qa-gate.sh	Validates the QA criteria YAML files against actual test results
These are optional infrastructure — if you don't set them up, nothing breaks. They add automated guardrails at the shell level.

references/ — Best Practice Guides
Static reference documents that skills and agents pull from:

File	What's In It
role-phase-terminology.md/.json	Which skills map to which roles and phases
deployment-best-practices.md	Standard deployment checklist
python-best-practices.md	Python style standards used in Phase 4
testing-and-logging.md	Test strategy patterns, logging standards
WHAT-IS-A-DECISION.md	Definition of what counts as a "decision" (for context tracking)
rules/ — Behavioral Guardrails
Structured rules for how agents should behave. Organized into subfolders (agents/, code/, general/, skills/, testing/). These are referenced by skills to enforce consistent output patterns.

templates/ — Reusable Starters
Ready-to-copy templates when you need to create something new:

File/Folder	What It Is
prd-template.md	PRD starting structure
skill-template.md	Boilerplate for a new skill
agent-template.md	Boilerplate for a new sub-agent
gitignore-maid-patterns.txt	.gitignore patterns to exclude .maid secrets
.maid	Template folder for initializing a new project's .maid directory
qa/	QA criteria YAML templates


