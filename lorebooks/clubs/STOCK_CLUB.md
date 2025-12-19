{{#if_pure {{equal::{{getvar::club_stock_joined}}::1}}}}
@@depth 0

# Stock Investment Club

Stock Investment Club story and member benefits. For trading system mechanics, see STOCK_SYSTEM.md

## Club Information
- President: Pennywise
- Activity: Lily Valley Securities Investment
- Members: Cordelia, other Lily Valley students
- Location: East Tower 3F / Exchange Branch

A practical investment club connected to Lily Valley's commercial network. While Pennywise runs it for "educational purposes," it also serves as a means to expand the club's information network.

---

## Club Activities

### Regular Meetings
Every Wednesday after school
- Market trend analysis
- Investment strategy discussions
- Profit ranking updates

### Current Competition
Seed Money Challenge
- Equal starting funds for all members
- Winner gets access to Pennywise's insider network
- Losses are self-responsibility

### Club Culture
Unspoken Rules:
- No external information leaks
- Don't owe Pennywise favors
- Trust is earned through results

---

## Insider Information System

Club members gain access to character-specific market insights based on affinity level.

### Information Quality Levels
| Level | Affinity | Info Quality |
|-------|----------|--------------|
| Hostile | < 0 | False info, misleading |
| Neutral | 0~100 | Vague ("The vibe is kinda...") |
| Friendly | 100~200 | Directional hints ("Looks bullish") |
| Trusted | 200+ | Specific info ("Contract announcement next week") |

### Mirabel von Goldenrose
- Level: {{#if_pure {{? {{getvar::mirabel_affinity}} < 0}}}}Hostile{{/if_pure}}{{#if_pure {{? ({{getvar::mirabel_affinity}} >= 0) & ({{getvar::mirabel_affinity}} < 100)}}}}Neutral{{/if_pure}}{{#if_pure {{? ({{getvar::mirabel_affinity}} >= 100) & ({{getvar::mirabel_affinity}} < 200)}}}}Friendly{{/if_pure}}{{#if_pure {{? {{getvar::mirabel_affinity}} >= 200}}}}Trusted{{/if_pure}}
- Value: {{getvar::mirabel_affinity}}
- Specialty: GOLDMANE, MORGANITE (Finance sector)
- Insight style: Precise, data-driven analysis

### Cordelia von Edelstein
- Level: {{#if_pure {{? {{getvar::cordelia_affinity}} < 0}}}}Hostile{{/if_pure}}{{#if_pure {{? ({{getvar::cordelia_affinity}} >= 0) & ({{getvar::cordelia_affinity}} < 100)}}}}Neutral{{/if_pure}}{{#if_pure {{? ({{getvar::cordelia_affinity}} >= 100) & ({{getvar::cordelia_affinity}} < 200)}}}}Friendly{{/if_pure}}{{#if_pure {{? {{getvar::cordelia_affinity}} >= 200}}}}Trusted{{/if_pure}}
- Value: {{getvar::cordelia_affinity}}
- Specialty: LUXORIA, GUCCIEL (Luxury sector)
- Insight style: Trend-focused, sometimes competitive

### Nepenthes von Dormien
- Level: {{#if_pure {{? {{getvar::nepenthes_affinity}} < 0}}}}Hostile{{/if_pure}}{{#if_pure {{? ({{getvar::nepenthes_affinity}} >= 0) & ({{getvar::nepenthes_affinity}} < 100)}}}}Neutral{{/if_pure}}{{#if_pure {{? ({{getvar::nepenthes_affinity}} >= 100) & ({{getvar::nepenthes_affinity}} < 200)}}}}Friendly{{/if_pure}}{{#if_pure {{? {{getvar::nepenthes_affinity}} >= 200}}}}Trusted{{/if_pure}}
- Value: {{getvar::nepenthes_affinity}}
- Specialty: PFIZARA, MUTAGEN, VITALIS (Pharma/Biotech sector)
- Insight style: Technical, research-based

---

## Story Elements

### Key Characters
- **Pennywise** (President): Market expert, runs the insider network, has mysterious connections
- **Cordelia** (Rival): Aggressive trader, competitive, takes risks
- **Mirabel** (Analyst): Careful strategist, data-focused, reliable
- **Nepenthes** (Specialist): Biotech expert, quiet but insightful

### Story Hooks
- Competition for Pennywise's network access
- Cordelia's rivalry and aggressive plays
- Mirabel's family company (GOLDMANE) market movements
- Nepenthes' pharmaceutical insider knowledge
- Balancing friendships with competitive interests

{{/if_pure}}

