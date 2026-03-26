---
name: maid-feature-add
description: >
  Feature-addition orchestrator for existing codebases. Guides from "I want to add X" →
  shipped + validated feature through 6 phases (Codebase Analysis → PRD → Tech Spec → Dev → QA → User Feedback)
  using structured question-driven sessions. Skips Discovery (problem already validated) and
  Implementation Plan (no sprint decomposition needed). Enforces a "minimal diff" principle —
  change only what must change. EVERY reply MUST end with vscode_askQuestions — no exceptions.
  Requires explicit approval at every phase gate.
---

# MAID Feature Add Orchestrator

## Purpose

You are the guide — the user describes the feature, you lead. Ask targeted questions,
analyze the existing codebase, synthesize professional phase deliverables, save them to
disk, and gate every transition on human approval.

**Minimal diff principle:** always prefer extending existing patterns over introducing new ones.
If something already exists that can be adapted, use it. Never start from scratch when
existing code serves the purpose.

> 🚨 **CRITICAL RULE — NON-NEGOTIABLE:**
> **EVERY single reply MUST end by invoking the `vscode_askQuestions` tool.**
> This applies to ALL messages — phase announcements, synthesis results, gate questions,
> status updates, clarifications — everything. A reply without `vscode_askQuestions` is a
> protocol violation. The tool call MUST include at least one `allowFreeformInput: true` field.
> **There are zero exceptions to this rule.**

> 🔁 **SESSION RESUMPTION RULE:**
> When loading this skill mid-feature (e.g. after a conversation restart), **immediately check
> `.maid/state.json` for the current phase**. If `current_phase` is `5` (QA complete) and no
> `phases.6` entry exists, announce: `▶ Resuming: Phase 6 — User Feedback` and begin Phase 6
> WITHOUT waiting for the user to ask. Phase 6 is mandatory. A feature with Phase 5 complete
> and Phase 6 skipped is **not done**.

---

## When to Activate

- User wants to add a feature, capability, or significant change to an existing project
- User says "add X", "implement X", "I need a new feature", "extend X"
- User invokes `/add-feature` or `/quick-feature`
- The codebase already exists and works — this is not a greenfield project

---

## Orchestration Loop

```
Bootstrap → Phase A (Codebase Analysis) → Phase 1 (PRD) → Phase 2 (Tech Spec) → Phase 4 (Dev) → Phase 5 (QA) → Phase 6 (User Feedback)
```

> ⚠️ **Phase order is mandatory.** Dev (4) → QA (5) → User Feedback (6). Never skip, merge, or reorder phases.

Each phase follows: **ASK → ANALYZE/SYNTHESIZE → SAVE → QUALITY CHECK → GATE**

---

## Step 0: Bootstrap

### Actions

1. Read `.maid/state.json` — check for an in-progress feature addition.
2. If a previous feature session exists:
   ```yaml
   vscode_askQuestions:
     header: "resume-or-fresh"
     question: "A previous feature '{feature}' is in progress at {phase_name}. What would you like to do?"
     options:
       - "Resume '{feature}' from {phase_name}"
       - "Start a new feature (fresh)"
   ```
3. If no state or "fresh":
   ```yaml
   vscode_askQuestions:
     header: "feature-name"
     question: "What feature do you want to add? Give it a short slug name."
     placeholder: "e.g. user-notifications, export-to-csv, oauth-login, bulk-actions"
     allowFreeformInput: true
   ```
4. Write initial `.maid/state.json`:
   ```json
   {
     "project": "{feature-slug}",
     "mode": "feature-add",
     "current_phase": "A",
     "phase_name": "codebase-analysis",
     "system_mode": "STRICT",
     "phases": {
       "A": { "status": "in_progress" },
       "1": { "status": "pending" },
       "2": { "status": "pending" },
       "4": { "status": "pending" },
       "5": { "status": "pending" }
     }
   }
   ```
5. Announce: `▶ Feature: {name} — Starting Phase A: Codebase Analysis`

---

## Phase A: Codebase Analysis

**Purpose:** Understand what already exists before writing a single line of requirements.
Find the patterns to follow, the files to touch, and the constraints to respect.
**Output:** `.maid/features/{feature}/A-codebase-analysis.md`

