---
name: phase-enforcement
description: MAID methodology phase gate enforcement with lazy loading. Ensures work follows correct phase order while loading only required skills for current phase.
---

# Phase Enforcement Skill (with Lazy Loading)

github MUST check current phase, load appropriate skills, and enforce gates before any work.

## Operating Modes

### Lazy Loading Mode (Default - Token Efficient)
- **Load skills by phase** - Only load what's needed for current work
- **Core always loaded** - WHY, reflection, phase-enforcement, context (~2,000 tokens)
- **Phase skills on-demand** - Load +2,000-3,000 tokens for active phase
- **Unload when done** - Remove phase skills when phase completes

### Quick Mode (Solo/small tasks)
- **Skip phase gates** for `/fix` and `/quick-feature`
- **Direct to Dev** - Load only Phase 4 skills
- **Quality still required** - Tests, validation, status reports

### Full Mode (Complex features)
- **All phases enforced** when using `/full-feature`
- **Sub-agent reviews** at each gate
- **Complete documentation**

### Mode Detection

**Quick Mode is active when:**
- Using `/fix` command
- Using `/quick-feature` command

**Lazy Loading Mode is active when:**
- Using specific phase commands (`/prd`, `/tech-spec`, etc.)
- Working within a specific phase

**Full Mode is active when:**
- Using `/full-feature` command
- User explicitly requests full methodology

## Lazy Loading Logic

### Phase Entry (Load Phase Skills)

When entering Phase N:
1. Read `.maid/state.json` for current phase
2. Read `phases/phase-{N}/MANIFEST.md` for skills to load
3. Load ONLY skills listed in manifest
4. Unload skills from previous phase (if different)
5. Update context with phase-specific capabilities

**Example: Entering Phase 1 (PRD)**
```yaml
1. Read: phases/phase-1-prd/MANIFEST.md
2. Load: MAID-prd/ skill
3. Unload: phase-0-discovery/ skills (no longer needed)
4. Token cost: +2,000 (total: ~4,000)
```

### Phase Exit (Unload Phase Skills)

When completing Phase N:
1. Run phase gate checks
2. Unload Phase N skills
3. If advancing to Phase N+1: Load Phase N+1 skills
4. Update `.maid/state.json` with new phase

## Priority 1: Phase Gate Enforcement (Team Mode)

In Team Mode, before any work:
1. Read `.maid/state.json` for current phase
2. Classify the requested work
3. Check if work is allowed
4. REFUSE if not allowed (show violation)
5. At phase completion: mandatory sub-agent review
6. After review passes: collect feedback via /MAID end

## Priority 1: Quality Assurance (Solo Mode)

In Solo Mode, before any work:
1. Classify the task (quick feature, fix, or complex)
2. For quick features/fixes: Skip phase gates, maintain quality
3. For complex features: Suggest using `/full-feature`
4. ALWAYS require: tests, validation, code quality
5. After completion: reflection review recommended

## Mandatory: Sub-Agent Review at Transitions

Before Phase N -> N+1:
1. Spawn review sub-agent
2. Sub-agent reviews all deliverables
3. Returns PASS/FAIL with findings
4. FAIL: Address issues, retry
5. PASS: Proceed to feedback

## Work Classification & Command Routing

| Command | Use Case | Phase Requirements |
|---------|----------|-------------------|
| `/fix` | Quick bug fixes | None (skip to code) |
| `/quick-feature` | Small features (<4 hours) | Minimal planning (skip PRD/Tech Spec) |
| `/full-feature` | Complex features (>4 hours) | Full MAID lifecycle (all phases) |
| `/discovery` | Problem validation | Phase 0 |
| `/prd` | Requirements definition | Phase 1 |
| `/tech-spec` | Technical specification | Phase 2 |
| `/phase-advance` | Move to next phase | Requires gate check |

## 5-Phase Development Lifecycle (Team Mode)

| Phase | Name | Document | Folder |
|-------|------|----------|--------|
| 0 | Discovery | Problem Validation | docs/discovery/ |
| 1 | PRD | Product Requirements | docs/prd/ |
| 2 | Tech Spec | Technical Specification | docs/tech-spec/ |
| 3 | Impl Plan | Task Breakdown | docs/implementation-plan/ |
| 4 | Development | Code & Tests | src/ |
| 5 | QA & Ship | Deployment | Production |

## Work Classification

