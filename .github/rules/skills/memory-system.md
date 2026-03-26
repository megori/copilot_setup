# Memory System Rules

Rules for loading and using the MAID Memory System skill.

---

## When to Load This Skill

Load `skills/memory-system/SKILL.md` when the user invokes:

| Command | Description |
|---------|-------------|
| `/MAID-init` | Initialize memory system for project |
| `/MAID-start` | Start work session (role + phase selection) |
| `/MAID-end` | End phase and collect feedback |
| `/MAID-improve` | Run improvement analysis (spawns sub-agent) |
| `/MAID-status` | Check current state |
| `/MAID-memory` | Manage memory entries |
| `/MAID-reset` | Reset memory system |

---

## Automatic Loading

The memory system skill should be loaded automatically when:

1. User starts any MAID session (`/MAID-start`)
2. User ends any MAID session (`/MAID-end`)
3. User explicitly requests memory management

---

## Sub-Agent Spawning

When `/MAID-improve` is invoked, spawn the memory analysis sub-agent:

```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: [Read agents/memory-analysis-agent/AGENT-PROMPT.md],
  description: "Memory system improvement analysis"
)
```

### Data to Pass

| Variable | Source |
|----------|--------|
| `{{FEEDBACK_DATA}}` | Contents of `~/.maid/feedback/pending/*.json` |
| `{{CURRENT_SKILLS}}` | Section headers from `skills/memory-system/references/` |
| `{{TREND_DATA}}` | Contents of `~/.maid/metrics/trends.json` |
| `{{MEMORY_ENTRIES}}` | Current MAID:* github Memory entries |

---

## State Management

### State Files

| File | Purpose | Location |
|------|---------|----------|
| `state.json` | Phase tracking | `.maid/state.json` (project) |
| `context.json` | Work context | `.maid/context.json` (project) |
| `state.json` | Session state | `~/.maid/state.json` (user) |
| `feedback/pending/` | Unprocessed feedback | `~/.maid/feedback/pending/` |
| `feedback/processed/` | Archived feedback | `~/.maid/feedback/processed/` |

### Update Triggers

Update `.maid/state.json` when:
- Session starts (`/MAID-start`)
- Session ends (`/MAID-end`)
- Phase changes
- Improvement analysis runs

Update `.maid/context.json` when:
- New task begins
- Step completes
- Session ends

---

## Feedback Collection Rules

### MANDATORY

1. **Always collect rating (1-5)** at session end
2. **Track revision count** during session
3. **Never include project-specific data** (names, code, companies)

### OPTIONAL

1. What worked well
2. What could be improved
3. Additional notes

---

## Anonymization Rules

### NEVER Include

- ❌ Project name or identifier
- ❌ Company name
- ❌ Domain-specific terms
- ❌ Code snippets
- ❌ User names

### ALWAYS Include

- ✅ Role (product-manager, developer, qa-engineer, tech-lead)
- ✅ Phase (discovery, prd, tech-spec, breakdown, development, qa-ship)
- ✅ Rating (1-5)
- ✅ Revision count
- ✅ Generic methodology feedback

---

## Improvement Thresholds

| Metric | Threshold | Action |
|--------|-----------|--------|
| Pending feedback | ≥ 5 | Suggest improvement run |
| Sessions since last improvement | ≥ 10 | Suggest improvement run |
| Average rating | < 3.5 | Flag for attention |

---

## Reference Loading

When session starts, load references from `skills/memory-system/references/`:

```
1. roles/{role}/SKILL.md       - Role quick reference
2. roles/{role}/cumulative.md  - Role learnings
3. phases/{phase}/SKILL.md     - Phase quick reference
4. phases/{phase}/cumulative.md - Phase learnings
```

---

## Error Handling

| Error | Action |
|-------|--------|
| Missing `~/.maid/` | Run `/MAID-init` automatically |
| Missing skill files | Use defaults, log warning |
| Corrupted state.json | Backup and reset |
| User skips rating | Gently insist, then save as null |

---

## Related Files

| File | Purpose |
|------|---------|
| `agents/memory-analysis-agent/AGENT-PROMPT.md` | Sub-agent prompt |
| `skills/memory-system/SKILL.md` | Skill definition |
| `skills/memory-system/references/` | Role/phase references |
| `.github/commands/MAID-*.md` | Memory system commands |
