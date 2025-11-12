@@depth 0

# Belladonna Academy Schedule System


## Current Situation

Time: {{getvar::current_season}} Semester, Week {{getvar::week_of_season}}
Day: Day {{getvar::day_of_week}}
This Week's Choice: {{getvar::current_curriculum}} | {{getvar::current_lifestyle}}


## This Week's Main Event

### [Special Events - Specific Weeks Only]

{{#if_pure {{and::{{equal::{{getvar::current_season}}::봄}}::{{equal::{{getvar::week_of_season}}::1}}}}}}
Week 1: Freshman Orientation
Entrance ceremony with house assignment announcement, house welcome party, campus tour, orientation party, textbook shopping at Ruby Row.
Stat Effect: No special growth (adjustment period)
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::봄}}::{{equal::{{getvar::week_of_season}}::2}}}}}}
Week 2: Club Recruitment & Freshman Welcome Week
Club fair at central plaza, hands-on trials, club registration and enrollment, first club meeting with seniors.
Stat Effect: CHA growth, stats related to chosen club
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::봄}}::{{equal::{{getvar::week_of_season}}::3}}}}}}
Week 3: Foundation Festival
House booths, talent show competition, night party, ranking announcement and closing ceremony with fireworks.
Stat Effect: CHA growth, strengthened bonds with house members
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::봄}}::{{equal::{{getvar::week_of_season}}::5}}}}}}
Week 5: Club Tournament Preliminaries
Clubs compete by field (combat tournaments, research presentations, creative competitions, athletic meets), preliminary results announced Friday, finals teams begin intensive training.
Stat Effect: Stats related to club activity type increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::봄}}::{{equal::{{getvar::week_of_season}}::7}}}}}}
Week 7: Cherry Blossom Picnic
Post-midterm rest week, Saturday picnic at Cherry Blossom Garden with lunch boxes and house gatherings, afternoon walks and performances, romantic evening confessions, night campfire.
Stat Effect: CHA growth, affinity increase with specific characters (if time spent together)
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::봄}}::{{equal::{{getvar::week_of_season}}::9}}}}}}
Week 9: Spring Ball
Partner finding and confessions, outfit preparation and dance practice, Saturday Grand Ballroom ball with opening/closing waltzes, Sunday SNS explosion and new relationships.
Stat Effect:
- With partner (affinity 50+): Character affinity greatly increased, CHA growth
- With partner (affinity ~49): Character affinity moderately increased, CHA growth
- Alone: CHA growth, INT growth, multiple character affinities slightly increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::봄}}::{{equal::{{getvar::week_of_season}}::11}}}}}}
Week 11: Club Presentations
Club finals (combat tournaments, research presentations, performance nights, friendly matches), Friday club awards ceremony, weekend after-parties.
Stat Effect: Stats related to club activity type greatly increased, strengthened bonds with club members
{{/if_pure}}

---

{{#if_pure {{and::{{equal::{{getvar::current_season}}::여름}}::{{equal::{{getvar::week_of_season}}::2}}}}}}
Week 2: Summer Club Camp
Clubs depart for camps (combat: mountain training, academic: intensive seminars, arts: suburban resorts, sports: beach expeditions), 3-day intensive activities, Friday return.
Stat Effect: Stats related to club type greatly increased, club member affinity increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::여름}}::{{equal::{{getvar::week_of_season}}::3}}}}}}
Week 3: Summer Solstice Tournament
Aconitum-hosted combat festival, Monday preliminaries, Wednesday finals tournament opening, Thursday semifinals, Friday finals at sunset, Saturday closing party.
Stat Effect:
- Champion: STR greatly increased, DEX increased, VIT increased, large gold reward, fame greatly increased
- Runner-up (2-4th): STR increased, DEX increased, gold reward
- Finals qualified: STR increased, gold reward
- Spectator: STR slightly increased, combat understanding increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::여름}}::{{equal::{{getvar::week_of_season}}::6}}}}}}
Week 6: Beach Sports Festival
Post-midterm Azure Coast Beach trip, Saturday morning free time and beach BBQ, afternoon beach sports competition, evening sunset and beach party with fireworks, Sunday return.
Stat Effect: VIT increased, DEX increased, CHA increased, opportunity to mingle with various characters
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::여름}}::{{equal::{{getvar::week_of_season}}::7}}}}}}
Week 7: Inter-Club Tournament
Inter-club competition by field (combat tournaments, knowledge competitions, creative competitions, sports meets), Thursday semifinals/finals, Friday awards ceremony, weekend after-parties.
Stat Effect: Stats related to club type increased, inter-club exchanges increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::여름}}::{{equal::{{getvar::week_of_season}}::9}}}}}}
Week 9: Stargazing Night
Poppy House astronomy club hosts Saturday hilltop observatory festival, telescope observation, constellation explanations, magic light show, midnight star myths, romantic confessions, 2 AM conclusion.
Stat Effect: INT increased, LUK increased, if together with specific character affinity greatly increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::여름}}::{{equal::{{getvar::week_of_season}}::11}}}}}}
Week 11: Research Symposium
Poppy/Rafflesia-hosted academic event, Monday-Tuesday research presentations, Wednesday external visitors and scouting, Thursday poster session, Friday awards ceremony.
Stat Effect: INT greatly increased, additional stats by research field, future opportunities increased
{{/if_pure}}

