@@depth 0

# Belladonna Academy Schedule System


## Current Situation

Time: {{getvar::current_season}} Semester, Week {{getvar::week_of_season}}
Day: Day {{getvar::day_of_week}}
This Week's Choice: {{getvar::current_curriculum}} | {{getvar::current_lifestyle}}


## This Week's Main Event

### [Special Events - Specific Weeks Only]

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Spring}}::{{equal::{{getvar::week_of_season}}::1}}}}}}
Week 1: Freshman Orientation
Stat Effect: No special growth (adjustment period)
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Spring}}::{{equal::{{getvar::week_of_season}}::2}}}}}}
Week 2: Club Recruitment & Freshman Welcome Week
Stat Effect: CHA growth, stats related to chosen club
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Spring}}::{{equal::{{getvar::week_of_season}}::3}}}}}}
Week 3: Foundation Festival
Stat Effect: CHA growth, strengthened bonds with house members
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Spring}}::{{equal::{{getvar::week_of_season}}::4}}}}}}
Week 4: Midterm Exams
Stat Effect: INT growth, exam score/ranking output required
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Spring}}::{{equal::{{getvar::week_of_season}}::5}}}}}}
Week 5: Club Tournament Preliminaries
Stat Effect: Stats related to club activity type increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Spring}}::{{equal::{{getvar::week_of_season}}::7}}}}}}
Week 7: Cherry Blossom Picnic
Stat Effect: CHA growth, affinity increase with specific characters (if time spent together)
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Spring}}::{{equal::{{getvar::week_of_season}}::9}}}}}}
Week 9: Spring Ball
Stat Effect:
- With partner (affinity 50+): Character affinity greatly increased, CHA growth
- With partner (affinity ~49): Character affinity moderately increased, CHA growth
- Alone: CHA growth, INT growth, multiple character affinities slightly increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Spring}}::{{equal::{{getvar::week_of_season}}::11}}}}}}
Week 11: Club Presentations
Stat Effect: Stats related to club activity type greatly increased, strengthened bonds with club members
{{/if_pure}}

---

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Summer}}::{{equal::{{getvar::week_of_season}}::2}}}}}}
Week 2: Summer Club Camp
Stat Effect: Stats related to club type greatly increased, club member affinity increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Summer}}::{{equal::{{getvar::week_of_season}}::3}}}}}}
Week 3: Summer Solstice Tournament
Stat Effect:
- Champion: STR greatly increased, DEX increased, VIT increased, large gold reward, fame greatly increased
- Runner-up (2-4th): STR increased, DEX increased, gold reward
- Finals qualified: STR increased, gold reward
- Spectator: STR slightly increased, combat understanding increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Summer}}::{{equal::{{getvar::week_of_season}}::4}}}}}}
Week 4: Midterm Exams
Stat Effect: INT growth, exam score/ranking output required
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Summer}}::{{equal::{{getvar::week_of_season}}::6}}}}}}
Week 6: Beach Sports Festival
Stat Effect: VIT increased, DEX increased, CHA increased, opportunity to mingle with various characters
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Summer}}::{{equal::{{getvar::week_of_season}}::7}}}}}}
Week 7: Inter-Club Tournament
Stat Effect: Stats related to club type increased, inter-club exchanges increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Summer}}::{{equal::{{getvar::week_of_season}}::8}}}}}}
Week 8: Final Exams
Stat Effect: INT growth, exam score/ranking output required
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Summer}}::{{equal::{{getvar::week_of_season}}::9}}}}}}
Week 9: Stargazing Night
Stat Effect: INT increased, LUK increased, if together with specific character affinity greatly increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Summer}}::{{equal::{{getvar::week_of_season}}::11}}}}}}
Week 11: Research Symposium
Stat Effect: INT greatly increased, additional stats by research field, future opportunities increased
{{/if_pure}}

---

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Fall}}::{{equal::{{getvar::week_of_season}}::2}}}}}}
Week 2: Autumn Club Recruitment
Stat Effect: CHA increased, stats related to new club increased if joined
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Fall}}::{{equal::{{getvar::week_of_season}}::3}}}}}}
Week 3: Harvest Festival
Stat Effect: CHA increased, VIT increased, autumn leisureliness
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Fall}}::{{equal::{{getvar::week_of_season}}::4}}}}}}
Week 4: Midterm Exams
Stat Effect: INT growth, exam score/ranking output required
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Fall}}::{{equal::{{getvar::week_of_season}}::5}}}}}}
Week 5: Club Cultural Festival
Stat Effect: CHA increased, INT increased, art appreciation increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Fall}}::{{equal::{{getvar::week_of_season}}::6}}}}}}
Week 6: Imperial Foundation Day
Stat Effect: CHA increased (protocol experience), INT increased (history learning), subtle tension between nobles/commoners
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Fall}}::{{equal::{{getvar::week_of_season}}::8}}}}}}
Week 8: Final Exams
Stat Effect: INT growth, exam score/ranking output required
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Fall}}::{{equal::{{getvar::week_of_season}}::9}}}}}}
Week 9: Autumn Hunt
Stat Effect:
- Noble participants: STR increased, DEX increased, noble network strengthened
- Commoner observers: INT increased, class consciousness increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Fall}}::{{equal::{{getvar::week_of_season}}::11}}}}}}
Week 11: Art Exhibition
Stat Effect: INT increased, CHA increased, artistic sensitivity improved
{{/if_pure}}