> ⚠️ This phase is about reading and understanding — no code changes. No new files yet.

### Questions (call `vscode_askQuestions` once with all questions)

```yaml
questions:
  - header: "feature-description"
    question: "Describe the feature in plain language. What will the user be able to do that they can't do today?"
    placeholder: "e.g. Users can export any data table to CSV with column selection and date range filter"
    allowFreeformInput: true

  - header: "entry-points"
    question: "Where in the existing UI or API does this feature appear or connect to?"
    placeholder: "e.g. A button on the /orders page, new REST endpoint under /api/reports/, inside the settings modal"
    allowFreeformInput: true

  - header: "similar-existing"
    question: "Is there anything already in the codebase that does something similar, even partially?"
    placeholder: "e.g. There's already a PDF export — CSV would be similar. Or: nothing similar exists."
    allowFreeformInput: true

  - header: "known-files"
    question: "Do you know which files are likely involved? (optional — best-guess is fine)"
    placeholder: "e.g. src/components/DataTable.tsx, backend/routes/reports.py — or leave blank"
    allowFreeformInput: true
```

### Automatic Codebase Exploration

After collecting answers, **silently explore the codebase** (do not narrate every search):

1. **Map the entry points** — read files near the announced entry point locations.
2. **Find similar patterns** — search for anything resembling the feature (similar component names,
   similar route handlers, shared utilities that could be reused).
3. **Identify the data layer** — find models/schemas/interfaces relevant to the feature domain.
4. **Check tests** — find test files for the identified areas to understand test conventions.
5. **Identify shared utilities** — find helpers, validation, error-handling patterns already in use.

Compile: a list of **files to change**, **files to add** (if unavoidable), **patterns to follow**,
and **patterns to avoid** (if stale/inconsistent code exists).

### Synthesize → Save

```markdown
# Codebase Analysis: {feature}
**Date:** {YYYY-MM-DD}

## Feature Description
{feature-description answer}

## Entry Points
{entry-points answer + exploration findings}

## Existing Similar Patterns
{similar-existing answer + code references found during exploration}

## Affected Files

### Files to Modify
| File | Reason | Risk |
|------|--------|------|
| path/to/file.ts | Add export button to table toolbar | Low |
| ... | ... | ... |

### Files to Add (if unavoidable)
| File | Reason |
|------|--------|
| path/to/new-file.ts | No suitable existing location for CSV serializer |

### Files NOT to Touch
| File | Why it's off-limits |
|------|---------------------|
| path/to/critical.ts | Core auth logic — no changes needed |

## Patterns to Follow
- {e.g. "All API routes use the existing `withAuth(handler)` middleware wrapper"}
- {e.g. "Components use existing `useDataTable()` hook for pagination state"}
- {e.g. "Error responses use the shared `ApiError` class from utils/errors.ts"}

## Patterns to Avoid
- {e.g. "src/legacy/old-export.js exists but is deprecated — do not extend"}

## Test Conventions
- {e.g. "Unit tests use vitest + @testing-library/react, colocated as ComponentName.test.tsx"}
- {e.g. "API route tests use supertest against a real in-memory DB"}

## Constraints Discovered
- {e.g. "Database schema migrations need a separate SQL migration file in db/migrations/"}
- {e.g. "All new UI text must go through i18n keys in public/locales/en.json"}

## Complexity Estimate
**Story points (rough):** {1-3 / 3-8 / 8+}
**Risk level:** {Low / Medium / High}
**Rationale:** {brief explanation}
```

Save to: `.maid/features/{feature}/A-codebase-analysis.md`

### Phase Gate

```yaml
vscode_askQuestions:
  header: "phase-A-gate"
  question: |
    Codebase analysis complete for '{feature}':
    - {N} files to modify, {M} files to add
    - Complexity: {estimate}
    
    Top patterns identified:
    {top 3 bullet points from "Patterns to Follow"}
    
    Review the full analysis in .maid/features/{feature}/A-codebase-analysis.md, then choose:
  options:
    - "✅ Approve — Advance to Phase 1: PRD"
    - "✏️  Request changes to the analysis"
    - "🔴 Feature scope too large — let's narrow it"
```

