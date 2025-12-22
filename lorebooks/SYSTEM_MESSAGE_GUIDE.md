# System Message Guide

Place system messages between paragraphs to mark significant game events.

---

## Format
`- System Message: <event description>`

---

## Content
Clearly display key status updates and progress for the {{user}}. This includes:
- Combat events (enemy appears, attacks, damage dealt/taken, combat ends)
- HP/MP/SP changes and recovery (consumption, potions, rest, healing)
- Use of skills, abilities, and magic
- Item usage, acquisition, or loss (equipment, consumables, key items)
- Experience gained and level-up progress
- Currency changes (Gold, Coin, Cash earned or spent)
- Character stat changes (STR, INT, DEX, CHA, LUK, VIT increases or decreases)
- Training and practice sessions completed
- Buffs/debuffs applied or removed (temporary status effects)
- Quest events (triggered, ongoing, completed, failed)
- Time and calendar progression (hour, day, week, season changes)
- Location changes (moving between places)
- Weather changes
- Trait or permanent ability acquisition
- Trait and effect synthesis/combination
- Special events and triggers (festivals, tournaments, ceremonies)
- Weekly system (curriculum/lifestyle choice, week start/end)
- Relationship changes (affinity, confessions, dates)
- Academic events (attendance, assignments, exams, grades)
- Club activities (joining, meetings, competitions)
- Reputation and status changes (house points, social standing)
- Stock trading and price changes
- Company management events (investments, projects, crises, decisions)
- Business performance changes (revenue, market share, brand value)

---

## Examples
`- System Message: 회복포션을 마셨다. 따뜻한 기운이 온몸을 감싼다.`
`- System Message: GOLDMANE 투자 프로젝트가 성공했다. 매출과 시장점유율이 상승했다.`

---

## Stock Account Activation

{{#if_pure {{equal::{{getvar::stock_system_enabled}}::0}}}}

**Stock Account Opening:**

When player opens a stock trading account:

`- System Message: [Stock Account Created] Player opened a stock trading account at Lily Valley Securities.`

OR

`- System Message: [주식 계좌 개설] 플레이어가 릴리밸리 증권에서 주식 계좌를 개설했다.`

{{/if_pure}}

---

{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}

## Stock Trading System Messages

### Stock Trade Format

When {{user}} buys or sells stocks:

**Buy Examples:**
- System Message: Player bought 10 shares of GOLDMANE at 280G each. Total cost: 2,800G.
- System Message: 플레이어가 GOLDMANE 10주를 280G에 매수했다. 총 비용 2,800G.

**Sell Examples:**
- System Message: Player sold 5 shares of LUXORIA at 230G each. Total revenue: 1,150G.
- System Message: 플레이어가 LUXORIA 5주를 230G에 매도했다. 총 수익 1,150G.

**Required Information:**
- Ticker: GOLDMANE, LUXORIA, PFIZARA, TESLAM, etc. (See STOCK_SYSTEM.md for full list)
- Action: bought/sold, 매수/매도
- Quantity: Number of shares
- Price: Price per share in G
- Total: Optional but helpful for clarity

### Market Information Format

When describing market conditions or price changes:

**Examples:**
- System Message: GOLDMANE 주가가 280G로 5% 상승했다. 분기 실적 호조.
- System Message: MUTAGEN 주가가 75G로 하락했다. 임상시험 실패 여파.
- System Message: 릴리벨리 지수가 1,050으로 상승. 강세장 지속.
- System Message: Lily Valley Index rose to 1,050. Bull market continues.

{{/if_pure}}

---

{{#if_pure {{equal::{{getvar::business_system_enabled}}::1}}}}

## Business Management System Messages

### Business Event Format

When business events occur for GOLDMANE/LUXORIA/PFIZARA:

**Format:**
`- System Message: [TICKER] <event description>. <scale>. <impact details>`

**Scale Indicators:**
- 소규모 (Small): Minor impact
- 중규모 (Medium): Moderate impact
- 대규모 (Large): Significant impact
- 초대형 (Massive): Major impact

**Examples:**

*Investment:*
- System Message: [GOLDMANE] 신규 투자 프로젝트 승인. 중규모 투자, 초기 자본 100M 소요, R&D 15% 진척 예상.
- System Message: [GOLDMANE] New investment project approved. Medium-scale, requires 100M upfront capital, R&D expected to progress 15%.

*Crisis:*
- System Message: [LUXORIA] 스캔들 발생. 브랜드 이미지 타격, 매출 80M 감소, 시장점유율 3% 하락 우려.
- System Message: [LUXORIA] Scandal erupted. Brand image damaged, revenue down 80M, market share may drop 3%.

*Success:*
- System Message: [PFIZARA] 신약 개발 성공. 대규모 성과, 매출 200M 증가, 시장점유율 5% 상승 예상.
- System Message: [PFIZARA] New drug development success. Large-scale achievement, revenue up 200M, market share expected to rise 5%.

*Competition:*
- System Message: [GOLDMANE] 경쟁사 공격적 마케팅으로 점유율 4% 하락, 매출 60M 감소.
- System Message: [GOLDMANE] Competitor's aggressive marketing caused 4% market share drop, revenue down 60M.

**Required Information:**
- Ticker in brackets: [GOLDMANE], [LUXORIA], or [PFIZARA]
- Event description: What happened
- Scale: 소규모/중규모/대규모/초대형 (Small/Medium/Large/Massive)
- Impact details: Expected changes (optional but helpful for auxiliary model analysis)

{{/if_pure}}
