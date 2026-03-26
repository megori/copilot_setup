---
paths:
  - "**/*"
---

# Project Policy

> **Instructions for use:** Fill in this file when starting a new project.
> This file is loaded by Copilot for every file in the workspace.
> Delete sections that don't apply. Add sections specific to your stack or domain.

---

## Project
- **Name**: [Project name]
- **Stack**: [e.g. Next.js, FastAPI, React Native]
- **Primary Language(s)**: [e.g. TypeScript, Python]

---

## Credentials & Configuration
- Never hardcode credentials — always use `.env` + environment variables
- No fallback defaults for API keys, model names, or external service endpoints
- All environment variables must be present at startup or the system fails with a clear error

## Code Quality
- No dead code — delete unused functions, imports, and comments
- No commented-out code in committed files
- Minimal mocks — use real implementations in integration tests; mocks only in unit tests
- No simulation or demo modes — everything either works as designed or fails clearly

## Configuration Loading
- Access settings through a single config object/module — never use `os.getenv` ad-hoc
- All config validation happens at startup, not at call time

## Dependencies
- Pin dependency versions in lockfiles
- No direct dependency on transitive packages
- Run `npm audit` / `pip audit` before every release

## Error Handling
- Raise specific, typed exceptions — never swallow exceptions silently
- Include context in error messages (what failed, what was expected)
- Do not return `null`/`None` as a silent error — raise or return a typed result

---

## Stack-Specific Rules
<!-- Add rules that are specific to your tech stack -->
<!-- Example: "All API routes must use Zod validation schemas" -->

## Domain Rules
<!-- Add rules specific to your business domain -->
<!-- Example: "Currency values are always stored in cents (integer), never floats" -->

## Exceptions to Default Rules
<!-- Document any intentional deviations from the universal rules in .github/rules/ -->
<!-- Example: "This project ships a demo mode — the 'no simulation modes' rule does not apply" -->
