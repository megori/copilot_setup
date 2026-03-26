# Command: /new-project

**Trigger:** User types `/new-project` or says "create a new project" / "start a new project"

---

## Behavior

Ask the user one question:

> What would you like to name the new project?

Wait for the name. Then run this command in the terminal without asking for further confirmation:

```powershell
& "C:/Users/dori/Code/copilot_setup/scripts/new-project.ps1" -Name "{project-name}"
```

Replace `{project-name}` with the name the user gave.

After the script runs, tell the user:
- VS Code is opening the new project workspace
- Their first step is to fill in `.github/rules/project/policy.md` with their stack and rules
- They can type `/maid-start` when ready to begin

---

## What the Script Creates

```
{project-name}/
├── .github/rules/project/policy.md   ← Fill this in with stack + domain rules
├── .maid/                              ← Phase folders + blank state/context
├── {project-name}.code-workspace      ← Linked to copilot_setup
├── .gitignore
└── README.md
```

---

## Notes
- The script detects the MAID root automatically from its location
- If the project folder already exists, the script will report an error
- VS Code opens the new workspace automatically if `code` CLI is on the PATH
