-- 이미지 태그 복장 접미사 테스트 (채팅 통합 버전)
-- 보조모델이 시간/장소 기반으로 "_일상복", "_교복" 등 접미사 추가

-- ============================================
-- 설정
-- ============================================

local USE_REAL_MODEL = true  -- true: 실제 API 호출, false: 시뮬레이션만
local debugLog = {}

function addDebug(msg)
    table.insert(debugLog, msg)
end

function getDebugOutput()
    if #debugLog == 0 then
        return ""
    end
    local output = "\n\n" .. string.rep("=", 60) .. "\n📋 **디버그 로그**\n" .. string.rep("=", 60) .. "\n"
    for _, msg in ipairs(debugLog) do
        output = output .. msg .. "\n"
    end
    output = output .. string.rep("=", 60)
    return output
end

function clearDebugLog()
    debugLog = {}
end

-- ============================================
-- 컨텍스트
-- ============================================

function getContext()
    return {
        time = "Evening",
        location = "Dormitory"
    }
end

-- ============================================
-- 보조모델 프롬프트 생성
-- ============================================

function generateAuxiliaryPrompt(mainOutput, context)
    return string.format([[
---

# IMAGE TAG OUTFIT CORRECTION

Analyze the main model output and add outfit context to image tags.

## Current Context

- **Time**: %s
- **Location**: %s

## Outfit Rules

**Time-based (default):**
- Morning/Afternoon → add `_교복`
- Evening → add `_일상복`
- Night → add `_잠옷`

**Location-based (PRIORITY):**
- Ballroom → add `_이브닝드레스`
- Garden → add `_원피스`
- Beach → add `_수영복`
- Gym → add `_운동복`

## Task

Find all `<img="...">` tags and add appropriate outfit suffix.

**Output format:**
```
[IMG_FIX:original_tag→corrected_tag]
```

**Example:**
- Found: `<img="Margaret.nervous">`
- Output: `[IMG_FIX:<img="Margaret.nervous">→<img="Margaret.nervous_일상복">]`

## Main Model Output

%s

---

**Now output the IMG_FIX tags:**
]], context.time, context.location, mainOutput)
end

-- ============================================
-- 보조모델 호출
-- ============================================

