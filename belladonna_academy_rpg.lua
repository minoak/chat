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
You are the System Judge for Belladonna Academy RPG. Analyze the Main AI's output and generate status tags.

## Mandatory Output Format
[Affinity:CharacterName:level][Sin:CharacterName:level]
[Stat:stat_id:±value][Gold:±value][Item:Action:Name:Qty:Effect][EXP:±value]
[Effect:Action:Name:StatBonus][Trait:Name:Description]
[Season:계절][Week:주차][Time:시간][Location:장소]
<Panel>■★

## Output Rules
### Character State (Required Every Turn)
- Affinity: Judge emotional change THIS TURN
- Sin: Judge sin manifestation THIS TURN
- Multiple characters = multiple tag pairs

### RPG System (Conditional)
- Stat: When stats change (str/int/dex/cha/luk/vit)
  - Stats can be used in ANY situation, not just combat:
  - Combat: STR (melee), DEX (dodge/ranged), INT (magic), VIT (endurance), LUK (critical/fumble)
  - Exams/Tests: INT (written exam), DEX (practical test), CHA (presentation)
  - Social Events: CHA (persuasion/seduction), LUK (games/fortune telling)
  - Physical Challenges: STR (athletics), VIT (stamina), DEX (acrobatics)
  - Comic/Random Events: LUK (lucky accidents, embarrassing fumbles, wardrobe malfunctions)
  - Any creative scenario can trigger stat checks, rewards (EXP/Gold/Items), or stat increases
  - Even silly/humorous situations can become "battles" with choices and stat-based outcomes
- Gold: When gold changes
- Item: When acquired/removed - [Item:Add/Remove:Name:Qty:Effect]
- EXP: When gained
- Heal: When {{user}} recovers combat power - [Heal:amount]
  - Rest/sleep: [Heal:20~50]
  - Potion/medicine: [Heal:30~100]
  - Healing magic: [Heal:40~80]
  - Food/meal: [Heal:10~30]
- Effect: When magic/skill buffs/debuffs applied/removed - [Effect:Add/Remove:Name:StatBonus]
- Trait: When {{user}} gains permanent trait (NOT for NPC traits)
- Combat: When enemy/monster appears - [Combat:EnemyName:PowerValue]
  - MUST generate <CombatChoice> with 6 options immediately after [Combat:] tag
  - Combat End: When combat ends - [Combat:End]

### Environment (Conditional)
- Season/Week: First turn or when changed
- Time/Location: Only when changed
- Omit unchanged tags

### Critical
- Use first names only (see list below)
- <Panel>■★ must be absolute last line

---
## Characters
Mirabel, Celestia, Cassandra, Evangeline, Amelia, Nepenthes, Lilith, Aurelia, Cordelia, Suah, Adelheid, Rosalie, Mika, Clover

Wrong: [Affinity:{{user}}:like] or [Affinity:Mirabel von Goldenrose:like]
Right: [Affinity:Mirabel:like]

---
## Affinity Levels
Question: "How did feelings toward {{user}} change THIS TURN?"

| Level | Meaning |
|-------|---------|
| love | Major positive shift - Life-changing moment |
| like | Moderate positive - Kind act, warmth |
| neutral | No significant change |
| dislike | Moderate negative - Annoyed, frustrated |
| hate | Major negative - Hurt, betrayal |

---
## Sin Levels
Question: "How did deadly sin manifest THIS TURN?"

| Level | Meaning |
|-------|---------|
| corrupt | Heavily indulged - Surrendered to sin |
| tempt | Moderately indulged - Sin influenced |
| neutral | No change - Sin dormant |
| resist | Moderately resisted - Fought sin |
| purify | Strongly overcame - Sin diminished |

---
## Tag Format Reference

