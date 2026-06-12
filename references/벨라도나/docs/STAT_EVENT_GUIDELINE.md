# 초기 스탯/특성 결정 이벤트 가이드라인

## 목적
플레이어의 배경 스토리와 선택에 기반하여 초기 능력치와 특성을 결정하는 이벤트를 제작합니다.

---

## 시스템 개요

### 능력치 (Stats)
| Stat ID | 이름 | 설명 | 기본값 | 범위 |
|---------|------|------|--------|------|
| `str` | Strength (힘) | 물리적 전투력, 근력 | 50 | 0-100 |
| `int` | Intelligence (지능) | 마법력, 학습능력, 전략 | 50 | 0-100 |
| `dex` | Dexterity (민첩) | 손재주, 반사신경, 회피 | 50 | 0-100 |
| `cha` | Charisma (매력) | 사교성, 설득력, 인맥 | 50 | 0-100 |
| `luk` | Luck (운) | 확률, 크리티컬, 보상 | 50 | 0-100 |
| `vit` | Vitality (생명력) | HP, 체력, 지구력 | 50 | 0-100 |

**할당 원칙**:
- 초기 할당: 40-70 범위 (평범한 학생 기준)
- 총합 제한 없음 (배경에 맞게 자유롭게)
- 특출난 재능: 70-80
- 천재적 재능: 80-90
- 전설급 재능: 90-100

---

## 특성 (Traits) 시스템

### 특성 구조
```
[Trait:Name:Category:Effect:Value:Condition]
```

**필드 설명**:
- `Name`: 특성 이름 (예: Dragon_Slayer, Silver_Tongue)
- `Category`: 카테고리 (Combat, Social, Magic, Craft, Mental, Physical)
- `Effect`: 효과 타입 (damage_bonus, stat_boost, gold_bonus, exp_bonus, crit_chance)
- `Value`: 수치 (20 = +20%, 5 = +5 등)
- `Condition`: 발동 조건

### Condition 종류
- `always`: 항상 적용
- `vs_[target]`: 특정 대상 (vs_dragons, vs_undead, vs_nobles)
- `low_hp`: HP 30% 이하
- `high_hp`: HP 70% 이상
- `in_combat`: 전투 중
- `night_time`: 밤 시간
- `day_time`: 낮 시간
- `when_[상황]`: 특정 상황 (when_negotiating, when_crafting)

### 초기 특성 가이드
- 일반 학생: 특성 0-1개
- 특별한 배경: 특성 1-2개
- 귀족/특수 출신: 특성 2-3개

---

## 이벤트 구조 제안

### 1단계: 배경 선택
플레이어의 과거를 질문하여 기본 방향성 결정
- 어떤 가문 출신인가? (귀족/평민/특수)
- 어떤 교육을 받았는가?
- 특별한 재능이나 경험이 있는가?

### 2단계: 능력 테스트
구체적인 상황을 제시하여 능력치 결정
- **전투 시나리오** → STR, DEX, VIT
- **마법 수업** → INT
- **사교 모임** → CHA
- **위기 상황** → LUK

### 3단계: 특성 각성
특별한 경험이나 재능 확인
- 과거의 중요한 사건
- 타고난 재능
- 특수한 훈련

---

## 출력 형식

### 초기 스탯 설정 예시
```
[Stat:str:+15][Stat:int:+25][Stat:dex:+10][Stat:cha:+20][Stat:luk:+5][Stat:vit:+10]
```
→ 결과: STR 65, INT 75, DEX 60, CHA 70, LUK 55, VIT 60

### 특성 설정 예시
```
[Trait:Noble_Blood:Social:persuasion_bonus:15:when_negotiating]
[Trait:Combat_Prodigy:Combat:damage_bonus:20:always]
[Trait:Lucky_Star:Mental:crit_chance:10:always]
```

---

## 예시 시나리오

### 예시 1: 귀족 마법사
**배경**: 명문 마법 가문 출신, 어린 시절부터 엘리트 교육

