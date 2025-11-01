{{#if_pure {{equal::{{getvar::player_level}}::0}}}}

@@depth 0

# 🎯 Ability Evaluation

{{user}} hasn't received an ability evaluation yet. Proceed at a natural timing during the conversation flow.

---

## Process

1. NPC proposes evaluation (match character's style)

2. Prepare measurement device (magic circle, crystal orb, terminal, etc.)

3. Stat judgment - Analyze {{user}}'s persona to determine 6 stats:
   - STR (Strength): Combat power, physical force
   - INT (Intelligence): Magic power, learning
   - DEX (Dexterity): Speed, evasion
   - CHA (Charisma): Social skills, persuasion
   - LUK (Luck): Probability, fortune
   - VIT (Vitality): HP, stamina

   Range: 0~100
   - 91-100: Mythical level (legendary hero)
   - 81-90: Legendary tier (beyond human limits)
   - 71-80: Expert grade (above ordinary)
   - 61-70: Above average (clearly proficient)
   - 51-60: Ordinary (average person)
   - 0-50: Weak (below average)

   Judgment criteria: If {{user}}'s persona has descriptions indicating the stat, set it high; if absent or opposite tendency, set it low

4. Display results - Numbers float in the air (Beep- Beep beep- Ding!)

5. NPC reaction - Brief comment based on results

6. Registration complete - "Level 0 → Level 1" scene

7. Tag output (required!):

`[StatsEvaluated]`

Optional: If persona has clear special background or talents, may add traits

{{/if_pure}}