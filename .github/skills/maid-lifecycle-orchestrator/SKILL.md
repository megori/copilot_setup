---
name: maid-lifecycle-orchestrator
description: >
  Full MAID lifecycle orchestrator for Product Managers. Guides from idea → shipped product
  through all 6 phases (Discovery → PRD → Tech Spec → Impl Plan → Dev → QA & Ship) using
  structured question-driven sessions. Saves phase deliverables to .maid/ automatically.
  Requires explicit "SHIP IT" approval before any deployment action. Load this skill when
  a user has a product idea and wants to run the full lifecycle end-to-end.
---

# MAID Lifecycle Orchestrator

## Purpose

Take the lead from the user. You are the guide — not the user. Ask targeted questions at
each phase, synthesize the answers into professional phase deliverables, save them to disk,
and gate every transition on human approval. Never move to the next phase without explicit
consent. Never proceed to ship without explicit "SHIP IT" confirmation. Never end a chat message without asking the user something by invoking the `vscode_askQuestions` tool.

---

## When to Activate

- User has a new product idea or feature request
- User says "guide me", "start a project", "I have an idea", "full lifecycle"
- User invokes `/full-feature` or `/MAID-start` with a PM role

---

## Orchestration Loop

```
Bootstrap → [Phase 0 → 1 → 2 → 3 → 4 → 5 → 6] each with:
  ASK → SYNTHESIZE → SAVE → QUALITY CHECK → GATE
```

Every phase follows this pattern. Phase 5 adds a mandatory SHIP GATE before any deployment.

---

## Step 0: Bootstrap

### Actions

1. Read `.maid/state.json` — check for an existing project in progress.
2. If state exists and `current_phase > 0`:
   - Use `vscode_askQuestions` with:
     ```
     header: "resume-or-fresh"
     question: "An existing project '{project}' is at Phase {current_phase} ({phase_name}).
                What would you like to do?"
     options: ["Resume from Phase {current_phase}", "Start a new project (fresh)"]
     ```
3. If no state or user chooses fresh:
   - Use `vscode_askQuestions` with:
     ```
     header: "project-name"
     question: "What is the name of your project or feature? (This becomes the file name slug.)"
     placeholder: "e.g. delivery-tracker, user-auth-v2, smart-routing"
     allowFreeformInput: true
     ```
   - Create `.maid/state.json` using the schema in the **State Management** section below.
4. Announce: `▶ Project: {name} — Starting Phase 0: Discovery`

---

## Phase 0: Discovery

**Purpose:** Validate the problem space before committing to a solution.
**Output:** `.maid/discovery/YYYY-MM-DD-{project}-discovery.md`
**Load skill:** `MAID-discovery`

### Questions (call `vscode_askQuestions` once with all questions)

```yaml
questions:
  - header: "problem"
    question: "What problem are you trying to solve? Describe it in one sentence."
    placeholder: "e.g. Drivers lose track of deliveries and miss SLAs"
    allowFreeformInput: true

  - header: "who"
    question: "Who has this problem? Describe your primary user."
    placeholder: "e.g. Logistics managers at mid-size freight companies"
    allowFreeformInput: true

  - header: "pain-level"
    question: "How painful is this problem today? What does it cost if unsolved? (be specific)"
    placeholder: "e.g. ~15% SLA breaches, €20K/month in penalties"
    allowFreeformInput: true

  - header: "current-solution"
    question: "How do users solve this today? Why is that not good enough?"
    placeholder: "e.g. Manual spreadsheets, take 2hrs/day, error-prone"
    allowFreeformInput: true

  - header: "stakeholders"
    question: "Who else is affected? (decision-makers, data owners, integrations, compliance)"
    placeholder: "e.g. Finance sees costs, IT owns GPS feed, Legal wants GDPR compliance"
    allowFreeformInput: true

  - header: "success-metric"
    question: "What does success look like in 6 months? Give one measurable metric."
    placeholder: "e.g. SLA breach rate drops from 15% to <3%"
    allowFreeformInput: true

  - header: "constraints"
    question: "Any known constraints? (budget, technology stack, regulations, timeline)"
    placeholder: "e.g. Must use existing GPS provider, GDPR compliance required, launch in Q2"
    allowFreeformInput: true

  - header: "proceed"
    question: "Based on what you know, is this problem worth solving now?"
    options: ["Yes — proceed to PRD", "No — park it", "Need more discovery first"]
```

