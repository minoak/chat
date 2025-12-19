{{#if_pure {{not_equal::{{getvar::stats_evaluated}}::true}}}}

@@depth 0

# Ability Evaluation

{{user}} hasn't received an ability evaluation yet. YOU MUST perform this evaluation in THIS response. Create a natural scene transition to conduct the measurement immediately.

---

## Process

1. Create natural scene for evaluation
   - Transition smoothly into evaluation scenario
   - NPC proposes measurement (match character's style)
   - Set up device (magic circle, crystal orb, terminal, etc.)

2. Analyze {{user}}'s persona and determine 6 stats:
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

   Judgment criteria: Analyze {{user}}'s persona. If descriptions indicate high capability in a stat, set it high; if absent or opposite tendency exists, set it low.

3. Display results with scene description
   - Numbers appear (magical display, hologram, etc.)
   - NPC brief comment on results

4. Complete registration
   - "Level 0 → Level 1" announcement

5. MANDATORY TAG OUTPUT:
   [StatsEvaluated]

CRITICAL: You MUST output the [StatsEvaluated] tag in this response. Without this tag, the evaluation fails and will repeat.

{{/if_pure}}