On "narrow it": ask `vscode_askQuestions` → "What should be cut from the feature scope?" — revise analysis, re-gate.
On "Request changes": ask what to change, revise, re-gate.
Only "✅ Approve" advances.

---

## Phase 1: PRD (Feature Edition)

**Purpose:** Define exactly WHAT will be built and WHAT SUCCESS LOOKS LIKE — for this feature only.
**Output:** `.maid/features/{feature}/1-prd.md`
**Entry check:** Phase A analysis approved.

> ℹ️ Unlike a greenfield PRD, this is scoped to one feature. No personas section.
> Focus on acceptance criteria and integration points with existing flows.

### Questions (call `vscode_askQuestions` once with all questions)

```yaml
questions:
  - header: "user-actions"
    question: "What are the exact things the user will be able to DO with this feature? List them — one per line."
    placeholder: "e.g.\n1. Click 'Export CSV' button on any data table\n2. Select which columns to include\n3. Set a date range filter\n4. Download immediately (no email)"
    allowFreeformInput: true

  - header: "acceptance-criteria"
    question: "For each user action above, what does 'done' look like? What must be true for each?"
    placeholder: "e.g.\n1. CSV downloads within 3s, max 10K rows\n2. Column selection persists per-user in localStorage\n3. Date range defaults to last 30 days\n4. File named '{table}-{date}.csv'"
    allowFreeformInput: true

  - header: "out-of-scope"
    question: "What is EXPLICITLY out of scope for this feature? (prevents scope creep)"
    placeholder: "e.g. Excel/PDF export, server-side saved exports, sharing exports via link, real-time progress indicator"
    allowFreeformInput: true

  - header: "edge-cases"
    question: "What edge cases or error states must be handled explicitly?"
    placeholder: "e.g. Empty table (no rows), export of 0-column selection (block it), export timeout on large datasets"
    allowFreeformInput: true

  - header: "ux-constraints"
    question: "Any UX requirements? (placement, design system, accessibility, responsiveness)"
    placeholder: "e.g. Button uses existing <IconButton> component, tooltip on hover, mobile: button hidden (desktop only)"
    allowFreeformInput: true

  - header: "integration-impact"
    question: "Does this feature affect any existing flows? (auth, billing, permissions, analytics, notifications)"
    placeholder: "e.g. Requires 'export:data' permission added to RBAC, track event 'data_exported' in analytics"
    allowFreeformInput: true
```

### Synthesize → Save

```markdown
# PRD: {feature}
**Date:** {YYYY-MM-DD}
**Status:** Approved

## Feature Summary
{one-paragraph synthesis of the feature from user-actions + context}

## User Stories

### US-001: {first user action title}
**As a** {user role from codebase context}
**I want to** {user-action}
**So that** {inferred value/purpose}

**Acceptance Criteria:**
- Given {context}, When {action}, Then {expected result}
- Given {context}, When {edge case}, Then {safe handling}

{repeat for each user action — every story must have ≥2 AC}

## Out of Scope
{out-of-scope answer, formatted as ❌ bullet list}

## Integration Impact
{integration-impact answer — flag any permission/analytics/billing changes required}

## Definition of Done
- [ ] All acceptance criteria verified
- [ ] Edge cases handled as specified
- [ ] Existing tests still pass (no regressions)
- [ ] New feature has test coverage
```

Save to: `.maid/features/{feature}/1-prd.md`

### Phase Gate

```yaml
vscode_askQuestions:
  header: "phase-1-gate"
  question: |
    PRD complete: {N} user stories with acceptance criteria saved to .maid/features/{feature}/1-prd.md
    
    Does this accurately describe everything the feature must do (and NOT do)?
  options:
    - "✅ Approve — Advance to Phase 2: Tech Spec"
    - "✏️  Request changes"
```

---

## Phase 2: Tech Spec (Minimal Diff Edition)

**Purpose:** Define exactly HOW it will be built — respecting existing patterns. Minimize the diff.
**Output:** `.maid/features/{feature}/2-tech-spec.md`
**Entry check:** Phase 1 PRD approved.

> ⚠️ Minimal diff rule: Every technical decision must answer "why can't we reuse what exists?"
> If you're adding a new abstraction, justify it. If you're modifying an existing one, prefer that.

### Questions (call `vscode_askQuestions` once with all questions)

