-- Belladonna Academy System v7.3 - RPG Edition
-- 로어북 기준 장소명 정리 + 한영 병기 출력 + RPG 시스템 통합

--[[
==============================================
보조모델 (Auxiliary Model) 사용 안내
==============================================

본 스크립트는 이중 모델 아키텍처를 사용합니다:

1. 메인 모델 (Main Model) - 스토리텔링 전담
   - 순수하게 이야기만 작성
   - 시스템 태그 출력 없음
   - 자연스러운 롤플레이에 집중

2. 보조 모델 (Auxiliary Model) - 시스템 심판
   - 메인 모델의 출력 분석
   - 시스템 태그 생성 및 출력
   - 프롬프트: STATUS_OUTPUT_INSTRUCTIONS_v2.0.md 참조

3. Lua 스크립트 (본 파일) - 시스템 관리자
   - 태그 파싱 및 변수 저장
   - 계산 처리 (레벨업, 스탯 제한 등)
   - 스냅샷/복원 (리롤 지원)

태그 형식:
  [Affinity:Name:level][Sin:Name:level]
  [Stat:stat_id:±value][Gold:±value][EXP:±value]
  [Item:Add:Name:Qty:Type:Value:Duration:Desc]  -- AI가 효과 정의
  [Item:Remove:Name:Qty]
  [Trait:Name:Category:Effect:Value:Condition]
  [Effect:Add:Name:Type:Value:Duration:Desc]
  [Effect:Remove:Name]
  [Season:계절][Week:주차][Time:시간][Location:장소]
  [StatsEvaluated]  -- 능력평가 완료
  <Panel>■★

아이템 생성 시 AI가 효과를 정의합니다:
  예: [Item:Add:힘의물약:1:str_bonus:10:3:근육이 불끈]

비소모품(학생증, 열쇠 등)은 사용 후 재획득:
  사용자: /use 학생증
  AI: 학생증을 보여준다... [Item:Add:학생증:1]
==============================================
]]

-- ============================================
-- 설정 섹션
-- ============================================

local characters = {
    -- Main 8 (대죄 보유자)
    {display = "Mirabel", storage = "mirabel", sin_type = "탐욕", icon = "💰", is_main = true,
     stats = {str = 55, dex = 60, int = 82, luk = 75}},  -- 귀족 마법사, 경호원 고용 (전투력: 334)

    {display = "Celestia", storage = "celestia", sin_type = "오만", icon = "👑", is_main = true,
     stats = {str = 58, dex = 65, int = 88, luk = 70}},  -- 황족, 높은 마법적성 (전투력: 374)

    {display = "Cassandra", storage = "cassandra", sin_type = "분노", icon = "👊", is_main = true,
     stats = {str = 88, dex = 85, int = 65, luk = 68}},  -- 전사, 체력/민첩/힘 특화 (전투력: 411)

    {display = "Evangeline", storage = "evangeline", sin_type = "색욕", icon = "💋", is_main = true,
     stats = {str = 52, dex = 58, int = 68, luk = 78}},  -- 귀족, 마력 있지만 전투원 아님 (전투력: 298)

    {display = "Amelia", storage = "amelia", sin_type = "질투", icon = "🎨", is_main = true,
     stats = {str = 42, dex = 45, int = 70, luk = 55}},  -- 찐따, 신체능력 낮음 (전투력: 244)

    {display = "Nepenthes", storage = "nepenthes", sin_type = "폭식", icon = "🌺", is_main = true,
     stats = {str = 56, dex = 62, int = 80, luk = 65}},  -- 연금술/마력, 도구 사용 (전투력: 321)

    {display = "Lilith", storage = "lilith", sin_type = "나태", icon = "📱", is_main = true,
     stats = {str = 48, dex = 60, int = 92, luk = 78}},  -- 마법천재, 신체 약함 (전투력: 310)

    {display = "Aurelia", storage = "aurelia", sin_type = "타락", icon = "☀️", is_main = true,
     stats = {str = 82, dex = 85, int = 82, luk = 75}},  -- 육각형 천재, 완벽한 황녀 (전투력: 409)

    -- Sub 6 (일반 캐릭터)
    {display = "Cordelia", storage = "cordelia", icon = "💎", is_main = false,
     stats = {str = 54, dex = 58, int = 72, luk = 66}},  -- 보석상 영애 (전투력: 296)

    {display = "Suah", storage = "suah", icon = "🌙", is_main = false,
     stats = {str = 58, dex = 62, int = 68, luk = 60}},  -- 업소 출신, 생존력 (전투력: 308)

    {display = "Adelheid", storage = "adelheid", icon = "❄️", is_main = false,
     stats = {str = 78, dex = 90, int = 70, luk = 68}},  -- 천재검사 (전투력: 406)

    {display = "Rosalie", storage = "rosalie", icon = "🌸", is_main = false,
     stats = {str = 62, dex = 65, int = 72, luk = 65}},  -- 남부 귀족, 의지력 (전투력: 326)

    {display = "Mika", storage = "mika", icon = "🎵", is_main = false,
     stats = {str = 55, dex = 60, int = 75, luk = 70}},  -- 일러스트레이터 (전투력: 305)

    {display = "Clover", storage = "clover", icon = "🍀", is_main = false,
     stats = {str = 52, dex = 58, int = 78, luk = 72}}  -- 연금술사, 운빨 (전투력: 298)
}

local affinityChanges = {
    love = 20,
    like = 15,
    neutral = 0,
    dislike = -15,
    hate = -20
}

local sinPosChanges = {
    corrupt = 2,
    tempt = 1
}

local sinNegChanges = {
    resist = 1,
    purify = 2
}

local AFFINITY_MAX = 500
local AFFINITY_MIN = -500
local SIN_MAX = 30

-- ============================================
-- RPG 시스템 설정
-- ============================================

local STAT_MIN = 0
local STAT_MAX = 100
local STAT_DEFAULT = 0

local playerStats = {"str", "int", "dex", "cha", "luk", "vit"}

-- 효과 시스템 설정
local EFFECT_MAX_STACK = 10  -- 최대 동시 적용 효과 수

local statDisplayNames = {
    str = "근력 (STR)",
    int = "지능 (INT)",
    dex = "민첩 (DEX)",
    cha = "매력 (CHA)",
    luk = "행운 (LUK)",
    vit = "생명 (VIT/HP)"
}

-- 레벨별 필요 경험치 (누적)
local expTable = {
    [1] = 0,
    [2] = 100,
    [3] = 250,
    [4] = 450,
    [5] = 700,
    [6] = 1000,
    [7] = 1350,
    [8] = 1750,
    [9] = 2200,
    [10] = 2700,
    [11] = 3300,
    [12] = 4000,
    [13] = 4800,
    [14] = 5700,
    [15] = 6700,
    [16] = 7800,
    [17] = 9000,
    [18] = 10300,
    [19] = 11700,
    [20] = 13200
}

-- ============================================
-- 보조모델 프롬프트
-- ============================================

local AUXILIARY_BASE_PROMPT = [[
You are the System Judge for Belladonna Academy RPG. Analyze Main AI narrative and output tags.

## Output Format
[Affinity:Name:level][Sin:Name:level]
[Stat:stat:±value][Gold:±value][Item:Action:Name:Qty:Effect][EXP:±value]
[Heal:amount][Effect:Action:Name:StatBonus][Trait:Action:Name:Description]
[Combat:Name:Power][Combat:End]
[Season:계절][Week:주차][Day:요일][Time:시간][Location:장소][Weather:날씨]
<Panel>■★

## Relationship Tags (Only for Characters in Scene)
[Affinity:Name:level] - THIS TURN feelings: love(+20), like(+15), neutral(0), dislike(-15), hate(-20)
[Sin:Name:level] - THIS TURN sin: corrupt(+2), tempt(+1), neutral(0), resist(+1), purify(+2)
Names: [Affinity:Mirabel:like] NOT [Affinity:Mirabel von Goldenrose:like]

**CRITICAL: Output tags ONLY for characters who appear in the narrative. Skip characters not mentioned.**
**Do NOT output neutral tags unless there's a clear emotional shift to neutral state.**

## Environment Tags
Game State Panel shows current. Output ONLY when Main AI describes changes.
[Day:요일][Time:시간][Location:장소] - Final arrival only (여러 곳→마지막만)
[Week:숫자] - Monday new week start only
[Season:계절] - New semester only

## RPG Tags
[Stat:stat:±value] - str/int/dex/cha/luk/vit (±1~5 typical, ±10+ major). [StatsEvaluated]시 ± 없이
[Gold:±value] - Money change
[Item:Add:Name:Qty:Effect] / [Item:Remove:Name:Qty] - Non-consumables(학생증,열쇠) return after use
[EXP:±value] - +10~100
[Heal:amount] - CP recovery 20~100

## Effect/Trait Tags - {{user}} ONLY
[Effect:Add:Name:StatBonus] - Temporary boost ({{user}} only, NOT NPCs)
[Effect:Remove:Name] - Remove effect
[Effect:Merge:Old1+Old2→New:StatBonus] - Combine similar effects
[Trait:Add:Name:Desc] - Permanent trait ({{user}} only, NOT NPCs)
[Trait:Merge:Old1+Old2→New:Desc] - Combine similar traits

**CRITICAL: Effect/Trait tags are for {{user}} only.**
**NPC changes (Mirabel gets stronger, Celestia learns magic) → Narrative description ONLY. NO tags.**

**CRITICAL StatBonus Format (MUST follow):**
✓ SINGLE stat only: str+15, int+10, dex+5, all_bonus+8
✗ NEVER multiple: "str+10, int+5" or "ALLSTATS +20, CHA +10"

**Multiple stats → Separate tags:**
✓ [Effect:Add:축복_힘:str+10][Effect:Add:축복_지능:int+10]
✗ [Effect:Add:축복:str+10, int+10]

## Growth System - Effect/Trait Synthesis
Effects/Traits show player's growth. Merge similar ones → stronger versions (reduces token usage, shows progression).

**When to Merge (check current lists above):**
- Similar theme/concept 2+ times: 작은축복+중간축복→성녀의축복
- Same stat stacking: str+5, str+10 → str+15 with upgraded name
- Related concepts: 빠른발+민첩함→신속함, 학습+집중→천재성

**Merge Examples:**
✓ [Effect:Merge:작은축복+중간축복→성녀의축복:str+20]
✓ [Effect:Merge:빠른학습+높은집중력→천재적재능:int+15]
✓ [Trait:Merge:검술입문+검술수련→검술숙련:검에 대한 깊은 이해]

**Multiple stat merge → Separate effects:**
✓ [Effect:Merge:작은축복+중간축복→성녀의축복_힘:str+15]
   [Effect:Add:성녀의축복_매력:cha+10]
✗ [Effect:Merge:작은축복+중간축복→성녀의축복:str+15, cha+10]

{{PLAYER_TRAITS_SECTION}}
{{PLAYER_EFFECTS_SECTION}}

**Decision logic:** Check above lists → similar 2+? Merge. Otherwise Add new.

## Combat Tags
Check Game State for "⚔️ Combat Status: ACTIVE"
- If ACTIVE: DO NOT output [Combat:Name:Power] again. ONLY [Combat:End] when clearly ends
- If NOT ACTIVE: MUST output [Combat:Name:Power] when new challenge starts
- Power guide (player ~400): 150-250(VeryEasy), 250-350(Easy), 350-500(Normal), 500-650(Hard), 650-900+(VeryHard)
- Works for ANY challenge: combat, exams, negotiations, skills
- [Combat:End] when resolved. NEVER with <CombatChoice> same turn

## Weekly System
Friday: [Stat:...weekly]<WeeklyReport>Week:X|Season:Y|Curriculum:Name|Lifestyle:Activity|Score:N|Stats:changes</WeeklyReport>[Day:금요일][Time:저녁]
Monday: [Week:X+1][Day:월요일][Time:오전]
Exams (Week 6,12): [Exam:midterm:87:23]

## Characters
Mirabel, Celestia, Cassandra, Evangeline, Amelia, Nepenthes, Lilith, Aurelia, Cordelia, Suah, Adelheid, Rosalie, Mika, Clover

Always end with <Panel>■★
]]

-- ============================================
-- 유틸리티 함수
-- ============================================

function clampValue(value, min, max)
    if value > max then return max
    elseif value < min then return min
    else return value end
end

function checkEnding(affinity)
    if affinity >= 200 then return "pure_love"
    elseif affinity <= -200 then return "redemption"
    end
    return "ongoing"
end

function getRouteText(ending)
    if ending == "pure_love" then return "순애"
    elseif ending == "redemption" then return "구원"
    else return "진행중" end
end

-- ============================================
-- 활성 효과 관리 시스템
-- ============================================

-- 활성 효과 가져오기 (간단한 구분자 파싱)
function getActiveEffects(triggerId)
    local effectsStr = getChatVar(triggerId, "active_effects") or ""
    local effects = {}

    if effectsStr == "" then
        return effects
    end

    -- 형식: "name1:type1:value1:duration1:desc1|name2:type2:value2:duration2:desc2|..."
    for effectData in effectsStr:gmatch("[^|]+") do
        local parts = {}
        for part in effectData:gmatch("[^:]+") do
            table.insert(parts, part)
        end

        if #parts >= 4 then
            table.insert(effects, {
                name = parts[1],
                type = parts[2],
                value = tonumber(parts[3]) or 0,
                duration = tonumber(parts[4]) or 0,
                desc = parts[5] or ""
            })
        end
    end

    return effects
end

-- 활성 효과 저장 (간단한 구분자 직렬화)
function saveActiveEffects(triggerId, effects)
    if #effects == 0 then
        setChatVar(triggerId, "active_effects", "")
        setState(triggerId, "active_effects", "")
        setChatVar(triggerId, "active_effects_display", "")
        setState(triggerId, "active_effects_display", "")
        return
    end

    -- 직렬화: name:type:value:duration:desc|name:type:value:duration:desc|...
    local parts = {}
    for _, effect in ipairs(effects) do
        -- nil 방어: 모든 필드가 유효한 값인지 확인
        local effectStr = string.format("%s:%s:%d:%d:%s",
            effect.name or "Unknown",
            effect.type or "display",
            tonumber(effect.value) or 0,
            tonumber(effect.duration) or 0,
            effect.desc or "")
        table.insert(parts, effectStr)
    end

    local serialized = table.concat(parts, "|")
    setChatVar(triggerId, "active_effects", serialized)
    setState(triggerId, "active_effects", serialized)

    -- 표시용 텍스트 생성
    updateEffectsDisplay(triggerId, effects)
end

-- 효과 표시 텍스트 업데이트
function updateEffectsDisplay(triggerId, effects)
    if #effects == 0 then
        setChatVar(triggerId, "active_effects_display", "")
        setState(triggerId, "active_effects_display", "")
        return
    end

    local lines = {}
    for _, effect in ipairs(effects) do
        -- nil 방어: value와 duration을 숫자로 보장
        local effectValue = tonumber(effect.value) or 0
        local effectDuration = tonumber(effect.duration) or 0
        local effectName = effect.name or "Unknown"
        local effectDesc = effect.desc or ""

        local sign = effectValue >= 0 and "+" or ""
        local durationText = effectDuration > 0 and (effectDuration .. "턴") or "영구"

        -- 효과 설명이 있으면: "이름: 설명 (효과, 기간)"
        -- 효과 설명이 없으면: "이름: 효과 (기간)"
        local line
        if effectDesc ~= "" and effectDesc ~= effectName then
            line = string.format("%s: %s (%s%d, %s)",
                effectName, effectDesc, sign, effectValue, durationText)
        else
            line = string.format("%s: %s%d (%s)",
                effectName, sign, effectValue, durationText)
        end

        table.insert(lines, line)
    end

    local display = table.concat(lines, "\n")
    setChatVar(triggerId, "active_effects_display", display)
    setState(triggerId, "active_effects_display", display)
end

-- 효과 추가 (같은 이름 있으면 덮어쓰기)
function addEffect(triggerId, name, effectType, value, duration, desc)
    local effects = getActiveEffects(triggerId)

    -- 같은 이름의 효과 제거
    for i = #effects, 1, -1 do
        if effects[i].name == name then
            table.remove(effects, i)
        end
    end

    -- 최대 개수 체크
    if #effects >= EFFECT_MAX_STACK then
        log("⚠️ 효과 상한 도달 - " .. name .. " 추가 실패")
        return false
    end

    -- 새 효과 추가
    table.insert(effects, {
        name = name,
        type = effectType,
        value = value,
        duration = duration,
        desc = desc or ""
    })

    saveActiveEffects(triggerId, effects)
    log("✨ 효과 추가: " .. name .. " (" .. effectType .. " " .. value .. ", " .. duration .. "턴)")
    return true
end

-- 효과 제거
function removeEffect(triggerId, name)
    local effects = getActiveEffects(triggerId)
    local removed = false

    for i = #effects, 1, -1 do
        if effects[i].name == name then
            table.remove(effects, i)
            removed = true
        end
    end

    if removed then
        saveActiveEffects(triggerId, effects)
        log("💨 효과 제거: " .. name)
    end

    return removed
end

-- 턴마다 duration 감소 및 만료 효과 제거
function updateEffectDurations(triggerId)
    local effects = getActiveEffects(triggerId)
    local expired = {}
    local needsSave = false

    for i = #effects, 1, -1 do
        local effect = effects[i]
        if effect.duration > 0 then
            effect.duration = effect.duration - 1
            needsSave = true  -- duration이 감소했으면 저장 필요

            if effect.duration == 0 then
                table.insert(expired, effect.name)
                table.remove(effects, i)
            end
        end
    end

    if needsSave then
        saveActiveEffects(triggerId, effects)

        if #expired > 0 then
            for _, name in ipairs(expired) do
                log("⏰ 효과 만료: " .. name)
            end
        end
    end
end

-- 특정 스탯에 적용되는 효과 합계 계산
function calculateEffectBonus(triggerId, statName)
    local effects = getActiveEffects(triggerId)
    local total = 0

    for _, effect in ipairs(effects) do
        -- 개별 스탯 효과
        if effect.type == statName .. "_bonus" or effect.type == statName .. "_penalty" then
            total = total + effect.value
        -- 전체 스탯 효과
        elseif effect.type == "all_bonus" or effect.type == "all_penalty" then
            total = total + effect.value
        end
    end

    return total
end

-- 효과 적용된 스탯 값 가져오기
function getStatWithEffects(triggerId, statName)
    local baseStat = tonumber(getChatVar(triggerId, "player_" .. statName)) or STAT_DEFAULT
    local effectBonus = calculateEffectBonus(triggerId, statName)
    local finalStat = baseStat + effectBonus

    return clampValue(finalStat, STAT_MIN, STAT_MAX)
end

-- ============================================
-- 아이템 효과 정의
-- ============================================

-- 아이템 효과는 AI가 생성하며, 아이템 추가 시 저장됩니다.
-- 형식: item_effect_<itemname> = "type:value:duration:desc"

-- ============================================
-- 아이템 사용 함수는 updateRpgDisplayVars에서 인덱스 기반으로 등록됨
-- 한글 아이템명 문제 해결: use_item_1, use_item_2... 형식 사용
-- ============================================

-- ============================================
-- RPG 디스플레이 변수 업데이트
-- ============================================

function updateRpgDisplayVars(triggerId)
    -- 경험치 퍼센트 계산
    local exp = tonumber(getChatVar(triggerId, "player_exp")) or 0
    local expToNext = getChatVar(triggerId, "player_exp_to_next") or "100"
    local expPercent = 0

    if expToNext ~= "MAX" then
        local expToNextNum = tonumber(expToNext) or 100
        if expToNextNum > 0 then
            expPercent = (exp / (exp + expToNextNum)) * 100
            expPercent = clampValue(expPercent, 0, 100)
        end
    else
        expPercent = 100
    end

    setChatVar(triggerId, "player_exp_percent", tostring(math.floor(expPercent)))

    -- 스탯 보너스 및 실제 적용값 계산 (효과 포함)
    for _, stat in ipairs({"str", "dex", "int", "cha", "luk", "vit"}) do
        local bonus = calculateEffectBonus(triggerId, stat)
        local effectiveStat = getStatWithEffects(triggerId, stat)

        setChatVar(triggerId, stat .. "_bonus", tostring(bonus))
        setState(triggerId, stat .. "_bonus", bonus)

        setChatVar(triggerId, stat .. "_effective", tostring(effectiveStat))
        setState(triggerId, stat .. "_effective", effectiveStat)
    end

    -- 최대 전투력 계산 (현재 스탯 기반, 효과 포함)
    local maxCombatPower = calculateCombatPower(triggerId)
    setChatVar(triggerId, "player_combat_power_max", tostring(maxCombatPower))
    setState(triggerId, "player_combat_power_max", maxCombatPower)

    -- 아이템 HTML 생성 (슬롯 15개 기반)
    local itemsHtml = ""
    local hasItems = false

    for i = 1, 15 do
        local itemName = getChatVar(triggerId, "player_item_slot_" .. i .. "_name") or ""
        local itemCount = getChatVar(triggerId, "player_item_slot_" .. i .. "_count") or "0"

        if itemName ~= "" and itemCount ~= "0" then
            hasItems = true
            itemsHtml = itemsHtml .. string.format(
                "<button type='button' risu-trigger='use_item_%d' class='rpg-item-button'>%s (%s)</button>",
                i, itemName, itemCount
            )
        end
    end

    if not hasItems then
        itemsHtml = "<span style='color: #666; font-style: italic;'>아이템 없음</span>"
    end

    setChatVar(triggerId, "player_items_html", itemsHtml)
    setState(triggerId, "player_items_html", itemsHtml)
end

-- ============================================
-- 퍼센트 계산
-- ============================================

function updatePercent(triggerId, char)
    local affinity = tonumber(getChatVar(triggerId, char.storage .. "_affinity")) or 0
    local affPercent = ((affinity + 500) / 1000) * 100
    affPercent = clampValue(affPercent, 0, 100)
    setChatVar(triggerId, char.storage .. "_affinity_percent", tostring(math.floor(affPercent)))

    if char.is_main then
        local pos = tonumber(getChatVar(triggerId, char.storage .. "_sin_pos")) or 0
        local neg = tonumber(getChatVar(triggerId, char.storage .. "_sin_neg")) or 0

        local posPercent = (pos / 30) * 100
        local negPercent = (neg / 30) * 100

        posPercent = clampValue(posPercent, 0, 100)
        negPercent = clampValue(negPercent, 0, 100)

        setChatVar(triggerId, char.storage .. "_sin_pos_percent", tostring(math.floor(posPercent)))
        setChatVar(triggerId, char.storage .. "_sin_neg_percent", tostring(math.floor(negPercent)))
    end
end

-- ============================================
-- RPG 시스템 함수
-- ============================================

-- 플레이어 스탯 파싱
function parseStatChanges(triggerId, message)
    local combatStatsChanged = false
    local oldMaxPower = calculateCombatPower(triggerId)
    local currentPower = tonumber(getChatVar(triggerId, "player_combat_power")) or oldMaxPower
    local powerRatio = (oldMaxPower > 0) and (currentPower / oldMaxPower) or 1.0

    for statId, changeStr in message:gmatch("%[Stat:(%w+):([%+%-]?%d+)%]") do
        local key = "player_" .. statId:lower()
        local current = tonumber(getChatVar(triggerId, key)) or STAT_DEFAULT
        local change, new

        -- ±가 있으면 변화값, 없으면 절대값
        if changeStr:match("^[%+%-]") then
            change = tonumber(changeStr) or 0
            new = clampValue(current + change, STAT_MIN, STAT_MAX)
        else
            new = clampValue(tonumber(changeStr) or STAT_DEFAULT, STAT_MIN, STAT_MAX)
            change = new - current
        end

        setChatVar(triggerId, key, tostring(new))

        -- 변경량 추적
        local changeKey = key .. "_change"
        local prevChange = tonumber(getChatVar(triggerId, changeKey)) or 0
        setChatVar(triggerId, changeKey, tostring(prevChange + change))

        local displayName = statDisplayNames[statId:lower()] or statId
        log(string.format("📊 %s %+d | 현재: %d", displayName, change, new))

        -- 전투력 관련 스탯 체크 (STR, DEX, INT, LUK)
        local statLower = statId:lower()
        if statLower == "str" or statLower == "dex" or statLower == "int" or statLower == "luk" then
            combatStatsChanged = true
        end
    end

    -- 전투력 관련 스탯이 변경되었으면 현재 전투력도 비례 조정
    if combatStatsChanged then
        local newMaxPower = calculateCombatPower(triggerId)
        local newCurrentPower = math.floor(newMaxPower * powerRatio)

        -- 최소 1, 최대 newMaxPower로 제한
        newCurrentPower = clampValue(newCurrentPower, 1, newMaxPower)

        setChatVar(triggerId, "player_combat_power", tostring(newCurrentPower))
        setState(triggerId, "player_combat_power", newCurrentPower)

        log(string.format("⚔️ 전투력 조정: %d → %d (최대: %d → %d)", currentPower, newCurrentPower, oldMaxPower, newMaxPower))
    end
