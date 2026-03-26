---
description: "Full MAID workflow for complex features (all phases: Discovery, PRD, Tech Spec, Impl Plan, Dev, QA)"
argument-hint: [feature-description]
---

# Full Feature: $ARGUMENTS

## Purpose

Complete MAID methodology workflow for **complex, significant features** requiring thorough planning, specification, and validation.

**Best for:**
- Complex architectural changes
- New major capabilities
- Features affecting multiple systems
- Breaking API changes
- Features requiring extensive stakeholder coordination
- Work estimated at > 4 hours

---

## Overview: MAID 6-Phase Lifecycle

This command guides you through the complete MAID development methodology:

```
Phase 0: Discovery → Phase 1: PRD → Phase 2: Tech Spec →
Phase 3: Implementation Plan → Phase 4: Development → Phase 5: QA & Ship
```

Each phase has specific deliverables and quality gates.

---

## Phase 0: Discovery

**Goal**: Validate problem space and ensure we're solving the right problem.

### Activities
- Use `/discovery` command or perform discovery analysis
- Validate the problem exists
- Identify stakeholders
- Define success metrics
- Assess feasibility

### Key Questions
- What problem are we solving?
- For whom are we solving it?
- Why solve it now?
- What does success look like?

### Deliverable
- Discovery document confirming the problem is worth solving
- Go/No-Go decision

### Gate
- ✅ Problem validated
- ✅ Stakeholders identified
- ✅ Success metrics defined
- **Gate Check**: Use `/gate-check` before proceeding

---

## Phase 1: Product Requirements Document (PRD)

**Goal**: Define what we're building from the user's perspective.

### Activities
- Use `/prd` command
- Write user stories
- Define acceptance criteria
- Scope features (MVP vs future)
- Identify constraints

### Key Questions
- Who is the user?
- What are their goals?
- What are the acceptance criteria?
- What's out of scope?

### Deliverable
- Complete PRD with:
  - User stories
  - Acceptance criteria
  - Feature scope
  - Success metrics
  - Constraints

### Gate
- ✅ User stories defined
- ✅ Acceptance criteria clear
- ✅ Scope agreed upon
- **Gate Check**: Use `/gate-check` before proceeding

---

## Phase 2: Technical Specification

**Goal**: Define how we'll build it from a technical perspective.

### Activities
- Use `/tech-spec` command
- Design system architecture
- Define API contracts
- Design data models
- Plan integration points
- Identify technical risks

### Key Questions
- What's the system architecture?
- What are the API endpoints/data structures?
- How do components interact?
- What are the technical risks?
- What technology choices are needed?

### Deliverable
- Complete Tech Spec with:
  - System architecture
  - API contracts
  - Data models
  - Integration points
  - Security considerations
  - Performance requirements

### Gate
- ✅ Architecture designed
- ✅ API contracts defined
- ✅ Data models specified
- ✅ Technical risks addressed
- **Gate Check**: Use `/gate-check` before proceeding

---

## Phase 3: Implementation Plan

**Goal**: Break down the work into actionable tasks.

### Activities
- Use Phase 3 planning approach
- Break down into atomic tasks
- Define task dependencies
- Estimate effort
- Plan testing approach

### Key Questions
- What are the specific implementation tasks?
- What's the order of execution?
- What tests are needed?
- What are the validation criteria?

### Deliverable
- Implementation plan with:
  - Ordered task list
  - File-by-file changes
  - Test strategy
  - Validation commands
  - Risk mitigation

### Gate
- ✅ Tasks identified and ordered
- ✅ Test strategy defined
- ✅ Validation commands specified
- **Gate Check**: Use `/gate-check` before proceeding

---

## Phase 4: Development

**Goal**: Implement the feature following the plan.

### Activities
- Execute implementation tasks in order
- Follow TDD practices (use `/write-tests` skill)
- Follow code patterns from codebase
- Run validation frequently
- Use `/reflect` for quality checks

### Key Practices
- **Read first**: Always read existing files before modifying
- **Follow patterns**: Use existing codebase conventions
- **Test as you go**: Write and run tests frequently
- **Validate continuously**: Run linting, type checking, tests
- **Ask for reflection**: Use `/reflect` for significant outputs

### Deliverable
- Complete implementation with:
  - All code changes
  - Comprehensive tests
  - Updated documentation
  - Passing validation

### Gate
- ✅ All tasks completed
- ✅ Tests passing
- ✅ Validation passing
- ✅ Code reviewed (use `/code-review`)
- **Gate Check**: Use `/gate-check` before proceeding

---

## Phase 5: QA & Ship

**Goal**: Validate quality and prepare for deployment.

### Activities
- Run comprehensive test suite
- Perform end-to-end testing
- Validate acceptance criteria
- Prepare deployment
- Update documentation

### Key Questions
- Do all tests pass?
- Does it meet acceptance criteria?
- Are there any regressions?
- Is it ready for production?

### Deliverable
- Validated feature ready for deployment:
  - All tests passing
  - Acceptance criteria met
  - Documentation updated
  - Deployment plan ready

### Gate
- ✅ Test suite passes
- ✅ Acceptance criteria met
- ✅ No regressions
- ✅ Documentation complete
- ✅ Ready to deploy

---

## Phase Advance Workflow

As you complete each phase:

1. **Complete phase deliverables**
2. **Run `/gate-check`** to validate phase completion
3. **Address any issues** identified by the phase review agent
4. **Advance to next phase** only when gate check passes

Example:
```bash
# After completing PRD
/gate-check "Phase 1: PRD complete for [feature]"

# If gate check passes, proceed to Tech Spec
# If issues found, address them first
```

---

## Quality Assurance Throughout

### Continuous Quality Checks
- **Reflection**: Use `/reflect` for significant outputs
- **Code Review**: Use `/code-review` after implementation
- **Context Updates**: Use `/context-update` to track progress

### Documentation
- Update relevant documentation as you go
- Keep github.md in sync with any changes
- Document any new patterns or conventions

---

## Final Output Report

### Feature Summary
**Feature**: $ARGUMENTS
**Complexity**: [Low/Medium/High]
**Estimated Time**: [hours]

### Phase Completion Status
- [ ] Phase 0: Discovery - ✅ Complete
- [ ] Phase 1: PRD - ✅ Complete
- [ ] Phase 2: Tech Spec - ✅ Complete
- [ ] Phase 3: Implementation Plan - ✅ Complete
- [ ] Phase 4: Development - ✅ Complete
- [ ] Phase 5: QA & Ship - ✅ Complete

### Key Deliverables
- Discovery: [path/to/discovery.md]
- PRD: [path/to/prd.md]
- Tech Spec: [path/to/tech-spec.md]
- Implementation Plan: [path/to/impl-plan.md]
- Code Changes: [list of files]
- Tests: [list of test files]

### Validation Results
```bash
[Paste final validation output]
```

### Deployment Status
- ✅ Ready for deployment
- Target deployment: [date/environment]

---

## Notes

- This is the complete MAID methodology - use for significant work
- Each phase gate ensures quality before proceeding
- Phase enforcement prevents skipping ahead
- The phase review agent validates completion at each gate
- Context persists across the entire feature lifecycle

## If You Need Help

- `/phase` - Check current phase
- `/gate-check` - Validate phase completion
- `/maid-status` - Check overall status
- `/reflect` - Get quality assessment
- `/context` - View accumulated context
