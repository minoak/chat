# 기존 주간 스케줄 시스템 분석

**분석 대상 브랜치:** `claude/continue-dudada-project-011CUXjsh1QMQVJpXGHSK5FW`

---

## 📋 현재 구현된 시스템

### 1. Lua 함수들

#### A) `set_weekly_schedule` (라인 3990~4043)

**목적:** 주간 활동 계획 설정

**동작 방식:**
```lua
_G["set_weekly_schedule"] = function(triggerId)
    -- 선택지 구성
    local morningOptions = {
        "전투 훈련", "마법 이론", "도서관 자습", "수업 빼먹기", "자유시간"
    }
    local afternoonOptions = {
        "훈련장", "카페", "쇼핑", "퀘스트", "동아리", "휴식", "자유시간"
    }

    local days = {"월요일", "화요일", "수요일", "목요일", "금요일"}

    -- 각 날짜별로 활동 선택 (총 10번 alertSelect!)
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
        displayText = displayText .. string.format("%s\n오전: %s\n오후: %s\n\n", ...)
    end

    -- 변수 저장
    setState(triggerId, "weekly_schedule_plan", displayText)
    setChatVar(triggerId, "weekly_schedule_display", displayText)
end
```

**특징:**
- ✅ 5일 × (오전+오후) = 10번 선택
- ✅ 선택 내용을 텍스트로 저장
- ❌ **매우 복잡하고 번거로움** (alertSelect 10번!)
- ❌ **턴 낭비** (선택만 하는데 시간 소요)

---

#### B) `execute_weekly_schedule` (라인 4046~4099)

**목적:** 설정한 스케줄 실행 (시간 진행)

**동작 방식:**
```lua
_G["execute_weekly_schedule"] = function(triggerId)
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
        newWeek = 1
        local seasons = {"봄" = "여름", "여름" = "가을", ...}
        currentSeason = seasons[currentSeason]
        setChatVar(triggerId, "current_season", currentSeason)
    end

    setChatVar(triggerId, "week_of_season", newWeek)
    setChatVar(triggerId, "day_of_week", "1")
    setChatVar(triggerId, "current_time", "오전")

    -- AI에게 시스템 메시지 전송
    local message = string.format("한 주가 지났습니다.\n\n%s\n\n...", scheduleData)
    sendSystemMessage(triggerId, message)
end
```

**특징:**
- ✅ 주차 자동 증가
- ✅ 계절 변경 로직
- ❌ **sendSystemMessage로 AI에게 직접 명령** (권장하지 않음)
- ❌ **로어북 미사용** (AI가 자연스럽게 서술 불가)

---

### 2. HTML 버튼 (rpg_status_panel.html)

**위치:** 활동 선택 패널 안 (floating panel)

```html
<details class="activity-float">
    <summary></summary>
    <div class="activity-float-content">
        <div class="activity-section-title">📅 주간 스케줄</div>

        <!-- 현재 스케줄 표시 -->
        <div style="...">
            {{getvar::weekly_schedule_display}}
        </div>

        <!-- 스케줄 조정 버튼 -->
        <button type="button" risu-trigger="set_weekly_schedule"
                class="activity-btn"
                style="background:linear-gradient(135deg, #42A5F5 0%, #2196F3 100%);">
            <div>📋</div>
            <div>스케줄 조정</div>
        </button>

        <!-- 스케줄 실행 버튼 -->
        <button type="button" risu-trigger="execute_weekly_schedule"
                class="activity-btn"
                style="background:linear-gradient(135deg, #66BB6A 0%, #4CAF50 100%);">
            <div>✨</div>
            <div>스케줄 실행</div>
        </button>
    </div>
</details>
```

**특징:**
- ✅ Floating panel (화면 고정)
- ✅ 2개 버튼 (조정/실행 분리)
- ✅ 현재 스케줄 표시
- ❌ RPG 스탯 패널과 분리되어 있음

---

## 🎯 문제점 분석

### 1. 사용성 문제

**너무 번거로움:**
- 플레이어가 10번 선택해야 함 (5일 × 2회)
- "월요일 오전 뭐 할까?" → "월요일 오후 뭐 할까?" → "화요일 오전..." → 반복
- 지루하고 피곤함

