@@depth 0

# 📊 Stat Influence

## Current Stats

- 💪 STR (Strength): {{getvar::str_effective}} / 100
- 🧠 INT (Intelligence): {{getvar::int_effective}} / 100
- 🤸 DEX (Dexterity): {{getvar::dex_effective}} / 100
- 💬 CHA (Charisma): {{getvar::cha_effective}} / 100
- 🍀 LUK (Luck): {{getvar::luk_effective}} / 100
- ❤️ VIT (Vitality): {{getvar::vit_effective}} / 100

Each stat ranges from 0-100, and {{user}}'s capabilities and others' reactions change based on the values.

---

## 💪 STR (Strength)

{{#if {{? {{getvar::str_effective}} >= 91}}}}
### Mythical Strength (STR 91-100)
Impression: People look at you as if witnessing a legendary hero. When you lift something, it feels like a scene from mythology, and no one dares to oppose your strength.

Level: A mythical realm. Superhuman strength that completely transcends human limits.

Scope: You can solve almost any situation with strength. Break down castle gates alone, lift giant boulders, overwhelm beasts. Physical obstacles essentially don't exist, and you dominate in combat.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 81}}::{{? {{getvar::str_effective}} <= 90}}}}}}
### Monstrous Strength (STR 81-90)
Impression: People feel like they're witnessing a hero from famous tales. Your strength clearly exceeds human standards, and no one dares challenge you physically.

Level: Strength beyond human limits. You can wrestle bears or tigers barehanded.

Scope: Easily break down heavy doors, lift people with one hand, fight wild beasts. Almost every strength-based option opens, and you dominate combat.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 71}}::{{? {{getvar::str_effective}} <= 80}}}}}}
### Superhuman Strength (STR 71-80)
Impression: People feel they could never defeat you in strength. Unless they're exceptionally skilled, they avoid physical confrontation and respect your power with caution.

Level: Beginning to exceed ordinary people. Athletic-level physical capability, easily performing feats of strength people talk about.

Scope: Move heavy furniture alone, break doors with force, easily subdue people. Strength becomes the solution in most situations requiring it, gaining advantage against physical threats.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 61}}::{{? {{getvar::str_effective}} <= 70}}}}}}
### Strong Person (STR 61-70)
Impression: People clearly recognize you as strong. Often hear "You're really strong" and get asked to do heavy lifting.

Level: Clearly strong among ordinary people. Like someone who regularly goes to the gym or does physical labor.

Scope: Can do many things with strength. Lift heavy loads, carry or drag people, clear simple obstacles with force. While mostly limited to carrying heavy things, strength greatly helps in daily life.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 51}}::{{? {{getvar::str_effective}} <= 60}}}}}}
### Average Strength (STR 51-60)
Impression: Don't give an impression of being particularly strong or weak. Look like an ordinary person.

Level: Ordinary person level. Strength sufficient for daily life.

Scope: Lift ordinary objects, do ordinary physical activities. No special advantages or disadvantages.
{{/if}}

{{#if {{? {{getvar::str_effective}} <= 50}}}}
### Frail Build (STR 0-50)
Impression: People think you're delicate and fragile. Worry about you carrying heavy things, saying "Let me do it" first. Sometimes receive pitying looks.

Level: Lacking strength. Physically weak and struggle with tasks requiring force.

Scope: Can hardly solve anything with strength. Difficult to lift heavy objects, lose in physical confrontations, must find other methods for strength-based situations. However, this weakness draws help and care from others, opening paths to solve problems through other abilities instead of strength.
{{/if}}

---

## 🧠 INT (Intelligence)

{{#if {{? {{getvar::int_effective}} >= 91}}}}
### Mythical Intellect (INT 91-100)
Impression: People revere you, considering it an honor just to speak with you. Your single word overturns academic orthodoxy, and ancient problems solve themselves before you.

Level: A once-in-centuries genius. Compared to ancient sages or mythical gods of wisdom. Possess insight that penetrates the world's principles, not mere knowledge.

Scope: Can solve almost any problem through intellect. Reconstruct forbidden magical theories on the spot, decipher ancient texts at a glance, see through opponents' thoughts in a few words. Can secure not just academic authority but political influence.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 81}}::{{? {{getvar::int_effective}} <= 90}}}}}}
### Genius Level (INT 81-90)
Impression: Those around you recognize you as a genius. Your ideas are innovative, insights deep, and people listen carefully to your advice.

Level: Top tier even among scholars, mages, and strategists. On par with historical figures who left their mark.

Scope: Understand complex theories instantly, create new magic, foresee opponent's traps. Can decipher obscure ancient texts, formulate elaborate strategies, research forbidden knowledge.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 71}}::{{? {{getvar::int_effective}} <= 80}}}}}}
### Exceptional Intelligence (INT 71-80)
Impression: People clearly recognize you as "smart." Your opinions are respected, and many seek your counsel.

Level: Intellect beyond ordinary people. Expert level as a scholar, mage, or strategist. Comparable to top university graduates or renowned researchers.

Scope: Quickly understand difficult magical theories, logically solve complex problems, see through lies. Can conduct academic research, formulate strategies, decode complex ciphers.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 61}}::{{? {{getvar::int_effective}} <= 70}}}}}}
### Intelligent Person (INT 61-70)
Impression: People think you're smart. Understand explanations quickly, ask appropriate questions, help solve problems.