---

{{#if_pure {{and::{{equal::{{getvar::current_season}}::가을}}::{{equal::{{getvar::week_of_season}}::2}}}}}}
Week 2: Autumn Club Recruitment
Second recruitment opportunity with achievement exhibitions, central plaza club fair, Thursday registration, Friday welcome meetings, weekend first activities.
Stat Effect: CHA increased, stats related to new club increased if joined
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::가을}}::{{equal::{{getvar::week_of_season}}::3}}}}}}
Week 3: Harvest Festival
Saturday central garden festival, house decorations and food booths, cooking competition, afternoon garden walks and confessions, evening bonfire party, night lantern release.
Stat Effect: CHA increased, VIT increased, autumn leisureliness
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::가을}}::{{equal::{{getvar::week_of_season}}::5}}}}}}
Week 5: Club Cultural Festival
Campus-wide arts festival, Monday-Wednesday club performances and exhibitions (music, art, theater, literature, traditional culture), Thursday special events, Friday closing comprehensive performance.
Stat Effect: CHA increased, INT increased, art appreciation increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::가을}}::{{equal::{{getvar::week_of_season}}::6}}}}}}
Week 6: Imperial Foundation Day
Rose House-led official ceremony, Monday central plaza assembly and flag raising, Tuesday history lectures, Wednesday house patriotic performances, Thursday imperial visit possibility, Friday closing ceremony.
Stat Effect: CHA increased (protocol experience), INT increased (history learning), subtle tension between nobles/commoners
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::가을}}::{{equal::{{getvar::week_of_season}}::9}}}}}}
Week 9: Autumn Hunt
Nobles-only Aconitum/Rose House event, Saturday dawn forest hunt (deer, boars, foxes), lunch outdoor feast and networking, afternoon beast hunting, evening return and exclusive after-party. Commoners excluded.
Stat Effect:
- Noble participants: STR increased, DEX increased, noble network strengthened
- Commoner observers: INT increased, class consciousness increased
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::가을}}::{{equal::{{getvar::week_of_season}}::11}}}}}}
Week 11: Art Exhibition
Ivy House comprehensive arts festival, Monday campus-wide installation art, Tuesday painting exhibition, Wednesday photo/film screening, Thursday performance art, Friday comprehensive performance.
Stat Effect: INT increased, CHA increased, artistic sensitivity improved
{{/if_pure}}

---

