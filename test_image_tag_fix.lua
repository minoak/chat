-- 이미지 태그 복장 접미사 추가 테스트 코드
-- 보조모델이 시간/장소 기반으로 "_일상복", "_교복" 등 접미사 추가

-- 테스트용 헬퍼 함수
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
-- 테스트 케이스
-- ============================================

print("=== 이미지 태그 복장 접미사 추가 테스트 시작 ===\n")

-- 컨텍스트 설정
local context = getContext()
print(string.format("컨텍스트: 시간=%s, 장소=%s\n", context.time, context.location))

-- 테스트 1: 기본 케이스 (Evening + Dormitory → _일상복)
print("테스트 1: 기본 복장 추가 (저녁 + 기숙사)")
local test1_main = 'She looks nervous. <img="Margaret.nervous"> "I need to tell you something."'
local test1_tag = '<img="Margaret.nervous">'
local test1_aux = simulateAuxiliaryOutfit(test1_tag, context) .. '\n[Affinity:Margaret:like]\n<Panel>■★'

print("보조모델 출력:", test1_aux)
local result1 = applyImageTagFixes(test1_main, test1_aux)
print("원본:", test1_main)
print("결과:", result1)
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
print("테스트 3: 특수 장소 우선 적용 (무도회장)")
local test3_main = 'Celestia enters gracefully. <img="Celestia.confident"> The crowd gasps.'
local test3_tag = '<img="Celestia.confident">'
local ballroom_context = {time = "Evening", location = "Ballroom"}
local test3_aux = simulateAuxiliaryOutfit(test3_tag, ballroom_context)

print("컨텍스트: 시간=Evening, 장소=Ballroom")
print("보조모델 출력:", test3_aux)
local result3 = applyImageTagFixes(test3_main, test3_aux)
print("원본:", test3_main)
print("결과:", result3)
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

print("=== 테스트 완료 ===")
print("\n예상 결과:")
print("테스트 1: _일상복 추가 (Evening + Dormitory)")
print("테스트 2: _교복 추가 (Morning)")
print("테스트 3: _이브닝드레스 추가 (Ballroom 우선)")
print("테스트 4: 두 캐릭터 모두 _일상복")
print("테스트 5: _잠옷 추가 (Night)")
print("테스트 6: _원피스 추가 (Garden 우선)")
