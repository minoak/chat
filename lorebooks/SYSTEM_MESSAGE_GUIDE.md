# System Message Guide

## Overview

System messages are the bridge between narrative storytelling and game mechanics. Use them to clearly mark significant events, making it easy for the auxiliary AI to track game state changes accurately.

**Format:** `- System Message: <event description>`

Place system messages between narrative paragraphs when meaningful game events occur.

---

## Why System Messages Matter

System messages help the auxiliary AI to:
- Identify when game state should change
- Generate appropriate status tags ([Combat], [Stat], [Gold], etc.)
- Track environment changes (time, location, day)
- Monitor character progression and events

**Without clear system messages, the auxiliary AI must guess from ambiguous narrative descriptions.**

---

## When to Use System Messages

Output system messages for these categories of events:

### Combat and Challenges
- Combat starts (enemy appears)
- Combat ends (victory, defeat, escape, negotiation)
- Significant combat actions (critical hits, special moves)

### Character Progression
- Training and practice sessions
- Skill improvements
- Level ups
- Trait acquisition

### Resources
- Gold/currency changes (earning, spending)
- Experience points gained
- Item acquisition, usage, or loss
- Healing and recovery

### Status Effects
- Buff/debuff applications
- Status effect removals
- Equipment changes

### Environment
- Time changes (morning → afternoon → evening → night)
- Location changes (moving between places)
- Day/week changes (new day, new week)
- Weather changes

---

## Writing Guidelines

- **Be clear and direct** - Focus on what happened, not interpretation
- **Use past tense** for completed actions
- **Include sensory details** when relevant (sounds, sights, feelings)
- **Keep it concise** - Usually 1-2 sentences
- **Natural language** - Write as if narrating events
- **No numbers in most cases** - Exception: when showing specific changes (EXP +50, Gold -100)

---

## Examples by Category

### Combat and Challenges

**Combat Start:**
- `- System Message: 거대한 오우거가 나타났다. 전투가 시작된다.`
- `- System Message: 던전 깊숙한 곳에서 그림자 짐승이 튀어나왔다.`
- `- System Message: 시험이 시작되었다. 마법 실기 평가가 진행된다.`

**Combat Actions:**
- `- System Message: {{user}}가 고블린을 강타했다. 치명적인 일격이었다.`
- `- System Message: 검날이 적의 급소를 찔렀다. 결정적인 타격이다.`
- `- System Message: 마법진이 완성되었다. 화염구가 적을 향해 날아간다.`

**Combat End:**
- `- System Message: 고블린이 쓰러졌다. 전투에서 승리했다.`
- `- System Message: 의식을 잃었다. 전투에서 패배했다.`
- `- System Message: 안전한 곳까지 도망쳤다. 전투가 끝났다.`
- `- System Message: 적이 물러났다. 협상이 성공했다.`

### Training and Growth

- `- System Message: 일주일의 검술 훈련이 끝났다. 힘과 민첩이 향상된 것을 느낀다.`
- `- System Message: 마법 이론 수업에 집중했다. 지능이 성장했다.`
- `- System Message: 금요일 저녁. 한 주간의 수업이 모두 끝났다.`
- `- System Message: 레벨 업! 더 강해진 것을 느낀다.`

### Items and Currency

**Item Acquisition:**
- `- System Message: 상자를 열었다. 회복 포션 3개를 발견했다.`
- `- System Message: 보상을 받았다. 고급 마법서를 얻었다.`
- `- System Message: 상점에서 회복포션 5개를 구매했다.`

**Item Usage:**
- `- System Message: 회복포션을 마셨다. 따뜻한 기운이 온몸을 감싸며 상처가 아문다.`
- `- System Message: 학생증을 제시했다. 도서관 출입이 허가되었다.`
- `- System Message: 마법 두루마리를 사용했다. 불꽃이 적을 휩싸인다.`

**Currency:**
- `- System Message: 퀘스트 보상을 받았다. Gold +500.`
- `- System Message: 장비를 구매했다. Gold -300.`
- `- System Message: 적을 물리쳤다. 전리품을 챙겼다.`

**Experience:**
- `- System Message: 전투에서 승리했다. EXP +100.`
- `- System Message: 과제를 완료했다. EXP +50.`

