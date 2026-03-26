---
description: "Quick bug fix workflow with minimal planning"
argument-hint: [bug-description]
---

# Fix: $ARGUMENTS

## Purpose

Streamlined bug fix workflow for **quickly resolving bugs** with minimal overhead.

**Best for:**
- Clear, reproducible bugs
- Simple fixes (1-2 file changes)
- Bugs with obvious root cause
- Fixes that can be tested easily

**NOT for:**
- Complex debugging requiring investigation
- Bugs requiring architectural changes
- Issues needing extensive research
- Bugs with unclear root cause

---

## Process

### Phase 1: Quick Analysis (5-10 minutes)

**Understand the Bug:**
- What is the expected behavior?
- What is the actual behavior?
- What are the steps to reproduce?
- What is the suspected root cause?

**Reproduce the Bug:**
- Follow reproduction steps
- Confirm the bug exists
- Note any error messages
- Identify the affected code area

### Phase 2: Find the Root Cause (10-20 minutes)

**Use targeted exploration:**
- Search for relevant code files
- Read the suspected buggy code
- Identify the exact issue
- Understand why it's happening

**Tools to use:**
- Explore agent to find related code
- Grep to search for specific functions/variables
- Read to examine the code

### Phase 3: Implement Fix

**Read before modifying:**
- Read the full file containing the bug
- Understand surrounding context
- Look for similar patterns in the codebase
- Check for related code that might be affected

**Implement the fix:**
- Make the minimal change needed
- Follow existing code patterns
- Don't refactor unrelated code
- Add comments if the fix is non-obvious

### Phase 4: Add Test (if applicable)

**Create a test case:**
- Write a test that reproduces the bug
- Verify the test fails before the fix
- Verify the test passes after the fix
- This prevents regression

**Test file location:**
- Mirror the source file structure
- Use descriptive test names
- Example: `test_issue_description.py`

### Phase 5: Validate

**Run validation:**
```bash
# Detect project type and run appropriate validation
# Python:
pytest
ruff check

# JavaScript/TypeScript:
npm test
npm run lint
```

**Manual testing:**
- Reproduce the bug - should be fixed
- Test related functionality - no regressions
- Check edge cases

---

## Quality Checklist

Before considering complete:

- [ ] Bug is fixed
- [ ] Test added (if applicable) and passing
- [ ] No regressions introduced
- [ ] Code follows project conventions
- [ ] Linting passes
- [ ] Related functionality still works

---

## Output Report

### Bug Fixed
**Description**: $ARGUMENTS

### Root Cause
[One-line summary of what was wrong]

### Fix Applied
**File Modified**: `path/to/file.py`
**Change**: [Brief description of the fix]
**Lines**: [Line numbers affected]

### Test Added
**Test File**: `path/to/test_file.py`
**Test Case**: [test function name]
**Coverage**: [what the test verifies]

### Validation Results
```bash
[Paste validation output]
```

### Verification
- [x] Bug reproduction steps - bug is fixed
- [x] Related functionality - no regressions
- [x] Edge cases - all passing

### Ready for Commit
Yes/No - [any remaining work]

---

## Example

### Input
```
/fix User profile page shows "undefined" for email field
```

### Process
1. **Analysis**: Email field not being populated in user profile
2. **Exploration**: Find user profile component and API endpoint
3. **Root Cause**: API returns `emailAddress` but component expects `email`
4. **Fix**: Update component to use `emailAddress` OR update API to return `email`
5. **Test**: Add test verifying email field is populated
6. **Validate**: Run tests and linting

---

## If Bug is Complex

If during investigation you discover:
- Root cause is not obvious
- Multiple files/components affected
- Fix requires architectural changes
- Related issues exist

**Stop and consider:**
- Using `/full-feature` for proper investigation
- Creating a discovery document
- Raising an issue for tracking

---

## Notes

- Minimal planning for speed
- Quality still matters - tests and validation required
- Keep changes focused - don't refactor unrelated code
- Document the fix if it's non-obvious
- Consider if similar bugs might exist elsewhere
