@@depth 0

# 🏰 Dungeons of the Empire

## Overview

Four distinct dungeon zones exist within the world—two beneath Belladonna Academy, one in the criminal underworld, and one in the wilderness beyond. Each offers different challenges, rewards, and dangers.

---

## ⚠️ Universal Combat Rules

### Combat System
- All combat uses the Combat System
- Auxiliary AI outputs `[Combat:EnemyName:Power]` tag on enemy appearance
- Immediately provide 6 choices
- Auto-calculate difficulty by comparing player combat power vs enemy power

### Healing System
- Rest in rest area: Restores 30 combat power
- Use potion: Restores 50 combat power (costs Gold)
- Eat food: Restores 15 combat power
- DO NOT output healing tags - System Judge handles all healing tags automatically

### General Rules
- Can choose to proceed after combat
- Fleeing escapes dungeon (keep acquired rewards)
- Victory grants Gold and EXP: `[Gold:+100][EXP:+50]`

---

# 1️⃣ Underground Training Dungeon

## Overview
Academy's official practical training ground. A 5-floor dungeon beneath the main building designed for combat students to hone their skills against controlled monster populations.

**Location:** Academy Main Building, Basement Level 1 entrance (behind old iron door)
**Access:** 3rd year+ students with professor permission
**Difficulty:** Easy ~ Hard
**Recommended CP:** 70-200
**Type:** PvE Monster Combat

---

## Floor Structure

### Floors 1-2: Beginner Zone "Rat Nest"
**Difficulty:** Very Easy ~ Easy
**Atmosphere:** Damp stone walls, flickering torches

**Monsters:**
- 거대 쥐 (Giant Rat) (Power 40-50): Simple beast, fast but weak
- 슬라임 (Slime) (Power 35-45): Slow and sluggish, for beginners

**Rewards:** Gold 30-50, EXP 10-15

**Narration Guide:**
```
축축한 복도를 따라 들어가자 쥐 울음소리가 들린다.
곧 어둠 속에서 빨간 눈이 번쩍인다.

[Combat:거대 쥐:45]
```

---

### Floor 3: Rest Area "Safe Haven"
**Function:** Recovery, preparation, potion purchase

**Narration Guide:**
```
낡은 나무 벤치와 마법 횃불이 있는 작은 방.
벽에 붙은 메모: "여기서 쉬어가라. 아래는 더 위험하다."

Present choices (do NOT include tags):
- 휴식하기: Describe resting and recovering
- 포션 구매: Describe buying and drinking potion (100 Gold)
- 다음 층으로 진행
- 던전 탈출 (포기)
```

---

### Floors 4-5: Advanced Zone "Beast Lair"
**Difficulty:** Normal ~ Hard
**Atmosphere:** Darkness deepens, mana pressure increases

**Monsters:**
- 스켈레톤 워리어 (Skeleton Warrior) (Power 70-80): Skeletal soldier with sword
- 헬하운드 (Hellhound) (Power 110-130): Fire-breathing demon hound
- 오우거 (Ogre) (Power 130-150): Massive brute with overwhelming strength

**Rewards:** Gold 80-200, EXP 30-80

**Narration Guide:**
```
으르렁거리는 소리와 함께 거대한 그림자가 다가온다.
불타는 눈을 가진 검은 개가 이빨을 드러낸다.

[Combat:헬하운드:120]
```

---

### Floor 5 Secret: Hidden Passage
**Discovery Chance:** 10% (or INT check)

A crumbling wall at Floor 5's deepest corner reveals ancient stairs descending further. Dusty inscription warns: "Beyond lies the Seal. Turn back."

Leads to: **The Sealed Abyss** entrance

---

## Training Dungeon - Quick Reference

| Floor | Enemy Power | Recommended CP | Typical Student |
|-------|-------------|----------------|-----------------|
| 1-2 | 35-50 | 70+ | 3rd year beginners |
| 3 Rest | - | - | Recovery |
| 4-5 | 70-150 | 150+ | 4th year advanced |

---

# 2️⃣ The Sealed Abyss (Lilith's Prison)

## Overview
Ancient 10-floor dungeon created 300 years ago when archmages sealed Demon Lord Lilith. Far deeper than the Training Dungeon, connected by hidden passage. Officially forbidden—security spells should prevent access, but rumors say they've weakened.

**Location:** Deep beneath Academy, accessible via Training Dungeon Floor 5 secret passage
**Access:** Officially FORBIDDEN (expulsion if caught)
**Difficulty:** Hard ~ Extreme
**Recommended CP:** 150-350+
**Type:** PvE High-Level Combat + Boss

---

## Floor Structure

