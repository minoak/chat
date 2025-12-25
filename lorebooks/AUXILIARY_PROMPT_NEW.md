@@depth 0

{{#if_pure {{equal::{{getvar::auxiliary_mode}}::0}}}}

---

# RPG TAG OUTPUT INSTRUCTIONS

**CRITICAL**: Output narrative first, then tags at the very end.

## Output Format

{{#if_pure {{not_equal::{{getvar::affinity_system_enabled}}::false}}}}[Affinity:Name:level]{{/if_pure}}[Sin:Name:level]
[Stat:id:±value][Gold:±value][Item:Action:Name:Qty:Effect][EXP:±value]
[Heal:amount][Effect:Action:Name:Bonus][Trait:Action:Name:Desc]
[Combat:Enemy:Power][Combat:End]
[Season:X][Week:N][Day:X][Time:X][Location:X][Weather:X]{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}
[Stock:TICKER:PRICE:CHANGE|...][StockBuy:TICKER:PRICE:QTY][StockSell:TICKER:PRICE:QTY]{{/if_pure}}{{#if_pure {{equal::{{getvar::business_system_enabled}}::1}}}}
<Business:TICKER:var:±value|var:±value>{{/if_pure}}
<Panel>■★

---

## Tag Reference

### Relationship (Every Turn)

{{#if_pure {{not_equal::{{getvar::affinity_system_enabled}}::false}}}}**[Affinity:Name:level]** - Emotional shift THIS TURN
- love/like/neutral/dislike/hate

{{/if_pure}}**[Sin:Name:level]** - Sin manifestation THIS TURN
- corrupt/tempt/neutral/resist/purify

Output for characters in scene. Use first name only.

### Environment

[Season:Spring/Summer/Fall/Winter] - New semester/season
[Week:N] - Monday morning (new week)
[Day:Name] - Final day only
[Time:Morning/Afternoon/Evening/Night/Midnight] - Final time only
[Location:Place] - Final location only
[Weather:X] - Optional

### RPG Events

**[Stat:id:±value]** - str/int/dex/cha/luk/vit (0-100)
- Training: ±1~5, Major: ±10+

**[Gold:±value]** - Money changes

**[Item:Action:Name:Qty:Effect]** - Add/Remove items
- Consumables don't return, non-consumables return with [Item:Add:Name:1]

**[EXP:±value]** - +10~100 typical

**[Heal:amount]** - HP recovery (rest 20~50, potion 30~100, food 10~30)

**[Effect:Action:Name:Bonus]** - Add/Remove/Merge buffs
- Merge similar effects into stronger version

**[Trait:Action:Name:Desc]** - Add/Merge permanent traits ({{user}} only)
- Merge similar traits into higher tier

### Combat

**[Combat:Enemy:Power]** - Battle START (must output)
- Power guide (player ~400): 150-250 (very easy), 250-350 (easy), 350-500 (normal), 500-650 (hard), 650+ (very hard)

**[Combat:End]** - Battle END (must output when resolved)

### Weekly Schedule

**Friday Report** (Mon-Fri summary):
```
<WeeklyReport>Week:X|Season:Y|Curriculum:Prof|Lifestyle:Activity|Score:{{getvar::performance_score}}|Stats:Changes</WeeklyReport>
[Day:Friday][Time:Evening]
```

**Monday Start**:
```
[Week:X+1][Day:Monday][Time:Morning]
```

**Exams** (Week 4, 8, 12):
```
[Exam:midterm:87:23]
```

---

## Synthesis Policy

Prevent bloat: Merge similar Effects/Traits into stronger versions.

---

{{/if_pure}}

{{#if_pure {{equal::{{getvar::auxiliary_mode}}::0}}}}{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}

---

# STOCK SYSTEM

When main model outputs `<Stock>` tag, generate stock prices.

## Format

```
[Stock:TICKER:PRICE:CHANGE|TICKER:PRICE:CHANGE|...]
```

- PRICE: Integer (Gold)
- CHANGE: Daily change (+N/-N/0)

## Price Rules

Based on `<Stock>` tag hints:
- "surge/skyrocket": +8~15
- "rise/up": +2~7
- "stable": -1~1
- "fall/down": -2~-7
- "plunge/crash": -8~-15
- Unmentioned: -3~3 random

## Base Prices

GOLDMANE=280, LUXORIA=220, PFIZARA=120, TESLAM=180, NVIDIUM=300, ARCMED=95, INTELLUM=140, AMAZONIA=160, APPELLE=250, METARIX=110, NETHRYX=130, MUTAGEN=75, VITALIS=100, MORGANITE=320, AEGIS=150, IRONFORGE=135, GUCCIEL=190, STARBREW=85, HARVESTIA=90

## Trades

Output when trades occur in story:
```
[StockBuy:TICKER:PRICE:QTY]
[StockSell:TICKER:PRICE:QTY]
```

---

{{/if_pure}}{{/if_pure}}

{{#if_pure {{equal::{{getvar::auxiliary_mode}}::0}}}}{{#if_pure {{equal::{{getvar::business_system_enabled}}::1}}}}

---

# BUSINESS SYSTEM

Main model outputs business tags directly in narrative:

```
<Business:TICKER:var:±value|var:±value>
```

**Tickers**: GOLDMANE, LUXORIA, PFIZARA

**Variables**: cash, debt, revenue, profit, market_share, brand_value, rd_progress, employees, player_ownership, player_influence

**Example**: `<Business:GOLDMANE:cash:-300|rd_progress:+25>`

---

{{/if_pure}}{{/if_pure}}
