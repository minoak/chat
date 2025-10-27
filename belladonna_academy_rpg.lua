-- Belladonna Academy System v7.0 - RPG Edition
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
  [Stat:stat_id:±value][Gold:±value][Item:Action:Name:Qty:Effect][EXP:±value]
  [Trait:Name:Category:Effect:Value:Condition]
  [Season:계절][Week:주차][Time:시간][Location:장소]
  <Panel>■★

자세한 사용법은 STATUS_OUTPUT_INSTRUCTIONS_v2.0.md 파일 참조
==============================================
]]

-- ============================================
-- 설정 섹션
-- ============================================

local characters = {
    {display = "Mirabel", storage = "mirabel", sin_type = "탐욕", icon = "💰", is_main = true},
    {display = "Celestia", storage = "celestia", sin_type = "오만", icon = "👑", is_main = true},
    {display = "Cassandra", storage = "cassandra", sin_type = "분노", icon = "👊", is_main = true},
    {display = "Evangeline", storage = "evangeline", sin_type = "색욕", icon = "💋", is_main = true},
    {display = "Amelia", storage = "amelia", sin_type = "질투", icon = "🎨", is_main = true},
    {display = "Nepenthes", storage = "nepenthes", sin_type = "폭식", icon = "🌺", is_main = true},
    {display = "Lilith", storage = "lilith", sin_type = "나태", icon = "📱", is_main = true},
    {display = "Aurelia", storage = "aurelia", sin_type = "타락", icon = "☀️", is_main = true},
    {display = "Cordelia", storage = "cordelia", icon = "💎", is_main = false},
    {display = "Suah", storage = "suah", icon = "🌙", is_main = false},
    {display = "Adelheid", storage = "adelheid", icon = "❄️", is_main = false},
    {display = "Rosalie", storage = "rosalie", icon = "🌸", is_main = false},
    {display = "Mika", storage = "mika", icon = "🎵", is_main = false},
    {display = "Clover", storage = "clover", icon = "🍀", is_main = false}
}

local affinityChanges = {
    love = 20,
    like = 15,
    neutral = 0,
    dislike = -15,
    hate = -20
}

local sinPosChanges = {
    corrupt = 10,
    tempt = 5
}

local sinNegChanges = {
    resist = 5,
    purify = 10
}

local AFFINITY_MAX = 500
local AFFINITY_MIN = -500
local SIN_MAX = 30

-- ============================================
-- RPG 시스템 설정
-- ============================================

local STAT_MIN = 0
local STAT_MAX = 100
local STAT_DEFAULT = 50

local playerStats = {"str", "int", "dex", "cha", "luk", "vit"}

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
You are the System Judge for Belladonna Academy RPG. Analyze the Main AI's output and generate status tags.

## Mandatory Output Format
[Affinity:CharacterName:level][Sin:CharacterName:level]
[Stat:stat_id:±value][Gold:±value][Item:Action:Name:Qty:Effect][EXP:±value]
[Trait:Name:Category:Effect:Value:Condition]
[Season:계절][Week:주차][Time:시간][Location:장소]
<Panel>■★

## Output Rules
### Character State
- Affinity: Judge how character's feelings changed THIS TURN
- Sin: Judge how character's deadly sin manifested THIS TURN
- Output every turn based on character's current emotional state
- Multiple characters = multiple tag pairs

### RPG System
- Stat: Output when stats increase/decrease from events
- Gold: Output when gold is gained/spent
- Item: Output when items are acquired/used/removed
- EXP: Output when experience is gained
- Trait: Output when new trait is acquired

### Environment
- Season: Output when season changes or first turn (봄/여름/가을/겨울)
- Week: Output when week changes or first turn (1~12)
- Time: Output ONLY when time passes (오전/오후/저녁/밤/심야)
- Location: Output ONLY when location changes
- Omit tags if unchanged

## Critical
- Use character's first name from list below
- <Panel>■★ must be absolute last line

---
## Characters in This Story
Mirabel, Celestia, Cassandra, Evangeline, Amelia, Nepenthes, Lilith, Aurelia, Cordelia, Suah, Adelheid, Rosalie, Mika, Clover

Examples:
- Wrong: [Affinity:{{user}}:like] or [Affinity:Mirabel von Goldenrose:like]
- Right: [Affinity:Mirabel:like]

---
## Affinity Levels
Question: "How did this character's feelings toward {{user}} change THIS TURN?"