| Category | Examples | First Allowed |
|----------|----------|---------------|
| requirements | PRD, user stories | Phase 1 |
| architecture | System design, APIs | Phase 2 |
| planning | Jira, task breakdown | Phase 3 |
| coding | Components, tests | Phase 4 |
| qa | Testing, deployment | Phase 5 |

## Phase Permissions

### Team Mode (Strict)
- Phase 0: Discovery activities only
- Phase 1: requirements
- Phase 2: requirements, architecture
- Phase 3: requirements, architecture, planning
- Phase 4: requirements, architecture, planning, coding
- Phase 5: all

### Solo Mode (Flexible)
- `/fix`: Direct to implementation, quality gates apply
- `/quick-feature`: Brief planning → implementation → validation
- `/full-feature`: Full Team Mode phase gates apply
- All modes: Tests and validation REQUIRED before completion

## Solo Mode Quality Gates

Even with relaxed phase gates, quality is NEVER compromised:

**Required for ALL completed work:**
- [ ] Tests added and passing
- [ ] Code follows project conventions
- [ ] Linting passes
- [ ] Type checking passes (if applicable)
- [ ] No regressions in existing functionality
- [ ] Acceptance criteria met

**Optional (recommended for significant changes):**
- Reflection review via `/reflect`
- Code review via `/code-review`
- Documentation updates

## Gate Check Requirements

### Phase 1 -> 2
- [ ] PRD exists in docs/prd/
- [ ] User stories defined
- [ ] Acceptance criteria complete
- [ ] Sub-agent review PASSED

### Phase 2 -> 3
- [ ] Tech Spec exists
- [ ] Architecture diagram
- [ ] API contracts
- [ ] Security assessment
- [ ] Sub-agent review PASSED

### Phase 3 -> 4
- [ ] Implementation Plan exists
- [ ] Tasks broken down
- [ ] Dependencies identified
- [ ] Test strategy defined
- [ ] Sub-agent review PASSED

### Phase 4 -> 5
- [ ] Code implemented
- [ ] Tests passing
- [ ] Coverage meets threshold
- [ ] Sub-agent review PASSED

## Violation Template

```
PHASE GATE VIOLATION

Current Phase: [N] [Name]
Requested: [What]
Category: [Category]

This work belongs to Phase [X].

Complete first: [List]

Commands: /phase, /gate-check, /MAID end
```

## Sub-Agent Review Prompts

### PRD Review (Phase 1 -> 2)
- [ ] Problem statement clear
- [ ] User stories As/I want/So that
- [ ] Acceptance criteria per story
- [ ] Non-functional requirements
- [ ] Measurable success metrics
- [ ] No implementation details

### Tech Spec Review (Phase 2 -> 3)
- [ ] Architecture diagram
- [ ] Components defined
- [ ] Data models (TypeScript)
- [ ] API contracts
- [ ] Database schema
- [ ] Security assessment
- [ ] References PRD

### Impl Plan Review (Phase 3 -> 4)

**Phase 3 Golden Rules:**
1. NO WORD LEFT BEHIND - PRD → Epic/Story, Tech Spec → Task
2. SMALL TASKS - Larger docs = smaller tasks
3. PROCESS IN CHUNKS - Read → Write immediately
4. VERIFY - 100% coverage required

**Sub-Phases:** 3a Consolidation → 3b Breakdown → 3c Enrichment → 3d Jira → 3e Verification

**Checklist:**
- [ ] Contradiction log created
- [ ] Source documents fixed
- [ ] Consolidated spec created
- [ ] Hierarchy: Epic → Story → Task
- [ ] Tasks sized appropriately
- [ ] All 8 required fields per Task
- [ ] 100% PRD/Tech Spec coverage
- [ ] Enriched files staged
- [ ] Jira populated with ADF

### Development Review (Phase 4 -> 5)
- [ ] All tasks complete
- [ ] Tests passing
- [ ] Coverage >= 70%
- [ ] Lint passes
- [ ] Build succeeds
- [ ] No critical vulnerabilities

## Exceptions

**Always Allowed:** Reading files, documentation updates, questions, /phase, /gate-check

**Override:** User says "override: [reason]" - logged to .maid/overrides.log

## State File

`.maid/state.json`:
```json
{
  "current_phase": 2,
  "phase_name": "tech-spec",
  "feature_name": "user-auth",
  "phases_completed": [1],
  "subagent_review": {"phase_1": {"status": "passed"}}
}
```