Level: Clearly intellectual among ordinary people. Like a university graduate or professional.

Scope: Understand basic magical theory, excel academically, solve simple riddles or puzzles. Logical conversation, basic research, everyday problem-solving come easily.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 51}}::{{? {{getvar::int_effective}} <= 60}}}}}}
### Average Intelligence (INT 51-60)
Impression: Don't give an impression of being particularly smart or dull. Converse normally, understand normally.

Level: Ordinary person level. Intelligence sufficient for daily life.

Scope: Understand basic education, handle simple tasks, engage in ordinary conversation. Not particularly outstanding but live without problems.
{{/if}}

{{#if {{? {{getvar::int_effective}} <= 50}}}}
### Simple Thinking (INT 0-50)
Impression: People think you understand slowly. Need explanations multiple times, can't follow complex stories.

Level: Struggle with learning. Difficult with abstract thinking or logical reasoning.

Scope: Can follow simple instructions, but hard to understand complex plans or theories. Rely on intuition or experience rather than academic approaches, must solve problems through other abilities.
{{/if}}

---

## 🤸 DEX (Dexterity)

{{#if {{? {{getvar::dex_effective}} >= 91}}}}
### Supernatural Agility (DEX 91-100)
Impression: People can't properly see your movements. Leave only afterimages as you vanish, witnesses doubt "Is that really human?"

Level: Speed and agility rivaling mythical heroes or legendary thieves. Completely transcends human limits.

Scope: Can solve almost any situation with agility. Change direction mid-air, step on walls while falling, catch arrows by hand. Dominate in assassination, escape, acrobatics, and combat.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 81}}::{{? {{getvar::dex_effective}} <= 90}}}}}}
### Lightning Speed (DEX 81-90)
Impression: People can't follow your movements. When you move, opponents are already too late, spectators can't help but admire.

Level: Speed beyond human limits. Level of historical master swordsmen or legendary thieves.

Scope: Do consecutive somersaults, climb walls, dodge flying weapons. Possible in assassination, infiltration, escape, acrobatics - ordinary people can't catch you.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 71}}::{{? {{getvar::dex_effective}} <= 80}}}}}}
### Acrobat Level (DEX 71-80)
Impression: People admire your movements. Marvel "How can you move like that?" and give up competing in speed.

Level: Agility beyond ordinary people. Professional acrobat, first-rate martial artist, skilled thief level.

Scope: Run on narrow railings, jump from heights and land safely, flexibly dodge attacks in close combat. Gain great advantages in infiltration, escape, combat maneuvers.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 61}}::{{? {{getvar::dex_effective}} <= 70}}}}}}
### Agile Person (DEX 61-70)
Impression: People think you're fast and nimble. Light on your feet, quick reactions.

Level: Clearly agile among ordinary people. Athlete or skilled warrior level.

Scope: Run fast, jump over obstacles, dodge attacks well in combat. Advantageous in pursuit, evasion, ambush, and situations requiring physical reactions.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 51}}::{{? {{getvar::dex_effective}} <= 60}}}}}}
### Average Agility (DEX 51-60)
Impression: Don't give an impression of being particularly fast or slow. Move normally.

Level: Ordinary person level. Sufficient for daily life.

Scope: Run normally, catch things normally, react normally. No special advantages but no problems either.
{{/if}}