{{#if_pure {{and::{{equal::{{getvar::current_season}}::겨울}}::{{equal::{{getvar::week_of_season}}::2}}}}}}
Week 2: Snow Festival
Saturday snow-covered campus, house snow sculpture competition, afternoon snowball fight competition and winter sports, evening indoor party with warm cocoa, night fireworks.
Stat Effect: VIT increased, DEX increased, winter vigor
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::겨울}}::{{equal::{{getvar::week_of_season}}::3}}}}}}
Week 3: Club Year-End Tournament
Friendly year-end matches by club (combat, quiz, concerts, sports day), Thursday club year-end parties, Friday all-club exchange meeting.
Stat Effect: Stats related to club type increased, club bonds strengthened
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::겨울}}::{{equal::{{getvar::week_of_season}}::6}}}}}}
Week 6: Year-End Charity Bazaar
Saturday central plaza charity bazaar, house charity events (tea party, auction, demonstrations), club activities (snacks, portraits, busking), afternoon fundraising announcement, donations to orphanage and poor district.
Stat Effect: CHA increased, satisfaction from good deeds
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::겨울}}::{{equal::{{getvar::week_of_season}}::8}}}}}}
Week 8: Winter Gala
Year's most important social event, Monday-Thursday strategic partner selection and luxury preparation, Friday Grand Ballroom gala with opening ceremony and noble first waltz, banquet with networking, midnight gift exchange, closing waltz, Saturday-Sunday SNS chaos and rumors.
Stat Effect:
- High noble partner: Character affinity greatly increased, CHA greatly increased, network greatly strengthened
- Regular partner: Character affinity increased, CHA increased
- Alone: CHA increased, INT increased (observation and networking learning)
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::겨울}}::{{equal::{{getvar::week_of_season}}::10}}}}}}
Week 10: Club Awards Ceremony & Year-End Party
Thursday auditorium awards ceremony (Club of the Year, Outstanding Activity, Newcomer, Special Contribution), club room year-end parties with senior farewells, Friday all-club joint party.
Stat Effect: Stats related to club type increased, club bonds maximized
{{/if_pure}}