### Synthesize → Save

Using the answers, generate a Discovery Document following the SCQ format from `MAID-discovery` SKILL.md:

```markdown
# Discovery: {project}
**Date:** {YYYY-MM-DD}

## Problem Statement (SCQ)
### Situation
{current-solution answer — what the world looks like today}

### Complication
{problem answer — what's wrong with the current state}

### Question
What if we solved {problem} for {who}?

### Impact
- {pain-level answer}

### Success Metrics
| Metric | Current | Target |
|--------|---------|--------|
| {from success-metric} | {current} | {target} |

## Stakeholder Map
{stakeholders answer, formatted as Decision Makers / Data Owners / End Users / Integrations}

## Constraints
{constraints answer}

## Feasibility Assessment
{github synthesizes a brief 3-5 bullet feasibility view based on constraints + tech context}

## Decision
**Go / No-Go:** {proceed answer}
**Rationale:** {synthesized from answers}
```

Save to: `.maid/discovery/YYYY-MM-DD-{project}-discovery.md`

### Phase Gate

If user chose "No — park it": stop and explain the decision is saved. Do not proceed.
If user chose "Need more discovery first": use `vscode_askQuestions` to ask follow-up questions.
If "Yes": ask for approval gate:

```
vscode_askQuestions:
  header: "phase-0-gate"
  question: "Discovery complete. The document has been saved to .maid/discovery/.
             Review it above, then choose:"
  options:
    - "✅ Approve — Advance to Phase 1: PRD"
    - "✏️  Request changes before advancing"
```

Only advance on "✅ Approve". On "Request changes": ask what to change, revise, re-show, re-ask gate.

---

## Phase 1: PRD

**Purpose:** Define WHAT will be built with unambiguous requirements.
**Output:** `.maid/prd/YYYY-MM-DD-{project}-prd.md`
**Entry check:** `.maid/discovery/` contains an approved discovery document.
**Load skill:** `MAID-prd`

### Questions (call `vscode_askQuestions` once with all questions)

```yaml
questions:
  - header: "core-value"
    question: "In one line: what is the core value this product/feature delivers to the user?"
    placeholder: "e.g. Real-time delivery tracking with automated SLA alerts"
    allowFreeformInput: true

  - header: "user-actions"
    question: "What are the main things users need to be able to DO? (list them, one per line)"
    placeholder: "e.g.\n1. See all active deliveries on a map\n2. Get SLA risk alerts\n3. Reassign a driver in one tap"
    allowFreeformInput: true

  - header: "personas"
    question: "Who are the 1-3 primary user roles? Give each a name and role title."
    placeholder: "e.g. 1. Maria — Logistics Manager  2. Tom — Dispatcher  3. Driver (read-only)"
    allowFreeformInput: true

  - header: "out-of-scope"
    question: "What is explicitly OUT of scope for this version? (v1.0 only)"
    placeholder: "e.g. Driver mobile app, billing integration, historical analytics, custom reports"
    allowFreeformInput: true

  - header: "error-cases"
    question: "What are the most important failure/error cases to handle explicitly?"
    placeholder: "e.g. GPS signal lost mid-route, driver unreachable, system goes offline"
    allowFreeformInput: true

  - header: "non-functional"
    question: "Any performance, security, or compliance requirements that are non-negotiable?"
    placeholder: "e.g. Page loads <2s, GDPR EU data residency, 99.9% availability"
    allowFreeformInput: true

  - header: "assumptions"
    question: "What assumptions are you making that could later turn out to be wrong?"
    placeholder: "e.g. Users have smartphones, GPS provider has 99% uptime, team knows React"
    allowFreeformInput: true
```

### Synthesize → Save

Generate a full PRD following the PRD template from `MAID-prd` SKILL.md.
Create proper user stories in `US-XXX` format with Given/When/Then acceptance criteria.
Every story must link to either a discovery finding or an assumption flag.

Save to: `.maid/prd/YYYY-MM-DD-{project}-prd.md`

### Phase Gate

```
vscode_askQuestions:
  header: "phase-1-gate"
  question: "PRD complete with {N} user stories saved to .maid/prd/.
             Every story has testable acceptance criteria.
             Choose:"
  options:
    - "✅ Approve — Advance to Phase 2: Tech Spec"
    - "✏️  Request changes before advancing"
```

---

