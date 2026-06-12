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
Impression: People look at you as if witnessing a legendary hero.
Level: Superhuman strength that completely transcends human limits.
Scope: Break down castle gates alone, lift giant boulders, overwhelm beasts. Physical obstacles essentially don't exist.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 81}}::{{? {{getvar::str_effective}} <= 90}}}}}}
### Monstrous Strength (STR 81-90)
Impression: People feel like they're witnessing a hero from famous tales.
Level: Strength beyond human limits. Can wrestle bears or tigers barehanded.
Scope: Break down heavy doors, lift people with one hand, fight wild beasts. Dominate in combat.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 71}}::{{? {{getvar::str_effective}} <= 80}}}}}}
### Superhuman Strength (STR 71-80)
Impression: People feel they could never defeat you in strength.
Level: Beginning to exceed ordinary people. Athletic-level physical capability.
Scope: Move heavy furniture alone, break doors with force, easily subdue people.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 61}}::{{? {{getvar::str_effective}} <= 70}}}}}}
### Strong Person (STR 61-70)
Impression: People clearly recognize you as strong.
Level: Clearly strong among ordinary people. Like someone who regularly works out.
Scope: Lift heavy loads, carry or drag people. Strength greatly helps in daily life.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 51}}::{{? {{getvar::str_effective}} <= 60}}}}}}
### Above Average (STR 51-60)
Impression: People notice you're stronger than average.
Level: Somewhat stronger than ordinary people.
Scope: Lift moderately heavy objects, win arm wrestling against most people. Noticeable advantage in physical tasks.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 41}}::{{? {{getvar::str_effective}} <= 50}}}}}}
### Average Strength (STR 41-50)
Impression: Look like an ordinary person.
Level: Ordinary person level. Strength sufficient for daily life.
Scope: Lift ordinary objects, do ordinary physical activities. No special advantages or disadvantages.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 21}}::{{? {{getvar::str_effective}} <= 40}}}}}}
### Below Average (STR 21-40)
Impression: People think you're weak. Often receive help from others.
Level: Lacking in strength. Physical tasks are difficult.
Scope: Struggle with heavier objects, tire quickly from physical labor. Must find other methods.
{{/if}}

{{#if {{and::{{? {{getvar::str_effective}} >= 1}}::{{? {{getvar::str_effective}} <= 20}}}}}}
### Frail Build (STR 1-20)
Impression: People worry about you constantly. Look fragile.
Level: Very weak. Even basic physical tasks are challenging.
Scope: Can barely lift everyday items, completely avoid physical confrontations. Your weakness draws protective instincts from others.
{{/if}}

---

## 🧠 INT (Intelligence)

{{#if {{? {{getvar::int_effective}} >= 91}}}}
### Mythical Intellect (INT 91-100)
Impression: People revere you, considering it an honor just to speak with you.
Level: A once-in-centuries genius. Possess insight that penetrates the world's principles.
Scope: Reconstruct forbidden magical theories on the spot, decipher ancient texts at a glance, see through opponents' thoughts.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 81}}::{{? {{getvar::int_effective}} <= 90}}}}}}
### Genius Level (INT 81-90)
Impression: People recognize you as a genius. Your ideas are innovative, insights deep.
Level: Top tier even among scholars, mages, and strategists.
Scope: Understand complex theories instantly, create new magic, foresee opponent's traps.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 71}}::{{? {{getvar::int_effective}} <= 80}}}}}}
### Exceptional Intelligence (INT 71-80)
Impression: People clearly recognize you as "smart."
Level: Expert level as a scholar, mage, or strategist.
Scope: Quickly understand difficult magical theories, logically solve complex problems, see through lies.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 61}}::{{? {{getvar::int_effective}} <= 70}}}}}}
### Intelligent Person (INT 61-70)
Impression: People think you're smart.
Level: Clearly intellectual among ordinary people. Like a university graduate.
Scope: Understand basic magical theory, excel academically, solve simple riddles. Logical conversation comes easily.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 51}}::{{? {{getvar::int_effective}} <= 60}}}}}}
### Above Average (INT 51-60)
Impression: People notice you're smarter than average.
Level: Somewhat smarter than ordinary people.
Scope: Learn faster than peers, understand moderately complex topics. Academic work comes easier.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 41}}::{{? {{getvar::int_effective}} <= 50}}}}}}
### Average Intelligence (INT 41-50)
Impression: Converse normally, understand normally.
Level: Ordinary person level. Intelligence sufficient for daily life.
Scope: Understand basic education, handle simple tasks, engage in ordinary conversation.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 21}}::{{? {{getvar::int_effective}} <= 40}}}}}}
### Below Average (INT 21-40)
Impression: People notice you're slower to understand. Need explanations more carefully.
Level: Struggle with abstract concepts and complex topics.
Scope: Take longer to learn, must work harder to keep up academically. Rely on intuition over logic.
{{/if}}

