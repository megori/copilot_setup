---
name: 4-maid-development
description: MAID Phase 4 - Development phase. Use for implementing features, TDD practices, code reviews, transitioning from planning to QA.
---

# Development Phase Skill

## MANDATORY: QA Gate After EVERY Task

**Iron Rule:** Task complete → Spawn QA → Wait for result → PASS? Next task : Fix

```
Task(
  subagent_type="general-purpose",
  prompt="You are a QA Validator. Read .maid/qa/{TASK-ID}.yaml and review modified files. Return JSON with verdict: PASS or FAIL.",
  description="QA validation for {TASK-ID}"
)
```

- PASS → Proceed to next task
- FAIL → Fix issues in `action_required`, spawn QA again

---

## Phase Overview

**Purpose:** Implement solution with quality built-in through TDD.

**Entry:** Tech spec completed, architecture defined
**Exit:** All features implemented, tests passing, code reviewed

## Deliverables

1. **Production Code** - Clean, documented, follows standards
2. **Test Suite** - Unit, integration, E2E, >80% coverage
3. **Documentation** - Code docs, API docs, README updates

## TDD Workflow

RED (failing test) → GREEN (make pass) → REFACTOR (clean up) → REPEAT

| Phase | Rule |
|-------|------|
| RED | Test MUST fail first |
| GREEN | Minimal code to pass |
| REFACTOR | Tests still pass |

---

## Frontend Checklist *(every UI task)*

**Before writing any new component:**

1. **Audit first** — search `src/components/` for an existing component that can be extended via props. Duplicate only when genuinely impossible to extend.
2. **Load skills** — invoke `ui-ux-pro-max` (design quality + accessibility) AND `atomic-design` (hierarchy placement) before implementing.
3. **Name generically** — the name must describe WHAT the component IS, not WHERE it is used:

| Wrong | Right |
|-------|-------|
| `ProductCard` | `Card` |
| `OrdersTable` | `DataTable` |
| `UserAvatarGroup` | `AvatarGroup` |
| `CheckoutButton` | `Button` (variant=primary) |

4. **Tokens only** — every color, spacing, font size, and radius value must reference a CSS variable from `src/tokens/`. No hardcoded values in component files.
5. **Accessibility baseline** — every component must pass: color contrast ≥4.5:1, 44×44px touch targets, visible focus ring, ARIA labels on icon-only elements.
6. **Visual bar** — refer to `ui-ux-pro-max` style and palette guidance; output must be visually distinctive and consistent with the project's chosen aesthetic direction.

### Iron Rules for UI (non-negotiable)

- `TODO: define token` is a blocker — do not ship a component with a hardcoded hex value
- A component named after a feature (`FeatureNameXxx`) fails code review
- Missing `ui-ux-pro-max` skill load for a UI task is a protocol violation

## Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| Skipping TDD | Write tests first |
| Test-specific code | No `if is_test:` in prod |
| Over-mocking | <20% mocking |
| Happy path only | Test errors & edge cases |
| Weak assertions | Assert exact values |

## Code Quality

**Required:**
- [ ] Single responsibility functions
- [ ] DRY - no copy-paste
- [ ] Type hints on public functions
- [ ] Meaningful names
- [ ] Error handling

**Forbidden:**
- [ ] No `any` types
- [ ] No TODO/FIXME
- [ ] No commented-out code
- [ ] No test-specific branching

## Documentation Standards

**File-Level:**
```typescript
/**
 * @file UserService.ts
 * @description Purpose
 * @related ./UserRepository.ts
 */
```

**Function:**
```typescript
/**
 * Creates user account.
 * @param data - User input
 * @returns Created user
 * @throws {ValidationError} If email invalid
 */
```

## QA Gate Enforcement

### Per-Task Flow

1. Read Task + QA Criteria (`.maid/qa/{task-id}.yaml`)
2. Implement Task (TDD)
3. Signal Complete (TodoWrite)
4. **SPAWN QA SUB-AGENT** (mandatory)
5. Process QA Report → PASS: next task, FAIL: fix & retry

### QA Criteria Location

`.maid/qa/{task-id}.yaml`:
```yaml
criteria:
  must_achieve:    # What code MUST do
  must_not:        # What code must NEVER do
  not_included:    # Scope boundaries
  best_practices:  # Quality standards
```

### QA Sub-Agent Context (Isolated)

**Sees:** Epic goal, Story value, Acceptance criteria, Changed files
**Does NOT see:** Tech Spec, Architecture, Developer notes

### QA Gate Rules

| Rule | Enforcement |
|------|-------------|
| Hard block | Cannot proceed until PASS |
| Max 3 cycles | After 3 FAILs, escalate to human |
| Check all criteria | Reports ALL failures |
| No skipping | Mandatory for all tasks |

### When QA Fails

1. Read report at `.maid/qa/{task-id}-review-{N}.json`
2. Fix each issue in `action_required`
3. Re-spawn QA
4. Repeat until PASS or max cycles

---

## Phase Gate Checklist

- [ ] All features per spec
- [ ] All tests passing
- [ ] Edge cases tested
- [ ] Code reviewed
- [ ] No test-specific logic in prod
- [ ] Documentation updated
- [ ] **All tasks passed QA gate**
- [ ] **Git: changes staged and ready to commit at phase end**

### Git Checkpoint (end of phase only)

Work freely throughout Phase 4 — green/red change indicators stay visible while you have uncommitted changes, which helps you track everything you've built.

When ALL tasks are complete and QA passed, make a single phase-level commit:
```powershell
git add .
git commit -m "feat: phase 4 complete — [brief summary]"
```

> **Do NOT push yet.** Push happens in Phase 6 after user acceptance.
> Committing here saves a local checkpoint while keeping everything ready to review.

## Role Guidance

| Role | Focus |
|------|-------|
| PM | Clarifications, validate intent |
| Dev | TDD, implement to pass tests |
| QA | Review coverage, test scenarios |
| Tech Lead | Code review, standards |

## Handoff to QA

- Complete, tested code
- Test results + coverage
- Known issues (if any)
- Deployment instructions

---

## ⚠️ IRON RULE: Every Message Must End With a Question

This rule is **non-negotiable** and applies even when the lifecycle orchestrator skill is not loaded.

> **Every single response you send during this phase MUST end by calling `vscode_askQuestions`.**
> No exceptions. No informational-only messages. No summaries without a follow-up question.

### What this means in practice

| Situation | WRONG | RIGHT |
|-----------|-------|-------|
| After completing a task | Summarise and stop | Summarise, then ask "Continue to next task?" |
| After a QA pass | Report PASS and stop | Report PASS, then ask "Continue to next task\|Pause\|Revise?" |
| After a QA fail | List issues and stop | List issues, then ask "Ready to fix? (describe approach)" |
| After a phase summary | Show summary and stop | Show summary, then ask for approval to advance |
| Asking a clarification | Answer inline and stop | Answer inline, then ask the next driving question |

### Minimum required `vscode_askQuestions` call at end of every message

If nothing else fits, always end with:

```
vscode_askQuestions:
  header: "next-step"
  question: "What would you like to do next?"
  options:
    - "▶ Continue"
    - "⏸  Pause here"
    - "🔁 Revise something"
```

### Never do this

```
❌ Send a message that ends with a period and no question
❌ Send a status update without asking for approval or next action
❌ Complete a task and wait silently for the user to drive
```

**You are the orchestrator. You take the lead. Always move the conversation forward with a question.**