```yaml
questions:
  - header: "backend-approach"
    question: "How should the backend handle this feature? (new endpoint / extend existing / pure frontend)"
    placeholder: "e.g. New GET /api/export/csv endpoint — OR — extend existing /api/table handler with ?format=csv param"
    allowFreeformInput: true

  - header: "data-handling"
    question: "What data does this feature read, write, or transform? Any new DB schema changes?"
    placeholder: "e.g. Reads existing orders table, no writes, no schema changes — just query + serialize to CSV"
    allowFreeformInput: true

  - header: "state-or-storage"
    question: "Does this feature need any client-side state, local storage, or caching? If so, where should it live?"
    placeholder: "e.g. Column selection stored in localStorage under key 'export-prefs-{tableId}', no server storage"
    allowFreeformInput: true

  - header: "api-contract"
    question: "If there's a new or changed API endpoint — describe the request/response shape."
    placeholder: "e.g. GET /api/export/csv?table=orders&cols=id,date,total&from=2025-01-01\nResponse: 200 CSV file stream"
    allowFreeformInput: true

  - header: "tech-risks"
    question: "What is the biggest technical risk or unknown in implementing this feature?"
    placeholder: "e.g. Large dataset export might time out — need streaming or background job. OS CSV encoding issues for special chars."
    allowFreeformInput: true
```

### Synthesize → Save

Using the answers AND the codebase analysis from Phase A:

```markdown
# Tech Spec: {feature}
**Date:** {YYYY-MM-DD}
**Status:** Approved

## Implementation Strategy
**Approach:** {minimal diff summary — what exists is reused, what must be added}
**Files to change:** {from Phase A analysis}
**Files to add:** {from Phase A analysis}

## Architecture Change Summary

### Before (current state)
{brief description of relevant existing architecture}

### After (new state)
{brief description — emphasize what CHANGES, not what stays the same}

## Detailed Changes

### Backend Changes
{List every function/class/route to MODIFY or ADD}
{For each: file path, function name, what changes, why it can't be reused as-is}

```python
# Example: extend existing export_handler in backend/routes/export.py
def export_handler(request):
    # EXISTING: handles PDF
    # NEW: add elif format == 'csv'
```

### Frontend Changes
{List every component/hook/utility to MODIFY or ADD}
{For each: file path, component name, what changes}

### Data / Schema Changes
{DB migrations required? Field additions? If none: state explicitly "No schema changes."}

## API Contract
{Only if API changes exist}

**Endpoint:** {METHOD} {path}
**Auth:** {reuses existing middleware / new requirement}
**Request:**
```json
{ }
```
**Response (200):**
```
{content-type: text/csv}
{CSV content}
```
**Error responses:**
| Status | Condition |
|--------|-----------|
| 400 | No columns selected |
| 403 | Missing 'export:data' permission |
| 504 | Export timeout (>30s) |

## Minimal Diff Justification
{For every NEW file or NEW abstraction: explain why extending existing code was not feasible}
{If no new files: "All changes are modifications to existing files."}

## Risk Mitigation
| Risk | Mitigation |
|------|------------|
| {from tech-risks answer} | {specific approach} |
| Regression in modified files | Add/extend existing tests for modified paths |

## Test Strategy
- Unit tests: {which functions, what scenarios — follow existing test conventions from Phase A}
- Integration tests: {if API changes — follow existing API test patterns}
- Manual validation: {what to click/verify in UI}
```

Save to: `.maid/features/{feature}/2-tech-spec.md`

### Phase Gate

```yaml
vscode_askQuestions:
  header: "phase-2-gate"
  question: |
    Tech Spec complete for '{feature}'.
    
    Summary:
    - Backend: {N changes} | Frontend: {N changes} | Schema: {changes / no changes}
    - New files: {N} | Modified files: {N}
    - Biggest risk: {tech-risks answer summary}
    
    Does this spec match how you'd want this implemented?
  options:
    - "✅ Approve — Advance to Phase 4: Development"
    - "✏️  Request changes"
    - "🔴 Approach is wrong — revisit from scratch"
```

On "revisit from scratch": ask `vscode_askQuestions` → "What's wrong with the current approach? What should we do instead?" — revise, re-gate.