end

-- 골드 파싱
function parseGoldChanges(triggerId, message)
    for changeStr in message:gmatch("%[Gold:([%+%-]%d+)%]") do
        local change = tonumber(changeStr) or 0
        local current = tonumber(getChatVar(triggerId, "player_gold")) or 0
        local new = math.max(0, current + change)

        setChatVar(triggerId, "player_gold", tostring(new))

        -- 변경량 추적
        local prevChange = tonumber(getChatVar(triggerId, "player_gold_change")) or 0
        setChatVar(triggerId, "player_gold_change", tostring(prevChange + change))

        log(string.format("💰 골드 %+d | 현재: %d", change, new))
    end
end

-- 경험치 파싱 및 레벨업 체크
function parseExpChanges(triggerId, message)
    -- [EXP:+100] 형식 파싱
    for changeStr in message:gmatch("%[EXP:([%+%-]%d+)%]") do
        local change = tonumber(changeStr) or 0
        local current = tonumber(getChatVar(triggerId, "player_exp")) or 0
        local new = math.max(0, current + change)

        setChatVar(triggerId, "player_exp", tostring(new))

        -- 변경량 추적
        local prevChange = tonumber(getChatVar(triggerId, "player_exp_change")) or 0
        setChatVar(triggerId, "player_exp_change", tostring(prevChange + change))

        log(string.format("⭐ 경험치 %+d | 현재: %d", change, new))

        if change > 0 then
            checkLevelUp(triggerId)
        end
    end

    -- [Level:1] 형식 파싱 (직접 레벨 설정)
    for levelStr in message:gmatch("%[Level:(%d+)%]") do
        local newLevel = tonumber(levelStr) or 1
        local currentLevel = tonumber(getChatVar(triggerId, "player_level")) or 0

        if newLevel ~= currentLevel then
            setState(triggerId, "player_level", newLevel)
            setChatVar(triggerId, "player_level", tostring(newLevel))

            -- 스냅샷도 즉시 업데이트 (리롤 시 복원되지 않도록)
            setChatVar(triggerId, "snapshot_player_level", tostring(newLevel))

            log(string.format("⭐ 레벨 설정: %d → %d", currentLevel, newLevel))
        end
    end
end

-- 전투력 회복 파싱
function parseHeal(triggerId, message)
    for amountStr in message:gmatch("%[Heal:(%d+)%]") do
        local healAmount = tonumber(amountStr) or 0

        -- 현재 전투력과 최대 전투력
        local maxPower = calculateCombatPower(triggerId)
        local currentPower = tonumber(getChatVar(triggerId, "player_combat_power")) or maxPower

        -- 회복 적용 (최대값 초과 불가)
        local newPower = math.min(maxPower, currentPower + healAmount)
        local actualHeal = newPower - currentPower

        setChatVar(triggerId, "player_combat_power", tostring(newPower))
        setState(triggerId, "player_combat_power", newPower)

        log(string.format("💚 전투력 회복 +%d | 현재: %d/%d", actualHeal, newPower, maxPower))

        -- 회복 후 부상 상태 업데이트
        updateInjuryEffect(triggerId)
    end
end

-- 레벨업 체크 및 처리
function checkLevelUp(triggerId)
    local currentLevel = tonumber(getChatVar(triggerId, "player_level")) or 1
    local currentExp = tonumber(getChatVar(triggerId, "player_exp")) or 0

    local nextLevel = currentLevel + 1

    -- 최대 레벨 체크 (레벨 20)
    if nextLevel > 20 then
        setChatVar(triggerId, "player_exp_to_next", "MAX")
        return
    end

    local expRequired = expTable[nextLevel]

    if currentExp >= expRequired then
        -- 레벨업!
        setChatVar(triggerId, "player_level", tostring(nextLevel))

        -- 다음 레벨 경험치 계산
        if nextLevel < 20 then
            local nextExpRequired = expTable[nextLevel + 1]
            setChatVar(triggerId, "player_exp_to_next", tostring(nextExpRequired - currentExp))
        else
            setChatVar(triggerId, "player_exp_to_next", "MAX")
        end

        log(string.format("🎉 레벨 업! %d → %d", currentLevel, nextLevel))

        -- 재귀 호출로 다중 레벨업 처리
        if nextLevel < 20 then
            checkLevelUp(triggerId)
        end
    else
        -- 다음 레벨까지 남은 경험치
        setChatVar(triggerId, "player_exp_to_next", tostring(expRequired - currentExp))
    end
end

-- 아이템 리스트 파싱 (문자열 → 테이블)
function parseItemList(itemsStr)
    local items = {}
    if not itemsStr or itemsStr == "" then return items end

    for entry in itemsStr:gmatch("[^,]+") do
        local name, count = entry:match("([^:]+):(%d+)")
        if name and count then
            items[name] = tonumber(count)
        end
    end
    return items
end

-- 아이템 리스트 직렬화 (테이블 → 문자열)
function serializeItemList(items)
    local parts = {}
    for name, count in pairs(items) do
        if count > 0 then
            table.insert(parts, name .. ":" .. count)
        end
    end
    table.sort(parts)
    return table.concat(parts, ",")
end

-- 아이템 슬롯 변수 업데이트 (버튼 텍스트용)
function updateItemSlotVars(triggerId)
    local itemsStr = getChatVar(triggerId, "player_items") or ""
    local items = parseItemList(itemsStr)

    -- 아이템을 정렬된 배열로 변환
    local sortedItems = {}
    for name, count in pairs(items) do
        if count > 0 then
            table.insert(sortedItems, {name = name, count = count})
        end
    end
    table.sort(sortedItems, function(a, b) return a.name < b.name end)

    -- 각 슬롯 변수 설정 (최대 15개)
    for i = 1, 15 do
        if sortedItems[i] then
            local itemName = sortedItems[i].name
            local itemCount = sortedItems[i].count
            setChatVar(triggerId, "player_item_slot_" .. i .. "_name", itemName)
            setState(triggerId, "player_item_slot_" .. i .. "_name", itemName)
            setChatVar(triggerId, "player_item_slot_" .. i .. "_count", tostring(itemCount))
            setState(triggerId, "player_item_slot_" .. i .. "_count", tostring(itemCount))
        else
            -- 빈 슬롯
            setChatVar(triggerId, "player_item_slot_" .. i .. "_name", "")
            setState(triggerId, "player_item_slot_" .. i .. "_name", "")
            setChatVar(triggerId, "player_item_slot_" .. i .. "_count", "0")
            setState(triggerId, "player_item_slot_" .. i .. "_count", "0")
        end
    end
end

-- 아이템 추가
function addItem(triggerId, itemName, quantity, effect)
    local itemsStr = getChatVar(triggerId, "player_items") or ""
    local items = parseItemList(itemsStr)

    items[itemName] = (items[itemName] or 0) + quantity

    setChatVar(triggerId, "player_items", serializeItemList(items))

    -- 슬롯 변수 업데이트
    updateItemSlotVars(triggerId)

    -- AI가 생성한 아이템 효과 저장
    if effect and effect ~= "" then
        setChatVar(triggerId, "item_effect_" .. itemName, effect)
        log(string.format("📦 아이템 획득: %s x%d (효과: %s)", itemName, quantity, effect))
    else
        log(string.format("📦 아이템 획득: %s x%d", itemName, quantity))
    end
end

-- 아이템 제거
function removeItem(triggerId, itemName, quantity)
    local itemsStr = getChatVar(triggerId, "player_items") or ""
    local items = parseItemList(itemsStr)

    local currentCount = items[itemName] or 0
    if currentCount >= quantity then
        items[itemName] = currentCount - quantity
        setChatVar(triggerId, "player_items", serializeItemList(items))

        -- 슬롯 변수 업데이트
        updateItemSlotVars(triggerId)

        log(string.format("🗑️ 아이템 제거: %s x%d", itemName, quantity))
        return true
    else
        log(string.format("❌ 아이템 부족: %s (보유: %d, 필요: %d)", itemName, currentCount, quantity))
        return false
    end
end

-- 아이템 사용은 로어북 기반 시스템으로 처리됨
-- /use 명령어 → using_item 설정 → 로어북 활성화 → AI 응답 → 시스템 처리

-- 아이템 태그 파싱
function parseItems(triggerId, message)
    -- 형식: [Item:Add:name:qty:type:value:duration:desc] 또는 [Item:Remove:name:qty]
    -- AI가 아이템 생성 시 효과를 정의: [Item:Add:힘의물약:1:str_bonus:10:3:근육이 불끈]
    for itemTag in message:gmatch("%[Item:[^%]]+%]") do
        local action, name, qty, effect = itemTag:match("%[Item:([^:]+):([^:]+):(%d+):?([^%]]*)%]")

        if action and name and qty then
            qty = tonumber(qty) or 1

            if action == "Add" then
                addItem(triggerId, name, qty, effect)  -- AI 생성 효과 전달
            elseif action == "Remove" then
                removeItem(triggerId, name, qty)
            end
            -- 주의: Item:Use 액션은 더 이상 지원하지 않음
            -- 아이템 사용은 /use 명령어 + 로어북으로 처리
        end
    end
end

-- Trait ID 목록 파싱
function parseTraitIdList(traitsStr)
    local traitIds = {}
    if not traitsStr or traitsStr == "" then return traitIds end

    for traitId in traitsStr:gmatch("[^,]+") do
        table.insert(traitIds, traitId)
    end
    return traitIds
end

-- Trait ID 목록 직렬화
function serializeTraitIdList(traitIds)
    table.sort(traitIds)
    return table.concat(traitIds, ",")
end

-- Trait 추가
function addTrait(triggerId, traitName, traitDesc)
    -- Trait ID 생성 (이름 기반)
    local traitId = traitName:gsub("%s+", "_"):lower()

    local traitsStr = getChatVar(triggerId, "player_traits") or ""
    local traitIds = parseTraitIdList(traitsStr)

    -- 중복 체크
    for _, existingId in ipairs(traitIds) do
        if existingId == traitId then
            log(string.format("⚠️ Trait 이미 보유: %s", traitName))
            return false
        end
    end

    -- Trait 추가
    table.insert(traitIds, traitId)
    setChatVar(triggerId, "player_traits", serializeTraitIdList(traitIds))

    -- Trait 세부 정보 저장 (이름, 설명만)
    setChatVar(triggerId, "trait_" .. traitId .. "_name", traitName)
    setChatVar(triggerId, "trait_" .. traitId .. "_desc", traitDesc)

    log(string.format("🏆 Trait 획득: %s - %s", traitName, traitDesc))

    -- Display 변수 자동 업데이트
    updateTraitsDisplay(triggerId)

    return true
end

-- Trait 제거
function removeTrait(triggerId, traitId)
    local traitsStr = getChatVar(triggerId, "player_traits") or ""
    local traitIds = parseTraitIdList(traitsStr)

    local found = false
    local newTraitIds = {}

    for _, existingId in ipairs(traitIds) do
        if existingId == traitId then
            found = true
        else
            table.insert(newTraitIds, existingId)
        end
    end

    if found then
        setChatVar(triggerId, "player_traits", serializeTraitIdList(newTraitIds))

        local traitName = getChatVar(triggerId, "trait_" .. traitId .. "_name") or traitId
        log(string.format("🗑️ Trait 제거: %s", traitName))

        -- Display 변수 자동 업데이트
        updateTraitsDisplay(triggerId)

        return true
    else
        log(string.format("⚠️ Trait 미보유: %s", traitId))
        return false
    end
end

-- Trait Display 변수 업데이트
function updateTraitsDisplay(triggerId)
    local traitsStr = getChatVar(triggerId, "player_traits") or ""
    local traitIds = parseTraitIdList(traitsStr)

    -- 특성이 없으면 빈 문자열
    if #traitIds == 0 then
        setChatVar(triggerId, "player_traits_display", "")
        setState(triggerId, "player_traits_display", "")
        setChatVar(triggerId, "player_traits_html", "<span style='color: #666; font-style: italic;'>특성 없음</span>")
        setState(triggerId, "player_traits_html", "<span style='color: #666; font-style: italic;'>특성 없음</span>")
        return
    end

    -- 평문 리스트 생성 (하위 호환성 유지)
    local parts = {}
    for _, traitId in ipairs(traitIds) do
        local traitName = getChatVar(triggerId, "trait_" .. traitId .. "_name") or traitId
        local traitDesc = getChatVar(triggerId, "trait_" .. traitId .. "_desc") or ""

        if traitDesc ~= "" then
            table.insert(parts, traitName .. ": " .. traitDesc)
        else
            table.insert(parts, traitName)
        end
    end

    -- 평문으로 저장 (하위 호환성)
    local displayText = table.concat(parts, "\n")
    setChatVar(triggerId, "player_traits_display", displayText)
    setState(triggerId, "player_traits_display", displayText)

    -- HTML 생성
    local traitsHtml = ""
    for _, traitId in ipairs(traitIds) do
        local traitName = getChatVar(triggerId, "trait_" .. traitId .. "_name") or traitId
        local traitDesc = getChatVar(triggerId, "trait_" .. traitId .. "_desc") or ""

        if traitDesc ~= "" then
            traitsHtml = traitsHtml .. string.format(
                "<div style='margin-bottom: 8px; padding: 8px; background: rgba(0, 212, 255, 0.05); border-left: 3px solid #00d4ff; border-radius: 4px;'><div style='color: #00d4ff; font-weight: 600; margin-bottom: 4px;'>%s</div><div style='color: #aaa; font-size: 0.9em;'>%s</div></div>",
                traitName, traitDesc
            )
        else
            traitsHtml = traitsHtml .. string.format(
                "<div style='margin-bottom: 8px; padding: 8px; background: rgba(0, 212, 255, 0.05); border-left: 3px solid #00d4ff; border-radius: 4px;'><div style='color: #00d4ff; font-weight: 600;'>%s</div></div>",
                traitName
            )
        end
    end

    setChatVar(triggerId, "player_traits_html", traitsHtml)
    setState(triggerId, "player_traits_html", traitsHtml)
end

-- 단일 Trait 파싱
function parseTrait(triggerId, traitTag)
    -- 형식 1: [Trait:Add:Name:Description] 또는 [Trait:Name:Description] (하위 호환)
    -- 형식 2: [Trait:Merge:OldName1+OldName2→NewName:NewDescription]

    -- Merge 형식 먼저 체크
    local mergePart, newName, newDesc = traitTag:match("%[Trait:Merge:([^→]+)→([^:]+):([^%]]+)%]")

    if mergePart and newName and newDesc then
        -- 합성할 특성 이름들 추출 (+ 또는 x로 구분)
        local oldNames = {}
        for name in mergePart:gmatch("[^+x]+") do
            local trimmed = name:match("^%s*(.-)%s*$")  -- 공백 제거
            if trimmed and trimmed ~= "" then
                table.insert(oldNames, trimmed)
            end
        end

        -- 기존 특성들 제거
        local removed = {}
        for _, oldName in ipairs(oldNames) do
            if removeTrait(triggerId, oldName) then
                table.insert(removed, oldName)
            end
        end

        -- 새 특성 추가
        addTrait(triggerId, newName, newDesc)

        if #removed > 0 then
            log(string.format("🔄 Trait 합성: [%s] → %s", table.concat(removed, " + "), newName))
        end
        return
    end

    -- Add 형식 또는 기존 형식
    local action, traitName, traitDesc = traitTag:match("%[Trait:([^:]+):([^:]+):([^%]]+)%]")

    if action == "Add" and traitName and traitDesc then
        addTrait(triggerId, traitName, traitDesc)
        return
    end

    -- 하위 호환: [Trait:Name:Description]
    local name, desc = traitTag:match("%[Trait:([^:]+):([^%]]+)%]")
    if name and desc then
        addTrait(triggerId, name, desc)
    end
end

-- Trait 태그 파싱
function parseTraits(triggerId, message)
    for traitTag in message:gmatch("%[Trait:[^%]]+%]") do
        parseTrait(triggerId, traitTag)
    end
end

-- Exam 태그 파싱
function parseExams(triggerId, message)
    -- 형식: [Exam:midterm:87:23] or [Exam:final:92:15]
    for examType, score, rank in message:gmatch("%[Exam:(%w+):(%d+):(%d+)%]") do
        -- 시험 결과 저장
        setChatVar(triggerId, "exam_" .. examType .. "_score", score)
        setChatVar(triggerId, "exam_" .. examType .. "_rank", rank)

        log(string.format("📝 %s 시험 결과: %s점 (120명 중 %s위)",
            examType == "midterm" and "중간고사" or "기말고사", score, rank))
    end
end

-- ============================================
-- 효과 태그 파싱
-- ============================================

-- 새 형식: [Effect:Add:Name:StatBonus] 또는 [Effect:Remove:Name]
-- 예: [Effect:Add:미라벨의 축복:str+15], [Effect:Remove:독]
function parseEffects(triggerId, message)
    for effectTag in message:gmatch("%[Effect:[^%]]+%]") do
        parseEffect(triggerId, effectTag)
    end
end

function parseEffect(triggerId, tag)
    -- [Effect:Merge:OldName1+OldName2→NewName:StatBonus] 형식 먼저 체크
    local mergePart, newName, statBonus = tag:match("%[Effect:Merge:([^→]+)→([^:]+):([^%]]+)%]")

    if mergePart and newName and statBonus then
        -- 합성할 효과 이름들 추출 (+ 또는 x로 구분)
        local oldNames = {}
        for name in mergePart:gmatch("[^+x]+") do
            local trimmed = name:match("^%s*(.-)%s*$")  -- 공백 제거
            if trimmed and trimmed ~= "" then
                table.insert(oldNames, trimmed)
            end
        end

        -- 기존 효과들 제거
        local removed = {}
        for _, oldName in ipairs(oldNames) do
            if removeEffect(triggerId, oldName) then
                table.insert(removed, oldName)
            end
        end

        -- 새 효과 추가 (Add와 동일한 로직)
        local stat, sign, valueStr = statBonus:match("(%w+)([%+%-])(%d+)")

        if stat and sign and valueStr then
            local value = tonumber(valueStr) or 0
            if sign == "-" then
                value = -value
            end

            local effectType = stat:lower() .. "_bonus"
            local desc = newName
            local duration = 0

            addEffect(triggerId, newName, effectType, value, duration, desc)

            if #removed > 0 then
                log(string.format("🔄 Effect 합성: [%s] → %s (%s %+d)",
                    table.concat(removed, " + "), newName, stat:upper(), value))
            end
        else
            -- 표시용 Effect
            addEffect(triggerId, newName, "display", 0, 0, statBonus)

            if #removed > 0 then
                log(string.format("🔄 Effect 합성 (표시용): [%s] → %s",
                    table.concat(removed, " + "), newName))
            end
        end
        return
    end

    -- [Effect:Add:Name:StatBonus] 형식 파싱
    local actionAdd, name, statBonus = tag:match("%[Effect:(Add):([^:]+):([^%]]+)%]")

    if actionAdd == "Add" and name and statBonus then
        -- StatBonus 파싱 시도: "str+15" → type="str_bonus", value=15
        local stat, sign, valueStr = statBonus:match("(%w+)([%+%-])(%d+)")

        if stat and sign and valueStr then
            -- 스탯 보너스 형식 (str+15, vit-5 등)
            local value = tonumber(valueStr) or 0
            if sign == "-" then
                value = -value
            end

            local effectType = stat:lower() .. "_bonus"  -- str → str_bonus
            local desc = name  -- 효과 이름을 설명으로 사용
            local duration = 0  -- 영구 효과 (나중에 Remove로 제거)

            addEffect(triggerId, name, effectType, value, duration, desc)
            log(string.format("✨ Effect 추가: %s (%s %+d)", name, stat:upper(), value))
        else
            -- 스탯 보너스 없는 순수 표시용 Effect (출혈 멈춤, 기력 회복 등)
            addEffect(triggerId, name, "display", 0, 0, statBonus)
            log(string.format("✨ Effect 추가 (표시용): %s (%s)", name, statBonus))
        end
        return
    end

    -- [Effect:Remove:Name] 형식 파싱
    local actionRemove, removeName = tag:match("%[Effect:(Remove):([^%]]+)%]")

    if actionRemove == "Remove" and removeName then
        removeEffect(triggerId, removeName)
        log(string.format("💫 Effect 제거: %s", removeName))
    end
end

-- ============================================
-- 전투 시스템 (Combat System)
-- ============================================

-- 플레이어 전투력 계산
function calculateCombatPower(triggerId)
    local str = getStatWithEffects(triggerId, "str")
    local dex = getStatWithEffects(triggerId, "dex")
    local int = getStatWithEffects(triggerId, "int")
    local luk = getStatWithEffects(triggerId, "luk")

    local power = (str * 2) + (dex * 2) + int + luk

    return power
end

-- 난이도 판정 (비율 기반) - 엄격한 밸런싱
function getDifficulty(statPower, enemyPower)
    if enemyPower == 0 then
        return "Very Easy"
    end

    local ratio = statPower / enemyPower

    if ratio >= 2.5 then
        return "Very Easy"
    elseif ratio >= 2.0 then
        return "Easy"
    elseif ratio >= 1.3 then
        return "Normal"
    elseif ratio >= 0.9 then
        return "Hard"
    else
        return "Very Hard"
    end
end

-- 전투 특성 찾기
function findCombatTrait(triggerId)
    local traitsDisplay = getChatVar(triggerId, "player_traits_display") or ""

    -- 전투 관련 키워드 목록 (우선순위 순)
    local combatKeywords = {
        -- 근접 전투
        {pattern = "검술", difficulty = "Easy", type = "melee"},
        {pattern = "격투", difficulty = "Easy", type = "melee"},
        {pattern = "무술", difficulty = "Easy", type = "melee"},
        {pattern = "전사", difficulty = "Easy", type = "melee"},

        -- 마법
        {pattern = "마법", difficulty = "Normal", type = "magic"},
        {pattern = "화염", difficulty = "Normal", type = "magic"},
        {pattern = "냉기", difficulty = "Normal", type = "magic"},
        {pattern = "번개", difficulty = "Normal", type = "magic"},
        {pattern = "치유", difficulty = "Easy", type = "magic"},

        -- 은신/기습
        {pattern = "은신", difficulty = "Easy", type = "stealth"},
        {pattern = "암살", difficulty = "Normal", type = "stealth"},
        {pattern = "그림자", difficulty = "Easy", type = "stealth"},

        -- 지식/전술
        {pattern = "전술", difficulty = "Easy", type = "tactical"},
        {pattern = "지식", difficulty = "Normal", type = "tactical"},
        {pattern = "공학", difficulty = "Normal", type = "tactical"},

        -- 특수
        {pattern = "야수", difficulty = "Normal", type = "special"},
        {pattern = "변신", difficulty = "Hard", type = "special"},
        {pattern = "정령", difficulty = "Normal", type = "special"}
    }

    -- 특성 목록을 줄 단위로 분리
    for line in traitsDisplay:gmatch("[^\n]+") do
        -- 각 키워드 확인
        for _, keywordData in ipairs(combatKeywords) do
            if line:find(keywordData.pattern) then
                -- 특성 이름 추출 (콜론 앞 부분 또는 첫 단어)
                local traitName = line:match("^([^:]+)") or line:match("^(%S+)")

                if traitName then
                    traitName = traitName:gsub("^%s*", ""):gsub("%s*$", "")  -- 공백 제거

                    return {
                        name = traitName,
                        difficulty = keywordData.difficulty,
                        traitType = keywordData.type,
                        fullDescription = line
                    }
                end
            end
        end
    end

    return nil  -- 전투 관련 특성 없음
end

