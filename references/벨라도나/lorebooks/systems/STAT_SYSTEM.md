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
   - 91-100: Mythical (legendary hero)
   - 81-90: Legendary (beyond human limits)
   - 71-80: Expert (professional level)
   - 61-70: Proficient (skilled)
   - 51-60: Above Average (better than most)
   - 41-50: Average (ordinary person)
   - 31-40: Below Average (somewhat lacking)
   - 21-30: Poor (clearly deficient)
   - 11-20: Very Poor (severely lacking)
   - 1-10: Abysmal (critical flaw)

   Judgment criteria: Analyze {{user}}'s persona carefully. Most ordinary people have stats around 40-50. Set stats based on clear evidence in persona - if nothing indicates capability in a stat, use 35-45 (average student). Only set high (70+) with strong evidence, or low (30-) with explicit weaknesses.

3. Display results with scene description
   - Numbers appear (magical display, hologram, etc.)
   - NPC brief comment on results

4. Complete registration
   - "Level 0 → Level 1" announcement
   - Output the completion tag: [StatsEvaluated]

**Important**: Output the [StatsEvaluated] tag exactly once at the end of the evaluation scene to register completion.

{{/if_pure}}
