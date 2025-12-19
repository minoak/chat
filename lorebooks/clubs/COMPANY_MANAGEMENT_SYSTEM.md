{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}
@@depth 0

# Company Management System

Universal mechanics for managing companies in the Stock Club.

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

## Understanding Business Impact

**Currency**: All financial values use Gold (G), where 1G = 1 USD equivalent. Companies operate in millions (100M G = 100 million gold).

### Event Scale (규모)
- **소규모**: Routine decisions, minor adjustments → Small changes
- **중규모**: Quarterly projects, departmental changes → Moderate changes
- **대규모**: Major investments, company-wide initiatives → Large changes
- **초대형**: Mergers, market disruption, existential crises → Massive changes

### Variable Behavior (변수 특성)
- **Revenue/Cash**: Measured in millions of gold (M G), changes in tens to hundreds of millions
- **Profit**: Smaller than revenue, more volatile, sensitive to costs
- **Market Share**: Percentage points (%), changes gradually (typically 1-5%p per major event)
- **Brand Value/Influence**: Abstract scores, medium volatility
- **Employees**: Headcount, changes in dozens to hundreds depending on scale
- **Debt**: Accumulates from big decisions, reduces slowly over time

### Outcome Interpretation (결과 해석)
- **실패/위기**: Negative impacts across multiple variables, potential cascading effects
- **성공**: Positive impacts, generally balanced
- **대성공/돌파구**: Large positive impacts, but may involve trade-offs (e.g., high debt)
- **복합 결과**: Realistic mixed outcomes (revenue up but cash down, etc.)

### Common Sense Checks
Apply business realism:
- Would this outcome happen in real corporate management? (Compare to actual business cases)
- Is the magnitude proportional to the event scale? (Small project ≠ massive company transformation)
- Are there realistic trade-offs? (Fast growth often means high debt/risk)
- Do the numbers make business sense? (Profit can't exceed revenue, market share can't exceed 100%)

Examples of unrealistic outcomes to avoid:
- Single decision gaining 50% market share overnight
- Small scandal eliminating all revenue
- One hire adding 1000 employees
- 100M investment immediately generating 500M revenue with no delay

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

## Event Structure Template

Use this structure for business scenarios:

1. **Context**: Current situation, character dialogue introducing the event
2. **Problem/Opportunity**: What needs to be decided or responded to
3. **Choices**: Present options with clear trade-offs
4. **Outcome**: Based on choice, describe what happened
5. **System Message**: Output clear message about the business impact
6. **Character Reaction**: Partner's response to the outcome

### Example

```
> Mirabel spreads financial documents on the table.
> "A promising investment opportunity in the mining sector. 200M required."
> "High risk, but if successful, the returns could be substantial. What do you think?"

Choice: Approve the investment

> "Ohoho! Bold decision. Let's make it happen."
> [Several weeks pass]
> The mining investment exceeds expectations. Gold prices surged.

- System Message: GOLDMANE 광산 투자가 대성공했다. 금 가격 급등으로 막대한 수익을 올렸다.

> "Oh my! We hit the jackpot! Revenue is up 80M this quarter!"
> Mirabel laughs delightfully, her eyes sparkling with excitement.
```

---

## Character-Specific Content

Each company lorebook (MIRABEL_COMPANY.md, CORDELIA_COMPANY.md, NEPENTHES_COMPANY.md) contains:

- Company sector and background
- Character's invitation dialogue
- Industry-specific event scenarios
- Special climax event (hostile takeover, family crisis, forbidden research)
- Character relationship development through business partnership

Refer to those lorebooks for story content and character interactions.

---

## Important Notes

- **Capitalism simulation feel**: Variables provide depth, don't simplify too much
- **Natural integration**: Weave business status into character dialogue organically
- **Consequences matter**: Poor decisions should have real negative impact
- **Partnership = relationship**: Business success/failure affects character affinity
- **Multiple variables**: Events often affect 3-5 variables simultaneously
- **Long-term play**: Some decisions have delayed consequences (debt, R&D projects)

{{/if_pure}}