-- 전투 선택지 준비 (난이도 계산)
function prepareCombatChoices(triggerId, enemyPower)
    local str = getStatWithEffects(triggerId, "str")
    local dex = getStatWithEffects(triggerId, "dex")
    local int = getStatWithEffects(triggerId, "int")
    local cha = getStatWithEffects(triggerId, "cha")
    local luk = getStatWithEffects(triggerId, "luk")

    -- 플레이어 전투력
    local playerPower = calculateCombatPower(triggerId)

    -- 각 스탯별 난이도 계산
    setChatVar(triggerId, "combat_str_difficulty", getDifficulty(str * 2, enemyPower))
    setChatVar(triggerId, "combat_dex_difficulty", getDifficulty(dex * 2, enemyPower * 1.3))
    setChatVar(triggerId, "combat_int_difficulty", getDifficulty(int * 2, enemyPower * 0.7))
    setChatVar(triggerId, "combat_cha_difficulty", getDifficulty(cha, enemyPower * 0.5))
    setChatVar(triggerId, "combat_luk_difficulty", "Very Hard")  -- 항상 Very Hard

    setState(triggerId, "combat_str_difficulty", getChatVar(triggerId, "combat_str_difficulty"))
    setState(triggerId, "combat_dex_difficulty", getChatVar(triggerId, "combat_dex_difficulty"))
    setState(triggerId, "combat_int_difficulty", getChatVar(triggerId, "combat_int_difficulty"))
    setState(triggerId, "combat_cha_difficulty", getChatVar(triggerId, "combat_cha_difficulty"))
    setState(triggerId, "combat_luk_difficulty", "Very Hard")

    -- 특성 확인 및 6번 선택지 생성
    local traitChoice = findCombatTrait(triggerId)

    if traitChoice then
        -- 특성이 있으면 특성 선택지
        setChatVar(triggerId, "combat_6th_type", "trait")
        setChatVar(triggerId, "combat_6th_name", traitChoice.name)
        setChatVar(triggerId, "combat_6th_difficulty", traitChoice.difficulty)

        setState(triggerId, "combat_6th_type", "trait")
        setState(triggerId, "combat_6th_name", traitChoice.name)
        setState(triggerId, "combat_6th_difficulty", traitChoice.difficulty)
    else
        -- 특성이 없으면 도망
        setChatVar(triggerId, "combat_6th_type", "flee")
        setChatVar(triggerId, "combat_6th_name", "도망")
        setChatVar(triggerId, "combat_6th_difficulty", "Easy")

        setState(triggerId, "combat_6th_type", "flee")
        setState(triggerId, "combat_6th_name", "도망")
        setState(triggerId, "combat_6th_difficulty", "Easy")
    end

    -- 전투 정보 저장
    setChatVar(triggerId, "combat_player_power", playerPower)
    setState(triggerId, "combat_player_power", playerPower)

    log(string.format("⚔️ 전투 준비: 플레이어 파워 %d vs 적 파워 %d", playerPower, enemyPower))
end

-- 난이도에 따른 목표값 반환
function getDifficultyTarget(difficulty)
    if difficulty == "Very Easy" then
        return 5
    elseif difficulty == "Easy" then
        return 10
    elseif difficulty == "Normal" then
        return 15
    elseif difficulty == "Hard" then
        return 20
    else  -- Very Hard
        return 25
    end
end

-- 전투 선택지 버튼 클릭 시 실행되는 함수
-- 선택지 주사위 굴림 (combat_active와 독립적으로 작동)
function rollChoiceDice(triggerId, choiceNum, stat, desc, diff)
    log(string.format("🎲 선택: %d번 - [%s] %s (%s)", choiceNum, stat, desc, diff))

    -- 능력치 이름 표준화
    local statName = stat:lower()

    -- Escape/Flee는 LUK으로 처리
    if statName == "escape" or statName == "flee" or statName == "run" or statName == "도망" then
        statName = "luk"
    elseif statName == "str" or statName == "dex" or statName == "int" or
           statName == "cha" or statName == "luk" or statName == "vit" then
        -- 표준 능력치
    else
        -- 기타 미인식 능력치 -> LUK으로 처리
        log(string.format("⚠️ 미인식 능력치 '%s' → LUK으로 처리", stat))
        statName = "luk"
    end

    -- 주사위 굴림
    local success, critical, fumble, roll, total = rollCombatCheck(triggerId, statName, diff)

    -- 결과 변수 저장 (메인 AI가 읽을 변수)
    setChatVar(triggerId, "combat_last_choice_num", tostring(choiceNum))
    setChatVar(triggerId, "combat_last_choice_stat", stat)
    setChatVar(triggerId, "combat_last_choice_desc", desc)
    setChatVar(triggerId, "combat_last_choice_diff", diff)
    setChatVar(triggerId, "combat_last_roll", tostring(roll))

    local statValue = getStatWithEffects(triggerId, statName)
    local bonus = math.floor((statValue - 10) / 2)
    bonus = math.max(-3, math.min(10, bonus))

    setChatVar(triggerId, "combat_last_bonus", tostring(bonus))
    setChatVar(triggerId, "combat_last_total", tostring(total))
    setChatVar(triggerId, "combat_last_target", tostring(getDifficultyTarget(diff)))
    setChatVar(triggerId, "combat_last_result", success and "성공" or "실패")
    setChatVar(triggerId, "combat_last_critical", critical and "true" or "false")
    setChatVar(triggerId, "combat_last_fumble", fumble and "true" or "false")

    -- 적 추적 시스템이 활성화되어 있으면 전투 결과 처리
    local combatActive = getChatVar(triggerId, "combat_active")
    if combatActive == "true" then
        local enemyPower = tonumber(getChatVar(triggerId, "combat_enemy_power")) or 0
        processCombatResult(triggerId, success, critical, fumble, diff, enemyPower)
    end

    log(string.format("✅ 주사위 결과: %d + %d = %d → %s", roll, bonus, total, success and "성공" or "실패"))

    return true
end

-- (Legacy) 전투 시스템용 주사위 - 적 추적 시스템 사용 시
function rollCombat(triggerId, choiceNum)
    -- 전투 활성 여부 확인
    local combatActive = getChatVar(triggerId, "combat_active")
    if combatActive ~= "true" then
        log("⚠️ 전투가 활성화되지 않음")
        return false
    end

    -- 선택지 정보 가져오기
    local stat = getChatVar(triggerId, "combat_choice_" .. choiceNum .. "_stat")
    local desc = getChatVar(triggerId, "combat_choice_" .. choiceNum .. "_desc")
    local diff = getChatVar(triggerId, "combat_choice_" .. choiceNum .. "_diff")

    if not stat or stat == "" then
        log("⚠️ 유효하지 않은 선택지: " .. choiceNum)
        return false
    end

    -- 새 함수로 위임
    return rollChoiceDice(triggerId, choiceNum, stat, desc, diff)
end

-- 주사위 굴림 및 체크
function rollCombatCheck(triggerId, statName, difficulty)
    -- 1d20 주사위
    local roll = math.random(1, 20)

    -- 스탯 보너스 (D&D 방식)
    local statValue = getStatWithEffects(triggerId, statName)
    local bonus = math.floor((statValue - 10) / 2)

    -- 보너스 제한 (-3 ~ +10)
    bonus = math.max(-3, math.min(10, bonus))

    -- 총합
    local total = roll + bonus

    -- 난이도별 목표값
    local target = getDifficultyTarget(difficulty)

    -- 성공 판정
    local success = (total >= target)

    -- 크리티컬/대실패
    local critical = (roll == 20)
    local fumble = (roll == 1)

    -- 크리티컬은 자동 성공, 대실패는 자동 실패
    if critical then
        success = true
    elseif fumble then
        success = false
    end

    log(string.format("🎲 주사위: %d + 보너스 %d = %d vs 목표 %d (%s) [%s]",
        roll, bonus, total, target, difficulty, success and "성공" or "실패"))

    return success, critical, fumble, roll, total
end

-- 몬스터 파워에 따른 보상 계산
function getCombatRewards(enemyPower)
    local gold, exp

    if enemyPower < 60 then
        -- 약함
        gold = 50
        exp = 20
    elseif enemyPower < 90 then
        -- 보통
        gold = 100
        exp = 50
    elseif enemyPower < 120 then
        -- 강함
        gold = 200
        exp = 100
    elseif enemyPower < 160 then
        -- 정예
        gold = 400
        exp = 200
    else
        -- 보스
        gold = 800
        exp = 500
    end

    return gold, exp
end

-- 전투 결과 처리
function processCombatResult(triggerId, success, critical, fumble, difficulty, enemyPower)
    local playerDamage = 0  -- 플레이어가 받는 데미지
    local enemyDamage = 0   -- 적이 받는 데미지
    local combatState = "Neutral"
    local combatEnded = false
    local giveRewards = false

    if critical then
        -- 크리티컬: 적에게 큰 데미지, 플레이어 무상
        enemyDamage = 150
        playerDamage = 0
        combatState = "Critical"
        log("💥 크리티컬!")

    elseif fumble then
        -- 대실패: 플레이어가 큰 데미지
        playerDamage = 120
        enemyDamage = 0
        combatState = "Fumble"
        log("💀 대실패!")

    elseif success then
        -- 성공 - 난이도별 데미지
        if difficulty == "Very Easy" or difficulty == "Easy" then
            enemyDamage = 80
            playerDamage = 20
            combatState = "Advantageous"
            log("✅ 성공! 큰 타격!")

        elseif difficulty == "Normal" then
            enemyDamage = 60
            playerDamage = 40
            combatState = "Neutral"
            log("✅ 성공!")

        elseif difficulty == "Hard" then
            enemyDamage = 50
            playerDamage = 60
            combatState = "Neutral"
            log("⚡ 성공! 하지만 피해도 입음")

        else  -- Very Hard
            enemyDamage = 40
            playerDamage = 80
            combatState = "Disadvantageous"
            log("😰 간신히 성공...")
        end

    else
        -- 실패 - 적만 데미지 줌
        playerDamage = 100
        enemyDamage = 0
        combatState = "Disadvantageous"
        log("❌ 실패!")
    end

    -- 적 HP 감소 및 승리 체크
    local currentEnemyHp = tonumber(getChatVar(triggerId, "combat_enemy_hp")) or enemyPower
    local newEnemyHp = math.max(0, currentEnemyHp - enemyDamage)

    setChatVar(triggerId, "combat_enemy_hp", tostring(newEnemyHp))
    setState(triggerId, "combat_enemy_hp", newEnemyHp)

    if newEnemyHp <= 0 then
        combatEnded = true
        giveRewards = true
        combatState = "Victory"
        log(string.format("🏆 승리! 적 HP: %d → 0", currentEnemyHp))
    else
        log(string.format("⚔️ 적 HP: %d → %d (-%d)", currentEnemyHp, newEnemyHp, enemyDamage))
    end

    -- 플레이어 전투력 감소 및 패배 체크
    local currentPower = tonumber(getChatVar(triggerId, "player_combat_power")) or calculateCombatPower(triggerId)
    local newPower = math.max(0, currentPower - playerDamage)

    setChatVar(triggerId, "player_combat_power", tostring(newPower))
    setState(triggerId, "player_combat_power", newPower)

    log(string.format("💪 플레이어 전투력: %d → %d (-%d)", currentPower, newPower, playerDamage))

    if newPower <= 0 and not combatEnded then
        combatEnded = true
        giveRewards = false
        combatState = "Defeat"
        log("💔 패배! 전투력 0")
    end

    -- 전투 종료 시 부상 Effect 업데이트
    if combatEnded then
        updateInjuryEffect(triggerId)
    end

    -- 전투 상태 저장
    setChatVar(triggerId, "combat_state", combatState)
    setState(triggerId, "combat_state", combatState)

    -- 데미지 정보 저장
    setChatVar(triggerId, "combat_player_damage", tostring(playerDamage))
    setState(triggerId, "combat_player_damage", playerDamage)
    setChatVar(triggerId, "combat_enemy_damage", tostring(enemyDamage))
    setState(triggerId, "combat_enemy_damage", enemyDamage)

    -- 보상 지급
    if giveRewards then
        local baseGold, baseExp = getCombatRewards(enemyPower)

        -- 크리티컬 보너스
        if critical then
            baseGold = math.floor(baseGold * 1.5)
            baseExp = math.floor(baseExp * 1.5)
        end

        -- 골드 추가
        local currentGold = getChatVar(triggerId, "player_gold") or 0
        local newGold = currentGold + baseGold
        setChatVar(triggerId, "player_gold", newGold)
        setState(triggerId, "player_gold", newGold)

        -- 경험치 추가
        local currentExp = getChatVar(triggerId, "player_exp") or 0
        local newExp = currentExp + baseExp
        setChatVar(triggerId, "player_exp", newExp)
        setState(triggerId, "player_exp", newExp)

        -- 레벨업 체크
        checkLevelUp(triggerId)

        log(string.format("💰 보상: Gold +%d, EXP +%d", baseGold, baseExp))
    end

    -- 전투 종료 처리
    if combatEnded then
        setChatVar(triggerId, "combat_active", "false")
        setState(triggerId, "combat_active", "false")
        log("🏁 전투 종료")
    else
        -- 난이도 조정
        if combatState == "Advantageous" then
            adjustCombatDifficulty(triggerId, -1)  -- 1단계 쉬워짐
        elseif combatState == "Disadvantageous" then
            adjustCombatDifficulty(triggerId, 1)   -- 1단계 어려워짐
        end
    end

    return combatEnded, giveRewards
end

-- 난이도 조정 (유리/불리한 상황)
function adjustCombatDifficulty(triggerId, adjustment)
    local difficulties = {"Very Easy", "Easy", "Normal", "Hard", "Very Hard"}
    local difficultyMap = {
        ["Very Easy"] = 1,
        ["Easy"] = 2,
        ["Normal"] = 3,
        ["Hard"] = 4,
        ["Very Hard"] = 5
    }

    -- 각 스탯별 난이도 조정
    local stats = {"str", "dex", "int", "cha", "luk"}
    for _, stat in ipairs(stats) do
        local varName = "combat_" .. stat .. "_difficulty"
        local currentDiff = getChatVar(triggerId, varName) or "Normal"
        local currentLevel = difficultyMap[currentDiff] or 3

        local newLevel = math.max(1, math.min(5, currentLevel + adjustment))
        local newDiff = difficulties[newLevel]

        setChatVar(triggerId, varName, newDiff)
        setState(triggerId, varName, newDiff)
    end

    -- 6번 특성 선택지도 조정 (도망 제외)
    local sixthType = getChatVar(triggerId, "combat_6th_type") or "flee"
    if sixthType == "trait" then
        local currentDiff = getChatVar(triggerId, "combat_6th_difficulty") or "Normal"
        local currentLevel = difficultyMap[currentDiff] or 3

        local newLevel = math.max(1, math.min(5, currentLevel + adjustment))
        local newDiff = difficulties[newLevel]

        setChatVar(triggerId, "combat_6th_difficulty", newDiff)
        setState(triggerId, "combat_6th_difficulty", newDiff)
    end

    if adjustment > 0 then
        log(string.format("📈 난이도 상승 (%+d단계)", adjustment))
    elseif adjustment < 0 then
        log(string.format("📉 난이도 하락 (%d단계)", adjustment))
    end
end

-- 부상 Effect 자동 업데이트
function updateInjuryEffect(triggerId)
    -- 최대 전투력 계산 (현재 스탯 기반)
    local maxPower = calculateCombatPower(triggerId)

    -- 현재 전투력 가져오기
    local currentPower = tonumber(getChatVar(triggerId, "player_combat_power")) or maxPower

    -- 손실 퍼센트 계산
    local lossPct = 0
    if maxPower > 0 then
        lossPct = ((maxPower - currentPower) / maxPower) * 100
    end

    -- 기존 부상 Effect 제거
    removeEffect(triggerId, "경상")
    removeEffect(triggerId, "중상")
    removeEffect(triggerId, "위급")

    -- 손실 퍼센트에 따른 부상 상태 판정
    if lossPct >= 60 then
        -- 60% 이상 손실: 위급 (생명 위험)
        addEffect(triggerId, "위급", "str_bonus", -10, 0, "생명이 위험한 상태")
        addEffect(triggerId, "위급", "dex_bonus", -8, 0, "")
        log(string.format("🩸 부상 상태: 위급 (전투력 손실 %.1f%%)", lossPct))

    elseif lossPct >= 35 then
        -- 35% 이상 손실: 중상 (심각한 부상)
        addEffect(triggerId, "중상", "str_bonus", -5, 0, "심각한 부상")
        addEffect(triggerId, "중상", "dex_bonus", -4, 0, "")
        log(string.format("🩹 부상 상태: 중상 (전투력 손실 %.1f%%)", lossPct))

    elseif lossPct >= 15 then
        -- 15% 이상 손실: 경상 (가벼운 부상)
        addEffect(triggerId, "경상", "str_bonus", -3, 0, "가벼운 부상")
        addEffect(triggerId, "경상", "dex_bonus", -2, 0, "")
        log(string.format("🏥 부상 상태: 경상 (전투력 손실 %.1f%%)", lossPct))

    else
        -- 15% 미만 손실: 건강
        log(string.format("💚 건강 상태: 양호 (전투력 손실 %.1f%%)", lossPct))
    end
end

-- Combat 태그 파싱
function parseCombat(triggerId, tag)
    log(string.format("🔍 parseCombat 호출: %s", tag))

    -- [Combat:End] 처리
    if tag:match("%[Combat:End%]") then
        log("⚔️ 전투 종료")
        setChatVar(triggerId, "combat_active", "false")
        setChatVar(triggerId, "combat_enemy_name", "")
        setChatVar(triggerId, "combat_enemy_power", "0")
        setChatVar(triggerId, "combat_enemy_hp", "0")
        setChatVar(triggerId, "combat_state", "Neutral")

        setState(triggerId, "combat_active", "false")
        setState(triggerId, "combat_enemy_name", "")
        setState(triggerId, "combat_enemy_power", 0)
        setState(triggerId, "combat_enemy_hp", 0)
        setState(triggerId, "combat_state", "Neutral")

        -- 선택지는 초기화하지 않음 (선택지 시스템은 전투와 독립적으로 작동)

        log(string.format("✅ combat_active 설정: %s", getChatVar(triggerId, "combat_active")))
        return
    end

    -- [Combat:EnemyName:Power] 형식 파싱
    local enemyName, enemyPowerStr = tag:match("%[Combat:([^:]+):(%d+)%]")

    if enemyName and enemyPowerStr then
        local enemyPower = tonumber(enemyPowerStr) or 0

        log(string.format("⚔️ 전투 발생: %s (파워 %d)", enemyName, enemyPower))

        -- 플레이어 전투력: 현재 값 유지, max만 재계산
        local maxPower = calculateCombatPower(triggerId)
        local currentPower = tonumber(getChatVar(triggerId, "player_combat_power")) or maxPower
        -- 현재 전투력이 max보다 높으면 max로 제한
        if currentPower > maxPower then
            currentPower = maxPower
        end
        setChatVar(triggerId, "player_combat_power", tostring(currentPower))
        setState(triggerId, "player_combat_power", currentPower)

        -- 적 HP 초기화 (파워 = HP)
        setChatVar(triggerId, "combat_enemy_hp", tostring(enemyPower))
        setState(triggerId, "combat_enemy_hp", enemyPower)

        -- 전투 활성화
        setChatVar(triggerId, "combat_active", "true")
        setChatVar(triggerId, "combat_enemy_name", enemyName)
        setChatVar(triggerId, "combat_enemy_power", tostring(enemyPower))

        setState(triggerId, "combat_active", "true")
        setState(triggerId, "combat_enemy_name", enemyName)
        setState(triggerId, "combat_enemy_power", enemyPower)

        log(string.format("✅ 플레이어 전투력: %d", currentPower))
        log(string.format("✅ 적 HP: %d", enemyPower))
        log(string.format("✅ combat_active 설정: '%s'", getChatVar(triggerId, "combat_active")))

        -- prepareCombatChoices는 더 이상 사용하지 않음 (보조 AI가 선택지 생성)
    else
        log(string.format("⚠️ Combat 태그 파싱 실패: %s", tag))
    end
end

function parseCombats(triggerId, message)
    for combatTag in message:gmatch("%[Combat:[^%]]+%]") do
        parseCombat(triggerId, combatTag)
    end
end

-- CombatChoice 태그 파싱 및 HTML 버튼 생성
function parseCombatChoice(triggerId, choiceBlock)
    -- <CombatChoice>...</CombatChoice> 내용 추출
    local content = choiceBlock:match("<CombatChoice>(.-)</CombatChoice>")
    if not content then return end

    log("⚔️ 전투 선택지 파싱 시작")

    -- 기존 선택지 초기화 (이전 전투 데이터 제거)
    for i = 1, 6 do
        setChatVar(triggerId, "combat_choice_" .. i .. "_stat", "")
        setChatVar(triggerId, "combat_choice_" .. i .. "_desc", "")
        setChatVar(triggerId, "combat_choice_" .. i .. "_diff", "")
    end

    -- 각 선택지 라인 파싱 ([STAT|Description|Difficulty] 형식)
    local choiceIndex = 1
    for line in content:gmatch("[^\r\n]+") do
        local stat, desc, diff = line:match("%[([^|]+)|([^|]+)|([^%]]+)%]")
        if stat and desc and diff then
            setChatVar(triggerId, "combat_choice_" .. choiceIndex .. "_stat", stat)
            setChatVar(triggerId, "combat_choice_" .. choiceIndex .. "_desc", desc)
            setChatVar(triggerId, "combat_choice_" .. choiceIndex .. "_diff", diff)

            log(string.format("  선택지 %d: [%s] %s - %s", choiceIndex, stat, desc, diff))

            choiceIndex = choiceIndex + 1
            if choiceIndex > 6 then break end
        end
    end

    -- 6개 미만이면 경고
    if choiceIndex <= 6 then
        log(string.format("⚠️ 전투 선택지가 %d개만 파싱됨 (6개 필요)", choiceIndex - 1))
    end

    -- HTML 버튼 생성
    local html = "<div style='max-width:600px;margin:15px auto;padding:0 10px'>"
    for i = 1, 6 do
        local stat = getChatVar(triggerId, "combat_choice_" .. i .. "_stat") or ""
        local desc = getChatVar(triggerId, "combat_choice_" .. i .. "_desc") or ""
        local diff = getChatVar(triggerId, "combat_choice_" .. i .. "_diff") or ""

        if stat ~= "" then
            -- 능력치별 이모지
            local emoji = "⚔️"
            local statUpper = stat:upper()
            local statLower = stat:lower()

            if statUpper == "STR" then emoji = "💪"
            elseif statUpper == "DEX" then emoji = "⚡"
            elseif statUpper == "INT" then emoji = "🧠"
            elseif statUpper == "CHA" then emoji = "💬"
            elseif statUpper == "LUK" then emoji = "🍀"
            elseif statLower == "escape" or statLower == "flee" or statLower == "run" or stat == "도망" then
                emoji = "🏃"
            else
                emoji = "⚔️"  -- 기타 미인식 능력치는 기본 아이콘
            end

            -- 난이도별 색상 (그라디언트)
            local gradient = "linear-gradient(135deg, #666 0%%, #888 100%%)"
            local shadow = "0 2px 8px rgba(0,0,0,0.3)"
            if diff == "Very Easy" then
                gradient = "linear-gradient(135deg, #4CAF50 0%%, #66BB6A 100%%)"
                shadow = "0 2px 8px rgba(76,175,80,0.4)"
            elseif diff == "Easy" then
                gradient = "linear-gradient(135deg, #8BC34A 0%%, #9CCC65 100%%)"
                shadow = "0 2px 8px rgba(139,195,74,0.4)"
            elseif diff == "Normal" then
                gradient = "linear-gradient(135deg, #FFC107 0%%, #FFD54F 100%%)"
                shadow = "0 2px 8px rgba(255,193,7,0.4)"
            elseif diff == "Hard" then
                gradient = "linear-gradient(135deg, #FF9800 0%%, #FFB74D 100%%)"
                shadow = "0 2px 8px rgba(255,152,0,0.4)"
            elseif diff == "Very Hard" then
                gradient = "linear-gradient(135deg, #F44336 0%%, #EF5350 100%%)"
                shadow = "0 2px 8px rgba(244,67,54,0.4)"
            end

            html = html .. string.format(
                "<button type='button' risu-trigger='combat_choice_%d' style='display:block;width:100%%;max-width:580px;margin:8px auto;padding:12px 20px;background:%s;color:white;border:none;border-radius:8px;box-shadow:%s;font-size:14px;font-weight:500;cursor:pointer;transition:all 0.2s ease;text-align:left'>%s <strong>[%s]</strong> %s <span style='float:right;opacity:0.9;font-size:12px'>%s</span></button>",
                i, gradient, shadow, emoji, stat, desc, diff
            )
        end
    end
    html = html .. "</div>"

    setChatVar(triggerId, "combat_choices_html", html)
    log("✅ 전투 선택지 HTML 버튼 생성 완료")
end

function parseCombatChoices(triggerId, message)
    -- <CombatChoice>...</CombatChoice> 블록 찾기
    local choiceBlock = message:match("(<CombatChoice>.-</CombatChoice>)")
    if choiceBlock then
        parseCombatChoice(triggerId, choiceBlock)
    else
        -- 전투 선택지 태그가 없으면 버튼 초기화 (이전 전투 데이터 제거)
        for i = 1, 6 do
            setChatVar(triggerId, "combat_choice_" .. i .. "_stat", "")
            setChatVar(triggerId, "combat_choice_" .. i .. "_desc", "")
            setChatVar(triggerId, "combat_choice_" .. i .. "_diff", "")
        end
        setChatVar(triggerId, "combat_choices_html", "")
    end
