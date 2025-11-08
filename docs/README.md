# RisuAI Lua 스크립팅 가이드

Belladonna Academy RPG 프로젝트를 통해 학습한 RisuAI Lua 스크립팅 베스트 프랙티스와 패턴을 정리한 문서 모음입니다.

## 📚 문서 구조

### 📖 [BEST_PRACTICES.md](BEST_PRACTICES.md)
RisuAI에서 Lua 스크립트를 작성할 때 따라야 할 모범 사례를 정리한 종합 가이드입니다.

**포함 내용:**
- ✅ 변수 초기화 패턴 (조건부 초기화)
- ✅ 변수 관리 시스템 (ChatVar vs State)
- ✅ 스냅샷과 리롤 방지
- ✅ 디버깅 전략
- ✅ 일반적인 실수와 해결법
- ✅ 체크리스트

**대상:** RisuAI Lua 스크립팅을 처음 시작하는 개발자, 또는 베스트 프랙티스를 찾는 개발자

### 🔍 [CASE_STUDY_STAT_RESET_BUG.md](CASE_STUDY_STAT_RESET_BUG.md)
실제 프로젝트에서 발생한 "스탯 리셋 버그"의 발견, 디버깅, 해결 과정을 상세히 기록한 사례 연구입니다.

**포함 내용:**
- 🐛 문제 상황 (스탯이 0으로 리셋되는 현상)
- 🔎 디버깅 과정 (4단계)
- 💡 근본 원인 분석
- ✅ 해결 방법
- 📝 교훈과 배운 점
- ✔️ 검증 방법

**대상:** 실제 버그 해결 과정을 배우고 싶은 개발자, 유사한 문제를 겪고 있는 개발자

### 💻 [examples/initialization_patterns.lua](examples/initialization_patterns.lua)
다양한 초기화 패턴의 실제 코드 예제 모음입니다. 복사하여 바로 사용할 수 있는 템플릿을 제공합니다.

**포함 패턴:**
1. 단순 변수 조건부 초기화
2. 여러 변수 그룹 초기화
3. 캐릭터 배열 초기화
4. 복잡한 데이터 구조 초기화 (JSON)
5. 진행도 기반 초기화 (챕터 시스템)
6. 마이그레이션 패턴 (버전 업그레이드)
7. 스냅샷 시스템
8. 리셋 가능한 임시 변수
9. 완전한 onStart()/onEndOfTurn() 예제

**대상:** 즉시 사용 가능한 코드 템플릿이 필요한 개발자

---

## 🚀 빠른 시작

### 새로운 프로젝트를 시작한다면?

1. **[BEST_PRACTICES.md](BEST_PRACTICES.md)** 읽기
   - 핵심 개념과 원칙 이해
   - 체크리스트 숙지

2. **[examples/initialization_patterns.lua](examples/initialization_patterns.lua)** 참고
   - 필요한 패턴 복사
   - 프로젝트에 맞게 수정

3. **프로젝트에 적용**
   - 조건부 초기화 패턴 사용
   - setState와 setChatVar 둘 다 호출
   - 스냅샷 시스템 구현

### 버그를 해결하고 있다면?

1. **[CASE_STUDY_STAT_RESET_BUG.md](CASE_STUDY_STAT_RESET_BUG.md)** 읽기
   - 유사한 증상인지 확인
   - 디버깅 방법 참고

2. **디버그 로깅 추가**
   - 전략적 위치에 log() 배치
   - 변수 값 변화 추적

3. **[BEST_PRACTICES.md](BEST_PRACTICES.md)** 체크리스트 확인
   - 일반적인 실수 검토
   - 패턴 적용 여부 확인

---

## 🎯 핵심 원칙

### 1. 항상 조건부 초기화

```lua
❌ setState(triggerId, "player_level", 0)  // 무조건 초기화

✅ if getState(triggerId, "player_level") == nil then
    setState(triggerId, "player_level", 0)
end
```

### 2. 두 시스템 모두 업데이트

```lua
setState(triggerId, "player_level", newLevel)  // Lorebook 접근용
setChatVar(triggerId, "player_level", tostring(newLevel))  // 내부 저장용
```

### 3. 스냅샷으로 리롤 방지

