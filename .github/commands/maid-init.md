# /MAID init

Initialize the MAID Memory System.

## Purpose

First-time setup of the memory system. Creates runtime directories and copies templates.

## What It Does

1. Creates `~/.maid/` directory structure:
   ```
   ~/.maid/
   ├── state.json
   ├── config.yaml
   ├── feedback/
   │   ├── pending/
   │   └── processed/
   ├── skills/
   ├── metrics/
   └── logs/
   ```

2. Copies skill templates from `memory-system/skills/`

3. Initializes configuration files from `memory-system/templates/`

4. Initializes github Memory with 20 starter entries (if not present)

## Usage

```
/MAID init
```

## Output

```
✅ MAID Memory System initialized

Created:
- ~/.maid/state.json
- ~/.maid/config.yaml
- ~/.maid/feedback/pending/
- ~/.maid/feedback/processed/
- ~/.maid/skills/ (copied from repo)
- ~/.maid/metrics/

github Memory: 20 starter entries added

Ready! Use /MAID start to begin a session.
```

## Notes

- Safe to run multiple times (won't overwrite existing data)
- Use `/MAID reset` to start fresh
- See `memory-system/docs/COMMANDS.md` for details