{{#if {{and::{{? {{getvar::int_effective}} >= 1}}::{{? {{getvar::int_effective}} <= 20}}}}}}
### Simple Thinking (INT 1-20)
Impression: People speak to you very simply and slowly.
Level: Severe difficulty with intellectual tasks. Abstract thought nearly impossible.
Scope: Can follow very simple instructions but struggle with anything complex. However, this makes others more patient and willing to help.
{{/if}}

---

## 🤸 DEX (Dexterity)

{{#if {{? {{getvar::dex_effective}} >= 91}}}}
### Supernatural Agility (DEX 91-100)
Impression: People can't properly see your movements. Leave only afterimages.
Level: Speed and agility rivaling mythical heroes or legendary thieves.
Scope: Change direction mid-air, step on walls while falling, catch arrows by hand. Dominate in assassination, escape, acrobatics.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 81}}::{{? {{getvar::dex_effective}} <= 90}}}}}}
### Lightning Speed (DEX 81-90)
Impression: People can't follow your movements.
Level: Speed beyond human limits. Level of historical master swordsmen.
Scope: Do consecutive somersaults, climb walls, dodge flying weapons. Ordinary people can't catch you.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 71}}::{{? {{getvar::dex_effective}} <= 80}}}}}}
### Acrobat Level (DEX 71-80)
Impression: People admire your movements. Marvel "How can you move like that?"
Level: Professional acrobat, first-rate martial artist, skilled thief level.
Scope: Run on narrow railings, jump from heights and land safely, flexibly dodge attacks in close combat.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 61}}::{{? {{getvar::dex_effective}} <= 70}}}}}}
### Agile Person (DEX 61-70)
Impression: People think you're fast and nimble. Light on your feet.
Level: Clearly agile among ordinary people. Athlete or skilled warrior level.
Scope: Run fast, jump over obstacles, dodge attacks well in combat.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 51}}::{{? {{getvar::dex_effective}} <= 60}}}}}}
### Above Average (DEX 51-60)
Impression: People notice you're quicker than most. Good reflexes.
Level: Somewhat more agile than ordinary people.
Scope: React faster than peers, better hand-eye coordination. Advantage in physical activities.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 41}}::{{? {{getvar::dex_effective}} <= 50}}}}}}
### Average Agility (DEX 41-50)
Impression: Move normally.
Level: Ordinary person level. Sufficient for daily life.
Scope: Run normally, catch things normally, react normally. No special advantages or problems.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 21}}::{{? {{getvar::dex_effective}} <= 40}}}}}}
### Below Average (DEX 21-40)
Impression: People notice you're slow or clumsy. Often trip or drop things.
Level: Lacking motor skills. Poor at handling your body.
Scope: Frequently make physical mistakes, slow at running, difficult to dodge in combat. People often help with delicate tasks.
{{/if}}