```lua
function onStart(e)
    restoreSnapshot(triggerId)  // 턴 시작: 복원
end

function onEndOfTurn(e)
    takeSnapshot(triggerId)  // 턴 종료: 저장
end
```

---

## 📊 프로젝트 배경

### Belladonna Academy RPG System

이 문서들은 **Belladonna Academy** 라는 RisuAI 프로젝트를 개발하면서 얻은 경험과 교훈을 바탕으로 작성되었습니다.

**프로젝트 특징:**
- 학원 배경 RPG 시스템
- 캐릭터별 호감도 관리
- 레벨/경험치/스탯 시스템
- 아이템/특성 시스템
- 능력평가 시스템

**주요 학습 내용:**
- 조건부 초기화의 중요성
- 변수 관리 시스템 이해
- 스냅샷 기반 데이터 보호
- 체계적 디버깅 방법

---

## 🔧 실제 적용 사례

### 해결한 주요 버그

#### 1. 스탯 리셋 버그 (2025-10-23)
**문제:** 대화 다음 턴으로 넘어갈 때 모든 스탯이 0으로 리셋
**원인:** `onStart()`에서 조건 없이 변수 초기화
**해결:** 조건부 초기화 패턴 적용

상세: [CASE_STUDY_STAT_RESET_BUG.md](CASE_STUDY_STAT_RESET_BUG.md)

#### 2. Lorebook 미반영 문제
**문제:** 스탯이 변경되어도 AI가 인식하지 못함
**원인:** `setState()` 호출 누락
**해결:** 모든 스탯 변경 함수에 `setState()` 추가

#### 3. 리롤 시 진행 상황 손실
**문제:** AI 응답을 재생성하면 변경사항이 사라짐
**원인:** 스냅샷 시스템 미흡
**해결:** 이중 스냅샷 패턴 (턴 시작 + 턴 종료)

---

## 📖 권장 학습 순서

### 초급 (RisuAI Lua 처음 시작)

1. [BEST_PRACTICES.md](BEST_PRACTICES.md) - "변수 초기화 패턴" 섹션
2. [examples/initialization_patterns.lua](examples/initialization_patterns.lua) - 패턴 1, 2, 3
3. 간단한 프로젝트 시작 (호감도 시스템 등)

### 중급 (기본 구조 이해 완료)

1. [BEST_PRACTICES.md](BEST_PRACTICES.md) - "변수 관리 시스템" 섹션
2. [examples/initialization_patterns.lua](examples/initialization_patterns.lua) - 패턴 4, 5, 6
3. [BEST_PRACTICES.md](BEST_PRACTICES.md) - "스냅샷과 리롤 방지" 섹션
4. [examples/initialization_patterns.lua](examples/initialization_patterns.lua) - 패턴 7

### 고급 (복잡한 시스템 개발)

1. [CASE_STUDY_STAT_RESET_BUG.md](CASE_STUDY_STAT_RESET_BUG.md) - 전체
2. [BEST_PRACTICES.md](BEST_PRACTICES.md) - "디버깅 전략" 섹션
3. [examples/initialization_patterns.lua](examples/initialization_patterns.lua) - 패턴 8, 9
4. 실제 프로젝트 코드 리뷰 (`belladonna_academy_rpg.lua`)

---

## 🤝 기여 방법

이 문서들은 실제 프로젝트 경험을 바탕으로 지속적으로 업데이트됩니다.

### 기여할 수 있는 것들

- 새로운 패턴이나 베스트 프랙티스
- 실제 프로젝트 사례 연구
- 문서 개선 제안
- 오타나 오류 수정
- 추가 코드 예제

### 문서 업데이트 계획

- [ ] RisuAI 공식 문서 링크 추가
- [ ] 더 많은 실제 사례 추가
- [ ] 성능 최적화 가이드
- [ ] 고급 패턴 (상태 머신, 이벤트 시스템)
- [ ] 멀티 캐릭터 관리 패턴

---

## 📜 라이선스

이 문서들은 교육 목적으로 자유롭게 사용, 수정, 배포할 수 있습니다.

---

## 📞 문의

질문이나 제안사항이 있으시면 GitHub Issues를 통해 연락해 주세요.

---

**최종 업데이트:** 2025-10-23
**프로젝트:** Belladonna Academy RPG System
**문서 버전:** 1.0
