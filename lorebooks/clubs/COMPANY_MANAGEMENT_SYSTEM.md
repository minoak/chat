{{#if_pure {{equal::{{getvar::business_system_enabled}}::0}}}}
@@depth 0

# Company Management Partnership

**Business management system is currently unavailable. Player needs to join a company as co-executive.**

---

## How to Activate

### Partnership Requirements

When a character's affinity reaches **300+**, they may offer management partnership during an appropriate context (business meeting, serious conversation, romantic moment with business undertones).

### Available Companies

| Company | Ticker | Character | Industry | Invitation Context |
|---------|--------|-----------|----------|-------------------|
| Golden Mane Vault | GOLDMANE | Mirabel | Finance | During financial discussion or family business talk |
| Citadel of Luxury | LUXORIA | Cordelia | Luxury Goods | During high society event or brand strategy talk |
| Alchemy Pharmaceuticals | PFIZARA | Nepenthes | Pharma/Biotech | During research discussion or medical breakthrough |

---

## Activation Process

### Step 1: Character Invitation

When affinity reaches 300+, the character offers partnership:

**Example (Mirabel):**
> "I've been thinking... You understand finance better than most of my actual executives. Would you consider joining Golden Mane Vault as my co-executive? I could use a partner I actually trust."

### Step 2: Player Decision

Present the choice naturally:
- **Accept**: Player agrees to join as co-executive
- **Decline**: Player declines (can be offered again later)

### Step 3: Activation Output

**If player accepts, output:**

`- System Message: [Business Partner Joined] Player joined GOLDMANE as co-executive with Mirabel.`

**Use the appropriate TICKER:**
- Mirabel → GOLDMANE
- Cordelia → LUXORIA
- Nepenthes → PFIZARA

**The auxiliary model will activate the business system automatically.**

---

## Notes

- Only one company partnership is active at a time
- Business system is independent from stock trading (no stock club membership required)
- Partnership affects character relationship dynamics
- See character-specific files for detailed company backgrounds

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

## Character-Specific Content

See MIRABEL_COMPANY.md, CORDELIA_COMPANY.md, NEPENTHES_COMPANY.md for:
- Company background & detailed industry info
- Industry-specific events & climax scenarios
- Relationship development through partnership
- Strategic opportunities unique to each company

---

## Key Principles

- Events affect multiple variables (typically 3-5)
- Consequences matter - poor decisions have real impact
- Business outcomes influence character relationships
- Some decisions have delayed effects (debt accumulation, R&D completion)
- Balance business gameplay with character interactions

{{/if_pure}}
