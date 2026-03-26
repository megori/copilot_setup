# /MAID improve

Run the improvement analysis cycle.

## Purpose

Analyze collected feedback, suggest skill updates, promote insights to github Memory.

## Requirements

- At least 3 pending feedback items in `~/.maid/feedback/pending/`
- Or use `--force` to run with fewer (will warn about limited data)

## Flow

1. **Gather Data**:
   - Load all files from `~/.maid/feedback/pending/`
   - Load current skills from `~/.maid/skills/`
   - Load trends from `~/.maid/metrics/trends.json`

2. **Analyze** (Sub-Agent):
   - Cluster feedback by role/phase
   - Identify recurring patterns
   - Generate improvement suggestions
   - Score confidence for each suggestion

3. **Present Suggestions**:
   ```
   Improvement Analysis Complete
   
   Based on 5 feedback sessions (avg rating: 3.8)
   
   SKILL UPDATES SUGGESTED:
   
   1. [Developer Skill] Add section on error handling
      Confidence: 85%
      Reason: 3/5 sessions mentioned need for better error handling
      
      [Approve] [Edit] [Reject]
   
   2. [Development Phase] Emphasize incremental commits
      Confidence: 72%
      Reason: Pattern of large commits causing review issues
      
      [Approve] [Edit] [Reject]
   
   MEMORY CANDIDATES:
   
   1. "When implementing auth, always start with session management"
      Category: Developer
      Confidence: 80%
      
      [Promote to Memory] [Skip]
   ```

4. **Apply Changes**:
   - Update approved skill files
   - Promote approved memory entries
   - Archive processed feedback to `~/.maid/feedback/processed/`

5. **Summary**:
   ```
   ✅ Improvement cycle complete
   
   Changes applied:
   - 2 skill updates
   - 1 new memory entry
   
   Feedback archived: 5 sessions
   Next improvement suggested: ~1 week
   ```

## Usage

```
/MAID improve
```

Force with limited data:
```
/MAID improve --force
```

## Notes

- Run weekly or after 5+ sessions
- All changes require user approval
- Memory entries follow format: `MAID:{ROLE}:{PHASE}:{TYPE} {insight}`
- See `memory-system/docs/IMPROVEMENT-FLOW.md` for full process
