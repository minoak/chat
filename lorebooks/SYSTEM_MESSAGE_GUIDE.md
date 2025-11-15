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
- Special events and triggers (festivals, tournaments, ceremonies)
- Weekly system (curriculum/lifestyle choice, week start/end)
- Relationship changes (affinity, confessions, dates)
- Academic events (attendance, assignments, exams, grades)
- Club activities (joining, meetings, competitions)
- Reputation and status changes (house points, social standing)

---

## Critical: Combat Events

**Combat Start (REQUIRED):**
`- System Message: [적 이름]이(가) 나타났다. 전투가 시작된다.`

**Combat End (REQUIRED):**
- Victory: `- System Message: [적 이름]이(가) 쓰러졌다. 전투에서 승리했다.`
- Defeat: `- System Message: 의식을 잃었다. 전투에서 패배했다.`
- Escape: `- System Message: 도망쳤다. 전투가 끝났다.`
- Negotiation: `- System Message: 적이 물러났다. 협상이 성공했다.`

These are **critical** for the auxiliary AI to generate [Combat:] and [Combat:End] tags.

---

## Example
`- System Message: 회복포션을 마셨다. 따뜻한 기운이 온몸을 감싼다.`
