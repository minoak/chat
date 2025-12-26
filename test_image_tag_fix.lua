-- 이미지 태그 복장 접미사 추가 테스트 코드
-- 보조모델이 시간/장소 기반으로 "_일상복", "_교복" 등 접미사 추가

-- ============================================
-- 설정
-- ============================================

-- 실제 보조모델 호출 여부 (RisuAI 환경에서만 작동)
local USE_REAL_MODEL = true  -- true: 실제 API 호출, false: 시뮬레이션만

-- ============================================
-- 테스트용 헬퍼 함수
-- ============================================
function escapePattern(str)
    return str:gsub("([%.%+%-%*%?%[%]%(%)%%])", "%%%1")
end

-- 이미지 태그 수정 적용 함수
function applyImageTagFixes(data, auxiliaryOutput)
    local fixCount = 0
    local fixes = {}

    -- [IMG_FIX:wrong→correct] 패턴 찾기
    for wrongTag, correctTag in auxiliaryOutput:gmatch("%[IMG_FIX:(.-)→(.-)%]") do
        -- 특수문자 이스케이프
        local escapedWrong = escapePattern(wrongTag)

        -- 교체 (첫 번째 발견만)
        local oldData = data
        data = data:gsub(escapedWrong, correctTag, 1)

        if data ~= oldData then
            fixCount = fixCount + 1
            table.insert(fixes, {
                wrong = wrongTag,
                correct = correctTag
            })
            print(string.format("✓ 수정: %s → %s", wrongTag, correctTag))
        else
            print(string.format("✗ 실패: '%s' 찾을 수 없음", wrongTag))
        end
    end

    print(string.format("\n총 %d개 태그 수정 완료\n", fixCount))
    return data, fixes
end

-- 컨텍스트 시뮬레이션 (실제로는 {{getvar}} 사용)
function getContext()
    return {
        time = "Evening",      -- Morning/Afternoon/Evening/Night
        location = "Dormitory" -- Classroom/Dormitory/MainHall/Garden 등
    }
end

-- 보조모델 시뮬레이션: 컨텍스트 기반 복장 선택
function simulateAuxiliaryOutfit(imageTag, context)
    -- 시간대별 기본 복장
    local timeOutfits = {
        Morning = "_교복",
        Afternoon = "_교복",
        Evening = "_일상복",
        Night = "_잠옷"
    }

    -- 장소별 특수 복장 (우선순위)
    local locationOutfits = {
        Ballroom = "_이브닝드레스",
        Garden = "_원피스",
        Beach = "_수영복",
        Gym = "_운동복"
    }

    -- 장소 우선, 없으면 시간대
    local outfit = locationOutfits[context.location] or timeOutfits[context.time] or "_일상복"

    -- 태그에 복장 접미사 추가
    local modifiedTag = imageTag:gsub('(")', outfit .. '%1')

    return string.format("[IMG_FIX:%s→%s]", imageTag, modifiedTag)
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
-- 실제 보조모델 호출 (RisuAI API 사용)
-- ============================================

