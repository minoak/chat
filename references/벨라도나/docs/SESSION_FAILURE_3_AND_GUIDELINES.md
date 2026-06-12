# 세션 실패 기록 #3 (2025-10-29) + 필수 가이드라인

**브랜치:** `claude/session-011CUZRiC4HEivg4LPyMv6b5`
**세션 ID:** `011CUZRiC4HEivg4LPyMv6b5` (계속)
**최종 상태:** be66393 커밋으로 롤백됨

---

## 🚨 이번 세션의 중대한 실수들

### 1. 로어북 형식 완전 오해 ⚠️⚠️⚠️

#### 실수 내용
- ❌ 이벤트 로어북(EVENT_WEEK01_ORIENTATION.md 등)에 **직접 스토리를 작성**함
- ❌ "벚꽃이 만개한 캠퍼스에서 한 주가 시작되었다..." 같은 서술 작성
- ❌ "주간 활동 묘사", "주간 보고서" 섹션에 완성된 내용을 작성

#### 올바른 방식
- ✅ 로어북은 **AI에게 가이드라인을 제공**하는 것
- ✅ "이번 주는 오리엔테이션이다"라는 정보만 제공
- ✅ "이렇게 묘사해라", "이렇게 보고서 작성해라"는 **지시**만 작성

#### 참고: WEEKLY_SCHEDULE.md (올바른 예시)
```markdown
## 1단계: 주간 활동 묘사

{{user}}가 선택한 커리큘럼과 라이프스타일에 따라 1주일간의 활동을 자연스럽게 묘사하세요.

### 커리큘럼 반영
- 선택한 교수의 수업 특징과 전문 분야를 반영
- 해당 분야의 학습과 훈련 내용을 포함

### 묘사 방식
- 1주일을 요약하여 주요 사건과 경험을 중심으로 서술
```

**이것이 가이드라인입니다. AI에게 "어떻게 할지" 알려주는 것입니다.**

---

### 2. CBS (Curly Braced Syntaxes) 구문 오류

#### 실수 내용
```markdown
❌ 잘못된 구문:
{{#if {{and::{{getvar::current_curriculum}}::{{getvar::current_lifestyle}}}}}}
```

**문제:** RisuAI CBS는 단순히 변수 존재 여부를 체크하지 않습니다.

#### 올바른 구문
```markdown
✅ 올바른 구문 (DYNAMIC_MATRIX.md 참고):
{{#if {{and::{{? {{getvar::current_curriculum}} != ""}}::{{? {{getvar::current_lifestyle}} != ""}}}}}}
```

**핵심:**
- `{{? 조건식}}` - 조건을 평가하는 표현식 필요
- `!= ""` 또는 `!= null` - 명시적인 비교 연산자 필요

#### 참고: DYNAMIC_MATRIX.md의 올바른 예시
```markdown
{{#if {{and::{{? {{getvar::mirabel_affinity}} >= -500}}::{{? {{getvar::mirabel_affinity}} < -300}}}}}}
```

---

### 3. JavaScript 사용 금지 규칙 위반 ⚠️

#### 실수 내용
```html
❌ HTML에 onclick JavaScript 추가:
<button ... onclick="setTimeout(function(){document.getElementById('display_curriculum').textContent='';}, 500);">
```

#### 규칙 (docs/CURRENT_STATUS.md에 명시)
```
절대 반복하지 말 것:
2. ❌ JavaScript 코드 사용 (RisuAI 미지원)
```

**RisuAI는 HTML 버튼의 JavaScript 이벤트 핸들러를 지원하지 않습니다.**

#### 올바른 방식
- ✅ Lua 함수에서 변수 관리
- ✅ `risu-trigger` 속성 사용
- ✅ HTML은 순수 마크업만 (인라인 스타일은 가능)

---

### 4. onEndOfTurn 타이밍 오해