{{#if {{? {{getvar::dex_effective}} <= 50}}}}
### Clumsy Movement (DEX 0-50)
Impression: People think you're slow and clumsy. Often trip, drop things, slow reactions.

Level: Lacking motor skills. Poor at handling your body.

Scope: Can hardly do anything requiring agility. Slow at running, difficult to dodge in combat, must find other methods than physical techniques. People try to protect you in dangerous situations.
{{/if}}

---

## 💬 CHA (Charisma)

{{#if {{? {{getvar::cha_effective}} >= 91}}}}
### Mythical Beauty (CHA 91-100)
Impression: People's breath stops the moment they see you. Say you're like a goddess of beauty from mythology manifested, your very presence overwhelms surroundings.

Level: On par with legendary beauties recorded in history. Beyond mere appearance, your presence itself is mysterious and overwhelming.

Scope: Can solve almost any social situation with charm. Captivate people at first meeting, even adversaries hesitate to harm you, hard to refuse your requests. Political influence, social dominance, becoming a public icon happen naturally.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 81}}::{{? {{getvar::cha_effective}} <= 90}}}}}}
### Overwhelming Beauty (CHA 81-90)
Impression: People can't take their eyes off you. When you enter a room, everyone's eyes turn to you, people listen carefully to your every word.

Level: Beauty that defines an era. Top-tier charm even among nobles or celebrities.

Scope: Become the center of social circles, people compete for your favor, gain advantageous positions in most negotiations. Gain overwhelming advantages in persuasion, negotiation, socializing.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 71}}::{{? {{getvar::cha_effective}} <= 80}}}}}}
### Captivating Charm (CHA 71-80)
Impression: People think you're beautiful. Draw attention, strong first impression, memorable.

Level: Charm beyond ordinary people. Actor, model, socialite level.

Scope: People treat you favorably, try to grant your requests, want to befriend you. Advantageous in socializing, negotiation, persuasion, leave good first impressions.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 61}}::{{? {{getvar::cha_effective}} <= 70}}}}}}
### Likable Person (CHA 61-70)
Impression: People consider you attractive. Have likable appearance and atmosphere.

Level: Clearly attractive among ordinary people. Have appearance and attitude people like.

Scope: Social interactions are smooth, people listen to you well. Advantageous in ordinary requests or negotiations, easy to make friends.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 51}}::{{? {{getvar::cha_effective}} <= 60}}}}}}
### Average Charm (CHA 51-60)
Impression: Don't give an impression of being particularly attractive or unattractive. Look like an ordinary person.

Level: Ordinary person level. Neither eye-catching nor off-putting.

Scope: Live social life normally. No special advantages or disadvantages.
{{/if}}

{{#if {{? {{getvar::cha_effective}} <= 50}}}}
### Unremarkable Presence (CHA 0-50)
Impression: People don't remember you well. Pass by without notice, thin presence, weak first impression.

Level: Lacking charm. Hard to stand out socially.

Scope: Struggle in social situations. People easily ignore or forget you, persuasion or negotiation difficult. However, being unremarkable can actually be advantageous for infiltration or observation.
{{/if}}

---

## 🍀 LUK (Luck)

{{#if {{? {{getvar::luk_effective}} >= 91}}}}
### Fate Controller (LUK 91-100)
Impression: People think events around you aren't coincidences. Revere you saying "blessed by fate," believe good fortune follows when with you.

Level: Mythical or legendary. Seems to bend fate itself beyond mere luck.

Scope: Impossible situations resolve miraculously. Fatal attacks miss, escape routes appear in desperate situations, needed things arrive at perfect timing. Every choice has "luck" as insurance.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 81}}::{{? {{getvar::luk_effective}} <= 90}}}}}}
### Miraculous Fortune (LUK 81-90)
Impression: People consider you "really lucky." Things you do work out well, think good things happen when with you.

Level: Level of historical lucky figures. Good things happen too often and too dramatically to be coincidence.

Scope: Receive unexpected help in crises, often win at gambling or lotteries, safe even with risky choices. Greatly advantageous in adventurous choices, dangerous gambles, situations needing miracles.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 71}}::{{? {{getvar::luk_effective}} <= 80}}}}}}
### Lucky Person (LUK 71-80)
Impression: People think you're lucky. Often hear "You're lucky," good things often happen around you.

Level: Fortune beyond ordinary people. Good things happen at statistically unexplainable frequency.

Scope: Fortune follows at important moments, avoid minor accidents, gain unexpected opportunities. Relatively safe even with risky choices, chance meetings become helpful.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 61}}::{{? {{getvar::luk_effective}} <= 70}}}}}}
### Decent Luck (LUK 61-70)
Impression: People think your luck isn't bad. Sometimes good things happen, no major misfortune.

