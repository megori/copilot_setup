# /MAID reset

Full system reset - clears all runtime data.

## Purpose

Start fresh by removing all runtime data. Use when troubleshooting or starting over.

## Warning

⚠️ This will delete:
- All pending feedback
- All processed feedback history
- Session state
- Metrics and trends
- Local skill modifications

This will NOT delete:
- github Memory entries (manage separately)
- Repository files in `memory-system/`

## Flow

1. **Confirm**:
   ```
   ⚠️ Full Reset Warning
   
   This will delete all data in ~/.maid/
   
   - 3 pending feedback items
   - 15 processed feedback items
   - Session history
   - Skill modifications
   
   github Memory entries will NOT be affected.
   
   Type 'RESET' to confirm:
   ```

2. **Execute**:
   ```
   Resetting...
   ✅ Deleted ~/.maid/feedback/
   ✅ Deleted ~/.maid/metrics/
   ✅ Deleted ~/.maid/state.json
   ✅ Reset ~/.maid/skills/ to defaults
   
   Reset complete. Run /MAID init to reinitialize.
   ```

## Usage

```
/MAID reset
```

## Export Before Reset

To save feedback before reset:
```
/MAID export
```

This creates a backup file you can review later.

## Notes

- Requires explicit confirmation
- Cannot be undone
- Run `/MAID init` after reset to reinitialize
- See `memory-system/docs/COMMANDS.md#reset` for details
