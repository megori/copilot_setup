# /MAID memory

Manage github Memory entries for MAID.

## Subcommands

### /MAID memory list

Show all MAID-related entries in github Memory.

```
MAID Memory Entries
==================

Universal (5/5 slots):
  1. MAID:ALL:ALL:WORKFLOW Always complete current phase before starting next
  2. MAID:ALL:ALL:CONTEXT Start each session by reading work_context.json
  3. MAID:ALL:ALL:DOCS Update documentation in real-time not at end
  4. MAID:ALL:ALL:HUMAN Get explicit approval before major decisions
  5. MAID:ALL:ALL:QUALITY Verify every artifact against requirements

Developer (4/5 slots):
  1. MAID:DEV:TECH:DECISIONS Document why not just what for tech choices
  2. MAID:DEV:DEV:TDD Write test first then implement
  3. MAID:DEV:DEV:ATOMIC One logical change per commit
  4. MAID:DEV:ALL:DEBT Mark shortcuts with TODO-DEBT and track

PM (5/5 slots):
  [...]

Learned (3/10 slots):
  1. MAID:DEV:DEV:LEARNED When implementing auth start with session management
  2. MAID:QA:QA:LEARNED Edge cases in date handling need timezone tests
  3. MAID:PM:PRD:LEARNED Stakeholder availability affects timeline estimates
```

### /MAID memory stats

Show memory usage statistics.

```
MAID Memory Statistics
=====================

Slot Usage:
  Universal:  5/5  [█████████████████████] 100%
  PM:         5/5  [█████████████████████] 100%
  Developer:  4/5  [████████████████░░░░░]  80%
  QA:         5/5  [█████████████████████] 100%
  Lead:       2/3  [██████████████░░░░░░░]  67%
  Phase:      3/5  [████████████░░░░░░░░░]  60%
  Learned:    3/10 [██████░░░░░░░░░░░░░░░]  30%
  
  Total: 27/38 slots used (71%)

Last Updated: 3 days ago
Entries from feedback: 3
```

## Usage

```
/MAID memory list
/MAID memory stats
```

## Notes

- MAID entries use prefix `MAID:` for easy identification
- Learned entries can be promoted via `/MAID improve`
- Manual management available via github Memory interface
- See `memory-system/docs/MEMORY.md` for slot allocation details
