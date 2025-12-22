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

OR for Korean:

`- System Message: [경영진 합류] 플레이어가 미라벨과 함께 GOLDMANE의 공동 경영자가 되었다.`

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

**For system message format, see SYSTEM_MESSAGE_GUIDE.md**

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

As a management partner, {{user}} has access to economic simulation gameplay alongside the romance narrative.

**Your Role:**
- Write engaging business scenarios and character interactions
- Output system messages when significant events occur (see SYSTEM_MESSAGE_GUIDE.md)
- The auxiliary model converts system messages to variable updates automatically

---

## Management Variables

Each company tracks 12 variables (automatically managed by Lua):

### Financial Health (재무)
- **revenue**: Revenue in millions (매출M)
- **profit**: Net profit in millions (순이익M)
- **cash**: Cash reserves in millions (현금M)
- **debt**: Outstanding debt in millions (부채M)

### Market Position (시장)
- **market_share**: Market share percentage (시장점유율%)
- **brand_value**: Brand value score (브랜드가치)

### Operations (운영)
- **employees**: Number of employees (직원수)
- **rd_progress**: R&D progress percentage (연구개발%)

### Player Stake (플레이어)
- **player_share**: Ownership percentage (보유지분%)
- **influence**: Management influence score (경영영향력)

### Additional Metrics
- **reputation**: Company reputation score
- **valuation**: Company valuation estimate

---

## Current Company Status

**Active Partnership:**
- {{#if_pure {{equal::{{getvar::mirabel_company_joined}}::1}}}}GOLDMANE (Mirabel){{/if_pure}}
- {{#if_pure {{equal::{{getvar::cordelia_company_joined}}::1}}}}LUXORIA (Cordelia){{/if_pure}}
- {{#if_pure {{equal::{{getvar::nepenthes_company_joined}}::1}}}}PFIZARA (Nepenthes){{/if_pure}}

**Key Metrics:** (Access via panel for real-time data)

---

## Business Impact Principles

**Currency**: 1G = 1 USD. Companies operate in millions (M).

**Event Scale**: 소규모 → 중규모 → 대규모 → 초대형 (proportional impact on variables)

**Variable Types**:
- Financial (revenue/profit/cash/debt): Millions of gold
- Market (market_share/brand_value): Percentages/scores
- Operations (employees/rd_progress): Headcount/percentages
- Player (player_share/influence): Percentages/scores

**Realism**: Match magnitude to scale, include trade-offs, respect constraints (profit < revenue, shares ≤ 100%)

---

## Weekly Reports & Panels

### Weekly Management Meetings

When appropriate (weekly meetings, quarterly reviews), show the comprehensive panel:

```
> "Here's this week's report."
> <StockPanel:GOLDMANE />
```

The Lua system will generate a formatted HTML panel displaying all metrics.

### When to Show Panels
- Regular weekly/monthly meetings with partner character
- After major events (post-crisis review, post-expansion analysis)
- When {{user}} asks for status update
- Before major decisions (investment approval meetings)

---

## Event Flow

**Structure**: Context → Data/Metrics → Choices → Outcome → System Message → Character Reaction

**IMPORTANT - Panel Display Rules:**
- Display `<StockPanel:TICKER />` or `<StockChart:TICKER />` **ONLY ONCE per turn**
- Show panels **BEFORE choices** (to inform decisions), NOT after outcomes
- After outcomes, output System Messages only - panels are auto-updated
- Do NOT repeat panels at turn end if already shown

**Providing Decision Context (IMPORTANT)**:
Before major business decisions, show relevant data to inform the choice:

**Investment Decisions** - Show company financials:
> "Major investment opportunity. Let me show you our current position."
> <StockPanel:GOLDMANE />
> "We have 500M cash but 200M debt. This project needs 300M upfront."
> "High risk, but if successful... Your call?"

**Stock Trading** - Show price chart:
> "GOLDMANE stock showing interesting pattern. Take a look."
> <StockChart:GOLDMANE />
> "Notice the uptrend? Buy opportunity, or wait for correction?"

**Crisis Response** - Show impact metrics:
> "Scandal broke. Here's our brand value trend..."
> <StockPanel:LUXORIA />
> "Brand value dropped 15 points. Market share at risk. Respond now or investigate first?"

**Competitor Analysis** - Mention market context:
> "GUCCIEL launched aggressive campaign. They're at 18% market share, we're at 23%."
> "Match their spending and protect share, or differentiate and go premium?"

**Expansion/M&A** - Show financial capacity:
> "SILVERFANG acquisition opportunity. They're asking 400M."
> <StockPanel:GOLDMANE />
> "Our cash: 350M. We'd need to take on 100M debt. Worth it for their 8% market share?"

**Key Principle**: Don't ask blind choices. Give {{user}} information to make informed decisions.

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
