---
name: 2-maid-tech-spec
description: MAID Phase 2 - Technical Specification. Use for system architecture, API contracts, data models, security architecture, transitioning from PRD to implementation.
---

# Tech Spec Phase Skill

## Phase Overview

Purpose: Design technical solution. Create blueprint developers can follow without ambiguity.

Entry: PRD approved, requirements clear, dependencies identified
Exit: Tech spec complete, architecture documented, API contracts defined, data models specified

## Deliverables

1. Tech Spec Document - Implementation-ready design
2. Architecture Diagram - Components and interactions
3. API Contracts - Endpoints, schemas, errors
4. Data Models - Schemas, types, constraints

## Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| Over-engineering | Design for current needs |
| Missing error handling | Define errors upfront |
| Tight coupling | Design for testability |
| Ignoring non-functionals | Address performance, security |
| Unclear contracts | APIs unambiguous with examples |

## Phase Gate Checklist

- [ ] Tech spec complete
- [ ] Architecture diagram created
- [ ] All API contracts defined
- [ ] Data models specified
- [ ] Error handling strategy defined
- [ ] Security considerations addressed
- [ ] Performance requirements addressed
- [ ] **Frontend: design tokens table filled in** (if UI present)
- [ ] **Frontend: component inventory with generic names documented** (if UI present)
- [ ] Tech lead approved

## Tech Spec Template

```markdown
# [Feature] Technical Specification

## 1. Overview
### Problem Summary
### Proposed Solution
### Key Decisions
| Decision | Choice | Rationale |

## 2. Architecture
### System Diagram
[Mermaid or image]

### Component Breakdown
| Component | Responsibility | Dependencies |

### Data Flow

## 3. API Design
### POST /api/[resource]
**Request:**
```json
{ "field": "type" }
```

**Response (200):**
```json
{ "id": "string" }
```

**Errors:**
| Code | Error | Description |

## 4. Data Model
### Entity: [Name]
| Field | Type | Constraints | Description |

## 5. Frontend Architecture *(skip if no UI)*

> **Input**: Pull the `## UX Vision` section from the PRD before filling this in.
> If the PRD's UX Vision is incomplete, use `vscode_askQuestions` to collect missing answers before proceeding.

### Optional: Figma MCP Design *(new projects only)*

Offer this path ONLY when all three conditions are met:
1. This is a **new project** (not a feature addition — do not offer if `MAID-feature-add` skill is active and the project already has a codebase without a Figma file)
2. User has not already said "no Figma" in the UX Vision step
3. The `figma-design-review` / Figma MCP is configured

```
vscode_askQuestions:
  header: "figma-optional"
  question: "Would you like to create a Figma design file for this project? This generates visual frames for your screens before locking the design tokens."
  options:
    - "❌ No — proceed with text-based token definition"
    - "✅ Yes — generate Figma frames (requires Figma MCP configured)"
```

- **Yes** → load `figma-design-review` skill, invoke Figma MCP to create frames, then extract tokens from the result into the token table below
- **No** / feature-add context → skip and continue with manual token definition

### Design Direction Sign-off
Before specifying tokens, confirm the visual direction with the user:

```
vscode_askQuestions:
  header: "design-direction-confirm"
  question: "Based on the UX Vision, I'm planning: [summarise direction — e.g. 'Dark-mode, minimal, rich micro-animations, shadcn/ui components, WCAG AA, mobile-first responsive']. Is this the direction we want to lock in for the design tokens?"
  options:
    - "✅ Yes — lock it in"
    - "✏️ Tweak it (describe below)"
  allowFreeformInput: true
```

Only proceed to token definition after the user confirms.

### Design Tokens
Define all tokens here. These become `src/tokens/` CSS variables — **no component may hardcode any of these values.**

| Token | Value | Semantic Role |
|-------|-------|---------------|
| `--color-primary` | `#______` | CTAs, active states, links |
| `--color-secondary` | `#______` | Accents, badges |
| `--color-surface` | `#______` | Cards, panels, inputs |
| `--color-background` | `#______` | Page background |
| `--color-text-primary` | `#______` | Body copy (4.5:1 min contrast) |
| `--color-text-secondary` | `#______` | Labels, hints |
| `--color-error` | `#______` | Errors, destructive |
| `--color-success` | `#______` | Confirmation, success |
| `--font-heading` | `[family]` | H1–H3 |
| `--font-body` | `[family]` | Body, labels |
| `--spacing-base` | `4px` | Base unit (multiply: ×2=8, ×4=16…) |
| `--radius-default` | `[value]` | Card/button corner radius |

### Component Inventory
List every UI component planned. Names are **role-generic and context-neutral** — the component's *props* define its specific usage, not its name.

| Component | Atomic Level | Generic Name | Props / Variants |
|-----------|-------------|--------------|-----------------|
| Primary action button | Atom | `Button` | `variant: primary\|secondary\|ghost`, `size`, `loading` |
| Content container | Molecule | `Card` | `header?`, `footer?`, `padded?` |
| Row in a list/grid | Molecule | `ListItem` | `leading?`, `trailing?`, `selected?` |
| *(add more…)* | | | |

> **Naming Rule:** `UserCard` → `Card`. `OrdersTable` → `DataTable`. `TeamAvatars` → `AvatarGroup`.
> The wrong name = copy-pasted, incompatible duplicates. The generic name = one component, infinite uses.

### UI Tech Notes
- Skill to invoke in Phase 4 for all UI work: **`ui-ux-pro-max`** (accessibility, design quality) + **`atomic-design`** (hierarchy, token enforcement)
- Style system: `src/tokens/design.css` (CSS variables) or equivalent for the project stack
- Visual design direction: *(note tone/aesthetic decided — see PRD or discovery)*
- **Save completed design system to**: `.maid/design/design-system.md` (token table + component inventory + direction notes)

## 6. Security
### Authentication
### Authorization
### Data Protection

## 7. Error Handling
| Scenario | Response | Recovery |

## 8. Non-Functional Requirements
| Requirement | Target | Measurement |

## 9. Risks & Mitigations
| Risk | Impact | Mitigation |
```

## Role Guidance

| Role | Focus |
|------|-------|
| PM | Validate approach addresses requirements |
| Dev | Own spec, design for testability |
| QA | Review testability, integration points |
| Tech Lead | Review architecture, approve direction |

## Handoff to Implementation

- Approved tech spec
- API contracts
- Data models
- Architecture decisions with rationale
- Spike/POC results (if any)

Save to: `docs/tech-spec/YYYY-MM-DD-[feature].md`