[Stat:str:+3] - Stats: str/int/dex/cha/luk/vit, range ±value
[Gold:±500] - Gold change
[Item:Add:포션:1:hp+20] - Item acquired with effect
[Item:Remove:포션:1] - Item removed
[EXP:+100] - Experience gained
[Heal:30] - Combat power recovery (rest/potion/magic/food)
[Effect:Add:축복:str+15] - Buff applied
[Effect:Remove:축복] - Buff removed
[Trait:Name:Description] - Player trait only
[Combat:Goblin:45] - Combat encounter (enemy name:power level)
[Combat:End] - Combat ended
<CombatChoice>
[STR|Description|Difficulty]
[DEX|Description|Difficulty]
[INT|Description|Difficulty]
[CHA|Description|Difficulty]
[LUK|Description|Difficulty]
[TraitName|Description|Difficulty]
</CombatChoice> - 6 combat action choices (STR/DEX/INT/CHA/LUK + 1 trait/flee)
[Season:봄][Week:1] - Season/week (봄/여름/가을/겨울, 1-12)
[Time:저녁][Location:도서관] - Time/location change

---
## Examples

### First turn
[Affinity:Mirabel:like][Sin:Mirabel:neutral][Season:봄][Week:1][Time:오전][Location:중앙 광장]
<Panel>■★

### Normal interaction
[Affinity:Celestia:hate][Sin:Celestia:tempt]
<Panel>■★

### Combat rewards
[Affinity:Cassandra:like][Sin:Cassandra:resist][Stat:str:+3][Gold:+500][EXP:+100]
<Panel>■★

### Shopping
[Affinity:Clover:neutral][Sin:Clover:neutral][Gold:-500][Item:Add:회복포션:1:hp+20]
<Panel>■★

### Healing/Rest
[Affinity:Rosalie:neutral][Sin:Rosalie:neutral][Heal:40]
<Panel>■★

### Magic buff
[Affinity:Mirabel:like][Sin:Mirabel:neutral][Effect:Add:미라벨의 축복:str+15]
<Panel>■★

### Combat encounter
[Affinity:Cassandra:neutral][Sin:Cassandra:neutral][Combat:Goblin:45]
<CombatChoice>
[STR|검으로 베어넘긴다|Easy]
[DEX|재빠르게 피한 후 반격한다|Normal]
[INT|약점을 노려 공격한다|Normal]
[CHA|위협하여 물러서게 한다|Hard]
[LUK|운에 맡긴다|Very Hard]
[도주|재빠르게 도망친다|Very Easy]
</CombatChoice>
<Panel>■★

### Exam/Test scenario
[Affinity:Celestia:like][Sin:Celestia:neutral][Stat:int:+2][EXP:+50]
<Panel>■★

### Comic/Random event (LUK-based fumble)
[Affinity:Mirabel:dislike][Sin:Mirabel:neutral][Stat:luk:-1][Gold:-100]
<Panel>■★

---
## CombatChoice Generation Guide

**WHEN TO GENERATE <CombatChoice>:**
- ONLY when Main AI describes an **ACTIVE, ONGOING** combat/threat situation
- Enemy is present AND player needs to decide next action
- Combat has NOT concluded yet

**WHEN NOT TO GENERATE <CombatChoice>:**
- Combat already ended (enemy defeated/fled/negotiated)
- No immediate threat or danger
- Player is in safe situation
- Peaceful/narrative moments

### Generation Rules:

When you detect **NEW or ONGOING** combat situation:

1. **[Combat:EnemyName:PowerValue]** tag first (only for NEW combat)
2. **<CombatChoice>** block immediately after with exactly 6 choices

### Format
```
<CombatChoice>
[STAT|Action description|Difficulty]
...6 lines total...
</CombatChoice>
```

### 6 Choice Structure
1. **[STR|...]** - Strength-based action (직접 공격, 힘으로 밀어붙이기)
2. **[DEX|...]** - Dexterity-based action (회피, 기습, 민첩한 공격)
3. **[INT|...]** - Intelligence-based action (약점 분석, 전술, 마법)
4. **[CHA|...]** - Charisma-based action (설득, 위협, 협상)
5. **[LUK|...]** - Luck-based action (always "운에 맡긴다")
6. **[TraitName|...]** or **[도주|...]** - Player trait (if applicable) or flee

### Difficulty Determination
Read Main AI's narrative context:
- Player advantage (high ground, ambush, enemy wounded) → Easy/Very Easy
- Balanced fight → Normal
- Player disadvantage (outnumbered, trapped, injured) → Hard/Very Hard

Base difficulty on enemy power vs player capability (infer from narrative).

