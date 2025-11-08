# 사례 연구: 스탯 리셋 버그 해결 과정

## 요약

**프로젝트:** Belladonna Academy RPG System
**문제:** 대화를 다음 턴으로 넘길 때마다 모든 RPG 스탯이 0으로 리셋되는 현상
**원인:** `onStart()` 함수에서 조건 없이 변수를 초기화
**해결:** 조건부 초기화 패턴 적용
**날짜:** 2025-10-23

---

## 문제 상황

### 증상

사용자가 다음과 같은 문제를 보고했습니다:

> "대화 다음으로 넘어가니까 스탯의 값이 다시 0으로 돌아가네"

구체적으로:
- 게임 내에서 플레이어가 레벨업을 하고 스탯이 증가함
- AI가 태그를 통해 올바른 스탯 값을 생성함 (예: `<rpg_player_level>5</rpg_player_level>`)
- 다음 대화 턴으로 넘어가면 모든 스탯이 0으로 되돌아감
- 게임 진행이 불가능한 상태

### 초기 가설들

1. **setState() 호출 누락**: 스탯 변경 시 State 시스템에 저장하지 않았을 가능성
2. **스냅샷 미구현**: 리롤 시 변수가 복원되지 않을 가능성
3. **변수 이름 불일치**: ChatVar과 State의 키 이름이 달라서 발생할 가능성

---

## 디버깅 과정

### 1단계: setState() 호출 추가

**가설:** 스탯을 변경하는 함수들이 `setState()`를 호출하지 않아서 Lorebook이 업데이트된 값을 인식하지 못한다.

**조치:**
```lua
-- checkLevelUp() 함수 수정
function checkLevelUp(triggerId)
    -- 기존 코드
    setChatVar(triggerId, "player_level", tostring(new_level))

    -- 추가된 코드
    setState(triggerId, "player_level", new_level)  -- ✅ State 업데이트 추가
    setState(triggerId, "player_exp_to_next", exp_to_next)
end
```

**결과:** 문제 지속. 태그는 올바르게 생성되지만 다음 턴에서 여전히 0으로 리셋됨.

### 2단계: 스냅샷 시스템 강화

**가설:** 리롤이나 턴 전환 시 스냅샷이 제대로 작동하지 않는다.

**조치:**
- 턴 시작 시 스냅샷 복원 (기존)
- **턴 종료 시 스냅샷 저장 추가** (신규)

```lua
function onEndOfTurn(e)
    local triggerId = e.scriptId

    -- 턴 종료 전 최종 스냅샷 저장 (리롤 방지)
    for _, char in ipairs(characters) do
        takeSnapshot(triggerId, char)
    end
    takeRpgSnapshot(triggerId)  -- ✅ RPG 스탯 스냅샷 추가
end
```

**결과:** 문제 지속. 이중 스냅샷으로 리롤 방지는 강화되었지만 근본 원인은 해결되지 않음.

### 3단계: 디버그 로깅 추가

**조치:** 스탯 값의 변화를 추적하기 위해 전략적으로 로그 배치

```lua
function onStart(e)
    log("🔧 DEBUG: onStart() 호출됨!")

    local triggerId = e.scriptId

    -- 턴 시작 시점의 값
    log("🔧 DEBUG: 턴 시작 시 player_level = " ..
        tostring(getState(triggerId, "player_level")))

    -- ... 초기화 로직 ...

    -- 파싱 후 값
    log("🔧 DEBUG: 파싱 후 player_level = " ..
        tostring(getState(triggerId, "player_level")))

    -- 스냅샷 저장 전 값
    log("🔧 DEBUG: 스냅샷 전 player_level = " ..
        tostring(getState(triggerId, "player_level")))
end
```

**발견:**
```
🔧 DEBUG: onStart() 호출됨!
🔧 DEBUG: 턴 시작 시 player_level = 5
🎮 RPG 시스템 초기화 시작
🔧 DEBUG: 파싱 후 player_level = 0  ⚠️ 여기서 0으로 변경됨!
```

**핵심 발견:** `onStart()` 중간에 `player_level`이 5에서 0으로 변경되고 있었습니다!

