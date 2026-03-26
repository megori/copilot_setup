# MAID Plugin Pairing

Generate a one-time pairing code to connect your Figma plugin with MAID.

## Usage

Run `/maid-pair` when you want to authenticate your Figma plugin with the MAID system.

## What This Command Does

### Step 1: Generate OTP Code

Generate a pairing code from the MAID production server:

```bash
curl -s -X POST https://figma-plugin-server-983606191500.us-central1.run.app/auth/generate-pairing \
  -H "Content-Type: application/json" \
  -d '{"tenantId": "{project-id}", "projectPath": "{cwd}", "source": "github-code"}'
```

**If request fails:**
```
❌ Could not connect to MAID server

Check your internet connection and try again.
```

### Step 2: Display Pairing Code

```
╔══════════════════════════════════════════════════════════╗
║                  🔗 MAID PAIRING CODE                      ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║        Enter this code in your Figma plugin:             ║
║                                                          ║
║                    XXX XXX                               ║
║                                                          ║
║        ⏱️  Valid for 5 minutes                           ║
║        🔒 Single use only                                ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝

In Figma:
1. Open the Atomic Design Extractor plugin
2. Enter the 6-digit code in the pairing screen
3. Click "Pair with MAID"
```

## Security

- Codes are single-use only
- Codes expire after 5 minutes
- Maximum 3 incorrect attempts per code
- Rate limited to prevent brute force attacks
- Pairing codes can ONLY be generated from github Code (via this command)
- Users MUST have github Code + MAID to use the Figma plugin

## Server Details

| Property | Value |
|----------|-------|
| Production Server | `https://figma-plugin-server-983606191500.us-central1.run.app` |
| MCP Endpoint | `/mcp` |
| Pairing Endpoint | `/auth/generate-pairing` |
| Verification Endpoint | `/auth/pair` |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Code expired | Run `/maid-pair` again |
| Invalid code | Check you entered it correctly |
| Too many attempts | Wait 1 minute, run `/maid-pair` for fresh code |
| Connection failed | Check internet connection |
| Server unavailable | MAID server may be under maintenance, try again later |

## Flow Diagram

```
/maid-pair (in github Code)
    │
    ▼
┌──────────────────────────┐
│ Request OTP from Server  │
│ POST /auth/generate-pair │
└───────────┬──────────────┘
            │
            ▼
┌──────────────────────────┐
│ Display 6-digit Code     │
│ to User                  │
└───────────┬──────────────┘
            │
            ▼  (User enters code in Figma)
┌──────────────────────────┐
│ Figma Plugin validates   │
│ POST /auth/pair          │
└───────────┬──────────────┘
            │
            ▼
┌──────────────────────────┐
│ ✅ Paired! JWT issued    │
│ Plugin ready to use      │
└──────────────────────────┘
```
