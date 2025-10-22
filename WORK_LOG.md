# Belladonna Academy RPG System - Work Log

## Session: 2025-10-21 - Status Panel Refactor

### Branch
`claude/status-panel-refactor-011CULHEMzJabhP38ZzPyx98`

---

## 작업 요약

보조 모델(auxiliary model) 통합 및 스테이터스 패널 출력 방식 개선 작업을 진행했습니다.

### 주요 성과

1. **보조 모델 태그가 채팅에 정상 출력** ✅
2. **태그 파싱 및 변수 업데이트 정상 작동** ✅
3. **토큰 낭비 제거 (HTML → 태그)** ✅
4. **프로덕션용 코드 정리 완료** ✅

---

## 상세 작업 내역

### 1. 디버그 로깅 추가 (커밋: 808b056, 38200ad)

**문제**: 보조 모델이 호출되지 않는 문제 발생

**해결**:
- `callAuxiliaryModel()` 함수에 상세 디버그 로그 추가
- `parseGoldChanges()`, `parseItems()` 등 파싱 함수에 로그 추가
- 호감도 파싱, RPG 파싱 섹션에 추적 로그 추가

**결과**:
- 보조 모델은 정상 작동 확인
- 태그 생성까지는 성공했으나 채팅에 표시되지 않는 문제 발견

---

### 2. HTML 스테이터스 패널 구현 (커밋: 7401cf1)

**구현 내용**:
- `buildStatusPanel()` 함수 생성 (104줄)
- 변경사항을 HTML로 포맷팅:
  - 레벨 & EXP 변화
  - 골드 변화 (색상 코딩)
  - 스탯 변화 (STR, INT, DEX, CHA, LUK, VIT)
  - 호감도 변화 (캐릭터 아이콘 포함)
  - 시간 & 위치 정보
- `setChat()`으로 마지막 메시지에 패널 추가

**문제점 발견**:
- HTML이 채팅에 그대로 출력되어 토큰 낭비
- LLM이 매 턴마다 HTML 코드를 읽게 됨

---

### 3. HTML → 태그 방식으로 전환 (커밋: e909809)

**사용자 피드백**:
> "기존 시스템에서는 `<Panel>■`을 정규식 치환을 통해 각종 캐릭터 호감도와 위치정보를 출력하게 되어있어. HTML 수정은 하지않고 태그만 출력하는 편이 좋을것 같아."

**변경 내용**:
- `buildStatusPanel()` 함수 제거 (118줄 삭제)
- 보조 모델이 생성한 태그를 그대로 채팅에 추가:
  ```lua
  local finalMessage = message .. "\n\n" .. auxiliaryMessage
  setChat(triggerId, -1, finalMessage)
  ```

**장점**:
- ✅ 최소 토큰 사용
- ✅ RisuAI 정규식 시스템 활용
- ✅ 간결한 코드 (3줄)
- ✅ 컨텍스트 오염 제거

**출력 예시**:
```
[Affinity:Clover:neutral][Gold:-500][Item:Add:만병통치약:1:피로회복][Time:오후][Location:스칼렛 스트리트]<Panel>■
```

---

### 4. 디버그 로그 제거 (커밋: 4dbaf99)

**작업 내용**:
- 모든 `print("[DEBUG] ...")` 제거 (33개)
- 중요 게임 이벤트 로그는 유지:
  - `💰 골드 +500 | 현재: 1500`
  - `🍀 Clover 호감도 +20 (love) | 현재: 20`
  - `✅ 턴 처리 완료`

**결과**:
- 깔끔한 콘솔 출력
- 프로덕션 준비 완료

---

## 기술적 세부사항

### 보조 모델 통합 구조

```
[메인 모델]
  ↓ 스토리 출력
[Lua onOutput]
  ↓ 호출
[보조 모델 (axLLM)]
  ↓ 태그 생성
[Lua 파싱]
  ↓ 변수 업데이트
[setChat]
  ↓ 태그 추가
[RisuAI 정규식]
  ↓ 표시
[사용자]
```

### 주요 함수

1. **callAuxiliaryModel(triggerId, mainResponse)**
   - 보조 모델 호출
   - 메시지 배열 형식 사용
   - 태그 문자열 반환

2. **parseGoldChanges(triggerId, message)**
   - `[Gold:±value]` 태그 파싱
   - 골드 변수 업데이트
   - 변경량 추적

3. **parseItems(triggerId, message)**
   - `[Item:Action:Name:Qty:Effect]` 태그 파싱
   - Add/Use/Remove 액션 처리

4. **호감도/죄악도 파싱**
   - `[Affinity:Name:level]` 파싱
   - `[Sin:Name:level]` 파싱
   - 캐릭터 매칭 및 변수 업데이트

---

## 테스트 결과

### 성공 사례

**입력**: 사용자가 NPC와 상호작용

**보조 모델 출력**:
```
[Affinity:Clover:neutral][Gold:-500][Item:Add:만병통치약:1:피로회복][Time:오후][Location:스칼렛 스트리트]<Panel>■
```