### 4단계: 예시 코드 분석

사용자가 제공한 다른 프로젝트의 코드를 분석:

```lua
-- 올바른 패턴 (예시 코드에서)
function initializeAffectionVariables(triggerId)
    for _, name in ipairs(characters) do
        local master_score_key = name .. "aff"

        -- ✅ 조건부 초기화
        if getState(triggerId, master_score_key) == nil then
            setState(triggerId, master_score_key, initial_score)
        end
    end
end
```

**비교: Belladonna Academy 코드**

```lua
-- ❌ 문제가 있는 코드
function onStart(e)
    -- 호감도 시스템 (정상 작동)
    if not getChatVar(triggerId, "Evangeline_affection") then
        setChatVar(triggerId, "Evangeline_affection", "0")
        setState(triggerId, "Evangeline_affection", 0)
    end

    -- RPG 시스템 (문제!)
    setChatVar(triggerId, "player_level", "0")  -- ⚠️ 조건 없이 항상 실행
    setState(triggerId, "player_level", 0)
    setChatVar(triggerId, "player_exp", "0")
    setState(triggerId, "player_exp", 0)
    -- ... 모든 RPG 변수를 무조건 0으로 리셋
end
```

**발견:**
- 호감도 시스템: 조건부 초기화 사용 → **정상 작동** ✅
- RPG 시스템: 무조건 초기화 → **버그 발생** ❌

---

## 근본 원인

### 왜 이런 일이 발생했나?

`onStart()` 함수는 다음 상황에서 호출됩니다:
1. 처음 대화를 시작할 때
2. **대화를 이어갈 때마다** ⚠️
3. 리롤을 할 때

원래 의도:
```
첫 실행: player_level = nil → 0으로 초기화 ✅
이후 실행: player_level = 5 → 5 유지 (예상)
```

실제 동작:
```
첫 실행: player_level = nil → 0으로 초기화 ✅
이후 실행: player_level = 5 → 0으로 덮어쓰기 ❌
```

### 코드 비교

**문제가 있는 코드 (수정 전):**
```lua
function onStart(e)
    local triggerId = e.scriptId

    -- 항상 실행됨!
    setChatVar(triggerId, "player_level", "0")
    setState(triggerId, "player_level", 0)
    setChatVar(triggerId, "player_exp", "0")
    setState(triggerId, "player_exp", 0)
    -- ... 모든 RPG 변수
end
```

**수정된 코드 (수정 후):**
```lua
function onStart(e)
    local triggerId = e.scriptId

    -- 변수가 nil일 때만 실행됨!
    if getState(triggerId, "player_level") == nil then
        log("🎮 RPG 시스템 첫 초기화 시작")

        setChatVar(triggerId, "player_level", "0")
        setState(triggerId, "player_level", 0)
        setChatVar(triggerId, "player_exp", "0")
        setState(triggerId, "player_exp", 0)
        -- ... 모든 RPG 변수

        log("🎮 RPG 시스템 초기화 완료 (레벨 0)")
    else
        log("🎮 RPG 시스템 기존 데이터 유지 (player_level=" ..
            tostring(getState(triggerId, "player_level")) .. ")")
    end
end
```

---

## 해결 방법

### 적용된 패턴: 조건부 초기화

```lua
if getState(triggerId, "variable_name") == nil then
    -- 변수가 없을 때만 초기화
    setState(triggerId, "variable_name", initial_value)
else
    -- 변수가 있으면 유지
    -- 아무것도 하지 않음
end
```

### 커밋 히스토리

1. **커밋 1**: `69ab880` - Fix variable persistence: Add comprehensive setState calls
   - 모든 스탯 변경 함수에 `setState()` 추가
   - `checkLevelUp()`, `applyItemEffect()`, `addItem()`, `removeItem()` 등

2. **커밋 2**: `e4ce15d` - Add turn-end snapshot for better reroll protection
   - `onEndOfTurn()`에 스냅샷 저장 추가
   - 이중 스냅샷 시스템 구현