**능력치**:
```
[Stat:str:-5][Stat:int:+30][Stat:dex:+5][Stat:cha:+15][Stat:luk:+10][Stat:vit:-10]
```
→ STR 45, INT 80, DEX 55, CHA 65, LUK 60, VIT 40

**특성**:
```
[Trait:Arcane_Prodigy:Magic:spell_power:25:always]
[Trait:Noble_Etiquette:Social:persuasion_bonus:15:vs_nobles]
```

### 예시 2: 전사 출신 전학생
**배경**: 용병 가문, 실전 경험 풍부, 학문은 부족

**능력치**:
```
[Stat:str:+25][Stat:int:-10][Stat:dex:+20][Stat:cha:+5][Stat:luk:+0][Stat:vit:+20]
```
→ STR 75, INT 40, DEX 70, CHA 55, LUK 50, VIT 70

**특성**:
```
[Trait:Battle_Hardened:Combat:damage_bonus:15:in_combat]
[Trait:Survivor:Physical:stat_boost:10:low_hp]
```

### 예시 3: 평범한 학생
**배경**: 일반 상인 집안, 특별한 재능 없음

**능력치**:
```
[Stat:str:+0][Stat:int:+5][Stat:dex:+5][Stat:cha:+10][Stat:luk:+5][Stat:vit:+0]
```
→ 모두 50-60 범위 (평범)

**특성**:
```
[Trait:Merchant_Instinct:Social:gold_bonus:10:always]
```

---

## Claude 공홈 사용 팁

### 프롬프트 구조
```
나는 Belladonna Academy RPG의 캐릭터 생성 이벤트를 진행하려고 합니다.

[시스템 정보 붙여넣기]

플레이어에게 질문을 통해 배경을 파악하고,
최종적으로 다음 형식의 태그를 출력해주세요:

[Stat:stat_id:±value]
[Trait:Name:Category:Effect:Value:Condition]

대화형으로 진행해주세요.
```

### 진행 방식
1. **Claude가 질문** → 플레이어가 답변
2. **3-5개 질문 후** → 능력치/특성 제안
3. **플레이어 확인** → 최종 태그 출력
4. **태그를 복사** → RisuAI Lua 트리거로 적용

---

## RisuAI 적용 방법

생성된 태그를 RisuAI의 치트 명령어나 수동 입력으로 적용:

### 방법 1: 채팅에 직접 입력
```
/stat_init [Stat:str:+20][Stat:int:+15]...[Trait:...]
```

### 방법 2: Lua 트리거 제작
```lua
-- 치트 명령어: /init_stats
registerSlashCommand(triggerId, "init_stats", function(data)
    local tags = "[Stat:str:+20][Stat:int:+15]..." -- Claude 출력 복붙
    parseStatusWindow(triggerId, tags)
end)
```

---

## 밸런스 가이드

### 일반적인 총합
- **평범한 학생**: 총합 300 (각 50)
- **우수한 학생**: 총합 360-390 (평균 60-65)
- **특출난 재능**: 총합 420-450 (한 분야 80+)
- **천재형**: 총합 480+ (여러 분야 70+)

### 특성 밸런스
- **약한 특성**: Value 5-10, 조건부
- **중간 특성**: Value 15-20, 상시 또는 조건부
- **강한 특성**: Value 25-30, 까다로운 조건부
- **전설 특성**: Value 35+, 매우 제한적

---

## 주의사항

1. **스토리 중심**: 숫자보다 배경 스토리가 우선
2. **약점 포함**: 완벽한 캐릭터보다 개성 있는 캐릭터
3. **성장 여지**: 초반에 너무 강하면 성장 재미 감소
4. **테마 일치**: Belladonna Academy 세계관과 어울리는 설정

---

## 다음 단계

1. Claude 공홈에서 대화형 이벤트 진행
2. 생성된 태그 복사
3. RisuAI에서 적용
4. 게임 시작!
