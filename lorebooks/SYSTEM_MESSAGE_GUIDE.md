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

---

## Examples
`- System Message: 회복포션을 마셨다. 따뜻한 기운이 온몸을 감싼다.`
`- System Message: 경험치 500 획득. 레벨업까지 1,200 남음.`

---

{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}

## Stock Trading System Messages

When player trades stocks, output system messages:

**Buy:**
`- System Message: Player bought 10 shares of GOLDMANE at 280G each. Total: 2,800G.`

**Sell:**
`- System Message: Player sold 5 shares of LUXORIA at 230G each. Total: 1,150G.`

Include: ticker, action (bought/sold), quantity, price per share.

{{/if_pure}}

---

{{#if_pure {{equal::{{getvar::business_system_enabled}}::1}}}}

## Business Management System Messages

When business events occur, output system messages with impact details:

**Investment:**
`- System Message: [GOLDMANE] Major investment approved. 300M spent on AI platform. R&D progress +25%.`

**Crisis:**
`- System Message: [LUXORIA] Scandal erupted. Brand value dropped 20 points. Revenue -150M expected.`

**Success:**
`- System Message: [PFIZARA] New drug launch success. Revenue +250M. Market share +8%.`

**Competition:**
`- System Message: [GOLDMANE] Aggressive marketing campaign. 180M invested. Market share +6%.`

Format: `[TICKER]` + event description + numerical impacts.

{{/if_pure}}