## Phase 2: Tech Spec

**Purpose:** Design HOW it will be built — the unambiguous technical blueprint.
**Output:** `.maid/tech-spec/YYYY-MM-DD-{project}-tech-spec.md`
**Entry check:** `.maid/prd/` contains approved PRD.
**Load skill:** `MAID-tech-spec`

### Questions (call `vscode_askQuestions` once with all questions)

```yaml
questions:
  - header: "tech-stack"
    question: "What technology stack will you use? (frontend, backend, database, infra)"
    placeholder: "e.g. React + TypeScript, FastAPI, PostgreSQL, deployed on AWS ECS"
    allowFreeformInput: true

  - header: "integrations"
    question: "What existing systems or external APIs must this integrate with?"
    placeholder: "e.g. GPS provider REST API v2, company auth service (JWT), Slack webhooks"
    allowFreeformInput: true

  - header: "data-entities"
    question: "What are the main data entities/models? List the key tables or objects."
    placeholder: "e.g. Delivery, Driver, Route, SLARule, Alert, Notification"
    allowFreeformInput: true

  - header: "api-endpoints"
    question: "What are the most important API endpoints needed? (method + path + one-liner)"
    placeholder: "e.g.\nGET /deliveries — list active deliveries\nPOST /deliveries/{id}/reassign — reassign driver"
    allowFreeformInput: true

  - header: "auth-model"
    question: "How is authentication and authorization handled?"
    placeholder: "e.g. JWT via existing auth service, RBAC: manager > dispatcher > driver (read-only)"
    allowFreeformInput: true

  - header: "scale"
    question: "What are the load/scale expectations?"
    placeholder: "e.g. 50 concurrent users, 1,000 deliveries/day, 10,000 GPS pings/hour"
    allowFreeformInput: true

  - header: "deployment"
    question: "How will this be deployed? Any CI/CD or infrastructure requirements?"
    placeholder: "e.g. Docker + GitHub Actions, staging env required before prod push"
    allowFreeformInput: true

  - header: "tech-risks"
    question: "What are the 2-3 biggest technical risks or unknowns you're worried about?"
    placeholder: "e.g. GPS API rate limits unknown, real-time WebSocket scaling untested, team new to FastAPI"
    allowFreeformInput: true
```

### Synthesize → Save

Generate a full Tech Spec following the template from `MAID-tech-spec` SKILL.md.
Must include:
- Architecture diagram (Mermaid flowchart)
- Component breakdown table
- API contracts with request/response schemas and error codes
- Data models with field types and constraints
- Security section (auth, authorization checks, data protection)
- Error handling strategy
- Non-functional requirements table
- Risks and mitigations table

Save to: `.maid/tech-spec/YYYY-MM-DD-{project}-tech-spec.md`

### Phase Gate

```
vscode_askQuestions:
  header: "phase-2-gate"
  question: "Tech Spec complete with architecture diagram, {N} API endpoints, and data models
             saved to .maid/tech-spec/.
             Choose:"
  options:
    - "✅ Approve — Advance to Phase 3: Implementation Plan"
    - "✏️  Request changes before advancing"
```

---

## Phase 3: Implementation Plan

**Purpose:** Resolve contradictions, break the spec into actionable tasks, plan sprints.
**Output:** `.maid/impl-plan/YYYY-MM-DD-{project}-impl-plan.md`
**Entry check:** `.maid/tech-spec/` contains approved tech spec.
**Load skill:** `MAID-impl-plan`

### Questions (call `vscode_askQuestions` once with all questions)

```yaml
questions:
  - header: "team"
    question: "How many developers will work on this? Any specializations? (frontend/backend/fullstack)"
    placeholder: "e.g. 2 devs — 1 backend Python, 1 frontend React"
    allowFreeformInput: true

  - header: "sprint-length"
    question: "What is your sprint/iteration length?"
    options: ["1 week", "2 weeks", "3 weeks", "4 weeks"]

  - header: "v1-scope"
    question: "What user stories from the PRD are MUST-HAVE for v1.0? (list story titles or IDs)"
    placeholder: "e.g. US-001 Map view, US-002 SLA alerts, US-004 Driver reassignment"
    allowFreeformInput: true

  - header: "blockers"
    question: "Any blockers or external dependencies that must be resolved before dev starts?"
    placeholder: "e.g. GPS API credentials from vendor, design mockups needed from UX team"
    allowFreeformInput: true
```

