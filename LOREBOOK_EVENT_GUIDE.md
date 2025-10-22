# 로어북 RPG 초기화 이벤트 가이드

## 개요

로어북을 사용하여 RPG 시스템 초기화 이벤트를 자동으로 진행하는 방법입니다.

**작동 원리**:
1. 사용자가 `/rpg on`으로 RPG 시스템 활성화
2. 로어북이 "활성화 O + 초기화 X" 상태 감지
3. 로어북 내용이 AI 응답에 삽입되어 초기화 이벤트 진행
4. 이벤트 완료 시 `[InitComplete]` 태그 출력
5. Lua가 태그 감지하여 `rpg_initialized = "true"` 설정
6. 다음 턴부터 로어북 비활성화 (이미 초기화됨)

---

## 로어북 설정

### 기본 설정
- **이름**: `RPG_초기화_이벤트` (또는 원하는 이름)
- **Order**: 높은 우선순위 (예: 100)
- **Insertion**: `In Prompt` 또는 `Author's Note`

### 활성화 조건 (Conditional)

RisuAI 로어북의 조건부 활성화 기능을 사용합니다.

#### 옵션 1: 스크립트 조건 사용
```javascript
// 스크립트 조건이 지원되는 경우
return (
  risuChatVar.rpg_system_enabled === "true" &&
  risuChatVar.rpg_initialized !== "true"
);
```

#### 옵션 2: 변수 체크 (RisuAI 문법)
```
{{#if rpg_system_enabled}}
  {{#unless rpg_initialized}}
    [이벤트 내용]
  {{/unless}}
{{/if}}
```

**참고**: RisuAI 버전에 따라 지원되는 조건문 방식이 다를 수 있습니다. 위 방법이 작동하지 않으면 "항상 활성화" + 이벤트 내용 첫 줄에 조건 체크를 넣는 방식을 사용하세요.

---

## 로어북 이벤트 내용 예시

### 예시 1: 간단한 질문 방식

```
{{#if rpg_system_enabled}}{{#unless rpg_initialized}}
---
🎓 **Belladonna Academy 입학 심사**

입학 담당관이 {{user}}를 살펴보며 질문을 시작했다.

"자네의 배경에 대해 들려주게. 어떤 가문 출신인가?"

[선택지]
1. 명문 귀족 가문 출신
2. 평범한 평민 가정
3. 특수한 배경 (상인, 용병, 기타)

"그리고 자네가 가장 자신 있는 분야는?"

[선택지]
1. 마법과 학문 (INT 중심)
2. 전투와 무술 (STR/DEX 중심)
3. 사교와 협상 (CHA 중심)
4. 균형잡힌 만능형

**시스템 안내**: 다음 응답에서 선택지를 골라 대답하면, 그에 맞는 능력치가 부여됩니다.
{{/unless}}{{/if}}
```

### 예시 2: 자동 분석 방식

```
{{#if rpg_system_enabled}}{{#unless rpg_initialized}}
---
🎓 **Belladonna Academy 입학 심사 - 자동 평가**

입학 담당관이 {{user}}의 서류와 면담 내용을 바탕으로 능력치를 평가했다.

**[AI: {{user}}의 페르소나를 분석하여 아래 형식으로 능력치를 부여하세요]**

평가 기준:
- 배경 설정에서 귀족/특수 출신 → CHA/INT 높음
- 전투/무술 경험 언급 → STR/DEX 높음
- 마법/학문 재능 → INT 높음
- 특별한 언급 없음 → 모든 능력치 50 (평범)

능력치 범위: 40-70 (기본), 70-90 (특출남)

**[능력치 부여 예시]**
- 평범한 학생: [Stat:str:+0][Stat:int:+5][Stat:dex:+0][Stat:cha:+5][Stat:luk:+0][Stat:vit:+0]
- 귀족 마법사: [Stat:str:-5][Stat:int:+30][Stat:dex:+5][Stat:cha:+15][Stat:luk:+10][Stat:vit:-10]
- 전사 출신: [Stat:str:+25][Stat:int:-10][Stat:dex:+20][Stat:cha:+5][Stat:luk:+0][Stat:vit:+20]

**[초기 특성 예시]** (선택적)
- 귀족: [Trait:Noble_Blood:Social:persuasion_bonus:15:when_negotiating]
- 전사: [Trait:Battle_Hardened:Combat:damage_bonus:15:in_combat]
- 학자: [Trait:Arcane_Prodigy:Magic:spell_power:20:always]

**[필수] 평가 완료 후 반드시 다음 태그를 포함하세요:**
[InitComplete]

---
입학 심사가 완료되었습니다. {{user}}의 능력이 기록되었습니다.
{{/unless}}{{/if}}
```

### 예시 3: 대화형 다턴 이벤트

```
{{#if rpg_system_enabled}}{{#unless rpg_initialized}}
---
🎓 **Belladonna Academy 입학 심사 - 1단계**

입학 담당관 **Instructor Maven**이 {{user}}를 맞이했다.

"환영하네, 신입생. 먼저 자네의 배경부터 듣고 싶군."

**[AI 지시사항]**:
- {{user}}가 배경을 설명하면 2-3턴에 걸쳐 질문
- 전투 실력, 마법 재능, 사교 능력 각각 테스트
- 3-4턴 후 종합 평가하여 능력치 부여
- 마지막 턴에 능력치 태그 + [InitComplete] 출력

**턴 카운트**: 이 로어북은 rpg_initialized가 false일 때만 활성화되므로,
[InitComplete]를 출력하기 전까지는 계속 활성 상태입니다.
{{/unless}}{{/if}}
```

