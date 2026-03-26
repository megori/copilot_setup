# MAID Development Methodology — Global Rules

This workspace uses the **MAID (Managed AI Development)** framework. These rules apply to all files and interactions.

## 0. Core Principles
**Never end a chat message without asking the user something via `vscode_askQuestions`.** Always seek user input to clarify, confirm, or gather more information before proceeding. This ensures alignment and prevents misunderstandings. Any reply must include the askQuestions tool.

### Git Push — Non-Negotiable Rule
**NEVER run `git push` (or any command that sends code to a remote) without first asking for explicit confirmation via `vscode_askQuestions`.** No exceptions. No matter how small the change. No matter what phase. Always ask, always wait for yes.

## 1. State Protocol (CRITICAL)
Before every response, read `.maid/state.json`. Every response MUST start with `[Phase: {PHASE}] [Goal: {GOAL}]`.

- `system_mode: STRICT` → no code changes until `current_phase` is 4
- `system_mode: ADMIN` → full autonomy for architectural refactoring
- Phase gates are ENFORCED — work blocked unless prior phase criteria are met

## 2. WHY-First Thinking
Before any action, answer: **WHY am I doing this? WHAT value does it create? WHO benefits?**
Cannot answer in 3 seconds → STOP and clarify.

## 3. Phase Lifecycle
```
0: Discovery → 1: PRD → 2: Tech Spec → 3: Impl Plan → 4: Dev → 5: QA & Ship → 6: User Feedback
```
Each phase transition requires: all deliverables complete + quality check ≥7.0 + human approval (`/approve`).

## 4. Quality Checks
All significant outputs (code >10 lines, architecture decisions, PRDs, tech specs) go through the reflection-agent sub-agent. Pass threshold: 7.0/10.

## 5. Development Standards
- Python: PEP8, mandatory type hints, Pydantic v2 in `backend/models/`
- TDD mandatory in Phase 4: tests written first, must pass before "Done"
- Never hardcode keys — use `.env`
- Status updates format: `✅ Done: [task] 🧪 Tests: [x/x]`

### UI Quality (applies whenever the project has a frontend)
- Load `ui-ux-pro-max` skill for **every** frontend task — accessibility, touch targets, and visual sophistication are non-negotiable, not optional enhancements
- Apply `atomic-design` hierarchy: Tokens → Atoms → Molecules → Organisms → Templates → Pages — never jump levels
- Design tokens (colors, spacing, typography) are defined in Phase 2 and stored in `src/tokens/` — **no hardcoded values ever** in components

### Reusability
- Component names are **role-generic and context-neutral**: `ActionCard` not `ProductCard`, `DataTable` not `OrdersTable`, `AvatarGroup` not `TeamMembers` — the component's props define specific usage, not its name
- Before creating any new component, audit the existing library — extend via props before creating a duplicate
- Color palette is defined once as semantic CSS variables (`--color-primary`, `--color-surface`, etc.) — referenced everywhere, hardcoded nowhere

## 6. File Access Policy
- Agents read from `.github/` only
- Agents write to `.maid/` or `C:\Users\dori\.maid` only

## 7. Key Commands
| Command | Use Case |
|---------|----------|
| `/new-project` | Technical scaffolding (asks for name, venv, and GitHub via UI) |
| `/maid-start` | Begin a session (pick up role and phase) |
| `/maid-end` | End session and save state |
| `/fix "bug"` | Urgent fix (bypasses phase gates) |
| `/status` | Current progress & blockers |
| `/gate-check` | Validate readiness to advance phase |
| `/approve` | Advance the phase |
| `/reflect` | Quality assessment |

### 7.1 Scaffolding vs. Methodology
The `/new-project` command is purely for **technical scaffolding** (folder structure, virtual environment, GitHub repository). It does **not** include the "WHY/Purpose" or "Discovery" questions. Those are part of **Phase 0 (Discovery)**, which begins only after the project is created and the user runs `/maid-start` in the new workspace.

> **MAID commands are text triggers** — not VS Code slash commands. Type them in the chat and press Enter. Natural language works too (e.g. "create a new project", "what's the status").

> **Multi-root workspace:** This copilot_setup folder is the MAID methodology root.
> Your project folder is the second root. Instructions from both roots are active simultaneously.

For project-specific coding standards, see [.github/rules/project/policy.md](rules/project/policy.md) (fill this file in when starting each new project)
