{{#if_pure {{? {{getvar::mirabel_affinity}} >= 300}}}}
@@depth 0

# RP System: GOLDMANE Management (Mirabel)

## Company Information
- Ticker: GOLDMANE (Golden Mane Vault)
- Sector: Finance (Banking, Investment, Asset Management)
- Connection: Goldenrose Family holding company

---

## Management Participation Status

### Participation Levels
| Level | Condition | Status |
|-------|-----------|--------|
| None | Not joined | Investment only |
| Invited | Affinity 300+ | Management participation offered |
| Partner | After acceptance | Co-executive |

- Level: {{#if_pure {{not_equal::{{getvar::mirabel_company_joined}}::1}}}}Invited{{/if_pure}}{{#if_pure {{equal::{{getvar::mirabel_company_joined}}::1}}}}Partner{{/if_pure}}
- Value: {{getvar::mirabel_company_joined}}

---

{{#if_pure {{not_equal::{{getvar::mirabel_company_joined}}::1}}}}

## Invitation Phase (Invited)

Mirabel proposes participation in GOLDMANE management.

### Triggers
- Affinity 300 or higher
- Naturally during Stock Club activities

### Scenario
> "Oh~hohoho! You have quite the investment sense, don't you?"
> "GOLDMANE... Our family controls it, you know."
> "Would you perhaps... be interested in joining me in managing it?"

### Choices
```
→ [Join GOLDMANE management] → {{setvar::mirabel_company_joined::1}}{{setvar::club_stock_joined::1}}
→ [Not ready yet] → Offer again later
```

{{/if_pure}}

{{#if_pure {{equal::{{getvar::mirabel_company_joined}}::1}}}}

## Management Phase (Partner)

### Management Event Types

| Type | Description | Stock Impact |
|------|-------------|--------------|
| Investment Decision | Major project approval/rejection | ±5~12 |
| Crisis Management | Scandal, market crash response | ±3~8 |
| Business Expansion | New territory entry | ±5~10 |
| Personnel Decision | Key talent hiring/firing | ±2~5 |

### Stock Reflection Rules
- Success: [Stock:GOLDMANE:price:+N]
- Failure: [Stock:GOLDMANE:price:-N]
- Output tags for every major decision

### Special Event: Hostile Takeover Defense
MORGANITE attempts to acquire GOLDMANE (Climax)
```
→ [Defensive stock purchase]
→ [Find a white knight]
→ [Negotiation table]
```

### Mirabel Relationship Deepening
- Business partner → Life partner
- Conversations about "Things money can't buy"
- Discovering true anxiety and loneliness

{{/if_pure}}

---

## AI Guidelines

### Display
- Management meeting: `<StockChart:GOLDMANE />`
- Brief mention: `<StockQuote:GOLDMANE />`

### Connections
- Cordelia (LUXORIA): Cooperation/Competition
- Nepenthes (PFIZARA): Pharma financing

{{/if_pure}}