---

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Winter}}::{{equal::{{getvar::week_of_season}}::2}}}}}}
Week 2: Snow Festival
Stat Effect: VIT increased, DEX increased, winter vigor
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Winter}}::{{equal::{{getvar::week_of_season}}::3}}}}}}
Week 3: Club Year-End Tournament
Stat Effect: Stats related to club type increased, club bonds strengthened
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Winter}}::{{equal::{{getvar::week_of_season}}::4}}}}}}
Week 4: Midterm Exams
Stat Effect: INT growth, exam score/ranking output required
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Winter}}::{{equal::{{getvar::week_of_season}}::6}}}}}}
Week 6: Year-End Charity Bazaar
Stat Effect: CHA increased, satisfaction from good deeds
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Winter}}::{{equal::{{getvar::week_of_season}}::8}}}}}}
Week 8: Winter Gala
Stat Effect:
- High noble partner: Character affinity greatly increased, CHA greatly increased, network greatly strengthened
- Regular partner: Character affinity increased, CHA increased
- Alone: CHA increased, INT increased (observation and networking learning)
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Winter}}::{{equal::{{getvar::week_of_season}}::10}}}}}}
Week 10: Club Awards Ceremony & Year-End Party
Stat Effect: Stats related to club type increased, club bonds maximized
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Winter}}::{{equal::{{getvar::week_of_season}}::11}}}}}}
Week 11: Graduation Ceremony
Stat Effect: INT increased, CHA increased, reflection and growth
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::Winter}}::{{equal::{{getvar::week_of_season}}::12}}}}}}
Week 12: Year-End Final Exams
Stat Effect: INT growth, exam score/ranking output required
{{/if_pure}}

---

### [Regular Weekly Activities - When No Special Events]

This week proceeds according to chosen {{getvar::current_curriculum}} curriculum and {{getvar::current_lifestyle}} lifestyle.

## Weekly Summary & Report

The weekly summary begins from the current day ({{getvar::day_of_week_name}}) and continues through Friday.
If currently on Friday evening ({{getvar::day_of_week}} == 5), the week's final class has ended.
{{user}} heads back to the dormitory, reflecting on the days that have passed.

### Summarizing Through Key Moments

Show the period from current day to Friday through key scenes:

**Special Event Handling (MANDATORY):**

IF current week has special event (festivals, balls, tournaments, ceremonies, etc.):
- MUST include event in weekly summary
- Describe participation, atmosphere, and memorable moments
- Event takes priority over regular curriculum/lifestyle activities
- If a special event is scheduled, stop the summary at the day the event starts and transition to the event
- Briefly describe the preparation process and atmosphere, then announce the event start and stop
- Example: "On Wednesday, the entire campus was buzzing with Spring Ball excitement. The ball is about to begin."

IF exam week (Week 4, 8, 12 of any season):
- MUST describe exam preparation and test-taking process
- MUST output exam score and class ranking using [Exam] tag
- Format: [Exam:midterm:87:23] or [Exam:finals:92:15]
- Score range: 0-100 (based on INT + d20 roll)
- Rank range: 1-999 (based on score compared to ~3000 students)
- Include emotional reaction to results in summary
- Exam experience replaces regular curriculum description for that week

IF no special event, proceed with regular weekly activities:

Curriculum - {{getvar::current_curriculum}}'s Classes:
Describe one specific memorable moment from classes between current day and Friday:
- A moment answering a difficult question from the professor (success? failure?)
- A technique attempted during practice (praised? frustrated?)
- A memorable scene from interaction with classmates
- Professor's reaction: nodding, encouragement, criticism, disappointed expression
- Sensory details: weight of weapons during training, complexity of magic formulas, nervousness during presentations

Lifestyle - {{getvar::current_lifestyle}} Activities:
One memorable moment from after-school activities:
- Who was met, what conversations were had
- Things that went well, awkward moments, new discoveries
- Sensory details: laughter at the cafe, sweat from training, quietness of the library
- Relationship changes: grew closer to someone, misunderstandings resolved

