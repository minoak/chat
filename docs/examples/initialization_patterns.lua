--[[
    RisuAI Lua 초기화 패턴 예제

    이 파일은 RisuAI에서 변수를 올바르게 초기화하는 다양한 패턴을 보여줍니다.
    실제 프로젝트에서 이 패턴들을 참고하여 사용하세요.
]]

-- ============================================================================
-- 패턴 1: 단순 변수 조건부 초기화
-- ============================================================================

function initializeSimpleVariable(triggerId)
    -- 변수가 없을 때만 초기화
    if getState(triggerId, "player_level") == nil then
        log("플레이어 레벨 초기화: 1")
        setState(triggerId, "player_level", 1)
        setChatVar(triggerId, "player_level", "1")
    else
        log("기존 플레이어 레벨 유지: " .. tostring(getState(triggerId, "player_level")))
    end
end

-- ============================================================================
-- 패턴 2: 여러 변수 그룹 초기화
-- ============================================================================

function initializePlayerStats(triggerId)
    -- 플래그 변수를 사용하여 그룹 초기화 여부 확인
    if getState(triggerId, "stats_initialized") == nil then
        log("플레이어 스탯 초기화 시작")

        -- 기본 스탯
        setState(triggerId, "strength", 10)
        setChatVar(triggerId, "strength", "10")

        setState(triggerId, "agility", 10)
        setChatVar(triggerId, "agility", "10")

        setState(triggerId, "intelligence", 10)
        setChatVar(triggerId, "intelligence", "10")

        setState(triggerId, "vitality", 10)
        setChatVar(triggerId, "vitality", "10")

        -- 초기화 완료 플래그
        setState(triggerId, "stats_initialized", true)
        log("플레이어 스탯 초기화 완료")
    else
        log("플레이어 스탯 기존 데이터 유지")
    end
end

-- ============================================================================
-- 패턴 3: 캐릭터 배열 초기화
-- ============================================================================