end

-- ============================================
-- 보조모델 호출
-- ============================================

-- 보조모델용 4개 메시지 구조 생성 (system, user, user prefill, assistant prefill)
function buildAuxiliaryMessages(triggerId, mainResponse)
    -- 플레이어 특성 정보 가져오기
    local traitsDisplay = getChatVar(triggerId, "player_traits_display") or ""

    -- 특성 섹션 생성
    local traitsSection = ""
    if traitsDisplay ~= "" then
        traitsSection = "**Current Player Traits:**\n" .. traitsDisplay
    else
        traitsSection = "(No traits yet)"
    end

    -- 활성 효과 정보 가져오기
    local effects = getActiveEffects(triggerId)
    local effectsSection = ""

    if #effects > 0 then
        effectsSection = "**Current Active Effects:**\n"
        for _, effect in ipairs(effects) do
            -- nil 방어: 모든 필드가 유효한 값인지 확인
            local effectName = effect.name or "Unknown"
            local effectType = effect.type or "display"
            local effectValue = tonumber(effect.value) or 0
            local effectDesc = effect.desc or ""

            if effectType == "display" then
                effectsSection = effectsSection .. string.format("- %s: %s\n", effectName, effectDesc)
            else
                local statName = effectType:gsub("_bonus", ""):upper()
                effectsSection = effectsSection .. string.format("- %s: %s %+d\n", effectName, statName, effectValue)
            end
        end
    else
        effectsSection = "(No active effects)"
    end

    -- SYSTEM 메시지: AUXILIARY_BASE_PROMPT (규칙)
    local systemPrompt = AUXILIARY_BASE_PROMPT:gsub("{{PLAYER_TRAITS_SECTION}}", traitsSection)
    systemPrompt = systemPrompt:gsub("{{PLAYER_EFFECTS_SECTION}}", effectsSection)

    -- USER 메시지: 게임 상태 + 메인 AI 응답
    local userPrompt = "## Current Game State\n"
    userPrompt = userPrompt .. "===========================================\n"

    -- 현재 게임 상태 정보 수집
    local location = getChatVar(triggerId, "current_location") or "Unknown"
    local time = getChatVar(triggerId, "current_time") or "Unknown"
    local season = getChatVar(triggerId, "current_season") or "봄"
    local week = getChatVar(triggerId, "week_of_season") or "1"
    local dayName = getChatVar(triggerId, "day_of_week_name") or "월요일"
    local weather = getChatVar(triggerId, "current_weather") or ""

    local playerLevel = getState(triggerId, "player_level") or "1"
    local playerExp = getState(triggerId, "player_exp") or "0"
    local playerExpMax = getState(triggerId, "player_exp_max") or "100"
    local playerGold = getState(triggerId, "player_gold") or "0"
    local activeEffects = getChatVar(triggerId, "active_effects") or ""

    -- 환경 정보
    userPrompt = userPrompt .. "Environment:\n"
    userPrompt = userPrompt .. string.format("- Season: %s Week %s | Day: %s %s\n", season, week, dayName, time)
    userPrompt = userPrompt .. string.format("- Location: %s\n", location)
    if weather ~= "" then
        userPrompt = userPrompt .. string.format("- Weather: %s\n", weather)
    end

    -- 전투 정보 (전투 중일 때만 표시)
    local combatActive = getChatVar(triggerId, "combat_active") or "false"
    if combatActive == "true" then
        local enemyName = getChatVar(triggerId, "combat_enemy_name") or "Unknown"
        local enemyHp = getChatVar(triggerId, "combat_enemy_hp") or "0"
        local enemyPower = getChatVar(triggerId, "combat_enemy_power") or "0"
        local playerCp = getChatVar(triggerId, "player_combat_power") or "0"
        local playerCpMax = getChatVar(triggerId, "player_combat_power_max") or "0"

        userPrompt = userPrompt .. "\n⚔️ Combat Status: ACTIVE\n"
        userPrompt = userPrompt .. string.format("- Enemy: %s (HP: %s / %s)\n", enemyName, enemyHp, enemyPower)
        userPrompt = userPrompt .. string.format("- Player CP: %s / %s\n", playerCp, playerCpMax)
    end

    -- 플레이어 정보
    userPrompt = userPrompt .. "\nPlayer Status:\n"
    userPrompt = userPrompt .. string.format("- Level: %s | EXP: %s / %s\n", playerLevel, playerExp, playerExpMax)
    userPrompt = userPrompt .. string.format("- Gold: %s\n", playerGold)
    if activeEffects ~= "" then
        userPrompt = userPrompt .. string.format("- Active Effects: %s\n", activeEffects)
    end

    userPrompt = userPrompt .. "===========================================\n"

    -- 메인 AI 응답 추가 (CombatChoice 블록은 제거 - 보조 모델 혼란 방지)
    local cleanedResponse = mainResponse:gsub("<CombatChoice>.-</CombatChoice>", "")
    userPrompt = userPrompt .. "\n## Main AI Response to Analyze:\n"
    userPrompt = userPrompt .. cleanedResponse

    -- 캐시 무효화용 고유 ID
    local uniqueId = tostring(os.time()) .. "_" .. tostring(math.random(1000000))
    userPrompt = userPrompt .. "\n\n<!-- Request ID: " .. uniqueId .. " -->"

    -- USER PREFILL: OOC 지시
    local userPrefill = "(OOC: Analyze the Main AI Response and output only the relevant tags based on the narrative context. Always end with <Panel>■★)"

    -- ASSISTANT PREFILL: 응답 시작
    local assistantPrefill = "[Affinity:"

    -- 4개 메시지 구조 반환
    return {
        { role = "system", content = systemPrompt },
        { role = "user", content = userPrompt },
        { role = "user", content = userPrefill },
        { role = "assistant", content = assistantPrefill }
    }
end

-- 보조모델 호출 및 태그 반환
function callAuxiliaryModel(triggerId, mainResponse)
    -- 모델 선택: 기본값은 off (로어북에서 처리)
    local mode = getState(triggerId, "auxiliary_mode") or "0"

    -- Off 모드일 때는 보조모델을 호출하지 않음 (로어북에서 처리)
    if mode == "0" then
        return "<Panel>■★"
    end

    -- 4개 메시지 구조로 프롬프트 생성
    local success, messages = pcall(buildAuxiliaryMessages, triggerId, mainResponse)

    if not success then
        log("⚠️ buildAuxiliaryMessages 에러: " .. tostring(messages))
        return "<Panel>■★"
    end

    log("📤 보조모델 호출 시작 (4-message structure)")

    local response = (mode == "1") and LLM(triggerId, messages) or axLLM(triggerId, messages)

    -- 에러 체크
    if not response then
        log("⚠️ 보조모델 호출 실패: response is nil")
        return "<Panel>■★"
    end

    if response.success == false then
        log("⚠️ 보조모델 호출 실패: " .. tostring(response.result))
        return "<Panel>■★"
    end

    -- 응답 추출 (assistant prefill "[Affinity:"로 시작했으므로 앞에 붙여줌)
    local result = response.result or ""

    if type(result) == "string" and result ~= "" then
        -- assistant prefill을 앞에 붙임
        result = "[Affinity:" .. result

        -- <Panel> 태그가 있는지 확인 (guard 체크를 위해 필수)
        if not result:find("<Panel>") then
            log("⚠️ 보조모델 응답에 <Panel> 태그 없음, 추가함")
            result = result .. "\n<Panel>■★"
        end

        -- 중복 태그 블록 제거: 첫 번째 <Panel>■★ 이후 모든 내용 삭제
        local panelPos = result:find("<Panel>■★", 1, true)
        if panelPos then
            local afterPanel = result:sub(panelPos + 11)  -- "<Panel>■★" 이후 내용
            if afterPanel:find("%[Affinity:", 1, false) or afterPanel:find("<Panel>", 1, true) then
                -- 이후에 태그나 Panel이 더 있으면 중복으로 간주, 첫 번째까지만 자름
                result = result:sub(1, panelPos + 10)  -- "<Panel>■★" 포함
                log("⚠️ 중복 태그 블록 감지 및 제거")
            end
        end

        log("✅ 보조모델 응답 수신 완료")
        return result
    else
        log("⚠️ 보조모델 응답이 비어있거나 잘못된 타입: " .. tostring(result))
        return "<Panel>■★"
    end
end

-- ============================================
-- 스냅샷 시스템
-- ============================================

function takeSnapshot(triggerId, char)
    local aff = getChatVar(triggerId, char.storage .. "_affinity") or "0"
    setChatVar(triggerId, char.storage .. "_snapshot_affinity", aff)

    if char.is_main then
        local pos = getChatVar(triggerId, char.storage .. "_sin_pos") or "0"
        local neg = getChatVar(triggerId, char.storage .. "_sin_neg") or "0"
        local pos_count = getChatVar(triggerId, char.storage .. "_sin_pos_count") or "0"
        local neg_count = getChatVar(triggerId, char.storage .. "_sin_neg_count") or "0"

        setChatVar(triggerId, char.storage .. "_snapshot_sin_pos", pos)
        setChatVar(triggerId, char.storage .. "_snapshot_sin_neg", neg)
        setChatVar(triggerId, char.storage .. "_snapshot_sin_pos_count", pos_count)
        setChatVar(triggerId, char.storage .. "_snapshot_sin_neg_count", neg_count)
    end
end

function restoreSnapshot(triggerId, char)
    local aff = getChatVar(triggerId, char.storage .. "_snapshot_affinity") or "0"
    setChatVar(triggerId, char.storage .. "_affinity", aff)

    if char.is_main then
        local pos = getChatVar(triggerId, char.storage .. "_snapshot_sin_pos") or "0"
        local neg = getChatVar(triggerId, char.storage .. "_snapshot_sin_neg") or "0"
        local pos_count = getChatVar(triggerId, char.storage .. "_snapshot_sin_pos_count") or "0"
        local neg_count = getChatVar(triggerId, char.storage .. "_snapshot_sin_neg_count") or "0"

        setChatVar(triggerId, char.storage .. "_sin_pos", pos)
        setChatVar(triggerId, char.storage .. "_sin_neg", neg)
        setChatVar(triggerId, char.storage .. "_sin_pos_count", pos_count)
        setChatVar(triggerId, char.storage .. "_sin_neg_count", neg_count)

        local affinity = tonumber(aff) or 0
        setChatVar(triggerId, char.storage .. "_route", getRouteText(checkEnding(affinity)))
    end

    updatePercent(triggerId, char)

    log(string.format("🔄 %s %s 스냅샷 복원 (호감: %s)",
        char.icon, char.display, aff))
end

function clearChanges(triggerId, char)
    setChatVar(triggerId, char.storage .. "_change_affinity", "0")

    if char.is_main then
        setChatVar(triggerId, char.storage .. "_change_sin_pos", "0")
        setChatVar(triggerId, char.storage .. "_change_sin_neg", "0")
    end
end

-- RPG 변수 스냅샷
function takeRpgSnapshot(triggerId)
    -- Player Stats
    for _, stat in ipairs(playerStats) do
        local key = "player_" .. stat
        local value = getChatVar(triggerId, key) or tostring(STAT_DEFAULT)
        setChatVar(triggerId, "snapshot_" .. key, value)
    end

    -- Gold, EXP, Level
    setChatVar(triggerId, "snapshot_player_gold", getChatVar(triggerId, "player_gold") or "0")
    setChatVar(triggerId, "snapshot_player_exp", getChatVar(triggerId, "player_exp") or "0")
    setChatVar(triggerId, "snapshot_player_level", getChatVar(triggerId, "player_level") or "1")
    setChatVar(triggerId, "snapshot_player_exp_to_next", getChatVar(triggerId, "player_exp_to_next") or "100")

    -- Items
    setChatVar(triggerId, "snapshot_player_items", getChatVar(triggerId, "player_items") or "")

    -- Traits
    setChatVar(triggerId, "snapshot_player_traits", getChatVar(triggerId, "player_traits") or "")

    -- Ability Eval Status
    setChatVar(triggerId, "snapshot_ability_eval_status", getChatVar(triggerId, "ability_eval_status") or "0")

    -- Active Effects
    setChatVar(triggerId, "snapshot_active_effects", getChatVar(triggerId, "active_effects") or "")

    -- Season, Week, Time, Location
    setChatVar(triggerId, "snapshot_current_season", getChatVar(triggerId, "current_season") or "봄")
    setChatVar(triggerId, "snapshot_week_of_season", getChatVar(triggerId, "week_of_season") or "1")
    setChatVar(triggerId, "snapshot_current_time", getChatVar(triggerId, "current_time") or "오전")
    setChatVar(triggerId, "snapshot_current_location", getChatVar(triggerId, "current_location") or "")

    -- Combat Power
    local currentPower = getChatVar(triggerId, "player_combat_power") or tostring(calculateCombatPower(triggerId))
    setChatVar(triggerId, "snapshot_player_combat_power", currentPower)

    -- Combat State
    setChatVar(triggerId, "snapshot_combat_active", getChatVar(triggerId, "combat_active") or "false")
    setChatVar(triggerId, "snapshot_combat_enemy_name", getChatVar(triggerId, "combat_enemy_name") or "")
    setChatVar(triggerId, "snapshot_combat_enemy_power", getChatVar(triggerId, "combat_enemy_power") or "0")
    setChatVar(triggerId, "snapshot_combat_state", getChatVar(triggerId, "combat_state") or "Neutral")
end

-- RPG 변수 복원
function restoreRpgSnapshot(triggerId)
    -- Player Stats
    for _, stat in ipairs(playerStats) do
        local key = "player_" .. stat
        local snapshotValue = getChatVar(triggerId, "snapshot_" .. key) or tostring(STAT_DEFAULT)
        setChatVar(triggerId, key, snapshotValue)
        setState(triggerId, key, tonumber(snapshotValue))
    end

    -- Gold, EXP, Level
    local gold = getChatVar(triggerId, "snapshot_player_gold") or "0"
    setChatVar(triggerId, "player_gold", gold)
    setState(triggerId, "player_gold", tonumber(gold))

    local exp = getChatVar(triggerId, "snapshot_player_exp") or "0"
    setChatVar(triggerId, "player_exp", exp)
    setState(triggerId, "player_exp", tonumber(exp))

    local level = getChatVar(triggerId, "snapshot_player_level") or "0"
    setChatVar(triggerId, "player_level", level)
    setState(triggerId, "player_level", tonumber(level))

    local expToNext = getChatVar(triggerId, "snapshot_player_exp_to_next") or "100"
    setChatVar(triggerId, "player_exp_to_next", expToNext)
    setState(triggerId, "player_exp_to_next", tonumber(expToNext))

    -- Items
    local items = getChatVar(triggerId, "snapshot_player_items") or ""
    setChatVar(triggerId, "player_items", items)
    setState(triggerId, "player_items", items)

    -- Traits
    local traits = getChatVar(triggerId, "snapshot_player_traits") or ""
    setChatVar(triggerId, "player_traits", traits)
    setState(triggerId, "player_traits", traits)

    -- Ability Eval Status
    local evalStatus = getChatVar(triggerId, "snapshot_ability_eval_status") or "0"
    setChatVar(triggerId, "ability_eval_status", evalStatus)
    setState(triggerId, "ability_eval_status", tonumber(evalStatus))

    -- Active Effects
    local effects = getChatVar(triggerId, "snapshot_active_effects") or ""
    setChatVar(triggerId, "active_effects", effects)
    setState(triggerId, "active_effects", effects)

    -- Season, Week, Time, Location
    local season = getChatVar(triggerId, "snapshot_current_season") or "봄"
    setChatVar(triggerId, "current_season", season)
    setState(triggerId, "current_season", season)

    local week = getChatVar(triggerId, "snapshot_week_of_season") or "1"
    setChatVar(triggerId, "week_of_season", week)
    setState(triggerId, "week_of_season", week)

    local time = getChatVar(triggerId, "snapshot_current_time") or "오전"
    setChatVar(triggerId, "current_time", time)
    setState(triggerId, "current_time", time)

    local location = getChatVar(triggerId, "snapshot_current_location") or ""
    setChatVar(triggerId, "current_location", location)
    setState(triggerId, "current_location", location)

    -- Combat Power
    local combatPower = getChatVar(triggerId, "snapshot_player_combat_power") or tostring(calculateCombatPower(triggerId))
    setChatVar(triggerId, "player_combat_power", combatPower)
    setState(triggerId, "player_combat_power", tonumber(combatPower))

    -- Combat State
    local combatActive = getChatVar(triggerId, "snapshot_combat_active") or "false"
    setChatVar(triggerId, "combat_active", combatActive)
    setState(triggerId, "combat_active", combatActive)

    local combatEnemyName = getChatVar(triggerId, "snapshot_combat_enemy_name") or ""
    setChatVar(triggerId, "combat_enemy_name", combatEnemyName)
    setState(triggerId, "combat_enemy_name", combatEnemyName)

    local combatEnemyPower = getChatVar(triggerId, "snapshot_combat_enemy_power") or "0"
    setChatVar(triggerId, "combat_enemy_power", combatEnemyPower)
    setState(triggerId, "combat_enemy_power", tonumber(combatEnemyPower))

    local combatState = getChatVar(triggerId, "snapshot_combat_state") or "Neutral"
    setChatVar(triggerId, "combat_state", combatState)
    setState(triggerId, "combat_state", combatState)

    log("🔄 RPG 스냅샷 복원 완료")
end

-- RPG 변수 변경량 초기화
function clearRpgChanges(triggerId)
    for _, stat in ipairs(playerStats) do
        setChatVar(triggerId, "player_" .. stat .. "_change", "0")
    end

    setChatVar(triggerId, "player_gold_change", "0")
    setChatVar(triggerId, "player_exp_change", "0")
end

-- ============================================
-- 장소 별칭 시스템 (로어북 기준)
-- ============================================

local locationAliases = {
    -- 7개 하우스
    ["Lily Valley House"] = {"Lily Valley", "릴리 밸리", "백합곡", "Lily"},
    ["Rose House"] = {"Rose House", "로즈 하우스", "로즈", "장미관", "Rose"},
    ["Aconitum House"] = {"Aconitum", "아코니툼", "투구꽃"},
    ["Poppy House"] = {"Poppy", "포피", "양귀비"},
    ["Ivy House"] = {"Ivy", "아이비", "담쟁이"},
    ["Rafflesia House"] = {"Rafflesia", "라플레시아", "래플레시아"},
    ["Belladonna House"] = {"Belladonna", "벨라도나", "벨라돈나"},

    -- 캠퍼스 시설
    ["Library"] = {"Library", "도서관", "라이브러리", "Central Library"},
    ["Central Plaza"] = {"Central Plaza", "중앙 광장", "광장", "Plaza"},
    ["Student Council Room"] = {"Student Council", "학생회실", "학생회", "Council"},
    ["Shopping District"] = {"Shopping District", "쇼핑가", "상점가"},
    ["Café Street"] = {"Café Street", "카페 거리", "카페가", "Café"},
    ["Dueling Grounds"] = {"Dueling Grounds", "결투장", "훈련장"},
    ["Underground Archives"] = {"Underground Archives", "지하 기록실", "기록보관소"},

    -- 대학가 (College Town)
    ["Scarlet Street"] = {"Scarlet Street", "스칼렛 스트리트", "스칼렛", "대학가", "Boulevard", "메인 스트리트"},
    ["Midnight Alley"] = {"Midnight Alley", "미드나잇 앨리", "미드나잇", "Food Alley", "뒷골목", "음식 골목"},

    -- 유흥/상업 지구
    ["Lotus Street"] = {"Lotus Street", "로터스 스트리트", "로터스", "연꽃가", "Club District", "클럽가"},
    ["Ruby Row"] = {"Ruby Row", "루비 로우", "루비", "Luxury Club", "고급 유흥가"},
    ["Mana Square"] = {"Mana Square", "마나 스퀘어", "마나", "Mana Stone Exchange", "거래소"},
    ["Golden District"] = {"Golden District", "골든 디스트릭트", "황실 구역", "Imperial District"},

    -- 기타
    ["FamilyMart"] = {"FamilyMart", "패밀리마트", "편의점"},
    ["Club Moonlight"] = {"Club Moonlight", "문라이트", "클럽 문라이트"},
    ["Imperial Palace"] = {"Imperial Palace", "황궁", "궁전", "Twin Princesses Palace"},
    ["Imperial Training Grounds"] = {"Imperial Training", "황실 훈련장", "Imperial Grounds"},
    ["Imperial Hunting Grounds"] = {"Hunting Grounds", "사냥터", "수렵장"},
    ["Aconitum Arena"] = {"Arena", "아레나", "경기장"},
    ["Grand Ballroom"] = {"Ballroom", "무도회장", "연회장", "Opera House"}
}

local locationFlags = {
    -- 하우스
    ["Lily Valley House"] = "at_lily_house",
    ["Rose House"] = "at_rose_house",
    ["Aconitum House"] = "at_aconitum_house",
    ["Poppy House"] = "at_poppy_house",
    ["Ivy House"] = "at_ivy_house",
    ["Rafflesia House"] = "at_rafflesia_house",
    ["Belladonna House"] = "at_belladonna_house",

    -- 캠퍼스
    ["Library"] = "at_library",
    ["Central Plaza"] = "at_plaza",
    ["Student Council Room"] = "at_council_room",
    ["Shopping District"] = "at_shopping",
    ["Café Street"] = "at_cafe_street",

    -- 외부 지역
    ["Scarlet Street"] = "at_scarlet_street",
    ["Midnight Alley"] = "at_midnight_alley",
    ["Lotus Street"] = "at_lotus_street",
    ["Ruby Row"] = "at_ruby_row",
    ["Mana Square"] = "at_mana_square",
    ["Golden District"] = "at_golden_district",
    ["FamilyMart"] = "at_familymart",
    ["Club Moonlight"] = "at_club_moonlight",
    ["Imperial Palace"] = "at_imperial_palace",
    ["Imperial Training Grounds"] = "at_imperial_training",
    ["Imperial Hunting Grounds"] = "at_hunting_grounds",
    ["Aconitum Arena"] = "at_aconitum_arena",
    ["Grand Ballroom"] = "at_ballroom"
}

-- 유연한 장소 매칭
function matchLocation(currentLoc, targetLoc)
    if currentLoc:match(targetLoc) then return true end

    if locationAliases[targetLoc] then
        for _, alias in ipairs(locationAliases[targetLoc]) do
            if currentLoc:match(alias) then return true end
        end
    end

    return false
end

-- ============================================
-- 캐릭터 스케줄 (로어북 기준 재조정)
-- ============================================

