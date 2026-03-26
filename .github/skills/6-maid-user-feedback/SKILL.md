---
name: 6-maid-user-feedback
description: MAID Phase 6 - User Feedback. Collect structured feedback on delivered development, triage issues, implement fixes, and confirm resolution. Loop continues until all feedback items are closed or explicitly deferred.
---

# User Feedback Phase Skill

## Purpose

Receive feedback on delivered or in-progress development, triage each issue, implement fixes, and confirm resolution. Does not end until the user confirms all items are resolved or deferred.

**Entry:** Development shipped or a recent dev cycle just completed
**Exit:** User confirms all raised issues are resolved or explicitly deferred

---

## Feedback Collection

Start with a single `vscode_askQuestions` call to capture all initial feedback at once:

```yaml
vscode_askQuestions:
  header: "feedback-collect"
  question: "You're reviewing the delivered work. What feedback do you have?"
  questions:
    - header: "feedback-items"
      question: "List every issue, observation, or change request you have.
                 One item per line — don't self-filter, include everything."
      placeholder: |
        e.g.
        1. Save button doesn't work on mobile
        2. Loading spinner shows for too long
        3. Would like darker background color
        4. Login flow feels confusing
      allowFreeformInput: true

    - header: "severity-overall"
      question: "Overall — how critical is this feedback?"
      options:
        - "🔴 Blockers present — cannot accept this build"
        - "🟡 Issues present — needs fixes before sign-off"
        - "🟢 Minor polish only — mostly satisfied"

    - header: "context"
      question: "What environment or scenario was this feedback captured in?
                 (e.g. real user session, internal review, staging demo, prod observation)"
      placeholder: "e.g. Demo with 3 users on mobile, staging env"
      allowFreeformInput: true
```

---

## Triage

After collecting feedback, parse each item into a triage table and present it:

```markdown
## Feedback Triage

| # | Item | Type | Priority | Action |
|---|------|------|----------|--------|
| 1 | Save button doesn't work on mobile | 🐛 Bug | 🔴 High | Fix |
| 2 | Loading spinner too long | 🐛 Bug | 🟡 Med | Fix |
| 3 | Darker background color | ✨ Polish | 🟢 Low | Decide |
| 4 | Login flow confusing | 🔧 UX | 🟡 Med | Fix |
```

**Type labels:**
- 🐛 Bug — something broken
- ✨ Polish — visual or copy tweak
- 🔧 UX — interaction flow change
- 🚫 Out of Scope — feature creep / v2 candidate
- ❓ Unclear — needs clarification before action

**Priority labels:**
- 🔴 High — blocks acceptance or causes data loss
- 🟡 Med — degrades experience but has workaround
- 🟢 Low — nice to have

Present the triage table and confirm with:

```yaml
vscode_askQuestions:
  header: "triage-confirm"
  question: "Here's how I've triaged the {N} feedback items above.
             Does this look correct? Adjust any labels before we begin fixing."
  options:
    - "✅ Triage looks correct — start fixing"
    - "✏️  Adjust triage before fixing"
    - "🚫 Mark some items Out of Scope first"
```

On "Adjust": ask which item to change and what to change it to, then re-show the table. Re-confirm.

---

## Fix Loop

For each item classified as Bug, UX, or Polish (not Out of Scope / Unclear):

### Per-Item Fix Cycle

1. **Announce item:**
   ```
   🔧 Fixing Item #{N}: {description}
   Type: {type} | Priority: {priority}
   ```

2. **Implement fix** — follow the same TDD practice as the Development phase:
   - For bugs: write a failing test that reproduces the bug first (RED), then fix (GREEN)
   - For UX/polish: implement change, verify visually or via snapshot test

3. **Confirm fix with user:**
   ```yaml
   vscode_askQuestions:
     header: "fix-confirm-{N}"
     question: "Item #{N} — '{description}' has been fixed.
                Summary of change: {1-2 line description of what was changed}
                Does this resolve the issue?"
     options:
       - "✅ Yes — resolved"
       - "🔁 Not quite — describe what's still wrong"
       - "🚫 Defer to next cycle"
   ```

   - **Resolved**: mark item ✅, proceed to next
   - **Not quite**: ask for clarification, re-implement, re-confirm (max 3 cycles per item; escalate to user on 3rd fail)
   - **Defer**: mark item 🔜, record deferral reason

4. **Update feedback log** after each resolved or deferred item.

---

## Resolution Check Loop

After all items in the current triage are handled, always check if the user has more feedback:

```yaml
vscode_askQuestions:
  header: "more-feedback"
  question: "All triaged items are now resolved or deferred.
             Do you have any additional feedback from this session?"
  options:
    - "✅ No — all good, I'm satisfied"
    - "➕ Yes — I have more feedback"
    - "🔜 Pause — come back to deferred items later"
```