{{#if_pure {{and::{{equal::{{getvar::current_season}}::겨울}}::{{equal::{{getvar::week_of_season}}::11}}}}}}
Week 11: Graduation Ceremony
Friday morning auditorium graduation ceremony with diploma presentation and cap throwing, afternoon farewell time, evening farewell parties, Saturday graduates' departure, quiet campus.
Stat Effect: INT increased, CHA increased, reflection and growth
{{/if_pure}}

---

### [Regular Weekly Activities - When No Special Events]

This week proceeds according to chosen {{getvar::current_curriculum}} curriculum and {{getvar::current_lifestyle}} lifestyle.

## Weekly Summary & Report

The weekly summary begins from the current day ({{getvar::day_of_week_name}}) and continues through Friday.
If currently on Friday evening ({{getvar::day_of_week}} == 5), the week's final class has ended.
{{user}} heads back to the dormitory, reflecting on the days that have passed.

### Summarizing Through Key Moments

현재 요일부터 금요일까지의 기간을 주요 장면들을 통해 보여준다:

특별 이벤트 (진행 중인 경우):
이 기간에 특별 이벤트가 예정되어 있다면, 해당 이벤트가 시작되는 요일에서 요약을 중단하고 이벤트로 전환한다.
요약 중 특별 이벤트 주차(위 섹션 참조)의 해당 요일에 도달하면, 준비 과정이나 분위기를 간략히 묘사한 후 이벤트 시작을 알리고 중단한다.
예: "수요일, 캠퍼스 전체가 Spring Ball 분위기로 들떴다. 이제 무도회가 시작된다."

특별 이벤트가 없는 경우, 일반 주간 활동 계속:

Curriculum - {{getvar::current_curriculum}}'s Classes:
현재 요일부터 금요일까지의 수업 중 가장 인상적이었던 순간 하나를 구체적으로:
- 교수가 던진 어려운 질문에 대답했던 순간 (성공? 실패?)
- 실습 중 시도했던 기술 (칭찬? 좌절?)
- 동료들과의 상호작용에서 기억에 남는 한 장면
- 교수의 반응: 고개 끄덕임, 격려, 비판, 실망한 표정
- 감각적 디테일: 훈련 중 무기의 무게, 마법 공식의 복잡함, 발표 때의 긴장감

Lifestyle - {{getvar::current_lifestyle}} Activities:
방과 후 활동 중 기억에 남는 한 순간:
- 누구를 만났고, 어떤 대화를 나눴는지
- 잘 풀렸던 일, 어색했던 순간, 새로운 발견
- 감각적 디테일: 카페에서의 웃음, 훈련의 땀, 도서관의 고요함
- 관계의 변화: 누군가와 가까워졌거나, 오해가 풀렸거나

금요일 저녁 (도달 시):
마지막 수업이 끝나고, 복도를 걸어 기숙사로 향한다.
지나온 날들이 몸으로 느껴진다 - 피곤함, 뿌듯함, 아쉬움, 성장감, 혹은 이번 주말 이벤트에 대한 설렘.
그 주요 장면들이 지나온 시간을 상징하며 떠오른다.

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
- Stat changes based on performance (use judgment: 25+=+3~5, 20-24=+2~3, 15-19=+1~2, 10-14=+1, 9-=0)

이번 주의 점수는 {{getvar::performance_score}}점입니다.

각 점수 구간별 의미:

{{#if_pure {{greater_equal::{{getvar::performance_score}}::25}}}}
S Grade (25+) 🏆: 이번 주 모든 일이 잘 풀렸음. 능력은 자신의 한계 이상으로 뽐냈으며 주변은 사용자에게서 빛나는 가능성을 발견함. 운조차 사용자를 도와주는 한 주였음.
→ Everything went perfectly this week. The student exceeded their own limits, and everyone around saw their shining potential. Even luck was on their side.
{{/if_pure}}

{{#if_pure {{and::{{greater_equal::{{getvar::performance_score}}::20}}::{{less_equal::{{getvar::performance_score}}::24}}}}}}
A Grade (20-24) ⭐: 이번 주 대체로 순조로웠음. 자신의 능력을 충분히 발휘했고, 노력이 확실한 성과로 이어졌음. 교수와 주변 학생들이 성장을 인정해줌.
→ The week went smoothly overall. The student demonstrated their abilities well, and their efforts yielded clear results. Professors and peers acknowledged their growth.
{{/if_pure}}

{{#if_pure {{and::{{greater_equal::{{getvar::performance_score}}::15}}::{{less_equal::{{getvar::performance_score}}::19}}}}}}
B Grade (15-19) ✨: 이번 주가 무난하게 흘러갔음. 특별히 뛰어나진 않았지만 성실하게 따라갔고, 조금씩 발전하는 느낌이 있었음. 평범하지만 나쁘지 않은 한 주.
→ The week passed without major issues. Nothing exceptional, but the student kept up diligently and felt gradual improvement. An ordinary but decent week.
{{/if_pure}}

{{#if_pure {{and::{{greater_equal::{{getvar::performance_score}}::10}}::{{less_equal::{{getvar::performance_score}}::14}}}}}}
C Grade (10-14) 💫: 이번 주가 힘들고 버거웠음. 수업 내용을 따라가기 어려웠고, 운도 따라주지 않았음. 간신히 낙제를 면했지만 성장보단 버티기에 급급했던 한 주.
→ The week was difficult and overwhelming. The student struggled to keep up with classes, and luck wasn't on their side. Barely avoided failing, focused more on surviving than growing.
{{/if_pure}}

{{#if_pure {{less_equal::{{getvar::performance_score}}::9}}}}
D Grade (9-) 📝: 이번 주가 완전히 망했음. 수업을 전혀 이해하지 못했고, 모든 일이 꼬였음. 교수는 실망했고, 자신도 좌절감을 느낌. 운도 최악이었던 참담한 한 주.
→ The week was a complete disaster. The student understood nothing in class, and everything went wrong. The professor was disappointed, and the student felt defeated. Even luck turned its back - a disastrous week.
{{/if_pure}}

이 점수 결과에 맞춰 주간 활동 내용을 요약해주세요.

Note: The auxiliary AI will extract this information and generate a visual report interface automatically.

### After the Report: Character Encounter

이번 주를 정리하고 기숙사로 향하다, 누군가와 마주친다.

이번 주 {{getvar::current_curriculum}} 수업이나 {{getvar::current_lifestyle}} 활동에서 만났던 캐릭터 중,
호감도가 높거나 관계가 발전하고 있는 캐릭터와 자연스럽게 대화를 나눈다.

금요일 저녁 대화:
- "이번 주 어땠어?"
- 주간 활동 중 불평, 성공담, 재밌었던 순간 공유
- 주말 계획 가볍게 이야기
- 목소리에 묻어나는 한 주의 피로와 안도감

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
Prof. Vivienne (Rose House) - Political Science & Diplomacy
- Background: Former Imperial Diplomatic Advisor, personal tutor to two princesses
- Personality: Strict and perfectionist, unwavering composure
- Teaching Style: High expectations, no tolerance for mistakes, emphasizes political results
- Main Subjects: Political Theory, Rhetoric, Protocol Practice, International Relations
- Key Students: Eglantine (honor student), Aurelia, Celestia, noble students
- Main Locations: Rose House lecture hall, protocol room
- Growth Direction: Political sense, diplomacy, perfect etiquette
- Description Points: Tension, pressure toward perfection, elegant authority
- Judgment Stat: INT
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Robert}}}}
Prof. Robert (Lily Valley) - Commerce & Finance
- Background: Former Imperial Finance Minister, stable economic management
- Personality: Gentle and approachable, middle-aged ease
- Teaching Style: Steady and systematic, practice-oriented
- Main Subjects: Financial Management, Accounting, Commercial Practice
- Key Students: Lily Valley merchant family students
- Main Locations: Commerce lecture hall, Scarlet Street market field trips
- Growth Direction: Financial management, stable judgment
- Description Points: Practical, calm, numbers and stability
- Judgment Stat: INT
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Scar}}}}
Prof. Scar (Aconitum) - Combat Studies
- Background: Former mercenary "Mad Dog", commoner-born Sword Saint
- Personality: Rough and blunt, meritocratic, 28-year-old young professor
- Teaching Style: Almost only practical training, theory brief and concise
- Main Subjects: Combat Practice, Sparring, Field Training
- Key Students: Oleander (rival), Cassandra, Aconitum warriors
- Main Locations: Outdoor training ground, practical field
- Growth Direction: Combat power, survival ability, practical sense
- Description Points: Sweat, blood, brutal training, rough encouragement, results are everything
- Judgment Stat: STR
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Margot}}}}
Prof. Margot (Ivy) - Art Studies
- Background: Former imperial art critic, famous for scathing reviews
- Personality: Cynical and observational, creatively cruel criticism
- Teaching Style: Rarely teaches, observes and gives destructive criticism
- Main Subjects: Art Theory, Criticism, Creation (but doesn't directly teach)
- Key Students: Ivy artists (fear and respect)
- Main Locations: Ivy Hall gallery, atelier
- Growth Direction: Artistic sense, critical thinking, mental strength
- Description Points: Sharp criticism, agony of creation, rare recognition
- Judgment Stat: CHA
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Lydia}}}}
Prof. Lydia (Poppy) - Magic Studies
- Background: Tower of Mages archmage (lower rank), mid-20s
- Personality: Tired and lethargic, hates teaching, wants to do research
- Teaching Style: Deep and thorough theory lectures, killer assignments and exams
- Main Subjects: Magic Theory, Spellcraft, Mana Control
- Key Students: Poppy mages (exam terror)
- Main Locations: Magic practice room, research lab (rarely comes out)
- Growth Direction: Magic theory, precise mana control
- Description Points: Fatigue, deep theory, difficult assignments, dark circles under eyes
- Judgment Stat: INT
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Hemlock}}}}
Prof. Hemlock (Rafflesia) - Alchemy
- Background: Former court alchemist, toxicology specialist
- Personality: Languid and unstable-looking, monotone voice
- Appearance: Bloodshot eyes, pallid complexion, occasional tremors (poison immunity side effects)
- Teaching Style: Precise and systematic but unsettling appearance
- Main Subjects: Toxicology, Antidote Development, Material Transformation
- Key Students: Rafflesia alchemists
- Main Locations: Alchemy lab, Mana Square
- Growth Direction: Alchemy, poison knowledge, meticulous preparation
- Description Points: Potion smells, dangerous experiments, unsettling atmosphere, precision
- Judgment Stat: INT
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_curriculum}}::Margaret}}}}
Prof. Margaret (Belladonna) - Administrative Studies & Practice
- Background: Former Imperial Treasury Director, youngest commoner director
- Personality: Pragmatic, no noble connections, competes with ability
- Teaching Style: Corporate-level rigor, employment-focused practice
- Main Subjects: Administrative Studies, Accounting, Career Management
- Key Students: Belladonna commoner students (nobles rarely attend)
- Main Locations: General lecture hall, counseling room (packed with commoner students)
- Growth Direction: Practical skills, career development, networking (not bloodline)
- Description Points: Practicality, meritocracy, career counseling, commoners' hope
- Judgment Stat: INT
{{/if_pure}}


