# MOVED

Project coding standards are now a proper Copilot instruction file loaded automatically by path matching.

**New location:** `.github/rules/project/policy.md`

Edit that file to define your project-specific rules. It has `paths: ["**/*"]` so Copilot loads it for every file.


## Credentials & Configuration
- **Never hardcode credentials** — always use `.env` + environment variables
- **No fallback defaults** for API keys, model names, or external service endpoints
- All environment variables must be present at startup or the system fails with a clear error message

## Code Quality
- **No dead code** — delete unused functions, imports, and comments
- **No commented-out code** in committed files
- **Minimal mocks** — use real implementations in integration tests; mocks only in unit tests
- **No simulation or demo modes** — everything either works as designed or fails clearly

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

**Last Updated**: 2026-03-25  
**Applies to**: All projects in this workspace  
**Enforced by**: GitHub Copilot Agent