| Level | Meaning |
|-------|---------|
| love | Major positive shift - Life-changing moment, profound breakthrough |
| like | Moderate positive - Genuinely kind act, felt warmth/attraction |
| neutral | No significant change - Normal interaction |
| dislike | Moderate negative - Annoyed/disappointed, felt frustration |
| hate | Major negative - Deep hurt/betrayal, relationship damage |

---
## Sin Levels
Question: "How did this character's deadly sin manifest THIS TURN?"

| Level | Meaning |
|-------|---------|
| corrupt | Heavily indulged - Surrendered to sin |
| tempt | Moderately indulged - Sin influenced behavior |
| neutral | No change - Sin dormant |
| resist | Moderately resisted - Fought against sin |
| purify | Strongly overcame - Sin diminished through growth |

---
## RPG System Tags

### Stats: [Stat:stat_id:±value]
Stats: str(strength), int(intelligence), dex(dexterity), cha(charisma), luk(luck), vit(vitality/HP)
Range: 0-100
Initial assignment: Analyze {{user}} persona, assign 40-70 (default 50)

**Stats can be used in ANY situation, not just combat:**
- Combat: STR (melee), DEX (dodge/ranged), INT (magic), VIT (endurance), LUK (critical/fumble)
- Exams/Tests: INT (written exam), DEX (practical test), CHA (presentation)
- Social Events: CHA (persuasion/seduction), LUK (games/fortune telling)
- Physical Challenges: STR (athletics), VIT (stamina), DEX (acrobatics)
- Comic/Random Events: LUK (lucky accidents, embarrassing fumbles, wardrobe malfunctions)
- Any creative scenario can trigger stat checks, rewards (EXP/Gold/Items), or stat increases
- Even silly/humorous situations can become "battles" with choices and stat-based outcomes

### Gold: [Gold:±value]
Quest rewards, purchases, trading

### Items: [Item:Action:Name:Qty:Effect]
Actions: Add (acquire), Use (consume), Remove (discard)
Effects: hp+20, str+5, gold+100 (or empty for key items)

### EXP: [EXP:±value]
Quest completion, combat victory, skill success

### Traits: [Trait:Name:Category:Effect:Value:Condition]
Format: Name:Category:Effect:NumericValue:Condition
Conditions: always, vs_X (vs_dragons), low_hp, high_hp, in_combat, night_time, day_time

---
## Examples

### First output or season/week change
[Affinity:Mirabel:like][Sin:Mirabel:neutral][Season:봄][Week:1][Time:오전][Location:중앙 광장]
<Panel>■★

### Combat with rewards
[Affinity:Mirabel:like][Sin:Mirabel:resist][Stat:str:+3][Gold:+500][EXP:+100][Trait:Dragon_Slayer:Combat:damage_bonus:20:vs_dragons]
<Panel>■★

### Normal interaction (environment unchanged)
[Affinity:Celestia:hate][Sin:Celestia:tempt]
<Panel>■★

### Shopping
[Affinity:Clover:neutral][Sin:Clover:neutral][Gold:-500][Item:Add:회복포션:1:hp+20]
<Panel>■★

### Week change only
[Affinity:Cassandra:like][Sin:Cassandra:resist][Week:5]
<Panel>■★

### Multiple characters with time change
[Affinity:Evangeline:love][Sin:Evangeline:corrupt][Affinity:Amelia:neutral][Sin:Amelia:neutral][Time:밤][Location:Club Moonlight]
<Panel>■★

### Season transition (new semester)
[Season:여름][Week:1][Time:오전]
<Panel>■★
No character interaction this turn, but new semester started

### Exam/Test scenario
[Affinity:Celestia:like][Sin:Celestia:neutral][Stat:int:+2][EXP:+50]
<Panel>■★