### Difficulty Levels
- **Very Easy**: Almost guaranteed success (target: 5)
- **Easy**: Good chance (target: 10)
- **Normal**: Fair challenge (target: 15)
- **Hard**: Difficult task (target: 20)
- **Very Hard**: Nearly impossible (target: 25)

### Action Description Guidelines
- **STR**: 직접적인 물리 공격, 힘을 사용한 행동
  - Example: "검으로 베어넘긴다", "방패로 밀쳐낸다"
- **DEX**: 민첩성, 회피, 기습
  - Example: "재빠르게 피한 후 반격한다", "그림자를 이용해 기습한다"
- **INT**: 지능적 판단, 약점 파악, 마법
  - Example: "약점을 노려 공격한다", "주변 환경을 이용한다"
- **CHA**: 대화, 설득, 위협
  - Example: "위협하여 물러서게 한다", "협상을 시도한다"
- **LUK**: Always "운에 맡긴다" (no variation)
- **6th choice**: Use player trait if relevant to situation, otherwise use "도주" (flee)

### Player Traits Reference
{{PLAYER_TRAITS_SECTION}}

If player has combat-relevant trait (검술, 마법, 전투 관련), use it for 6th choice.
If no relevant trait or no traits at all, use: [도주|재빠르게 도망친다|Very Easy]

### Combat End Detection

**Output [Combat:End] when:**
- Main AI clearly states combat concluded:
  - "전투가 끝났다" / "Combat has ended"
  - "적을 물리쳤다" / "Enemy defeated"
  - "도망쳤다" / "Fled successfully"
  - "협상이 성공했다" / "Negotiation succeeded"
- No ongoing threat or combat action

**NEVER output [Combat:End] if:**
- Enemy just appeared (first turn)
- Combat still ongoing
- Player in middle of action

**CRITICAL RULES:**
- [Combat:End] = Do NOT generate <CombatChoice>
- <CombatChoice> present = Do NOT output [Combat:End]
- These are MUTUALLY EXCLUSIVE - never both in same turn
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
        local effectStr = string.format("%s:%s:%d:%d:%s",
            effect.name, effect.type, effect.value, effect.duration, effect.desc or "")
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
        local sign = effect.value >= 0 and "+" or ""
        local durationText = effect.duration > 0 and (effect.duration .. "턴") or "영구"
        local line = string.format("• %s (%s%d, %s)",
            effect.name, sign, effect.value, durationText)
        if effect.desc and effect.desc ~= "" then
            line = line .. " - " .. effect.desc
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

    for i = #effects, 1, -1 do
        local effect = effects[i]
        if effect.duration > 0 then
            effect.duration = effect.duration - 1
            if effect.duration == 0 then
                table.insert(expired, effect.name)
                table.remove(effects, i)
            end
        end
    end

    if #expired > 0 then
        saveActiveEffects(triggerId, effects)
        for _, name in ipairs(expired) do
            log("⏰ 효과 만료: " .. name)
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

    -- 최대 전투력 계산 (현재 스탯 기반)
    local maxCombatPower = calculateCombatPower(triggerId)
    setChatVar(triggerId, "player_combat_power_max", tostring(maxCombatPower))
    setState(triggerId, "player_combat_power_max", maxCombatPower)
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

    -- 각 슬롯 변수 설정 (최대 5개)
    for i = 1, 5 do
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
        return
    end

    -- 평문 리스트 생성 (HTML이 스타일링 담당)
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

    -- 평문으로 저장
    local displayText = table.concat(parts, "\n")
    setChatVar(triggerId, "player_traits_display", displayText)
    setState(triggerId, "player_traits_display", displayText)
end

-- 단일 Trait 파싱
function parseTrait(triggerId, traitTag)
    -- 형식: [Trait:Name:Description]
    local traitName, traitDesc = traitTag:match("%[Trait:([^:]+):([^%]]+)%]")

    if traitName and traitDesc then
        addTrait(triggerId, traitName, traitDesc)
    end
end

-- Trait 태그 파싱
function parseTraits(triggerId, message)
    for traitTag in message:gmatch("%[Trait:[^%]]+%]") do
        parseTrait(triggerId, traitTag)
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

