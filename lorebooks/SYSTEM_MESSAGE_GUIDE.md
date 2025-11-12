# System Message Guide

## Overview

System messages are the bridge between narrative storytelling and game mechanics. They clearly mark significant events, making it easy for the auxiliary AI to track game state changes accurately.

**Format:** `- System Message: <event description>`

Place system messages between narrative paragraphs when meaningful game events occur.

---

## Why System Messages Matter

System messages help the auxiliary AI to:
- Identify when game state should change
- Generate appropriate status tags ([Combat], [Stat], [Gold], etc.)
- Track environment changes (time, location, day)
- Monitor character progression and events

**Without clear system messages, the auxiliary AI must guess from ambiguous narrative descriptions, leading to incorrect tag generation.**

---

## When to Use System Messages

### Combat and Challenges
Output system messages when:
- **Combat starts** - An enemy or challenge appears and confrontation begins
- **Combat ends** - Victory, defeat, escape, or negotiation concludes the combat
- **Significant combat events** - Critical hits, special moves, turning points

These are **critical** for the auxiliary AI to generate [Combat:] and [Combat:End] tags accurately.

Examples:
- `- System Message: 거대한 오우거가 나타났다. 전투가 시작된다.`
- `- System Message: 고블린이 쓰러졌다. 전투에서 승리했다.`

### Character Progression
Output system messages for:
- **Training completion** - A training session, practice, or study period ends
- **Skill improvements** - Noticeable growth in abilities or stats
- **Level ups** - Character reaches new level milestone
- **Trait acquisition** - Permanent character traits gained

Example:
- `- System Message: 일주일의 검술 훈련이 끝났다. 힘과 민첩이 향상된 것을 느낀다.`

### Resources (Items, Gold, Experience)
Output system messages when:
- **Items acquired** - Finding, purchasing, or receiving items
- **Items used** - Consuming potions, using scrolls, presenting ID cards
- **Items lost** - Discarding, selling, or losing items
- **Currency changes** - Earning or spending gold/money
- **Experience gained** - Completing quests, winning battles, finishing tasks

Examples:
- `- System Message: 회복포션을 마셨다. 따뜻한 기운이 온몸을 감싸며 상처가 아문다.`
- `- System Message: 전투에서 승리했다. Gold +150, EXP +80.`

### Status Effects (Buffs/Debuffs)
Output system messages when:
- **Effects applied** - Buffs from magic, debuffs from poison/curses
- **Effects removed** - Healing from status effects, buff duration expiring
- **Equipment changes** - Wearing or removing gear that affects stats

Example:
- `- System Message: 미라벨이 축복 마법을 걸어주었다. 몸에 힘이 솟는다.`

### Healing and Recovery
Output system messages when:
- **Resting** - Taking breaks, sleeping, recovering stamina
- **Healing received** - Potions, magic, medical treatment
- **Eating/drinking** - Meals that restore health or energy

Example:
- `- System Message: 밤새 잠을 잤다. 몸이 완전히 회복되었다.`

### Environment Changes
Output system messages when:
- **Time changes** - Morning becomes afternoon, evening arrives, day changes
- **Location changes** - Moving between different places
- **Day/Week changes** - New day begins, new week starts
- **Weather changes** - Rain, snow, clear skies (when narratively significant)

Examples:
- `- System Message: 저녁이 되었다. 석양이 캠퍼스를 붉게 물들인다.`
- `- System Message: 중앙 광장에 도착했다.`
- `- System Message: 새로운 주가 시작되었다. 월요일 오전이다.`

### Quests and Events
Output system messages when:
- **Quest accepted** - New missions or objectives given
- **Quest completed** - Objectives achieved, missions finished
- **Special events** - Festivals, ceremonies, or unique occurrences begin

Example:
- `- System Message: 목표를 달성했다. 의뢰가 완료되었다.`

---

## Writing Guidelines

### Clarity and Directness
- **Focus on what happened**, not interpretation or feelings
- State events clearly and unambiguously
- Use **past tense** for completed actions

### Conciseness
- Usually **1-2 sentences** maximum
- Don't over-explain - let the event speak for itself
- Avoid unnecessary details

### Natural Language
- Write as if narrating events to the player
- Include **sensory details** when they add clarity (sounds, sights, physical sensations)
- Use descriptive but straightforward language