## Lifestyle Guide

### [Only Currently Selected Lifestyle Activated]

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Social}}}}
Social - Socializing and Networking
- Main Locations: Scarlet Street cafes, Lotus Street parties/performances
- Characters to Meet: Natural mingling with various students (2-3 people)
- Main Activities: Cafe conversations, shopping, concert viewing, social gatherings
- Cost: Money spent (cafes, gifts, etc.)
- Growth Direction: Charm and social skills improved
- Description Points: Laughter, chatter, new rumors, deepening relationships
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Training}}}}
Training - Personal Development
- Main Locations: Training ground, library, practice room
- Characters to Meet: Student with same goal (about 1 person)
- Main Activities: Combat training, reading, magic practice, self-improvement
- Cost: Physical/mental stamina consumed
- Growth Direction: Intensively improved abilities related to chosen curriculum
- Description Points: Sweat, concentration, breaking limits, quiet achievement
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Club}}}}
Club - Club Activities
- Main Locations: Club room, related places (performance hall, training ground, etc.)
- Characters to Meet: Deep bonds with club members
- Main Activities: Club projects, practice, collaborative work
- Cost: Time investment
- Growth Direction: Abilities matching club characteristics + cooperation
- Description Points: Passion, teamwork, common goals, sense of belonging
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Adventure}}}}
Adventure - Off-Campus Activities
- Main Locations: Midnight Alley quest board, off-campus danger zones
- Characters to Meet: Adventurous students
- Main Activities: Quest completion, dungeon exploration, dangerous work
- Cost: Injury risk
- Rewards: Money and experience, loot
- Description Points: Tension, thrill, danger, pleasure of reward
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_lifestyle}}::Rest}}}}
Rest - Relaxation and Recovery
- Main Locations: Dormitory, campus garden, quiet places
- Characters to Meet: Roommate or chance encounters (optional)
- Main Activities: Sleep, hobbies, walks, leisure
- Effect: Physical recovery, stress relief
- Description Points: Serenity, recharging, self-reflection, preparation for next
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

