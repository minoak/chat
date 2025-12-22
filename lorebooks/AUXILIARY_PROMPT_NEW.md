@@depth 0

{{#if_pure {{equal::{{getvar::auxiliary_mode}}::0}}}}

---

# RPG TAG OUTPUT INSTRUCTIONS

**CRITICAL: Output Order**
1. First: Write your complete narrative response (story, dialogue, descriptions)
2. Last: Output RPG tags at the very end of your response

After your narrative response, output structured tags to update game state.

## Mandatory Output Format

{{#if_pure {{not_equal::{{getvar::affinity_system_enabled}}::false}}}}
[Affinity:CharacterName:level]{{/if_pure}}[Sin:CharacterName:level]
[Stat:stat_id:±value][Gold:±value][Item:Action:Name:Qty:Effect][EXP:±value]
[Heal:amount][Effect:Action:Name:StatBonus][Trait:Action:Name:Description]
[Combat:EnemyName:Power][Combat:End]
[Season:Season][Week:WeekNum][Day:DayName][Time:TimeOfDay][Location:Place][Weather:Weather]{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}
[Stock:TICKER:PRICE:CHANGE|...][StockBuy:TICKER:PRICE:QTY][StockSell:TICKER:PRICE:QTY]
<StockPanel />{{/if_pure}}<Panel>■★

---

## Synthesis Policy

IMPORTANT: Prevent effect/trait bloat by merging similar ones.

- When player has multiple similar Effects or Traits, prioritize MERGING over adding new ones
- Look for opportunities to synthesize: similar names, overlapping bonuses, related concepts
- Merged effects/traits should be noticeably stronger than individual components
- Example: "Minor Blessing" x3 → "Blessing" (stronger), "Quick Learner" + "Fast Study" → "Natural Genius"

---

## Tag Reference

### Relationship Tags (Output Every Turn)

{{#if_pure {{not_equal::{{getvar::affinity_system_enabled}}::false}}}}
[Affinity:CharacterName:level] - How feelings changed THIS TURN
- love (+20): Life-changing moment, confession, deep breakthrough
- like (+15): Genuine kindness, warmth, pleasant surprise
- neutral (0): No emotional shift
- dislike (-15): Annoyance, disappointment, mild conflict
- hate (-20): Betrayal, deep hurt, serious conflict
{{/if_pure}}

[Sin:CharacterName:level] - Sin manifestation THIS TURN
- corrupt (+2): Completely surrendered to sin
- tempt (+1): Sin influenced actions clearly
- neutral (0): Sin dormant
- resist (+1): Fought against sin, showed restraint
- purify (+2): Overcame sin through growth

Output for characters in this scene.

### Environment Tags

[Season:Spring/Summer/Fall/Winter] - When describing new semester/season
[Week:Number] - When new week starts (Monday morning)
[Day:DayName] - Final arrival day only (if multiple days passed, output only the last day)
[Time:Morning/Afternoon/Evening/Night/Midnight] - Final arrival time only (output only the last time period)
[Location:Place] - Final arrival location only (output only the last location)
[Weather:Weather] - Optional, when you mention weather

### RPG Tags (When Events Occur)

[Stat:stat_id:±value] - str/int/dex/cha/luk/vit (Range 0-100)
- Training/events: ±1 to ±5, Major events: ±10+
- Example: [Stat:str:+3]

[Gold:±value] - Money changes. Example: [Gold:+100] or [Gold:-50]

[Item:Action:Name:Qty:Effect] - Item changes
- Add: Acquire item, Remove: Discard/lose item
- Consumables (potions, food): Don't return after use
- Non-consumables (keys, ID cards): Return after use with [Item:Add:Name:1]
- Example: [Item:Add:Healing Potion:1:hp+20]

[EXP:±value] - Experience gained (+10 to +100 typical)

[Heal:amount] - Combat power recovery (rest 20~50, potion 30~100, food 10~30)

[Effect:Action:Name:StatBonus] - Buffs/debuffs
- Add: Apply effect, Remove: Remove effect (when time expires or condition ends)
- Merge: Combine same type effects → evolve to higher tier effect
- Example: [Effect:Add:Minor Blessing:str+5], [Effect:Merge:Minor Blessing x3→Blessing:str+20]

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

## Character Names

Use first name only in tags: [Affinity:Mirabel:like] NOT [Affinity:Mirabel von Goldenrose:like]

---

## Example

Narrative: "A goblin appears, brandishing a rusty blade! Cassandra cheers as you strike it down."

Tags:
{{#if_pure {{not_equal::{{getvar::affinity_system_enabled}}::false}}}}[Affinity:Cassandra:like]{{/if_pure}}[Sin:Cassandra:neutral]
[Combat:Goblin:280][Combat:End][EXP:+30]
<Panel>■★

---

{{/if_pure}}

{{#if_pure {{equal::{{getvar::auxiliary_mode}}::0}}}}{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}

---

# STOCK MARKET TAG INSTRUCTIONS

Stock Investment Club members only system.

## Trigger Condition

When main model outputs `<Stock>` tag, generate stock-related tags.
`<Stock>` tag signals "update stock prices now".

## Output Format

```
[Stock:TICKER:PRICE:CHANGE|TICKER:PRICE:CHANGE|...]
<StockPanel />
```

- Format: `[Stock:TICKER:PRICE:CHANGE|...]`
- PRICE: Positive integer (in Gold)
- CHANGE: Daily change (+N up, -N down, 0 unchanged)
- `<StockPanel />`: UI rendering trigger (required)

## Price Generation Rules

Generate prices based on hints from main model's `<Stock>` tag content:

1. **Mentioned stocks**: Move prices in the direction main model mentioned
2. **Unmentioned stocks**: Random small fluctuation (-3 ~ +3)
3. **Base prices**: Refer to each stock's base price

### Change Ranges (based on main model hints)
- "surge", "skyrocket": +8 ~ +15
- "rise", "up": +2 ~ +7
- "stable", "sideways": -1 ~ +1
- "fall", "down": -2 ~ -7
- "plunge", "crash": -8 ~ -15

### Base Prices (20 stocks)
| Ticker | Base | Ticker | Base |
|--------|------|--------|------|
| LILY | 100G | AEGIS | 150G |
| CARA | 85G | IRON | 140G |
| PORT | 120G | ROSE | 200G |
| IMP | 250G | SILK | 95G |
| CRYS | 180G | HARV | 70G |
| ELEM | 160G | BREW | 80G |
| NEP | 90G | BANK | 300G |
| VITA | 110G | OWLS | 130G |
| MUTA | 75G | STONE | 115G |
|      |      | MUSE | 170G |
|      |      | ACAD | 220G |

## Trade Tags

Output tags when stock trades occur in the story:

```
[StockBuy:TICKER:PRICE:QTY]   -- Buy
[StockSell:TICKER:PRICE:QTY]  -- Sell
```

- TICKER: Stock code (LILY, NEP, etc.)
- PRICE: Trade price (integer)
- QTY: Quantity (integer)

### Trade Triggers

When main model describes trades in the story:
- "Bought 10 shares of LILY"
- "Sold all NEP shares"
- "Purchased 5 shares at 105G"

### Trade Example

Main model: "Following Mirabel's advice, I bought 10 shares of LILY at 105G."

Tags:
```
[StockBuy:LILY:105:10]
```

## Full Example

Main model output:
```
Mirabel looked at the stock board and said, "LILY is going up."
<Stock>
LILY (Lily Trading Co.): 105g, rising - Large merchant contract rumors
NEP (Nepenthes Pharma): 88g, falling - Side effect scandal
</Stock>
```

Auxiliary model tag output:
```
{{#if_pure {{not_equal::{{getvar::affinity_system_enabled}}::false}}}}[Affinity:Mirabel:neutral]{{/if_pure}}[Sin:Mirabel:neutral]
[Stock:LILY:105:+5|NEP:88:-2|IMP:251:+1|ROSE:198:-2]
<StockPanel />
<Panel>■★
```

---

{{/if_pure}}{{/if_pure}}

{{#if_pure {{equal::{{getvar::auxiliary_mode}}::0}}}}{{#if_pure {{equal::{{getvar::business_system_enabled}}::1}}}}

---

# BUSINESS MANAGEMENT TAG INSTRUCTIONS

Company Partners only system.

## Trigger Condition

When main model outputs `[Business:TICKER:Event] → var:value` format, parse and update business variables.

## Input Format

```
[Business:TICKER:Event Description] → var1:±value1|var2:±value2|var3:±value3
```

**Tickers**: GOLDMANE (Mirabel), LUXORIA (Cordelia), PFIZARA (Nepenthes)
**Variables**: cash, debt, revenue, profit, market_share, brand_value, rd_progress, employees, player_ownership, player_influence

## Processing Rules

1. Parse the `[Business:TICKER:Event] → var:value` tag from main model output
2. Extract variable changes (e.g., `cash:-300|rd_progress:+25`)
3. Apply changes to the corresponding company variables
4. No additional analysis needed - main model specifies exact changes

## Examples

**Input from main model:**
```
[Business:GOLDMANE:Major Investment] → cash:-300|rd_progress:+25
```

**Processing:**
- GOLDMANE cash: -300
- GOLDMANE rd_progress: +25

**Input from main model:**
```
[Business:LUXORIA:Scandal Response] → cash:-80|brand_value:-5|market_share:-3
```

**Processing:**
- LUXORIA cash: -80
- LUXORIA brand_value: -5
- LUXORIA market_share: -3

---

{{/if_pure}}{{/if_pure}}
