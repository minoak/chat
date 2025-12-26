-- 이미지 태그 복장 접미사 테스트 (채팅 통합 버전)
-- 보조모델이 시간/장소 기반으로 "_일상복", "_교복" 등 접미사 추가

-- ============================================
-- 설정
-- ============================================

local USE_REAL_MODEL = true  -- true: 실제 API 호출, false: 시뮬레이션만

-- ============================================
-- 디버그 로그
-- ============================================

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
-- 컨텍스트 (시간/장소)
-- ============================================

function getContext()
    return {
        time = "Evening",      -- Morning/Afternoon/Evening/Night
        location = "Dormitory" -- Classroom/Dormitory/MainHall/Garden/Ballroom 등
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

- **Time**: %s (Morning/Afternoon/Evening/Night)
- **Location**: %s

## Outfit Rules

**Time-based (default):**
- Morning/Afternoon → add `_교복`
- Evening → add `_일상복`
- Night → add `_잠옷`

**Location-based (PRIORITY - overrides time):**
- Ballroom → add `_이브닝드레스`
- Garden → add `_원피스`
- Beach → add `_수영복`
- Gym → add `_운동복`

## Task

Find all `<img="...">` tags in the main output below and add appropriate outfit suffix.

**Output format:**
```
[IMG_FIX:original_tag→corrected_tag]
```

**Example:**
- Context: Time=Evening, Location=Dormitory
- Found: `<img="Margaret.nervous">`
- Output: `[IMG_FIX:<img="Margaret.nervous">→<img="Margaret.nervous_일상복">]`

## Main Model Output

%s

---

**Now output the IMG_FIX tags:**
]], context.time, context.location, mainOutput)
end

-- ============================================
-- 실제 보조모델 호출
-- ============================================

