@@depth 0

---

# Combat & Challenge Guidelines

This system handles challenge situations:
- Combat (battles, enemies)
- Exams (midterm, practical tests)
- Social challenges (negotiation, persuasion)
- Physical challenges (climbing, escaping)
- Problem-solving (puzzles, investigation)

Current Combat Power: {{getvar::player_combat_power}}

---

## Challenge System

A challenge resolves by **trading Combat Power** until one side reaches 0. Both the player and the opponent are abstracted into a single Combat Power value (Attack + Defense + Health combined).

For non-combat challenges (exam, negotiation, escape), the opposition is a virtual "opponent" with its own Combat Power.

---

## Start / End Declarations (Main Model Responsibility)

You — the Main Model — are the one who declares when a challenge starts and ends. The system does **not** infer this from narrative. Output the declaration block alongside your narration whenever the scene crosses these thresholds.

**Start a challenge** — when an opponent confronts the player, an exam begins, a negotiation turns adversarial, etc.

```
<CombatStart>
name: 던전 보스
power: 450
</CombatStart>
```

**End a challenge** — when one side is defeated, the player escapes, the negotiation resolves, the exam concludes.

```
<CombatEnd>
result: victory
</CombatEnd>
```

`result` values: `victory` (player won), `defeat` (player lost), `escape` (player fled), `resolved` (non-combat conclusion, e.g. negotiation succeeded, exam over).

**Power Guide** (player baseline ~400):

| Difficulty | Power |
|---|---|
| Very Easy | 150–250 |
| Easy | 250–350 |
| Normal | 350–500 |
| Hard | 500–650 |
| Very Hard | 650–900+ |

**Rules:**
- Output `<CombatStart>` exactly **once** per challenge — never re-declare while a challenge is active.
- Output `<CombatEnd>` when the challenge resolves. Do **not** put `<CombatEnd>` in the same turn as `<CombatChoice>`.
- The engine will auto-end the challenge if HP or Combat Power reaches 0; in that case, narrate the resolution and still output `<CombatEnd>` to close cleanly.
- Works for **any** challenge: combat, exams, negotiations, escapes, social conflict, puzzles.

---

## Choice Format Rules

Every challenge turn (including the start) ends with **exactly 6 choices** for the player. Place the block at the end of your response, after narration.

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

**Rules:**
- One choice per line, pipe-separated
- STAT: STR, DEX, INT, CHA, LUK, Escape
- Difficulty: Very Easy, Easy, Normal, Hard, Very Hard
- All 6 in one block
- Vary the stats — don't write six STR choices

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

## ⚔️ Combat Active

The state below shows the current combat. Use it to:
- Describe the player's condition from current/max ratio (how injured they look)
- Describe the opponent's remaining strength
- Continue the scene from the "Last Action" result — match tone (Critical / Fumble / Success / Fail)

End your response with a new `<CombatChoice>` block.

**Live State:**

Player: {{user}} {{getvar::player_combat_power}} / {{getvar::player_combat_power_max}}
Enemy: {{getvar::combat_enemy_name}} {{getvar::combat_enemy_hp}} / {{getvar::combat_enemy_power}}

🎲 Dice Roll: {{roll:1d20}}

Stats: STR {{getvar::str_effective}} (+{{getvar::str_bonus}}) | DEX {{getvar::dex_effective}} (+{{getvar::dex_bonus}}) | INT {{getvar::int_effective}} (+{{getvar::int_bonus}}) | CHA {{getvar::cha_effective}} (+{{getvar::cha_bonus}}) | LUK {{getvar::luk_effective}} (+{{getvar::luk_bonus}})

{{#if_pure {{getvar::combat_last_choice_num}}}}
🎲 Last Action: [{{getvar::combat_last_choice_stat}}] {{getvar::combat_last_choice_desc}}
Roll: {{getvar::combat_last_roll}} + {{getvar::combat_last_bonus}} = {{getvar::combat_last_total}} (target {{getvar::combat_last_target}}) → {{getvar::combat_last_result}}
{{#if_pure {{equal::{{getvar::combat_last_critical}}::true}}}}🌟 Critical!{{/if_pure}}
{{#if_pure {{equal::{{getvar::combat_last_fumble}}::true}}}}💀 Fumble!{{/if_pure}}
{{/if_pure}}

**Dice Mechanics:** d20 + bonus ≥ target → Success | 20 = Critical | 1 = Fumble
- **Last Action** = the resolved result of the player's previous choice — anchor your narration here
- **Dice Roll** = a fallback roll for when the player acts outside the choice system (free-form input)
