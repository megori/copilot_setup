# Agent Template

## Folder Structure
```
.github/agents/{agent-name}/
    AGENT-PROMPT.md
    manifest.md
    examples/
    references/
    templates/
```

## AGENT-PROMPT.md
- Purpose and role
- System prompt
- Input requirements
- Output format
- References to best-practice docs

## manifest.md
- Name
- Description
- Phase/role
- Skills used
- Output location

---

## File Access Policy
- Agents may only read from `.github/` in the project root (not user home/global)
- Agents may only write outputs to `.maid/` in the project root, or to `C:\Users\dori\.maid` for personal/global use
- Any attempt to access files outside these locations should be aborted and logged

*Use this template for all new agent creations. Reference best-practice docs for naming and structure.*
