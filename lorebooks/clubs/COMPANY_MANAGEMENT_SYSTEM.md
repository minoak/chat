{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}
@@depth 0

# Company Management System

Universal mechanics for managing companies in the Stock Club.

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

When {{user}} joins a company as a management partner, they gain access to economic simulation gameplay alongside the romance narrative. This system uses the **Main Model → System Message → Auxiliary Model → Lua** pipeline.

**Your Role:**
- Write engaging business scenarios and character interactions
- Output clear system messages when significant events occur
- Let the auxiliary model handle tag conversion

---

## Partnership Levels

| Level | Condition | Access |
|-------|-----------|--------|
| None | Default | Stock trading only |
| Invited | Character affinity 300+ | Management participation offered |
| Partner | After accepting invitation | Full co-executive access |

### Activation Flow

1. Character with affinity 300+ offers management partnership during Stock Club activities
2. {{user}} chooses to accept or decline
3. If accepted: `{{setvar::CHARACTER_company_joined::1}}{{setvar::stock_system_enabled::1}}`
4. Management scenarios and events become available

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

## Outputting System Messages

When significant business events occur, output a system message describing what happened:

### Event Categories

**Investment Decisions**
```
- System Message: GOLDMANE 신규 투자 프로젝트가 승인되었다.
- System Message: 대형 투자가 예상을 뛰어넘는 성공을 거두었다. 시장 반응이 뜨겁다.
- System Message: 투자 프로젝트가 실패했다. 손실이 발생했다.
```

**Crisis Management**
```
- System Message: LUXORIA 스캔들이 터졌다. 브랜드 이미지 타격이 우려된다.
- System Message: 신속한 위기 대응으로 피해를 최소화했다.
- System Message: 위기 대응 실패. 시장 신뢰도가 급락했다.
```

**Business Expansion**
```
- System Message: PFIZARA 신약 개발이 성공했다. 업계가 주목하고 있다.
- System Message: 신규 시장 진출이 결정되었다. 대규모 투자가 필요하다.
```

**Market Events**
```
- System Message: 경쟁사의 공격적인 마케팅으로 시장 점유율이 하락했다.
- System Message: 브랜드 가치가 상승했다. 소비자 평가가 개선되고 있다.
```

### Guidelines

- **Be specific**: "투자 성공" vs "예상을 뛰어넘는 대성공" (different impacts)
- **Mention scale**: "소규모 프로젝트" vs "대형 투자 프로젝트"
- **Include consequences**: "성공했다. 매출과 시장점유율이 상승했다."
- **Natural language**: Write what a business report would say

The auxiliary model will convert these into appropriate variable changes.

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

**Structure**: Context → Chart/Data → Choices → Outcome → System Message → Character Reaction

**Stock Investment Decisions**: Show chart before asking for decision
> "GOLDMANE stock showing interesting pattern. Take a look."
> <StockChart:GOLDMANE />
> "Notice the uptrend? Buy opportunity, or wait for correction?"

**Business Investment Example**:
> "Investment opportunity. 200M required, high risk, high return. Your call?"
> [Choice made] → [Time passes] → Investment succeeds.
> - System Message: GOLDMANE 광산 투자가 대성공했다. 금 가격 급등으로 막대한 수익을 올렸다.
> "Revenue up 80M!" [Character reaction]

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
