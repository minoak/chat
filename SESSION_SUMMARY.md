# Session Summary - Dating Sim System Implementation

## 이번 세션에서 완료한 작업

### 1. 시간 진행 시스템 구현 ⏰
**파일**: `belladonna_academy_rpg.lua`

- `progressTime()` 함수 추가
  - 오전 활동 → 오후로 자동 진행
  - 오후 활동 → 다음날 오전으로 자동 진행
  - 7일 (월-일) 순환
  - 7일 종료 → 다음 주로 이동
  - 12주 종료 → 다음 시즌으로 이동

- 모든 활동 버튼 (13개)에 시간 진행 자동 연결
  - `activity_combat`, `activity_magic` 등
  - "주말 내내 휴식" 버튼은 일요일 오후로 스킵

### 2. 요일 이름 시스템 추가 📅
**파일**: `belladonna_academy_rpg.lua`, `academic_schedule_panel.html`

- `getDayName()` 함수 추가: 숫자 → 한글 요일 변환
- `day_of_week_name` 변수 추가
  - 자동 업데이트: "월요일", "화요일", "수요일", ..., "일요일"
  - HTML에서 직접 `{{getvar::day_of_week_name}}` 사용 가능
  - 보조 프롬프트에도 반영

### 3. 12주 학기 시스템 확장 📚
**파일**: `belladonna_academy_rpg.lua`

- 기존 4주 → **12주 시스템**으로 확장
  - 한 시즌 = 12주 (약 3개월)
  - 총 4개 시즌 = 48주 (1년)

- 시험 주차 시스템 추가
  - Week 4, 8, 12 = 시험 주간
  - `is_exam_week` 플래그 자동 설정

### 4. 학사 일정 자동 생성 시스템 🗓️
**파일**: `belladonna_academy_rpg.lua`

- `getWeekSchedule()` 함수 추가
  - Week 1-12별 고유한 학사 일정 메시지
  - Week 1: 신입생 오리엔테이션
  - Week 2: 정규 수업 시작 / 하우스 필수 회의
  - Week 3: 정규 수업 진행중 / 동아리 활동
  - Week 4: 📝 1차 시험 주간
  - Week 5-7: 정규 수업 진행중 (변주)
  - Week 8: 📝 2차 시험 주간
  - Week 9-11: 정규 수업 진행중 (변주)
  - Week 12: 📝 기말 시험 주간

- `week_schedule_message` 변수
  - 주차 변경 시 자동 업데이트
  - onOutput에서 초기화 체크 (비어있으면 설정)

### 5. 정보 패널 HTML 개선 🎨
**파일**: `academic_schedule_panel.html`

**최종 구조**:
```
📅 정보 패널
├─ 시간 & 달력
│  ├─ 봄 학기 Week 1/12
│  ├─ 월요일 오전
│  └─ [월][화][수][목][금][토][일] (오늘 하이라이트)
├─ 📍 현재 위치
│  └─ {{getvar::current_location}}
└─ 📋 이번 주
   └─ {{getvar::week_schedule_message}}
```

**특징**:
- CBS 중첩 조건문 제거 (파싱 오류 방지)
- Lua에서 생성한 변수만 표시
- 간단하고 깔끔한 레이아웃

### 6. 보조 프롬프트 업데이트 🤖
**파일**: `belladonna_academy_rpg.lua` - `buildAuxiliaryPrompt()`

- Current Context 섹션에 요일 추가
- 이전: `Season: 봄 Week 1 | Time: 오전 | Location: ...`
- 이후: `Season: 봄 Week 1 | Day: 월요일 오전 | Location: ...`

### 7. RP 가이드라인 업데이트 필요 📝
**사용자가 직접 수정 필요 (로어북)**

```markdown
## Time & Location

- Season: {{getvar::current_season}} (봄/여름/가을/겨울)
- Week: {{getvar::week_of_season}} / 12
- Day: {{getvar::day_of_week_name}}
- Time: {{getvar::current_time}} (오전/오후/저녁/밤/심야)
- Location: {{getvar::current_location}}
```

## 추가된 변수들

| 변수명 | 타입 | 설명 | 예시 |
|--------|------|------|------|
| `day_of_week` | 숫자 (1-7) | 현재 요일 번호 | 1 = 월요일 |
| `day_of_week_name` | 문자열 | 현재 요일 이름 | "월요일" |
| `week_of_season` | 숫자 (1-12) | 시즌 내 주차 | 1 ~ 12 |
| `is_exam_week` | "true"/"false" | 시험 주간 여부 | Week 4, 8, 12 |
| `week_schedule_message` | 문자열 | 주차별 학사 일정 | "📝 1차 시험 주간" |

## 커밋 히스토리

```
7e6d061 Fix week_schedule_message not initialized on game start
18e2a63 Move week schedule logic to Lua, restore calendar in HTML
e2c492e Simplify info panel to fix rendering issues
e949270 Extend season weeks from 4 to 12 and add exam week system
ae11424 Update auxiliary prompt to include day_of_week_name
4cc3bb4 Add day_of_week_name variable and merge location/schedule info
31f1dba Simplify calendar to minimal view-only layout
87cee98 Simplify calendar UI and merge with academic schedule
d67c98a Implement time progression system for dating sim mechanics
```

## 다음 세션에서 할 작업 (선택 사항)

### 우선순위 높음
- [ ] 시험 랭킹 시스템 구현 (1-10등, 스탯 기반)
- [ ] 주말 데이트 이벤트 강화

### 우선순위 중간
- [ ] 5단계 시간 시스템 확장? (오전/오후/저녁/밤/심야)
  - 현재는 오전/오후만 구현됨
  - RP 가이드라인에는 5단계로 명시됨
  - 필요시 추가 구현

### 완료 ✅
- [x] 활동 버튼 시스템
- [x] 시간 진행 시스템
- [x] 요일 시스템
- [x] 12주 학기 시스템
- [x] 학사 일정 시스템
- [x] 정보 패널 UI

## 주요 파일 위치

- `/home/user/dudada/belladonna_academy_rpg.lua` - 메인 Lua 스크립트
- `/home/user/dudada/academic_schedule_panel.html` - 정보 패널 HTML
- `/home/user/dudada/rpg_status_panel.html` - 활동 선택 버튼 HTML
- `/home/user/dudada/ACTIVITY_SYSTEM.md` - 활동 시스템 문서

## 브랜치 정보

- 브랜치: `claude/continue-dudada-project-011CUWg8tNDsJRoD6rbB2Hxi`
- 최신 커밋: `7e6d061`
- 리모트 상태: 모든 커밋 푸시 완료

## 참고사항

- 시간 진행은 **활동 버튼 클릭 시 자동 발동**
- HTML 패널은 **매 AI 응답마다 자동 업데이트**
- CBS 중첩 조건문 사용 금지 (파싱 오류 방지)
- Lua에서 복잡한 로직 처리 → HTML은 변수만 표시