**파싱 결과**:
- ✅ Clover 호감도: 0 변화 (neutral)
- ✅ 골드: -500 (현재: 0)
- ✅ 아이템 추가: 만병통치약 x1
- ✅ 시간: 오후
- ✅ 위치: 스칼렛 스트리트

**채팅 출력**:
- ✅ 태그가 메시지 하단에 추가됨
- ✅ RisuAI 정규식이 처리하여 표시

---

## 남은 작업 (향후 개선 사항)

### 우선순위 높음
- [ ] 스탯 변경 파싱 테스트 (`[Stat:str:+5]`)
- [ ] EXP 및 레벨업 시스템 테스트
- [ ] Trait 시스템 테스트
- [ ] 리롤 시 스냅샷 복원 테스트

### 우선순위 중간
- [ ] 보조 모델 프롬프트 최적화
- [ ] 에러 핸들링 강화
- [ ] `/status` 명령어로 현재 상태 확인 기능 추가

### 우선순위 낮음
- [ ] 보조 모델 응답 캐싱 (동일 턴 재호출 방지)
- [ ] 성능 최적화
- [ ] 다국어 지원

---

## 파일 변경 내역

### 수정된 파일
- `belladonna_academy_rpg.lua`
  - 총 변경: +43줄, -161줄 (순 감소: 118줄)
  - 주요 함수: `callAuxiliaryModel()`, `parseGoldChanges()`, `parseItems()`, `onOutput()`

---

## 참고 코드

### 기존 시스템 (LightBoard)
```lua
-- LightBoard 패턴 참고
local result = processLLMResult(manifest, response)
local finalChat = lastChatNoNode .. "\n" .. result .. "\n"
setChat(triggerId, idx, finalChat)
```

### RisuAI 함수 사용법
```lua
-- axLLM 호출
local messages = {
    {
        content = promptText,
        role = "user"
    }
}
local response = axLLM(triggerId, messages)

-- setChat으로 메시지 수정
setChat(triggerId, -1, finalMessage)
```

---

## 알려진 이슈

없음 (현재 시스템 정상 작동)

---

### 5. 듀얼 패널 시스템 구현 (커밋: 0842fa8)

**사용자 요청**:
> "우선 추가된 시스템의 값들을 추적할수있는 html코드를 만들어줄래? ★이 기호값으로 정규식을 통해 디스플레이변환기능을 써서 창이 출력되도록 할거야."
> "잠시만 ■★ 동시에 출력하는거야"

**문제점 발견**:
- 초기에 `<Panel>■`을 모두 `<Panel>★`로 변경했으나, 사용자가 **두 마커 모두** 필요함을 명확히 함

**최종 구현**:
1. **보조 모델 마커 복원**: `<Panel>■` 유지 (캐릭터 호감도/죄악도 태그용)
2. **RPG 스테이터스 패널 추가**: `buildRpgStatsPanel()` 함수 생성
3. **HTML 템플릿 생성**: `rpg_status_panel.html` 파일 작성
4. **듀얼 출력 구현**:
   ```lua
   local rpgStatsPanel = buildRpgStatsPanel(triggerId)
   local finalMessage = message .. "\n\n" .. auxiliaryMessage .. "\n" .. rpgStatsPanel
   ```

**출력 형식**:
```
[메인 스토리]

[Affinity:Clover:neutral][Gold:-500][Item:Add:회복포션:1:hp+20]<Panel>■
<Panel>★
```

**HTML 템플릿 구조**:
- 레벨, 골드, 경험치 (진행 바 포함)
- 6가지 스탯 (STR, INT, DEX, CHA, LUK, VIT)
- 아이템 목록 (조건부 표시)
- 특성 목록 (조건부 표시)
- RisuAI 정규식이 `<Panel>★`를 HTML로 치환
- 템플릿 변수 (예: `{{player_level}}`)는 RisuAI가 자동으로 채움

**장점**:
- ✅ 캐릭터 시스템과 RPG 시스템 분리
- ✅ 각 시스템의 독립적인 표시 방식 유지
- ✅ RisuAI 정규식 시스템 활용
- ✅ 확장 가능한 구조

---

## 결론

보조 모델 통합이 성공적으로 완료되었습니다. 태그 기반 시스템으로 토큰 효율성을 확보하고, RisuAI의 기존 정규식 시스템과 완벽하게 통합되었습니다.

**듀얼 패널 시스템**:
- `<Panel>■`: 캐릭터 호감도/죄악도 태그 (기존 시스템)
- `<Panel>★`: RPG 스테이터스 HTML 패널 (신규 시스템)

**다음 세션 시작 시 확인 사항**:
1. 현재 브랜치: `claude/status-panel-refactor-011CULHEMzJabhP38ZzPyx98`
2. 최신 커밋: `0842fa8` (Implement dual panel system)
3. 테스트 상태: 듀얼 패널 출력 구조 구현 완료
4. 추가 작업 필요: RisuAI 정규식 설정, HTML 템플릿 테스트