### Judgment Results
- 25+: Outstanding achievement (maximum growth)
- 20-24: Excellent achievement (high growth)
- 15-19: Good achievement (medium growth)
- 10-14: Minimal achievement (minimum growth)
- 9 or below: Failure (no growth, word of comfort)

### Include When Writing Weekly Report
Naturally describe stat changes based on judgment results.


## Seasonal Atmosphere

{{#if_pure {{equal::{{getvar::current_season}}::봄}}}}
Spring Semester Atmosphere
Campus with cherry blossoms in full bloom. New semester energy and excitement. New beginnings.
Upcoming Events: Week 3 Foundation Festival, Week 9 Spring Ball
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_season}}::여름}}}}
Summer Semester Atmosphere
Hot sun and vibrant energy. Midterm pressure. Season of passion.
Upcoming Events: Week 3 Summer Solstice Tournament, Week 6 Beach Festival
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_season}}::가을}}}}
Autumn Semester Atmosphere
Autumn leaves and chilly wind. Mature atmosphere. Mid-year leisure and reflection.
Upcoming Events: Week 3 Harvest Festival, Week 6 Imperial Foundation Day
{{/if_pure}}

{{#if_pure {{equal::{{getvar::current_season}}::겨울}}}}
Winter Semester Atmosphere
Snow-covered campus. Year-end pressure and anticipation. Final sprint.
Upcoming Events: Week 2 Snow Festival, Week 8 Winter Gala, Week 11 Graduation Ceremony
{{/if_pure}}


## Daily Activity Reference (During Free Conversation)

Weekday Morning: Classes, library, training, skipping class
Weekday Afternoon: Cafes, shopping, quests, clubs, rest
Weekend: Dates, dungeon exploration, free exploration, complete rest
Exam Weeks (Week 4, 8, 12): Exam preparation and taking

