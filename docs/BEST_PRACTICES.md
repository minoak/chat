# RisuAI Lua 스크립팅 베스트 프랙티스

이 문서는 RisuAI에서 Lua 스크립트를 작성할 때 따라야 할 모범 사례를 정리한 것입니다. 실제 프로젝트에서 발생한 버그와 그 해결 과정을 통해 얻은 교훈을 바탕으로 작성되었습니다.

## 목차
1. [변수 초기화 패턴](#변수-초기화-패턴)
2. [변수 관리 시스템](#변수-관리-시스템)
3. [스냅샷과 리롤 방지](#스냅샷과-리롤-방지)
4. [디버깅 전략](#디버깅-전략)
5. [일반적인 실수와 해결법](#일반적인-실수와-해결법)

---

## 변수 초기화 패턴

### ❌ 잘못된 방법: 무조건 초기화

```lua
function onStart(e)
    local triggerId = e.scriptId

    -- 잘못된 예: 매번 변수를 0으로 리셋
    setChatVar(triggerId, "player_level", "0")
    setState(triggerId, "player_level", 0)
    setChatVar(triggerId, "player_exp", "0")
    setState(triggerId, "player_exp", 0)
end
```

**문제점:**
- `onStart()`는 대화를 시작할 때마다 호출됩니다
- 이전에 저장된 값이 있어도 무조건 0으로 덮어씁니다
- 결과: 다음 대화로 넘어갈 때마다 모든 진행 상황이 초기화됩니다

### ✅ 올바른 방법: 조건부 초기화

```lua
function onStart(e)
    local triggerId = e.scriptId

    -- 올바른 예: 값이 없을 때만 초기화
    if getState(triggerId, "player_level") == nil then
        log("🎮 첫 시작: RPG 시스템 초기화")

        setChatVar(triggerId, "player_level", "0")
        setState(triggerId, "player_level", 0)
        setChatVar(triggerId, "player_exp", "0")
        setState(triggerId, "player_exp", 0)

        log("✅ RPG 시스템 초기화 완료")
    else
        log("🎮 기존 데이터 유지 (레벨: " ..
            tostring(getState(triggerId, "player_level")) .. ")")
    end
end
```

**장점:**
- 첫 실행 시에만 초기화됩니다
- 기존 데이터가 있으면 보존됩니다
- 대화를 이어갈 때 진행 상황이 유지됩니다

### 패턴 템플릿

```lua
-- 단일 변수 초기화
if getState(triggerId, "variable_name") == nil then
    setState(triggerId, "variable_name", initial_value)
end

-- 여러 변수 초기화
if getState(triggerId, "initialization_flag") == nil then
    -- 모든 관련 변수 초기화
    setState(triggerId, "var1", value1)
    setState(triggerId, "var2", value2)
    setState(triggerId, "var3", value3)

    -- 초기화 완료 플래그 설정
    setState(triggerId, "initialization_flag", true)
end

-- 캐릭터별 변수 초기화 (배열)
local characters = {"char1", "char2", "char3"}
for _, char in ipairs(characters) do
    local key = char .. "_affection"
    if getState(triggerId, key) == nil then
        setState(triggerId, key, 0)
    end
end
```

---

## 변수 관리 시스템

RisuAI는 두 가지 변수 저장 시스템을 제공합니다:

### 1. ChatVar (내부 변수)

```lua
setChatVar(triggerId, "key", "value")  -- 저장
local value = getChatVar(triggerId, "key")  -- 읽기
```

**특징:**
- Lua 스크립트 내부에서만 접근 가능
- 문자열로 저장됨
- Lorebook에서 직접 접근 불가

**용도:**
- 내부 계산용 임시 값
- 복잡한 데이터 구조 (JSON 등)

### 2. State (외부 접근 가능 변수)

```lua
setState(triggerId, "key", value)  -- 저장
local value = getState(triggerId, "key")  -- 읽기
```

**특징:**
- Lorebook에서 `{{getvar::key}}` 형태로 접근 가능
- 숫자, 문자열 등 다양한 타입 저장 가능
- AI가 직접 참조할 수 있음

**용도:**
- AI에게 표시할 상태 정보
- Lorebook 조건 검사
- 게임 스탯, 레벨 등

### ⚠️ 중요: 두 시스템 모두 업데이트

변수를 변경할 때는 **반드시 두 시스템 모두** 업데이트해야 합니다:

```lua
function updatePlayerLevel(triggerId, newLevel)
    -- ChatVar 업데이트
    setChatVar(triggerId, "player_level", tostring(newLevel))

    -- State 업데이트 (Lorebook 접근용)
    setState(triggerId, "player_level", newLevel)

    log("레벨 업데이트: " .. newLevel)
end
```

**실제 사례:**
Belladonna Academy 프로젝트에서 `setState()` 호출을 누락하여 Lorebook이 업데이트된 스탯을 인식하지 못하는 문제가 발생했습니다. 모든 스탯 변경 함수에 `setState()` 호출을 추가하여 해결했습니다.

---

## 스냅샷과 리롤 방지

### 스냅샷의 필요성

사용자가 AI 응답을 리롤(재생성)하면:
1. 이전 응답이 삭제됨
2. 그 응답에서 변경된 변수들도 사라질 수 있음
3. 진행 상황이 손실될 위험

### 이중 스냅샷 패턴

```lua
function onStart(e)
    local triggerId = e.scriptId

    -- 턴 시작 시: 이전 턴의 최종 상태 복원
    restoreSnapshot(triggerId)

    -- ... 게임 로직 실행 ...
end

function onEndOfTurn(e)
    local triggerId = e.scriptId

    -- 턴 종료 시: 현재 상태 저장
    takeSnapshot(triggerId)
end
```

### 스냅샷 구현 예제

```lua
function takeSnapshot(triggerId)
    -- 현재 상태를 별도 키에 저장
    local current_level = getState(triggerId, "player_level")
    setState(triggerId, "player_level_snapshot", current_level)

    local current_exp = getState(triggerId, "player_exp")
    setState(triggerId, "player_exp_snapshot", current_exp)

    log("📸 스냅샷 저장: Lv" .. current_level .. ", EXP " .. current_exp)
end

function restoreSnapshot(triggerId)
    -- 스냅샷에서 복원
    local snapshot_level = getState(triggerId, "player_level_snapshot")
    if snapshot_level ~= nil then
        setState(triggerId, "player_level", snapshot_level)
        setChatVar(triggerId, "player_level", tostring(snapshot_level))
    end

    local snapshot_exp = getState(triggerId, "player_exp_snapshot")
    if snapshot_exp ~= nil then
        setState(triggerId, "player_exp", snapshot_exp)
        setChatVar(triggerId, "player_exp", tostring(snapshot_exp))
    end

    log("♻️ 스냅샷 복원: Lv" .. tostring(snapshot_level))
end
```

### 복잡한 데이터 스냅샷

배열이나 테이블은 JSON으로 직렬화하여 저장합니다:

```lua
function takeComplexSnapshot(triggerId)
    -- 배열 데이터
    local items = getChatVar(triggerId, "player_items")
    setState(triggerId, "player_items_snapshot", items)

    -- 테이블 데이터 (JSON 직렬화 필요)
    local stats = {
        strength = getState(triggerId, "strength"),
        agility = getState(triggerId, "agility"),
        intelligence = getState(triggerId, "intelligence")
    }

    -- JSON 라이브러리 사용
    local json = require("json")
    local statsJson = json.encode(stats)
    setState(triggerId, "stats_snapshot", statsJson)
end
```

---

## 디버깅 전략

### 1. 전략적 로그 배치

```lua
function onStart(e)
    log("🔧 DEBUG: onStart() 호출됨")

    local triggerId = e.scriptId

    -- 초기 상태 확인
    log("🔧 턴 시작 시 레벨: " .. tostring(getState(triggerId, "player_level")))

    -- 초기화 로직
    if getState(triggerId, "player_level") == nil then
        log("🎮 첫 초기화 시작")
        setState(triggerId, "player_level", 0)
        log("✅ 초기화 완료")
    else
        log("🎮 기존 데이터 유지")
    end

    -- 파싱 후 상태 확인
    log("🔧 파싱 후 레벨: " .. tostring(getState(triggerId, "player_level")))

    -- 스냅샷 전 상태 확인
    log("🔧 스냅샷 전 레벨: " .. tostring(getState(triggerId, "player_level")))
    takeSnapshot(triggerId)
end
```

### 2. 변수 변경 추적

```lua
function updateStat(triggerId, statName, newValue)
    local oldValue = getState(triggerId, statName)

    log("📊 스탯 변경: " .. statName ..
        " (" .. tostring(oldValue) .. " → " .. tostring(newValue) .. ")")

    setChatVar(triggerId, statName, tostring(newValue))
    setState(triggerId, statName, newValue)
end
```

### 3. 조건부 디버그 모드

```lua
local DEBUG_MODE = true  -- 개발 중: true, 배포 시: false

function debugLog(message)
    if DEBUG_MODE then
        log("🐛 " .. message)
    end
end

-- 사용 예
debugLog("player_level = " .. tostring(getState(triggerId, "player_level")))
```

---

## 일반적인 실수와 해결법

### 실수 1: setState() 누락

```lua
-- ❌ 잘못된 예
function addExperience(triggerId, amount)
    local current = tonumber(getChatVar(triggerId, "player_exp")) or 0
    local new_exp = current + amount
    setChatVar(triggerId, "player_exp", tostring(new_exp))
    -- setState() 호출 누락!
end

-- ✅ 올바른 예
function addExperience(triggerId, amount)
    local current = tonumber(getChatVar(triggerId, "player_exp")) or 0
    local new_exp = current + amount
    setChatVar(triggerId, "player_exp", tostring(new_exp))
    setState(triggerId, "player_exp", new_exp)  -- Lorebook 접근용
end
```

### 실수 2: nil 체크 누락

```lua
-- ❌ 잘못된 예
function calculateTotal(triggerId)
    local value1 = getState(triggerId, "value1")
    local value2 = getState(triggerId, "value2")
    return value1 + value2  -- value1이나 value2가 nil이면 에러!
end

-- ✅ 올바른 예
function calculateTotal(triggerId)
    local value1 = getState(triggerId, "value1") or 0
    local value2 = getState(triggerId, "value2") or 0
    return value1 + value2
end
```

### 실수 3: 타입 불일치

```lua
-- ❌ 잘못된 예
function updateLevel(triggerId, level)
    setState(triggerId, "player_level", level)  -- 숫자로 저장
    setChatVar(triggerId, "player_level", level)  -- 숫자로 저장 (문제!)
end

-- ✅ 올바른 예
function updateLevel(triggerId, level)
    setState(triggerId, "player_level", level)  -- 숫자
    setChatVar(triggerId, "player_level", tostring(level))  -- 문자열로 변환
end
```

### 실수 4: 스냅샷 복원 시 ChatVar 미갱신

```lua
-- ❌ 잘못된 예
function restoreSnapshot(triggerId)
    local snapshot = getState(triggerId, "level_snapshot")
    if snapshot ~= nil then
        setState(triggerId, "player_level", snapshot)
        -- setChatVar 호출 누락!
    end
end

-- ✅ 올바른 예
function restoreSnapshot(triggerId)
    local snapshot = getState(triggerId, "level_snapshot")
    if snapshot ~= nil then
        setState(triggerId, "player_level", snapshot)
        setChatVar(triggerId, "player_level", tostring(snapshot))
    end
end
```

---

## 체크리스트

새로운 변수를 추가할 때 다음 사항을 확인하세요:

- [ ] 조건부 초기화 패턴 사용 (`if == nil then`)
- [ ] `setState()`와 `setChatVar()` 모두 호출
- [ ] 타입 일치 (State: 숫자/문자열, ChatVar: 문자열)
- [ ] nil 체크 및 기본값 설정
- [ ] 스냅샷 저장/복원 로직 포함
- [ ] 디버그 로그 추가 (개발 중)
- [ ] 변경 시 양쪽 시스템 모두 업데이트

---

## 참고 자료

- Belladonna Academy RPG 프로젝트: 실제 버그 수정 사례
- RisuAI 공식 문서: [링크 필요]
- Lua 스크립팅 가이드: [링크 필요]

---

## 버전 히스토리

- v1.0 (2025-10-23): 초기 작성
  - 조건부 초기화 패턴
  - 변수 관리 시스템
  - 스냅샷 패턴
  - 일반적인 실수 모음

---

## 기여

이 문서는 실제 프로젝트 경험을 바탕으로 작성되었습니다. 추가적인 베스트 프랙티스나 사례가 있다면 기여해 주세요.