#### 실수 내용
```lua
❌ 잘못된 가정:
1. addChat(triggerId, "user", message) - 사용자 메시지 추가
2. AI가 응답 생성
3. AI 턴 종료 → onEndOfTurn 호출
4. 변수 초기화
```

**실제:**
```
1. addChat(triggerId, "user", message) - 사용자 메시지 추가
2. 사용자 턴 종료 → onEndOfTurn 호출 ← 여기서 초기화됨!
3. AI가 응답 생성 (이미 변수 비어있음)
```

**결과:** 로어북 조건이 맞지 않아 비활성화됨

---

### 5. editDisplay 성능 문제 (부분적으로 수정함)

#### 문제 발견
```lua
❌ 매 스트리밍마다 정규식 파싱:
listenEdit("editDisplay", function(triggerId, data)
    data = data:gsub("<CombatChoice>(.-)</CombatChoice>", function(content)
        -- 복잡한 파싱 로직
    end)
end)
```

**스트리밍 중 매번 호출되어 느려짐**

#### 수정 (부분적으로 완료)
```lua
✅ 완성된 블록만 처리:
listenEdit("editDisplay", function(triggerId, data)
    if not data:find("</CombatChoice>") then
        return data  -- 닫는 태그 없으면 스킵
    end
    -- 파싱 진행
end)
```

**Note:** 이 수정은 롤백되지 않았음. 유지할 가치 있음.

---

### 6. 문서 확인 실패

#### 확인하지 않은 것들
1. ❌ `docs/BEST_PRACTICES.md` - RisuAI Lua 가이드
2. ❌ `docs/CURRENT_STATUS.md` - JavaScript 금지 규칙
3. ❌ `lorebooks/DYNAMIC_MATRIX.md` - CBS 조건문 올바른 예시
4. ❌ 사용자가 "로어북 형식"에 대해 설명한 내용

---

## 📚 필수 가이드라인 (다음 세션용)

### A. 로어북 작성 규칙 ⚠️⚠️⚠️

#### 로어북의 역할
```
로어북 ≠ 스토리 작성
로어북 = AI에게 정보 + 가이드라인 제공
```

#### 올바른 로어북 구조

**1. 이벤트 정보 제공**
```markdown
# 🌸 Week 1 - 신입생 오리엔테이션

이번 주는 **신입생 오리엔테이션 기간**입니다.

[OOC: Trigger this event as top priority]
```
→ AI에게 "이번 주에 이런 이벤트가 있다"고 알림

**2. 묘사 가이드라인 제공**
```markdown
## 주간 활동 묘사 가이드

다음 요소를 포함하여 1주일을 요약 서술하세요:
- 입학식 및 하우스 배정
- 하우스별 환영회
- 캠퍼스 투어
- 오리엔테이션 파티
- 교재 구입
```
→ AI에게 "이런 내용을 포함해서 묘사해라"고 지시

**3. 보고서 작성 가이드라인**
```markdown
## 주간 보고서 작성

### 담당 하우스 대표 평가 (한 줄)
{{user}}의 하우스 대표가 신입생 환영회에서 한마디 남긴다.

### 주요 사건 (3~5개)
이번 주 동안 있었던 중요한 순간들을 간결하게 나열합니다.
```
→ AI에게 "이런 형식으로 보고서 작성해라"고 지시

#### ❌ 절대 하지 말 것
```markdown
❌ 잘못된 예시:
벚꽃이 만개한 캠퍼스에서 한 주가 시작되었다.
입학식 날, 중앙 광장은 긴장과 설렘으로 가득했다.
[완성된 스토리를 직접 작성]
```

**이것은 AI가 할 일입니다. 로어북에 쓰면 안 됩니다.**

---

### B. CBS 조건문 작성 규칙

