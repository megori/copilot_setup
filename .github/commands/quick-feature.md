---
description: "Quick feature workflow for small features (skips full PRD/Tech Spec phases)"
argument-hint: [feature-description]
---

# Quick Feature: $ARGUMENTS

## Purpose

Streamlined feature development workflow for **small, straightforward features** that don't require full PRD and Technical Spec phases.

**Best for:**
- Simple CRUD operations
- Minor UI enhancements
- Small API endpoints
- Bug fixes that require code changes
- Features with clear, well-understood requirements

**NOT for:**
- Complex architectural changes
- Features requiring extensive stakeholder input
- Multi-team coordination
- Breaking changes to existing APIs

## When to Use Quick vs Full Feature

| Aspect | Quick Feature | Full Feature |
|--------|--------------|--------------|
| Time estimate | < 4 hours | > 4 hours |
| Files affected | 1-5 files | 5+ files |
| New components | No | Yes |
| Breaking changes | No | Possibly |
| Documentation | Minimal | Extensive |

---

## Process

### Phase 1: Brief Planning (5-15 minutes)

**Understand the Request:**
- What exactly needs to be built?
- What are the acceptance criteria?
- What files will be affected?
- Are there any edge cases to consider?

**Create a Simple Plan:**
Write a brief plan covering:

```markdown
# Quick Feature: [feature-name]

## What
[One-sentence description]

## Acceptance Criteria
- [ ] Criteria 1
- [ ] Criteria 2

## Files to Modify
- `path/to/file1` - [change needed]
- `path/to/file2` - [change needed]

## Approach
[Brief description of implementation approach]
```

### Phase 2: Exploration (10-20 minutes)

**Use the Explore agent to:**
- Find similar patterns in the codebase
- Identify relevant files and their locations
- Understand the project's conventions
- Note any utilities or helpers available

**Use parallel exploration for efficiency:**
- Agent 1: Find similar implementations
- Agent 2: Explore affected file locations

### Phase 3: Implementation

**Follow MAID Development Phase (Phase 4) practices:**
1. **TDD First**: Write tests before implementation when possible
2. **Follow Patterns**: Use patterns found during exploration
3. **Incremental**: Build small, testable pieces
4. **Validate**: Run tests and linting frequently

**Key Implementation Guidelines:**
- Read existing files before modifying
- Follow the project's code style
- Add appropriate error handling
- Include logging where useful
- Update type definitions if needed

### Phase 4: Validation

**Run project validation commands:**
```bash
# Detect project type and run appropriate validation
# Python projects:
#   - ruff check
#   - pytest
#   - mypy (if configured)

# JavaScript/TypeScript projects:
#   - npm test
#   - npm run lint
#   - npm run typecheck (if configured)
```

**Manual Testing:**
- Test the feature end-to-end
- Verify acceptance criteria are met
- Check for edge cases
- Ensure no regressions

---

## Quality Checklist

Before considering complete:

- [ ] Acceptance criteria met
- [ ] Code follows project conventions
- [ ] Tests added (if applicable)
- [ ] Tests pass
- [ ] Linting passes
- [ ] No obvious bugs or edge cases
- [ ] Error handling in place
- [ ] Documentation updated (if needed)

---

## Output Report

Provide a summary:

### Feature Implemented
**Feature**: $ARGUMENTS

### Files Modified
1. `path/to/file1` - [change summary]
2. `path/to/file2` - [change summary]

### Tests Added
- Test file: `path/to/test_file.py`
- Coverage: [what was tested]

### Validation Results
```bash
[Paste validation output]
```

### Acceptance Status
- [x] Criteria 1 - [status]
- [x] Criteria 2 - [status]

### Ready for Commit
Yes/No - [any remaining work]

---

## If You Need More Structure

If during implementation you discover the feature is more complex than expected:
1. Stop and assess
2. Consider switching to `/full-feature` for proper planning
3. Or proceed if you're confident you can complete it

---

## Notes

- This command bypasses the full MAID phase gates for speed
- Quality gates (testing, validation) still apply
- Use judgement - if in doubt, use `/full-feature`
- Document any decisions made during implementation