3. **커밋 3**: `2a1b084` - Add comprehensive debug logging to track stat reset issue
   - 전략적 디버그 로깅 추가
   - 문제 지점 식별

4. **최종 커밋**: (현재) - Fix stat reset bug: Make RPG initialization conditional
   - `onStart()`에 조건부 초기화 적용
   - **근본 원인 해결** ✅

---

## 교훈

### 1. 조건부 초기화는 필수

```lua
// ❌ 절대 이렇게 하지 마세요
function onStart(e)
    setState(triggerId, "player_level", 0)
}

// ✅ 항상 이렇게 하세요
function onStart(e)
    if getState(triggerId, "player_level") == nil then
        setState(triggerId, "player_level", 0)
    end
}
```

### 2. 같은 프로젝트 내에서도 패턴 불일치 주의

Belladonna Academy에서는:
- 호감도 시스템: 조건부 초기화 사용 ✅
- RPG 시스템: 무조건 초기화 사용 ❌

→ **코드 일관성 유지**가 중요합니다!

### 3. 디버그 로깅의 중요성

전략적으로 배치된 로그가 문제를 정확히 식별했습니다:
```lua
log("🔧 DEBUG: 턴 시작 시 player_level = " .. tostring(getState(...)))
// ... 코드 실행 ...
log("🔧 DEBUG: 파싱 후 player_level = " .. tostring(getState(...)))
```

이를 통해 "어디서" 값이 변경되는지 정확히 파악할 수 있었습니다.

### 4. 예시 코드의 가치

다른 프로젝트의 작동하는 코드를 참고하는 것이 큰 도움이 되었습니다. 베스트 프랙티스를 배우고 비교할 수 있었습니다.

### 5. 점진적 디버깅

문제를 해결하기 위해 여러 단계를 거쳤습니다:
1. setState() 추가 → 부분적 개선
2. 스냅샷 강화 → 리롤 방지 개선
3. 디버그 로깅 → 문제 식별
4. 조건부 초기화 → **근본 해결** ✅

각 단계가 최종 해결에 기여했습니다.

---

## 검증

### 테스트 시나리오

1. **첫 시작**
   ```
   player_level = nil
   → onStart() 실행
   → player_level = 0 (초기화) ✅
   ```

2. **레벨업 후 다음 턴**
   ```
   player_level = 5
   → onStart() 실행
   → player_level = 5 (유지) ✅
   ```

3. **리롤**
   ```
   player_level_snapshot = 5
   → onStart() 실행
   → restoreSnapshot()
   → player_level = 5 (복원) ✅
   ```

### 예상 로그 출력

```
🎮 게임 시스템 시작
🎮 RPG 시스템 기존 데이터 유지 (player_level=5)
```

---

## 참고 자료

### 관련 파일
- `/home/user/dudada/belladonna_academy_rpg.lua` (라인 1846-1882)

### 관련 문서
- [BEST_PRACTICES.md](BEST_PRACTICES.md) - 조건부 초기화 패턴 상세 설명
- [examples/initialization_patterns.lua](examples/initialization_patterns.lua) - 코드 예제

### 커밋
- `69ab880` - setState() 호출 추가
- `e4ce15d` - 턴 종료 스냅샷 추가
- `2a1b084` - 디버그 로깅 추가
- 최종 수정 - 조건부 초기화 적용

---

## 결론

이 버그는 다음을 보여줍니다:

1. **패턴의 중요성**: 조건부 초기화는 선택이 아닌 필수
2. **일관성의 중요성**: 같은 프로젝트 내에서도 패턴을 일관되게 적용해야 함
3. **디버깅의 중요성**: 체계적인 로깅으로 문제를 정확히 진단
4. **학습의 중요성**: 다른 프로젝트의 베스트 프랙티스 참고

작은 실수(조건문 누락)가 큰 문제(게임 진행 불가)로 이어질 수 있으며, 올바른 패턴을 처음부터 적용하는 것이 중요합니다.

---

**작성일:** 2025-10-23
**작성자:** Claude (AI Assistant)
**프로젝트:** Belladonna Academy RPG System
