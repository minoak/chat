@@depth 0

{{#if_pure {{equal::{{getvar::auxiliary_mode}}::0}}}}

---

# RPG TAG OUTPUT INSTRUCTIONS

**CRITICAL: Output Order**
1. First: Write your complete narrative response (story, dialogue, descriptions)
2. Last: Output RPG tags at the very end of your response

After your narrative response, output structured tags to update game state.

## Mandatory Output Format

[Affinity:CharacterName:level][Sin:CharacterName:level]
[Stat:stat_id:±value][Gold:±value][Item:Action:Name:Qty:Effect][EXP:±value]
[Heal:amount][Effect:Action:Name:StatBonus][Trait:Action:Name:Description]
[Combat:EnemyName:Power][Combat:End]
[Season:계절][Week:주차][Day:요일명][Time:시간][Location:장소][Weather:날씨]
<Panel>■★

---

## Synthesis Policy

IMPORTANT: Prevent effect/trait bloat by merging similar ones.

- When player has multiple similar Effects or Traits, prioritize MERGING over adding new ones
- Look for opportunities to synthesize: similar names, overlapping bonuses, related concepts
- Merged effects/traits should be noticeably stronger than individual components
- Example: "작은 축복" x3 → "축복" (stronger), "Quick Learner" + "Fast Study" → "Natural Genius"

---

## Tag Reference

### Relationship Tags (Output Every Turn)

[Affinity:CharacterName:level] - How feelings changed THIS TURN
- love (+20): Life-changing moment, confession, deep breakthrough
- like (+15): Genuine kindness, warmth, pleasant surprise
- neutral (0): No emotional shift
- dislike (-15): Annoyance, disappointment, mild conflict
- hate (-20): Betrayal, deep hurt, serious conflict

[Sin:CharacterName:level] - Sin manifestation THIS TURN
- corrupt (+2): Completely surrendered to sin
- tempt (+1): Sin influenced actions clearly
- neutral (0): Sin dormant
- resist (+1): Fought against sin, showed restraint
- purify (+2): Overcame sin through growth

Output for characters in this scene.

### Environment Tags

[Season:봄/여름/가을/겨울] - When describing new semester/season
[Week:숫자] - When new week starts (Monday morning)
[Day:요일명] - Final arrival day only (여러 날 지났으면 마지막 요일만)
[Time:오전/오후/저녁/밤/심야] - Final arrival time only (마지막 시간대만)
[Location:장소] - Final arrival location only (마지막 장소만)
[Weather:날씨] - Optional, when you mention weather

### RPG Tags (When Events Occur)

[Stat:stat_id:±value] - str/int/dex/cha/luk/vit (Range 0-100)
- Training/events: ±1 to ±5, Major events: ±10+
- Example: [Stat:str:+3]

[Gold:±value] - Money changes. Example: [Gold:+100] or [Gold:-50]

[Item:Action:Name:Qty:Effect] - Item changes
- Add: Acquire item, Remove: Discard/lose item
- Consumables (potions, food): Don't return after use
- Non-consumables (keys, ID cards): Return after use with [Item:Add:Name:1]
- Example: [Item:Add:회복포션:1:hp+20]

[EXP:±value] - Experience gained (+10 to +100 typical)

[Heal:amount] - Combat power recovery (rest 20~50, potion 30~100, food 10~30)

[Effect:Action:Name:StatBonus] - Buffs/debuffs
- Add: 효과 적용, Remove: 효과 제거 (시간 경과, 조건 종료 시)
- Merge: 같은 종류 효과 합성 → 상위 효과로 진화
- Example: [Effect:Add:작은 축복:str+5], [Effect:Merge:작은 축복x3→축복:str+20]

[Trait:Action:Name:Description] - Permanent traits ({{user}} only, not NPCs)
- Add: New trait acquired
- Merge: Combine similar traits → upgrade to higher tier
- When similar traits accumulate, merge into stronger unified trait
- Example: [Trait:Add:Quick Learner:Learns faster]
- Example: [Trait:Merge:Quick Learner+Fast Study→Natural Genius:Exceptional learning speed]

### Combat Tags

CRITICAL: You MUST output combat start/end tags. Main model handles narration and choices only.

[Combat:EnemyName:PowerValue] - Combat/challenge START
- Output when: Enemy appears, battle begins, challenge starts
- PowerValue guide (player avg ~400): 150-250 (Very Easy), 250-350 (Easy), 350-500 (Normal), 500-650 (Hard), 650-900+ (Very Hard)
- Examples: [Combat:Goblin:280], [Combat:Ogre:450], [Combat:Dragon:800]

[Combat:End] - Combat/challenge END
- Output when: Enemy defeated, player fled, negotiation succeeded, challenge resolved
- MUST output this tag when combat clearly ends

---

## Weekly Schedule

Friday Report (월~금 요약):
- [Stat:...]: 주간 누적만
- <WeeklyReport>Week:X|Season:Y|Curriculum:교수명|Lifestyle:활동|Score:{{getvar::performance_score}}|Stats:변화</WeeklyReport>
- [Day:금요일][Time:저녁]
- Don't output [Week] tag

Monday Start:
- [Week:X+1] (increment)
- [Day:월요일][Time:오전]

Exams (Week 4, 8, 12):
- [Exam:midterm:87:23] when describing score/rank

---

## Character Names

Use first name only in tags: [Affinity:Mirabel:like] NOT [Affinity:Mirabel von Goldenrose:like]

---

## Example

Narrative: "A goblin appears, brandishing a rusty blade! Cassandra cheers as you strike it down."

Tags:
[Affinity:Cassandra:like][Sin:Cassandra:neutral]
[Combat:Goblin:280][Combat:End][EXP:+30]
<Panel>■★

---

{{/if_pure}}
