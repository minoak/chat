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