local schedules = {
    mirabel = {
        morning = {
            location = "Lily Valley House",
            text = "릴리 밸리 하우스 거래소 (Lily Valley House Trading Floor)"
        },
        afternoon = {
            location = "Lily Valley House",
            text = "릴리 밸리 하우스 강의실 (Lily Valley House Classroom)"
        },
        evening = {
            location = "Scarlet Street",
            text = "스칼렛 스트리트 쇼핑가 (Scarlet Street Shopping District)"
        },
        night = {
            location = "Ruby Row",
            text = "루비 로우 고급 라운지 (Ruby Row Luxury Lounge)"
        }
    },

    celestia = {
        morning = {
            location = "Student Council Room",
            alt_location = "Rose House",
            text = "학생회실 / 로즈 하우스 훈련 (Student Council Room / Rose House Training)"
        },
        afternoon = {
            location = "Rose House",
            text = "로즈 하우스 강의실 (Rose House Classroom)"
        },
        evening = {
            location = "Student Council Room",
            alt_location = "Rose House",
            text = "학생회실 / 로즈 하우스 (Student Council Room / Rose House)"
        },
        night = {
            location = "Lotus Street",
            text = "로터스 스트리트 유흥가 (Lotus Street Entertainment Quarter)"
        }
    },

    lilith = {
        morning = {
            location = "Poppy House",
            text = "포피 하우스 뒷자리 (Poppy House Back Row - rarely visible)"
        },
        afternoon = {
            location = "NONE",
            text = "출현 불가 (NOT AVAILABLE)"
        },
        evening = {
            location = "FamilyMart",
            text = "패밀리마트 앞 계단 (FamilyMart Front Steps)"
        },
        night = {
            location = "FamilyMart",
            alt_location = "{{user}}'s Room",
            text = "패밀리마트 / {{user}} 방 (FamilyMart / {{user}}'s Room)"
        }
    },

    cassandra = {
        morning = {
            location = "Aconitum House",
            text = "아코니툼 하우스 훈련장 (Aconitum House Training Grounds)"
        },
        afternoon = {
            location = "Aconitum House",
            text = "아코니툼 하우스 전술실 (Aconitum House Tactics Room)"
        },
        evening = {
            location = "Aconitum House",
            alt_location = "Scarlet Street",
            text = "아코니툼 무기고 / 스칼렛 무기상점 (Aconitum Armory / Scarlet Weapon Shop)"
        },
        night = {
            location = "Aconitum House",
            text = "아코니툼 개인 숙소 (Aconitum Personal Quarters)"
        }
    },

    evangeline = {
        morning = {
            location = "NONE",
            text = "출현 불가 (NOT AVAILABLE)"
        },
        afternoon = {
            location = "Belladonna House",
            alt_location = "Central Plaza",
            text = "벨라도나 라운지 / 중앙 광장 카페 (Belladonna Lounge / Plaza Café)"
        },
        evening = {
            location = "Lotus Street",
            text = "로터스 스트리트 클럽가 (Lotus Street Club District)"
        },
        night = {
            location = "Club Moonlight",
            alt_location = "Lotus Street",
            text = "클럽 문라이트 / 로터스 클럽가 (Club Moonlight / Lotus Clubs)"
        }
    },

    amelia = {
        morning = {
            location = "NONE",
            text = "출현 불가 (NOT AVAILABLE)"
        },
        afternoon = {
            location = "Library",
            alt_location = "Ivy House",
            text = "도서관 예술 섹션 / 아이비 스튜디오 (Library Art Section / Ivy Studio)"
        },
        evening = {
            location = "Ivy House",
            text = "아이비 하우스 스튜디오 (Ivy House Studio)"
        },
        night = {
            location = "Ivy House",
            text = "아이비 개인 작업실 (Ivy House Personal Workspace)"
        }
    },

    nepenthes = {
        morning = {
            location = "Rafflesia House",
            alt_location = "Central Plaza",
            text = "라플레시아 연구실 / 중앙 광장 정원 (Rafflesia Lab / Plaza Garden)"
        },
        afternoon = {
            location = "Rafflesia House",
            alt_location = "Library",
            text = "라플레시아 연구실 / 도서관 연금술 섹션 (Rafflesia Lab / Library Alchemy)"
        },
        evening = {
            location = "Rafflesia House",
            alt_location = "Scarlet Street",
            text = "라플레시아 다실 / 스칼렛 카페 (Rafflesia Tea Room / Scarlet Café)"
        },
        night = {
            location = "Rafflesia House",
            text = "라플레시아 비밀 연구실 (Rafflesia Secret Lab)"
        }
    },

    aurelia = {
        morning = {
            location = "Rose House",
            alt_location = "Imperial Training Grounds",
            text = "로즈 하우스 / 황실 훈련장 (Rose House / Imperial Training Grounds)"
        },
        afternoon = {
            location = "Rose House",
            text = "로즈 하우스 전략실 (Rose House Strategy Room)"
        },
        evening = {
            location = "Library",
            alt_location = "Central Plaza",
            text = "도서관 / 중앙 광장 (Library / Central Plaza)"
        },
        night = {
            location = "Imperial Palace",
            text = "황궁 별관 (Imperial Palace Wing)"
        }
    },

    cordelia = {
        morning = {
            location = "Lily Valley House",
            text = "릴리 밸리 하우스 (Lily Valley House)"
        },
        afternoon = {
            location = "Lily Valley House",
            text = "릴리 밸리 하우스 (Lily Valley House)"
        },
        evening = {
            location = "Scarlet Street",
            alt_location = "Mana Square",
            text = "스칼렛 보석상가 / 마나 스퀘어 (Scarlet Jewelry / Mana Square)"
        },
        night = {
            location = "Cordelia's Quarters",
            text = "개인 숙소 (Personal Quarters)"
        }
    },

    suah = {
        morning = {
            location = "NONE",
            text = "출현 불가 - 외부인 (NOT AVAILABLE - Outsider)"
        },
        afternoon = {
            location = "NONE",
            text = "출현 불가 (NOT AVAILABLE)"
        },
        evening = {
            location = "Lotus Street",
            alt_location = "Midnight Alley",
            text = "로터스 유흥가 / 미드나잇 뒷골목 (Lotus Red Light / Midnight Alley)"
        },
        night = {
            location = "Lotus Street",
            text = "로터스 스트리트 바 (Lotus Street Bar)"
        }
    },

    adelheid = {
        morning = {
            location = "Aconitum House",
            text = "아코니툼 훈련장 (Aconitum Training - when not cold)"
        },
        afternoon = {
            location = "Aconitum House",
            text = "아코니툼 전략실 (Aconitum Strategy Room)"
        },
        evening = {
            location = "Library",
            text = "도서관 만화/라노벨 섹션 (Library Manga/Light Novel Section)"
        },
        night = {
            location = "Adelheid's Quarters",
            text = "개인 숙소 (Personal Quarters)"
        }
    },

    rosalie = {
        morning = {
            location = "Central Plaza",
            alt_location = "Rose House",
            text = "중앙 광장 정원 / 로즈 온실 (Plaza Garden / Rose Greenhouse)"
        },
        afternoon = {
            location = "Central Plaza",
            alt_location = "Rose House",
            text = "중앙 광장 정원 / 로즈 온실 (Plaza Garden / Rose Greenhouse)"
        },
        evening = {
            location = "Rose House",
            text = "로즈 하우스 다실 (Rose House Tea Room)"
        },
        night = {
            location = "Rosalie's Quarters",
            text = "개인 숙소 (Personal Quarters)"
        }
    },

    mika = {
        morning = {
            location = "NONE",
            text = "출현 불가 (NOT AVAILABLE)"
        },
        afternoon = {
            location = "Library",
            alt_location = "Central Plaza",
            text = "도서관 예술 섹션 / 광장 카페 (Library Art / Plaza Café)"
        },
        evening = {
            location = "Lotus Street",
            text = "로터스 스트리트 공연가 (Lotus Street Performance District)"
        },
        night = {
            location = "Mika's Studio",
            text = "개인 작업실 (Personal Studio)"
        }
    },

    clover = {
        morning = {
            location = "Belladonna House",
            alt_location = "Central Plaza",
            text = "벨라도나 라운지 / 중앙 광장 (Belladonna Lounge / Plaza)"
        },
        afternoon = {
            location = "Belladonna House",
            alt_location = "Scarlet Street",
            text = "벨라도나 라운지 / 스칼렛 거리 (Belladonna Lounge / Scarlet Street)"
        },
        evening = {
            location = "Scarlet Street",
            alt_location = "Midnight Alley",
            text = "스칼렛 바자 / 미드나잇 시장 (Scarlet Bazaar / Midnight Market)"
        },
        night = {
            location = "NONE",
            text = "행방 불명 (Unknown Location)"
        }
    }
}

-- ============================================
-- 이벤트 스케줄 (로어북 기준)
-- ============================================

local eventSchedules = {
    ["봄"] = {
        {
            weeks = {3, 4, 5, 6},
            name = "Foundation Festival (창립제)",
            overrides = {
                ["Central Plaza"] = {
                    chars = {"celestia", "mirabel", "evangeline", "clover", "rosalie"},
                    periods = {"afternoon", "evening"}
                },
                ["Rose House"] = {
                    chars = {"celestia", "aurelia", "rosalie"},
                    periods = {"morning"}
                },
                ["Scarlet Street"] = {
                    chars = {"mirabel", "cordelia", "clover"},
                    periods = {"afternoon", "evening"}
                }
            }
        },
        {
            weeks = {7, 8, 9},
            name = "Spring Ball Season (봄 무도회)",
            overrides = {
                ["Grand Ballroom"] = {
                    chars = {"aurelia", "celestia", "rosalie", "evangeline"},
                    periods = {"evening", "night"}
                },
                ["Central Plaza"] = {
                    chars = {"rosalie", "clover"},
                    periods = {"afternoon"}
                },
                ["Ruby Row"] = {
                    chars = {"evangeline", "celestia"},
                    periods = {"night"}
                }
            }
        }
    },

    ["여름"] = {
        {
            weeks = {4, 5, 6, 7},
            name = "Solstice Tournament (하지 토너먼트)",
            overrides = {
                ["Aconitum Arena"] = {
                    chars = {"cassandra", "aurelia", "adelheid"},
                    periods = {"afternoon", "evening"}
                },
                ["Central Plaza"] = {
                    chars = {"celestia", "evangeline", "clover"},
                    periods = {"afternoon"}
                },
                ["Scarlet Street"] = {
                    chars = {"mirabel", "cordelia"},
                    periods = {"afternoon", "evening"}
                }
            }
        },
        {
            weeks = {8, 9, 10, 11, 12},
            name = "Research Symposium (연구 심포지엄)",
            overrides = {
                ["Poppy House"] = {
                    chars = {"lilith", "nepenthes"},
                    periods = {"afternoon", "evening"}
                },
                ["Rafflesia House"] = {
                    chars = {"nepenthes"},
                    periods = {"afternoon", "evening"}
                },
                ["Library"] = {
                    chars = {"amelia", "adelheid"},
                    periods = {"afternoon"}
                }
            }
        }
    },

    ["가을"] = {
        {
            weeks = {1, 2, 3, 4},
            name = "Harvest Festival (수확제)",
            overrides = {
                ["Central Plaza"] = {
                    chars = {"rosalie", "evangeline", "clover", "nepenthes", "celestia"},
                    periods = {"afternoon", "evening"}
                },
                ["Scarlet Street"] = {
                    chars = {"mirabel", "cordelia", "clover"},
                    periods = {"afternoon", "evening"}
                }
            }
        },
        {
            weeks = {8, 9, 10, 11, 12},
            name = "Autumn Hunt (가을 사냥)",
            overrides = {
                ["Imperial Hunting Grounds"] = {
                    chars = {"aurelia", "cassandra", "adelheid"},
                    periods = {"morning", "afternoon"}
                }
            }
        }
    },

    ["겨울"] = {
        {
            weeks = {5, 6, 7, 8},
            name = "Winter Gala (겨울 갈라)",
            overrides = {
                ["Grand Ballroom"] = {
                    chars = {"celestia", "aurelia", "mirabel", "nepenthes", "rosalie"},
                    periods = {"evening", "night"}
                },
                ["Rose House"] = {
                    chars = {"celestia", "aurelia"},
                    periods = {"afternoon"}
                },
                ["Ruby Row"] = {
                    chars = {"evangeline", "celestia"},
                    periods = {"night"}
                }
            }
        }
    }
}

-- ============================================
-- 시간대 판별
-- ============================================

function getCurrentPeriod(triggerId)
    local time = getChatVar(triggerId, "current_time") or "오전"

    if time:match("오전") or time:match("아침") or time:match("새벽") or time:match("Morning") or time:match("morning") then
        return "morning"
    elseif time:match("오후") or time:match("Afternoon") or time:match("afternoon") then
        return "afternoon"
    elseif time:match("저녁") or time:match("Evening") or time:match("evening") then
        return "evening"
    elseif time:match("밤") or time:match("심야") or time:match("Night") or time:match("night") then
        return "night"
    else
        return "morning"
    end
end

-- ============================================
-- 스케줄 매칭
-- ============================================

function checkScheduleMatch(triggerId)
    local currentLocation = getChatVar(triggerId, "current_location") or "중앙 광장"
    local period = getCurrentPeriod(triggerId)
    local season = getChatVar(triggerId, "current_season") or "봄"
    local week = tonumber(getChatVar(triggerId, "week_of_season")) or 1

    -- 초기화
    for charStorage, _ in pairs(schedules) do
        setChatVar(triggerId, charStorage .. "_available", "false")
    end

    -- 1. 이벤트 스케줄 우선 체크
    local eventMatch = false
    if eventSchedules[season] then
        for _, event in ipairs(eventSchedules[season]) do
            local inEventWeek = false
            for _, eventWeek in ipairs(event.weeks) do
                if week == eventWeek then
                    inEventWeek = true
                    break
                end
            end

            if inEventWeek then
                setChatVar(triggerId, "active_event", event.name)

                for eventLocation, config in pairs(event.overrides) do
                    if matchLocation(currentLocation, eventLocation) then
                        local periodMatch = false
                        for _, eventPeriod in ipairs(config.periods) do
                            if period == eventPeriod then
                                periodMatch = true
                                break
                            end
                        end

                        if periodMatch then
                            for _, charStorage in ipairs(config.chars) do
                                setChatVar(triggerId, charStorage .. "_available", "true")
                                eventMatch = true
                            end
                        end
                    end
                end
            end
        end
    end

    if not eventMatch then
        setChatVar(triggerId, "active_event", "none")
    end

    -- 2. 기본 스케줄 체크
    for charStorage, schedule in pairs(schedules) do
        if getChatVar(triggerId, charStorage .. "_available") == "true" then
            goto continue
        end

        local periodData = schedule[period]

        if periodData then
            if periodData.location ~= "NONE" and matchLocation(currentLocation, periodData.location) then
                setChatVar(triggerId, charStorage .. "_available", "true")
            end

            if periodData.alt_location and matchLocation(currentLocation, periodData.alt_location) then
                setChatVar(triggerId, charStorage .. "_available", "true")
            end
        end

        ::continue::
    end
end

function initScheduleVars(triggerId)
    for charStorage, schedule in pairs(schedules) do
        setChatVar(triggerId, charStorage .. "_schedule_morning", schedule.morning.text)
        setChatVar(triggerId, charStorage .. "_schedule_afternoon", schedule.afternoon.text)
        setChatVar(triggerId, charStorage .. "_schedule_evening", schedule.evening.text)
        setChatVar(triggerId, charStorage .. "_schedule_night", schedule.night.text)
    end
end

-- ============================================
-- 호감도 패널 트리거 (56개)
-- ============================================

for _, char in ipairs(characters) do
    _G["adjust_" .. char.storage .. "_plus_100"] = function(triggerId)
        local key = char.storage .. "_affinity"
        local current = tonumber(getChatVar(triggerId, key)) or 0
        local new = clampValue(current + 100, AFFINITY_MIN, AFFINITY_MAX)
        setChatVar(triggerId, key, tostring(new))

        if char.is_main then
            setChatVar(triggerId, char.storage .. "_route", getRouteText(checkEnding(new)))
        end

        updatePercent(triggerId, char)

        log(string.format("%s %s 호감도: %d → %d (+100)",
            char.icon, char.display, current, new))
        return true
    end

    _G["adjust_" .. char.storage .. "_plus_50"] = function(triggerId)
        local key = char.storage .. "_affinity"
        local current = tonumber(getChatVar(triggerId, key)) or 0
        local new = clampValue(current + 50, AFFINITY_MIN, AFFINITY_MAX)
        setChatVar(triggerId, key, tostring(new))

        if char.is_main then
            setChatVar(triggerId, char.storage .. "_route", getRouteText(checkEnding(new)))
        end

        updatePercent(triggerId, char)

        log(string.format("%s %s 호감도: %d → %d (+50)",
            char.icon, char.display, current, new))
        return true
    end

    _G["adjust_" .. char.storage .. "_minus_50"] = function(triggerId)
        local key = char.storage .. "_affinity"
        local current = tonumber(getChatVar(triggerId, key)) or 0
        local new = clampValue(current - 50, AFFINITY_MIN, AFFINITY_MAX)
        setChatVar(triggerId, key, tostring(new))

        if char.is_main then
            setChatVar(triggerId, char.storage .. "_route", getRouteText(checkEnding(new)))
        end

        updatePercent(triggerId, char)

        log(string.format("%s %s 호감도: %d → %d (-50)",
            char.icon, char.display, current, new))
        return true
    end

    _G["adjust_" .. char.storage .. "_minus_100"] = function(triggerId)
        local key = char.storage .. "_affinity"
        local current = tonumber(getChatVar(triggerId, key)) or 0
        local new = clampValue(current - 100, AFFINITY_MIN, AFFINITY_MAX)
        setChatVar(triggerId, key, tostring(new))

        if char.is_main then
            setChatVar(triggerId, char.storage .. "_route", getRouteText(checkEnding(new)))
        end

        updatePercent(triggerId, char)

        log(string.format("%s %s 호감도: %d → %d (-100)",
            char.icon, char.display, current, new))
        return true
    end
end

-- ============================================
-- 죄악도 패널 트리거 (32개)
-- ============================================

for _, char in ipairs(characters) do
    if char.is_main then
        _G["adjust_" .. char.storage .. "_sin_pos_plus_15"] = function(triggerId)
            local key = char.storage .. "_sin_pos"
            local current = tonumber(getChatVar(triggerId, key)) or 0
            local new = clampValue(current + 15, 0, SIN_MAX)
            setChatVar(triggerId, key, tostring(new))

            updatePercent(triggerId, char)

            log(string.format("%s %s %s 압력: %d → %d (+15)",
                char.icon, char.display, char.sin_type, current, new))
            return true
        end

        _G["adjust_" .. char.storage .. "_sin_pos_plus_5"] = function(triggerId)
            local key = char.storage .. "_sin_pos"
            local current = tonumber(getChatVar(triggerId, key)) or 0
            local new = clampValue(current + 5, 0, SIN_MAX)
            setChatVar(triggerId, key, tostring(new))

            updatePercent(triggerId, char)

            log(string.format("%s %s %s 압력: %d → %d (+5)",
                char.icon, char.display, char.sin_type, current, new))
            return true
        end

        _G["adjust_" .. char.storage .. "_sin_neg_plus_15"] = function(triggerId)
            local key = char.storage .. "_sin_neg"
            local current = tonumber(getChatVar(triggerId, key)) or 0
            local new = clampValue(current + 15, 0, SIN_MAX)
            setChatVar(triggerId, key, tostring(new))

            updatePercent(triggerId, char)

            log(string.format("%s %s %s 해소: %d → %d (+15)",
                char.icon, char.display, char.sin_type, current, new))
            return true
        end

        _G["adjust_" .. char.storage .. "_sin_neg_plus_5"] = function(triggerId)
            local key = char.storage .. "_sin_neg"
            local current = tonumber(getChatVar(triggerId, key)) or 0
            local new = clampValue(current + 5, 0, SIN_MAX)
            setChatVar(triggerId, key, tostring(new))

            updatePercent(triggerId, char)

            log(string.format("%s %s %s 해소: %d → %d (+5)",
                char.icon, char.display, char.sin_type, current, new))
            return true
        end
    end
end

-- ============================================
-- 유틸리티 함수
-- ============================================

-- 요일 이름 변환 함수 (숫자 → 한글)
local function getDayName(dayNum)
    local dayNames = {"월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"}
    return dayNames[dayNum] or "알 수 없음"
end

-- 한글 요일명 → 숫자 변환 함수
local function getDayNumber(dayName)
    local dayMap = {
        ["월요일"] = 1, ["화요일"] = 2, ["수요일"] = 3,
        ["목요일"] = 4, ["금요일"] = 5, ["토요일"] = 6, ["일요일"] = 7
    }
    return dayMap[dayName] or 1
end

-- ============================================
-- 상태창 파싱
-- ============================================

function parseStatusWindow(triggerId, message)
    local time = message:match("%[Time:([^%]]+)%]")
    if time then
        setChatVar(triggerId, "current_time", time)
        setState(triggerId, "current_time", time)
    end

    local location = message:match("%[Location:([^%]]+)%]")
    if location then
        setChatVar(triggerId, "current_location", location)
        setState(triggerId, "current_location", location)

        for _, flag in pairs(locationFlags) do
            setChatVar(triggerId, flag, "false")
        end

        for locName, flag in pairs(locationFlags) do
            if matchLocation(location, locName) then
                setChatVar(triggerId, flag, "true")
            end
        end
    end

    local season = message:match("%[Season:([^%]]+)%]")
    if season then
        setChatVar(triggerId, "current_season", season)
        setState(triggerId, "current_season", season)
        setChatVar(triggerId, "is_spring", season == "봄" and "true" or "false")
        setChatVar(triggerId, "is_summer", season == "여름" and "true" or "false")
        setChatVar(triggerId, "is_autumn", season == "가을" and "true" or "false")
        setChatVar(triggerId, "is_winter", season == "겨울" and "true" or "false")
    end

    local week = message:match("%[Week:(%d+)%]")
    if week then
        setChatVar(triggerId, "week_of_season", week)
        setState(triggerId, "week_of_season", week)
    end

    -- Day 태그 파싱: 한글 요일명 지원
    local day = message:match("%[Day:([^%]]+)%]")
    if day then
        local dayNum
        -- 숫자 형식인 경우 (하위 호환성)
        if tonumber(day) then
            dayNum = tonumber(day)
        else
            -- 한글 요일명인 경우
            dayNum = getDayNumber(day)
        end

        -- day_of_week에 숫자 저장
        setChatVar(triggerId, "day_of_week", tostring(dayNum))
        setState(triggerId, "day_of_week", tostring(dayNum))

        -- day_of_week_name에 한글 저장
        local dayName = getDayName(dayNum)
        setChatVar(triggerId, "day_of_week_name", dayName)
        setState(triggerId, "day_of_week_name", dayName)
    end

    local weather = message:match("%[Weather:([^%]]+)%]")
    if weather then
        setChatVar(triggerId, "current_weather", weather)
    end

    -- Combat 태그 파싱 (Combat 시작/종료만 - CombatChoice는 메인모델에서 처리)
    parseCombats(triggerId, message)

    if time or location then
        checkScheduleMatch(triggerId)
    end
end


-- ============================================
-- 시나리오 트리거 (18개)
-- ============================================

for i = 1, 16 do
    _G["greeting" .. i] = function(triggerId)
        setChatVar(triggerId, "greeting", tostring(i))
        setState(triggerId, "greeting", i)
        log("Scenario " .. i)
        return true
    end
end

_G["random_start"] = function(triggerId)
    math.randomseed(os.time())
    local r = math.random(1, 16)
    setChatVar(triggerId, "greeting", tostring(r))
    setState(triggerId, "greeting", r)
    log("🎲 Random: " .. r)
    return true
end

_G["free_start"] = function(triggerId)
    setChatVar(triggerId, "greeting", "18")
    setState(triggerId, "greeting", 18)
    log("✨ Free Start")
    return true
end

-- 테스트용: 전투 강제 시작
_G["test_combat"] = function(triggerId)
    -- 보조 AI 출력을 시뮬레이션
    local testMessage = "[Affinity:Cassandra:neutral][Sin:Cassandra:neutral][Combat:Ogre:110]\n<CombatChoice>\n[STR|곤봉을 피해 검으로 베어넘긴다|Normal]\n[DEX|재빠르게 옆으로 굴러 회피한다|Easy]\n[INT|약점을 분석하여 공격한다|Normal]\n[CHA|위협하여 물러서게 한다|Very Hard]\n[LUK|운에 맡긴다|Very Hard]\n[도주|재빠르게 도망친다|Easy]\n</CombatChoice>\n<Panel>■★"

    log("🧪 테스트: 전투 시뮬레이션 시작")
    parseStatusWindow(triggerId, testMessage)

    log(string.format("✅ combat_active = %s", getChatVar(triggerId, "combat_active")))
    log(string.format("✅ combat_enemy_name = %s", getChatVar(triggerId, "combat_enemy_name")))
    log(string.format("✅ combat_enemy_power = %s", getChatVar(triggerId, "combat_enemy_power")))

    return true
end

-- ============================================
-- 메인 함수
-- ============================================