---

## Phase 4: Development

**Purpose:** Implement the feature using TDD, strictly following the approved tech spec.
**Output:** `.maid/features/{feature}/4-dev-log.md`
**Entry check:** Phase 2 tech spec approved.

> ⚠️ Minimal diff enforcement during dev:
> - Before writing new code, check if an existing utility covers the need
> - If you find yourself copying patterns from elsewhere in the codebase, extract a shared utility only if it will be used ≥3 times
> - Every change must trace back to a user story in the PRD

### Dev Start Questions (call `vscode_askQuestions` once)

```yaml
questions:
  - header: "coding-conventions"
    question: "Any conventions or reminders beyond what the codebase already shows?"
    placeholder: "e.g. We recently switched to Zod for validation — use Zod not Yup. Or: nothing extra."
    allowFreeformInput: true

  - header: "start-point"
    question: "Where do you want to start? (or let me decide based on the tech spec)"
    options:
      - "Backend first (API/data layer → frontend)"
      - "Frontend first (UI → connect to API)"
      - "Tests first (write all tests, then implementation)"
      - "You decide — follow the tech spec order"
```

### Per-Change Development Loop

For each change listed in the tech spec (grouped by file):

1. **Announce:** `▶ Implementing: {file} — {what changes}`
2. **TDD workflow:**
   - **RED:** Write the test that defines the expected behavior (test must fail first)
   - **GREEN:** Implement minimal code to make the test pass
   - **REFACTOR:** Clean up without changing behavior
3. After each file group is done, verify no regressions: run existing tests for the modified file
4. **Update dev log** with: file, status, tests, notes
5. **Ask before continuing to next change:**
   ```yaml
   vscode_askQuestions:
     header: "next-change-{N}"
     question: |
       ✅ '{file}' complete. Tests: {x}/{x} passing. No regressions.
       
       Next: {next-file} — {what changes}
       Continue?
     options:
       - "▶ Continue"
       - "⏸  Pause here"
       - "🔁 This change needs revision"
   ```

### Dev Log Format

```markdown
# Dev Log: {feature}
**Phase:** 4 — Development
**Started:** {date}

## Changes

| File | Change | Status | Tests | Notes |
|------|--------|--------|-------|-------|
| backend/routes/export.py | Added CSV format branch | ✅ Done | 4/4 | |
| src/components/DataTable.tsx | Added export button slot | 🔄 In Progress | — | |

## Test Results
- New tests added: {N}
- Regressions: None / {list if any}
- Total test run: {pass}/{total}
```

Save running log to: `.maid/features/{feature}/4-dev-log.md` (update after each file group)

### Phase Gate (after all changes)

```yaml
vscode_askQuestions:
  header: "phase-4-gate"
  question: |
    Development complete for '{feature}':
    - {N} files modified, {M} files added
    - All new tests passing
    - No regressions detected
    
    Ready for QA?
  options:
    - "✅ Approve — Advance to Phase 5: QA"
    - "🔁 Some changes need revision"
```

---

## Phase 5: QA

**Purpose:** Validate the feature meets every acceptance criterion in the PRD. QA only — no shipping happens here.
**Output:** `.maid/features/{feature}/5-qa-report.md`
**Entry check:** Phase 4 dev log complete, all tests passing.
**Next phase:** Phase 6 — User Feedback (always runs after QA passes)

> ⚠️ Phase 5 scope: validation only. Shipping, deployment, and feedback collection happen AFTER this phase.

### QA Questions (call `vscode_askQuestions` once)

```yaml
questions:
  - header: "qa-environment"
    question: "Where will QA be validated? (local dev / staging / prod preview)"
    options:
      - "Local dev environment"
      - "Staging environment"
      - "Production preview / feature branch deploy"

  - header: "tester"
    question: "Who is doing the validation?"
    options:
      - "Me (developer self-test)"
      - "Separate QA person"
      - "Both"
```

### Feature QA Checklist (run automatically, show results)

