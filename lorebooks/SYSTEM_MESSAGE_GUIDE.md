# System Message Guide

## Format
`- System Message: <event description>`

Place system messages between paragraphs when significant game events occur.

---

## Purpose
System messages help the auxiliary AI generate accurate status tags by marking clear event boundaries. Without them, the AI must guess from narrative descriptions.

---

## When to Use

Output system messages for:

- **Combat events** - Enemy appears, combat ends (victory/defeat/escape)
- **Training & progression** - Training complete, stat improvements, level ups, trait acquisition
- **Items & currency** - Item acquired/used/lost, gold earned/spent, experience gained
- **Status effects** - Buffs/debuffs applied or removed, equipment changes
- **Healing & recovery** - Resting, healing received, meals
- **Environment** - Time/location/day/weather changes
- **Quests** - Quest accepted/completed, special events

---

## Writing Guidelines

- **Be clear and direct** - State what happened in past tense
- **Be concise** - 1-2 sentences maximum
- **Use natural language** - Write as if narrating to the player
- **Avoid specific numbers** - Exception: value changes like `Gold +150`, `EXP +80`
- **One event per message** - Multiple events = multiple messages

---

## Critical: Combat System Messages

**Combat Start (REQUIRED):**
- `- System Message: [적 이름]이(가) 나타났다. 전투가 시작된다.`

**Combat End (REQUIRED):**
- Victory: `- System Message: 고블린이 쓰러졌다. 전투에서 승리했다.`
- Defeat: `- System Message: 의식을 잃었다. 전투에서 패배했다.`
- Escape: `- System Message: 안전한 곳까지 도망쳤다. 전투가 끝났다.`
- Negotiation: `- System Message: 적이 물러났다. 협상이 성공했다.`

These are **critical** for [Combat:] and [Combat:End] tag generation.

---

## Common Mistakes

❌ **Too vague:** `뭔가 일어났다`
✅ **Clear:** `함정이 발동했다. 독 가스가 방을 가득 채운다.`

❌ **Missing combat marker:** (just narrative, no system message)
✅ **Proper:** `- System Message: 오우거가 나타났다. 전투가 시작된다.`

❌ **Ambiguous ending:** `적이 약해진 것 같다`
✅ **Clear:** `- System Message: 적이 쓰러졌다. 전투에서 승리했다.`

❌ **Multiple events mixed:** `전투가 끝나고 보상을 받고 레벨이 올랐다`
✅ **Separate:** Split into 3 distinct system messages

---

## Summary

1. Did something important happen?
2. Write a clear system message (1-2 sentences, past tense)
3. Trust the auxiliary AI to handle mechanics

**The clearer your system messages, the more accurate the game state management.**