#### 기본 구문 패턴
```markdown
1. 단일 조건 (같음):
{{#if {{equal::{{getvar::변수}}::값}}}}

2. 단일 조건 (비교):
{{#if {{? {{getvar::변수}} != ""}}}}
{{#if {{? {{getvar::변수}} >= 100}}}}

3. AND 조건:
{{#if {{and::{{? {{getvar::var1}} != ""}}::{{? {{getvar::var2}} != ""}}}}}}

4. 범위 조건:
{{#if {{and::{{? {{getvar::affinity}} >= -500}}::{{? {{getvar::affinity}} < -300}}}}}}
```

#### 참고 파일
- `lorebooks/DYNAMIC_MATRIX.md` - 복잡한 조건문 예시
- `lorebooks/WEEKLY_SCHEDULE.md` - 커리큘럼/라이프스타일 조건
- `lorebooks/EVENT_MIDTERM.md` - week_of_season 조건

---

### C. JavaScript 사용 금지

#### 절대 사용 금지
```html
❌ onclick 핸들러
❌ <script> 태그
❌ addEventListener
❌ document.getElementById() 등
```

#### 대신 사용할 것
```lua
✅ Lua 함수로 변수 관리
✅ risu-trigger 속성
✅ setState/getChatVar로 상태 저장
```

---

### D. 작업 프로세스 (반드시 준수)

```
1. 사용자 요청 이해
   ↓
2. 관련 문서 읽기
   - docs/BEST_PRACTICES.md
   - docs/CURRENT_STATUS.md
   - 관련 로어북 파일
   ↓
3. 기존 코드 확인
   - Read 도구로 파일 읽기
   - Grep으로 유사 패턴 검색
   ↓
4. 설계 제안
   - 어떻게 구현할지 설명
   - 수정할 파일 목록
   ↓
5. **사용자 승인 대기** ⚠️
   ↓
6. 승인 후 구현
   ↓
7. 커밋 & 푸시
```

---

### E. 변수 초기화 문제 해결 방법

#### 문제
- 버튼 클릭 → 선택 → 스케줄 시작 → AI 응답 생성 → 변수 초기화
- 초기화 타이밍: **AI 응답 후**여야 함
- 하지만 onEndOfTurn은 사용자 턴 후 즉시 호출됨

#### 해결 방법 (사용자 확인 필요)

**Option 1: 초기화하지 않음**
- 변수를 초기화하지 않고 그대로 유지
- 매번 덮어쓰기
- 단점: 변화 감지 불가

**Option 2: 명시적 초기화 버튼**
- "스케줄 초기화" 버튼 별도 제공
- 사용자가 수동으로 초기화
- 단점: 번거로움

**Option 3: 조건 변경**
- 로어북 활성화 조건을 다르게 설정
- 예: "선택된 적 있음" 플래그 사용
- 사용자와 논의 필요

---

## 🔄 롤백 현황

### 현재 상태
```
로컬 HEAD: be66393 (Fix event lorebooks to use weekly summary + report format)
원격 HEAD: 7b99a38 (Optimize editDisplay to prevent streaming lag)
```

### 롤백된 커밋들
1. `3cd2f85` - Fix weekly schedule activation (CBS 구문 수정)
2. `0abd7b4` - Fix schedule reset timing (onEndOfTurn 추가)
3. `7b99a38` - Optimize editDisplay (스트리밍 최적화)

### 롤백 이유
- CBS 구문 수정이 불완전함
- JavaScript 사용 금지 규칙 위반
- onEndOfTurn 타이밍 문제
- 근본적인 접근 방식 재검토 필요

---

## 📋 현재 문제점 (미해결)

### 1. WEEKLY_SCHEDULE.md 조건문 오류
```markdown
현재: {{#if {{and::{{getvar::current_curriculum}}::{{getvar::current_lifestyle}}}}}}
문제: 변수 존재 여부만 체크하는 잘못된 구문

수정 필요:
{{#if {{and::{{? {{getvar::current_curriculum}} != ""}}::{{? {{getvar::current_lifestyle}} != ""}}}}}}
```