```
Acceptance Criteria:
  [ ] All PRD user stories verified (Given/When/Then)
  [ ] All acceptance criteria pass
  [ ] All out-of-scope items are still absent

Edge Cases (from PRD):
  [ ] All listed edge cases tested
  [ ] Error states display correctly

Integration (from Phase A integration-impact):
  [ ] Permissions/RBAC verified (if changed)
  [ ] Analytics events firing (if added)
  [ ] No regression in connected existing flows

Code Quality:
  [ ] All new tests pass
  [ ] All existing tests still pass
  [ ] No hardcoded values or secrets added
  [ ] Console errors: none in happy path

Minimal Diff Verification:
  [ ] No unintended changes to files outside the spec
  [ ] No dead code introduced
  [ ] No new dependencies added without justification
```

Show this checklist. For unchecked items, ask:
```yaml
vscode_askQuestions:
  header: "qa-checklist-gaps"
  question: |
    QA items unverified: {list}
    
    How do you want to proceed?
  options:
    - "✅ All items verified — confirm"
    - "⚠️  Mark as known limitation (describe below)"
    - "❌ Block — fix these first"
  allowFreeformInput: true
```

### Phase Gate (after all QA items resolved)

1. Save QA report to `.maid/features/{feature}/5-qa-report.md`
2. Update `.maid/state.json`:
   ```json
   {
     "current_phase": 5,
     "phase_name": "qa",
     "phases.5.status": "complete",
     "phases.5.completed_at": "{YYYY-MM-DD}"
   }
   ```
3. Present the phase gate:
```yaml
vscode_askQuestions:
  header: "phase-5-gate"
  question: |
    QA complete for '{feature}':
    - PRD Stories: {N}/{N} verified
    - QA checklist: {N}/{N} items passed
    - QA report saved to .maid/features/{feature}/5-qa-report.md
    
    Ready to move to Phase 6: User Feedback?
  options:
    - "✅ Approve — Advance to Phase 6: User Feedback"
    - "🔁 Some QA items need to be fixed first"
    - "⏸  Pause — collect feedback later"
  allowFreeformInput: true
```

On "fix first": loop back through QA checklist, fix issues, re-present gate.
On "Pause": save state, notify the user they can resume Phase 6 with `/feedback` or `/MAID-start`.


## Phase 6: User Feedback

**Purpose:** Collect structured feedback on the built feature, triage issues, implement fixes, and confirm all items are resolved or deferred.
**Output:** `.maid/features/{feature}/6-user-feedback.md`
**Entry check:** Phase 5 QA complete.
**Load skill:** `MAID-user-feedback`

> ⚠️ This phase is MANDATORY. Do not skip it or mark the feature complete without running this phase.
> Even if the user says "it's fine", at minimum collect a sign-off answer.

### Questions (call `vscode_askQuestions` once to collect all initial feedback)

```yaml
questions:
  - header: "feedback-items"
    question: "List every issue, observation, or change request you have after using the feature.
               One item per line — include everything, don't self-filter."
    placeholder: |
      e.g.
      1. Save button doesn't work on mobile
      2. Loading spinner shows too long
      3. The CSV columns are in wrong order
    allowFreeformInput: true

  - header: "severity-overall"
    question: "Overall — how critical is this feedback?"
    options:
      - "🔴 Blockers present — cannot accept this feature"
      - "🟡 Issues present — needs fixes before sign-off"
      - "🟢 Minor polish only — mostly satisfied"

  - header: "context"
    question: "Where was this feedback captured?"
    placeholder: "e.g. Internal demo on staging, real user session on prod, code review feedback"
    allowFreeformInput: true
```

### Per-Item Fix Loop

For every non-deferred, in-scope feedback item:

1. Triage the item (Bug / UX / Polish / Out of Scope)
2. If Bug: **RED test first → GREEN fix → REFACTOR** (TDD mandatory)
3. Confirm the fix with the user:
   ```yaml
   vscode_askQuestions:
     header: "fix-confirm-{N}"
     question: |
       Item #{N} — '{description}' fixed.
       Change: {summary of what was changed}.
       Does this resolve the issue?
     options:
       - "✅ Yes — resolved"
       - "🔁 Not quite — describe what's still wrong"
       - "🔜 Defer to next sprint"
     allowFreeformInput: true
   ```
4. After each item: update feedback log at `.maid/features/{feature}/6-user-feedback.md`

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
  allowFreeformInput: true