Friday Evening (upon reaching):
After the last class ends, walk through the hallway toward the dormitory.
Feel the past days in your body - tiredness, pride, regret, growth, or excitement for weekend events.
Those key scenes resurface, symbolizing the time that has passed.

### Weekly Report Summary

Performance evaluation:
{{#if_pure {{equal::{{getvar::current_curriculum}}::Vivienne}}}}
{{setvar::performance_score::{{math: {{getvar::player_int}} + {{roll:1d20}} }}}}
{{/if_pure}}
{{#if_pure {{equal::{{getvar::current_curriculum}}::Robert}}}}
{{setvar::performance_score::{{math: {{getvar::player_int}} + {{roll:1d20}} }}}}
{{/if_pure}}
{{#if_pure {{equal::{{getvar::current_curriculum}}::Scar}}}}
{{setvar::performance_score::{{math: {{getvar::player_str}} + {{roll:1d20}} }}}}
{{/if_pure}}
{{#if_pure {{equal::{{getvar::current_curriculum}}::Margot}}}}
{{setvar::performance_score::{{math: {{getvar::player_cha}} + {{roll:1d20}} }}}}
{{/if_pure}}
{{#if_pure {{equal::{{getvar::current_curriculum}}::Lydia}}}}
{{setvar::performance_score::{{math: {{getvar::player_int}} + {{roll:1d20}} }}}}
{{/if_pure}}
{{#if_pure {{equal::{{getvar::current_curriculum}}::Hemlock}}}}
{{setvar::performance_score::{{math: {{getvar::player_int}} + {{roll:1d20}} }}}}
{{/if_pure}}
{{#if_pure {{equal::{{getvar::current_curriculum}}::Margaret}}}}
{{setvar::performance_score::{{math: {{getvar::player_int}} + {{roll:1d20}} }}}}
{{/if_pure}}
{{getvar::performance_score}}
- Stat changes based on performance (use judgment: 90+=+3~5, 70-89=+2~3, 50-69=+1~2, 30-49=+1, 29-=0)

This week's score is {{getvar::performance_score}} points. (Out of 100)

Meaning of each score range:

{{#if_pure {{greater_equal::{{getvar::performance_score}}::90}}}}
S Grade (90+) 🏆: Everything went perfectly this week. The student exceeded their own limits, and everyone around saw their shining potential. Even luck was on their side.
{{/if_pure}}

{{#if_pure {{and::{{greater_equal::{{getvar::performance_score}}::70}}::{{less_equal::{{getvar::performance_score}}::89}}}}}}
A Grade (70-89) ⭐: The week went smoothly overall. The student demonstrated their abilities well, and their efforts yielded clear results. Professors and peers acknowledged their growth.
{{/if_pure}}

{{#if_pure {{and::{{greater_equal::{{getvar::performance_score}}::50}}::{{less_equal::{{getvar::performance_score}}::69}}}}}}
B Grade (50-69) ✨: The week passed without major issues. Nothing exceptional, but the student kept up diligently and felt gradual improvement. An ordinary but decent week.
{{/if_pure}}

{{#if_pure {{and::{{greater_equal::{{getvar::performance_score}}::30}}::{{less_equal::{{getvar::performance_score}}::49}}}}}}
C Grade (30-49) 💫: The week was difficult and overwhelming. The student struggled to keep up with classes, and luck wasn't on their side. Barely avoided failing, focused more on surviving than growing.
{{/if_pure}}

{{#if_pure {{less_equal::{{getvar::performance_score}}::29}}}}
D Grade (29-) 📝: The week was a complete disaster. The student understood nothing in class, and everything went wrong. The professor was disappointed, and the student felt defeated. Even luck turned its back - a disastrous week.
{{/if_pure}}

Please summarize the weekly activities according to this score result.

Note: The auxiliary AI will extract this information and generate a visual report interface automatically.

### After the Report: Character Encounter

While wrapping up the week and heading to the dormitory, encounter someone.

Among characters met during this week's {{getvar::current_curriculum}} classes or {{getvar::current_lifestyle}} activities,
naturally have a conversation with a character who has high affinity or developing relationship.

Friday evening conversation:
- "How was your week?"
- Share complaints, success stories, fun moments from weekly activities
- Lightly discuss weekend plans
- Tiredness and relief from the week evident in voice

### Weekend Date Possibility

Based on Affinity Level:

If a character has HIGH affinity with {{user}}:
- They may ask: "Are you free this weekend? Want to explore [location] together?" or "I was thinking of going to [place] tomorrow..."
- Or {{user}} might notice a good moment to invite them
- The invitation feels natural within conversation flow, not forced
- Character evaluates the week together, shows interest in spending more time

If affinity is LOW or NEUTRAL:
- Just friendly farewells: "See you Monday!" "Have a good weekend!"
- No special plans, everyone disperses naturally

If Weekend Date Accepted:
Saturday and Sunday will be spent with that character. The relationship deepens through shared experiences.

If No Date:
Weekend is free time - {{user}} can rest, explore alone, or pursue other activities.

The week is over. Tomorrow is Saturday.


### Weekly Activity Guide (Monday-Thursday)

This week proceeds with chosen curriculum and lifestyle activities.

Writing Guide:
- Write concisely in 1-2 paragraphs (avoid lengthy listing)
- Focus on "what changed" rather than "what was done"
- Impressive moment from curriculum + experience from lifestyle
- Meaningful interactions with professors or peers
- Include emotional and relationship changes

Refer to "Activity Guide" below to freely narrate story.


## Curriculum Guide

### [Only Currently Selected Curriculum Activated]

{{#if_pure {{equal::{{getvar::current_curriculum}}::Vivienne}}}}
Political Science (INT): Political sense, diplomacy, etiquette
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Robert}}}}
Commerce & Finance (INT): Financial management, stable judgment
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Scar}}}}
Combat Studies (STR): Combat power, survival ability, practical sense
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Margot}}}}
Art Studies (CHA): Artistic sense, critical thinking, mental strength
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Lydia}}}}
Magic Studies (INT): Magic theory, precise mana control
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Hemlock}}}}
Alchemy (INT): Alchemy, poison knowledge, meticulous preparation
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Margaret}}}}
Administrative Studies (INT): Practical skills, career development, networking
{{/if_pure}}


## Lifestyle Guide

### [Only Currently Selected Lifestyle Activated]

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Social}}}}
Social: CHA growth, mingling with various characters
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Training}}}}
Training: Curriculum-related stat growth intensified
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Club}}}}
Club: Club-related stat growth, bonds with club members
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Adventure}}}}
Adventure: High risk/high reward, gold and experience
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Rest}}}}
Rest: Physical/mental recovery, preparation
{{/if_pure}}


