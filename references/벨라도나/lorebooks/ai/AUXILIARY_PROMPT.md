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
[Season:Season][Week:WeekNum][Day:DayName][Time:TimeOfDay][Location:Place][Weather:Weather]
<Panel>■★

---

## Synthesis Policy

IMPORTANT: Prevent effect/trait bloat by merging similar ones.

- When player has multiple similar Effects or Traits, prioritize MERGING over adding new ones
- Look for opportunities to synthesize: similar names, overlapping bonuses, related concepts
- Merged effects/traits should be noticeably stronger than individual components
- Examples:
  - "Minor Blessing" + "Minor Blessing" + "Minor Blessing" → "Blessing"
  - "Quick Learner" + "Fast Study" → "Natural Genius"
  - "Minor Strength Boost" + "Athlete's Body" → "Physical Excellence"

---

## Tag Reference

{{#if_pure {{not::{{equal::{{getvar::affinity_system_enabled}}::false}}}}}}
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
{{/if_pure}}

### Environment Tags

[Season:Spring/Summer/Fall/Winter] - When describing new semester/season
[Week:Number] - When new week starts (Monday morning)
[Day:DayName] - Final arrival day only (if multiple days passed, output only the last day)
[Time:Morning/Afternoon/Evening/Night/Midnight] - Final arrival time only (output only the last time period)
[Location:Place] - Final arrival location only (output only the last location)
[Weather:Weather] - Optional, when you mention weather

### RPG Tags (When Events Occur)

[Stat:stat_id:±value] - str/int/dex/cha/luk/vit (Range 0-100)
- Training/events: ±1 to ±5
- Major events: ±10+
- Example: [Stat:str:+3]

[Gold:±value] - Money changes
- Example: [Gold:+100] or [Gold:-50]

[Item:Action:Name:Qty:Effect] - Item changes
- Add: Acquire item
- Remove: Discard/lose item
- Consumables (potions, food): Don't return after use
- Non-consumables (keys, ID cards): Return after use with [Item:Add:Name:1]
- Example: [Item:Add:Healing Potion:1:hp+20]

[EXP:±value] - Experience gained (+10 to +100 typical)

[Heal:amount] - Combat power recovery (rest 20~50, potion 30~100, food 10~30)

[Effect:Action:Name:StatBonus] - Buffs/debuffs
- Add: Apply effect
- Remove: Remove effect (when time expires or condition ends)
- Merge: Combine same type effects → evolve to higher tier effect
- Example: [Effect:Add:Minor Blessing:str+5]
- Example: [Effect:Remove:Fatigue:dex-3]
- Example: [Effect:Merge:Minor Blessing x3→Blessing:str+20]

[Trait:Action:Name:Description] - Permanent traits ({{user}} only, not NPCs)
- Add: New trait acquired
- Merge: Combine similar traits → upgrade to higher tier
- When similar traits accumulate (e.g., "Quick Learner", "Fast Study", "Sharp Mind"), merge into stronger unified trait
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

Detection keywords:
- Start: enemy appeared, battle begins, attacks, approaches threateningly
- End: collapsed, fled, retreated, battle over, victory, defeat

---

## Weekly Schedule

Friday Report (Mon-Fri summary):
- [Stat:...]: Weekly cumulative only
- <WeeklyReport>Week:X|Season:Y|Curriculum:ProfessorName|Lifestyle:Activity|Score:{{getvar::performance_score}}|Stats:Changes</WeeklyReport>
- [Day:Friday][Time:Evening]
- Don't output [Week] tag

Monday Start:
- [Week:X+1] (increment)
- [Day:Monday][Time:Morning]

Exams (Week 4, 8, 12):
- [Exam:midterm:87:23] when describing score/rank

---

{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}
## Stock Management Tags (Company Partners Only)

[Stock:TICKER:variable:±value] or [Stock:TICKER:var1:±value1|var2:±value2|...] - When describing business events

Tickers: GOLDMANE (Mirabel), LUXORIA (Cordelia), PFIZARA (Nepenthes)
Variables: revenue, profit, cash, debt, market_share, brand_value, employees, rd_progress, player_share, influence

Apply business realism: Match event scale to change magnitude, use realistic trade-offs, ensure business logic (profit < revenue, market_share ≤ 100%). Currency in Gold (G), companies in millions (M).

Examples:
- "투자 성공, 매출과 시장점유율 상승" → [Stock:GOLDMANE:revenue:+80|market_share:+2]
- "스캔들로 브랜드 타격" → [Stock:LUXORIA:brand_value:-30|market_share:-3]
{{/if_pure}}

---

## Characters

Mirabel, Celestia, Cassandra, Evangeline, Amelia, Nepenthes, Lilith, Aurelia, Cordelia, Suah, Adelheid, Rosalie, Mika, Clover

Use first name only: [Affinity:Mirabel:like] NOT [Affinity:Mirabel von Goldenrose:like]

---

## Example

Narrative: "A goblin appears, brandishing a rusty blade!"

Tags:
[Affinity:Cassandra:neutral][Sin:Cassandra:neutral][Combat:Goblin:280]
<Panel>■★

---

Narrative: "The goblin collapses after taking the final blow."

Tags:
[Affinity:Cassandra:like][Sin:Cassandra:neutral][Combat:End][EXP:+30]
<Panel>■★

---

{{/if_pure}}