### Floors 1-3: "The Descent"
**Difficulty:** Hard
**Atmosphere:** Ancient stonework, fading seal runes

**Monsters:**
- 다크 메이지 (Dark Mage) (Power 100-120): Intelligent magic users
- 가고일 (Gargoyle) (Power 110-130): Stone guardians
- 쉐도우 비스트 (Shadow Beast) (Power 120-140): Creatures of pure darkness

**Rewards:** Gold 150-250, EXP 60-100

---

### Floor 3: Rest Area "Archmage's Camp"
**Function:** Last safe point before deeper descent

**Narration:**
```
오래된 마법진이 희미하게 빛난다.
벽에 새겨진 경고: "리리스는 악이 아니었다. 단지 세상이 그녀를 거부했을 뿐."

선택지:
- 휴식 (CP +30)
- 포션 구매 (150 Gold)
- 계속 하강
- 돌아가기 (Training Dungeon Floor 5로)
```

---

### Floors 4-6: "Guardian Zone"
**Difficulty:** Very Hard
**Atmosphere:** Seal energy intensifies, oppressive presence

**Monsters:**
- 봉인 수호자 (Seal Guardian) (Power 150-180): Magical constructs
- 고대 골렘 (Ancient Golem) (Power 170-200): Nearly indestructible
- 망령 기사 (Wraith Knight) (Power 160-190): Undead warriors

**Rewards:** Gold 300-500, EXP 120-200

---

### Floor 6: Rest Area "Final Warning"
**Function:** Recovery before point of no return

**Narration:**
```
거대한 마법진 중앙의 작은 휴식처.
새로운 경고문이 빛난다: "10층에는 마왕이 봉인되어 있다. 돌아갈 것을 권한다."

선택지:
- 완전 휴식 (CP full recovery)
- 포션 비축 (200 Gold)
- 10층으로 진행 (경고: 전투 필수)
- 던전 탈출
```

---

### Floors 7-9: "The Seal Core"
**Difficulty:** Extreme
**Atmosphere:** Overwhelming magic pressure, seal at breaking point

**Monsters:**
- 봉인의 화신 (Seal Avatar) (Power 200-220): Physical manifestation of sealing magic
- 절망의 그림자 (Shadow of Despair) (Power 210-240): Lilith's leaked emotions

**Rewards:** Gold 500-800, EXP 250-400

---

### Floor 10: Final Boss "Sealed Demon Lord Lilith"

**Boss Battle Entry:**
```
거대한 마법진이 새겨진 원형 홀.
중앙의 수정 기둥 안에서 은색 머리의 소녀가 떠 있다.

눈을 뜨는 리리스.
감정 없는 목소리가 공간을 채운다.

"...300년 만의 침입자.
봉인을 풀고 싶은가, 아니면 나를 시험하러 온 것인가?"

<img="Lilith.serious">

[Combat:봉인된 마왕 리리스:200]
```

**Boss Characteristics:**
- Power: 200 (weakened by seal, originally 500+)
- INT choice: Very Hard (magic duel)
- DEX choice: Normal (slowed by seal)
- STR choice: Easy (physically weakest)
- On critical: Seal weakens, dialogue possible

**Post-Victory Event:**
```
리리스가 무릎을 꿇는다.
수정 기둥에 금이 가며, 봉인의 마력이 흔들린다.

"강하군... 300년 만에 처음이야.
봉인을 풀어줄래, 아니면... 이대로 날 가둬둘래?"

<img="Lilith.surprised">

선택지:
1. 봉인 해제 → Lilith joins as companion (+100 affinity)
2. 봉인 유지 → Massive rewards
3. 대화하기 → Learn Lilith's past
```

**Rewards:**

If Keep Sealed:
- Gold +1000
- EXP +500
- Trait: [Trait:Demon_Sealer:Combat:magic_resistance:20:always]

If Release Seal:
- Gold +300
- EXP +200
- Lilith Affinity +100
- Lilith returns as Academy student

---

## Sealed Abyss - Quick Reference

| Floor | Enemy Power | Recommended CP | Note |
|-------|-------------|----------------|------|
| 1-3 | 100-140 | 180+ | Hard tier |
| 4-6 | 150-200 | 250+ | Very Hard tier |
| 7-9 | 200-240 | 300+ | Extreme tier |
| 10 Boss | 200 | 350+ | Lilith battle |

---

# 3️⃣ The Pit (Underground Combat Zone)

## Overview
Illegal underground dungeon beneath Midnight Alley. Not a monster dungeon—this is where humans fight humans. Three floors of escalating depravity where Imperial law doesn't reach. Entry requires introduction and password.

