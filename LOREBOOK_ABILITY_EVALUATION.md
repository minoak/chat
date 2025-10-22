# 능력평가 로어북 - 수정된 버전

## ⚙️ 로어북 설정

### 기본 정보
- **이름**: `RPG_능력평가_이벤트`
- **Order**: 100 (높은 우선순위)
- **Keywords**: (비워두거나 "능력평가", "능력판정실")

---

## 📋 Activation 조건

### 옵션 1: Script 조건 (가장 확실) ⭐ 추천

```javascript
// RisuAI 스크립트 조건
const enabled = risuChatVar.rpg_system_enabled === "true";
const evaluated = risuChatVar.rpg_stats_evaluated === "true";
return enabled && !evaluated;
```

### 옵션 2: 템플릿 조건 (RisuAI 버전에 따라)

```handlebars
{{#if rpg_system_enabled}}
{{#unless rpg_stats_evaluated}}
true
{{/unless}}
{{/if}}
```

### 옵션 3: 항상 활성화 + 내용 내부에서 조건 체크

Activation: (비워두기)

Content 첫 줄에서 조건 체크:
```handlebars
{{#if rpg_system_enabled}}
{{#unless rpg_stats_evaluated}}
... (이벤트 내용)
{{/unless}}
{{/if}}
```

---

## 📝 Content (로어북 내용)

```handlebars
## 🎯 능력평가 이벤트

### [AI 지시사항]
{{user}}가 **능력판정실에 방문**하거나, **능력평가 관련 언급**을 할 때 이 이벤트를 자연스럽게 진행하세요.

---

### 📍 능력판정실 위치
- 학생회실 건물 1층
- 담당: Celestia von Silvercrown (학생회장)
- 중앙에 투명한 수정구 배치

---

### 이벤트 진행 순서

#### 1단계: 도착
{{user}}가 능력판정실에 들어서면:

Celestia가 클립보드를 들고 기다리고 있다.

"오셨군요. 필수 능력평가를 시작하겠습니다. 손을 수정구 위에 올려주세요."

---

#### 2단계: AI 능력치 분석

**[AI 전용 평가 프로세스]**

{{user}}의 페르소나를 분석하여 6가지 능력치를 결정하세요.

**분석 기준:**
- 배경 설정에서 힌트 찾기 (귀족/평민, 전투/마법 경험 등)
- 특별한 언급 없으면 평범한 학생으로 간주
- 범위: -10 ~ +40 (기본값 50에서 증감)

**능력치별 판단:**

1. **STR (힘)** - 물리 전투력, 근력
   - 전투/무술/운동 배경 → +15 ~ +25
   - 평범 → +0 ~ +10
   - 약함/마법사형 → -5 ~ +5

2. **INT (지능)** - 마법력, 학습, 전략
   - 마법사/학자 배경 → +15 ~ +30
   - 평범 → +0 ~ +10
   - 무식한 전사형 → -5 ~ +5

3. **DEX (민첩)** - 손재주, 반사신경, 회피
   - 도적/암살자/궁수 → +15 ~ +25
   - 평범 → +0 ~ +10
   - 둔함 → -5 ~ +5

4. **CHA (매력)** - 사교성, 설득력, 인맥
   - 귀족/사교계/연예인 → +15 ~ +25
   - 평범 → +0 ~ +10
   - 음침/사회부적응 → -5 ~ +5

5. **LUK (운)** - 확률, 크리티컬
   - 행운아 설정 → +15 ~ +25
   - 평범 → +0 ~ +10
   - 불운 설정 → -5 ~ +5

6. **VIT (생명력)** - HP, 체력, 지구력
   - 전사/운동선수 → +15 ~ +25
   - 평범 → +0 ~ +10
   - 허약/마법사형 → -5 ~ +5

---

#### 3단계: 측정 연출

수정구가 점점 밝게 빛나기 시작한다.
{{user}}의 손끝에서 마력이 흐르며, 허공에 숫자들이 하나씩 새겨진다.

```
STR: 50 → [최종값]
INT: 50 → [최종값]
DEX: 50 → [최종값]
CHA: 50 → [최종값]
LUK: 50 → [최종값]
VIT: 50 → [최종값]
```

빛이 사라지고, Celestia가 기록을 확인한다.

---

#### 4단계: 결과 분석 & 반응

**Celestia의 코멘트:**

- 대부분 평범 (45-55) → "평균적인 능력치네요. 무난합니다."
- 한 분야 70 이상 → "이 수치는... [분야] 방면으로 재능이 있군요."
- 한 분야 30 이하 → "음... [분야]는 좀 약하네요. 훈련이 필요할 듯 합니다."
- 전체적으로 높음 → "...예상 밖입니다. 숨은 재능이 있으시군요."
- 전체적으로 낮음 → "페이퍼보단 실물이... 뭐, 노력하면 됩니다."

"이것이 당신의 공식 능력치입니다. 기록에 등재됩니다."

---

#### 5단계: 태그 출력 (필수!)

**[AI: 반드시 다음 형식으로 태그를 출력하세요]**

```
[Stat:str:±X][Stat:int:±X][Stat:dex:±X][Stat:cha:±X][Stat:luk:±X][Stat:vit:±X]
[StatsEvaluated]
```

**예시:**
```
[Stat:str:+15][Stat:int:+20][Stat:dex:+10][Stat:cha:+5][Stat:luk:+8][Stat:vit:+12]
[StatsEvaluated]
```

---

#### 선택사항: 특성 부여

{{user}}의 페르소나에 **특별한 재능/경험**이 명확하다면 특성 1개 추가:

```
[Trait:특성명:카테고리:효과타입:수치:조건]
```

**카테고리**: Combat, Social, Magic, Craft, Mental, Physical
**효과**: damage_bonus, stat_boost, gold_bonus, exp_bonus, crit_chance
**조건**: always, vs_dragons, in_combat, low_hp 등

**예시:**
```
[Trait:Combat_Veteran:Combat:damage_bonus:15:always]
[Trait:Noble_Blood:Social:persuasion_bonus:10:vs_nobles]
[Trait:Arcane_Prodigy:Magic:spell_power:20:always]
```

---

## 🎮 테스트 방법

1. `/rpg on` - RPG 시스템 활성화
2. `/rpg status` - 상태 확인 (evaluated: false 확인)
3. 대화 시작 → "능력판정실에 간다" 입력
4. AI가 이벤트 진행
5. 태그 출력되면 자동으로 능력치 적용
6. `/status` - 능력치 확인
7. `/rpg status` - evaluated: true 확인

---

## 💡 추가 팁

### 이벤트 자연스럽게 시작하기

**방법 1: 직접 방문**
```
{{user}}: "능력판정실에 가본다"
→ 즉시 이벤트 시작
```

**방법 2: NPC가 유도**
```
Mirabel: "너 아직 능력평가 안 받았어?
학생회실 건물 1층에 있어. Celestia한테 가봐."
```

**방법 3: 알림 받기**
```
*buzz* 휴대폰에 알림이 온다.

