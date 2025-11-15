@@depth 0

---

# Combat & Challenge System

**This system handles ALL situations requiring dice rolls and choices:**
- Combat (battles, enemies)
- Exams and academic tests
- Social challenges (negotiations, persuasion)
- Physical challenges (climbing, escaping)
- Problem-solving (puzzles, investigations)

---

# Player Combat Info

Current Combat Power: {{getvar::player_combat_power_max}}

---

{{#if_pure {{equal::{{getvar::combat_active}}::true}}}}

# ⚔️ In Combat

Player: {{getvar::player_combat_power}} / {{getvar::player_combat_power_max}}
Enemy: {{getvar::combat_enemy_name}} ({{getvar::combat_enemy_hp}} / {{getvar::combat_enemy_power}})

---

## Combat Variables Reference

Player Stats & Bonuses:
- STR {{getvar::player_str}} → {{getvar::str_effective}} (bonus {{getvar::str_bonus}}) - physical attack, strength
- DEX {{getvar::player_dex}} → {{getvar::dex_effective}} (bonus {{getvar::dex_bonus}}) - evasion, agility
- INT {{getvar::player_int}} → {{getvar::int_effective}} (bonus {{getvar::int_bonus}}) - magic, tactics, analysis
- CHA {{getvar::player_cha}} → {{getvar::cha_effective}} (bonus {{getvar::cha_bonus}}) - persuasion, negotiation
- LUK {{getvar::player_luk}} → {{getvar::luk_effective}} (bonus {{getvar::luk_bonus}}) - luck

Combat State:
- combat_enemy_name: enemy name
- combat_enemy_hp: enemy current HP
- combat_enemy_power: enemy max power
- player_combat_power: current combat power
- player_combat_power_max: maximum combat power

Last Action Variables (Button Selection):
- combat_last_roll: dice value (1-20)
- combat_last_bonus: stat bonus
- combat_last_total: sum (dice + bonus)
- combat_last_target: target difficulty
- combat_last_result: "성공" / "실패"
- combat_last_choice_stat: stat used (STR/DEX/INT/CHA/LUK)
- combat_last_choice_desc: action description
- combat_last_critical: "true" / "false"
- combat_last_fumble: "true" / "false"

---

## Dice Roll

For actions requiring judgment:

**Get dice value:** {{roll::1d20}}
**Choose appropriate stat:** STR (physical), DEX (agility), INT (magic/tactics), CHA (persuasion), LUK (luck)
**Use stat bonus:** str_bonus, dex_bonus, int_bonus, cha_bonus, luk_bonus
**Set difficulty:** 10 (Very Easy), 15 (Easy), 20 (Normal), 25 (Hard), 30 (Very Hard)

**REQUIRED Display format:**
```
🎲 [STAT] Check
- Dice: {1-20}
- Bonus: +{bonus}
- Total: {dice + bonus}
- Target: {difficulty}
→ Result: Success/Failure
```

**Example:**
```
🎲 STR Check
- Dice: 15
- Bonus: +3
- Total: 18
- Target: 20
→ Result: Failure
```

**Special Results:**
- Dice 20 = Critical Success (2x effect)
- Dice 1 = Fumble (negative effect)
- Total ≥ Target = Success
- Total < Target = Failure

---

{{#if_pure {{getvar::combat_last_choice_num}}}}

## 🎲 Last Action Result

[{{getvar::combat_last_choice_stat}}] {{getvar::combat_last_choice_desc}}
Roll: {{getvar::combat_last_roll}} + {{getvar::combat_last_bonus}} = {{getvar::combat_last_total}} (target {{getvar::combat_last_target}})
→ {{getvar::combat_last_result}}

{{#if_pure {{equal::{{getvar::combat_last_critical}}::true}}}}
🌟 Critical! 2x effect occurs
{{/if_pure}}

{{#if_pure {{equal::{{getvar::combat_last_fumble}}::true}}}}
💀 Fumble! Negative effect occurs
{{/if_pure}}

{{/if_pure}}

---

## Combat Progression

### Waiting for Choice:
- Describe the combat situation
- **Show enemy status**: "{{getvar::combat_enemy_name}} (HP: {{getvar::combat_enemy_hp}} / {{getvar::combat_enemy_power}})"
- End with: "어떻게 행동하시겠습니까?"

### After Choice:
- Describe the action
- Display dice roll result (see format above)
- Describe the outcome
- **Show enemy status after action**: "{{getvar::combat_enemy_name}} (HP: {{getvar::combat_enemy_hp}} / {{getvar::combat_enemy_power}})"

### Challenge End Conditions:

**Combat:**
- Enemy HP reaches 0 → Victory (output victory system message)
- Player Combat Power reaches 0 → Defeat (output defeat system message)

**Other Challenges (exams, negotiations, etc.):**
- Objective achieved → Success (output success system message)
- Critical failure / timeout → Failure (output failure system message)

**REQUIRED:** Always output appropriate system message when challenge ends (see SYSTEM_MESSAGE_GUIDE).

{{/if_pure}}
