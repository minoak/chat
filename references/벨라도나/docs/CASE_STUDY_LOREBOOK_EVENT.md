# 사례 연구: 로어북 이벤트 비활성화 문제

## 요약

**프로젝트:** Belladonna Academy RPG System
**문제:** [StatsEvaluated] 태그가 출력된 후에도 능력평가 로어북이 비활성화되지 않음
**증상:** 로어북이 계속 500토큰 출력 (level = 0으로 계속 읽힘)
**소요 시간:** 2일
**근본 원인:** `restoreRpgSnapshot()` 함수에서 `setState()` 호출 누락
**날짜:** 2025-10-24

---

## 문제 상황

### 요구사항

능력평가 로어북 이벤트 시스템 구현:
1. 초기 상태: `player_level = 0` → 로어북 활성화 (500토큰)
2. AI가 능력평가 진행 후 `[StatsEvaluated]` 태그 출력
3. Lua가 태그 파싱 → `player_level = 1` 설정
4. 다음 턴: 로어북 비활성화 (0토큰)

### 실제 증상

```
턴 1: player_level = 0 → 로어북 500토큰 ✅
턴 2: [StatsEvaluated] 태그 출력 ✅
턴 3: player_level = 0 → 로어북 500토큰 ❌ (여전히 0!)
```

**핵심 단서:** "계속 500토큰이 출력됨" = Content의 `{{#if_pure {{equal::{{getvar::player_level}}::0}}}}` 조건이 계속 true

---

## 시도한 해결 방법들 (모두 실패)

### 시도 1: setState() 누락 의심 (부분적 성공)

**가설:** [StatsEvaluated] 파싱 시 `setState()` 호출 누락

**조치:**
```lua
// 기존
setChatVar(triggerId, "ability_eval_status", "1")

// 수정
setState(triggerId, "ability_eval_status", 1)
setChatVar(triggerId, "ability_eval_status", "1")
```

**결과:** 여전히 실패

---

### 시도 2: ability_eval_status 변수 추가 (불필요한 작업)

**가설:** player_level 대신 별도 플래그 변수 필요

**조치:**
- `ability_eval_status` 변수 추가
- 초기화, 파싱, 문서 모두 수정

**결과:** 여전히 실패. **이 변수는 완전히 불필요했음**

---

### 시도 3: 초기화 조건 변경 (표면적 수정)

**가설:** 초기화 조건문이 잘못됨

**조치:**
```lua
// 기존
if not getChatVar(triggerId, "player_level") then

// 수정
if getState(triggerId, "player_level") == nil then
```

**결과:** 개선되었으나 여전히 실패

---

### 시도 4: 로어북 Activation Script 수정 (잘못된 이해)

**가설:** Activation Script에서 조건 체크해야 함

**조치:**
```javascript
// 시도한 것
const level = parseInt(risuChatVar.player_level) || 0;
return enabled && level === 0;
```

**결과:** **로어북 작동 방식을 완전히 오해함**
- Activation Script = 로어북 활성화 여부
- Content `{{#if_pure}}` = 토큰 출력 제어
- **두 개념을 혼동함**

---

### 시도 5: 로어북 Content에서 if_pure 제거 (완전히 잘못됨)

**조치:** Content의 `{{#if_pure}}` 조건문 제거

**결과:** **토큰 제어를 없애버림** → 완전히 반대 방향

---

## 진짜 원인 발견

### 근본 원인

**`restoreRpgSnapshot()` 함수에서 `setState()` 호출이 전혀 없었음**

```lua
function restoreRpgSnapshot(triggerId)
    // 기존 (문제)
    setChatVar(triggerId, "player_level", level)
    // setState() 없음!

    // 수정 (해결)
    setChatVar(triggerId, "player_level", level)
    setState(triggerId, "player_level", tonumber(level))  // ✅
end
```

### 왜 이게 문제였나

```
1. [StatsEvaluated] 파싱
   → setState(player_level, 1) ✅
   → setChatVar(player_level, "1") ✅
   → 스냅샷 업데이트 ✅

2. 다음 턴 시작: restoreRpgSnapshot() 호출
   → ChatVar 복원: player_level = "1" ✅
   → State 복원: 호출 안 됨! ❌

3. 로어북이 읽는 값
   → {{getvar::player_level}} = getState()를 읽음
   → State는 초기화 때 0으로 설정된 상태 그대로!
   → 500토큰 계속 출력
```

---

## 최종 해결 방법

### 1. restoreRpgSnapshot() 수정

**모든 변수 복원 시 setState() + setChatVar() 둘 다 호출:**

```lua
function restoreRpgSnapshot(triggerId)
    -- Player Stats
    for _, stat in ipairs(playerStats) do
        local key = "player_" .. stat
        local snapshotValue = getChatVar(triggerId, "snapshot_" .. key) or tostring(STAT_DEFAULT)
        setChatVar(triggerId, key, snapshotValue)
        setState(triggerId, key, tonumber(snapshotValue))  // ✅ 추가
    end

    -- Gold, EXP, Level
    local level = getChatVar(triggerId, "snapshot_player_level") or "0"
    setChatVar(triggerId, "player_level", level)
    setState(triggerId, "player_level", tonumber(level))  // ✅ 추가

    // ... 모든 변수에 동일하게 적용
end
```

### 2. 로어북 설정

**Activation Script (항상 true):**
```javascript
return risuChatVar.rpg_system_enabled === "true";
```

**Content (if_pure로 토큰 제어):**
```handlebars
{{#if_pure {{equal::{{getvar::player_level}}::0}}}}
(내용 - 500토큰)
{{/if_pure}}
```