- **No more feedback**: proceed to Close phase (save report, update state)
- **More feedback**: return to **Feedback Collection** step (full re-collect loop)
- **Pause**: save current state to feedback log, stop session

> **This loop is mandatory.** Never close the feedback phase without asking. Never assume the user is done.

---

## Feedback Log Format

Save and update after every resolved/deferred item:

```markdown
# User Feedback Report: {project}
**Date:** {YYYY-MM-DD}
**Phase:** 6 — User Feedback
**Context:** {context from collection}
**Overall Severity:** {severity}

## Items

| # | Description | Type | Priority | Status | Resolution |
|---|-------------|------|----------|--------|------------|
| 1 | Save button mobile | 🐛 Bug | 🔴 High | ✅ Fixed | Patched touch event handler |
| 2 | Spinner too long | 🐛 Bug | 🟡 Med | ✅ Fixed | Reduced timeout 5s→1.5s |
| 3 | Darker background | ✨ Polish | 🟢 Low | 🔜 Deferred | User deferred to v1.1 |

## Deferred Items (carry to next cycle)
- Item #3: Darker background — deferred by user, reason: low priority

## Session Summary
- Total items: {N}
- Fixed: {N}
- Deferred: {N}
- Out of Scope: {N}
```

Save to: `.maid/feedback/YYYY-MM-DD-{project}-feedback.md`

---

## Phase Gate

After the user confirms all items resolved or explicitly closes the session:

```yaml
vscode_askQuestions:
  header: "phase-6-gate"
  question: "Feedback session complete.
             - ✅ Fixed: {N} items
             - 🔜 Deferred: {N} items
             - 🚫 Out of Scope: {N} items
             Report saved to .maid/feedback/
             Are you satisfied with the current state of the build?"
  options:
    - "✅ Yes — build is accepted"
    - "➕ More feedback to raise"
    - "🔜 Accepted with deferred items noted for next sprint"
```

Update `.maid/state.json`:
```json
"current_phase": 6,
"phase_name": "user-feedback",
"phases.6.status": "complete",
"phases.6.completed_at": "YYYY-MM-DD",
"phases.6.items_fixed": N,
"phases.6.items_deferred": N
```

### Git Push — After Build Acceptance

Once the user says "build is accepted" (any of the ✅ options above), ask:

```yaml
vscode_askQuestions:
  header: "push-to-github"
  question: "Build accepted! Ready to push all changes to GitHub?"
  options:
    - "✅ Yes — push to GitHub now"
    - "⏭️ Not yet — I'll push manually later"
  allowFreeformInput: false
```

If **Yes**, execute:
```powershell
git add .
git commit -m "chore: phase 6 complete — build accepted by user"
git push
```

> **Never push without this confirmation.** The push only happens here, at Phase 6, after explicit user approval.

---

## Phase Checklist

- [ ] All feedback items triaged (type + priority)
- [ ] Every in-scope item either fixed or deferred with reason
- [ ] User explicitly confirmed per-item resolution
- [ ] Resolution check loop ran — user confirmed "no more feedback"
- [ ] Feedback log saved to `.maid/feedback/`
- [ ] `.maid/state.json` updated
- [ ] Phase gate approved via `vscode_askQuestions`
- [ ] **GitHub push confirmed with user and executed**

---

## ⚠️ IRON RULE: Every Message Must End With a Question

**Non-negotiable.** Every response during this phase, including the very last one, MUST end by calling `vscode_askQuestions`.

| Situation | Action |
|-----------|--------|
| After fixing an item | Ask: "Does this resolve the issue?" |
| After triaging | Ask: "Triage correct — start fixing?" |
| After all items done | Ask: "Any more feedback?" |
| After phase gate | Ask: "Accepted? Or more to raise?" |
| Any summary message | End with: "What would you like to do next?" |

Minimum fallback:
```yaml
vscode_askQuestions:
  header: "next-step"
  question: "What would you like to do next?"
  options:
    - "▶ Continue"
    - "⏸  Pause here"
    - "➕ Add more feedback"
```

---

## Anti-Patterns

| Anti-Pattern | Fix |
|--------------|-----|
| Closing without asking for more feedback | Always run the resolution check loop |
| Fixing without confirming | Always confirm per-item before marking resolved |
| Silently deferring items | Always ask user before deferring; record reason |
| Skipping triage | Every item must be typed + prioritized before fixing |
| Assuming "mostly good" means done | Run the gate question regardless |
| Reply without invoking the askQuestions tool | Every message must end with a question to the user using the askQuestions tool |

---

## References

| File | When to Read |
|------|--------------|
| `.github/skills/4-maid-development/SKILL.md` | TDD fix practice (bugs require failing test first) |
| `.github/skills/5-maid-qa-ship/SKILL.md` | Regression check after applying fixes |
| `.maid/state.json` | Current phase and project context |
| `.maid/feedback/` | Previous feedback sessions for this project |