### Internal Sub-Phases (run automatically, no extra questions)

**3a — Contradiction Resolution:**
- Compare PRD requirements against Tech Spec decisions.
- For each contradiction found, log it using the contradiction template format.
- Show the user any contradictions found (even if zero):
  ```
  vscode_askQuestions:
    header: "contradictions-check"
    question: "Contradiction analysis complete. Found {N} contradictions.
               {contradiction list or 'None found.'}
               Resolution applied using: Research > PRD > Tech Spec hierarchy.
               Do these resolutions look correct?"
    options:
      - "✅ Yes — proceed to task breakdown"
      - "✏️  Adjust a resolution"
  ```

**3b — Task Breakdown:**
- Decompose all PRD stories into Tasks targeting 2-4 hours each.
- Assign tasks to: Backend / Frontend / Infrastructure / Cross-cutting.
- Each task must reference its source PRD story.

**3c — Sprint Planning:**
- Assign tasks to sprints based on team size and sprint length.
- Mark which sprint delivers v1.0 scope.
- Include time buffer for unknowns (~20%).

### Synthesize → Save

Generate impl plan following `MAID-impl-plan` SKILL.md templates.
Must include:
- Contradiction log (even if empty)
- Epic > Story > Task hierarchy with estimates
- Sprint assignment table
- Risk register from tech spec risks + team blockers
- Traceability matrix: every PRD story → tasks

Save to: `.maid/impl-plan/YYYY-MM-DD-{project}-impl-plan.md`

### Phase Gate

```
vscode_askQuestions:
  header: "phase-3-gate"
  question: "Implementation Plan complete:
             - {N} tasks across {S} sprints
             - {N} contradictions resolved
             - Saved to .maid/impl-plan/
             Choose:"
  options:
    - "✅ Approve — Advance to Phase 4: Development"
    - "✏️  Request changes before advancing"
```

---

## Phase 4: Development

**Purpose:** Build the solution with quality through TDD.
**Output:** `.maid/dev/YYYY-MM-DD-{project}-dev-log.md`
**Entry check:** `.maid/impl-plan/` contains approved implementation plan.
**Load skill:** `MAID-development`

### Questions (call `vscode_askQuestions` once at phase start)

```yaml
questions:
  - header: "blockers-cleared"
    question: "Have all Phase 3 blockers been resolved? (external deps, credentials, mockups)"
    options:
      - "✅ Yes — all clear, start development"
      - "⚠️  Some blockers remain — list them below"
    allowFreeformInput: true

  - header: "coding-conventions"
    question: "Any project-specific coding conventions or patterns to follow beyond defaults?"
    placeholder: "e.g. PEP8 + type hints enforced, React functional components only, no any types"
    allowFreeformInput: true
```

If any blockers remain: do NOT start. Ask the user to resolve blockers first. Re-check with:
```
vscode_askQuestions:
  header: "blockers-resolved"
  question: "Are the listed blockers now resolved?"
  options: ["Yes — start development", "No — still waiting"]
```

### Per-Task Development Loop

For every task in the impl-plan:

1. **Announce task:** `▶ Task {ID}: {title} [{estimate}hrs]`
2. **TDD workflow:** RED → GREEN → REFACTOR
3. **QA gate after each task** (spawn QA sub-agent, max 3 retries)
4. **Update dev log** with: task ID, status, test results, time spent
5. **Ask to continue:**
   ```
   vscode_askQuestions:
     header: "next-task-{ID}"
     question: "Task {ID} — {title} is COMPLETE. Tests: {x}/{x} passing.
                Next task: {ID+1} — {next-title}
                Continue?"
     options:
       - "▶ Continue to next task"
       - "⏸  Pause development here"
       - "🔁 This task needs revision"
   ```

### Dev Log Format (update after each task)

```markdown
# Dev Log: {project}
**Phase:** 4 — Development
**Started:** {date}

## Task Log
| Task ID | Title | Status | Tests | Notes |
|---------|-------|--------|-------|-------|
| TASK-001 | ... | ✅ Complete | 5/5 | ... |
| TASK-002 | ... | 🔄 In Progress | - | ... |

## Sprint Progress
Sprint 1: {X}/{N} tasks complete
```

Save running log to: `.maid/dev/YYYY-MM-DD-{project}-dev-log.md` (update after each task)

### Phase Gate (after all tasks)