function callRealAuxiliaryModel(prompt)
    -- 설정에서 비활성화되어 있으면 바로 반환
    if not USE_REAL_MODEL then
        print("\n⏭️  USE_REAL_MODEL=false - 시뮬레이션 모드")
        return nil
    end

    -- RisuAI의 requestChatCompletion API 사용
    -- 이 함수는 RisuAI 환경에서만 작동합니다

    print("\n🔄 보조모델 API 호출 중...")

    -- RisuAI API를 통해 보조모델 호출
    local success, response = pcall(function()
        return requestChatCompletion({
            role = "system",
            content = "You are an auxiliary model for an RPG system. Follow instructions precisely.",
            messages = {{
                role = "user",
                content = prompt
            }},
            temperature = 0.3,  -- 일관성을 위해 낮은 temperature
            maxTokens = 500
        })
    end)

    if success and response then
        print("✅ 보조모델 응답 받음 (" .. #response .. " chars)")
        return response
    else
        print("❌ 보조모델 호출 실패 - 시뮬레이션 모드로 전환")
        print("   사유: RisuAI 환경이 아니거나 API 미지원")
        return nil
    end
end

-- ============================================
-- 테스트 케이스
-- ============================================

print("=== 이미지 태그 복장 접미사 추가 테스트 시작 ===\n")
print("=" .. string.rep("=", 70))
print("보조모델 실시간 호출 테스트")
print("=" .. string.rep("=", 70))
print()
print("설정:")
print("  USE_REAL_MODEL = " .. tostring(USE_REAL_MODEL))
print()
if USE_REAL_MODEL then
    print("🔥 실제 보조모델 API 호출 모드")
    print("   - RisuAI 환경에서 실제 AI를 호출합니다")
    print("   - 보조모델이 IMG_FIX 태그를 생성하는지 확인합니다")
    print("   - API 미지원 시 자동으로 시뮬레이션으로 전환됩니다")
else
    print("🔧 시뮬레이션 전용 모드")
    print("   - 실제 API를 호출하지 않고 예상 결과만 표시합니다")
    print("   - USE_REAL_MODEL을 true로 변경하면 실제 테스트가 가능합니다")
end
print("=" .. string.rep("=", 70) .. "\n")

-- 컨텍스트 설정
local context = getContext()
print(string.format("컨텍스트: 시간=%s, 장소=%s\n", context.time, context.location))

-- 테스트 1: 기본 케이스 (Evening + Dormitory → _일상복)
print("\n" .. string.rep("-", 70))
print("테스트 1: 기본 복장 추가 (저녁 + 기숙사)")
print(string.rep("-", 70))
local test1_main = 'She looks nervous. <img="Margaret.nervous"> "I need to tell you something."'
local test1_tag = '<img="Margaret.nervous">'

-- 보조모델 프롬프트 생성
local test1_prompt = generateAuxiliaryPrompt(test1_main, context)
print("\n📋 보조모델에게 전달할 프롬프트:")
print(string.rep("=", 70))
print(test1_prompt)
print(string.rep("=", 70))

-- ⚡ 실제 보조모델 호출
local test1_aux_real = callRealAuxiliaryModel(test1_prompt)

-- 보조모델 응답 (실제 또는 시뮬레이션)
local test1_aux
if test1_aux_real then
    print("\n🤖 실제 보조모델 출력:")
    print(test1_aux_real)
    test1_aux = test1_aux_real
else
    -- 실패 시 시뮬레이션으로 폴백
    test1_aux = simulateAuxiliaryOutfit(test1_tag, context)
    print("\n🔧 시뮬레이션 출력:", test1_aux)
end

-- 예상 출력 표시
local test1_expected = simulateAuxiliaryOutfit(test1_tag, context)
print("\n✅ 예상 출력:", test1_expected)

-- Lua가 수정 적용
local result1 = applyImageTagFixes(test1_main, test1_aux)
print("\n원본:", test1_main)
print("결과:", result1)

-- 검증
if test1_aux_real and test1_aux_real:find("%[IMG_FIX:") then
    print("✅ 테스트 성공: 보조모델이 IMG_FIX 태그를 생성했습니다!")
else
    print("⚠️  시뮬레이션 모드 또는 API 미지원")
end
print()

-- 테스트 2: 아침 시간대 (Morning → _교복)
print("테스트 2: 아침 시간대 (교복)")
local test2_main = 'Mirabel waves cheerfully. <img="Mirabel.happy"> "Good morning!"'
local test2_tag = '<img="Mirabel.happy">'
local morning_context = {time = "Morning", location = "Classroom"}
local test2_aux = simulateAuxiliaryOutfit(test2_tag, morning_context)

print("컨텍스트: 시간=Morning, 장소=Classroom")
print("보조모델 출력:", test2_aux)
local result2 = applyImageTagFixes(test2_main, test2_aux)
print("원본:", test2_main)
print("결과:", result2)
print()

-- 테스트 3: 특수 장소 (Ballroom → _이브닝드레스)
print("\n" .. string.rep("-", 70))
print("테스트 3: 특수 장소 우선 적용 (무도회장)")
print(string.rep("-", 70))
local test3_main = 'Celestia enters gracefully. <img="Celestia.confident"> The crowd gasps.'
local test3_tag = '<img="Celestia.confident">'
local ballroom_context = {time = "Evening", location = "Ballroom"}

-- 보조모델 프롬프트 생성
local test3_prompt = generateAuxiliaryPrompt(test3_main, ballroom_context)
print("\n📋 보조모델에게 전달할 프롬프트:")
print(string.rep("=", 70))
print(test3_prompt)
print(string.rep("=", 70))

-- ⚡ 실제 보조모델 호출
local test3_aux_real = callRealAuxiliaryModel(test3_prompt)

-- 보조모델 응답 (실제 또는 시뮬레이션)
local test3_aux
if test3_aux_real then
    print("\n🤖 실제 보조모델 출력:")
    print(test3_aux_real)
    test3_aux = test3_aux_real
else
    -- 실패 시 시뮬레이션으로 폴백
    test3_aux = simulateAuxiliaryOutfit(test3_tag, ballroom_context)
    print("\n🔧 시뮬레이션 출력:", test3_aux)
end

-- 예상 출력 표시
local test3_expected = simulateAuxiliaryOutfit(test3_tag, ballroom_context)
print("\n✅ 예상 출력:", test3_expected)

-- Lua가 수정 적용
local result3 = applyImageTagFixes(test3_main, test3_aux)
print("\n원본:", test3_main)
print("결과:", result3)

-- 검증
if test3_aux_real and test3_aux_real:find("%[IMG_FIX:") then
    print("✅ 테스트 성공: 보조모델이 IMG_FIX 태그를 생성했습니다!")
    if test3_aux_real:find("_이브닝드레스") then
        print("✅ 장소 우선순위 적용 확인: Ballroom → _이브닝드레스")
    end
else
    print("⚠️  시뮬레이션 모드 또는 API 미지원")
end
print()

-- 테스트 4: 여러 캐릭터 동시 처리
print("테스트 4: 여러 캐릭터 동시 처리")
local test4_main = '<img="Mirabel.happy"> talks to <img="Aurelia.neutral"> in the evening.'
local test4_tag1 = '<img="Mirabel.happy">'
local test4_tag2 = '<img="Aurelia.neutral">'
local test4_aux = simulateAuxiliaryOutfit(test4_tag1, context) .. '\n' ..
                  simulateAuxiliaryOutfit(test4_tag2, context)

print("보조모델 출력:", test4_aux)
local result4 = applyImageTagFixes(test4_main, test4_aux)
print("원본:", test4_main)
print("결과:", result4)
print()

-- 테스트 5: 야간 (Night → _잠옷)
print("테스트 5: 야간 시간대 (잠옷)")
local test5_main = 'Lilith yawns sleepily. <img="Lilith.tired"> Time for bed.'
local test5_tag = '<img="Lilith.tired">'
local night_context = {time = "Night", location = "Dormitory"}
local test5_aux = simulateAuxiliaryOutfit(test5_tag, night_context)

print("컨텍스트: 시간=Night, 장소=Dormitory")
print("보조모델 출력:", test5_aux)
local result5 = applyImageTagFixes(test5_main, test5_aux)
print("원본:", test5_main)
print("결과:", result5)
print()

-- 테스트 6: 정원 특수 복장
print("테스트 6: 정원 특수 복장 (원피스)")
local test6_main = 'Rosalie sits on a bench. <img="Rosalie.peaceful">'
local test6_tag = '<img="Rosalie.peaceful">'
local garden_context = {time = "Afternoon", location = "Garden"}
local test6_aux = simulateAuxiliaryOutfit(test6_tag, garden_context)

print("컨텍스트: 시간=Afternoon, 장소=Garden")
print("보조모델 출력:", test6_aux)
local result6 = applyImageTagFixes(test6_main, test6_aux)
print("원본:", test6_main)
print("결과:", result6)
print()

print("\n" .. string.rep("=", 70))
print("=== 테스트 완료 ===")
print(string.rep("=", 70))

print("\n📊 예상 결과 요약:")
print("테스트 1: _일상복 추가 (Evening + Dormitory)")
print("테스트 2: _교복 추가 (Morning)")
print("테스트 3: _이브닝드레스 추가 (Ballroom 우선)")
print("테스트 4: 두 캐릭터 모두 _일상복")
print("테스트 5: _잠옷 추가 (Night)")
print("테스트 6: _원피스 추가 (Garden 우선)")

print("\n" .. string.rep("=", 70))
print("💡 실제 보조모델 테스트 방법")
print(string.rep("=", 70))
print([[

1. 위에서 출력된 "📋 보조모델에게 전달할 프롬프트" 섹션을 복사
2. RisuAI의 보조모델 채팅에 붙여넣기
3. 보조모델의 출력이 "✅ 보조모델 예상 출력"과 일치하는지 확인

예상 출력 형식:
  [IMG_FIX:<img="Character.emotion">→<img="Character.emotion_복장">]

실제 통합 시:
  - AUXILIARY_PROMPT_NEW.md에 IMAGE TAG CORRECTION 섹션 추가
  - belladonna_academy_rpg_new.lua에 applyImageTagFixes() 함수 추가
  - processOutput()에서 보조모델 응답에 applyImageTagFixes() 적용

]])
print(string.rep("=", 70))