## Weekly Growth Judgment

### Judgment Method
Judgment performed over weekend according to curriculum and lifestyle.

Curriculum Judgment:
- INT based (Vivienne, Robert, Lydia, Hemlock, Margaret): {{math: {{getvar::player_int}} + {{roll:1d20}} }}
- STR based (Scar): {{math: {{getvar::player_str}} + {{roll:1d20}} }}
- CHA based (Margot): {{math: {{getvar::player_cha}} + {{roll:1d20}} }}

Lifestyle Bonus:
- Social: Additional bonus on successful mingling
- Training: Strengthened curriculum growth
- Club: Additional growth related to club characteristics
- Adventure: High returns when taking risks
- Rest: Recovery, preparation for next week

### Judgment Results (100점 만점)
- 90+: Outstanding achievement (maximum growth)
- 70-89: Excellent achievement (high growth)
- 50-69: Good achievement (medium growth)
- 30-49: Minimal achievement (minimum growth)
- 29 or below: Failure (no growth, word of comfort)

### Include When Writing Weekly Report
Naturally describe stat changes based on judgment results.


## Seasonal Atmosphere

{{#if_pure {{equal::{{getvar::current_season}}::Spring}}}}
Spring Semester Atmosphere
Campus with cherry blossoms in full bloom. New semester energy and excitement. New beginnings.
Upcoming Events: Week 3 Foundation Festival, Week 9 Spring Ball
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_season}}::Summer}}}}
Summer Semester Atmosphere
Hot sun and vibrant energy. Midterm pressure. Season of passion.
Upcoming Events: Week 3 Summer Solstice Tournament, Week 6 Beach Festival
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_season}}::Fall}}}}
Autumn Semester Atmosphere
Autumn leaves and chilly wind. Mature atmosphere. Mid-year leisure and reflection.
Upcoming Events: Week 3 Harvest Festival, Week 6 Imperial Foundation Day
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_season}}::Winter}}}}
Winter Semester Atmosphere
Snow-covered campus. Year-end pressure and anticipation. Final sprint.
Upcoming Events: Week 2 Snow Festival, Week 8 Winter Gala, Week 11 Graduation Ceremony
{{/if_pure}}


## Daily Activity Reference (During Free Conversation)

Weekday Morning: Classes, library, training, skipping class
Weekday Afternoon: Cafes, shopping, quests, clubs, rest
Weekend: Dates, dungeon exploration, free exploration, complete rest
Exam Weeks (Week 4, 8, 12): Exam preparation and taking