{{#if {{and::{{? {{getvar::dex_effective}} >= 1}}::{{? {{getvar::dex_effective}} <= 20}}}}}}
### Clumsy Movement (DEX 1-20)
Impression: People constantly worry you'll hurt yourself.
Level: Severely poor coordination. Basic physical control is difficult.
Scope: Can barely perform tasks requiring coordination, constant accidents. However, people become very protective.
{{/if}}

---

## 💬 CHA (Charisma)

{{#if {{? {{getvar::cha_effective}} >= 91}}}}
### Mythical Beauty (CHA 91-100)
Impression: People's breath stops the moment they see you.
Level: On par with legendary beauties. Your presence itself is mysterious and overwhelming.
Scope: Captivate people at first meeting, even adversaries hesitate to harm you. Political influence and social dominance happen naturally.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 81}}::{{? {{getvar::cha_effective}} <= 90}}}}}}
### Overwhelming Beauty (CHA 81-90)
Impression: People can't take their eyes off you. When you enter a room, everyone's eyes turn to you.
Level: Beauty that defines an era. Top-tier charm even among nobles or celebrities.
Scope: Become the center of social circles, people compete for your favor. Overwhelming advantages in persuasion.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 71}}::{{? {{getvar::cha_effective}} <= 80}}}}}}
### Captivating Charm (CHA 71-80)
Impression: People think you're beautiful. Draw attention, strong first impression.
Level: Charm beyond ordinary people. Actor, model, socialite level.
Scope: People treat you favorably, try to grant your requests, want to befriend you.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 61}}::{{? {{getvar::cha_effective}} <= 70}}}}}}
### Likable Person (CHA 61-70)
Impression: People consider you attractive. Have likable appearance and atmosphere.
Level: Clearly attractive among ordinary people.
Scope: Social interactions are smooth, people listen to you well. Easy to make friends.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 51}}::{{? {{getvar::cha_effective}} <= 60}}}}}}
### Above Average (CHA 51-60)
Impression: People find you pleasant. Nicer than average appearance or personality.
Level: Somewhat more charming than ordinary people.
Scope: Make good first impressions, people are receptive to you. Social situations go smoothly.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 41}}::{{? {{getvar::cha_effective}} <= 50}}}}}}
### Average Charm (CHA 41-50)
Impression: Look like an ordinary person.
Level: Ordinary person level. Neither eye-catching nor off-putting.
Scope: Live social life normally. No special advantages or disadvantages.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 21}}::{{? {{getvar::cha_effective}} <= 40}}}}}}
### Below Average (CHA 21-40)
Impression: People don't find you particularly memorable. Somewhat plain or awkward.
Level: Less charming than average. Hard to stand out socially.
Scope: Struggle in social situations. People easily ignore or forget you. However, being unremarkable can be advantageous for infiltration.
{{/if}}

{{#if {{and::{{? {{getvar::cha_effective}} >= 1}}::{{? {{getvar::cha_effective}} <= 20}}}}}}
### Unremarkable Presence (CHA 1-20)
Impression: People actively avoid you or don't notice you at all.
Level: Severely lacking social presence.
Scope: Very difficult to make friends or persuade anyone. However, this isolation may lead to unexpected connections with fellow outcasts.
{{/if}}

---

## 🍀 LUK (Luck)

{{#if {{? {{getvar::luk_effective}} >= 91}}}}
### Fate Controller (LUK 91-100)
Impression: People think events around you aren't coincidences. Revere you saying "blessed by fate."
Level: Mythical or legendary. Seems to bend fate itself beyond mere luck.
Scope: Impossible situations resolve miraculously. Fatal attacks miss, escape routes appear, needed things arrive at perfect timing.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 81}}::{{? {{getvar::luk_effective}} <= 90}}}}}}
### Miraculous Fortune (LUK 81-90)
Impression: People consider you "really lucky." Think good things happen when with you.
Level: Level of historical lucky figures. Good things happen too often to be coincidence.
Scope: Receive unexpected help in crises, often win at gambling, safe even with risky choices.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 71}}::{{? {{getvar::luk_effective}} <= 80}}}}}}
### Lucky Person (LUK 71-80)
Impression: People think you're lucky. Often hear "You're lucky."
Level: Fortune beyond ordinary people. Good things happen at statistically unexplainable frequency.
Scope: Fortune follows at important moments, avoid minor accidents, gain unexpected opportunities.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 61}}::{{? {{getvar::luk_effective}} <= 70}}}}}}
### Decent Luck (LUK 61-70)
Impression: People think your luck isn't bad.
Level: Lucky among ordinary people. Slightly above average.
Scope: Sometimes experience good coincidences, experience small fortunes.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 51}}::{{? {{getvar::luk_effective}} <= 60}}}}}}
### Above Average (LUK 51-60)
Impression: People notice things tend to work out for you more often than not.
Level: Somewhat luckier than ordinary people.
Scope: Experience fortunate coincidences regularly, minor risks tend to pay off.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 41}}::{{? {{getvar::luk_effective}} <= 50}}}}}}
### Average Luck (LUK 41-50)
Impression: Don't give an impression of being particularly lucky or unlucky.
Level: Ordinary person level. Good and bad things happen normally.
Scope: Things proceed within predictable range. Fortune and misfortune are ordinary.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 21}}::{{? {{getvar::luk_effective}} <= 40}}}}}}
### Below Average (LUK 21-40)
Impression: People notice you have minor bad luck more often. Often hear "You're unlucky."
Level: Bad things happen at statistically unexplainable frequency.
Scope: Mistakes happen at important moments, small misfortunes accumulate. However, this draws attention and help from others.
{{/if}}

