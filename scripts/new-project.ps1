<#
.SYNOPSIS
    Creates a new MAID-powered project folder with all scaffolding.

.DESCRIPTION
    Scaffolds a new project directory pre-configured for the MAID 
    (Managed AI Development) framework. Includes:
      - .github/rules/project/policy.md  (project coding standards template)
      - .maid/ with all 7 phase subdirectories + blank state/context files
      - <name>.code-workspace linking this project to the MAID methodology
      - .gitignore (MAID-aware patterns)
      - README.md (minimal starter)

.PARAMETER Name
    The project name. Used as folder name and in generated files.

.PARAMETER Path
    Parent directory where the project folder is created.
    Defaults to the parent of the copilot_setup folder.

.EXAMPLE
    .\new-project.ps1 -Name "my-cool-app"
    .\new-project.ps1 -Name "client-portal" -Path "D:\Projects"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [Parameter(Mandatory = $false)]
    [string]$Path = "",

    [Parameter(Mandatory = $false)]
    [ValidateSet("public", "private", "none", "ask")]
    [string]$GitHub = "ask",    # "public" | "private" | "none" | "ask" (default: prompt)

    [Parameter(Mandatory = $false)]
    [string]$Venv = "ask",      # "yes" | "no" | "ask"

    [Parameter(Mandatory = $false)]
    [ValidateSet("python", "node", "skip", "ask")]
    [string]$VenvLang = "ask"   # "python" | "node" | "skip" | "ask"
)

# ─── Path Detection ────────────────────────────────────────────────────────────
$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path $MyInvocation.MyCommand.Path -Parent }
if (-not $Path) {
    # Default to the parent of the copilot_setup folder
    $Path = Split-Path (Split-Path $ScriptDir -Parent) -Parent
}

