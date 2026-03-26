# Phase 6: User Feedback Checklist

## Checklist Items

### Feedback Collection
- `[CRITICAL]` All user feedback items captured (nothing self-filtered)
- `[CRITICAL]` Each item categorized: Bug / UX / Feature Request / Clarification
- `[REQUIRED]` Priority assigned per item: Blocker / High / Medium / Low

### Triage
- `[CRITICAL]` All Blockers and High items triaged with root cause identified
- `[REQUIRED]` Duplicates merged
- `[REQUIRED]` Out-of-scope items explicitly deferred with reason

### Fixes Applied
- `[CRITICAL]` All Blocker items resolved and verified by user
- `[REQUIRED]` High priority items resolved or deferred with justification
- `[RECOMMENDED]` Medium items addressed if time permits

### Verification
- `[CRITICAL]` User confirms each resolved item is acceptable
- `[CRITICAL]` No unresolved Blockers remain open
- `[REQUIRED]` Fix summary document written

### Closure
- `[CRITICAL]` User explicitly confirms phase closure ("all done" or explicit deferral)
- `[REQUIRED]` Deferred items recorded with reason and proposed timeline

## Expected Files

- `.maid/6_user-feedback/feedback-log.md`
- `.maid/6_user-feedback/issue-triage.md`
- `.maid/6_user-feedback/fix-summary.md`

## Auto-FAIL

- Blocker items unresolved without user deferral
- User has not confirmed closure
- Feedback log empty (collection skipped)
- Fixes applied without re-verification by user