function initializeCharacterAffection(triggerId)
    local characters = {
        "Evangeline",
        "Isabella",
        "Scarlett",
        "Melissa"
    }

    local initial_affection = 0
    local need_log = false

    -- 각 캐릭터별로 호감도 초기화
    for _, char in ipairs(characters) do
        local key = char .. "_affection"

        if getState(triggerId, key) == nil then
            setState(triggerId, key, initial_affection)
            setChatVar(triggerId, key, tostring(initial_affection))
            need_log = true
        end
    end

    if need_log then
        log("캐릭터 호감도 초기화 완료 (" .. #characters .. "명)")
    end
end

-- ============================================================================
-- 패턴 4: 복잡한 데이터 구조 초기화 (JSON)
-- ============================================================================

function initializeInventory(triggerId)
    if getState(triggerId, "inventory_initialized") == nil then
        log("인벤토리 초기화 시작")

        -- 빈 배열로 시작
        local empty_inventory = "[]"
        setState(triggerId, "player_items", empty_inventory)
        setChatVar(triggerId, "player_items", empty_inventory)

        -- 기본 아이템 추가 (예시)
        local starting_items = "[\"초심자의 검\", \"체력 포션 x3\"]"
        setState(triggerId, "player_items", starting_items)
        setChatVar(triggerId, "player_items", starting_items)

        setState(triggerId, "inventory_initialized", true)
        log("인벤토리 초기화 완료")
    end
end

-- ============================================================================
-- 패턴 5: 진행도 기반 초기화 (챕터 시스템)
-- ============================================================================

function initializeChapterProgress(triggerId)
    local current_chapter = getState(triggerId, "current_chapter")

    if current_chapter == nil then
        -- 첫 시작
        log("새로운 스토리 시작: 챕터 1")
        setState(triggerId, "current_chapter", 1)
        setChatVar(triggerId, "current_chapter", "1")

        setState(triggerId, "chapter_1_progress", 0)
        setChatVar(triggerId, "chapter_1_progress", "0")
    else
        -- 기존 진행도 유지
        log("기존 스토리 이어하기: 챕터 " .. current_chapter)

        -- 현재 챕터의 진행도가 없으면 초기화
        local chapter_key = "chapter_" .. current_chapter .. "_progress"
        if getState(triggerId, chapter_key) == nil then
            setState(triggerId, chapter_key, 0)
            setChatVar(triggerId, chapter_key, "0")
        end
    end
end

-- ============================================================================
-- 패턴 6: 마이그레이션 패턴 (버전 업그레이드)
-- ============================================================================

function migrateVariables(triggerId)
    local version = getState(triggerId, "data_version")

    if version == nil then
        -- v1 -> v2 마이그레이션
        log("데이터 버전 1 -> 2 마이그레이션 시작")

        -- 이전 버전 변수가 있으면 변환
        local old_gold = getState(triggerId, "gold")
        if old_gold ~= nil then
            -- 새 이름으로 변경
            setState(triggerId, "player_currency", old_gold)
            setChatVar(triggerId, "player_currency", tostring(old_gold))
            log("gold -> player_currency 마이그레이션 완료: " .. old_gold)
        else
            -- 새 설치
            setState(triggerId, "player_currency", 100)
            setChatVar(triggerId, "player_currency", "100")
        end

        setState(triggerId, "data_version", 2)
        log("데이터 버전 업그레이드 완료: v2")

    elseif version == 2 then
        log("데이터 버전 최신 (v2)")
    end
end

-- ============================================================================
-- 패턴 7: 스냅샷 시스템
-- ============================================================================

function takeVariableSnapshot(triggerId)
    log("📸 변수 스냅샷 저장 시작")

    -- 단순 변수 스냅샷
    local level = getState(triggerId, "player_level")
    if level ~= nil then
        setState(triggerId, "player_level_snapshot", level)
    end

    local exp = getState(triggerId, "player_exp")
    if exp ~= nil then
        setState(triggerId, "player_exp_snapshot", exp)
    end

    -- 복잡한 데이터 스냅샷
    local items = getChatVar(triggerId, "player_items")
    if items ~= nil then
        setState(triggerId, "player_items_snapshot", items)
    end

    log("📸 스냅샷 저장 완료")
end

function restoreVariableSnapshot(triggerId)
    log("♻️ 변수 스냅샷 복원 시작")

    -- 단순 변수 복원
    local level_snapshot = getState(triggerId, "player_level_snapshot")
    if level_snapshot ~= nil then
        setState(triggerId, "player_level", level_snapshot)
        setChatVar(triggerId, "player_level", tostring(level_snapshot))
    end

    local exp_snapshot = getState(triggerId, "player_exp_snapshot")
    if exp_snapshot ~= nil then
        setState(triggerId, "player_exp", exp_snapshot)
        setChatVar(triggerId, "player_exp", tostring(exp_snapshot))
    end

    -- 복잡한 데이터 복원
    local items_snapshot = getState(triggerId, "player_items_snapshot")
    if items_snapshot ~= nil then
        setState(triggerId, "player_items", items_snapshot)
        setChatVar(triggerId, "player_items", items_snapshot)
    end

    log("♻️ 스냅샷 복원 완료")
end

-- ============================================================================
-- 패턴 8: 리셋 가능한 임시 변수
-- ============================================================================

function initializeTemporaryVariables(triggerId)
    -- 턴마다 리셋되어야 하는 변수들
    log("임시 변수 초기화")

    setState(triggerId, "turn_actions", 0)
    setChatVar(triggerId, "turn_actions", "0")

    setState(triggerId, "turn_damage_taken", 0)
    setChatVar(triggerId, "turn_damage_taken", "0")

    setState(triggerId, "special_event_triggered", false)
    setChatVar(triggerId, "special_event_triggered", "false")
end

-- ============================================================================
-- 완전한 onStart() 예제
-- ============================================================================

function onStart(e)
    local triggerId = e.scriptId
    log("🎮 게임 시스템 시작")

    -- 1. 스냅샷 복원 (리롤 방지)
    restoreVariableSnapshot(triggerId)

    -- 2. 영구 변수 초기화 (조건부)
    initializeSimpleVariable(triggerId)
    initializePlayerStats(triggerId)
    initializeCharacterAffection(triggerId)
    initializeInventory(triggerId)
    initializeChapterProgress(triggerId)

    -- 3. 데이터 마이그레이션
    migrateVariables(triggerId)

    -- 4. 임시 변수 초기화 (매 턴)
    initializeTemporaryVariables(triggerId)

    log("✅ 게임 시스템 준비 완료")
end

-- ============================================================================
-- 완전한 onEndOfTurn() 예제
-- ============================================================================

function onEndOfTurn(e)
    local triggerId = e.scriptId
    log("🏁 턴 종료 처리")

    -- 현재 상태 스냅샷 저장
    takeVariableSnapshot(triggerId)

    log("✅ 턴 종료 처리 완료")
end

-- ============================================================================
-- 사용 가이드
-- ============================================================================

--[[
    이 예제들을 프로젝트에 적용하는 방법:

    1. 필요한 패턴을 복사하여 사용
    2. 변수 이름을 프로젝트에 맞게 수정
    3. 초기값을 게임 디자인에 맞게 조정
    4. 디버그 로그를 추가하여 동작 확인
    5. 스냅샷 시스템을 통합

    주의사항:
    - 항상 조건부 초기화 사용 (if == nil then)
    - setState와 setChatVar 둘 다 호출
    - 타입 일치 확인 (State: any, ChatVar: string)
    - nil 체크 및 기본값 처리
    - 스냅샷 저장/복원 구현
]]
