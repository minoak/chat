@@depth 0

# 🏰 Academy Underground Dungeon

## Dungeon Overview

An ancient dungeon sealed beneath the Academy main building. A 10-floor trial structure created 300 years ago when archmages sealed the Demon Lord Lilith. Currently used as a practical training ground for students, though deeper floors remain dangerous.

Entrance Location: Behind old iron door, Academy main building basement floor 1
Restriction: Level 3+ students only (professor permission required)
Feature: Once entered, must clear or flee

---

## ⚠️ Important Rules

### Combat System
- All combat uses the Combat System
- Auxiliary AI outputs `[Combat:MonsterName:Power]` tag on enemy appearance
- Immediately provide 6 choices
- Auto-calculate difficulty by comparing player combat power vs enemy power

### Dungeon Progression
- 1-3 combats per floor
- Can choose to proceed to next floor after combat
- Rest areas appear every 3 floors (Floors 3, 6, 9)
- Fleeing escapes dungeon (no rewards)

### Healing System
- Rest in rest area: Restores 30 combat power
- Use potion: Restores 50 combat power (costs Gold)
- Eat food: Restores 15 combat power
- DO NOT output healing tags - System Judge handles all healing tags automatically

---

## 📊 Floor Structure

### Floors 1-2: Beginner Zone "Rat Nest"
Difficulty: Very Easy ~ Easy
Atmosphere: Damp stone walls, flickering torches

Monsters:
- 거대 쥐 (Giant Rat) (Power 40-50): Simple beast, fast but weak
- 슬라임 (Slime) (Power 35-45): Slow and sluggish, for beginners

Rewards: Gold 30-50, EXP 10-15

Narration Guide:
```
축축한 복도를 따라 들어가자 쥐 울음소리가 들린다.
곧 어둠 속에서 빨간 눈이 번쩍인다.

[Combat:거대 쥐:45]
```

---

### Floor 3: Rest Area "First Sanctuary"
Function: Recovery, preparation, potion purchase

Narration Guide:
```
낡은 나무 벤치와 마법 횃불이 있는 작은 방.
벽에 붙은 메모: "여기서 쉬어가라. 아래는 더 위험하다."

Present choices (do NOT include tags in your response):
- 휴식하기: Describe resting and recovering (System Judge outputs healing tag)
- 포션 구매: Describe buying and drinking potion (100 Gold)
- 다음 층으로 진행
- 던전 탈출 (포기)
```

---

### Floors 4-5: Intermediate Zone "Undead Tomb"
Difficulty: Normal ~ Hard
Atmosphere: Bones and skulls scattered, eerie cold

Monsters:
- 스켈레톤 워리어 (Skeleton Warrior) (Power 70-80): Skeletal soldier with sword, solid fundamentals
- 좀비 (Zombie) (Power 60-70): Slow but strong striking power

Rewards: Gold 80-120, EXP 30-40

Narration Guide:
```
바닥에 흩어진 뼈들이 덜컹거리며 모여든다.
해골이 녹슨 검을 집어들고 일어선다.

[Combat:스켈레톤 워리어:75]
```

---

### Floor 6: Rest Area "Mid Camp"
Function: Recovery, equipment check, potion purchase

Narration Guide:
```
모닥불이 타오르는 작은 야영지.
누군가 남긴 침낭과 빈 포션병이 보인다.

Present choices (do NOT include tags in your response):
- 휴식하기: Describe resting and recovering
- 모닥불에서 음식 조리: Describe cooking and eating food
- 포션 구매: Describe buying and drinking potion (100 Gold)
- 다음 층으로 진행
- 던전 탈출 (포기)
```

---

### Floors 7-8: Advanced Zone "Beast Territory"
Difficulty: Hard ~ Very Hard
Atmosphere: Darkness deepens, mana pressure heavy in the air

Monsters:
- 헬하운드 (Hellhound) (Power 110-130): Fire-breathing demon hound, fast and strong
- 오우거 (Ogre) (Power 130-150): Massive monster, overwhelming strength
- 다크 메이지 (Dark Mage) (Power 100-120): Magic attacks, intelligent

Rewards: Gold 180-250, EXP 80-100

Narration Guide:
```
으르렁거리는 소리와 함께 거대한 그림자가 다가온다.
불타는 눈을 가진 검은 개가 이빨을 드러낸다.

[Combat:헬하운드:120]
```

---

### Floor 9: Rest Area "Final Preparation"
Function: Last recovery, full resupply

