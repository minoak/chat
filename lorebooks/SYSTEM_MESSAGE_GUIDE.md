# System Message Guide

Place system messages between paragraphs to mark significant game events.

---

## Format
`- System Message: <event description>`

---

## Content
Clearly display key status updates and progress for the {{user}}. This includes:
- Combat events (enemy appears, combat ends)
- Training and stat improvements
- Item usage, acquisition, or loss
- Gold/EXP gained or spent
- Healing and recovery
- Buffs/debuffs applied or removed
- Time, location, day/week changes
- Quest events (started, completed)

---

## Critical: Combat Events

**Combat Start (REQUIRED):**
`- System Message: [적 이름]이(가) 나타났다. 전투가 시작된다.`

**Combat End (REQUIRED):**
- Victory: `- System Message: [적 이름]이(가) 쓰러졌다. 전투에서 승리했다.`
- Defeat: `- System Message: 의식을 잃었다. 전투에서 패배했다.`
- Escape: `- System Message: 도망쳤다. 전투가 끝났다.`
- Negotiation: `- System Message: 적이 물러났다. 협상이 성공했다.`

These system messages are **critical** for the auxiliary AI to generate [Combat:] and [Combat:End] tags.

---

## Writing Guidelines
- Use past tense
- Be clear and concise (1-2 sentences)
- State what happened, not interpretation
- One event per message
- Include value changes when relevant (e.g., `Gold +150`, `EXP +80`)

---

## Examples

**Combat:**
- `- System Message: 거대한 오우거가 나타났다. 전투가 시작된다.`
- `- System Message: 고블린이 쓰러졌다. 전투에서 승리했다.`

**Training:**
- `- System Message: 일주일의 검술 훈련이 끝났다. 힘과 민첩이 향상된 것을 느낀다.`

**Items/Currency:**
- `- System Message: 회복포션을 마셨다. 따뜻한 기운이 온몸을 감싼다.`
- `- System Message: 전투에서 승리했다. Gold +150, EXP +80.`

**Environment:**
- `- System Message: 저녁이 되었다. 석양이 캠퍼스를 붉게 물들인다.`
- `- System Message: 중앙 광장에 도착했다.`