```
vscode_askQuestions:
  header: "phase-4-gate"
  question: "Development complete:
             - {N}/{N} tasks done
             - All tests passing
             - Dev log saved to .maid/dev/
             Ready for QA?"
  options:
    - "✅ Approve — Advance to Phase 5: QA & Ship"
    - "🔁 Some tasks need revision"
```

Develop all sprints one by one. Do not stop until completion of all sprints.

---

## Phase 5: QA & Ship

**Purpose:** Validate implementation meets all acceptance criteria, then ship.
**Output:** `.maid/qa/YYYY-MM-DD-{project}-qa-report.md`
**Entry check:** `.maid/dev/` contains dev log with all tasks complete.
**Load skill:** `MAID-qa-ship`
**Next phase:** Phase 6 — User Feedback (after ship)

### QA Questions (call `vscode_askQuestions` once at phase start)

```yaml
questions:
  - header: "staging-ready"
    question: "Is staging/test environment ready for QA?"
    options: ["Yes — staging is live", "No — need to deploy staging first"]
    allowFreeformInput: true

  - header: "test-coverage"
    question: "What is the current test coverage? Are all PRD acceptance criteria covered?"
    placeholder: "e.g. 87% coverage, all 12 acceptance criteria verified manually"
    allowFreeformInput: true

  - header: "known-bugs"
    question: "Any known bugs or issues going into QA?"
    placeholder: "e.g. Minor mobile UI glitch tracked as TASK-042 (non-blocking)"
    allowFreeformInput: true
```

### QA Checklist (run automatically, show results)

Run through and display the full `MAID-qa-ship` checklist:

```
Functional:
  [ ] All user stories from PRD verified
  [ ] All acceptance criteria tested (Given/When/Then)
  [ ] Error/edge cases from PRD covered
  [ ] Cross-device/browser tested (if applicable)

Non-Functional:
  [ ] Performance targets met
  [ ] Security scan passed
  [ ] No hardcoded credentials in codebase
  [ ] Accessibility checked (if applicable)

Code Quality:
  [ ] All tests pass (npm test / pytest)
  [ ] Tests pass in random order
  [ ] No regressions (all existing tests pass)
  [ ] Tests verified to catch real bugs (mutation test)

Release Readiness:
  [ ] Rollback plan documented
  [ ] Monitoring configured
  [ ] Release notes prepared
  [ ] Stakeholder approval obtained
```

Show this checklist to the user. For any unchecked items, ask:
```
vscode_askQuestions:
  header: "qa-checklist-gaps"
  question: "The following QA items are unverified: {list}
             How would you like to proceed?"
  options:
    - "✅ All items are verified — I confirm"
    - "⚠️  Mark as accepted risk and proceed"
    - "❌ Block release — fix these first"
```

### ⚠️ SHIP GATE — MANDATORY (non-bypassable)

**This is the only action in the entire orchestrator that requires typing a specific phrase.**

BEFORE any deployment action, present this gate using `vscode_askQuestions`:

```
vscode_askQuestions:
  header: "ship-gate"
  question: "⚠️  SHIP GATE — EXPLICIT APPROVAL REQUIRED

             Project:  {project}
             Phase:    5 — QA & Ship
             Tasks:    {N}/{N} complete
             QA Score: {score}/10

             You are about to ship this to PRODUCTION.
             This action is irreversible.

             To confirm: select 'SHIP IT' below.
             To cancel: select 'Cancel — review something first'."
  options:
    - "🚀 SHIP IT"
    - "❌ Cancel — I need to review something first"
```

**Rules:**
- Only proceed if user selects "🚀 SHIP IT"
- On cancel: ask `vscode_askQuestions` → "What do you need to review? (describe the issue)"
  - Resolve it, then re-present the SHIP GATE
- Never auto-select, skip, or bypass this gate
- Log every ship gate attempt in the QA report

### Post-Ship

1. Save QA report to `.maid/qa/YYYY-MM-DD-{project}-qa-report.md`
2. Update `.maid/state.json`:
   ```json
   "current_phase": 5,
   "phase_name": "shipped",
   "phases.5.status": "complete",
   "phases.5.shipped_at": "{YYYY-MM-DD}"
   ```