---

## 능력치/특성 태그 형식

### 능력치 태그
```
[Stat:stat_id:±value]
```

**예시**:
```
[Stat:str:+20][Stat:int:+15][Stat:dex:+10][Stat:cha:+25][Stat:luk:+5][Stat:vit:+15]
```
→ STR 70, INT 65, DEX 60, CHA 75, LUK 55, VIT 65

### 특성 태그
```
[Trait:Name:Category:Effect:Value:Condition]
```

**예시**:
```
[Trait:Silver_Tongue:Social:persuasion_bonus:20:when_negotiating]
[Trait:Quick_Learner:Mental:exp_bonus:15:always]
[Trait:Lucky_Star:Mental:crit_chance:10:always]
```

### 완료 태그 (필수!)
```
[InitComplete]
```

**중요**: 이벤트가 완전히 끝났을 때만 `[InitComplete]`를 출력하세요. 이 태그가 출력되면 로어북이 비활성화됩니다.

---

## AI 프롬프트 가이드

로어북 내용에 AI 지시사항을 포함하면 더 나은 결과를 얻을 수 있습니다:

```
**[AI 지시사항: RPG 초기화 이벤트]**

1. {{user}}의 페르소나를 분석하세요
   - 귀족/특수 배경 → CHA, INT 높음
   - 전투/무술 경험 → STR, DEX 높음
   - 마법/학문 재능 → INT 높음
   - 평범한 배경 → 모든 스탯 50 전후

2. 능력치 할당 (기본 50, 범위 0-100)
   - 평범: 40-60
   - 우수: 60-70
   - 특출: 70-85
   - 천재: 85-95

3. 특성 부여 (0-2개)
   - 특별한 배경/재능이 있을 때만
   - 형식: [Trait:Name:Category:Effect:Value:Condition]

4. **필수**: 평가 완료 시 반드시 다음 태그들을 모두 출력
   [Stat:str:±X][Stat:int:±X]...[InitComplete]

5. 태그는 보이지 않게 처리됩니다. 자연스러운 서술과 함께 출력하세요.
```

---

## 테스트 방법

1. **RPG 시스템 활성화**
   ```
   /rpg on
   ```

2. **상태 확인**
   ```
   /rpg status
   ```
   → "활성화: ✅ ON" / "초기화: ⏳ 미완료" 확인

3. **대화 시작**
   - 아무 메시지나 입력
   - 로어북 이벤트가 자동으로 시작됨

4. **이벤트 진행**
   - AI의 질문에 답변
   - 능력치 태그가 출력될 때까지 진행

5. **완료 확인**
   ```
   /rpg status
   ```
   → "초기화: ✅ 완료" 확인

6. **스탯 확인**
   ```
   /status
   ```
   → 플레이어 RPG 섹션에서 능력치 확인

---

## 문제 해결

### Q1. 로어북이 활성화되지 않아요
- `/rpg status`로 RPG 시스템이 ON인지 확인
- 로어북 조건문이 올바른지 확인
- RisuAI 버전에 따라 조건문 문법이 다를 수 있음

### Q2. 이벤트가 계속 반복돼요
- `[InitComplete]` 태그가 제대로 출력되었는지 확인
- 로그에서 "✅ RPG 초기화 완료 (로어북 이벤트)" 메시지 확인
- `/rpg status`로 초기화 상태 확인

### Q3. 능력치가 적용되지 않아요
- 태그 형식이 정확한지 확인: `[Stat:str:+20]`
- 부호(+/-)가 포함되어 있는지 확인
- `/status`로 실제 능력치 확인

### Q4. 로어북 없이 수동으로 하고 싶어요
- 채팅에 직접 태그 입력:
  ```
  [Stat:str:+20][Stat:int:+15]...[InitComplete]
  ```
- 또는 `/rpg reset` 후 다시 이벤트 진행

---

## 고급 팁

### 다단계 이벤트
여러 로어북을 순차적으로 활성화하여 복잡한 이벤트 체인 구성:

```
로어북 1: rpg_initialized != "true" → 1단계 이벤트 → [Stage1Complete]
로어북 2: stage1_complete == "true" AND rpg_initialized != "true" → 2단계 이벤트
로어북 3: stage2_complete == "true" AND rpg_initialized != "true" → 최종 평가 → [InitComplete]
```

### 커스텀 태그 추가
Lua 파싱 함수에 새로운 태그 추가 가능:

```lua
-- belladonna_academy_rpg.lua에 추가
if message:find("%[CustomTag%]") then
    -- 원하는 동작
end
```

### 조건부 특성 부여
페르소나 키워드 기반 자동 특성:

```
**[AI 지시사항]**:
{{user}} 페르소나에서 키워드 탐지:
- "귀족" → [Trait:Noble_Blood:Social:persuasion_bonus:15:vs_nobles]
- "용병" → [Trait:Battle_Hardened:Combat:damage_bonus:15:in_combat]
- "마법사" → [Trait:Arcane_Prodigy:Magic:spell_power:20:always]
```

---

## 참고

- 능력치 시스템 상세: `STAT_EVENT_GUIDELINE.md`
- Lua 스크립트: `belladonna_academy_rpg.lua`
- HTML 패널: `rpg_status_panel.html`