### 2. 이벤트 로어북 형식 오류
```
파일: EVENT_WEEK01_ORIENTATION.md
파일: EVENT_WEEK03_FOUNDATION_FESTIVAL.md
파일: EVENT_WEEK09_SPRING_BALL.md
파일: EVENT_WEEK12_FINAL_EXAM.md

문제: 직접 스토리를 작성함 (AI가 할 일)
수정 필요: 가이드라인 형식으로 재작성
```

### 3. 변수 초기화 방법 미정
```
문제: 스케줄 시작 후 선택값 초기화가 필요하나 방법 불명확
해결: 사용자와 논의 필요
```

---

## 📝 다음 세션 시작 체크리스트

### 필수 읽기 (시작 전)
- [ ] 이 문서 (`docs/SESSION_FAILURE_3_AND_GUIDELINES.md`)
- [ ] `docs/CURRENT_STATUS.md`
- [ ] `docs/BEST_PRACTICES.md`
- [ ] `lorebooks/DYNAMIC_MATRIX.md` (CBS 구문 예시)
- [ ] `lorebooks/WEEKLY_SCHEDULE.md` (가이드라인 형식 예시)

### 작업 시작 전 확인
- [ ] 사용자 요청 명확히 이해
- [ ] 관련 파일 Read로 읽기
- [ ] 유사한 패턴 Grep으로 검색
- [ ] 설계 제안서 작성
- [ ] **사용자 승인 대기**

### 절대 하지 말 것
- [ ] ❌ 로어북에 직접 스토리 작성
- [ ] ❌ JavaScript 사용 (onclick, script 등)
- [ ] ❌ CBS 구문을 추측으로 작성
- [ ] ❌ 승인 없이 구현 시작
- [ ] ❌ 문서 확인 없이 작업

---

## 💡 핵심 교훈

### 1. 로어북의 본질
```
로어북 = AI의 행동 지침서
로어북 ≠ 완성된 스토리
```

### 2. RisuAI 제약사항
```
✅ Lua: 변수 관리, 태그 파싱
✅ HTML: 순수 마크업 (인라인 스타일 가능)
✅ CBS: 조건부 텍스트 표시
❌ JavaScript: 전혀 지원 안 됨
```

### 3. 타이밍 이해
```
사용자 입력 → onStart
  ↓
사용자 턴 종료 → onEndOfTurn ← 주의!
  ↓
AI 응답 생성
  ↓
AI 턴 종료 → (이벤트 없음?)
```

### 4. 문서의 중요성
```
추측으로 작성 → 실패
문서 확인 → 기존 패턴 참고 → 성공
```

---

**작성일:** 2025-10-29
**작성자:** Claude
**최종 커밋:** be66393
**상태:** 롤백 완료, 다음 세션 대기

---

## 🎯 다음 세션에서 해야 할 일

### 우선순위 1: 조건문 수정
1. `lorebooks/WEEKLY_SCHEDULE.md`의 CBS 구문 수정
2. `lorebooks/DYNAMIC_MATRIX.md` 패턴 참고

### 우선순위 2: 이벤트 로어북 재작성
1. 4개 이벤트 파일을 가이드라인 형식으로 변경
2. `lorebooks/WEEKLY_SCHEDULE.md` 스타일 참고
3. 직접 작성한 스토리 모두 제거
4. AI에게 지시하는 형식으로 변경

### 우선순위 3: 변수 초기화 방법 논의
1. 사용자에게 3가지 옵션 제시
2. 방향 결정 후 구현

---

## 📞 사용자에게 전달할 메시지

```
현재 상황:
- be66393 커밋으로 롤백 완료
- WEEKLY_SCHEDULE.md 조건문 오류 있음 (미수정)
- 이벤트 로어북 4개 잘못된 형식 (미수정)
- 변수 초기화 방법 미정

다음 세션 시작 시:
1. 조건문 수정 (CBS 구문)
2. 이벤트 로어북 재작성 (가이드라인 형식)
3. 변수 초기화 방법 논의

필요한 것:
- 변수 초기화 방법에 대한 방향 (3가지 옵션 중 선택)
```