**턴 낭비:**
- 선택하는 데만 시간 소요
- 실제 플레이가 아닌 "관리"에 시간 씀

### 2. 설계 문제

**AI 제어 방식:**
- `sendSystemMessage`로 AI에게 직접 명령
- 로어북을 통한 자연스러운 서술 불가
- "시스템이 개입한다"는 느낌

**프리셋 부재:**
- 매주 일일이 선택해야 함
- "이번 주도 지난주랑 똑같이!" 불가능
- 반복 작업

### 3. 턴 경제 문제

**목표: 1학기 = 20~30턴**
- 현재: 선택 10번 + 실행 + 결과 = 주당 2~3턴 최소
- 12주 × 2.5턴 = 30턴 (선택만으로 턴 소진!)
- 이벤트 넣으면 40~50턴으로 증가

---

## 💡 개선 방향 (설계 단계)

### 제안 1: 프리셋 시스템

**개념:**
- 매주 활동을 일일이 선택하지 않고
- **커리큘럼 + 라이프스타일** 2가지만 선택
- 나머지는 자동 결정

**장점:**
- alertSelect 10번 → 2번으로 감소
- 빠른 선택, 빠른 진행
- 프리셋의 의미가 명확 (전략적 선택)

**예시:**
```
커리큘럼: Professor Viper
→ 월~금 오전: 전투/암살술 자동 배정

라이프스타일: 사교형
→ 월~금 오후: 카페/교류 자동 배정
```

### 제안 2: 로어북 기반 서술

**개념:**
- `sendSystemMessage` 제거
- 로어북이 조건부 활성화
- AI가 자연스럽게 주간 보고서 작성

**예시:**
```markdown
{{#if {{getvar::current_curriculum}}}}

# 주간 보고서 작성 가이드

커리큘럼: {{getvar::current_curriculum}}
라이프스타일: {{getvar::current_lifestyle}}

다음 형식으로 보고서를 작성하세요:
- 담당교수 평가 (한 줄)
- 동료 평가 (한 줄)
- 주요 사건 (3~5개)

{{/if}}
```

### 제안 3: 버튼 통합

**개념:**
- "조정" + "실행" 2개 버튼 → 1개로 통합
- "주간 커리큘럼 선택" 버튼 하나로 끝

**위치:**
- RPG 스탯 패널 안으로 이동
- Floating panel 제거 (정리)

---

## ⚠️ 주의사항

### 기존 시스템 제거 시

**삭제할 것:**
1. `set_weekly_schedule` 함수 전체
2. `execute_weekly_schedule` 함수 전체
3. HTML의 floating panel 전체
4. 관련 변수들:
   - `weekly_schedule_plan`
   - `weekly_schedule_display`

**유지할 것:**
1. 시간/주차 관리 로직
2. 계절 변경 로직
3. 기본 변수들:
   - `week_of_season`
   - `current_season`
   - `day_of_week`
   - `current_time`

### 대체 구조

**새로운 함수:**
```lua
_G["select_curriculum"] = function(triggerId)
    -- 1. 커리큘럼 선택 (alertSelect 1회)
    -- 2. 라이프스타일 선택 (alertSelect 1회)
    -- 3. 변수 저장만 (AI 명령 없음)
    -- 끝!
end
```

**새로운 로어북:**
```markdown
WEEKLY_REPORT_LOREBOOK.md
- 조건: {{#if {{getvar::current_curriculum}}}}
- 역할: AI에게 보고서 작성 가이드 제공
```

---

## 📝 다음 작업 제안

1. **사용자 승인 필요:**
   - 기존 시스템 제거해도 되는지
   - 프리셋 방식으로 변경해도 되는지
   - 로어북 기반 서술로 변경해도 되는지

2. **세계관 정보 필요:**
   - 커리큘럼 프리셋 내용 (교수별)
   - 라이프스타일 프리셋 내용 (7종)

3. **구현 순서:**
   - Phase 1: 기존 함수/HTML 제거
   - Phase 2: 새 함수 추가
   - Phase 3: 로어북 작성
   - Phase 4: HTML 버튼 수정

---

**작성일:** 2025-10-28
**목적:** 기존 시스템 이해 및 개선 방향 제시
**상태:** 설계 단계 (구현 전 승인 필요)