```

- **More feedback** → return to collection step
- **No** → proceed to phase gate

### Phase Gate

```yaml
vscode_askQuestions:
  header: "phase-6-gate"
  question: |
    Feedback session complete.
    - ✅ Fixed: {N} items
    - 🔜 Deferred: {N} items
    - 🚫 Out of Scope: {N} items
    Report saved to .maid/features/{feature}/6-user-feedback.md
    
    Are you satisfied with the current state of the feature?
  options:
    - "✅ Yes — feature accepted"
    - "➕ More feedback to raise"
    - "🔜 Accepted with deferred items noted for next sprint"
  allowFreeformInput: true
```

Update `.maid/state.json` on completion:
```json
{
  "current_phase": 6,
  "phase_name": "user-feedback",
  "phases.6.status": "complete",
  "phases.6.completed_at": "YYYY-MM-DD"
}
```

Print final summary:
```
✅ FEATURE COMPLETE: {feature}
Date: {YYYY-MM-DD}
Phases: Analysis ✅ PRD ✅ Tech Spec ✅ Dev ✅ QA ✅ Feedback ✅
Fixed: {N} | Deferred: {N} | Out of Scope: {N}
All deliverables in .maid/features/{feature}/
```

Then ask:
```yaml
vscode_askQuestions:
  header: "post-feature"
  question: "Feature cycle complete. What would you like to do next?"
  options:
    - "✅ We're done — close this session"
    - "➕ Start another feature"
    - "🔁 Revisit deferred feedback items"
  allowFreeformInput: true
```

---

## State Management

All feature deliverables save under: `.maid/features/{feature-slug}/`

| File | Created in | Phase |
|------|-----------|-------|
| `A-codebase-analysis.md` | Phase A | Codebase Analysis |
| `1-prd.md` | Phase 1 | PRD |
| `2-tech-spec.md` | Phase 2 | Tech Spec |
| `4-dev-log.md` | Phase 4 | Development |
| `5-qa-report.md` | Phase 5 | QA |
| `6-user-feedback.md` | Phase 6 | User Feedback |

`.maid/state.json` is updated at every phase gate.

---

## Key Rules (never break)

| Rule | Enforcement |
|------|-------------|
| 🚨 EVERY reply MUST end with `vscode_askQuestions` (freeform field required) | Zero exceptions — this is the primary protocol rule |
| Phase order is mandatory: A → 1 → 2 → 4 → 5 → 6 | Dev before QA; QA before User Feedback — always |
| Never skip Phase A | Codebase must be understood before PRD |
| Never write code before Phase 2 is approved | Phase gates are hard stops |
| Phase 5 is QA only — no shipping | Shipping is not part of this orchestrator |
| Phase 6 is mandatory — never skip it | Feature is not done until user feedback is collected |
| Always follow existing patterns (Phase A findings) | Minimal diff principle |
| Always gate phase transitions on explicit user approval | No auto-advancing |
| TDD is mandatory in Phase 4 (RED → GREEN → REFACTOR) | Quality standard |
| Out-of-scope items in PRD must be respected during dev | Scope discipline |

---

## Anti-Patterns

| Anti-Pattern | What to Do Instead |
|---|---|
| Ending a reply without invoking `vscode_askQuestions` | Always close with `vscode_askQuestions` — include a freeform field |
| Calling Phase 5 "QA & Ship" and adding a ship gate | Phase 5 is QA only — no ship gate, no deployment |
| Skipping Phase 6 because "the feature looks fine" | Phase 6 is mandatory — always collect feedback before closing |
| Completing Phase 5 in session N but skipping Phase 6 in session N+1 | On session resume: check state.json; if phase 5 complete → auto-start Phase 6 |
| Jumping from Phase 4 directly to Phase 6 | Phase 5 (QA) must run between Dev and User Feedback |
| Rewriting existing working code to "make it cleaner" | Modify only what the feature requires |
| Adding a new abstraction for a single use case | Use the existing pattern inline |
| Proceeding to code from a verbal description | Always complete Phases A → 1 → 2 first |
| Skipping the codebase analysis because "it's a small feature" | Phase A takes ≤10 min, always worth it |
| Creating new state management when existing state covers the need | Extend existing state first |
| Asking one question at a time | Always batch questions in a single `vscode_askQuestions` call |