### Comic/Random event (LUK-based fumble)
[Affinity:Mirabel:dislike][Sin:Mirabel:neutral][Stat:luk:-1][Gold:-100]
<Panel>■★
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

    -- 아이템 HTML 생성
    local itemsStr = getChatVar(triggerId, "player_items") or ""
    local items = parseItemList(itemsStr)
    local itemsHtml = ""
    local hasItems = false

    for name, count in pairs(items) do
        if count > 0 then
            hasItems = true
            itemsHtml = itemsHtml .. string.format(
                '<span style="padding:4px 8px;background:#f9f6f0;border:1px solid #d4c4a8;border-radius:3px;color:#5d4e37;font-size:11px;">%s x%d</span>',
                name, count
            )
        end
    end

    setChatVar(triggerId, "player_items_html", itemsHtml)
    setChatVar(triggerId, "player_items_display", hasItems and "block" or "none")

    -- 특성 HTML 생성
    local traitsStr = getChatVar(triggerId, "player_traits") or ""
    local traitIds = parseTraitIdList(traitsStr)
    local traitsHtml = ""
    local hasTraits = #traitIds > 0

    for _, traitId in ipairs(traitIds) do
        local traitName = getChatVar(triggerId, "trait_" .. traitId .. "_name") or "Unknown"
        local category = getChatVar(triggerId, "trait_" .. traitId .. "_category") or ""
        local effect = getChatVar(triggerId, "trait_" .. traitId .. "_effect") or ""
        local value = getChatVar(triggerId, "trait_" .. traitId .. "_value") or ""

        traitsHtml = traitsHtml .. string.format(
            '<div style="padding:4px 8px;background:#f9f6f0;border:1px solid #d4c4a8;border-radius:3px;color:#5d4e37;font-size:11px;"><strong>%s</strong> [%s] %s +%s</div>',
            traitName, category, effect, value
        )
    end

    setChatVar(triggerId, "player_traits_html", traitsHtml)
    setChatVar(triggerId, "player_traits_display", hasTraits and "block" or "none")
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
    for statId, changeStr in message:gmatch("%[Stat:(%w+):([%+%-]%d+)%]") do
        local change = tonumber(changeStr) or 0
        local key = "player_" .. statId:lower()
        local current = tonumber(getChatVar(triggerId, key)) or STAT_DEFAULT
        local new = clampValue(current + change, STAT_MIN, STAT_MAX)

        setChatVar(triggerId, key, tostring(new))

        -- 변경량 추적
        local changeKey = key .. "_change"
        local prevChange = tonumber(getChatVar(triggerId, changeKey)) or 0
        setChatVar(triggerId, changeKey, tostring(prevChange + change))

        local displayName = statDisplayNames[statId:lower()] or statId
        log(string.format("📊 %s %+d | 현재: %d", displayName, change, new))
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

-- 아이템 추가
function addItem(triggerId, itemName, quantity)
    local itemsStr = getChatVar(triggerId, "player_items") or ""
    local items = parseItemList(itemsStr)

    items[itemName] = (items[itemName] or 0) + quantity

    setChatVar(triggerId, "player_items", serializeItemList(items))

    log(string.format("📦 아이템 획득: %s x%d", itemName, quantity))
end

-- 아이템 제거
function removeItem(triggerId, itemName, quantity)
    local itemsStr = getChatVar(triggerId, "player_items") or ""
    local items = parseItemList(itemsStr)

    local currentCount = items[itemName] or 0
    if currentCount >= quantity then
        items[itemName] = currentCount - quantity
        setChatVar(triggerId, "player_items", serializeItemList(items))
        log(string.format("🗑️ 아이템 제거: %s x%d", itemName, quantity))
        return true
    else
        log(string.format("❌ 아이템 부족: %s (보유: %d, 필요: %d)", itemName, currentCount, quantity))
        return false
    end
end

-- 아이템 효과 적용
function applyItemEffect(triggerId, effect)
    if not effect or effect == "" then return end

    -- 효과 파싱: "hp+20", "str+5", "gold+100" 등
    local stat, value = effect:match("(%w+)([%+%-]%d+)")
    if not stat or not value then return end

    value = tonumber(value) or 0

    if stat == "hp" then
        -- HP 효과 = VIT 증가
        local current = tonumber(getChatVar(triggerId, "player_vit")) or STAT_DEFAULT
        local new = clampValue(current + value, STAT_MIN, STAT_MAX)
        setChatVar(triggerId, "player_vit", tostring(new))

        local changeKey = "player_vit_change"
        local prevChange = tonumber(getChatVar(triggerId, changeKey)) or 0
        setChatVar(triggerId, changeKey, tostring(prevChange + value))

        log(string.format("💊 HP 회복: %+d (VIT %d → %d)", value, current, new))

    elseif stat == "gold" then
        local current = tonumber(getChatVar(triggerId, "player_gold")) or 0
        local new = math.max(0, current + value)
        setChatVar(triggerId, "player_gold", tostring(new))

        local prevChange = tonumber(getChatVar(triggerId, "player_gold_change")) or 0
        setChatVar(triggerId, "player_gold_change", tostring(prevChange + value))

        log(string.format("💰 골드: %+d", value))

    else
        -- 일반 스탯 (str, int, dex, cha, luk, vit)
        local key = "player_" .. stat:lower()
        local current = tonumber(getChatVar(triggerId, key)) or STAT_DEFAULT
        local new = clampValue(current + value, STAT_MIN, STAT_MAX)
        setChatVar(triggerId, key, tostring(new))

        local changeKey = key .. "_change"
        local prevChange = tonumber(getChatVar(triggerId, changeKey)) or 0
        setChatVar(triggerId, changeKey, tostring(prevChange + value))

        local displayName = statDisplayNames[stat:lower()] or stat:upper()
        log(string.format("📊 %s: %+d", displayName, value))
    end