---

## 핵심 교훈

### 1. RisuAI의 두 가지 변수 시스템

| 시스템 | 저장 함수 | 읽기 함수 | 로어북 접근 | 용도 |
|--------|----------|----------|-------------|------|
| **ChatVar** | setChatVar() | getChatVar() | ❌ 불가 | 내부 저장 |
| **State** | setState() | getState() | ✅ 가능 (`{{getvar::}}`) | 로어북 노출 |

**필수 규칙:**
- **변수 변경 시 항상 둘 다 호출**
- 초기화: setState() + setChatVar()
- 업데이트: setState() + setChatVar()
- **스냅샷 복원: setState() + setChatVar()**

### 2. 로어북 작동 방식

| 요소 | 역할 | 시점 |
|------|------|------|
| **Activation Script** | 로어북 활성화 여부 | 매 턴 체크 |
| **Content `{{#if_pure}}`** | 토큰 출력 제어 | 활성화 시 실행 |

**잘못된 이해:**
- ❌ Activation Script에서 조건 체크 → Content는 무조건 출력

**올바른 이해:**
- ✅ Activation Script는 단순 활성화
- ✅ Content의 `{{#if_pure}}`가 조건부 출력 (0토큰 vs 500토큰)

### 3. 문제 해결 접근법

**잘못된 접근:**
1. 증상만 보고 추측
2. 새 변수 추가 (ability_eval_status)
3. 문서 수정
4. 시스템 이해 없이 코드 변경

**올바른 접근:**
1. **핵심 단서 파악** ("500토큰 계속 출력" = getvar::player_level이 0)
2. **변수 흐름 추적** (초기화 → 파싱 → 스냅샷 → 복원)
3. **근본 원인 찾기** (restoreRpgSnapshot에 setState 없음)
4. **최소 변경으로 해결**

---

## 체크리스트: 로어북 이벤트 시스템 구현

새로운 로어북 이벤트를 추가할 때 확인해야 할 사항:

### 변수 관리
- [ ] 초기화: `setState()` + `setChatVar()` 둘 다 호출
- [ ] 태그 파싱: `setState()` + `setChatVar()` 둘 다 호출
- [ ] 스냅샷 저장: `takeRpgSnapshot()`에 변수 추가
- [ ] 스냅샷 복원: `restoreRpgSnapshot()`에서 `setState()` + `setChatVar()` 둘 다 호출
- [ ] 스냅샷 즉시 업데이트: 태그 파싱 시 `snapshot_변수명` 즉시 갱신

### 로어북 설정
- [ ] Activation Script: 간단한 활성화 조건만 (예: `rpg_system_enabled === "true"`)
- [ ] Content: `{{#if_pure}}` 조건으로 토큰 출력 제어
- [ ] Content 조건: `{{equal::{{getvar::변수명}}::값}}` 형식 사용
- [ ] 태그 출력: AI가 특정 태그 출력하도록 지시 (예: `[StatsEvaluated]`)

### 테스트
- [ ] 초기화 확인: 변수 값이 State와 ChatVar 모두에 설정됨
- [ ] 태그 파싱 확인: 태그 출력 시 변수가 변경됨
- [ ] 스냅샷 복원 확인: 다음 턴에도 변경된 값 유지됨
- [ ] 로어북 비활성화 확인: 조건 만족 시 0토큰 출력

---

## 참고 코드

### 완전한 변수 관리 패턴

```lua
-- 1. 초기화
if getState(triggerId, "event_status") == nil then
    setState(triggerId, "event_status", 0)
    setChatVar(triggerId, "event_status", "0")
end

-- 2. 태그 파싱
if message:find("%[EventComplete%]") then
    setState(triggerId, "event_status", 1)
    setChatVar(triggerId, "event_status", "1")

    -- 스냅샷 즉시 업데이트
    setChatVar(triggerId, "snapshot_event_status", "1")
end

-- 3. 스냅샷 저장
function takeRpgSnapshot(triggerId)
    -- ... 기존 코드 ...
    setChatVar(triggerId, "snapshot_event_status",
               getChatVar(triggerId, "event_status") or "0")
end

-- 4. 스냅샷 복원
function restoreRpgSnapshot(triggerId)
    -- ... 기존 코드 ...
    local eventStatus = getChatVar(triggerId, "snapshot_event_status") or "0"
    setChatVar(triggerId, "event_status", eventStatus)
    setState(triggerId, "event_status", tonumber(eventStatus))
end
```

### 로어북 설정

**Activation Script:**
```javascript
return risuChatVar.rpg_system_enabled === "true";
```

**Content:**
```handlebars
{{#if_pure {{equal::{{getvar::event_status}}::0}}}}

@@depth 0

# 이벤트 내용

...

출력할 태그: [EventComplete]

{{/if_pure}}
```

---

## 결론

**2일이 걸린 이유:**
1. 로어북 작동 방식 오해 (Activation vs Content)
2. 핵심 단서 무시 ("500토큰")
3. 근본 원인 대신 증상만 수정
4. setState() 호출을 여러 곳에서 누락

**진짜 문제:**
- `restoreRpgSnapshot()`에서 `setState()` 호출 단 한 줄 누락

**얻은 교훈:**
- 시스템 전체를 먼저 이해하라
- 사용자의 단서를 정확히 분석하라
- 근본 원인을 찾아라
- setState()와 setChatVar()는 항상 함께

---

**최종 커밋:** `20c9513` - CORRECT FIX: Use if_pure in Content to control token output
**작성일:** 2025-10-24