{{#if {{and::{{? {{getvar::luk_effective}} >= 1}}::{{? {{getvar::luk_effective}} <= 20}}}}}}
### Unlucky Person (LUK 1-20)
Impression: People actively avoid involving you in risky situations, fearing your bad luck.
Level: Severely unfortunate. Disasters follow you.
Scope: Major misfortunes happen regularly, risks almost always go wrong. However, people become sympathetic and you learn to find reliable methods.
{{/if}}

---

## ❤️ VIT (Vitality)

{{#if {{? {{getvar::vit_effective}} >= 91}}}}
### Immortal Stamina (VIT 91-100)
Impression: People find it hard to believe you're human. Compare you to legendary heroes.
Level: Mythical or legendary. Vitality completely transcending human limits.
Scope: Fine after staying up a week, recover from fatal wounds overnight, nearly immune to poison or disease.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 81}}::{{? {{getvar::vit_effective}} <= 90}}}}}}
### Steel Endurance (VIT 81-90)
Impression: People recognize you as "really tough." Admire your stamina and recovery.
Level: Beyond human limits. Comparable to warriors historically famous for toughness.
Scope: Fine next day after staying up all night, recover from injuries very fast, endure harsh environments.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 71}}::{{? {{getvar::vit_effective}} <= 80}}}}}}
### Athlete-Grade Stamina (VIT 71-80)
Impression: People think you're very healthy and sturdy. Surprised you don't tire.
Level: Stamina beyond ordinary people. Professional athlete or skilled warrior level.
Scope: Don't tire from long activities, recover quickly from injuries. Possible to do all-nighters, long journeys, intense combat.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 61}}::{{? {{getvar::vit_effective}} <= 70}}}}}}
### Healthy Person (VIT 61-70)
Impression: People think you're healthy and sturdy. Rarely get sick.
Level: Clearly healthy among ordinary people.
Scope: No problems with daily activities, can endure moderate strain. Can stay up all night or force march.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 51}}::{{? {{getvar::vit_effective}} <= 60}}}}}}
### Above Average (VIT 51-60)
Impression: People notice you have better stamina than most.
Level: Somewhat healthier than ordinary people.
Scope: Can work longer hours without tiring, bounce back from minor illnesses quickly. Noticeable advantage in sustained activities.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 41}}::{{? {{getvar::vit_effective}} <= 50}}}}}}
### Average Vitality (VIT 41-50)
Impression: Look like an ordinary person.
Level: Ordinary person level. Sufficient for daily life.
Scope: Activity normally but tire if overdo it. Live while taking moderate rest.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 21}}::{{? {{getvar::vit_effective}} <= 40}}}}}}
### Below Average (VIT 21-40)
Impression: People think you're weak and tire easily. Often say "Don't overdo it."
Level: Lacking stamina. Struggle with physical activities.
Scope: Tire easily and must rest often. Can hardly do stamina-requiring tasks. However, this draws care from others.
{{/if}}

{{#if {{and::{{? {{getvar::vit_effective}} >= 1}}::{{? {{getvar::vit_effective}} <= 20}}}}}}
### Frail Constitution (VIT 1-20)
Impression: People constantly worry about your health. Treated as if you might collapse.
Level: Severely weak constitution. Basic activities are exhausting.
Scope: Cannot participate in strenuous activity, frequently ill. However, this creates protective care from others.
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