function callRealAuxiliaryModel(prompt)
    clearDebugLog()

    if not USE_REAL_MODEL then
        addDebug("⏭️  USE_REAL_MODEL=false - 시뮬레이션 모드")
        return nil, "USE_REAL_MODEL=false"
    end

    -- axLLM 함수 존재 여부 확인
    if type(axLLM) ~= "function" then
        addDebug("❌ axLLM 함수가 존재하지 않음 (type: " .. type(axLLM) .. ")")
        addDebug("   RisuAI 환경이 아니거나 스크립트가 제대로 로드되지 않았습니다")
        return nil, "axLLM function not found"
    end

    addDebug("✅ axLLM 함수 발견 - 호출 준비")

    local messages = {
        {
            role = "system",
            content = "You are an auxiliary model for an RPG system. Follow instructions precisely and output only the requested tags."
        },
        {
            role = "user",
            content = prompt
        }
    }

    addDebug("🔄 보조모델 API 호출 시작...")
    addDebug("   메시지 개수: " .. #messages)

    local success, response = pcall(function()
        return axLLM(nil, messages)
    end)

    addDebug("📥 pcall 결과: success=" .. tostring(success))

    if success and response then
        addDebug("✅ 응답 객체 수신")
        addDebug("   response type: " .. type(response))

        if type(response) == "table" then
            addDebug("   response.success: " .. tostring(response.success))
            addDebug("   response.result type: " .. type(response.result))

            if response.success and response.result then
                local text = response.result
                addDebug("✅ 보조모델 응답 받음 (" .. #text .. " chars)")
                if #text > 100 then
                    addDebug("   응답 미리보기: " .. text:sub(1, 100) .. "...")
                else
                    addDebug("   응답 전체: " .. text)
                end
                return text, nil
            elseif response.success == false then
                local errMsg = tostring(response.result)
                addDebug("❌ 보조모델 응답 실패: " .. errMsg)
                return nil, errMsg
            else
                addDebug("❌ 응답 형식 오류 - success 또는 result 필드 없음")
                return nil, "Invalid response format"
            end
        else
            addDebug("❌ 응답이 테이블이 아님: " .. tostring(response))
            return nil, "Response is not a table"
        end
    else
        local errMsg = tostring(response)
        addDebug("❌ pcall 실패: " .. errMsg)
        return nil, errMsg
    end
end

-- ============================================
-- 보조모델 시뮬레이션 (폴백용)
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
-- 채팅 이벤트 핸들러
-- ============================================

_G["onUserInput"] = function(data, triggerId)
    -- 사용자 입력을 메인 모델 출력처럼 처리
    local mainOutput = data

    -- 출력 시작
    local output = "\n" .. string.rep("=", 60) .. "\n"
    output = output .. "🧪 **이미지 태그 복장 테스트**\n"
    output = output .. string.rep("=", 60) .. "\n\n"

    -- 컨텍스트 정보
    local context = getContext()
    output = output .. "⏰ **컨텍스트**: 시간=" .. context.time .. ", 장소=" .. context.location .. "\n\n"

    -- 메인 출력 표시
    output = output .. "📝 **입력 메시지**:\n" .. mainOutput .. "\n\n"

    -- 이미지 태그 찾기
    local hasImageTag = mainOutput:find('<img="[^"]+">') ~= nil

    if not hasImageTag then
        output = output .. "⚠️  이미지 태그가 없습니다. 테스트하려면 `<img=\"캐릭터.감정\">` 형식의 태그를 포함해주세요.\n"
        output = output .. "\n**예시**: Margaret looks nervous <img=\"Margaret.nervous\">\n"
        addToContext(triggerId, output, "assistant")
        return true
    end

    -- 보조모델 프롬프트 생성
    local prompt = generateAuxiliaryPrompt(mainOutput, context)

    output = output .. "📋 **보조모델 프롬프트 생성 완료**\n\n"

    -- 보조모델 호출
    local auxResponse, error = callRealAuxiliaryModel(prompt)

    if auxResponse then
        output = output .. "✅ **보조모델 응답**:\n```\n" .. auxResponse .. "\n```\n\n"

        -- IMG_FIX 태그 찾기
        local fixFound = auxResponse:find("%[IMG_FIX:") ~= nil

        if fixFound then
            output = output .. "🎉 **성공!** 보조모델이 IMG_FIX 태그를 생성했습니다!\n\n"

            -- 최종 결과 표시
            output = output .. "📤 **최종 결과**:\n"

            -- 실제 교체 적용 (간단 버전)
            local result = mainOutput
            for wrongTag, correctTag in auxResponse:gmatch("%[IMG_FIX:(.-)→(.-)%]") do
                local escaped = wrongTag:gsub("([%.%+%-%*%?%[%]%(%)%%])", "%%%1")
                result = result:gsub(escaped, correctTag, 1)
                output = output .. "  • " .. wrongTag .. " → " .. correctTag .. "\n"
            end

            output = output .. "\n" .. result .. "\n"
        else
            output = output .. "⚠️  보조모델이 IMG_FIX 태그를 생성하지 않았습니다.\n"
        end
    else
        output = output .. "❌ **보조모델 호출 실패**: " .. tostring(error) .. "\n\n"

        -- 시뮬레이션 폴백
        output = output .. "🔧 **시뮬레이션 모드로 전환**\n\n"

        for imageTag in mainOutput:gmatch('<img="[^"]+">') do
            local simResult = simulateAuxiliaryOutfit(imageTag, context)
            output = output .. "  " .. simResult .. "\n"
        end
    end

    -- 디버그 로그 추가
    output = output .. getDebugOutput()

    -- 출력
    addToContext(triggerId, output, "assistant")
    return true
end

-- 초기화 메시지
_G["onStart"] = function(data, triggerId)
    local msg = [[
🧪 **이미지 태그 복장 테스트 스크립트 로드됨**

이 스크립트는 보조모델이 이미지 태그에 복장 접미사를 추가하는지 테스트합니다.

**사용 방법**:
메시지에 이미지 태그를 포함해서 전송하세요.

**예시**:
```
Margaret looks nervous. <img="Margaret.nervous"> "I have something to tell you."
```

**현재 설정**:
- USE_REAL_MODEL: ]] .. tostring(USE_REAL_MODEL) .. [[

- 시간: Evening
- 장소: Dormitory

메시지를 보내면 보조모델이 자동으로 복장(_일상복 등)을 추가합니다!
]]

    addToContext(triggerId, msg, "assistant")
    return true
end