Narration Guide:
```
마지막 안식처. 마법진이 그려진 원형 방.
바닥에 새겨진 경고문: "10층에는 마왕이 봉인되어 있다.
돌아갈 것을 권한다."

Present choices (do NOT include tags in your response):
- 완전 휴식: Describe full rest and complete recovery
- 포션 비축: Describe buying and storing potions (150 Gold)
- 10층으로 진행 (경고: 돌이킬 수 없음)
- 던전 탈출 (포기)
```

---

## 👿 Floor 10: Final Boss "Sealed Demon Lord Lilith"

### Boss Battle Entry

Narration Guide:
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

### Boss Characteristics

Demon Lord Lilith (Sealed State)
- Power: 200 (weakened by seal, originally 500+)
- Features:
  - Genius mage (based on INT 92)
  - Physical abilities weakened by seal
  - Emotions suppressed (yandere symptoms sealed)
  - No smoking (for 300 years)

Combat Pattern:
- INT choice Very Hard (magic duel)
- DEX choice Normal (slowed by seal)
- STR choice Easy (physically weakest)
- On critical: Seal weakens (dialogue possible)

### Post-Victory Event

On Boss Defeat:
```
리리스가 무릎을 꿇는다.
수정 기둥에 금이 가며, 봉인의 마력이 흔들린다.

"강하군... 300년 만에 처음이야.
봉인을 풀어줄래, 아니면... 이대로 날 가둬둘래?"

<img="Lilith.surprised">

선택지:
1. 봉인 해제 → 리리스를 동료로 획득 (호감도 +100)
2. 봉인 유지 → 막대한 보상 획득
3. 대화하기 → 리리스의 과거 이야기
```

### Rewards

If Keep Sealed:
- Gold +1000
- EXP +500
- Trait: [Trait:Demon_Sealer:Combat:magic_resistance:20:always]
- Item: Demon Lord's Crystal Fragment

If Release Seal:
- Gold +300
- EXP +200
- Lilith Affinity +100 (immediately "Reluctant Interest" state)
- Lilith returns as Academy student
- Trait: [Trait:Demon_Friend:Social:charisma_bonus:15:with_Lilith]

---

## 🎯 Recommended Combat Power by Difficulty

| Floor | Monster Power | Recommended CP | Character Example |
|---|---|---|---|
| Floors 1-2 | 35-50 | 70+ | Beginner students |
| Floor 3 Rest | - | - | Recovery |
| Floors 4-5 | 60-80 | 120+ | Intermediate students |
| Floor 6 Rest | - | - | Recovery |
| Floors 7-8 | 100-150 | 200+ | Advanced students |
| Floor 9 Rest | - | - | Full recovery |
| Floor 10 Boss | 200 | 300+ | Cassandra/Aurelia level |

---

## 📝 Narration Guidelines

### Combat Encounter
1. Describe atmosphere (reflect floor characteristics)
2. Describe monster appearance vividly
3. System Judge will automatically detect combat and provide choices

### Rest Area Arrival
1. Describe safe space
2. Present choices (rest/potion/proceed/flee)
3. Wait for player choice

### After Combat Victory
1. Victory演出
2. Grant rewards: `[Gold:+100][EXP:+50]`
3. Ask about proceeding to next floor

### Flee/Escape
1. Successfully escape safely
2. Keep acquired rewards
3. Can re-challenge anytime

---

## 🎲 Random Events (Optional)

Treasure Chest (20% chance):
- Gold +50~200
- Healing potion
- Special item

Trap (10% chance):
- Combat Power -10 (temporary)
- Avoidable (DEX check)

Hidden Room (5% chance):
- Ancient spellbook: `[Stat:int:+5]`
- Legendary weapon: `[Stat:str:+5]`

---

## ⚡ Special Rules

### Consecutive Combat Penalty
- 3+ combats without rest: All checks -1 difficulty increase
- Combat Power ≤30%: All checks -2 difficulty increase

### Critical Bonus
- On critical victory: Next floor's first combat difficulty -1

### Party System (Future Expansion)
- Can challenge with companion characters
- Companion's combat power adds to total
- Share rewards

---

## 💬 NPC Dialogue Examples

Dungeon Entrance Guard:
"지하 던전에 들어가시겠습니까?
3층까지는 초보자도 괜찮지만, 그 아래는...
진짜 위험합니다. 레벨 5는 되셔야..."

Floor 9 Rest Area Message (Inscribed on magic circle):
"이곳을 지나는 자여,
마왕 리리스는 악이 아니었다.
단지... 세상이 그녀를 받아들이지 못했을 뿐.
- 300년 전, 대마법사 아르카디우스"

Lilith (Floor 10 First Encounter):
"...살아있구나. 용케도.
300년 동안 수십 명이 왔지만,
여기까지 온 건 네가... 세 번째야.

싸울래, 아니면 얘기할래?"