Level: Lucky among ordinary people. Slightly above average.

Scope: Sometimes experience good coincidences, experience small fortunes. Not greatly advantageous, but little misfortune.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 51}}::{{? {{getvar::luk_effective}} <= 60}}}}}}
### Average Luck (LUK 51-60)
Impression: Don't give an impression of being particularly lucky or unlucky.

Level: Ordinary person level. Good and bad things happen normally.

Scope: Things proceed within predictable range. Fortune and misfortune are ordinary.
{{/if}}

{{#if {{? {{getvar::luk_effective}} <= 50}}}}
### Unlucky Person (LUK 0-50)
Impression: People think you're unlucky. Minor accidents happen often, often hear "You're unlucky."

Level: Bad things happen at statistically unexplainable frequency.

Scope: Mistakes happen at important moments, small misfortunes accumulate, encounter unexpected problems. However, this misfortune sometimes draws attention and help from others. Find reliable methods rather than depending on luck.
{{/if}}

---

## ❤️ VIT (Vitality)

{{#if {{? {{getvar::vit_effective}} >= 91}}}}
### Immortal Stamina (VIT 91-100)
Impression: People find it hard to believe you're human. Surprised asking "Aren't you tired?" "Don't you hurt?" compare you to legendary heroes.

Level: Mythical or legendary. Vitality completely transcending human limits.

Scope: Fine after staying up a week, recover from fatal wounds overnight, nearly immune to poison or disease. Endure any physical ordeal, can participate in continuous combat, long-distance pursuit, dangerous experiments.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 81}}::{{? {{getvar::vit_effective}} <= 90}}}}}}
### Steel Endurance (VIT 81-90)
Impression: People recognize you as "really tough." Admire your stamina and recovery, think they can rely on you.

Level: Beyond human limits. Comparable to warriors or explorers historically famous for toughness.

Scope: Fine next day after staying up all night, recover from injuries very fast, endure harsh environments. Can do prolonged combat, harsh training, dangerous experiments - all stamina-requiring options open.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 71}}::{{? {{getvar::vit_effective}} <= 80}}}}}}
### Athlete-Grade Stamina (VIT 71-80)
Impression: People think you're very healthy and sturdy. Surprised you don't tire, respect your perseverance.

Level: Stamina beyond ordinary people. Professional athlete or skilled warrior level.

Scope: Don't tire from long activities, recover quickly from injuries, accomplish physically demanding tasks. Possible to do all-nighters, long journeys, intense combat.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 61}}::{{? {{getvar::vit_effective}} <= 70}}}}}}
### Healthy Person (VIT 61-70)
Impression: People think you're healthy and sturdy. Rarely get sick, look energetic.

Level: Clearly healthy among ordinary people. Someone who manages stamina well.

Scope: No problems with daily activities, can endure moderate strain. Possible to stay up all night or force march, participate without problems in stamina-requiring situations.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 51}}::{{? {{getvar::vit_effective}} <= 60}}}}}}
### Average Vitality (VIT 51-60)
Impression: Don't give an impression of being particularly sturdy or weak. Look like an ordinary person.

Level: Ordinary person level. Sufficient for daily life.

Scope: Activity normally but tire if overdo it. Live while taking moderate rest, find other methods rather than relying on stamina.
{{/if}}

{{#if {{? {{getvar::vit_effective}} <= 50}}}}
### Frail Constitution (VIT 0-50)
Impression: People think you're weak and tire easily. Worry about your pale face, often say "Don't overdo it."

Level: Lacking stamina. Struggle with physical activities.

Scope: Tire easily and must rest often. Can hardly do stamina-requiring tasks, prolonged activities or intense combat impossible. However, this weakness draws care from others, enables delicate and thoughtful approaches. Naturally find paths solving through wisdom or emotion rather than stamina.
{{/if}}

---

# 🌟 Active Traits

{{#if {{? {{getvar::player_traits}} != ""}}}}

Player's Active Traits:
{{getvar::player_traits}}

## AI Guidelines

Traits are unique tendencies, talents, or curses of the character.

Naturally reflect them in narration:
- Describe actions, reactions, and outcomes that match the traits
- Mention traits in situations where they would have influence
- Express advantages or disadvantages from traits

Examples:
- "화염 친화" → Skilled at fire magic, resistant to heat
- "사교적" → Conversations flow well, people like you
- "불운" → Minor accidents occur frequently

Traits should blend naturally into the story.

{{/if}}