function callRealAuxiliaryModel(triggerId, prompt)
    clearDebugLog()

    if not USE_REAL_MODEL then
        addDebug("⏭️  USE_REAL_MODEL=false")
        return nil, "disabled"
    end

    -- axLLM 함수 체크
    if type(axLLM) ~= "function" then
        addDebug("❌ axLLM 함수 없음 (type: " .. type(axLLM) .. ")")
        return nil, "axLLM not found"
    end

    addDebug("✅ axLLM 함수 발견")
    addDebug("   triggerId: " .. tostring(triggerId))

    local messages = {
        {
            role = "system",
            content = "You are an auxiliary model. Follow instructions precisely and output only the requested tags."
        },
        {
            role = "user",
            content = prompt
        }
    }

    addDebug("🔄 보조모델 호출 시작")
    addDebug("   메시지 개수: " .. #messages)

    local success, response = pcall(function()
        return axLLM(triggerId, messages)  -- ← triggerId 전달!
    end)

    addDebug("📥 pcall success=" .. tostring(success))

    if success and response then
        addDebug("✅ 응답 수신 type=" .. type(response))

        if type(response) == "table" then
            addDebug("   response.success=" .. tostring(response.success))
            addDebug("   response.result type=" .. type(response.result))

            if response.success and response.result then
                local text = response.result
                addDebug("✅ 보조모델 응답 OK (" .. #text .. " chars)")
                if #text <= 200 then
                    addDebug("   전체: " .. text)
                else
                    addDebug("   미리보기: " .. text:sub(1, 200) .. "...")
                end
                return text, nil
            elseif response.success == false then
                local err = tostring(response.result)
                addDebug("❌ 응답 실패: " .. err)
                return nil, err
            else
                addDebug("❌ 응답 형식 오류")
                return nil, "invalid format"
            end
        else
            addDebug("❌ 응답이 테이블 아님")
            return nil, "not a table"
        end
    else
        local err = tostring(response)
        addDebug("❌ pcall 실패: " .. err)
        return nil, err
    end
end

-- ============================================
-- 시뮬레이션
-- ============================================

function simulateAuxiliaryOutfit(imageTag, context)
    local timeOutfits = {
        Morning = "_교복",
        Afternoon = "_교복",
        Evening = "_일상복",
        Night = "_잠옷"
    }

    local locationOutfits = {
        Ballroom = "_이브닝드레스",
        Garden = "_원피스",
        Beach = "_수영복",
        Gym = "_운동복"
    }

    local outfit = locationOutfits[context.location] or timeOutfits[context.time] or "_일상복"
    local modifiedTag = imageTag:gsub('(")', outfit .. '%1')

    return string.format("[IMG_FIX:%s→%s]", imageTag, modifiedTag)
end

-- ============================================
-- 메시지 처리
-- ============================================

function processTestOutput(triggerId)
    addDebug("🔄 processTestOutput 시작")

    -- 마지막 메시지 가져오기 (메인 스크립트와 동일한 방법)
    local mainOutput = getCharacterLastMessage(triggerId)
    if not mainOutput then
        addDebug("❌ 메시지 없음")
        return
    end

    -- 이미 처리된 메시지 스킵
    if mainOutput:find("<Panel>■★", 1, true) then
        addDebug("⏭️ 이미 처리된 메시지 - 스킵")
        return
    end

    addDebug("📨 메시지 받음: " .. #mainOutput .. " chars")

    -- 이미지 태그 확인
    local hasImageTag = mainOutput:find('<img="[^"]+">') ~= nil

    if not hasImageTag then
        addDebug("⚠️  이미지 태그 없음 - 스킵")
        return
    end

    addDebug("✅ 이미지 태그 발견")

    -- 컨텍스트
    local context = getContext()
    addDebug("⏰ 컨텍스트: " .. context.time .. "/" .. context.location)

    -- 프롬프트 생성
    local prompt = generateAuxiliaryPrompt(mainOutput, context)
    addDebug("📋 프롬프트 생성 완료")

    -- 보조모델 호출
    local auxResponse, err = callRealAuxiliaryModel(triggerId, prompt)

    local modifiedOutput = mainOutput  -- 원본 복사
    local debugInfo = "\n\n" .. string.rep("=", 60) .. "\n"
    debugInfo = debugInfo .. "🧪 **이미지 태그 복장 테스트 결과**\n"
    debugInfo = debugInfo .. string.rep("=", 60) .. "\n\n"

    if auxResponse then
        debugInfo = debugInfo .. "✅ **보조모델 응답**:\n```\n" .. auxResponse .. "\n```\n\n"

        local fixFound = auxResponse:find("%[IMG_FIX:") ~= nil

        if fixFound then
            debugInfo = debugInfo .. "🎉 **성공!** IMG_FIX 태그 생성됨!\n\n"
            debugInfo = debugInfo .. "📤 **수정 내용**:\n"

            -- 실제 이미지 태그 수정 적용
            for wrongTag, correctTag in auxResponse:gmatch("%[IMG_FIX:(.-)→(.-)%]") do
                local escaped = wrongTag:gsub("([%.%+%-%*%?%[%]%(%)%%])", "%%%1")
                local before = modifiedOutput
                modifiedOutput = modifiedOutput:gsub(escaped, correctTag, 1)

                if modifiedOutput ~= before then
                    debugInfo = debugInfo .. "  ✓ " .. wrongTag .. " → " .. correctTag .. "\n"
                    addDebug("✓ 태그 수정: " .. wrongTag .. " → " .. correctTag)
                else
                    debugInfo = debugInfo .. "  ✗ 실패: " .. wrongTag .. "\n"
                    addDebug("✗ 수정 실패: " .. wrongTag)
                end
            end
        else
            debugInfo = debugInfo .. "⚠️  IMG_FIX 태그 없음\n"
        end
    else
        debugInfo = debugInfo .. "❌ **보조모델 호출 실패**: " .. tostring(err) .. "\n\n"
        debugInfo = debugInfo .. "🔧 **시뮬레이션 결과**:\n"

        for imageTag in mainOutput:gmatch('<img="[^"]+">') do
            local simResult = simulateAuxiliaryOutfit(imageTag, context)
            debugInfo = debugInfo .. "  " .. simResult .. "\n"
        end
    end

    -- 디버그 로그 추가
    debugInfo = debugInfo .. getDebugOutput()

    -- 최종 메시지 = 수정된 원본 + 디버그 정보
    local finalMessage = modifiedOutput .. debugInfo

    -- 메시지 교체 (메인 스크립트 방식)
    local chatLength = getChatLength(triggerId)
    local lastIndex = chatLength - 1
    setChat(triggerId, lastIndex, finalMessage)

    addDebug("✅ 메시지 업데이트 완료 (index: " .. lastIndex .. ")")
end

-- ============================================
-- 이벤트 핸들러 (메인 스크립트 방식)
-- ============================================

onOutput = async(function(triggerId)
    local success, result = pcall(processTestOutput, triggerId)

    if not success then
        local errMsg = "\n❌ **테스트 스크립트 에러**: " .. tostring(result) .. "\n"
        addToContext(triggerId, errMsg, "assistant")
    end
end)