$MAIDRoot     = Split-Path $ScriptDir -Parent              # copilot_setup/
$ProjectRoot  = Join-Path $Path $Name
$MAIDRootFwd  = $MAIDRoot.Replace("\", "/")                 # forward slashes for JSON
$ProjectRootFwd = $ProjectRoot.Replace("\", "/")

# ─── Guard ─────────────────────────────────────────────────────────────────────
if (Test-Path $ProjectRoot) {
    Write-Error "Folder already exists: $ProjectRoot"
    exit 1
}

Write-Host ""
Write-Host "Creating MAID project: $Name" -ForegroundColor Cyan
Write-Host "  Location : $ProjectRoot"
Write-Host "  MAID root : $MAIDRoot"
Write-Host ""

# ─── Create folders ────────────────────────────────────────────────────────────
$folders = @(
    $ProjectRoot,
    "$ProjectRoot\.github",
    "$ProjectRoot\.github\rules",
    "$ProjectRoot\.github\rules\project",
    "$ProjectRoot\.maid",
    "$ProjectRoot\.maid\0_discovery",
    "$ProjectRoot\.maid\1_prd",
    "$ProjectRoot\.maid\2_tech-spec",
    "$ProjectRoot\.maid\3_impl-plan",
    "$ProjectRoot\.maid\4_dev",
    "$ProjectRoot\.maid\5_qa",
    "$ProjectRoot\.maid\6_user-feedback",
    "$ProjectRoot\.maid\design",
    "$ProjectRoot\.maid\docs",
    "$ProjectRoot\.maid\reflection",
    "$ProjectRoot\src",
    "$ProjectRoot\src\tokens",
    "$ProjectRoot\src\components"
)
foreach ($f in $folders) {
    New-Item -Path $f -ItemType Directory -Force | Out-Null
}

# ─── .github/rules/project/policy.md ──────────────────────────────────────────
$policy = @"
---
paths:
  - "**/*"
---

# Project Policy: $Name

> Fill in this file before starting development.
> Copilot loads it for every file in the workspace (paths: ["**/*"]).

---

## Project
- **Name**: $Name
- **Stack**: [e.g. Next.js 14, FastAPI, React Native]
- **Primary Language(s)**: [e.g. TypeScript, Python]

---

## Credentials & Configuration
- Never hardcode credentials — always use `.env` + environment variables
- No fallback defaults for API keys or external service endpoints
- All environment variables must be present at startup or the system fails with a clear error

---

## UI & Design Tokens
- Color palette is defined ONCE in `src/tokens/` — never hardcode hex values in components
- Semantic token names: `--color-primary`, `--color-surface`, `--color-text-primary`, etc.
- Component names are generic and role-neutral (see MAID reusability rules)
- Load `ui-ux-pro-max` + `atomic-design` skills for every UI implementation task

<!-- Fill in token values in src/tokens/design.css during Phase 2 Tech Spec -->

## Code Quality
- No dead code — delete unused functions, imports, and comments
- No commented-out code in committed files
- Minimal mocks — real implementations in integration tests; mocks only in unit tests

## Error Handling
- Raise specific, typed exceptions — never swallow exceptions silently
- Do not return null/None as a silent error — raise or return a typed result

---

## Stack-Specific Rules
<!-- Add rules specific to your tech stack -->

## Domain Rules  
<!-- Add rules specific to your business domain -->

## Exceptions to Default Rules
<!-- Document intentional deviations from the universal MAID rules -->
"@
Set-Content -Path "$ProjectRoot\.github\rules\project\policy.md" -Value $policy -Encoding UTF8

# ─── .maid/state.json ───────────────────────────────────────────────────────────
$todayDate = Get-Date -Format "yyyy-MM-dd"
$state = @"
{
  "project": "$Name",
  "current_phase": 0,
  "phase_name": "discovery",
  "system_mode": "STRICT",
  "phases": {
    "0": { "status": "not_started" },
    "1": { "status": "not_started" },
    "2": { "status": "not_started" },
    "3": { "status": "not_started" },
    "4": { "status": "not_started" },
    "5": { "status": "not_started" },
    "6": { "status": "not_started" }
  },
  "last_updated": "$todayDate"
}
"@
Set-Content -Path "$ProjectRoot\.maid\state.json" -Value $state -Encoding UTF8

# ─── .maid/design/design-system.md ──────────────────────────────────────────────
$designSystem = @"
# Design System — $Name

> Created in Phase 2 (Tech Spec). Updated whenever design tokens or components change.
> This is the single source of truth for the project's visual language.

---

## UX Vision
*(Copied from PRD Phase 1 — fill in during Phase 2)*

- **Target devices**: [Desktop / Mobile / Responsive]
- **Visual direction**: [e.g. Clean & Minimal, Bold & Expressive, Dark-mode first]
- **Color palette direction**: [describe]
- **Animation level**: [None / Subtle / Rich]
- **Accessibility target**: [WCAG AA / AAA / Basic]
- **Design system**: [None — build from scratch / shadcn/ui / MUI / other]
- **Figma file**: [URL or "not created"]

---

## Design Tokens
*(Defined in Phase 2 — mirrored in src/tokens/design.css)*

| Token | Value | Semantic Role |
|-------|-------|---------------|
| ``--color-primary`` | | CTAs, active states, links |
| ``--color-secondary`` | | Accents, badges |
| ``--color-surface`` | | Cards, panels, inputs |
| ``--color-background`` | | Page background |
| ``--color-text-primary`` | | Body copy |
| ``--color-text-secondary`` | | Labels, hints |
| ``--color-error`` | | Errors, destructive |
| ``--color-success`` | | Confirmations |
| ``--font-heading`` | | H1–H3 |
| ``--font-body`` | | Body, labels |

---

## Component Registry
*(Updated in Phase 4 — one row per component created)*

| Component | Atomic Level | Generic Name | File Path | Props / Variants |
|-----------|-------------|--------------|-----------|-----------------|
| | | | | |

### Component Naming Rules
- Names describe WHAT the component IS, not WHERE it is used
- `ProductCard` → `Card` | `OrdersTable` → `DataTable` | `UserAvatarGroup` → `AvatarGroup`
- Props define specific usage; name stays generic

---

## Design Decisions Log
*(Record all significant design choices here)*

| Date | Decision | Rationale | Alternatives Considered |
|------|----------|-----------|------------------------|
| $todayDate | Initial scaffold | Project created | — |
"@
Set-Content -Path "$ProjectRoot\.maid\design\design-system.md" -Value $designSystem -Encoding UTF8

# ─── .maid/context.json ─────────────────────────────────────────────────────────
$context = @"
{
  "project": "$Name",
  "session_id": "",
  "role": "",
  "phase": 0,
  "phase_name": "discovery",
  "tasks": {
    "previous": "",
    "current": "",
    "next": ""
  },
  "current_task_steps": {
    "previous": "",
    "current": "",
    "next": ""
  },
  "sprint_plan": {
    "sprint": "",
    "name": "",
    "stories": "",
    "estimate": ""
  },
  "session_log": [],
  "decisions_made": []
}
"@
Set-Content -Path "$ProjectRoot\.maid\context.json" -Value $context -Encoding UTF8

# ─── <name>.code-workspace ─────────────────────────────────────────────────────
$workspace = @"
{
  "folders": [
    {
      "name": "MAID Methodology",
      "path": "$MAIDRootFwd"
    },
    {
      "name": "$Name",
      "path": "."
    }
  ],
  "settings": {
    "explorer.sortOrder": "foldersNestsFiles"
  }
}
"@
Set-Content -Path "$ProjectRoot\$Name.code-workspace" -Value $workspace -Encoding UTF8

# ─── src/tokens/design.css ─────────────────────────────────────────────────────
$designTokens = @"
/*
 * Design Tokens — $Name
 *
 * Defined in Phase 2 (Tech Spec). Every color, spacing, and typography value lives HERE.
 * Components reference these variables — they NEVER hardcode values.
 *
 * Fill in actual values during Phase 2. Use semantic names, not primitives.
 * (Bad: --blue-500  Good: --color-primary)
 */

:root {
  /* ── Color Palette ──────────────────────────────────────────── */
  --color-primary:          /* #______ – CTAs, links, active states */;
  --color-primary-hover:    /* #______ – hover/focus variant */;
  --color-secondary:        /* #______ – accents, badges */;
  --color-surface:          /* #______ – cards, panels, inputs */;
  --color-background:       /* #______ – page background */;
  --color-border:           /* #______ – dividers, outlines */;
  --color-text-primary:     /* #______ – body copy (min 4.5:1 on background) */;
  --color-text-secondary:   /* #______ – labels, hints (min 3:1) */;
  --color-error:            /* #______ – errors, destructive actions */;
  --color-success:          /* #______ – confirmations, success states */;
  --color-warning:          /* #______ – warnings, caution */;

  /* ── Typography ─────────────────────────────────────────────── */
  --font-heading: /* 'FontName', fallback */;
  --font-body:    /* 'FontName', fallback */;
  --font-mono:    /* 'FontName', monospace */;

  --text-xs:   0.75rem;   /* 12px */
  --text-sm:   0.875rem;  /* 14px */
  --text-base: 1rem;      /* 16px – minimum for body */
  --text-lg:   1.125rem;  /* 18px */
  --text-xl:   1.25rem;   /* 20px */
  --text-2xl:  1.5rem;    /* 24px */
  --text-3xl:  1.875rem;  /* 30px */
  --text-4xl:  2.25rem;   /* 36px */

  --leading-tight:  1.25;
  --leading-normal: 1.5;   /* body text */
  --leading-relaxed: 1.75;

  /* ── Spacing (4px base unit) ────────────────────────────────── */
  --space-1:  0.25rem;   /* 4px  */
  --space-2:  0.5rem;    /* 8px  */
  --space-3:  0.75rem;   /* 12px */
  --space-4:  1rem;      /* 16px */
  --space-6:  1.5rem;    /* 24px */
  --space-8:  2rem;      /* 32px */
  --space-12: 3rem;      /* 48px */
  --space-16: 4rem;      /* 64px */

  /* ── Radius ──────────────────────────────────────────────────── */
  --radius-sm:   4px;
  --radius-md:   8px;
  --radius-lg:   12px;
  --radius-xl:   16px;
  --radius-full: 9999px;

  /* ── Shadows ─────────────────────────────────────────────────── */
  --shadow-sm:  0 1px 2px rgba(0,0,0,0.05);
  --shadow-md:  0 4px 6px rgba(0,0,0,0.07), 0 2px 4px rgba(0,0,0,0.05);
  --shadow-lg:  0 10px 15px rgba(0,0,0,0.1), 0 4px 6px rgba(0,0,0,0.05);

  /* ── Z-index scale ──────────────────────────────────────────── */
  --z-base:    0;
  --z-above:   10;
  --z-dropdown: 20;
  --z-sticky:  30;
  --z-overlay: 40;
  --z-modal:   50;
  --z-toast:   60;
}
"@
Set-Content -Path "$ProjectRoot\src\tokens\design.css" -Value $designTokens -Encoding UTF8

# ─── .gitignore ────────────────────────────────────────────────────────────────
$gitignore = @"
# MAID methodology (personal tooling — stays local, not pushed)
.github/*
# EXCEPT the project policy (useful for collaborators)
!.github/rules/
!.github/rules/project/
!.github/rules/project/policy.md

# MAID runtime state (session-specific)
.maid/state.json
.maid/context.json
.maid/test-outputs/
.maid/qa/*-review-*.json

# Python
.venv/
__pycache__/
*.py[cod]
.pytest_cache/

# Node
node_modules/
.next/
dist/
build/

# Environment
.env
.env.local
.env*.local
!.env.example

# OS
.DS_Store
Thumbs.db
desktop.ini

# Editor
.idea/
*.swp
"@
Set-Content -Path "$ProjectRoot\.gitignore" -Value $gitignore -Encoding UTF8

# ─── README.md ─────────────────────────────────────────────────────────────────
$readme = @"
# $Name

<!-- Add project description here -->

---

## Development

This project uses the [MAID methodology](https://github.com/megori/copilot_setup).

### Setup
1. Open ``$Name.code-workspace`` in VS Code
2. Run ``/maid-start`` in GitHub Copilot chat
3. Follow the phase process

### Phases
| # | Phase | Status |
|---|-------|--------|
| 0 | Discovery | not started |
| 1 | PRD | not started |
| 2 | Tech Spec | not started |
| 3 | Impl Plan | not started |
| 4 | Dev | not started |
| 5 | QA & Ship | not started |
| 6 | User Feedback | not started |
"@
Set-Content -Path "$ProjectRoot\README.md" -Value $readme -Encoding UTF8

# ─── Git init ──────────────────────────────────────────────────────────────────
Push-Location $ProjectRoot
git init --quiet
git add .gitignore README.md ".github/rules/project/policy.md" 2>$null
git commit -m "chore: initial MAID project scaffold for $Name" --quiet 2>$null

# ─── Optional virtual environment ─────────────────────────────────────────────
if ($Venv -eq "ask") {
    $Venv = Read-Host "Create a virtual environment? [yes/no] (default: no)"
}

if ($Venv -match "^y") {
    if ($VenvLang -eq "ask") {
        $langAnswer = Read-Host "Language? [python/node/skip] (default: python)"
        $VenvLang = if ($langAnswer -match "^n") { "node" } `
                elseif ($langAnswer -match "^s") { "skip" } `
                else { "python" }
    }

    if ($VenvLang -eq "python") {
        Write-Host ""
        Write-Host "Creating Python virtual environment..." -ForegroundColor Cyan
        $pythonExe = Get-Command python -ErrorAction SilentlyContinue
        if ($pythonExe) {
            python -m venv ".venv"
            if (Test-Path ".venv\Scripts\pip.exe") {
                Write-Host "  Installing starter packages: python-dotenv, pytest, pydantic..." -ForegroundColor DarkGray
                & ".venv\Scripts\pip.exe" install python-dotenv pytest pydantic --quiet
                Write-Host "  .venv created. Activate with: .venv\Scripts\Activate.ps1" -ForegroundColor Green
                Write-Host "  Add project packages with: pip install [package-name]" -ForegroundColor DarkGray
            } else {
                Write-Host "  .venv created (pip not found; run: python -m venv .venv)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  Python not found. Install from https://python.org then run: python -m venv .venv" -ForegroundColor Yellow
        }
    } elseif ($VenvLang -eq "node") {
        Write-Host ""
        Write-Host "Initialising Node.js project..." -ForegroundColor Cyan
        $npmExe = Get-Command npm -ErrorAction SilentlyContinue
        if ($npmExe) {
            npm init -y --silent 2>$null
            Write-Host "  package.json created. Add packages with: npm install [package-name]" -ForegroundColor Green
        } else {
            Write-Host "  npm not found. Install Node.js from https://nodejs.org" -ForegroundColor Yellow
        }
    }
}

# ─── Optional GitHub repo ──────────────────────────────────────────────────────
$ghExe = Get-Command gh -ErrorAction SilentlyContinue
if (-not $ghExe) {
    $ghExe = Get-Item "C:\Program Files\GitHub CLI\gh.exe" -ErrorAction SilentlyContinue
    if ($ghExe) { $ghExe = $ghExe.FullName } else { $ghExe = $null }
} else {
    $ghExe = "gh"
}

if ($ghExe -and $GitHub -eq "ask") {
    $answer = Read-Host "Create GitHub repo? [public/private/no]"
    if ($answer -match "^p") {
        $GitHub = if ($answer -match "priv") { "private" } else { "public" }
    } else {
        $GitHub = "none"
    }
}

if ($ghExe -and $GitHub -ne "none") {
    Write-Host ""
    Write-Host "Creating GitHub repo ($GitHub)..." -ForegroundColor Cyan
    & $ghExe repo create $Name --$GitHub --description "MAID project: $Name" --source . --remote origin --push 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  GitHub: https://github.com/megori/$Name" -ForegroundColor Green
    } else {
        Write-Host "  GitHub repo creation skipped (already exists or error)" -ForegroundColor Yellow
    }
}

Pop-Location

# ─── Done ──────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Project created." -ForegroundColor Green
Write-Host ""
Write-Host "  $ProjectRoot\$Name.code-workspace" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open the .code-workspace file in VS Code"
Write-Host "  2. Edit .github\rules\project\policy.md with your stack rules"
Write-Host "  3. Run /maid-start in Copilot chat"
Write-Host "  4. Run: git add . && git commit -m 'feat: ...' && git push  (after each work session)"
Write-Host "  See GITHUB.md in copilot_setup for the full GitHub workflow guide"
Write-Host ""

# Open VS Code automatically
$codeExe = Get-Command code -ErrorAction SilentlyContinue
if ($codeExe) {
    code "$ProjectRoot\$Name.code-workspace"
    Write-Host "VS Code is opening..." -ForegroundColor DarkGray
}