-- 난이도 판정 (비율 기반)
function getDifficulty(statPower, enemyPower)
    if enemyPower == 0 then
        return "Very Easy"
    end

    local ratio = statPower / enemyPower

    if ratio >= 2.0 then
        return "Very Easy"
    elseif ratio >= 1.5 then
        return "Easy"
    elseif ratio >= 1.0 then
        return "Normal"
    elseif ratio >= 0.7 then
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
    local enemyPower = tonumber(getChatVar(triggerId, "combat_enemy_power")) or 0

    if not stat or stat == "" then
        log("⚠️ 유효하지 않은 선택지: " .. choiceNum)
        return false
    end

    log(string.format("⚔️ 선택: %d번 - [%s] %s (%s)", choiceNum, stat, desc, diff))

    -- 능력치 이름 표준화
    local statName = stat:lower()
    if statName == "str" or statName == "dex" or statName == "int" or
       statName == "cha" or statName == "luk" or statName == "vit" then
        -- 표준 능력치
    else
        -- 특성/도주 등 -> LUK으로 처리
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

    -- 전투 결과 처리
    processCombatResult(triggerId, success, critical, fumble, diff, enemyPower)

    log(string.format("✅ 주사위 결과: %d + %d = %d → %s", roll, bonus, total, success and "성공" or "실패"))

    return true
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
        enemyDamage = 50
        playerDamage = 0
        combatState = "Critical"
        log("💥 크리티컬!")

    elseif fumble then
        -- 대실패: 플레이어가 큰 데미지
        playerDamage = 40
        enemyDamage = 0
        combatState = "Fumble"
        log("💀 대실패!")

    elseif success then
        -- 성공 - 난이도별 데미지
        if difficulty == "Very Easy" or difficulty == "Easy" then
            enemyDamage = 25
            playerDamage = 5
            combatState = "Advantageous"
            log("✅ 성공! 큰 타격!")

        elseif difficulty == "Normal" then
            enemyDamage = 20
            playerDamage = 10
            combatState = "Neutral"
            log("✅ 성공!")

        elseif difficulty == "Hard" then
            enemyDamage = 15
            playerDamage = 15
            combatState = "Neutral"
            log("⚡ 성공! 하지만 피해도 입음")

        else  -- Very Hard
            enemyDamage = 10
            playerDamage = 20
            combatState = "Disadvantageous"
            log("😰 간신히 성공...")
        end

    else
        -- 실패 - 적만 데미지 줌
        playerDamage = 25
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

        -- 전투 선택지 변수 초기화
        for i = 1, 6 do
            setChatVar(triggerId, "combat_choice_" .. i .. "_stat", "")
            setChatVar(triggerId, "combat_choice_" .. i .. "_desc", "")
            setChatVar(triggerId, "combat_choice_" .. i .. "_diff", "")
        end

        log(string.format("✅ combat_active 설정: %s", getChatVar(triggerId, "combat_active")))
        return
    end

    -- [Combat:EnemyName:Power] 형식 파싱
    local enemyName, enemyPowerStr = tag:match("%[Combat:([^:]+):(%d+)%]")

    if enemyName and enemyPowerStr then
        local enemyPower = tonumber(enemyPowerStr) or 0

        log(string.format("⚔️ 전투 발생: %s (파워 %d)", enemyName, enemyPower))

        -- 플레이어 전투력 계산 및 초기화
        local playerCombatPower = calculateCombatPower(triggerId)
        setChatVar(triggerId, "player_combat_power", tostring(playerCombatPower))
        setState(triggerId, "player_combat_power", playerCombatPower)

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

        log(string.format("✅ 플레이어 전투력: %d", playerCombatPower))
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
            if statUpper == "STR" then emoji = "💪"
            elseif statUpper == "DEX" then emoji = "⚡"
            elseif statUpper == "INT" then emoji = "🧠"
            elseif statUpper == "CHA" then emoji = "💬"
            elseif statUpper == "LUK" then emoji = "🍀"
            else emoji = "🏃" end

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
    end
end

-- ============================================
-- 보조모델 호출
-- ============================================

