# /link-project

Link an external project to MAID methodology via symbolic links.

## Purpose

Enable the full MAID methodology in any project by creating symbolic links to MAID's commands, skills, and configuration. The linked project gains access to all MAID features while maintaining its own state.

## Usage

```
/link-project [path-to-project]
```

If no path provided, asks for the project path.

## Directory Structure Expected

```
Parent Folder/
├── MAID-main/           <- This MAID installation
│   ├── .github/
│   │   ├── commands/
│   │   └── skills/
│   ├── .mcp.json.example
│   └── ...
│
└── my-project/         <- Project to link
    └── (your code)
```

## What Gets Created in Target Project

```
my-project/
├── .github/
│   ├── commands/  -> SYMLINK to MAID-main/.github/commands/
│   └── skills/    -> SYMLINK to MAID-main/.github/skills/
├── .maid/
│   ├── state.json      (project-specific, not linked)
│   └── context.json    (project-specific, not linked)
├── .mcp.json           (copied from template, user edits tokens)
└── github.md           -> SYMLINK to MAID-main/github.md
```

## Flow

1. **Get MAID Path**: Determine current MAID-main installation path
2. **Get Target Path**: Ask user or use provided path
3. **Validate**: Ensure target exists and is not inside MAID-main
4. **Create .github Directory** in target project
5. **Create Symbolic Links**:
   - Windows: `mklink /D` (requires Admin or Developer Mode)
   - Mac/Linux: `ln -s`
6. **Create .maid Directory** with fresh state files
7. **Copy .mcp.json.example** to target as `.mcp.json`
8. **Link github.md** for methodology instructions
9. **Show Success** with next steps

## Windows Commands (Run as Admin or with Developer Mode)

```batch
cd "C:\Projects\my-project"
mkdir .github
mklink /D ".github\commands" "C:\path\to\MAID-main\.github\commands"
mklink /D ".github\skills" "C:\path\to\MAID-main\.github\skills"
mklink "github.md" "C:\path\to\MAID-main\github.md"
mkdir .maid
copy "C:\path\to\MAID-main\.mcp.json.example" ".mcp.json"
```

## Mac/Linux Commands

```bash
cd ~/Projects/my-project
mkdir -p .github
ln -s ~/path/to/MAID-main/.github/commands .github/commands
ln -s ~/path/to/MAID-main/.github/skills .github/skills
ln -s ~/path/to/MAID-main/github.md github.md
mkdir -p .maid
cp ~/path/to/MAID-main/.mcp.json.example .mcp.json
```

## Example Output

```
/link-project C:\Projects\my-app

MAID Project Linker
==================

MAID Installation: C:\user's local files\demo\MAID-main
Target Project:   C:\Projects\my-app

Creating symbolic links...
  [OK] .github/commands -> MAID commands
  [OK] .github/skills   -> MAID skills
  [OK] github.md        -> MAID methodology

Creating project-specific files...
  [OK] .maid/state.json
  [OK] .maid/context.json
  [OK] .mcp.json (edit with your API tokens)

===========================================
Project linked successfully!
===========================================

Next steps:
1. Edit my-app/.mcp.json with your API tokens
2. Open github Code in C:\Projects\my-app
3. Run /maid-start to begin working

All MAID commands are now available:
  /maid-start, /maid-status, /prd, /tech-spec,
  /design-system, /code-review, /write-tests, etc.
```

## What the Linked Project Gets

| Feature | Description |
|---------|-------------|
| All Commands | /maid-start, /prd, /tech-spec, /code-review, etc. |
| All Skills | atomic-design, system-architect, test-driven, etc. |
| Phase Enforcement | PRD -> Tech Spec -> Development -> QA flow |
| Context Tracking | Automatic progress tracking |
| MCP Servers | Jira, Figma, GitHub integration (after token setup) |

## Troubleshooting

### Windows: "You do not have sufficient privilege"
Enable Developer Mode: Settings > Update & Security > For Developers > Developer Mode

### Symlinks not working
Fall back to copying instead of linking (run install.bat in the target folder)

## Notes

- Symbolic links mean updates to MAID-main automatically apply to all linked projects
- Each project maintains its own .maid/state.json (phase progress is per-project)
- .mcp.json must be configured separately per project (different tokens possible)
- Run from within MAID-main folder, pointing to the target project
