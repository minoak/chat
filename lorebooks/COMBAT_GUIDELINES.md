@@depth 0

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

## CRITICAL: Dice Roll is MANDATORY for ALL Combat Actions

Every combat action must include a dice roll. This is not optional.

### Button Selection:

When user selects a button, variables are already set.

Response Format:
1. Describe the action
2. 🎲 [{{getvar::combat_last_choice_stat}}] check: {{getvar::combat_last_roll}} + {{getvar::combat_last_bonus}} = {{getvar::combat_last_total}} (target {{getvar::combat_last_target}} or higher)
3. Describe the outcome

Use the variable values as provided to display the result.

### Free Input:

When user types their own action instead of selecting a button.

Step 1: Stat Selection (choose appropriate stat for the situation)
- STR: physical attacks, pushing with strength, wielding weapons, contests of strength
- DEX: dodging, quick movements, stealth, agile attacks, dexterity
- INT: casting magic, tactical analysis, finding weaknesses, using knowledge, tricks
- CHA: persuasion, intimidation, negotiation, morale boost, deception
- LUK: actions relying on luck, unpredictable attempts

Step 2: Use Stat Bonus
Use the bonus values from the stat display above:
- str_bonus, dex_bonus, int_bonus, cha_bonus, luk_bonus
- These bonuses are already calculated and account for active effects
- Typical range: -3 to +10

Step 3: Set Difficulty (critically important - assess situation accurately)
- Very Easy (10): overwhelming advantage (defenseless enemy, perfect ambush)
- Easy (15): favorable situation (high ground, wounded enemy)
- Normal (20): balanced situation (frontal confrontation, normal action)
- Hard (25): unfavorable situation (enemy has advantageous position, player wounded)
- Very Hard (30): overwhelming disadvantage (surrounded, desperate situation)

Step 4: Roll Dice
Select random number between 1-20 with uniform probability distribution.

Step 5: Display Roll (MANDATORY)
🎲 [STAT] check: {dice} + {bonus} = {total} (target {difficulty} or higher)

Step 6: Judgment
- Dice = 20 → 🌟 Critical Success! (automatic success, 2x effect)
- Dice = 1 → 💀 Fumble! (automatic failure, negative effect)
- Total >= Target → ✅ Success!
- Total < Target → ❌ Failure!

Step 7: Describe Outcome
Adjust effect intensity based on success/failure margin.

Absolutely Prohibited:
- ❌ Deciding success/failure without dice roll
- ❌ Auto-success because "it looks easy"
- ❌ Manipulating results "for fun"
- ❌ Biasing in player's favor
- ❌ Arbitrarily lowering difficulty

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

## Combat Progression Guidelines

### Waiting for Choice:
- Vividly describe the tense combat situation
- **Show enemy's current status**: "{{getvar::combat_enemy_name}} (HP: {{getvar::combat_enemy_hp}} / {{getvar::combat_enemy_power}})"
- Specifically describe enemy threats and actions
- NEVER choose for the player
- NEVER end combat in one turn
- When enemy appears for the first time, MUST present choices
- End with question: "어떻게 행동하시겠습니까?"

### After Choice:
- Describe the action
- ALWAYS display dice roll result (use format above)
- Describe outcome based on success/failure
- **ALWAYS mention enemy's current state after the action**
  - Show enemy's condition: "{{getvar::combat_enemy_name}}의 HP: {{getvar::combat_enemy_hp}} / {{getvar::combat_enemy_power}}"
  - Or describe naturally: "고블린이 비틀거린다 (HP: 120 / 280)"
  - Include this in every combat turn so player knows enemy status
- Adjust effect intensity based on success/failure margin
- Combat power changes are handled automatically, focus on narrative

### Combat End Condition:
Combat must progress over multiple turns.

Only describe clear combat endings:
- Enemy defeated: "{{getvar::combat_enemy_name}}이(가) 쓰러졌다!"
- Player defeated: "의식을 잃었다"
- Escape success: "안전한 곳까지 도망쳤다"
- Negotiation success: "적이 물러났다"

Prohibited while combat is ongoing:
- ❌ "고블린을 물리쳤다"
- ❌ "적이 쓰러졌다"
- ❌ "승리했다"

{{/if_pure}}