function onStart(triggerId)
    log("=== Belladonna Academy v6.0 - Lorebook Edition ===")

    for _, char in ipairs(characters) do
        if not getChatVar(triggerId, char.storage .. "_affinity") then
            setChatVar(triggerId, char.storage .. "_affinity", "0")
        end

        if char.is_main then
            if not getChatVar(triggerId, char.storage .. "_sin_pos") then
                setChatVar(triggerId, char.storage .. "_sin_pos", "0")
            end
            if not getChatVar(triggerId, char.storage .. "_sin_neg") then
                setChatVar(triggerId, char.storage .. "_sin_neg", "0")
            end
            if not getChatVar(triggerId, char.storage .. "_sin_pos_count") then
                setChatVar(triggerId, char.storage .. "_sin_pos_count", "0")
            end
            if not getChatVar(triggerId, char.storage .. "_sin_neg_count") then
                setChatVar(triggerId, char.storage .. "_sin_neg_count", "0")
            end
            setChatVar(triggerId, char.storage .. "_route", "진행중")
        end

        updatePercent(triggerId, char)
        takeSnapshot(triggerId, char)
        clearChanges(triggerId, char)
    end

    initScheduleVars(triggerId)

    -- 환경 변수 초기화 (최초 1회만)
    if not getChatVar(triggerId, "current_season") then
        setChatVar(triggerId, "current_season", "봄")
        setChatVar(triggerId, "is_spring", "true")
        setChatVar(triggerId, "is_summer", "false")
        setChatVar(triggerId, "is_autumn", "false")
        setChatVar(triggerId, "is_winter", "false")
    end
    if not getChatVar(triggerId, "week_of_season") then
        setChatVar(triggerId, "week_of_season", "1")
        setChatVar(triggerId, "is_exam_week", "false")
    end
    if not getChatVar(triggerId, "day_of_week") then
        setChatVar(triggerId, "day_of_week", "1")
        setChatVar(triggerId, "day_of_week_name", "월요일")
    end
    if not getChatVar(triggerId, "current_time") then
        setChatVar(triggerId, "current_time", "오전")
    end
    if not getChatVar(triggerId, "current_location") then
        setChatVar(triggerId, "current_location", "중앙 광장")

        -- 초기 위치 플래그 설정
        for _, flag in pairs(locationFlags) do
            setChatVar(triggerId, flag, "false")
        end
        setChatVar(triggerId, "at_plaza", "true")
    end
    if not getChatVar(triggerId, "current_weather") then
        setChatVar(triggerId, "current_weather", "맑음")
    end
    if not getChatVar(triggerId, "active_event") then
        setChatVar(triggerId, "active_event", "none")
    end

    -- 보조 AI 모드 초기화 (기본값: off - 로어북 사용)
    if getState(triggerId, "auxiliary_mode") == nil then
        setState(triggerId, "auxiliary_mode", "2")
        setChatVar(triggerId, "auxiliary_mode", "2")
        setChatVar(triggerId, "auxiliary_mode_text", "Aux")
    end

    -- 주간 스케줄 변수 초기화
    if not getState(triggerId, "weekly_schedule_display") then
        local defaultSchedule = "=== 이번 주 계획 ===\n\n아직 스케줄이 설정되지 않았습니다.\n'스케줄 조정' 버튼을 눌러 계획을 세워보세요!"
        setState(triggerId, "weekly_schedule_display", defaultSchedule)
        setChatVar(triggerId, "weekly_schedule_display", defaultSchedule)
    end
    if not getChatVar(triggerId, "current_curriculum") then
        setChatVar(triggerId, "current_curriculum", "")
    end
    if not getChatVar(triggerId, "current_lifestyle") then
        setChatVar(triggerId, "current_lifestyle", "")
    end
    if not getChatVar(triggerId, "player_house") then
        setChatVar(triggerId, "player_house", "Serpent")
    end

    -- RPG 시스템 초기화
    if getState(triggerId, "player_level") == nil then
        -- 플레이어 레벨/경험치 (초기 레벨 0 = 능력평가 미완료)
        setState(triggerId, "player_level", 0)
        setChatVar(triggerId, "player_level", "0")
        setState(triggerId, "player_exp", 0)
        setChatVar(triggerId, "player_exp", "0")
        setState(triggerId, "player_exp_to_next", 100)
        setChatVar(triggerId, "player_exp_to_next", "100")

        -- 플레이어 골드
        setState(triggerId, "player_gold", 0)
        setChatVar(triggerId, "player_gold", "0")

        -- 플레이어 스탯 (기본값 50, 보조모델이 초기 할당 전까지)
        for _, stat in ipairs(playerStats) do
            setState(triggerId, "player_" .. stat, STAT_DEFAULT)
            setChatVar(triggerId, "player_" .. stat, tostring(STAT_DEFAULT))
        end

        -- 플레이어 아이템
        setState(triggerId, "player_items", "")
        setChatVar(triggerId, "player_items", "")

        -- 플레이어 Trait
        setState(triggerId, "player_traits", "")
        setChatVar(triggerId, "player_traits", "")

        -- Season, Week, Time, Location 초기값
        setState(triggerId, "current_season", "봄")
        setChatVar(triggerId, "current_season", "봄")
        setChatVar(triggerId, "is_spring", "true")
        setChatVar(triggerId, "is_summer", "false")
        setChatVar(triggerId, "is_autumn", "false")
        setChatVar(triggerId, "is_winter", "false")
        setState(triggerId, "week_of_season", "1")
        setChatVar(triggerId, "week_of_season", "1")
        setChatVar(triggerId, "is_exam_week", "false")
        setChatVar(triggerId, "day_of_week", "1")
        setChatVar(triggerId, "day_of_week_name", "월요일")
        setState(triggerId, "current_time", "오전")
        setChatVar(triggerId, "current_time", "오전")
        setState(triggerId, "current_location", "")
        setChatVar(triggerId, "current_location", "")

        -- 능력평가 완료 플래그 (로어북용)
        setState(triggerId, "ability_eval_status", 0)
        setChatVar(triggerId, "ability_eval_status", "0")

        -- RPG 시스템 기본 활성화
        setState(triggerId, "rpg_system_enabled", true)
        setChatVar(triggerId, "rpg_system_enabled", "true")

        -- 활성 효과 초기화
        setState(triggerId, "active_effects", "")
        setChatVar(triggerId, "active_effects", "")
        setState(triggerId, "active_effects_display", "")
        setChatVar(triggerId, "active_effects_display", "")

        -- 아이템 사용 상태 초기화
        setState(triggerId, "using_item", "")
        setChatVar(triggerId, "using_item", "")
        setState(triggerId, "using_item_effect", "")
        setChatVar(triggerId, "using_item_effect", "")

        -- 전투력 초기화 (스탯 기반 계산)
        local initialCombatPower = calculateCombatPower(triggerId)
        setState(triggerId, "player_combat_power", initialCombatPower)
        setChatVar(triggerId, "player_combat_power", tostring(initialCombatPower))

        -- 전투 시스템 초기화
        setState(triggerId, "combat_active", "false")
        setChatVar(triggerId, "combat_active", "false")
        setState(triggerId, "combat_enemy_name", "")
        setChatVar(triggerId, "combat_enemy_name", "")
        setState(triggerId, "combat_enemy_power", 0)
        setChatVar(triggerId, "combat_enemy_power", "0")
        setState(triggerId, "combat_player_power", 0)
        setChatVar(triggerId, "combat_player_power", "0")
        setState(triggerId, "combat_state", "Neutral")
        setChatVar(triggerId, "combat_state", "Neutral")

        -- 전투 선택지 난이도 초기화
        setState(triggerId, "combat_str_difficulty", "Normal")
        setChatVar(triggerId, "combat_str_difficulty", "Normal")
        setState(triggerId, "combat_dex_difficulty", "Normal")
        setChatVar(triggerId, "combat_dex_difficulty", "Normal")
        setState(triggerId, "combat_int_difficulty", "Normal")
        setChatVar(triggerId, "combat_int_difficulty", "Normal")
        setState(triggerId, "combat_cha_difficulty", "Normal")
        setChatVar(triggerId, "combat_cha_difficulty", "Normal")
        setState(triggerId, "combat_luk_difficulty", "Very Hard")
        setChatVar(triggerId, "combat_luk_difficulty", "Very Hard")

        -- 6번 선택지 초기화
        setState(triggerId, "combat_6th_type", "flee")
        setChatVar(triggerId, "combat_6th_type", "flee")
        setState(triggerId, "combat_6th_name", "도망")
        setChatVar(triggerId, "combat_6th_name", "도망")
        setState(triggerId, "combat_6th_difficulty", "Easy")
        setChatVar(triggerId, "combat_6th_difficulty", "Easy")

        -- 전투 선택지 변수 초기화 (보조 AI 생성 선택지)
        for i = 1, 6 do
            setChatVar(triggerId, "combat_choice_" .. i .. "_stat", "")
            setChatVar(triggerId, "combat_choice_" .. i .. "_desc", "")
            setChatVar(triggerId, "combat_choice_" .. i .. "_diff", "")
        end
        setChatVar(triggerId, "combat_choices_html", "")

        -- 전투 결과 변수 초기화 (주사위 굴림 결과)
        setChatVar(triggerId, "combat_last_choice_num", "0")
        setChatVar(triggerId, "combat_last_choice_stat", "")
        setChatVar(triggerId, "combat_last_choice_desc", "")
        setChatVar(triggerId, "combat_last_choice_diff", "")
        setChatVar(triggerId, "combat_last_roll", "0")
        setChatVar(triggerId, "combat_last_bonus", "0")
        setChatVar(triggerId, "combat_last_total", "0")
        setChatVar(triggerId, "combat_last_target", "0")
        setChatVar(triggerId, "combat_last_result", "")
        setChatVar(triggerId, "combat_last_critical", "false")
        setChatVar(triggerId, "combat_last_fumble", "false")

        log("🎮 RPG 시스템 초기화 완료")
        log("⚔️ 전투 시스템 초기화 완료")
        log("🔧 초기화: ability_eval_status = " .. tostring(getState(triggerId, "ability_eval_status")))
    end

    -- RPG 스냅샷 및 변경량 초기화
    takeRpgSnapshot(triggerId)
    clearRpgChanges(triggerId)

    checkScheduleMatch(triggerId)

    -- 초기 디스플레이 변수 생성
    updateTraitsDisplay(triggerId)
    updateItemsDisplay(triggerId)

    log("✅ 초기화 완료 (로어북 기준 + RPG 시스템)")
end

-- onOutput 중복 실행 방지 플래그
local isProcessing = false

-- onOutput 메인 처리 로직
function processOutput(triggerId)
    local message = getCharacterLastMessage(triggerId)
    if not message then
        return
    end

    -- 이미 최종 처리된 메시지인지 확인 (setChat() 재트리거 방지)
    -- <Panel>■★ 마커가 있으면 이미 보조 출력이 추가된 메시지
    if message:find("<Panel>■★", 1, true) then
        return
    end

    log("📨 새 턴 처리")

    -- 메인 모델 출력에서 CombatChoice 파싱 (버튼 생성)
    parseCombatChoices(triggerId, message)

    -- 리롤 지원: 이전 스냅샷으로 복원 후 새 스냅샷 생성
    for _, char in ipairs(characters) do
        restoreSnapshot(triggerId, char)  -- 리롤 시 이전 상태로 복원
        clearChanges(triggerId, char)
        takeSnapshot(triggerId, char)     -- 현재 턴 시작 전 상태 저장
    end

    -- RPG 스냅샷 및 변경량 초기화 (RPG 활성화 시에만)
    local rpgEnabled = getChatVar(triggerId, "rpg_system_enabled") == "true"
    if rpgEnabled then
        restoreRpgSnapshot(triggerId)  -- 리롤 시 이전 상태로 복원
        clearRpgChanges(triggerId)
        takeRpgSnapshot(triggerId)     -- 현재 턴 시작 전 상태 저장
    end

    -- 보조모델 호출: 메인 모델 출력 분석 후 태그 생성
    local auxiliaryMessage = callAuxiliaryModel(triggerId, message)

    -- 메인과 보조 응답 모두에서 태그 파싱 (어디에 태그가 있든 파싱됨)
    local combinedSource = message .. "\n" .. auxiliaryMessage

    -- 태그 파싱
    parseStatusWindow(triggerId, combinedSource)

    -- SIN RESET 처리
    for charStorage, sinType in combinedSource:gmatch("%[SIN_RESET:(%w+)_(pos|neg)%]") do
        local countKey = charStorage .. "_sin_" .. sinType .. "_count"
        local gaugeKey = charStorage .. "_sin_" .. sinType

        local currentCount = tonumber(getChatVar(triggerId, countKey)) or 0

        setChatVar(triggerId, countKey, tostring(currentCount + 1))
        setChatVar(triggerId, gaugeKey, "0")

        for _, char in ipairs(characters) do
            if char.storage == charStorage then
                updatePercent(triggerId, char)
                log(string.format("🔄 %s %s %s 리셋! 카운트: %d → %d",
                    char.icon, char.display, sinType == "pos" and "압력" or "해소",
                    currentCount, currentCount + 1))
                break
            end
        end
    end

    -- 호감도 파싱
    for charName, feeling in combinedSource:gmatch("%[Affinity:(%w+):(%w+)%]") do
        for _, char in ipairs(characters) do
            if char.display == charName and affinityChanges[feeling] then
                local key = char.storage .. "_affinity"
                local current = tonumber(getChatVar(triggerId, key)) or 0
                local change = affinityChanges[feeling]
                local new = clampValue(current + change, AFFINITY_MIN, AFFINITY_MAX)

                setChatVar(triggerId, key, tostring(new))

                local prevChange = tonumber(getChatVar(triggerId, char.storage .. "_change_affinity")) or 0
                setChatVar(triggerId, char.storage .. "_change_affinity", tostring(prevChange + change))

                if char.is_main then
                    setChatVar(triggerId, char.storage .. "_route", getRouteText(checkEnding(new)))
                end

                updatePercent(triggerId, char)

                log(string.format("%s %s 호감도 %+d (%s) | 현재: %d",
                    char.icon, char.display, change, feeling, new))
                break
            end
        end
    end

    -- 죄악도 파싱
    for charName, level in combinedSource:gmatch("%[Sin:(%w+):(%w+)%]") do
        for _, char in ipairs(characters) do
            if char.is_main and char.display == charName then
                if sinPosChanges[level] then
                    local key = char.storage .. "_sin_pos"
                    local current = tonumber(getChatVar(triggerId, key)) or 0
                    local change = sinPosChanges[level]
                    local new = clampValue(current + change, 0, SIN_MAX)

                    setChatVar(triggerId, key, tostring(new))

                    local prevChange = tonumber(getChatVar(triggerId, char.storage .. "_change_sin_pos")) or 0
                    setChatVar(triggerId, char.storage .. "_change_sin_pos", tostring(prevChange + change))

                    updatePercent(triggerId, char)

                    log(string.format("%s %s %s 압력 %+d (%s) | 현재: %d",
                        char.icon, char.display, char.sin_type, change, level, new))
                end

                if sinNegChanges[level] then
                    local key = char.storage .. "_sin_neg"
                    local current = tonumber(getChatVar(triggerId, key)) or 0
                    local change = sinNegChanges[level]
                    local new = clampValue(current + change, 0, SIN_MAX)

                    setChatVar(triggerId, key, tostring(new))

                    local prevChange = tonumber(getChatVar(triggerId, char.storage .. "_change_sin_neg")) or 0
                    setChatVar(triggerId, char.storage .. "_change_sin_neg", tostring(prevChange + change))

                    updatePercent(triggerId, char)

                    log(string.format("%s %s %s 해소 %+d (%s) | 현재: %d",
                        char.icon, char.display, char.sin_type, change, level, new))
                end

                break
            end
        end
    end

    -- RPG 시스템 파싱 (태그 소스에서)
    if rpgEnabled then
        parseStatChanges(triggerId, combinedSource)
        parseGoldChanges(triggerId, combinedSource)
        parseExpChanges(triggerId, combinedSource)
        parseHeal(triggerId, combinedSource)
        parseItems(triggerId, combinedSource)
        parseTraits(triggerId, combinedSource)
        parseEffects(triggerId, combinedSource)
        parseExams(triggerId, combinedSource)

        -- 턴마다 효과 duration 감소
        updateEffectDurations(triggerId)

        -- RPG 디스플레이 변수 업데이트 (HTML 템플릿용)
        updateRpgDisplayVars(triggerId)
    end

    -- 로어북 이벤트 태그 파싱 (메인 AI 응답에서)
    -- [StatsEvaluated] 태그 감지 → 능력평가 완료 처리
    log("🔍 메시지 체크: " .. (message:find("%[StatsEvaluated%]") and "태그 발견!" or "태그 없음"))
    if message:find("%[StatsEvaluated%]") then
        local currentLevel = tonumber(getChatVar(triggerId, "player_level")) or 0
        log("🔍 currentLevel = " .. currentLevel)

        if currentLevel == 0 then
            -- 레벨 0 → 1로 상승 (능력평가 완료)
            setState(triggerId, "player_level", 1)
            setChatVar(triggerId, "player_level", "1")
            setState(triggerId, "player_exp", 0)
            setChatVar(triggerId, "player_exp", "0")
            setState(triggerId, "player_exp_to_next", 100)
            setChatVar(triggerId, "player_exp_to_next", "100")
            setState(triggerId, "ability_eval_status", 1)
            setChatVar(triggerId, "ability_eval_status", "1")

            -- 스냅샷 즉시 업데이트 (다음 턴에 복원되지 않도록)
            setChatVar(triggerId, "snapshot_ability_eval_status", "1")
            setChatVar(triggerId, "snapshot_player_level", "1")

            log("✅ 능력평가 완료 - 레벨 1 달성!")
            log("🔧 ability_eval_status = " .. tostring(getState(triggerId, "ability_eval_status")))
            log("🔧 player_level = " .. tostring(getState(triggerId, "player_level")))
        end
    end

    -- 아이템 사용 완료 처리 (버튼 클릭 시 이미 차감됨)
    local usingItem = getChatVar(triggerId, "using_item") or ""
    if usingItem ~= "" then
        log("🎒 아이템 사용 완료 처리: " .. usingItem)

        -- AI가 아이템을 반환했는지 확인 (태그 소스에서)
        local returnPattern = "%[Item:Add:" .. usingItem .. ":1[:%]]"
        local wasReturned = combinedSource:find(returnPattern) ~= nil

        if wasReturned then
            -- 비소모품: 아이템 복원
            local itemsStr = getChatVar(triggerId, "player_items") or ""
            local items = parseItemList(itemsStr)

            items[usingItem] = (items[usingItem] or 0) + 1
            local newItemsStr = serializeItemList(items)
            setChatVar(triggerId, "player_items", newItemsStr)
            setState(triggerId, "player_items", newItemsStr)
            setChatVar(triggerId, "snapshot_player_items", newItemsStr)

            -- 슬롯 변수 업데이트 (버튼 텍스트 갱신)
            updateItemSlotVars(triggerId)

            log(string.format("♻️ %s 반환됨 (비소모품)", usingItem))
        else
            -- 소모품: 효과 적용 (아이템은 이미 차감됨)
            local effectStr = getChatVar(triggerId, "using_item_effect") or ""
            if effectStr ~= "" then
                local parts = {}
                for part in effectStr:gmatch("[^:]+") do
                    table.insert(parts, part)
                end

                if #parts >= 3 then
                    local effectType = parts[1]
                    local effectValue = tonumber(parts[2]) or 0
                    local effectDuration = tonumber(parts[3]) or 0
                    local effectDesc = parts[4] or ""

                    addEffect(triggerId, usingItem, effectType, effectValue, effectDuration, effectDesc)
                    log(string.format("✅ %s 소모됨 - 효과 적용: %s", usingItem, effectDesc))
                else
                    log(string.format("✅ %s 소모됨", usingItem))
                end
            else
                log(string.format("✅ %s 소모됨 (효과 없음)", usingItem))
            end

            -- 슬롯 변수 업데이트 (버튼 텍스트 갱신)
            updateItemSlotVars(triggerId)
        end

        -- using_item 초기화
        setChatVar(triggerId, "using_item", "")
        setState(triggerId, "using_item", "")
        setChatVar(triggerId, "using_item_effect", "")
        setState(triggerId, "using_item_effect", "")
    end

    -- 보조모델 태그를 채팅에 추가 (RisuAI 정규식이 <Panel>■★를 처리)
    local finalMessage = message .. "\n\n" .. auxiliaryMessage

    -- 마지막 메시지의 인덱스를 명시적으로 계산 (0-based index)
    local chatLength = getChatLength(triggerId)
    local lastIndex = chatLength - 1

    setChat(triggerId, lastIndex, finalMessage)
end

-- onOutput 이벤트 핸들러
onOutput = async(function(triggerId)
    -- 이미 처리 중이면 스킵 (전송 취소 후 재전송 등의 경우)
    if isProcessing then
        log("⚠️ 이미 처리 중 - 스킵")
        return
    end

    isProcessing = true

    -- pcall로 에러 발생 시에도 isProcessing 플래그 해제 보장
    local success, result = pcall(processOutput, triggerId)

    isProcessing = false

    if not success then
        log("❌ onOutput 에러 발생: " .. tostring(result))
    else
        log("✅ 턴 처리 완료")
    end
end)

-- ============================================
-- 치트 명령어
-- ============================================

listenEdit("editInput", function(triggerId, data)
    if data:match("^/reset") then
        for _, char in ipairs(characters) do
            setChatVar(triggerId, char.storage .. "_affinity", "0")

            if char.is_main then
                setChatVar(triggerId, char.storage .. "_sin_pos", "0")
                setChatVar(triggerId, char.storage .. "_sin_neg", "0")
                setChatVar(triggerId, char.storage .. "_sin_pos_count", "0")
                setChatVar(triggerId, char.storage .. "_sin_neg_count", "0")
                setChatVar(triggerId, char.storage .. "_route", "진행중")
            end

            updatePercent(triggerId, char)
            takeSnapshot(triggerId, char)
            clearChanges(triggerId, char)
        end

        setChatVar(triggerId, "week_of_season", "1")
        setChatVar(triggerId, "is_exam_week", "false")
        setChatVar(triggerId, "active_event", "none")

        -- RPG 시스템 리셋
        setChatVar(triggerId, "player_level", "1")
        setChatVar(triggerId, "player_exp", "0")
        setChatVar(triggerId, "player_exp_to_next", "100")
        setChatVar(triggerId, "player_gold", "0")

        for _, stat in ipairs(playerStats) do
            setChatVar(triggerId, "player_" .. stat, tostring(STAT_DEFAULT))
        end

        setChatVar(triggerId, "player_items", "")
        setChatVar(triggerId, "player_traits", "")

        takeRpgSnapshot(triggerId)
        clearRpgChanges(triggerId)

        checkScheduleMatch(triggerId)
        log("✅ 초기화 완료 (RPG 포함)")
    end

    if data:match("^/status") then
        local msg = "📊 벨라도나 아카데미 현황\n\n"

        msg = msg .. "[상태]\n"
        msg = msg .. string.format("계절: %s Week %s | 시간: %s | 장소: %s\n",
            getChatVar(triggerId, "current_season") or "봄",
            getChatVar(triggerId, "week_of_season") or "1",
            getChatVar(triggerId, "current_time") or "오전",
            getChatVar(triggerId, "current_location") or "중앙 광장")

        local activeEvent = getChatVar(triggerId, "active_event") or "none"
        if activeEvent ~= "none" then
            msg = msg .. string.format("🎪 이벤트: %s\n", activeEvent)
        end
        msg = msg .. "\n"

        msg = msg .. "[출현 가능]\n"
        for _, char in ipairs(characters) do
            if (getChatVar(triggerId, char.storage .. "_available") or "false") == "true" then
                msg = msg .. string.format("%s %s ✓\n", char.icon, char.display)
            end
        end
        msg = msg .. "\n"

        msg = msg .. "[메인 캐릭터]\n"
        for _, char in ipairs(characters) do
            if char.is_main then
                local aff = getChatVar(triggerId, char.storage .. "_affinity") or "0"
                local pos = getChatVar(triggerId, char.storage .. "_sin_pos") or "0"
                local neg = getChatVar(triggerId, char.storage .. "_sin_neg") or "0"
                local route = getChatVar(triggerId, char.storage .. "_route") or "진행중"
                msg = msg .. string.format("%s %s: 호감 %s | 압력 %s | 해소 %s | %s\n",
                    char.icon, char.display, aff, pos, neg, route)
            end
        end

        msg = msg .. "\n[서브 캐릭터]\n"
        for _, char in ipairs(characters) do
            if not char.is_main then
                local aff = getChatVar(triggerId, char.storage .. "_affinity") or "0"
                msg = msg .. string.format("%s %s: 호감 %s\n", char.icon, char.display, aff)
            end
        end

        -- RPG 상태
        msg = msg .. "\n[플레이어 RPG]\n"
        local level = getChatVar(triggerId, "player_level") or "1"
        local exp = getChatVar(triggerId, "player_exp") or "0"
        local expToNext = getChatVar(triggerId, "player_exp_to_next") or "100"
        local gold = getChatVar(triggerId, "player_gold") or "0"

        msg = msg .. string.format("레벨: %s | 경험치: %s/%s | 골드: %s\n", level, exp, expToNext, gold)
        msg = msg .. "스탯: "

        for _, stat in ipairs(playerStats) do
            local value = getChatVar(triggerId, "player_" .. stat) or tostring(STAT_DEFAULT)
            msg = msg .. string.format("%s:%s ", stat:upper(), value)
        end
        msg = msg .. "\n"

        -- 아이템 정보
        local itemsStr = getChatVar(triggerId, "player_items") or ""
        if itemsStr ~= "" then
            msg = msg .. "아이템: "
            local items = parseItemList(itemsStr)
            local itemList = {}
            for name, count in pairs(items) do
                table.insert(itemList, string.format("%s x%d", name, count))
            end
            table.sort(itemList)
            msg = msg .. table.concat(itemList, ", ") .. "\n"
        else
            msg = msg .. "아이템: (없음)\n"
        end

        -- Trait 정보
        local traitsStr = getChatVar(triggerId, "player_traits") or ""
        if traitsStr ~= "" then
            msg = msg .. "Trait:\n"
            local traitIds = parseTraitIdList(traitsStr)
            for _, traitId in ipairs(traitIds) do
                local traitName = getChatVar(triggerId, "trait_" .. traitId .. "_name") or traitId
                local traitDesc = getChatVar(triggerId, "trait_" .. traitId .. "_desc") or ""
                if traitDesc ~= "" then
                    msg = msg .. string.format("  - %s: %s\n", traitName, traitDesc)
                else
                    msg = msg .. string.format("  - %s\n", traitName)
                end
            end
        else
            msg = msg .. "Trait: (없음)\n"
        end

        log(msg)
    end

    if data:match("^/use ") then
        local itemName = data:match("^/use (.+)")

        if not itemName or itemName == "" then
            log("⚠️ 사용법: /use 아이템명")
            return
        end

        -- 아이템 소지 확인
        local itemsStr = getChatVar(triggerId, "player_items") or ""
        local items = parseItemList(itemsStr)

        if not items[itemName] or items[itemName] <= 0 then
            log(string.format("⚠️ %s을(를) 소지하고 있지 않습니다.", itemName))
            return
        end

        -- 사용 중인 아이템 저장
        setChatVar(triggerId, "using_item", itemName)
        setState(triggerId, "using_item", itemName)

        -- AI가 생성한 효과도 함께 저장
        local effectStr = getChatVar(triggerId, "item_effect_" .. itemName) or ""
        setChatVar(triggerId, "using_item_effect", effectStr)
        setState(triggerId, "using_item_effect", effectStr)

        -- 아이템 즉시 차감 (AI 응답에서 반환 태그 있으면 복원됨)
        items[itemName] = items[itemName] - 1
        local newItemsStr = serializeItemList(items)
        setChatVar(triggerId, "player_items", newItemsStr)
        setState(triggerId, "player_items", newItemsStr)

        -- 스냅샷도 즉시 업데이트
        setChatVar(triggerId, "snapshot_player_items", newItemsStr)

        log(string.format("🎒 %s을(를) 꺼냈습니다 (즉시 차감). AI가 사용 장면을 묘사합니다...", itemName))
    end

    if data:match("^/resetstats") then
        -- 모든 스탯을 50으로 설정
        for _, stat in ipairs(playerStats) do
            setChatVar(triggerId, "player_" .. stat, "50")
            setState(triggerId, "player_" .. stat, 50)
        end

        -- 스냅샷 업데이트
        takeRpgSnapshot(triggerId)
        clearRpgChanges(triggerId)

        log("✅ 모든 스탯을 50으로 설정했습니다 (STR, INT, DEX, CHA, LUK, VIT)")
    end

    if data:match("^/schedule") then
        local location = getChatVar(triggerId, "current_location") or "중앙 광장"
        local period = getCurrentPeriod(triggerId)
        local activeEvent = getChatVar(triggerId, "active_event") or "none"

        local msg = string.format("📍 현재: %s (%s)\n", location, period)

        if activeEvent ~= "none" then
            msg = msg .. string.format("🎪 이벤트: %s\n", activeEvent)
        end

        msg = msg .. "\n[출현 중]\n"

        local hasChar = false
        for _, char in ipairs(characters) do
            if (getChatVar(triggerId, char.storage .. "_available") or "false") == "true" then
                local scheduleText = getChatVar(triggerId, char.storage .. "_schedule_" .. period) or "???"
                msg = msg .. string.format("%s %s - %s\n", char.icon, char.display, scheduleText)
                hasChar = true
            end
        end

        if not hasChar then msg = msg .. "(없음)\n" end

        log(msg)
    end

    if data:match("^/test") then
        setChatVar(triggerId, "mirabel_affinity", "125")
        setChatVar(triggerId, "mirabel_sin_pos", "25")
        setChatVar(triggerId, "mirabel_sin_neg", "15")
        setChatVar(triggerId, "week_of_season", "5")
        setChatVar(triggerId, "current_season", "봄")
        setChatVar(triggerId, "current_location", "스칼렛 스트리트 쇼핑가")
        setChatVar(triggerId, "current_time", "저녁")

        -- 테스트 아이템 추가
        addItem(triggerId, "힘의물약", 2, "STR+5")
        addItem(triggerId, "마나물약", 1, "INT+3")
        addItem(triggerId, "학생증", 1, "")

        updatePercent(triggerId, characters[1])
        takeSnapshot(triggerId, characters[1])
        checkScheduleMatch(triggerId)

        log("✅ 테스트 값 설정 (Week 5, 스칼렛 스트리트)")
        log("✅ 테스트 아이템 추가 (힘의물약 x2, 마나물약 x1, 학생증 x1)")
    end

    -- RPG 시스템 온/오프
    if data:match("^/rpg") then
        local args = data:match("^/rpg%s+(.+)")

        if args == "on" then
            setChatVar(triggerId, "rpg_system_enabled", "true")
            log("✅ RPG 시스템 활성화")
        elseif args == "off" then
            setChatVar(triggerId, "rpg_system_enabled", "false")
            log("⏸️ RPG 시스템 비활성화")
        elseif args == "status" then
            local enabled = getChatVar(triggerId, "rpg_system_enabled") == "true"
            local msg = "🎮 RPG 시스템 상태\n"
            msg = msg .. string.format("활성화: %s", enabled and "✅ ON" or "❌ OFF")
            log(msg)
        else
            log("사용법: /rpg [on|off|status]")
        end
    end
end)