-- 보조모델 프롬프트 생성
function buildAuxiliaryPrompt(triggerId, mainResponse)
    -- 플레이어 특성 정보 가져오기
    local traitsDisplay = getChatVar(triggerId, "player_traits_display") or ""

    -- 특성 섹션 생성
    local traitsSection = ""
    if traitsDisplay ~= "" then
        traitsSection = "**Current Player Traits:**\n" .. traitsDisplay
    else
        traitsSection = "(No traits yet)"
    end

    -- PLAYER_TRAITS_SECTION 플레이스홀더 치환
    local prompt = AUXILIARY_BASE_PROMPT:gsub("{{PLAYER_TRAITS_SECTION}}", traitsSection)

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

    log("🤖 보조모델 호출 시작")

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
        log("❌ 보조모델 응답 없음 (response is nil)")
        return ""
    end

    log(string.format("🔍 보조모델 응답 success: %s", tostring(response.success)))

    if response.success == false then
        log(string.format("❌ 보조모델 에러: %s", tostring(response.result or "unknown error")))
        return ""
    end

    -- 응답 추출
    local result = response.result or ""

    if result ~= "" then
        log(string.format("✅ 보조모델 출력 (%d자): %s", #result, result:sub(1, 100)))
        return result
    else
        log("⚠️ 보조모델 응답이 빈 문자열")
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

    local day = message:match("%[Day:(%d+)%]")
    if day then
        setChatVar(triggerId, "current_day", day)
        setState(triggerId, "current_day", day)
    end

    local weather = message:match("%[Weather:([^%]]+)%]")
    if weather then
        setChatVar(triggerId, "current_weather", weather)
    end

    -- Combat 태그 파싱
    parseCombats(triggerId, message)
    parseCombatChoices(triggerId, message)

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
    end
    if not getChatVar(triggerId, "week_of_season") then
        setChatVar(triggerId, "week_of_season", "1")
    end
    if not getChatVar(triggerId, "current_day") then
        setChatVar(triggerId, "current_day", "1")
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

    if not getChatVar(triggerId, "last_processed_turn_id") then
        setChatVar(triggerId, "last_processed_turn_id", "0")
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
        setState(triggerId, "week_of_season", "1")
        setChatVar(triggerId, "week_of_season", "1")
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

    -- 디버깅: 보조 AI 출력 확인
    log("📋 보조 AI 출력:")
    log(auxiliaryMessage)

    -- 보조 AI 출력을 변수에 저장 (디버깅용)
    setChatVar(triggerId, "debug_auxiliary_output", auxiliaryMessage)

    -- Combat 태그 포함 여부 확인
    if auxiliaryMessage:find("%[Combat:") then
        log("✅ Combat 태그 발견!")
        setChatVar(triggerId, "debug_combat_tag_found", "true")
    else
        log("⚠️ Combat 태그 없음")
        setChatVar(triggerId, "debug_combat_tag_found", "false")
    end

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
        parseHeal(triggerId, auxiliaryMessage)
        parseItems(triggerId, auxiliaryMessage)
        parseTraits(triggerId, auxiliaryMessage)
        parseEffects(triggerId, auxiliaryMessage)

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

        -- AI가 아이템을 반환했는지 확인
        local returnPattern = "%[Item:Add:" .. usingItem .. ":1[:%]]"
        local wasReturned = message:find(returnPattern) ~= nil

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

    -- 턴 ID 먼저 업데이트 (setChat() 재트리거 방지)
    setChatVar(triggerId, "last_processed_turn_id", currentTurnId)

    -- 보조모델 태그를 채팅에 추가 (RisuAI 정규식이 <Panel>■★를 처리)
    local finalMessage = message .. "\n\n" .. auxiliaryMessage
    setChat(triggerId, -1, finalMessage)

    -- 마지막 메시지 리로드하여 스크롤 위치 정상화
    reloadChat(triggerId, -1)

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

-- 슬롯 N번 아이템 사용
for i = 1, 5 do
    _G["use_item_" .. i] = function(triggerId)
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

        -- N번째 아이템 찾기
        if sortedItems[i] then
            local itemName = sortedItems[i].name

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

            log(string.format("🎒 슬롯%d 아이템 사용: %s (즉시 차감)", i, itemName))
        else
            log(string.format("⚠️ 슬롯%d에 아이템이 없습니다", i))
        end
    end
end

-- 전투 선택지 버튼 등록 (combat_choice_1 ~ combat_choice_6)
for i = 1, 6 do
    _G["combat_choice_" .. i] = function(triggerId)
        -- 선택한 내용 가져오기
        local stat = getChatVar(triggerId, "combat_choice_" .. i .. "_stat") or ""
        local desc = getChatVar(triggerId, "combat_choice_" .. i .. "_desc") or ""
        local diff = getChatVar(triggerId, "combat_choice_" .. i .. "_diff") or ""

        if stat ~= "" then
            -- 사용자 메시지로 추가
            local message = string.format("[%s|%s|%s]", stat, desc, diff)
            addChat(triggerId, "user", message)

            log(string.format("💬 사용자 메시지 추가: %s", message))
        end

        -- 주사위 굴림
        rollCombat(triggerId, i)
    end
end

-- editRequest: 메인 AI 요청에서 보조모델 태그 모두 제거
listenEdit("editRequest", function(triggerId, data)
    -- <CombatChoice> 블록 제거
    data = data:gsub("<CombatChoice>.-</CombatChoice>", "")

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

-- editDisplay: <CombatChoice> 태그를 HTML 버튼으로 변환 (최신 메시지에만)
listenEdit("editDisplay", function(triggerId, data)
    data = data:gsub("<CombatChoice>(.-)</CombatChoice>", function(content)
        local html = "<div style='max-width:600px;margin:15px auto;padding:0 10px'>"
        local choiceIndex = 1

        for line in content:gmatch("[^\r\n]+") do
            local stat, desc, diff = line:match("%[([^|]+)|([^|]+)|([^%]]+)%]")
            if stat and desc and diff then
                -- 능력치별 이모지
                local emoji = "⚔️"
                local statUpper = stat:upper()
                if statUpper == "STR" then emoji = "💪"
                elseif statUpper == "DEX" then emoji = "⚡"
                elseif statUpper == "INT" then emoji = "🧠"
                elseif statUpper == "CHA" then emoji = "💬"
                elseif statUpper == "LUK" then emoji = "🍀"
                else emoji = "🏃" end

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
                    "<button type='button' risu-trigger='combat_choice_%d' style='display:block;width:100%%;max-width:580px;margin:8px auto;padding:12px 20px;background:%s;color:white;border:none;border-radius:8px;box-shadow:%s;font-size:14px;font-weight:500;cursor:pointer;transition:all 0.2s ease;text-align:left'>%s <strong>[%s]</strong> %s <span style='float:right;opacity:0.9;font-size:12px'>%s</span></button>",
                    choiceIndex, gradient, shadow, emoji, stat, desc, diff
                )

                choiceIndex = choiceIndex + 1
            end
        end

        html = html .. "</div>"

        -- Handlebars 조건문으로 감싸기: 최신 메시지에만 버튼 표시
        return "{{#if {{equal::{{chat_index}}::{{lastmessageid}}}}}}" .. html .. "{{/if}}"
    end)

    return data
end)

log("🥀 Belladonna Academy v7.0 - RPG Edition")
log("✅ 로어북 기준 장소명 정리 + RPG 시스템 통합")
log("📍 Scarlet Street, Midnight Alley, Lotus Street, Ruby Row 등")
log("🌐 한영 병기 출력 텍스트")
log("🎮 RPG: Stats, Gold, Items, Traits (서술용), EXP/Level")
log("👨‍⚖️ 보조모델: STATUS_OUTPUT_INSTRUCTIONS_v2.0.md 참조")
log("🔄 명령어: /status, /schedule, /reset, /test")
log("🔘 아이템 버튼: use_item_1~5 등록 완료")
log("⚔️ 전투 버튼: combat_choice_1~6 등록 완료")
log("📺 editDisplay 리스너: <CombatChoice> 태그를 HTML 버튼으로 변환")
log("🚫 editRequest 리스너: 메인 AI 요청에서 보조모델 태그 모두 제거 (Affinity/Sin/Stat/Gold/Item/EXP/Heal/Effect/Trait/Combat/Season/Week/Time/Location/Panel)")