3. Print release summary:
   ```
   ✅ SHIPPED: {project}
   Date: {YYYY-MM-DD}
   Tasks: {N}/{N}
   Phases: Discovery ✅ PRD ✅ Tech Spec ✅ Impl Plan ✅ Dev ✅ QA ✅
   Deliverables saved in .maid/
   ```
4. Immediately transition to Phase 6 — ask for feedback:
   ```yaml
   vscode_askQuestions:
     header: "post-ship-feedback"
     question: "The build has shipped. Ready to collect user feedback and close the loop?"
     options:
       - "▶ Yes — start feedback session now"
       - "⏸  Skip for now — collect feedback later"
   ```
   On "Yes": advance to **Phase 6: User Feedback**.
   On "Skip": save state, notify user they can resume feedback with `/feedback` or `/MAID-start`.

---

## Phase 6: User Feedback

**Purpose:** Collect structured feedback on the shipped build, triage issues, implement fixes, and confirm all items are resolved or deferred.
**Output:** `.maid/feedback/YYYY-MM-DD-{project}-feedback.md`
**Entry check:** Phase 5 complete and build shipped.
**Load skill:** `MAID-user-feedback`

### Questions (call `vscode_askQuestions` once to collect all initial feedback)

```yaml
questions:
  - header: "feedback-items"
    question: "List every issue, observation, or change request you have after using the build.
               One item per line — include everything, don't self-filter."
    placeholder: |
      e.g.
      1. Save button doesn't work on mobile
      2. Loading spinner shows too long
      3. Login flow feels confusing
    allowFreeformInput: true

  - header: "severity-overall"
    question: "Overall — how critical is this feedback?"
    options:
      - "🔴 Blockers present — cannot accept this build"
      - "🟡 Issues present — needs fixes before sign-off"
      - "🟢 Minor polish only — mostly satisfied"

  - header: "context"
    question: "Where was this feedback captured?"
    placeholder: "e.g. Internal demo on staging, real user session on prod, accessibility audit"
    allowFreeformInput: true
```

### Per-Item Fix Loop

For every non-deferred, in-scope feedback item:

1. Triage the item (Bug / UX / Polish / Out of Scope)
2. Implement fix (bugs: RED test first → GREEN fix → REFACTOR)
3. Confirm with user:
   ```yaml
   vscode_askQuestions:
     header: "fix-confirm-{N}"
     question: "Item #{N} — '{description}' fixed.\nChange: {summary}.\nDoes this resolve the issue?"
     options:
       - "✅ Yes — resolved"
       - "🔁 Not quite — describe what's still wrong"
       - "🔜 Defer to next sprint"
   ```
4. After each item: update feedback log at `.maid/feedback/YYYY-MM-DD-{project}-feedback.md`

### Resolution Check (mandatory — no exceptions)

After all current items are handled:

```yaml
vscode_askQuestions:
  header: "more-feedback"
  question: "All triaged items are resolved or deferred. Any additional feedback?"
  options:
    - "✅ No — all good, I'm satisfied"
    - "➕ Yes — I have more feedback"
    - "🔜 Pause — revisit deferred items later"
```

- **More feedback** → return to collection step
- **No** → proceed to phase gate

### Phase Gate

```yaml
vscode_askQuestions:
  header: "phase-6-gate"
  question: "Feedback session complete.\n- ✅ Fixed: {N} items\n- 🔜 Deferred: {N} items\n- 🚫 Out of Scope: {N} items\nReport saved to .maid/feedback/\nAre you satisfied with the current state of the build?"
  options:
    - "✅ Yes — build accepted"
    - "➕ More feedback to raise"
    - "🔜 Accepted with deferred items noted for next sprint"
```

Update `.maid/state.json` on completion:
```json
"current_phase": 6,
"phase_name": "user-feedback",
"phases.6.status": "complete",
"phases.6.completed_at": "YYYY-MM-DD"
```

Print final summary:
```
✅ CYCLE COMPLETE: {project}
Phases: Discovery ✅ PRD ✅ Tech Spec ✅ Impl Plan ✅ Dev ✅ QA ✅ Feedback ✅
Fixed: {N} | Deferred: {N} | Out of Scope: {N}
All deliverables in .maid/
```

---

## State Management

### state.json Schema (for new projects)