[학생회 공지]
"{{user}} 학생, 필수 능력평가 미완료.
능력판정실로 오시기 바랍니다."
```

---

## 🔧 문제 해결

### Q1. 로어북이 작동하지 않아요
- `/rpg status`로 `rpg_system_enabled`가 `true`인지 확인
- `rpg_stats_evaluated`가 `false`인지 확인
- Activation 조건이 RisuAI 버전과 맞는지 확인

### Q2. 태그가 적용 안 돼요
- 태그 형식 확인: `[Stat:str:+20]` (부호 필수!)
- 로그 확인: "✅ 능력평가 완료" 메시지 확인
- `/status`로 실제 능력치 확인

### Q3. 이벤트가 계속 반복돼요
- `[StatsEvaluated]` 태그가 출력되었는지 확인
- `/rpg status`로 evaluated 상태 확인
- 수동으로 설정: 치트 명령어로 직접 변경 가능

### Q4. 능력치를 리셋하고 싶어요
```lua
-- 콘솔이나 치트로 실행
setChatVar(triggerId, "rpg_stats_evaluated", "false")
```
그 다음 능력판정실 다시 방문

---

## 📊 예시 시나리오

### 예시 1: 평범한 학생
```
페르소나: 일반 학생, 특별한 배경 없음

측정 결과:
[Stat:str:+5][Stat:int:+8][Stat:dex:+5][Stat:cha:+10][Stat:luk:+3][Stat:vit:+5]
[StatsEvaluated]

Celestia: "평균적인 능력치네요. 무난합니다."
```

### 예시 2: 전직 용병
```
페르소나: 전직 용병, 실전 경험 풍부, 학문 부족

측정 결과:
[Stat:str:+22][Stat:int:-5][Stat:dex:+18][Stat:cha:+5][Stat:luk:+8][Stat:vit:+20]
[Trait:Battle_Hardened:Combat:damage_bonus:15:in_combat]
[StatsEvaluated]

Celestia: "...전투 방면 수치가 상당히 높군요.
반면 지능 지수는... 뭐, 노력하면 됩니다."
```

### 예시 3: 귀족 마법사
```
페르소나: 명문 귀족, 마법 영재, 운동 안 함

측정 결과:
[Stat:str:-8][Stat:int:+28][Stat:dex:+5][Stat:cha:+18][Stat:luk:+12][Stat:vit:-5]
[Trait:Arcane_Prodigy:Magic:spell_power:20:always]
[Trait:Noble_Blood:Social:persuasion_bonus:10:vs_nobles]
[StatsEvaluated]

Celestia: "지능과 마법 적성이... 천재급입니다.
다만 체력은 좀 단련이 필요하겠네요."
```

---

## ✅ 체크리스트

- [ ] Activation 조건 설정 완료
- [ ] 로어북 Order 우선순위 높게 설정
- [ ] `/rpg on` 실행
- [ ] `/rpg status`로 enabled=true, evaluated=false 확인
- [ ] 능력판정실 방문 시나리오 테스트
- [ ] 태그 출력 확인
- [ ] `/status`로 능력치 적용 확인
- [ ] 이벤트 반복 안 되는지 확인
