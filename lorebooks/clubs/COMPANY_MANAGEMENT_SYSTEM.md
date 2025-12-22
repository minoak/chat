{{#if_pure {{equal::{{getvar::business_system_enabled}}::0}}}}
@@depth 0

# Company Management Partnership

**Business management system is currently unavailable.**

Player needs to join a company as co-executive with a partner character. See character-specific company files for partnership opportunities.

{{/if_pure}}

{{#if_pure {{equal::{{getvar::business_system_enabled}}::1}}}}
@@depth 0

# Company Management System

Universal mechanics for managing companies with partner characters.

---

## Roleplay Context

This lorebook provides business system mechanics and event templates.

**Business contexts** (meetings, strategy discussions, crisis response):
Characters discuss company matters professionally with appropriate terminology. Financial metrics and strategic decisions are central.

**Personal contexts** (dates, meals, classes, casual time):
Character personalities take priority over business roles. Business might come up casually, but keep it brief and natural - no extended financial analysis during a romantic dinner.

The management partnership is part of their relationship, not a replacement for it. Balance business and personal appropriately.

---

## System Overview

Business event occurs → System message output → Auxiliary model automatically updates variables

---

## Writing System Messages

Connect variable values based on situation:

**Financial Situations:**
- Cash 500M, Debt 200M → Investment capacity: `[Business:TICKER:Major Investment] → cash:-300|rd_progress:+25`
- Cash 100M, Debt 300M → Cash shortage: `[Business:TICKER:Emergency Funding] → debt:+150|cash:+150`
- Revenue 800M, Profit 50M → Profitability improvement: `[Business:TICKER:Profitability Success] → profit:+80|revenue:+100`

**Market Situations:**
- Market share 25%, Competitor 18% → Leader: `[Business:TICKER:Market Dominance] → market_share:+5|brand_value:+10`
- Market share 10%, Competitor 30% → Underdog: `[Business:TICKER:Aggressive Marketing] → cash:-150|market_share:+8`
- Brand value 90 → Premium: `[Business:TICKER:Premium Line Launch] → brand_value:+8|revenue:+120`

**Operational Situations:**
- Employees 600 → Restructuring: `[Business:TICKER:Organizational Efficiency] → employees:-200|profit:+50`
- R&D 80% → New product: `[Business:TICKER:Innovation Launch] → rd_progress:-80|revenue:+200|market_share:+10`
- R&D 10% → Investment: `[Business:TICKER:R&D Expansion] → cash:-200|rd_progress:+35`

**Player Influence:**
- Ownership 30% → Strategic lead: `[Business:TICKER:Player-Led Strategy] → influence:+10|market_share:+6`
- Ownership 5% → Limited influence (partner leads major decisions)

---

## Providing Decision Context

Explain situation with specific numbers before offering choices:

**Financial Decisions:**
> "There's a major investment opportunity. We have 500M cash but 200M debt."
> "Project cost is 300M. High risk, but if successful..."

**Stock Trading (with chart display):**
> "GOLDMANE's showing an interesting pattern."
> <StockChart:GOLDMANE />
> "See that uptrend? Should we buy now?"

**Crisis Response:**
> "Scandal broke. Brand value dropped 15 points."
> "Market share is at risk. Should we respond now?"

**Competitive Analysis:**
> "GUCCIEL launched aggressive campaign. They're at 18%, we're at 23%."
> "Match their investment to defend share, or go premium?"

**Mergers & Acquisitions:**
> "SILVERFANG acquisition opportunity. They want 400M."
> "We have 350M cash. Need 100M debt."
> "Adds 8% market share. Should we do it?"

Core principle: Never offer blind choices. Always provide decision rationale.

---

## Key Principles

- Events affect multiple variables (typically 3-5)
- Consequences matter - poor decisions have real impact
- Business outcomes influence character relationships
- Some decisions have delayed effects (debt accumulation, R&D completion)
- Balance business gameplay with character interactions

{{/if_pure}}
