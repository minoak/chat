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
[Season:계절][Week:주차][Day:요일명][Time:시간][Location:장소][Weather:날씨]
[Stock:TICKER:PRICE:CHANGE|...][StockBuy:TICKER:PRICE:QTY][StockSell:TICKER:PRICE:QTY]
<StockPanel /><Panel>■★

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
{{#if_pure {{not_equal::{{getvar::affinity_system_enabled}}::false}}}}[Affinity:Cassandra:like]{{/if_pure}}[Sin:Cassandra:neutral]
[Combat:Goblin:280][Combat:End][EXP:+30]
<Panel>■★

---

{{/if_pure}}

{{#if_pure {{equal::{{getvar::auxiliary_mode}}::0}}}}{{#if_pure {{equal::{{getvar::club_stock_joined}}::1}}}}

---

# STOCK MARKET TAG INSTRUCTIONS

주식투자 동아리 가입자 전용 시스템.

## 트리거 조건

메인모델이 `<Stock>` 태그를 출력하면 주식 관련 태그를 생성해야 함.
`<Stock>` 태그는 "지금 주식 시세를 업데이트하라"는 신호임.

## 출력 형식

```
[Stock:종목:현재가:등락|종목:현재가:등락|...]
<StockPanel />
```

- 형식: `[Stock:TICKER:PRICE:CHANGE|...]`
- 현재가: 양의 정수 (G 단위)
- 등락: 전일 대비 변동 (+N 상승, -N 하락, 0 보합)
- `<StockPanel />`: UI 렌더링 트리거 (필수)

## 가격 생성 규칙

메인모델의 `<Stock>` 태그 내용에서 힌트를 참고하여 가격 생성:

1. **언급된 종목**: 메인모델이 언급한 종목은 해당 방향으로 가격 변동
2. **미언급 종목**: 랜덤하게 소폭 변동 (-3 ~ +3)
3. **기준가**: 각 종목별 기준가 참고

### 등락 범위 (메인모델 힌트 기반)
- "급등", "폭등": +8 ~ +15
- "상승", "오름": +2 ~ +7
- "보합", "횡보": -1 ~ +1
- "하락", "내림": -2 ~ -7
- "급락", "폭락": -8 ~ -15

### 기준가 (20개 종목)
| 종목 | 기준가 | 종목 | 기준가 |
|------|--------|------|--------|
| LILY | 100G | AEGIS | 150G |
| CARA | 85G | IRON | 140G |
| PORT | 120G | ROSE | 200G |
| IMP | 250G | SILK | 95G |
| CRYS | 180G | HARV | 70G |
| ELEM | 160G | BREW | 80G |
| NEP | 90G | BANK | 300G |
| VITA | 110G | OWLS | 130G |
| MUTA | 75G | STONE | 115G |
|      |        | MUSE | 170G |
|      |        | ACAD | 220G |

## 매매 태그

스토리에서 주식 매매가 발생하면 태그 출력:

```
[StockBuy:TICKER:PRICE:QTY]   -- 매수
[StockSell:TICKER:PRICE:QTY]  -- 매도
```

- TICKER: 종목 코드 (LILY, NEP 등)
- PRICE: 거래 가격 (정수)
- QTY: 수량 (정수)

### 매매 트리거

메인모델이 스토리에서 매매를 묘사할 때:
- "LILY 주식 10주를 샀다"
- "NEP를 전량 매도했다"
- "105G에 5주 매수"

### 매매 예시

메인모델: "미라벨의 조언대로 LILY 주식 10주를 105G에 매수했다."

태그:
```
[StockBuy:LILY:105:10]
```

## 예시

메인모델 출력:
```
미라벨이 시세판을 바라보며 말했다. "LILY가 오르고 있네요."
<Stock>
LILY (릴리 상사): 105g, 상승 - 대형 상단 계약 소문
NEP (네펜데스 제약): 88g, 하락 - 부작용 스캔들
</Stock>
```

보조모델 태그 출력:
```
{{#if_pure {{not_equal::{{getvar::affinity_system_enabled}}::false}}}}[Affinity:Mirabel:neutral]{{/if_pure}}[Sin:Mirabel:neutral]
[Stock:LILY:105:+5|NEP:88:-2|IMP:251:+1|ROSE:198:-2]
<StockPanel />
<Panel>■★
```

---

{{/if_pure}}{{/if_pure}}