-- ============================================
-- 아이템 사용 버튼 함수 등록 (risu-trigger용)
-- ============================================

-- 슬롯 N번 아이템 사용 (1~15)
for i = 1, 15 do
    _G["use_item_" .. i] = function(triggerId)
        local itemName = getChatVar(triggerId, "player_item_slot_" .. i .. "_name") or ""

        if itemName == "" then
            log(string.format("⚠️ 슬롯%d에 아이템이 없습니다", i))
            return
        end

        local itemsStr = getChatVar(triggerId, "player_items") or ""
        local items = parseItemList(itemsStr)

        if (items[itemName] or 0) <= 0 then
            log(string.format("⚠️ %s 아이템이 없습니다", itemName))
            return
        end

        -- 사용 중인 아이템 저장
        setChatVar(triggerId, "using_item", itemName)
        setState(triggerId, "using_item", itemName)

        -- AI가 생성한 효과도 함께 저장
        local effectStr = getChatVar(triggerId, "item_effect_" .. itemName) or ""
        setChatVar(triggerId, "using_item_effect", effectStr)
        setState(triggerId, "using_item_effect", effectStr)

        -- 아이템 즉시 차감 (AI 응답에서 반환 태그 있으면 복원됨)
        items[itemName] = items[itemName] - 1
        local newItemsStr = serializeItemList(items)
        setChatVar(triggerId, "player_items", newItemsStr)
        setState(triggerId, "player_items", newItemsStr)

        -- 슬롯 변수 업데이트
        updateItemSlotVars(triggerId)

        -- 스냅샷도 즉시 업데이트
        setChatVar(triggerId, "snapshot_player_items", newItemsStr)

        log(string.format("🎒 슬롯%d 아이템 사용: %s (즉시 차감)", i, itemName))
    end
end

-- 전투 선택지 버튼 등록 (combat_choice_1 ~ combat_choice_6)
-- 선택지 데이터만 있으면 바로 처리 (적 추적 시스템과 독립적)
for i = 1, 6 do
    _G["combat_choice_" .. i] = function(triggerId)
        log(string.format("🎮 전투 선택지 %d번 버튼 클릭", i))

        -- 선택한 내용 가져오기
        local stat = getChatVar(triggerId, "combat_choice_" .. i .. "_stat") or ""
        local desc = getChatVar(triggerId, "combat_choice_" .. i .. "_desc") or ""
        local diff = getChatVar(triggerId, "combat_choice_" .. i .. "_diff") or ""

        if stat == "" then
            log(string.format("⚠️ 선택지 %d번: 데이터 없음 (파싱 실패)", i))
            return false
        end

        log(string.format("📋 선택지 데이터: stat=%s, desc=%s, diff=%s", stat, desc, diff))

        -- 사용자 메시지로 추가
        local message = string.format("[%s|%s|%s]", stat, desc, diff)
        addChat(triggerId, "user", message)
        log(string.format("💬 사용자 메시지 추가: %s", message))

        -- 주사위 굴림 및 결과 반환
        local success = rollChoiceDice(triggerId, i, stat, desc, diff)
        log(string.format("🎲 주사위 결과: %s", success and "성공" or "실패"))
        return success
    end
end

-- 시간 진행 함수
local function progressTime(triggerId, isFullRest)
    local currentTime = getChatVar(triggerId, "current_time") or "오전"
    local dayOfWeek = tonumber(getChatVar(triggerId, "day_of_week")) or 1
    local weekOfSeason = tonumber(getChatVar(triggerId, "week_of_season")) or 1
    local season = getChatVar(triggerId, "current_season") or "봄"

    -- 주말 내내 쉬기: 일요일 오후로 점프
    if isFullRest then
        setChatVar(triggerId, "day_of_week", "7")
        setChatVar(triggerId, "day_of_week_name", "일요일")
        setChatVar(triggerId, "current_time", "오후")
        log("⏰ 시간 진행: 주말 내내 휴식 → 일요일 오후")
        return
    end

    -- 일반 시간 진행
    if currentTime == "오전" then
        -- 오전 → 오후
        setChatVar(triggerId, "current_time", "오후")
        log(string.format("⏰ 시간 진행: 오전 → 오후 (Day %d)", dayOfWeek))
    else
        -- 오후 → 다음날 오전
        dayOfWeek = dayOfWeek + 1

        -- 주차가 끝나면 다음 주로
        if dayOfWeek > 7 then
            dayOfWeek = 1
            weekOfSeason = weekOfSeason + 1

            -- 시즌이 끝나면 다음 시즌으로
            if weekOfSeason > 12 then
                weekOfSeason = 1
                local seasons = {"봄", "여름", "가을", "겨울"}
                local currentSeasonIdx = 1
                for i, s in ipairs(seasons) do
                    if s == season then
                        currentSeasonIdx = i
                        break
                    end
                end

                local nextSeasonIdx = (currentSeasonIdx % 4) + 1
                season = seasons[nextSeasonIdx]
                setChatVar(triggerId, "current_season", season)
                setState(triggerId, "current_season", season)

                -- 시즌 플래그 업데이트
                setChatVar(triggerId, "is_spring", season == "봄" and "true" or "false")
                setChatVar(triggerId, "is_summer", season == "여름" and "true" or "false")
                setChatVar(triggerId, "is_autumn", season == "가을" and "true" or "false")
                setChatVar(triggerId, "is_winter", season == "겨울" and "true" or "false")

                log(string.format("📅 시즌 변경: %s → %s", seasons[currentSeasonIdx], season))
            end

            setChatVar(triggerId, "week_of_season", tostring(weekOfSeason))
            setState(triggerId, "week_of_season", tostring(weekOfSeason))

            -- 시험 주차 체크 (4, 8, 12주)
            if weekOfSeason == 4 or weekOfSeason == 8 or weekOfSeason == 12 then
                setChatVar(triggerId, "is_exam_week", "true")
                log(string.format("📝 Week %d 시작 - 시험 주차!", weekOfSeason))
            else
                setChatVar(triggerId, "is_exam_week", "false")
                log(string.format("📅 Week %d 시작", weekOfSeason))
            end
        end

        setChatVar(triggerId, "day_of_week", tostring(dayOfWeek))
        setChatVar(triggerId, "day_of_week_name", getDayName(dayOfWeek))
        setChatVar(triggerId, "current_time", "오전")

        log(string.format("⏰ 시간 진행: 오후 → 다음날 오전 (%s, Day %d)", getDayName(dayOfWeek), dayOfWeek))
    end
end

-- 활동 선택 버튼 함수 등록
local activities = {
    {id = "combat", message = "나는 결투장으로 향한다. 무기 거치대와 수련용 원형 경기장이 보이고, 강철이 부딪히는 소리와 함성이 들려온다."},
    {id = "magic", message = "나는 강의실로 향한다. 칠판에는 복잡한 마법 공식이 가득하고, 오래된 책의 퀴퀴한 냄새가 난다."},
    {id = "study", message = "나는 중앙 도서관으로 향한다. 여러 층으로 이루어진 거대한 서가와 곳곳의 조용한 독서 공간이 보인다."},
    {id = "skip", message = "나는 기숙사로 돌아간다. 편안한 내 방, 부드러운 침대, 창문 너머의 풍경이 나를 반긴다."},
    {id = "training", message = "나는 훈련장으로 향한다. 오전보다 한산한 분위기 속에서 자율적으로 단련할 수 있는 시간이다."},
    {id = "cafe", message = "나는 스칼렛 거리의 카페로 향한다. 커피와 페이스트리 향기, 편안한 대화 소리와 컵이 부딪히는 소리가 들린다."},
    {id = "shopping", message = "나는 루비 로우의 쇼핑가로 향한다. 북적이는 인파, 거리 공연자들, 상인들의 호객 소리가 활기차다."},
    {id = "quest", message = "나는 미드나이트 앨리로 향한다. 그림자 깊은 뒷골목, 깜빡이는 가로등, 거친 분위기와 의뢰 게시판이 보인다."},
    {id = "club", message = "나는 동아리실로 향한다. 같은 관심사를 가진 사람들과의 활동 시간이다."},
    {id = "rest", message = "나는 기숙사로 돌아가 휴식을 취한다. 개인적이고 편안한 공간에서의 시간이다."},
    {id = "date", message = "나는 데이트 약속 장소로 향한다. 설레는 마음으로 특별한 시간을 준비한다."},
    {id = "dungeon", message = "나는 던전 탐험을 위해 출발한다. 어두운 복도, 함정, 몬스터, 보물이 기다리는 위험한 모험이다."},
    {id = "fullrest", message = "나는 주말을 온전히 휴식에 할애하기로 한다. 완전한 휴식과 회복의 시간이다."}
}

for _, activity in ipairs(activities) do
    _G["activity_" .. activity.id] = function(triggerId)
        -- 사용자 메시지로 활동 추가
        addChat(triggerId, "user", activity.message)
        log(string.format("📅 활동 선택: %s", activity.message))

        -- 시간 진행
        local isFullRest = (activity.id == "fullrest")
        progressTime(triggerId, isFullRest)
    end
end