end

-- 아이템 사용
function useItem(triggerId, itemName, quantity, effect)
    if removeItem(triggerId, itemName, quantity) then
        applyItemEffect(triggerId, effect)
        log(string.format("✨ %s 사용!", itemName))
        return true
    end
    return false
end

-- 아이템 태그 파싱
function parseItems(triggerId, message)
    -- 형식: [Item:Add:name:qty:effect] 또는 [Item:Use:name:qty:effect] 또는 [Item:Remove:name:qty]
    for itemTag in message:gmatch("%[Item:[^%]]+%]") do
        local action, name, qty, effect = itemTag:match("%[Item:([^:]+):([^:]+):(%d+):?([^%]]*)%]")

        if action and name and qty then
            qty = tonumber(qty) or 1

            if action == "Add" then
                addItem(triggerId, name, qty)
            elseif action == "Use" then
                useItem(triggerId, name, qty, effect)
            elseif action == "Remove" then
                removeItem(triggerId, name, qty)
            end
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
function addTrait(triggerId, traitId, traitName, category, effect, value, condition)
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

    -- Trait 세부 정보 저장
    setChatVar(triggerId, "trait_" .. traitId .. "_name", traitName)
    setChatVar(triggerId, "trait_" .. traitId .. "_category", category)
    setChatVar(triggerId, "trait_" .. traitId .. "_effect", effect)
    setChatVar(triggerId, "trait_" .. traitId .. "_value", value)
    setChatVar(triggerId, "trait_" .. traitId .. "_condition", condition)

    log(string.format("🏆 Trait 획득: %s (%s | %s:%s | %s)", traitName, category, effect, value, condition))
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
        return true
    else
        log(string.format("⚠️ Trait 미보유: %s", traitId))
        return false
    end
end

-- Trait 조건 체크
function checkTraitCondition(triggerId, condition, context)
    context = context or {}

    if condition == "always" then
        return true
    end

    -- vs_X 형식 (예: vs_dragons, vs_undead)
    if condition:match("^vs_") then
        local targetType = condition:match("^vs_(.+)")
        if context.enemy_type and context.enemy_type:lower() == targetType:lower() then
            return true
        end
        return false
    end

    -- low_hp (VIT < 30)
    if condition == "low_hp" then
        local vit = tonumber(getChatVar(triggerId, "player_vit")) or STAT_DEFAULT
        return vit < 30
    end

    -- high_hp (VIT > 70)
    if condition == "high_hp" then
        local vit = tonumber(getChatVar(triggerId, "player_vit")) or STAT_DEFAULT
        return vit > 70
    end

    -- in_combat
    if condition == "in_combat" then
        return context.in_combat == true
    end

    -- night_time
    if condition == "night_time" then
        local time = getChatVar(triggerId, "current_time") or ""
        return time:match("밤") or time:match("심야") or time:match("Night") or time:match("night")
    end

    -- day_time
    if condition == "day_time" then
        local time = getChatVar(triggerId, "current_time") or ""
        return time:match("오전") or time:match("오후") or time:match("아침") or time:match("Morning") or time:match("Afternoon")
    end

    return false
end