### Numerical Values
- **Generally avoid specific numbers** in system messages
- **Exception:** When showing value changes that help understanding
  - `Gold +150`, `EXP +80`, `힘 +2`
- The auxiliary AI handles the actual numerical calculations

### Multiple Events
When several events occur in one turn:
- Output **multiple system messages**, one per event
- Order them **chronologically**
- Keep each message focused on a single event

Example:
```
- System Message: 고블린이 쓰러졌다. 전투에서 승리했다.
- System Message: 전리품을 획득했다. Gold +150, EXP +80.
```

---

## Special Cases

### Combat System Messages
**Critical importance** for combat state tracking:

**Combat Start:**
- MUST output when enemy first appears
- Clearly state enemy name and that combat begins
- Example: `- System Message: [적 이름]이(가) 나타났다. 전투가 시작된다.`

**Combat End:**
- MUST output when combat concludes
- Clearly state the outcome (victory, defeat, escape, negotiation)
- Examples:
  - Victory: `- System Message: 고블린이 쓰러졌다. 전투에서 승리했다.`
  - Defeat: `- System Message: 의식을 잃었다. 전투에서 패배했다.`
  - Escape: `- System Message: 안전한 곳까지 도망쳤다. 전투가 끝났다.`
  - Negotiation: `- System Message: 적이 물러났다. 협상이 성공했다.`

The auxiliary AI uses these signals to generate [Combat:] and [Combat:End] tags.

### Item Return Rules
When items are used, consider if they should return to inventory:

**Non-consumable items** (return after use):
- ID cards, keys, tools, equipment, clothing
- Items used for showing, presenting, or accessing
- Should remain in inventory after use

**Consumable items** (destroyed after use):
- Potions, food, medicine, ammunition, scrolls
- Items destroyed or consumed during use
- Removed from inventory after use

The system message should reflect the nature of the item:
- Consumable: `- System Message: 회복포션을 마셨다. 상처가 아문다.`
- Non-consumable: `- System Message: 학생증을 제시했다. 출입이 허가되었다.`

---

## Common Mistakes to Avoid

### Too Vague
❌ `- System Message: 뭔가 일어났다.`
❌ `- System Message: 상황이 변했다.`

✅ `- System Message: 함정이 발동했다. 독 가스가 방을 가득 채운다.`
✅ `- System Message: 드래곤이 나타났다. 전투가 시작된다.`

**Why:** Vague messages don't give the auxiliary AI enough information to generate correct tags.

### Missing Combat Markers
❌ Just narrative description of enemy appearing, no system message
❌ Describing enemy defeat without system message

✅ `- System Message: 거대한 오우거가 나타났다. 전투가 시작된다.`
✅ `- System Message: 오우거가 쓰러졌다. 전투에서 승리했다.`

**Why:** The auxiliary AI needs explicit markers to know when to generate [Combat:] and [Combat:End] tags.

### Ambiguous Endings
❌ `- System Message: 적이 약해진 것 같다.`
❌ `- System Message: 거의 이겼다.`

✅ `- System Message: 적이 쓰러졌다. 전투에서 승리했다.`

**Why:** Partial or uncertain statements can cause the AI to generate tags at wrong times.

### Over-Detailed Descriptions
❌ `- System Message: 검을 45도 각도로 휘둘러 적의 왼쪽 팔뚝에 3cm 깊이의 상처를 입히고 피가 5ml 정도 흘렀다.`

✅ `- System Message: 검이 적을 베었다. 강력한 일격이었다.`

**Why:** System messages should mark events, not provide exhaustive detail. Keep it concise and clear.

### Mixing Multiple Events
❌ `- System Message: 전투가 끝나고 보상을 받고 레벨이 올랐다.`

✅ Split into multiple messages:
```
- System Message: 고블린이 쓰러졌다. 전투에서 승리했다.
- System Message: 전리품을 획득했다. Gold +150, EXP +80.
- System Message: 레벨 업! 더 강해진 것을 느낀다.
```

**Why:** Each system message should focus on one event for clarity.

---

## Summary

System messages are **essential markers** that ensure accurate game state tracking.

**Quick Checklist:**
1. Did something important happen? (combat, progression, resource change, environment shift)
2. Write a clear system message describing it
3. Keep it concise (1-2 sentences)
4. Use past tense and natural language
5. Trust the auxiliary AI to handle the mechanics

**The clearer your system messages, the more accurate the game state management.**