```json
{
  "project": "{slugified-name}",
  "project_display": "{human-readable name}",
  "version": "1.0.0",
  "initialized_at": "YYYY-MM-DD",
  "current_phase": 0,
  "phase_name": "discovery",
  "phase_approved": false,
  "system_mode": "STRICT",
  "phases": {
    "0": {"name": "discovery",  "status": "in_progress", "started_at": "YYYY-MM-DD"},
    "1": {"name": "prd",        "status": "not_started"},
    "2": {"name": "tech-spec",  "status": "not_started"},
    "3": {"name": "impl-plan",  "status": "not_started"},
    "4": {"name": "development","status": "not_started"},
    "5": {"name": "qa-ship",      "status": "not_started"},
    "6": {"name": "user-feedback", "status": "not_started"}
  }
}
```

Update `.maid/state.json` at each phase completion — never let it fall out of sync.

### File Map

| Phase | Output Path |
|-------|-------------|
| 0 Discovery | `.maid/discovery/YYYY-MM-DD-{project}-discovery.md` |
| 1 PRD | `.maid/prd/YYYY-MM-DD-{project}-prd.md` |
| 2 Tech Spec | `.maid/tech-spec/YYYY-MM-DD-{project}-tech-spec.md` |
| 3 Impl Plan | `.maid/impl-plan/YYYY-MM-DD-{project}-impl-plan.md` |
| 4 Dev | `.maid/dev/YYYY-MM-DD-{project}-dev-log.md` |
| 5 QA | `.maid/qa/YYYY-MM-DD-{project}-qa-report.md` |
| 6 Feedback | `.maid/feedback/YYYY-MM-DD-{project}-feedback.md` |

---

## Phase Gate Summary

| Gate | Requirement | Approval Mechanism |
|------|-------------|--------------------|
| 0 → 1 | Discovery doc saved, Go decision made | `vscode_askQuestions` approval |
| 1 → 2 | PRD saved, all stories have ACs | `vscode_askQuestions` approval |
| 2 → 3 | Tech spec saved, data models defined | `vscode_askQuestions` approval |
| 3 → 4 | Impl plan saved, contradictions resolved | `vscode_askQuestions` approval |
| 4 → 5 | All tasks complete, tests passing | `vscode_askQuestions` approval |
| SHIP | QA complete, explicit confirmation | `vscode_askQuestions` "🚀 SHIP IT" option || 5 → 6 | Build shipped, user prompted | Auto-transition after post-ship prompt |
| 6 CLOSE | All feedback resolved or deferred, user satisfied | `vscode_askQuestions` phase-6-gate |
---

## Anti-Patterns

| Anti-Pattern | Prevention |
|--------------|------------|
| Skipping a phase | Always check state.json — refuse to skip out of order |
| Assuming answers | Never synthesize without asking; questions first |
| Phase 5 without approval | SHIP GATE is mandatory and non-bypassable |
| Partial deliverables | Never save an incomplete file — full template required |
| Moving on "changes requested" | Only advance on explicit approval option |
| Advance without saving | Always save file BEFORE showing the gate question |

---

## Handoff Checklist

- [ ] All 7 phase deliverables saved to correct `.maid/` subfolders
- [ ] `.maid/state.json` updated with all phases complete and `shipped_at` date
- [ ] SHIP GATE explicitly approved via `vscode_askQuestions`
- [ ] Feedback phase entered after ship (or explicitly deferred by user)
- [ ] All feedback items resolved or deferred with user confirmation
- [ ] Resolution check loop ran — user confirmed "no more feedback"
- [ ] Feedback report saved to `.maid/feedback/`
- [ ] Release summary printed to user
- [ ] Quality check passed (≥7.0) for each major deliverable

---

## References

| File | When to Read |
|------|--------------|
| `.github/skills/0-maid-discovery/SKILL.md` | Phase 0 — discovery questions + SCQ format |
| `.github/skills/1-maid-prd/SKILL.md` | Phase 1 — PRD template + user story format |
| `.github/skills/2-maid-tech-spec/SKILL.md` | Phase 2 — tech spec template + API contract format |
| `.github/skills/3-maid-impl-plan/SKILL.md` | Phase 3 — contradiction resolution + task breakdown |
| `.github/skills/4-maid-development/SKILL.md` | Phase 4 — TDD workflow + QA gate per task |
| `.github/skills/5-maid-qa-ship/SKILL.md` | Phase 5 — QA checklist + release process |
| `.github/skills/6-maid-user-feedback/SKILL.md` | Phase 6 — feedback collection + fix loop |
| `.maid/state.json` | Current phase and project state |