-- Trait 보너스 계산
function getTraitBonus(triggerId, effect, context)
    context = context or {}
    local totalBonus = 0

    local traitsStr = getChatVar(triggerId, "player_traits") or ""
    local traitIds = parseTraitIdList(traitsStr)

    for _, traitId in ipairs(traitIds) do
        local traitEffect = getChatVar(triggerId, "trait_" .. traitId .. "_effect") or ""
        local traitValue = getChatVar(triggerId, "trait_" .. traitId .. "_value") or "0"
        local traitCondition = getChatVar(triggerId, "trait_" .. traitId .. "_condition") or "always"

        -- 효과 타입이 일치하고 조건이 충족되면 보너스 적용
        if traitEffect == effect and checkTraitCondition(triggerId, traitCondition, context) then
            totalBonus = totalBonus + (tonumber(traitValue) or 0)
        end
    end

    return totalBonus
end

-- 단일 Trait 파싱
function parseTrait(triggerId, traitTag)
    -- 형식: [Trait:Name:Category:Effect:Value:Condition]
    local traitName, category, effect, value, condition = traitTag:match("%[Trait:([^:]+):([^:]+):([^:]+):([^:]+):([^%]]+)%]")

    if traitName and category and effect and value and condition then
        -- Trait ID 생성 (이름 기반)
        local traitId = traitName:gsub("%s+", "_"):lower()

        addTrait(triggerId, traitId, traitName, category, effect, value, condition)
    end
end

-- Trait 태그 파싱
function parseTraits(triggerId, message)
    for traitTag in message:gmatch("%[Trait:[^%]]+%]") do
        parseTrait(triggerId, traitTag)
    end
end

-- ============================================
-- 보조모델 호출
-- ============================================

-- 보조모델 프롬프트 생성
function buildAuxiliaryPrompt(triggerId, mainResponse)
    local prompt = AUXILIARY_BASE_PROMPT

    -- 현재 컨텍스트 추가
    local location = getChatVar(triggerId, "current_location") or "Unknown"
    local time = getChatVar(triggerId, "current_time") or "Unknown"
    local season = getChatVar(triggerId, "current_season") or "봄"
    local week = getChatVar(triggerId, "week_of_season") or "1"

    prompt = prompt .. "\n\n## Current Context:\n"
    prompt = prompt .. string.format("Season: %s Week %s | Time: %s | Location: %s\n", season, week, time, location)

    -- 메인 AI 응답 추가
    prompt = prompt .. "\n## Main AI Response to Analyze:\n"
    prompt = prompt .. mainResponse

    prompt = prompt .. "\n\n## Your Output (tags only):\n"

    return prompt
end

-- 보조모델 호출 및 태그 반환
function callAuxiliaryModel(triggerId, mainResponse)
    local promptText = buildAuxiliaryPrompt(triggerId, mainResponse)

    -- axLLM()은 메시지 배열 형식을 요구함
    local messages = {
        {
            content = promptText,
            role = "user"
        }
    }

    -- axLLM() 함수로 보조모델 호출
    local response = axLLM(triggerId, messages)

    -- 에러 체크
    if not response then
        return ""
    end

    if response.success == false then
        return ""
    end

    -- 응답 추출
    local result = response.result or ""

    if result ~= "" then
        return result
    else
        return ""
    end
end

-- ============================================
-- 스냅샷 시스템
-- ============================================

function generateTurnId(triggerId)
    -- 메시지 내용 기반 해시로 턴 ID 생성 (같은 메시지 = 같은 ID)
    local message = getCharacterLastMessage(triggerId)
    if not message or message == "" then
        return "0"
    end

    -- 간단한 해시: 메시지 길이 + 앞/중간/끝 문자 조합
    local len = #message
    local hash = len

    if len > 0 then
        hash = hash * 31 + string.byte(message, 1)
    end
    if len > 10 then
        hash = hash * 31 + string.byte(message, math.floor(len / 2))
    end
    if len > 20 then
        hash = hash * 31 + string.byte(message, len)
    end

    return tostring(hash % 1000000000)
end

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
end

-- RPG 변수 복원
function restoreRpgSnapshot(triggerId)
    -- Player Stats
    for _, stat in ipairs(playerStats) do
        local key = "player_" .. stat
        local snapshotValue = getChatVar(triggerId, "snapshot_" .. key) or tostring(STAT_DEFAULT)
        setChatVar(triggerId, key, snapshotValue)
    end

    -- Gold, EXP, Level
    setChatVar(triggerId, "player_gold", getChatVar(triggerId, "snapshot_player_gold") or "0")
    setChatVar(triggerId, "player_exp", getChatVar(triggerId, "snapshot_player_exp") or "0")
    setChatVar(triggerId, "player_level", getChatVar(triggerId, "snapshot_player_level") or "1")
    setChatVar(triggerId, "player_exp_to_next", getChatVar(triggerId, "snapshot_player_exp_to_next") or "100")

    -- Items
    setChatVar(triggerId, "player_items", getChatVar(triggerId, "snapshot_player_items") or "")

    -- Traits
    setChatVar(triggerId, "player_traits", getChatVar(triggerId, "snapshot_player_traits") or "")

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
-- 상태창 파싱
-- ============================================

