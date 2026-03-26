---
name: 1-maid-prd
description: MAID Phase 1 - PRD creation. Use for user stories, acceptance criteria, scoping features, transitioning from discovery to tech spec.
---

# PRD Phase Skill

## Phase Overview

Purpose: Define what will be built with clarity for unambiguous development.

Entry: Discovery complete, problem validated, stakeholders identified
Exit: PRD complete, user stories with acceptance criteria, scope defined

## Deliverables

1. PRD Document - Readable by technical and non-technical
2. User Stories - "As a [role], I want [capability] so that [benefit]"
3. Acceptance Criteria - Given-When-Then, unambiguous, testable
4. Scope Definition - In-scope and out-of-scope explicit
5. Traceability - Every requirement links to research or flagged as assumption

## User Story Format

```markdown
### US-001: [Title]
**Research Backing**: [PROJECT]-A-INT-XXX OR ASSUMPTION - [rationale]

**As a** [role]
**I want** [capability]
**So that** [benefit]

**Acceptance Criteria:**
- [ ] Given [context], when [action], then [outcome]
```

## Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| Implementation in requirements | Keep focused on outcomes |
| Untestable criteria | "Should load in <2s" not "be fast" |
| Missing error cases | Define what happens when things fail |
| Scope creep | Explicit acknowledgment for additions |
| Orphan requirements | Link to research or flag assumption |

## Core Step: User-Flow Approval

**When to run**: After drafting user stories, before writing acceptance criteria.

### Process

1. **Identify all user flows** from the user stories — each meaningful path through the feature (happy path + key error/edge paths).
2. **Write each flow** in the PRD under a `## User Flows` section using the format below.
3. **Approve each flow one by one** with the user using `vscode_askQuestions`. Do NOT batch — one question per flow.
4. Only proceed to acceptance criteria once all flows are approved.

### Flow Format (write to PRD)

```markdown
## User Flows

### UF-001: [Flow Title]
**Trigger**: [What starts this flow]
**Actor**: [Who performs it]
**Steps**:
1. [Step]
2. [Step]
3. [Step]
**Expected Outcome**: [What success looks like]
**Error Paths**: [What can go wrong, and how it's handled]
```

### Approval Loop (per flow)

Use `vscode_askQuestions` for each flow:

```
Question: "UF-00X: [Flow Title]
[Steps as numbered list]
Outcome: [Expected Outcome]
Error: [Error Paths]

✅ Approve / ✏️ Change needed / ❌ Remove?"
```

- **Approved** → mark `[x]` in checklist, move to next flow
- **Change needed** → update flow, re-ask the same flow
- **Remove** → strike from PRD, note rationale, move to next

Do not move to the next flow until the current one is resolved.

---

## UX Vision Step *(run BEFORE writing acceptance criteria — for any project with a UI)*

Before locking acceptance criteria, run this structured interview. Record answers in the PRD under `## UX Vision`. This anchors all design decisions in Phase 2.

```
vscode_askQuestions — ask these one at a time or grouped:

1. header: "target-device"
   question: "Which devices must this work on?"
   options:
     - "Desktop only"
     - "Mobile only"
     - "Both (responsive)"
     - "Mobile-first responsive (mobile primary, desktop secondary)"

2. header: "visual-direction"
   question: "Describe the visual feel you're going for — pick a direction or describe it freely."
   options:
     - "Clean & minimal — lots of whitespace, simple typography"
     - "Bold & expressive — strong colors, distinctive fonts, personality"
     - "Professional / corporate — structured, trustworthy, neutral"
     - "Dark-mode first — sleek, modern, low-light"
     - "Playful / friendly — rounded, colorful, approachable"
     - "Custom — I'll describe it below"
   allowFreeformInput: true

3. header: "color-palette-direction"
   question: "Any color direction? (brand colors, palette preferences, or 'surprise me')"
   allowFreeformInput: true

4. header: "animations"
   question: "How much motion/animation should the UI have?"
   options:
     - "None — fast, static, no distractions"
     - "Subtle — micro-interactions only (hover states, focus rings)"
     - "Rich — smooth transitions, entrance animations, personality"

5. header: "accessibility-level"
   question: "Accessibility requirements?"
   options:
     - "WCAG AA (standard — 4.5:1 contrast, keyboard nav)"
     - "WCAG AAA (strict — enhanced contrast, full screen reader support)"
     - "Basic only (internal tool, controlled environment)"

6. header: "existing-design-system"
   question: "Is there an existing design system or component library to follow?"
   options:
     - "No — build from scratch"
     - "Yes — shadcn/ui"
     - "Yes — Material UI"
     - "Yes — another (type below)"
   allowFreeformInput: true
```

Record the answers in the PRD under:
```markdown
## UX Vision
- **Target devices**: [answer]
- **Visual direction**: [answer]
- **Color palette direction**: [answer]
- **Animation level**: [answer]
- **Accessibility target**: [answer]
- **Design system**: [answer]
```

This section is handed to Phase 2 (Tech Spec) as the input for the Frontend Architecture section.

---

## Phase Gate Checklist

- [ ] PRD document complete
- [ ] User flows identified and listed under `## User Flows`
- [ ] All user flows approved by user (one by one via vscode_askQuestions)
- [ ] **UX Vision section complete** (if project has UI)
- [ ] User stories proper format
- [ ] Every story has testable acceptance criteria
- [ ] Scope explicitly defined (in AND out)
- [ ] Dependencies identified
- [ ] Every requirement has research ID OR assumption flag
- [ ] Traceability matrix updated

## PRD Template

```markdown
# [Feature] PRD

## 1. Overview
### Problem Statement
[Problem] **Research**: [ID]

### Goals
[Goals] **Research**: [ID]

### Non-Goals
[Excluded items]

## 2. User Flows
<!-- One entry per flow, approved via vscode_askQuestions before acceptance criteria are written -->
### UF-001: [Flow Title]
**Trigger**: [What starts this flow]
**Actor**: [Who]
**Steps**: 1. ... 2. ... 3. ...
**Expected Outcome**: [Success]
**Error Paths**: [Failure handling]

## 3. User Stories
[Stories with research backing]

## 4. Scope
### In Scope
| Item | Research Backing |
|------|------------------|

### Out of Scope
| Item | Rationale |
|------|-----------|

## 4. Dependencies
## 5. UX Vision *(if project has a UI)*
- **Target devices**: [Desktop / Mobile / Responsive]
- **Visual direction**: [e.g. Clean & Minimal, Bold & Expressive, Dark-mode first]
- **Color palette direction**: [e.g. warm blues + white, brand colors TBD, surprise me]
- **Animation level**: [None / Subtle / Rich]
- **Accessibility target**: [WCAG AA / AAA / Basic]
- **Design system**: [None — build from scratch / shadcn/ui / MUI / other]

## 6. Success Metrics
## 7. Assumptions Log
| ID | Assumption | Risk | Validation Plan |
## 8. Open Questions
```

## Role Guidance

| Role | Focus |
|------|-------|
| PM | Own PRD, user stories, acceptance criteria |
| Dev | Review feasibility, identify edge cases |
| QA | Review testability, identify scenarios |
| Tech Lead | Validate fit, flag non-functionals |

## Handoff to Tech Spec

- Approved PRD
- Prioritized user stories
- Complete acceptance criteria
- Dependencies identified
- Traceability matrix

Save to: `docs/prd/YYYY-MM-DD-[feature].md`
