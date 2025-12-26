-- 이미지 태그 수정 테스트 코드

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

-- ============================================
-- 테스트 케이스
-- ============================================

print("=== 이미지 태그 수정 테스트 시작 ===\n")

-- 테스트 1: 기본 형식 오류
print("테스트 1: 기본 형식 오류 (콜론 → 따옴표)")
local test1_main = 'She looks nervous. <img:Mirabel.nervous> "I need to tell you something."'
local test1_aux = '[IMG_FIX:<img:Mirabel.nervous>→<img="Mirabel.nervous.casual_default">]\n[Affinity:Mirabel:like]\n<Panel>■★'

local result1, fixes1 = applyImageTagFixes(test1_main, test1_aux)
print("원본:", test1_main)
print("결과:", result1)
print()

-- 테스트 2: 따옴표 없음
print("테스트 2: 따옴표 없음")
local test2_main = 'Alice smiles brightly. <img=Alice.happy> "Hello!"'
local test2_aux = '[IMG_FIX:<img=Alice.happy>→<img="Alice.happy.uniform_default">]'

local result2 = applyImageTagFixes(test2_main, test2_aux)
print("원본:", test2_main)
print("결과:", result2)
print()

-- 테스트 3: 복잡한 케이스 (공백 포함)
print("테스트 3: 복잡한 케이스 (공백 + 추가 텍스트)")
local test3_main = 'Margaret appears worried. <img="Margaret nervous and looking away"> She hesitates.'
local test3_aux = '[IMG_FIX:<img="Margaret nervous and looking away">→<img="Margaret.nervous.casual_home">]'

local result3 = applyImageTagFixes(test3_main, test3_aux)
print("원본:", test3_main)
print("결과:", result3)
print()

-- 테스트 4: 여러 개 동시 수정
print("테스트 4: 여러 태그 동시 수정")
local test4_main = '<img:Mirabel.happy> talks to <img:Margaret.neutral> about the plan.'
local test4_aux = [[
[IMG_FIX:<img:Mirabel.happy>→<img="Mirabel.happy.uniform_default">]
[IMG_FIX:<img:Margaret.neutral>→<img="Margaret.neutral.uniform_neat">]
]]

local result4 = applyImageTagFixes(test4_main, test4_aux)
print("원본:", test4_main)
print("결과:", result4)
print()

-- 테스트 5: 특수문자 포함
print("테스트 5: 특수문자 이스케이프 테스트")
local test5_main = 'She looks up. <img="Alice.surprised"> "What?!"'
local test5_aux = '[IMG_FIX:<img="Alice.surprised">→<img="Alice.surprised.casual_default">]'

local result5 = applyImageTagFixes(test5_main, test5_aux)
print("원본:", test5_main)
print("결과:", result5)
print()

-- 테스트 6: 매칭 실패 케이스
print("테스트 6: 존재하지 않는 태그 (실패 예상)")
local test6_main = 'She smiles. <img="Mirabel.happy">'
local test6_aux = '[IMG_FIX:<img:Mirabel.sad>→<img="Mirabel.sad.casual_default">]'  -- 다른 태그

local result6 = applyImageTagFixes(test6_main, test6_aux)
print("원본:", test6_main)
print("결과:", result6, "(변경 없어야 함)")
print()

print("=== 테스트 완료 ===")
