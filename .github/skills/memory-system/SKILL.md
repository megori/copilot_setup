# Memory System Skill

> Load this skill when working with MAID Memory System commands (/MAID-start, /MAID-end, /MAID-improve, etc.)

---

## When to Load This Skill

Load when user invokes:
- `/MAID-init` - Initialize memory system
- `/MAID-start` - Start work session
- `/MAID-end` - End phase with feedback
- `/MAID-improve` - Run improvement analysis
- `/MAID-status` - Check current state
- `/MAID-memory` - Manage memory entries

---

## Sub-Agent: Memory Analysis

When `/MAID-improve` is invoked, spawn the **memory-analysis-agent**:

```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: [Read agents/memory-analysis-agent/AGENT-PROMPT.md],
  description: "Memory system improvement analysis"
)
```

### What to Pass to Agent

```
{{FEEDBACK_DATA}} - Contents of ~/.maid/feedback/pending/*.json
{{CURRENT_SKILLS}} - Section headers from skills/memory-system/references/
{{TREND_DATA}} - Contents of ~/.maid/metrics/trends.json
{{MEMORY_ENTRIES}} - Current MAID:* github Memory entries
```

### What Agent Returns

```json
{
  "suggestions": [...],
  "memory_candidates": [...],
  "trends_analysis": {...}
}
```

---

## Quick Reference

### Commands

| Command | Description |
|---------|-------------|
| `/MAID-init` | Initialize MAID system (first time setup) |
| `/MAID-start [role] [phase]` | Start a session |
| `/MAID-status` | Show current session state |
| `/MAID-end` | Complete phase gate, collect feedback |
| `/MAID-improve` | Run improvement analysis (spawns sub-agent) |

### Roles

- `product-manager` (pm)
- `developer` (dev)
- `qa-engineer` (qa)
- `tech-lead` (lead)

### Phases

- `discovery` (Phase 0)
- `prd` (Phase 1)
- `tech-spec` (Phase 2)
- `development` (Phase 4)
- `qa-ship` (Phase 5)

---

## Session Start Flow

When user says `/MAID-start`:

### Step 1: Check MAID Directory

```
IF ~/.maid/ does not exist:
  → Run /MAID-init flow
  → Create directory structure
  → Initialize with defaults
  → Display: "🚀 MAID Memory System initialized!"
```

### Step 2: Load State

```
Read ~/.maid/state.json
Check pending_feedback_count
Check sessions_since_last_improvement
```

### Step 3: Check Improvement Suggestion

```
IF pending feedback >= threshold:
  Display:
  "📊 I have {pending} feedback items waiting for analysis.
   Would you like to review insights and improve skills?
   [Yes, let's improve] [No, continue working]"
```

### Step 4: Determine Role & Phase

```
IF /MAID-start <role> <phase> provided:
  → Use provided values
ELIF state.last_session exists:
  → Suggest: "Continue as {last_role} in {last_phase}?"
ELSE:
  → Ask for role and phase
```

### Step 5: Load Skills

```
Load from skills/memory-system/references/:
1. roles/{role}/SKILL.md
2. roles/{role}/cumulative.md
3. phases/{phase}/SKILL.md
4. phases/{phase}/cumulative.md
```

### Step 6: Update State & Begin

```
Update ~/.maid/state.json with:
- current_session.active = true
- current_session.role = role
- current_session.phase = phase
- current_session.started_at = now()

Greet user and ask what they're working on.
```

---

## Session Work Flow

### Track Revisions (Internal Counter)

```
revision_triggers = [
  "fix", "change", "update", "wrong", "missing", "add",
  "incorrect", "error", "should be", "not right", "revise"
]

On each user message containing trigger:
  revision_count += 1
  Note what needed fixing for feedback
```

### Note Patterns (Internal)

```
positive_triggers = ["great", "perfect", "exactly", "good", "excellent"]

On positive trigger:
  Note what worked well for feedback
```

---

## Phase Gate Flow (Feedback Collection)

When user says `/MAID-end` or phase completion detected:

### Step 1: Display Summary

```
📋 Phase Summary: {phase_display_name}

Completed deliverables:
• {deliverable_1}
• {deliverable_2}

Revisions made: {revision_count}
```

### Step 2: Request Rating (MANDATORY)

```
📊 Quality Rating (1-5):

1 ⭐ - Poor, needs significant improvement
2 ⭐⭐ - Below average, missing important elements
3 ⭐⭐⭐ - Acceptable, worked but room for improvement
4 ⭐⭐⭐⭐ - Good, almost perfect
5 ⭐⭐⭐⭐⭐ - Excellent, exactly what I needed

MUST get rating before proceeding
```

### Step 3: Request Qualitative Feedback (Optional)

```
What worked well? (optional)
What could be improved? (optional)
Additional notes? (optional)
```

### Step 4: Save Feedback File

```
Save to ~/.maid/feedback/pending/{timestamp}.json:
{
  "context": { "role": "...", "phase": "..." },
  "metrics": { "rating": N, "revisions": N },
  "qualitative": { "what_worked": "...", "what_didnt": "..." }
}
```

### Step 5: Update State

```
Update ~/.maid/state.json:
- statistics.total_sessions += 1
- statistics.pending_feedback_count += 1
- statistics.sessions_since_last_improvement += 1
- current_session.active = false
```

---

## Improvement Flow (/MAID-improve)

### Step 1: Gather Data

```
Load all files from ~/.maid/feedback/pending/
Load current skills from skills/memory-system/references/
Load trends from ~/.maid/metrics/trends.json
```

### Step 2: Spawn Analysis Agent

```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: [agents/memory-analysis-agent/AGENT-PROMPT.md with variables],
  description: "Analyze feedback and suggest improvements"
)
```

### Step 3: Present Suggestions

Display agent's suggestions with approval buttons:
- [Approve] [Edit] [Reject] for each skill update
- [Promote to Memory] [Skip] for each memory candidate

### Step 4: Apply Changes

- Update approved skill files
- Add approved memory entries
- Archive processed feedback to ~/.maid/feedback/processed/

---

## Anonymization Rules

### NEVER include in feedback:

- ❌ Project name or identifier
- ❌ Company name
- ❌ Domain-specific terms
- ❌ Code snippets
- ❌ User names

### ALWAYS include:

- ✅ Role (product-manager, developer, etc.)
- ✅ Phase (discovery, prd, etc.)
- ✅ Rating (1-5)
- ✅ Revision count
- ✅ Generic methodology feedback

---

## State Files

| File | Purpose |
|------|---------|
| `~/.maid/state.json` | Current session state |
| `~/.maid/config.yaml` | User configuration |
| `~/.maid/feedback/pending/` | Unprocessed feedback |
| `~/.maid/feedback/processed/` | Archived feedback |
| `~/.maid/metrics/trends.json` | Historical trends |

---

## Error Handling

| Error | Action |
|-------|--------|
| Missing ~/.maid/ | Run /MAID-init automatically |
| Missing skill files | Use defaults, log warning |
| Corrupted state.json | Backup and reset |
| User skips rating | Gently insist, then save as null |

---

## Related

- Agent: `agents/memory-analysis-agent/AGENT-PROMPT.md`
- References: `skills/memory-system/references/`
- Commands: `.github/commands/MAID-*.md`
