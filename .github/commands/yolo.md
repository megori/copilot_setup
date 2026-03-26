# YOLO Mode - Enable Full Automation

To enable YOLO mode (auto-approve all tools), use the built-in command:

```
/permissions
```

Then add these patterns:
- `Bash(*)`
- `Edit(*)`
- `Write(*)`
- `Read(*)`

Or restart github Code to use the settings from `.github/settings.json` which already has these permissions configured.

## Alternative: Launch Flag

```bash
github --dangerously-skip-permissions
```

## What Gets Auto-Approved

| Pattern | Effect |
|---------|--------|
| `Bash(*)` | All bash/shell commands |
| `Edit(*)` | All file edits |
| `Write(*)` | All new file creation |
| `Read(*)` | All file reads |

⚠️ **Warning**: Commands will execute WITHOUT confirmation!