-- 주간 스케줄 조정 함수
_G["set_weekly_schedule"] = function(triggerId)
    log("주간 스케줄 조정 시작")

    -- 선택지 구성
    local morningOptions = {
        "전투 훈련", "마법 이론", "도서관 자습", "수업 빼먹기", "자유시간"
    }
    local afternoonOptions = {
        "훈련장", "카페", "쇼핑", "퀘스트", "동아리", "휴식", "자유시간"
    }

    local days = {"월요일", "화요일", "수요일", "목요일", "금요일"}
    local schedule = {}

    -- 각 날짜별로 활동 선택
    for i, day in ipairs(days) do
        -- 오전 활동 선택
        local morningChoice = alertSelect(triggerId, morningOptions)
        schedule[#schedule + 1] = morningChoice

        -- 오후 활동 선택
        local afternoonChoice = alertSelect(triggerId, afternoonOptions)
        schedule[#schedule + 1] = afternoonChoice
    end

    -- 스케줄 표시용 텍스트 생성
    local displayText = "=== 이번 주 계획 ===\n\n"
    for i, day in ipairs(days) do
        local amIdx = (i-1) * 2 + 1
        local pmIdx = (i-1) * 2 + 2
        displayText = displayText .. string.format("%s\n오전: %s\n오후: %s\n\n",
            day, schedule[amIdx] or "미정", schedule[pmIdx] or "미정")
    end

    -- 보조 AI가 읽을 스케줄 데이터 생성
    local scheduleData = ""
    for i, day in ipairs(days) do
        local amIdx = (i-1) * 2 + 1
        local pmIdx = (i-1) * 2 + 2
        scheduleData = scheduleData .. string.format("%s: 오전(%s), 오후(%s)\n",
            day, schedule[amIdx] or "자유", schedule[pmIdx] or "자유")
    end

    -- 변수에 저장
    setChatVar(triggerId, "weekly_schedule_plan", scheduleData)
    setState(triggerId, "weekly_schedule_plan", scheduleData)
    setChatVar(triggerId, "weekly_schedule_display", displayText)
    setState(triggerId, "weekly_schedule_display", displayText)

    -- 패널 새로고침
    reloadDisplay(triggerId)

    log("주간 스케줄 저장 완료")
end

-- 주간 스케줄 실행 함수
_G["execute_weekly_schedule"] = function(triggerId)
    log("주간 스케줄 실행 시작")

    -- 저장된 스케줄 확인
    local scheduleData = getState(triggerId, "weekly_schedule_plan")
    if not scheduleData or scheduleData == "" then
        alertError(triggerId, "먼저 '스케줄 조정' 버튼으로 이번 주 계획을 세워주세요!")
        return
    end

    -- 현재 주차 저장
    local currentWeek = getChatVar(triggerId, "week_of_season") or 1
    local currentSeason = getChatVar(triggerId, "current_season") or "봄"

    -- 시간을 다음 주 월요일 오전으로 이동
    local newWeek = currentWeek + 1
    if newWeek > 12 then
        -- 계절 변경 로직
        newWeek = 1
        local seasons = {
            ["봄"] = "여름",
            ["여름"] = "가을",
            ["가을"] = "겨울",
            ["겨울"] = "봄"
        }
        currentSeason = seasons[currentSeason] or "봄"
        setChatVar(triggerId, "current_season", currentSeason)
        setState(triggerId, "current_season", currentSeason)
    end

    setChatVar(triggerId, "week_of_season", newWeek)
    setState(triggerId, "week_of_season", newWeek)
    setChatVar(triggerId, "day_of_week", 1)  -- 월요일
    setState(triggerId, "day_of_week", 1)
    setChatVar(triggerId, "current_time", "오전")
    setState(triggerId, "current_time", "오전")

    -- 패널 업데이트
    updateTimePanel(triggerId)

    log(string.format("시간 이동: %s 학기 제%d주차 월요일 오전", currentSeason, newWeek))

    -- 시스템 메시지로 주간 리포트 요청
    addChat(triggerId, "system", string.format([[한 주가 지나갔습니다. (%s 학기 제%d주차 -> 제%d주차)

[주간 활동 계획이 설정되었습니다]

보조 AI는 이제 주간 스케줄을 바탕으로 이번 주의 활동 결과를 판정하고, 주간 리포트를 생성해주세요.

스케줄 정보는 {{getvar::weekly_schedule_plan}} 변수에 저장되어 있습니다.]],
        currentSeason, currentWeek, newWeek))

    log("주간 스케줄 실행 완료")
end

-- editRequest: 메인 AI 요청에서 보조모델 태그 모두 제거
listenEdit("editRequest", function(triggerId, data)
    -- <CombatChoice> 블록 제거
    data = data:gsub("<CombatChoice>.-</CombatChoice>", "")

    -- <WeeklyReport> 블록 제거
    data = data:gsub("<WeeklyReport>.-</WeeklyReport>", "")

    -- 보조모델의 모든 시스템 태그 제거
    data = data:gsub("%[Affinity:[^%]]+%]", "")
    data = data:gsub("%[Sin:[^%]]+%]", "")
    data = data:gsub("%[Stat:[^%]]+%]", "")
    data = data:gsub("%[Gold:[^%]]+%]", "")
    data = data:gsub("%[Item:[^%]]+%]", "")
    data = data:gsub("%[EXP:[^%]]+%]", "")
    data = data:gsub("%[Heal:[^%]]+%]", "")
    data = data:gsub("%[Effect:[^%]]+%]", "")
    data = data:gsub("%[Trait:[^%]]+%]", "")
    data = data:gsub("%[Combat:[^%]]+%]", "")
    data = data:gsub("%[Season:[^%]]+%]", "")
    data = data:gsub("%[Week:[^%]]+%]", "")
    data = data:gsub("%[Time:[^%]]+%]", "")
    data = data:gsub("%[Location:[^%]]+%]", "")

    -- <Panel> 마커 제거
    data = data:gsub("<Panel>[^<]*", "")

    return data
end)

-- editDisplay: <CombatChoice> 및 <ActivityChoice> 태그를 HTML 버튼으로 변환
-- ============================================
-- 디스플레이 변환 함수
-- ============================================

-- 주간 보고서 HTML 생성
local function convertWeeklyReport(content)
    -- 데이터 파싱
    local data = {}
    for pair in content:gmatch("([^|]+)") do
        local key, value = pair:match("([^:]+):(.+)")
        if key and value then
            data[key:gsub("^%s*(.-)%s*$", "%1")] = value:gsub("^%s*(.-)%s*$", "%1")
        end
    end

    -- 점수에 따른 등급 결정 (S/A/B/C/D)
    local score = tonumber(data.Score or "0")
    local grade = "D"
    local gradeEmoji = "📝"
    local gradeText = "다음에 더 잘할 수 있어요"

    if score >= 25 then
        grade = "S"
        gradeEmoji = "🏆"
        gradeText = "완벽해요!"
    elseif score >= 20 then
        grade = "A"
        gradeEmoji = "⭐"
        gradeText = "훌륭해요!"
    elseif score >= 15 then
        grade = "B"
        gradeEmoji = "✨"
        gradeText = "잘했어요!"
    elseif score >= 10 then
        grade = "C"
        gradeEmoji = "💫"
        gradeText = "괜찮아요"
    end

    -- 스탯 변화 HTML 생성
    local statsHTML = ""
    local statIcons = {
        INT = "🧠", CHA = "✨", STR = "💪",
        DEX = "🏃", VIT = "❤️", LUK = "🍀"
    }
    local statNames = {
        INT = "지능 (INT)", CHA = "매력 (CHA)", STR = "힘 (STR)",
        DEX = "민첩 (DEX)", VIT = "체력 (VIT)", LUK = "행운 (LUK)"
    }

    for stat, change in content:gmatch("([A-Z]+):([%+%-]%d+)") do
        if stat ~= "Score" and stat ~= "Week" then
            local icon = statIcons[stat] or "⭐"
            local name = statNames[stat] or stat

            statsHTML = statsHTML .. string.format([[
                <div style="display:flex;align-items:center;margin:6px 0;padding:6px 8px;background:rgba(255,255,255,0.8);border-radius:8px;box-shadow:0 2px 6px rgba(0,0,0,0.05)">
                    <div style="font-size:clamp(18px, 4vw, 20px);margin-right:8px;flex-shrink:0">%s</div>
                    <div style="flex:1;min-width:0">
                        <div style="font-size:clamp(10px, 2.2vw, 11px);color:#888">%s</div>
                        <div style="font-size:clamp(11px, 2.8vw, 13px);color:#d84c6f;font-weight:bold">성장했어요!</div>
                    </div>
                    <div style="font-size:clamp(18px, 4vw, 20px);color:#ff69b4;flex-shrink:0">↑%s</div>
                </div>
            ]], icon, name, change)
        end
    end

    -- 완전한 HTML 생성 (모바일 반응형)
    local html = string.format([[
<div style="max-width:500px;width:calc(100%% - 20px);background:linear-gradient(135deg,rgba(255,182,193,0.95) 0%%,rgba(255,218,224,0.95) 50%%,rgba(240,230,255,0.95) 100%%);border-radius:15px;box-shadow:0 8px 30px rgba(255,105,180,0.4),0 0 0 3px rgba(255,255,255,0.3);padding:0;color:#4a4a4a;margin:15px auto;font-family:'Segoe UI',sans-serif;box-sizing:border-box">
    <div style="padding:10px 15px;text-align:center;background:linear-gradient(135deg,rgba(255,105,180,0.3) 0%%,rgba(255,182,193,0.3) 100%%);border-bottom:2px solid rgba(255,255,255,0.5)">
        <h2 style="margin:0;font-size:clamp(16px, 4vw, 20px);color:#d84c6f;text-shadow:2px 2px 4px rgba(255,255,255,0.5);font-weight:bold">✨ 주간 보고서 ✨</h2>
    </div>
    <div style="padding:12px 15px">
        <div style="text-align:center;font-size:clamp(13px, 3.5vw, 15px);color:#d84c6f;font-weight:bold;margin-bottom:10px;padding:6px;background:rgba(255,255,255,0.5);border-radius:12px;box-shadow:0 2px 8px rgba(255,105,180,0.2)">
            🌸 %s 학기 Week %s 🌸
        </div>
        <div style="display:flex;gap:6px;margin-bottom:10px">
            <div style="flex:1;background:rgba(255,255,255,0.7);padding:8px;border-radius:10px;text-align:center;box-shadow:0 3px 12px rgba(0,0,0,0.1)">
                <div style="font-size:clamp(18px, 4vw, 20px);margin-bottom:3px">📚</div>
                <div style="font-size:clamp(9px, 2vw, 10px);color:#888;margin-bottom:3px">수업</div>
                <div style="font-size:clamp(11px, 3vw, 13px);color:#d84c6f;font-weight:bold">%s</div>
            </div>
            <div style="flex:1;background:rgba(255,255,255,0.7);padding:8px;border-radius:10px;text-align:center;box-shadow:0 3px 12px rgba(0,0,0,0.1)">
                <div style="font-size:clamp(18px, 4vw, 20px);margin-bottom:3px">🎯</div>
                <div style="font-size:clamp(9px, 2vw, 10px);color:#888;margin-bottom:3px">활동</div>
                <div style="font-size:clamp(11px, 3vw, 13px);color:#d84c6f;font-weight:bold">%s</div>
            </div>
        </div>
        <div style="background:linear-gradient(135deg,rgba(255,255,255,0.8) 0%%,rgba(255,240,245,0.8) 100%%);border-radius:12px;padding:12px 8px;margin:10px 0;text-align:center;box-shadow:0 3px 15px rgba(255,105,180,0.3);border:2px dashed rgba(255,105,180,0.3)">
            <div style="font-size:clamp(10px, 2.5vw, 12px);color:#888;margin-bottom:4px">이번 주 성과</div>
            <div style="font-size:clamp(32px, 10vw, 48px);margin:4px 0">%s</div>
            <div style="font-size:clamp(28px, 8vw, 40px);color:#ff69b4;font-weight:bold;text-shadow:2px 2px 4px rgba(255,105,180,0.3);letter-spacing:clamp(3px, 1.5vw, 6px)">%s</div>
            <div style="font-size:clamp(12px, 3vw, 14px);color:#d84c6f;font-weight:bold;margin-top:6px">%s</div>
        </div>
        <div style="text-align:center;margin:8px 0;font-size:clamp(14px, 3.5vw, 16px);color:#ff69b4">♥ ♥ ♥</div>
        <div style="background:rgba(255,255,255,0.6);border-radius:12px;padding:10px;box-shadow:0 3px 12px rgba(0,0,0,0.1)">
            %s
        </div>
    </div>
</div>
    ]], data.Season or "봄", data.Week or "1", data.Curriculum or "수업",
        data.Lifestyle or "활동", gradeEmoji, grade, gradeText, statsHTML)

    return html
end

listenEdit("editDisplay", function(triggerId, data)
    -- 전투 선택지 변환 (모바일 반응형)
    data = data:gsub("<CombatChoice>(.-)</CombatChoice>", function(content)
        local html = "<div style='max-width:600px;width:calc(100%% - 20px);margin:15px auto;padding:0 10px;box-sizing:border-box'>"
        local choiceIndex = 1

        for line in content:gmatch("[^\r\n]+") do
            local stat, desc, diff = line:match("%[([^|]+)|([^|]+)|([^%]]+)%]")
            if stat and desc and diff then
                -- 능력치별 이모지
                local emoji = "⚔️"
                local statUpper = stat:upper()
                local statLower = stat:lower()

                if statUpper == "STR" then emoji = "💪"
                elseif statUpper == "DEX" then emoji = "⚡"
                elseif statUpper == "INT" then emoji = "🧠"
                elseif statUpper == "CHA" then emoji = "💬"
                elseif statUpper == "LUK" then emoji = "🍀"
                elseif statLower == "escape" or statLower == "flee" or statLower == "run" or stat == "도망" then
                    emoji = "🏃"
                else
                    emoji = "⚔️"  -- 기타 미인식 능력치는 기본 아이콘
                end

                -- 난이도별 색상 (그라디언트)
                local gradient = "linear-gradient(135deg, #666 0%, #888 100%)"
                local shadow = "0 2px 8px rgba(0,0,0,0.3)"
                if diff == "Very Easy" then
                    gradient = "linear-gradient(135deg, #4CAF50 0%, #66BB6A 100%)"
                    shadow = "0 2px 8px rgba(76,175,80,0.4)"
                elseif diff == "Easy" then
                    gradient = "linear-gradient(135deg, #8BC34A 0%, #9CCC65 100%)"
                    shadow = "0 2px 8px rgba(139,195,74,0.4)"
                elseif diff == "Normal" then
                    gradient = "linear-gradient(135deg, #FFC107 0%, #FFD54F 100%)"
                    shadow = "0 2px 8px rgba(255,193,7,0.4)"
                elseif diff == "Hard" then
                    gradient = "linear-gradient(135deg, #FF9800 0%, #FFB74D 100%)"
                    shadow = "0 2px 8px rgba(255,152,0,0.4)"
                elseif diff == "Very Hard" then
                    gradient = "linear-gradient(135deg, #F44336 0%, #EF5350 100%)"
                    shadow = "0 2px 8px rgba(244,67,54,0.4)"
                end

                html = html .. string.format(
                    "<button type='button' risu-trigger='combat_choice_%d' style='display:flex;align-items:center;justify-content:space-between;width:100%%;max-width:580px;margin:6px auto;padding:10px 15px;background:%s;color:white;border:none;border-radius:8px;box-shadow:%s;font-size:clamp(12px, 3vw, 14px);font-weight:500;cursor:pointer;transition:all 0.2s ease;box-sizing:border-box'><span style='flex:1;min-width:0;text-align:left'>%s <strong>[%s]</strong> %s</span><span style='opacity:0.9;font-size:clamp(10px, 2.5vw, 12px);margin-left:8px;flex-shrink:0'>%s</span></button>",
                    choiceIndex, gradient, shadow, emoji, stat, desc, diff
                )

                choiceIndex = choiceIndex + 1
            end
        end

        html = html .. "</div>"
        return html
    end)

    -- 주간 보고서 변환
    data = data:gsub("<WeeklyReport>([^<]+)</WeeklyReport>", convertWeeklyReport)

    return data
end)

-- ============================================
-- 주간 스케줄 시스템
-- ============================================

-- 더미 데이터 (나중에 실제 데이터로 교체)
local house_professors = {
    Serpent = {
        "Professor A (STR/DEX focus)",
        "Professor B (INT/CHA focus)",
        "Professor C (Balanced)"
    },
    Aconitum = {
        "Professor D (STR focus)",
        "Professor E (VIT focus)",
        "Professor F (Combat Magic)"
    },
    Wisteria = {
        "Professor G (INT focus)",
        "Professor H (Theory)",
        "Professor I (Practical)"
    },
    Lotus = {
        "Professor J (Healing)",
        "Professor K (Support)",
        "Professor L (Balance)"
    }
}

local lifestyles = {
    "Social (사교/매력 향상)",
    "Training (개인 훈련/자기계발)",
    "Club (동아리 활동)",
    "Adventure (교외 활동/퀘스트)",
    "Rest (휴식/회복)"
}

-- 주간 커리큘럼 선택 함수
_G["select_curriculum"] = function(triggerId)
    -- 1. 소속 하우스 확인
    local house = getChatVar(triggerId, "player_house") or "Serpent"

    -- 2. 해당 하우스 교수 목록 가져오기
    local professors = house_professors[house]
    if not professors then
        log("❌ 하우스 정보 없음: " .. house)
        return
    end

    -- 3. 커리큘럼 선택
    local curriculumIdx = alertSelect(triggerId, professors, "이번 주 담당 교수를 선택하세요")
    if not curriculumIdx or curriculumIdx < 1 or curriculumIdx > #professors then
        log("❌ 커리큘럼 선택 취소")
        return
    end
    local curriculum = professors[curriculumIdx]

    -- 4. 라이프스타일 선택
    local lifestyleIdx = alertSelect(triggerId, lifestyles, "이번 주 방과후 라이프스타일을 선택하세요")
    if not lifestyleIdx or lifestyleIdx < 1 or lifestyleIdx > #lifestyles then
        log("❌ 라이프스타일 선택 취소")
        return
    end
    local lifestyle = lifestyles[lifestyleIdx]

    -- 5. 변수 저장 (AI에게 명령하지 않음!)
    setChatVar(triggerId, "current_curriculum", curriculum)
    setChatVar(triggerId, "current_lifestyle", lifestyle)

    log("📚 Week " .. (getChatVar(triggerId, "week_of_season") or "?") .. " 선택 완료")
    log("  커리큘럼: " .. curriculum)
    log("  라이프스타일: " .. lifestyle)
end

-- ============================================
-- 주간 스케줄 버튼 함수 (HTML 버튼용)
-- ============================================

-- 커리큘럼 선택 함수 (1~7)
local curriculum_names = {
    "Vivienne", "Robert", "Scar", "Margot", "Lydia", "Hemlock", "Margaret"
}

for i = 1, 7 do
    _G["set_curriculum_" .. i] = function(triggerId)
        setChatVar(triggerId, "current_curriculum", curriculum_names[i])
        log("📚 커리큘럼 선택: " .. curriculum_names[i])
    end
end

-- 라이프스타일 선택 함수 (1~5)
local lifestyle_names = {
    "Social", "Training", "Club", "Adventure", "Rest"
}

for i = 1, 5 do
    _G["set_lifestyle_" .. i] = function(triggerId)
        setChatVar(triggerId, "current_lifestyle", lifestyle_names[i])
        log("🌟 라이프스타일 선택: " .. lifestyle_names[i])
    end
end

-- 보조 AI 모델 선택 함수
_G["set_aux_mode_auxiliary"] = function(triggerId)
    setState(triggerId, "auxiliary_mode", "2")
    setChatVar(triggerId, "auxiliary_mode", "2")
    setChatVar(triggerId, "auxiliary_mode_text", "보조 모델")
    alertNormal(triggerId, "보조 AI가 [보조 모델]을 사용하도록 설정되었습니다.")
end

_G["set_aux_mode_main"] = function(triggerId)
    setState(triggerId, "auxiliary_mode", "1")
    setChatVar(triggerId, "auxiliary_mode", "1")
    setChatVar(triggerId, "auxiliary_mode_text", "메인 모델")
    alertNormal(triggerId, "보조 AI가 [메인 모델]을 사용하도록 설정되었습니다.")
end

_G["set_aux_mode_off"] = function(triggerId)
    setState(triggerId, "auxiliary_mode", "0")
    setChatVar(triggerId, "auxiliary_mode", "0")
    setChatVar(triggerId, "auxiliary_mode_text", "Off (로어북)")
    alertNormal(triggerId, "보조 AI가 [Off]로 설정되었습니다. 메인 모델이 로어북의 지시를 따라 태그를 출력합니다.")
end

_G["reset_all_stats_to_50"] = function(triggerId)
    local stats = {"str", "dex", "int", "cha", "luk", "vit"}

    for _, stat in ipairs(stats) do
        local key = "player_" .. stat
        setChatVar(triggerId, key, "50")
        setState(triggerId, key, 50)
    end

    -- 레벨도 1로 초기화
    setChatVar(triggerId, "player_level", "1")
    setState(triggerId, "player_level", 1)
    setChatVar(triggerId, "player_exp", "0")
    setState(triggerId, "player_exp", 0)

    -- 전투력 재계산
    local maxCombatPower = calculateCombatPower(triggerId)
    setChatVar(triggerId, "player_combat_power_max", tostring(maxCombatPower))
    setChatVar(triggerId, "player_combat_power", tostring(maxCombatPower))
    setState(triggerId, "player_combat_power_max", maxCombatPower)
    setState(triggerId, "player_combat_power", maxCombatPower)

    alertNormal(triggerId, "모든 스탯이 50으로 초기화되었습니다. (레벨 1, EXP 0)")
    log("🔄 스탯 초기화: 모든 스탯 50, 레벨 1")
    return true
end

-- 보조 AI 리롤 함수
_G["reroll_auxiliary"] = function(triggerId)
    log("🎲 보조 AI 리롤 시작")

    -- 현재 메시지 가져오기
    -- 주의: onButtonClick에서 "재생성 중..." 임시 메시지를 추가했으므로
    -- 실제 AI 응답은 마지막에서 두 번째(-2) 위치에 있음
    local full_chat = getFullChat(triggerId)
    if not full_chat or #full_chat < 2 then
        alertError(triggerId, "채팅 기록이 부족합니다.")
        return false
    end

    -- 마지막은 임시 메시지, 그 앞이 실제 AI 응답
    local chatIndex = #full_chat - 1
    local lastMessage = full_chat[chatIndex]

    -- AI 메시지인지 확인
    if lastMessage.role ~= "char" then
        alertError(triggerId, "대상 메시지가 AI 응답이 아닙니다.")
        return false
    end

    local message = lastMessage.data

    -- editDisplay에서 추가한 리롤 버튼 제거 (실제 데이터에는 없어야 하지만 안전을 위해)
    local cleanMessage = message:gsub('<div style="margin%-top:20px.-</div>', "")

    -- <Panel>■★ 위치 찾기 (메인 모델 응답과 보조 응답 구분)
    local panelPos = cleanMessage:find("<Panel>■★", 1, true)
    local mainResponse

    if panelPos then
        -- 마커가 있으면 기존 메인 응답 추출
        mainResponse = cleanMessage:sub(1, panelPos - 1)
    else
        -- 마커가 없으면 "<Panel" 또는 첫 번째 태그까지만 추출
        local partialPanelPos = cleanMessage:find("<Panel", 1, true)
        local firstTagPos = cleanMessage:find("%[Affinity:", 1, false) or
                           cleanMessage:find("%[Sin:", 1, false) or
                           cleanMessage:find("%[Location:", 1, false)

        local cutPos = nil
        if partialPanelPos and firstTagPos then
            cutPos = math.min(partialPanelPos, firstTagPos)
        elseif partialPanelPos then
            cutPos = partialPanelPos
        elseif firstTagPos then
            cutPos = firstTagPos
        end

        if cutPos then
            mainResponse = cleanMessage:sub(1, cutPos - 1)
            log("⚠️ <Panel>■★ 마커 없음 - 태그 시작 위치에서 자름 (pos: " .. cutPos .. ")")
        else
            mainResponse = cleanMessage
            log("⚠️ <Panel>■★ 마커 없음 - 태그 발견 안됨, 전체 사용")
        end
    end

    -- 보조모델 태그 제거 (혹시 남아있을 수 있으니 한번 더 정리)
    mainResponse = mainResponse:gsub("%[Affinity:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Sin:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Stat:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Gold:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Item:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[EXP:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Heal:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Effect:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Trait:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Combat:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Location:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Season:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Week:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[Time:[^%]]+%]", "")
    mainResponse = mainResponse:gsub("%[SIN_RESET:[^%]]+%]", "")

    -- 끝 공백 제거
    mainResponse = mainResponse:gsub("%s+$", "")

    log("📝 메인 응답 길이: " .. #mainResponse)

    -- 스냅샷으로 복원 (이전 태그 효과 롤백)
    for _, char in ipairs(characters) do
        restoreSnapshot(triggerId, char)
    end

    local rpgEnabled = getChatVar(triggerId, "rpg_system_enabled") == "true"
    if rpgEnabled then
        restoreRpgSnapshot(triggerId)
    end

    log("↩️ 스냅샷 복원 완료")

    -- 보조모델 다시 호출
    local auxiliaryMessage = callAuxiliaryModel(triggerId, mainResponse)
    log("🔄 보조모델 재호출 완료")

    -- 태그 파싱 (메인 + 보조)
    local combinedSource = mainResponse .. "\n" .. auxiliaryMessage

    -- 상태창 태그 파싱
    parseStatusWindow(triggerId, combinedSource)

    -- SIN RESET 처리
    for charStorage, sinType in combinedSource:gmatch("%[SIN_RESET:(%w+)_(pos|neg)%]") do
        local countKey = charStorage .. "_sin_" .. sinType .. "_count"
        local gaugeKey = charStorage .. "_sin_" .. sinType

        local currentCount = tonumber(getChatVar(triggerId, countKey)) or 0

        setChatVar(triggerId, countKey, tostring(currentCount + 1))
        setChatVar(triggerId, gaugeKey, "0")

        for _, char in ipairs(characters) do
            if char.storage == charStorage then
                updatePercent(triggerId, char)
                log(string.format("🔄 %s %s %s 리셋! 카운트: %d → %d",
                    char.icon, char.display, sinType == "pos" and "압력" or "해소",
                    currentCount, currentCount + 1))
                break
            end
        end
    end

    -- 호감도 파싱
    for charName, feeling in combinedSource:gmatch("%[Affinity:(%w+):(%w+)%]") do
        for _, char in ipairs(characters) do
            if char.display == charName and affinityChanges[feeling] then
                local key = char.storage .. "_affinity"
                local current = tonumber(getChatVar(triggerId, key)) or 0
                local change = affinityChanges[feeling]
                local new = clampValue(current + change, AFFINITY_MIN, AFFINITY_MAX)

                setChatVar(triggerId, key, tostring(new))

                local prevChange = tonumber(getChatVar(triggerId, char.storage .. "_change_affinity")) or 0
                setChatVar(triggerId, char.storage .. "_change_affinity", tostring(prevChange + change))

                if char.is_main then
                    setChatVar(triggerId, char.storage .. "_route", getRouteText(checkEnding(new)))
                end

                updatePercent(triggerId, char)
                log(string.format("💕 %s 호감도: %d → %d (%s, %+d)",
                    char.display, current, new, feeling, change))
                break
            end
        end
    end

    -- Sin 변화 파싱
    for charName, sinType, change in combinedSource:gmatch("%[Sin:(%w+):(pos|neg):([%+%-]?%d+)%]") do
        for _, char in ipairs(characters) do
            if char.display == charName and char.has_sin then
                local key = char.storage .. "_sin_" .. sinType
                local current = tonumber(getChatVar(triggerId, key)) or 0
                local delta = tonumber(change) or 0
                local new = clampValue(current + delta, SIN_MIN, SIN_MAX)

                setChatVar(triggerId, key, tostring(new))

                local changeKey = char.storage .. "_change_sin_" .. sinType
                local prevChange = tonumber(getChatVar(triggerId, changeKey)) or 0
                setChatVar(triggerId, changeKey, tostring(prevChange + delta))

                updatePercent(triggerId, char)
                log(string.format("😈 %s %s: %d → %d (%+d)",
                    char.display, sinType == "pos" and "압력" or "해소",
                    current, new, delta))
                break
            end
        end
    end

    -- RPG 태그 파싱
    if rpgEnabled then
        parseStatChanges(triggerId, combinedSource)
        parseGoldChanges(triggerId, combinedSource)
        parseExpChanges(triggerId, combinedSource)
        parseHeal(triggerId, combinedSource)
        parseItems(triggerId, combinedSource)
        parseTraits(triggerId, combinedSource)
        parseEffects(triggerId, combinedSource)
        parseExams(triggerId, combinedSource)
    end

    -- UI 업데이트
    for _, char in ipairs(characters) do
        updatePercent(triggerId, char)
    end

    if rpgEnabled then
        updateRpgDisplayVars(triggerId)
    end

    -- 메시지 업데이트 (음수 인덱스 사용)
    -- -2 = 임시 메시지(-1) 앞의 실제 AI 응답
    local finalMessage = mainResponse .. "\n\n" .. auxiliaryMessage
    setChat(triggerId, -2, finalMessage)

    alertNormal(triggerId, "🎲 보조 AI 리롤 완료!")
    log("✅ 보조 AI 리롤 완료")
    return true
end

-- 스케줄 시작 함수
_G["start_weekly_schedule"] = function(triggerId)
    local curriculum = getChatVar(triggerId, "current_curriculum") or "선택 안 함"
    local lifestyle = getChatVar(triggerId, "current_lifestyle") or "선택 안 함"

    local message = string.format(
        "<-OOC: {{user}}는 선택한 커리큘럼(%s)과 라이프스타일(%s)로 주간 활동을 진행한다. 현재 요일부터 금요일까지의 주간 요약을 작성하세요.->",
        curriculum, lifestyle
    )

    addChat(triggerId, "user", message)
    log("📅 주간 스케줄 시작: " .. curriculum .. " + " .. lifestyle)

    -- AI 응답 후 초기화하기 위한 플래그 설정
    setState(triggerId, "schedule_needs_reset", true)
end

-- AI 턴 종료 후 스케줄 선택값 초기화
function onEndOfTurn(e)
    local triggerId = e.scriptId

    if getState(triggerId, "schedule_needs_reset") == true then
        setChatVar(triggerId, "current_curriculum", "")
        setState(triggerId, "current_curriculum", "")
        setChatVar(triggerId, "current_lifestyle", "")
        setState(triggerId, "current_lifestyle", "")
        setState(triggerId, "schedule_needs_reset", false)
        log("🔄 주간 스케줄 선택값 초기화 완료")
    end
end

log("🥀 Belladonna Academy v7.3 - Optimized System")
log("✅ 로어북 기준 장소명 정리 + RPG 시스템 통합")
log("📍 Scarlet Street, Midnight Alley, Lotus Street, Ruby Row 등")
log("🌐 한영 병기 출력 텍스트")
log("🎮 RPG: Stats, Gold, Items, Traits (서술용), EXP/Level")
log("👨‍⚖️ 보조모델: STATUS_OUTPUT_INSTRUCTIONS_v2.0.md 참조")
log("🔄 명령어: /status, /schedule, /reset, /resetstats, /test")
log("🎒 아이템: 슬롯 기반 HTML 생성, 접을 수 있는 인벤토리, 최대 15개 표시")
log("🌟 특성: 동적 HTML 생성, 접을 수 있는 특성 목록")
log("🔘 아이템 버튼: use_item_1~15 등록 완료")
log("⚔️ 전투 버튼: combat_choice_1~6 등록 완료")
log("📅 활동 버튼: activity_combat, activity_magic 등 13개 등록 완료")
log("📺 editDisplay 리스너: <CombatChoice>, <WeeklyReport> 태그를 HTML로 변환")
log("🚫 editRequest 리스너: 메인 AI 요청에서 보조모델 태그 모두 제거 (Affinity/Sin/Stat/Gold/Item/EXP/Heal/Effect/Trait/Combat/Season/Week/Time/Location/Panel/WeeklyReport)")

-- ============================================
-- 보조 AI 리롤 버튼 표시 (editDisplay)
-- ============================================

listenEdit("editDisplay", function(triggerId, data, meta)
    -- 보조모델이 꺼져있으면 버튼 표시 안함
    local auxiliaryMode = getChatVar(triggerId, "auxiliary_mode") or "off"
    if auxiliaryMode == "off" then
        return data
    end

    -- meta 정보가 없으면 버튼 표시 안함
    if not meta or not meta.index then
        return data
    end

    -- 실제 채팅 배열을 가져와서 정확히 확인
    local fullChat = getFullChat(triggerId)
    if not fullChat or #fullChat == 0 then
        return data
    end

    -- 마지막 메시지가 맞는지 확인
    local lastMessage = fullChat[#fullChat]
    if not lastMessage then
        return data
    end

    -- meta.index가 실제 마지막 메시지의 인덱스와 일치하는지 확인
    if meta.index ~= #fullChat then
        return data
    end

    -- 캐릭터 메시지인지 확인 (user 메시지는 제외)
    if lastMessage.role ~= "char" then
        return data
    end

    -- 보조모델이 실행된 메시지인지 확인 (태그나 Panel이 있어야 함)
    local hasAuxiliaryOutput = data:find("%[Affinity:", 1, false) or
                               data:find("%[Sin:", 1, false) or
                               data:find("%[Location:", 1, false) or
                               data:find("<Panel", 1, true)

    if not hasAuxiliaryOutput then
        return data
    end

    -- 이미 리롤 버튼이 있으면 중복 추가 방지
    if data:find('risu%-btn="reroll_auxiliary"', 1, true) then
        return data
    end

    -- 리롤 버튼 (우측 하단 배치)
    local rerollButton = [[

<div style="margin-top:8px;padding-top:8px;border-top:1px solid #e0d5c7;text-align:right;">
<button type="button" risu-btn="reroll_auxiliary" style="background:#f5f1e8;border:1px solid #d4c4a8;border-radius:6px;padding:8px 20px;color:#8b7355;font-size:13px;font-weight:600;cursor:pointer;transition:all 0.15s ease;" onmouseover="this.style.background='#ede9dd';this.style.borderColor='#8b7355'" onmouseout="this.style.background='#f5f1e8';this.style.borderColor='#d4c4a8'">🔄 보조 AI 리롤</button>
</div>]]

    return data .. rerollButton
end)

-- ============================================
-- 보조 AI 리롤 버튼 클릭 핸들러
-- ============================================

onButtonClick = async(function(triggerId, code)
    if code == "reroll_auxiliary" then
        -- 재생성 중 표시
        addChat(triggerId, 'char', '<div style="padding:20px;text-align:center;color:#3498db;font-weight:600;">🎲 보조 AI 재생성 중...</div>')

        -- reroll_auxiliary 함수 호출
        local success, result = pcall(_G["reroll_auxiliary"], triggerId)

        -- 임시 메시지 제거
        removeChat(triggerId, -1)

        if not success then
            alertError(triggerId, "리롤 실패: " .. tostring(result))
            log("❌ 리롤 실패: " .. tostring(result))
        end
    end
end)

log("🎲 보조 AI 리롤 버튼: editDisplay + onButtonClick 등록 완료")