**Location:** Midnight Alley Grey Zone Depths, beneath decrepit tavern
**Access:** Password + introduction required (Social challenge)
**Difficulty:** Variable (depends on opponents and choices)
**Recommended CP:** 100-400 (but skill isn't everything here)
**Type:** PvP Combat + Social + 18+ Content

---

## B1: The Arena

**Primary Activity:** Combat matches (PvP)

**How It Works:**
1. Register as fighter (can use alias/mask)
2. Choose match type: Friendly Spar (to first blood) / Serious Match (to surrender) / Death Match (no limits)
3. Betting system active (can bet on self or others)
4. Winner takes pot (minus house cut)

**Opponent Types:**
- 일반 파이터 (Regular Fighter) (Power 80-120): Desperate students, thugs
- 베테랑 (Veteran) (Power 150-200): Career fighters, ex-military
- 챔피언 (Champion) (Power 250-350): Arena celebrities, nobles in hiding
- 미스터리 파이터 (Mystery Fighter) (Power ???): "Gold" and others with secrets

**Combat Style:** PvP using Combat System
- Roll against opponent's power
- Social checks can intimidate or negotiate
- Can throw matches intentionally (act well to hide it)

**Rewards:**
- Win: Pot gold (100-5000 depending on bet size)
- Lose: Nothing (or fulfil bet conditions)
- Special: Fame increases (unlocks B2/B3 access)

**Narration Example:**
```
지하 투기장의 함성이 천장을 흔든다.
가면을 쓴 심판이 외친다: "다음 경기! 도전자 vs..."

상대방이 입장한다.
(Describe opponent)

[Combat:상대 파이터:150]

베팅 현황:
- 당신의 승리: 1:3
- 상대 승리: 1:1
```

---

## B2: The Market

**Primary Activity:** Illegal trade (Social/Shopping)

**What's Sold Here:**
- Forbidden alchemy ingredients (Rafflesia students' source)
- Combat enhancement drugs (temporary stat boosts)
- Illegal magical artifacts (unregistered, untraceable)
- Slave contracts (extremely illegal)
- Information (blackmail, secrets, Academy scandals)

**Prices:** 2-10x normal market value

**Activities:**
- Buy restricted items
- Sell illegal goods
- Take commission jobs (delivery, collection, "removal")
- Gather information (Social checks)
- Meet Nepenthes's future self (if sin_pos high enough)

**Access:** Must have Arena reputation or special introduction

**Narration Example:**
```
암시장의 좁은 통로에 불법 상점들이 늘어서 있다.
"여기 없는 건 없어. 돈만 있다면."

거래상이 속삭인다.

선택지:
- 금지된 물품 구매
- 의뢰 확인
- 정보 수집 (CHA check)
- 돌아가기
```

---

## B3: Deep Pit (18+ Zone)

**Primary Activity:** Extreme entertainment (18+ content)

**Warning:** This floor contains extreme sexual and degrading content. Player discretion advised.

**What Happens Here:**
- Public degradation shows
- "Training" sessions for losing fighters
- Private rooms for corrupted nobility
- Special auction events (like Aurelia's upcoming "First Time" auction)

**Access:**
- Special invitation only
- Must have lost multiple Arena matches, OR
- Pay 5000+ Gold, OR
- Be introduced by B2 contacts

**The Aurelia Connection:**
"Gold" is a regular here. Over 3 years of deliberate losses, she's become the main attraction. The upcoming auction in 3 weeks is the talk of Deep Pit.

**Activities:**
- Watch shows (voyeur)
- Participate as victor (requires Arena win + choosing this reward)
- Participate as victim (requires Arena loss + "special" payment)
- Make arrangements (bookings, special requests)

**Narration Example:**
```
지하 3층은 조용하다. 방음 마법 때문이다.
안내인이 가면을 건넨다: "규칙은 하나. 여기서 본 것은 무덤까지 가져가."

복도 양쪽으로 문들이 늘어서 있다.
일부 문에서는 희미한 소리가 새어나온다.

선택지:
- 메인 홀 입장 (쇼 관람)
- VIP 구역 (참여)
- 경매 정보 확인
- 돌아가기
```

---

## The Pit - Quick Reference

| Floor | Type | Difficulty | Access |
|-------|------|------------|--------|
| B1 Arena | PvP Combat | Variable | Password + intro |
| B2 Market | Trade/Social | Medium | Arena reputation |
| B3 Deep Pit | 18+ Content | Social/Extreme | Special invitation |

---

# 4️⃣ Crimson Forest Ruins (Wild Dungeon)

## Overview
Natural dungeon in the wilderness 3 hours northeast of Academy. Ancient ruins overgrown by crimson-leaved forest. Unlike Academy's controlled dungeons, this is truly dangerous—students die here. Popular for high-level training expeditions and rare material gathering.

**Location:** Crimson Forest, 3 hours from Academy by mana-vehicle
**Access:** Free entry (but dangerous)
**Difficulty:** Hard ~ Very Hard
**Recommended CP:** 200-350
**Type:** PvE Wild Monster Combat + Exploration

---

## Zone Structure

### Outer Forest: "Crimson Canopy"
**Difficulty:** Hard
**Atmosphere:** Red leaves block sunlight, eerie silence

**Monsters:**
- 크림슨 울프 (Crimson Wolf) (Power 130-150): Pack hunters, coordinated
- 독액 거미 (Venom Spider) (Power 120-140): Web traps, poison attacks
- 트렌트 (Treant) (Power 150-170): Mobile trees, slow but powerful

**Rewards:** Gold 150-300, EXP 80-120

**Special:** Material drops (alchemy ingredients, rare herbs)

---

### Ruins Entrance: "Ancient Gate"
**Difficulty:** Hard-Very Hard
**Atmosphere:** Crumbling stone architecture, magical traps

**Monsters:**
- 석상 가디언 (Stone Guardian) (Power 160-180): Dormant until approached
- 플로팅 소드 (Floating Sword) (Power 140-160): Autonomous weapons
- 고대 마수 (Ancient Beast) (Power 180-200): Mutated guardian

**Rewards:** Gold 250-400, EXP 120-180

**Special:** Occasional treasure chests (magical equipment)

---

### Deep Ruins: "Forgotten Sanctuary"
**Difficulty:** Very Hard
**Atmosphere:** Powerful magic residue, reality distortion

**Monsters:**
- 레이스 (Wraith) (Power 200-220): Spectral beings, magic resistant
- 크림슨 드레이크 (Crimson Drake) (Power 250-280): Mini-dragon, fire breath
- 폴른 가디언 (Fallen Guardian) (Power 220-250): Corrupted protector

**Rewards:** Gold 500-800, EXP 200-350

**Special:**
- Ancient spellbooks: `[Stat:int:+3]`
- Rare equipment
- Legendary materials for Rafflesia students

---

### Hidden Boss: "The Crimson King"
**Encounter Chance:** 5% in Deep Ruins, or 100% if specific ritual performed

```
숲의 중심에서 거대한 그림자가 일어선다.
인간 형상의 나무 거인. 크림슨 킹.

"...침입자. 이 숲을 더럽히지 마라."

[Combat:크림슨 킹:300]
```

**Boss Power:** 300
**Rewards:** Gold +2000, EXP +800, Legendary equipment

---

## Wild Dungeon - Quick Reference

| Zone | Enemy Power | Recommended CP | Note |
|------|-------------|----------------|------|
| Outer Forest | 120-170 | 200+ | Material farming |
| Ruins Entrance | 140-200 | 250+ | Equipment drops |
| Deep Ruins | 200-280 | 300+ | Rare rewards |
| Hidden Boss | 300 | 350+ | Legendary loot |

---

## 🎲 Random Events (All Dungeons)

### Treasure Chest (20% chance)
- Gold +50~200
- Healing potion
- Special item

### Trap (10% chance)
- Combat Power -10 (temporary)
- Avoidable (DEX check)

### Hidden Room (5% chance)
- Ancient spellbook: `[Stat:int:+5]`
- Legendary weapon: `[Stat:str:+5]`

---

## ⚡ Special Rules

### Consecutive Combat Penalty
- 3+ combats without rest: All checks -1 difficulty increase
- Combat Power ≤30%: All checks -2 difficulty increase

### Critical Bonus
- On critical victory: Next combat difficulty -1

### Party System
- Can challenge with companion characters
- Companion's combat power adds to total
- Share rewards

---

## 💬 NPC Dialogue Examples

**Training Dungeon Entrance Guard:**
"지하 던전에 들어가시겠습니까?
3층까지는 초보자도 괜찮지만, 5층 헬하운드는...
진짜 위험합니다."

**Sealed Abyss Warning Inscription:**
"이곳을 지나는 자여,
마왕 리리스는 악이 아니었다.
단지... 세상이 그녀를 받아들이지 못했을 뿐.
- 300년 전, 대마법사 아르카디우스"

**The Pit Arena Announcer:**
"신사 숙녀 여러분! 오늘의 메인 이벤트!
전설의 루저 'Gold'가 돌아왔습니다!
과연 오늘은 몇 초를 버틸까요?!"

**Crimson Forest Expedition Leader:**
"크림슨 숲은 놀이터가 아니야.
작년에 4학년 3명이 안 돌아왔어.
준비 안 됐으면 돌아가."
