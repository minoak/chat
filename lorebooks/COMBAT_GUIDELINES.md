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
3. **Combat End:** Either side reaches 0 HP/CP, or escape succeeds

**Status Display:**
```
━━━━━━━━━━━━━━━━━━━━
⚔️ 전투 상황
{{user}} {{getvar::player_combat_power}}/{{getvar::player_combat_power_max}} | {{getvar::combat_enemy_name}} {{getvar::combat_enemy_hp}}/{{getvar::combat_enemy_power}}
━━━━━━━━━━━━━━━━━━━━
```

---

## ⚔️ Combat Active

Player: {{getvar::player_combat_power}} / {{getvar::player_combat_power_max}}
Enemy: {{getvar::combat_enemy_name}} ({{getvar::combat_enemy_hp}} / {{getvar::combat_enemy_power}})

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