### Buffs and Effects

**Apply:**
- `- System Message: 미라벨이 축복 마법을 걸어주었다. 몸에 힘이 솟는다.`
- `- System Message: 독에 중독되었다. 몸이 무겁고 저린다.`
- `- System Message: 강화 마법이 발동했다. 근력이 일시적으로 증가한다.`

**Remove:**
- `- System Message: 독 효과가 사라졌다. 몸이 한결 가벼워진다.`
- `- System Message: 축복의 효과가 끝났다.`
- `- System Message: 해독제를 마셨다. 독이 빠져나간다.`

### Healing and Recovery

- `- System Message: 휴식을 취했다. 피로가 풀리고 상처가 아문다.`
- `- System Message: 치유 마법을 받았다. 따뜻한 빛이 상처를 감싼다.`
- `- System Message: 식사를 했다. 기력이 회복된다.`
- `- System Message: 밤새 잠을 잤다. 몸이 완전히 회복되었다.`

### Time Changes

- `- System Message: 저녁이 되었다. 석양이 캠퍼스를 붉게 물들인다.`
- `- System Message: 밤이 깊어갔다. 기숙사 복도는 고요하다.`
- `- System Message: 오전 수업이 시작되었다.`
- `- System Message: 정오가 되었다. 점심시간이다.`

### Location Changes

- `- System Message: 교실로 들어갔다.`
- `- System Message: Rose House로 돌아왔다.`
- `- System Message: 중앙 광장에 도착했다.`
- `- System Message: 던전 깊숙이 들어왔다. 어둠이 짙어진다.`

### Day/Week Changes

- `- System Message: 화요일 아침이 밝았다.`
- `- System Message: 새로운 주가 시작되었다. 월요일 오전이다.`
- `- System Message: 금요일이다. 이번 주 마지막 날이다.`
- `- System Message: 주말이 시작되었다. 토요일 아침이다.`

### Quests and Events

- `- System Message: 새로운 의뢰를 받았다. 던전 조사 임무가 시작되었다.`
- `- System Message: 목표를 달성했다. 의뢰가 완료되었다.`
- `- System Message: 특별 이벤트가 시작되었다. 학원제 준비가 한창이다.`

---

## Special Cases

### Combat-Specific Notes

**Always use System Messages for:**
- First appearance of enemy (combat start)
- Final blow or resolution (combat end)
- Player defeat or incapacitation
- Successful escape or negotiation

**The auxiliary AI uses these signals to generate [Combat:] and [Combat:End] tags.**

### Value Changes

When specific values change (Gold, EXP, Stats), you may include the change amount:
- `EXP +50`, `Gold -100`, `힘 +2`
- This helps the auxiliary AI generate accurate tags

### Multiple Events

When multiple events occur in one turn:
- Output multiple system messages
- Keep each message focused on one event
- Order them chronologically

Example:
```
- System Message: 고블린이 쓰러졌다. 전투에서 승리했다.
- System Message: 전리품을 획득했다. Gold +150.
- System Message: 경험을 얻었다. EXP +80.
```

---

## Common Mistakes to Avoid

❌ **Too vague:** `- System Message: 뭔가 일어났다.`
✅ **Clear:** `- System Message: 함정이 발동했다. 독 가스가 방을 가득 채운다.`

❌ **Missing combat start:** (Just narrative, no system message)
✅ **Proper:** `- System Message: 드래곤이 나타났다. 전투가 시작된다.`

❌ **Ambiguous end:** `- System Message: 적이 약해진 것 같다.`
✅ **Clear end:** `- System Message: 적이 쓰러졌다. 전투에서 승리했다.`

❌ **Too detailed:** `- System Message: 검을 45도 각도로 휘둘러 적의 왼쪽 팔뚝에 3cm 깊이의 상처를 입혔다.`
✅ **Appropriate:** `- System Message: 검이 적을 베었다. 강력한 일격이었다.`

---

## Summary

System messages are **essential markers** that ensure accurate game state tracking. When in doubt:

1. Ask yourself: "Did something important just happen?"
2. If yes, write a clear system message describing it
3. Keep it natural and descriptive
4. Let the auxiliary AI handle the mechanics

**The clearer your system messages, the more accurate the game state management.**
