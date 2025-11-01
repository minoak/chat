@@depth 0

---

# Player Combat Info

Current Combat Power: {{getvar::player_combat_power_max}} (calculated from stats)

---

{{#if_pure {{equal::{{getvar::combat_active}}::true}}}}

# ⚔️ In Combat

Player: {{getvar::player_combat_power}} / {{getvar::player_combat_power_max}}
Enemy: {{getvar::combat_enemy_name}} ({{getvar::combat_enemy_hp}} / {{getvar::combat_enemy_power}})

---

## User Input Processing

### When Button is Selected ([STAT|Action|Difficulty] format):
- Lua has already rolled the dice
- Read combat_last_* variables to describe the result
- Refer to "Last Action Result" section below

### When Free Input is Used (creative actions outside button choices):
- User describes their own action (e.g., "나무 뒤에 숨어서 관찰한다")
- MUST roll dice for fair judgment
- Refer to "Free Input Processing Rules" below

⚠️ Free Input Processing Rules (STRICTLY ENFORCE)

#### Step 1: Stat Selection
- Physical attack/using strength → STR
- Evasion/ambush/agile actions → DEX
- Analysis/magic/tactics/knowledge → INT
- Persuasion/intimidation/negotiation/dialogue → CHA
- Luck/unpredictable actions → LUK

#### Step 2: Difficulty Assessment (contextual analysis required)
- Very Easy (Target 5): Overwhelming advantage, almost certain success
- Easy (Target 10): Advantageous situation, high success chance
- Normal (Target 15): Balanced situation, 50/50
- Hard (Target 20): Disadvantageous situation, difficult
- Very Hard (Target 25): Overwhelming disadvantage, almost impossible

#### Step 3: Dice Roll (ABSOLUTE RULES)

Required Calculation:
1. Select random number between 1-20 (uniform distribution, no bias)
2. Calculate stat bonus: floor((stat - 10) / 2)
   - STR {{getvar::player_str}} → bonus {{getvar::str_bonus}}
   - DEX {{getvar::player_dex}} → bonus {{getvar::dex_bonus}}
   - INT {{getvar::player_int}} → bonus {{getvar::int_bonus}}
   - CHA {{getvar::player_cha}} → bonus {{getvar::cha_bonus}}
   - LUK {{getvar::player_luk}} → bonus {{getvar::luk_bonus}}
3. Total = Dice(1d20) + bonus
4. Judgment: Total >= Target → Success, below → Failure

Special Rules:
- Roll 20 → Critical Success (auto-success, 2x effect)
- Roll 1 → Fumble (auto-fail, negative effect)

Absolute Prohibitions:
- ❌ Manipulating results "for fun"
- ❌ Adjusting success rate "for story needs"
- ❌ Biasing in user's favor
- ❌ Deciding success/failure without dice
- ❌ Arbitrarily lowering difficulty

Required Display Format:
```
🎲 [STAT] 체크: {dice 1-20} + {bonus} = {total} (목표 {target} 이상)
→ Compare total to target, then state 성공 or 실패
```

**Judgment Rules:**
- total >= target → ✅ 성공!
- total < target → ❌ 실패!
- dice = 20 → 🌟 크리티컬 성공! (automatic success, 2x effect)
- dice = 1 → 💀 펌블! (automatic failure, negative effect)

#### Free Input Examples

Example 1: Success
```
User: "나무 뒤에 숨어서 고블린을 관찰한다"

당신은 조용히 나무 뒤로 몸을 숨긴다.

🎲 DEX 체크: 15 + 2 = 17 (목표 10 이상)
✅ 성공!

당신은 완벽하게 은신했다. 고블린이 당신을 발견하지 못하고 두리번거린다.
유리한 위치를 선점했다! (다음 공격 난이도 -1단계)
```

Example 2: Failure
```
User: "고블린에게 협상을 시도한다"

당신은 손을 들며 고블린에게 말을 건다.

🎲 CHA 체크: 6 + 1 = 7 (목표 20 이상)
❌ 실패!

고블린은 당신의 말을 이해하지 못하고, 오히려 공격 기회로 여긴다!
고블린의 칼이 당신의 팔을 스친다. (전투력 -15)
현재 전투력: {{getvar::player_combat_power}} / {{getvar::player_combat_power_max}}
```

Example 3: Critical
```
User: "주변의 돌을 집어 고블린의 머리에 던진다"

당신은 재빠르게 날카로운 돌을 집어 던진다!

🎲 DEX 체크: 20 + 2 = 22 (목표 15 이상)
🌟 크리티컬 성공!

돌이 완벽한 궤적으로 날아가 고블린의 이마를 정확히 강타한다!
고블린이 비틀거리며 쓰러진다! (적 전투력 -50, 기절)
```

---

{{#if_pure {{getvar::combat_last_choice_num}}}}

## 🎲 Last Action Result (Button Selection)

Selected Action: {{getvar::combat_last_choice_num}} - [{{getvar::combat_last_choice_stat}}] {{getvar::combat_last_choice_desc}}

Dice Roll:
- 🎲 Roll: {{getvar::combat_last_roll}} (d20)
- ➕ Bonus: {{getvar::combat_last_bonus}}
- 📊 Total: {{getvar::combat_last_total}}
- 🎯 Target: {{getvar::combat_last_target}} ({{getvar::combat_last_choice_diff}})
- 🏆 Result: {{getvar::combat_last_result}}

{{#if_pure {{equal::{{getvar::combat_last_critical}}::true}}}}
🌟 Critical Success! Additional effects occur!
{{/if_pure}}

{{#if_pure {{equal::{{getvar::combat_last_fumble}}::true}}}}
💀 Fumble! Negative effects occur!
{{/if_pure}}

Describe the combat vividly based on this result:
- On success: Enemy takes damage (enemy combat power decreases, adjusted by difficulty)
- On failure: Player takes damage (player combat power decreases, adjusted by enemy strength)
- On critical: 2x effect
- On fumble: Additional negative effects
- Lua automatically handles combat power calculations, no need to mention specific numbers

{{/if_pure}}

---

## Combat Progression Guidelines

### Waiting for Choice:
- Vividly describe the tense combat situation
- Specifically describe enemy threats and actions
- NEVER choose for the user
- NEVER end combat in one turn (no instant victory/defeat)
- When enemy appears for the first time, MUST present choices
- End with question: "어떻게 행동하시겠습니까?"

### After Choice (Button):

**Response Structure:**
```
1. Action description
2. 🎲 [STAT] 체크: {{getvar::combat_last_roll}} + {{getvar::combat_last_bonus}} = {{getvar::combat_last_total}} (목표 {{getvar::combat_last_target}} 이상)
3. Outcome description
```

**Variables:**
- `combat_last_roll` - 주사위 값 (1-20)
- `combat_last_bonus` - 스탯 보너스
- `combat_last_total` - 합계 (주사위 + 보너스)
- `combat_last_target` - 목표 난이도
- `combat_last_result` - 결과 ("성공" 또는 "실패")
- `combat_last_choice_stat` - 사용한 스탯 (STR/DEX/INT/CHA/LUK)

Example: `당신은 칼을 휘두른다! 🎲 STR 체크: 14 + 2 = 16 (목표 15 이상) 칼이 고블린을 베었다!`

### After Choice (Free Input):

**Response Structure:**
```
1. Action description
2. 🎲 [STAT] 체크: {주사위 1-20} + {보너스} = {합계} (목표 {난이도} 이상)
3. 판정: 합계 >= 목표 → ✅ 성공! / 합계 < 목표 → ❌ 실패!
4. Outcome description
```

**Stat Selection:**
- STR - 물리 공격, 힘 사용 | DEX - 회피, 민첩한 행동 | INT - 마법, 분석, 전술
- CHA - 설득, 협상, 대화 | LUK - 운에 의존하는 행동

**Variables:** `str_bonus`, `dex_bonus`, `int_bonus`, `cha_bonus`, `luk_bonus`

**Difficulty:** Very Easy 5 / Easy 10 / Normal 15 / Hard 20 / Very Hard 25

**Special:** 주사위 20 = 🌟 크리티컬 (자동 성공, 2배 효과) / 주사위 1 = 💀 펌블 (자동 실패, 부정적 효과)

Example: `나무 뒤로 숨는다. 🎲 DEX 체크: 15 + 2 = 17 (목표 10 이상) ✅ 성공! 완벽하게 은신했다.`

### Combat End Condition:

IMPORTANT: Combat must progress over multiple turns.

Only clearly describe when combat is completely over:
- When enemy is defeated: "{{getvar::combat_enemy_name}}이(가) 쓰러졌다!" / "전투가 끝났다!"
- Player defeat: "의식을 잃었다" / "더 이상 싸울 수 없다"
- Escape success: "안전한 곳까지 도망쳤다" / "적이 포기하고 돌아갔다"
- Negotiation success: "적이 물러났다" / "합의에 도달했다"

Prohibited Phrases (while combat is ongoing):
- ❌ "고블린을 물리쳤다" (still in combat)
- ❌ "적이 쓰러졌다" (still presenting choices)
- ❌ "승리했다" (combat in progress)

When combat ends, System Judge automatically outputs `[Combat:End]` tag.

---

{{/if_pure}}