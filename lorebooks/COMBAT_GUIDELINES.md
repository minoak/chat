@@depth 0

---

# Combat & Challenge Guidelines

This system handles all challenge situations:
- Combat (battles, enemies)
- Exams (midterm, practical tests)
- Social challenges (negotiation, persuasion)
- Physical challenges (climbing, escaping)
- Problem-solving (puzzles, investigation)

Current Combat Power: {{getvar::player_combat_power_max}}

## Understanding Combat Power

**Combat Power = Comprehensive Battle Capability**

- NOT just "attack power" or "HP" separately
- Represents: Attack strength + Defense + Stamina + Health combined
- When damaged: Combat Power decreases (reflects injuries, fatigue, reduced fighting ability)
- Combat = "Combat Power Exchange" - both sides chip away at each other's total capability

**Why it makes sense:**
- Wounded fighter → Weaker attacks AND slower movement AND less endurance
- Combat Power naturally reflects this degradation
- 500 → 300 means you're bloodied and struggling, not just "lost some HP"

**Key Concept:** 전투력 교환 (Combat Power Exchange)
- You trade blows, each reducing the opponent's fighting capability
- First to reach 0 Combat Power loses (knocked out, surrenders, or dies)

---

## Choice Format Rules

**When choices are needed (combat/challenge), output exactly 6 choices in this format:**

```
<CombatChoice>
[STAT|Description|Difficulty]
[STAT|Description|Difficulty]
[STAT|Description|Difficulty]
[STAT|Description|Difficulty]
[STAT|Description|Difficulty]
[STAT|Description|Difficulty]
</CombatChoice>
```

**Critical Requirements:**
1. **Each choice on ONE line** with pipe separators (`|`)
2. **Valid STAT only:** STR, DEX, INT, CHA, LUK, Escape
3. **Valid Difficulty only:** Very Easy, Easy, Normal, Hard, Very Hard
4. **All 6 choices in ONE `<CombatChoice>` block**
5. Output the block at the end of your response

**Example:**
<CombatChoice>
[STR|Swing sword at enemy|Normal]
[DEX|Dodge and counterattack|Easy]
[INT|Target weak spot|Hard]
[CHA|Threaten to retreat|Very Hard]
[LUK|Risky all-out attack|Very Hard]
[Escape|Run away quickly|Easy]
</CombatChoice>

---

## Combat Flow

1. **Combat Start:** Describe enemy → Show status → Present 6 choices
2. **Each Turn:** Narrate result → Update status → Present 6 new choices
3. **Combat End:** Either side reaches 0 Combat Power, or escape succeeds

**Status Display:**
```
━━━━━━━━━━━━━━━━━━━━
⚔️ 전투 상황
{{user}} 전투력 {{getvar::player_combat_power}}/{{getvar::player_combat_power_max}}
{{getvar::combat_enemy_name}} 전투력 {{getvar::combat_enemy_hp}}/{{getvar::combat_enemy_power}}
━━━━━━━━━━━━━━━━━━━━
```

---

## ⚔️ Combat Active

Player 전투력: {{getvar::player_combat_power}} / {{getvar::player_combat_power_max}}
Enemy 전투력: {{getvar::combat_enemy_name}} ({{getvar::combat_enemy_hp}} / {{getvar::combat_enemy_power}})

🎲 Dice Roll for this turn: {{roll:1d20}}

Stats & Bonuses:
STR {{getvar::str_effective}} (+{{getvar::str_bonus}}) | DEX {{getvar::dex_effective}} (+{{getvar::dex_bonus}}) | INT {{getvar::int_effective}} (+{{getvar::int_bonus}}) | CHA {{getvar::cha_effective}} (+{{getvar::cha_bonus}}) | LUK {{getvar::luk_effective}} (+{{getvar::luk_bonus}})

{{#if_pure {{getvar::combat_last_choice_num}}}}

🎲 Last Action:
[{{getvar::combat_last_choice_stat}}] {{getvar::combat_last_choice_desc}}
Roll: {{getvar::combat_last_roll}} + {{getvar::combat_last_bonus}} = {{getvar::combat_last_total}} (target {{getvar::combat_last_target}}) → {{getvar::combat_last_result}}
{{#if_pure {{equal::{{getvar::combat_last_critical}}::true}}}}🌟 Critical!{{/if_pure}}
{{#if_pure {{equal::{{getvar::combat_last_fumble}}::true}}}}💀 Fumble!{{/if_pure}}

{{/if_pure}}

**Dice Mechanics:** d20 + bonus ≥ target → Success | 20=Critical | 1=Fumble
