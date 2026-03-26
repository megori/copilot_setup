# Skill Template

## Folder Structure
```
.github/skills/{skill-name}/
    SKILL.md
    manifest.md
    references/
    templates/
```

## SKILL.md
- Purpose and usage
- Input requirements
- Output format
- References to best-practice docs

## manifest.md
- Name
- Description
- Phase/role
- Output location

---

## File Access Policy
- Skills may only read from `.github/` in the project root (not user home/global)
- Skills may only write outputs to `.maid/` in the project root, or to `C:\Users\dori\.maid` for personal/global use
- Any attempt to access files outside these locations should be aborted and logged

*Use this template for all new skill creations. Reference best-practice docs for naming and structure.*