function parseStatusWindow(triggerId, message)
    local time = message:match("%[Time:([^%]]+)%]")
    if time then
        setChatVar(triggerId, "current_time", time)
    end

    local location = message:match("%[Location:([^%]]+)%]")
    if location then
        setChatVar(triggerId, "current_location", location)

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
        setChatVar(triggerId, "is_spring", season == "봄" and "true" or "false")
        setChatVar(triggerId, "is_summer", season == "여름" and "true" or "false")
        setChatVar(triggerId, "is_autumn", season == "가을" and "true" or "false")
        setChatVar(triggerId, "is_winter", season == "겨울" and "true" or "false")
    end

    local week = message:match("%[Week:(%d+)%]")
    if week then
        setChatVar(triggerId, "week_of_season", week)
    end

    local day = message:match("%[Day:(%d+)%]")
    if day then
        setChatVar(triggerId, "current_day", day)
    end

    local weather = message:match("%[Weather:([^%]]+)%]")
    if weather then
        setChatVar(triggerId, "current_weather", weather)
    end

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

    setChatVar(triggerId, "current_season", "봄")
    setChatVar(triggerId, "week_of_season", "1")
    setChatVar(triggerId, "current_day", "1")
    setChatVar(triggerId, "current_time", "오전")
    setChatVar(triggerId, "current_location", "중앙 광장")
    setChatVar(triggerId, "current_weather", "맑음")
    setChatVar(triggerId, "active_event", "none")

    for _, flag in pairs(locationFlags) do
        setChatVar(triggerId, flag, "false")
    end
    setChatVar(triggerId, "at_plaza", "true")

    setChatVar(triggerId, "last_processed_turn_id", "0")

    -- RPG 시스템 초기화
    if not getChatVar(triggerId, "player_level") then
        -- 플레이어 레벨/경험치 (초기 레벨 0 = 능력평가 미완료)
        setChatVar(triggerId, "player_level", "0")
        setChatVar(triggerId, "player_exp", "0")
        setChatVar(triggerId, "player_exp_to_next", "100")

        -- 플레이어 골드
        setChatVar(triggerId, "player_gold", "0")

        -- 플레이어 스탯 (기본값 50, 보조모델이 초기 할당 전까지)
        for _, stat in ipairs(playerStats) do
            setChatVar(triggerId, "player_" .. stat, tostring(STAT_DEFAULT))
        end

        -- 플레이어 아이템
        setChatVar(triggerId, "player_items", "")

        -- 플레이어 Trait
        setChatVar(triggerId, "player_traits", "")

        -- 능력평가 완료 플래그 (로어북용)
        setChatVar(triggerId, "rpg_stats_evaluated", "false")

        -- RPG 시스템 기본 활성화
        setChatVar(triggerId, "rpg_system_enabled", "true")

        log("🎮 RPG 시스템 초기화 완료")
    end

    -- RPG 스냅샷 및 변경량 초기화
    takeRpgSnapshot(triggerId)
    clearRpgChanges(triggerId)

    checkScheduleMatch(triggerId)

    log("✅ 초기화 완료 (로어북 기준 + RPG 시스템)")
end

