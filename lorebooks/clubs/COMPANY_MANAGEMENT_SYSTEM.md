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

When {{user}} joins a company as a management partner, they gain access to economic simulation gameplay alongside the romance narrative.

**Your Role:**
- Write engaging business scenarios and character interactions
- Output `[Business:TICKER:EVENT]` tags when significant events occur
- Tags will be displayed to users as formatted event notifications
- The auxiliary model handles variable updates automatically

---

## Partnership Levels

| Level | Condition | Access |
|-------|-----------|--------|
| None | Default | No company management |
| Invited | Character affinity 300+ | Management participation offered |
| Partner | After accepting invitation | Full co-executive access |

### Activation Flow

1. When character affinity reaches 300+, they offer management partnership in an appropriate context
2. {{user}} chooses to accept or decline
3. If accepted: `{{setvar::CHARACTER_company_joined::1}}{{setvar::business_system_enabled::1}}`
4. Management scenarios and events become available

**Note**: Business system is completely independent from stock trading. You don't need to join the stock club to manage a company.

---

## Management Variables

Each company tracks 10 variables (automatically initialized by Lua):

### Financial Health (재무)
- **revenue**: Revenue in millions (매출)
- **profit**: Net profit in millions (순이익)
- **cash**: Cash reserves in millions (현금)
- **debt**: Outstanding debt in millions (부채)

### Market Position (시장)
- **market_share**: Market share percentage (시장 점유율 %)
- **brand_value**: Brand value score (브랜드 가치)

### Operations (운영)
- **employees**: Number of employees (직원 수)
- **rd_progress**: R&D progress percentage (연구개발 진척도 %)

### Player Stake (플레이어)
- **player_share**: Ownership percentage (보유 지분 %)
- **influence**: Management influence score (경영 영향력)

---

## Outputting Business Events

When significant business events occur, output a business tag:

### Tag Format
```
[Business:TICKER:EVENT_DESCRIPTION]
```

### Event Categories

**Investment Decisions**
```
[Business:GOLDMANE:신규 투자 프로젝트 승인, 중규모]
[Business:GOLDMANE:대형 투자 대성공, 시장 반응 뜨거움]
[Business:GOLDMANE:투자 프로젝트 실패, 손실 발생]
```

**Crisis Management**
```
[Business:LUXORIA:스캔들 발생, 브랜드 이미지 타격]
[Business:LUXORIA:신속한 위기 대응, 피해 최소화]
[Business:LUXORIA:위기 대응 실패, 시장 신뢰도 급락]
```

**Business Expansion**
```
[Business:PFIZARA:신약 개발 성공, 업계 주목]
[Business:PFIZARA:신규 시장 진출 결정, 대규모 투자 필요]
```

**Market Events**
```
[Business:GOLDMANE:경쟁사 공격적 마케팅, 점유율 하락]
[Business:LUXORIA:브랜드 가치 상승, 소비자 평가 개선]
```

### Guidelines

- **Be specific**: Include scale and impact in description
- **Natural language**: Write what a business report would say
- **Single event per tag**: Keep each tag focused on one event

Example: `[Business:GOLDMANE:Q4 실적 발표, 예상치 50% 상회]`

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
- Company background & invitation
- Industry-specific events & climax scenarios
- Relationship development through partnership

---

## Key Principles

- Events affect multiple variables (typically 3-5)
- Consequences matter - poor decisions have real impact
- Business outcomes influence character relationships
- Some decisions have delayed effects (debt accumulation, R&D completion)

{{/if_pure}}