onOutput = async(function(triggerId)
    local message = getCharacterLastMessage(triggerId)
    if not message then
        return
    end

    local currentTurnId = generateTurnId(triggerId)
    local lastTurnId = getChatVar(triggerId, "last_processed_turn_id") or "0"

    -- 리롤 감지 (스냅샷 복원이 먼저!)
    if currentTurnId == lastTurnId then
        for _, char in ipairs(characters) do
            restoreSnapshot(triggerId, char)
            clearChanges(triggerId, char)
        end

        -- RPG 스냅샷 복원 (RPG 활성화 시에만)
        local rpgEnabled = getChatVar(triggerId, "rpg_system_enabled") == "true"
        if rpgEnabled then
            restoreRpgSnapshot(triggerId)
            clearRpgChanges(triggerId)
        end

        return
    end

    -- 이미 태그가 추가된 메시지는 스킵 (setChat() 재트리거 방지)
    if message:find("<Panel>") then
        return
    end

    log(string.format("📨 새 턴 처리 (ID: %s)", currentTurnId))

    for _, char in ipairs(characters) do
        takeSnapshot(triggerId, char)
        clearChanges(triggerId, char)
    end

    -- RPG 스냅샷 및 변경량 초기화 (RPG 활성화 시에만)
    local rpgEnabled = getChatVar(triggerId, "rpg_system_enabled") == "true"
    if rpgEnabled then
        takeRpgSnapshot(triggerId)
        clearRpgChanges(triggerId)
    end

    -- 보조모델 호출: 메인 모델 출력 분석 후 태그 생성
    local auxiliaryMessage = callAuxiliaryModel(triggerId, message)

    -- 보조모델이 생성한 태그 파싱
    parseStatusWindow(triggerId, auxiliaryMessage)

    -- SIN RESET 처리
    for charStorage, sinType in auxiliaryMessage:gmatch("%[SIN_RESET:(%w+)_(pos|neg)%]") do
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
    for charName, feeling in auxiliaryMessage:gmatch("%[Affinity:(%w+):(%w+)%]") do
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
    for charName, level in auxiliaryMessage:gmatch("%[Sin:(%w+):(%w+)%]") do
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

    -- RPG 시스템 파싱 (보조모델 응답에서)
    if rpgEnabled then
        parseStatChanges(triggerId, auxiliaryMessage)
        parseGoldChanges(triggerId, auxiliaryMessage)
        parseExpChanges(triggerId, auxiliaryMessage)
        parseItems(triggerId, auxiliaryMessage)
        parseTraits(triggerId, auxiliaryMessage)

        -- RPG 디스플레이 변수 업데이트 (HTML 템플릿용)
        updateRpgDisplayVars(triggerId)
    end

    -- 로어북 이벤트 태그 파싱 (메인 AI 응답에서)
    -- [StatsEvaluated] 태그 감지 → 능력평가 완료 처리
    if message:find("%[StatsEvaluated%]") then
        local currentLevel = tonumber(getChatVar(triggerId, "player_level")) or 0

        if currentLevel == 0 then
            -- 레벨 0 → 1로 상승 (능력평가 완료)
            setChatVar(triggerId, "player_level", "1")
            setChatVar(triggerId, "player_exp", "0")
            setChatVar(triggerId, "player_exp_to_next", "100")
            log("✅ 능력평가 완료 - 레벨 1 달성!")
        end
    end

    -- 보조모델 태그를 채팅에 추가 (RisuAI 정규식이 <Panel>■★를 처리)
    local finalMessage = message .. "\n\n" .. auxiliaryMessage
    setChat(triggerId, -1, finalMessage)

    setChatVar(triggerId, "last_processed_turn_id", currentTurnId)
    log(string.format("✅ 턴 %s 처리 완료", currentTurnId))
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

        setChatVar(triggerId, "last_processed_turn_id", "0")
        setChatVar(triggerId, "week_of_season", "1")
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
            msg = msg .. "Trait: "
            local traitIds = parseTraitIdList(traitsStr)
            local traitList = {}
            for _, traitId in ipairs(traitIds) do
                local traitName = getChatVar(triggerId, "trait_" .. traitId .. "_name") or traitId
                table.insert(traitList, traitName)
            end
            msg = msg .. table.concat(traitList, ", ") .. "\n"
        else
            msg = msg .. "Trait: (없음)\n"
        end

        log(msg)
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

        updatePercent(triggerId, characters[1])
        takeSnapshot(triggerId, characters[1])
        checkScheduleMatch(triggerId)

        log("✅ 테스트 값 설정 (Week 5, 스칼렛 스트리트)")
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

log("🥀 Belladonna Academy v7.0 - RPG Edition")
log("✅ 로어북 기준 장소명 정리 + RPG 시스템 통합")
log("📍 Scarlet Street, Midnight Alley, Lotus Street, Ruby Row 등")
log("🌐 한영 병기 출력 텍스트")
log("🎮 RPG: Stats, Gold, Items, Traits, EXP/Level")
log("👨‍⚖️ 보조모델: STATUS_OUTPUT_INSTRUCTIONS_v2.0.md 참조")
log("🔄 명령어: /status, /schedule, /reset, /test")
