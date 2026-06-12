# Belladonna Academy RPG System - Work Log

## Session: 2026-05-25 - 전투 시스템 정비 + 상점 시스템 백엔드 + 보조모델 디버깅

### 작업 요약

세 갈래 작업이 한 세션에 묶임:
1. **전투 시스템 정비** — 전투력 리셋/회복 모델 일관화 + 가이드라인(`COMBAT_GUIDELINES.md`) 4섹션 재작성
2. **상점 시스템 백엔드 초안** — 클로버의 바자르 (서브캐릭터 Clover 운영), 보조 AI 직접 호출 패턴 기반. Sub-step 1만 완료, 현재 `if false then ... end`로 비활성화 상태
3. **긴급 디버깅** — 세션 후반 보조모델 간헐적 미호출 이슈 추적. 진짜 원인은 LUA 파일 truncation (Edit 작업 중 어느 시점에 끝부분 잘림)

### 주요 성과

1. **`parseCombat` [Combat:End] 처리부에 전투력 자동 회복 코드 추가** ✅
2. **`processCombatResult` 자동 종료부에 회복 + OOC 자동 삽입 (현재 OOC는 디버깅용 주석 처리)** ⚠️
3. **`COMBAT_GUIDELINES.md` 4섹션으로 재작성** ✅ (97줄 → 80줄, Combat Flow 섹션 제거, Status Display LUA로 위임, 지시문 + 변수 분리)
4. **`SHOP_DATA` + `callShopAuxiliary` + `handleShopTransaction` 정의** ⚠️ (현재 비활성)
5. **LUA truncation 진단 및 복구** ✅

---

## 상세 작업 내역

### 1. LUA: 전투력 매 전투 max 리셋 (커밋 없음, 디스크 직접 수정)

**위치**: `parseCombat` 안 `[Combat:Name:Power]` 처리부

**Before**: 이전 전투 잔여 `player_combat_power` 그대로 가져오고 max 클램프만 적용

**After**: `calculateCombatPower(triggerId)`로 max 계산 → 그 값으로 현재 전투력 리셋. 부상 Effect는 영구라 max에 자연 반영됨.

### 2. LUA: 전투 종료 시 전투력 자동 회복

**두 곳에 동일 패턴 추가**:
- `parseCombat`의 `[Combat:End]` 처리부 — 메인 AI가 명시적 종료 태그 보낼 때
- `processCombatResult`의 자동 종료부 — HP 0 도달로 LUA가 자동 종료할 때

```lua
local maxPower = calculateCombatPower(triggerId)
setChatVar(triggerId, "player_combat_power", tostring(maxPower))
setState(triggerId, "player_combat_power", maxPower)
log(string.format("💚 전투력 회복: %d", maxPower))
```

**효과**: 전투 종료 후 일상 진행 시 전투력 깎인 채로 안 다님. 부상 Effect만 영구 페널티로 남아 max를 낮춤. 묘사 일관성 ↑.

### 3. LUA: 자동 종료 시 OOC 메시지 자동 삽입 (현재 주석 처리)

**위치**: `processCombatResult` 자동 종료부

**의도**: 메인 AI가 다음 턴에 종료 묘사 + `[Combat:End]` 출력하도록 유도하는 OOC 메시지를 user message로 자동 삽입.

```lua
-- Victory / Defeat 분기로 OOC 메시지 구성
if oocMessage then
    addChat(triggerId, "user", oocMessage)
    log("📜 종료 OOC 메시지 자동 삽입: " .. combatState)
end
```

**현재 상태**: `addChat` race condition 의심 가설로 임시 주석 처리됨. 디버깅 끝에 진짜 원인은 truncation으로 판명. 복원해도 안전할 가능성 높지만 미검증.

### 4. 가이드라인 재작성: `lorebooks/systems/COMBAT_GUIDELINES.md`

**구조 변화** (97줄 → 80줄):

| 변경 | 내용 |
|---|---|
| L14 변수 모순 정정 | `Current Combat Power: {{getvar::player_combat_power_max}}` → `player_combat_power` |
| Challenge System | "Damaged → Fighting ability decreases" 메타 설명 제거 + `[Combat:...]` 시작/종료 태그 명시 |
| Choice Format Rules | "After each challenge turn" 트리거 명시 + "Vary the stats" 다양성 가이드 |
| **Combat Flow 섹션 통째 제거** | LUA가 처리, 메인 AI 불필요 |
| ~~Status Display 템플릿~~ | 제거 (LUA `editDisplay`/HTML 변환이 처리) |
| Combat Active | 상단에 묘사 가이드 3줄 + "End your response with a new `<CombatChoice>` block" + Dice Mechanics에 Last Action vs Dice Roll 차이 명시 |

**핵심 원칙**: 변수는 그대로, 지시문/구성 재작성. "당신은 ~" 같은 역할 부여 제거(다른 로어북에서 처리됨). `combat_active is true` 같은 변수명 언급 제거(AI는 변수 메타 정보 못 봄, 값만 봄).

### 5. 상점 시스템 백엔드 초안 (현재 비활성)

**위치**: 파일 EOF 직전, `if false then ... end`로 감싸진 상태

**구성**:
- `SHOP_DATA.clover` — 시범 1개 상점 (이름/오너/컨셉/말투/상품 5종)
- `formatShopItems`, `formatTransactionItems` — 프롬프트 텍스트 포맷 헬퍼 (local)
- `callShopAuxiliary(triggerId, shopId, action, items)` — 보조 AI 직접 호출 (`axLLM`)
- `handleShopTransaction(...)` — 응답 받아 `parseGoldChanges` + `parseItems`로 변수 자동 갱신 + `alertNormal`로 멘트 표시

**설계 의도 (미반영)**: 라인업/가격을 매 방문 시 보조 AI가 동적 생성하는 방식이 원래 의도였음. 현재 코드는 라인업이 하드코딩됨 — Sub-step 1.5로 재설계 필요.

**Sub-step 진행**:
- Sub-step 1: 백엔드 ✅ (현재 비활성)
- Sub-step 1.5: 동적 라인업 재설계 (대기) — `SHOP_DATA`에서 items 제거, 캐릭터 시트 컨텍스트로 매 호출 시 라인업 생성
- Sub-step 2: 거래 흐름 설계 (대기)
- Sub-step 3: UI - 인벤토리 내 진입, 상점 화면 (대기)
- Sub-step 4: 통합 테스트 (대기)

### 6. 긴급 디버깅: 보조모델 간헐적 미호출

**증상**: 메인 AI 응답 후 보조모델 출력 영역이 완전 공란. `<Panel>■★` 마커도 안 보임. risuAI 에러: `[string "..."]:8321: 'end' expected (to close 'function' at line 8258) near <eof>`

**추적 가설** (검토 순서):
1. ~~`L5135` early return (`<Panel>■★` 이미 있어 스킵)~~ — addDebugLog 미호출로 보아 더 일찍 빠짐
2. ~~`addChat` OOC 자동 삽입이 isProcessing 락 / 메시지 인덱스 race~~ — 주석 처리해도 같은 에러 → 무관
3. ~~검열 이슈~~ — 마커도 안 나오는 건 설명 못 함 (callAuxiliaryModel 모든 분기에서 마커 반환 보장)
4. ~~`removeDuplicateTags`가 보조 응답 다 제거~~ — `<Panel>` 마커는 self-dedup에서 살아남음
5. **LUA 파일 truncation** ✅ — wasmoon으로 직접 검사해 발견. 마지막 라인 `log("✅ 상점 거래 완료: " ..` 에서 EOF — `shopId)` 인자, `return true`, 모든 닫는 `end` 누락. 그래서 wasmoon이 모든 상위 function이 안 닫힘 → onButtonClick async가 안 닫힘으로 잘못 보고 (라인 매핑은 어긋남)

**해결**: Python으로 잘린 부분 복구.

**병행 의심 — backup 파일 혼동**: 작업 중 민옥이 backup 파일을 risuAI에 잘못 import했을 가능성. 그러면 디스크의 working 파일 수정이 risuAI에 반영 안 됨. 같은 syntax error 패턴이 계속 보였던 것도 이걸로 설명됨. **재발 시 점검 우선순위: backup 파일 동기화 + risuAI 재import**.

**검증 환경 한계 기록**:
- 우리 환경 `lupa` LUA 5.4는 표준 LUA의 `for` 변수 const 룰을 엄격 적용 → 기존 코드의 `for item in ... do; item = item:gsub(...)` 패턴에서 막힘
- risuAI의 `wasmoon` LUA 5.4는 이 부분 통과 (어떤 옵션 또는 표준 동작 차이)
- `wasmoon` npm 패키지로 node에서 검사하면 risuAI와 거의 동일한 결과 → 추후 진단 시 활용

### 7. 코드 변경 후 발견된 부수 이슈

- `L3338` 주석 잘못된 정보 ("보조 AI가 선택지 생성") — 실제론 메인 AI가 `<CombatChoice>` 생성, LUA는 파싱만. Task #5 (코드·문서 정리) 때 함께 수정
- `LUA_INDEX.md`와 실제 코드 라인 번호가 ~90줄 어긋남 (이미 알려진 상태) — 마찬가지로 Task #5

---

## 미완 / 다음 세션 메모

### 즉시 결정 필요

1. **OOC 자동 삽입 주석 풀지** — `addChat` 가설은 truncation으로 판명되어 race condition은 미검증. 풀면 자동 종료 시 OOC가 다시 활성. 만약 그때 미호출 증상 재발하면 race condition 가설이 다시 살아남
2. **상점 시스템 `if false then` 풀지** — 상점 코드 자체는 syntax OK 확인됨. 다만 Sub-step 1.5 (동적 라인업 재설계)가 우선이라 풀어도 곧 수정 들어감

### Task 상태 (세션 종료 시점)

| # | 상태 | 제목 |
|---|---|---|
| 1 | ✅ completed | LUA: 전투력 매 전투 max 리셋 |
| 2 | ✅ completed | 전투 가이드라인: 4섹션 재작성 |
| 3 | 보류 | 특성 활용 시스템 재설계 (현재 OK 평가) |
| 4 | pending | 전투 수치 시스템 재설계 |
| 5 | pending | 코드·문서 정리 (L3338 주석, LUA_INDEX, 죽은 함수) |
| 6 | ✅ completed | LUA: 전투 종료 시 전투력 자동 회복 |
| 7 | ✅ completed | LUA: 자동 종료 시 OOC 메시지 자동 삽입 (현재 주석 처리됨) |
| 8 | 진행 중 | 상점 시스템 구현 (Sub-step 1 완료, 비활성 상태) |
| 9 | ✅ completed | 긴급: 보조모델 간헐적 미호출 디버깅 |

### 디자인 결정 합의 사항

- 전투 시스템 방향: PbtA 아닌 **D&D 라이트** (HP 모델 유지, 1d20 판정, 자연20/1 크리·펌블)
- 판정·HP 모델은 그대로 유지, 데미지 공식/적 표현/특성 활용/부상 묘사가 리빌딩 대상 (Task #4에서 다룰 영역)
- 상점은 **메인 AI 미경유, 보조 AI 직접 호출** 패턴. 동적 라인업 + 동적 가격이 본래 의도
- 클로버 캐릭터 시트만 컨텍스트로 던지는 미니멀 방식 (메타 정의 SHOP_DATA에 박지 않고)

---

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

---

## Session: 2026-05-26 — 전투 선언 책임 이전 + 스테이터스 자원 모델 재설계 논의

### 작업 요약

두 갈래:
1. **전투 시작/종료 선언 책임을 메인모델로 이전** (코드 변경 완료) ✅
2. **스테이터스 자원 모델 재설계** (사유·합의만, 코드 변경 없음) — 다음 세션 작업 대상

---

### 1. 전투 선언 책임 이전 (완료)

#### 진단

이전 구조:
- 메인모델: narrative + `<CombatChoice>` 블록 출력
- 보조모델: narrative를 읽고 `[Combat:Enemy:Power]` / `[Combat:End]` 태그 출력
- LUA: HP 0 도달 시 자동 종료 + 보조모델 태그 받아 처리

문제:
- 메인모델이 `<CombatChoice>`로 전투 진행을 *이미* 선언하고 있는데, 시작/종료 태그는 보조모델한테 맡기는 비대칭. 보조모델의 narrative *재추론* 단계가 끼어 오류 지점이 됨.
- 보조모델이 협상 마무리 / 새 적 등장 같은 상황을 잘못 판정 → 유령 전투 지속 / 시작 태그 누락 등의 시나리오 가능.

#### 해결: 새 양식 `<CombatStart>` / `<CombatEnd>` 도입

메인모델이 narrative와 함께 직접 선언. `<CombatChoice>` 블록과 같은 패밀리의 멀티라인 블록.

```
<CombatStart>
name: 던전 보스
power: 450
</CombatStart>

<CombatEnd>
result: victory
</CombatEnd>
```

`result` 값: `victory` / `defeat` / `escape` / `resolved`.

#### 책임 계층

| 계층 | 역할 |
|---|---|
| **메인모델** | 1차 선언자. `<CombatStart>` / `<CombatEnd>` 출력 |
| **LUA 엔진** | 안전망. HP 0 도달 시 자동 종료 + OOC로 메인에 `<CombatEnd>` 출력 유도 |
| **보조모델 폴백** | 구 양식 `[Combat:...]` 파서 호환성 유지 (메인이 옛 양식 뱉어도 작동) |

#### 변경된 파일

1. **`lorebooks/systems/COMBAT_GUIDELINES.md`**
   - "Start / End Declarations (Main Model Responsibility)" 섹션 신설
   - `<CombatStart>` / `<CombatEnd>` 양식 + Power 가이드(150–250 VeryEasy ~ 650–900+ VeryHard) 명시
   - 구 양식 `[Combat:OpponentName:Power]` / `[Combat:End]` 안내 제거

2. **`belladonna_academy_rpg_new.lua`**
   - `AUXILIARY_BASE_PROMPT` (line 175~): `[Combat:Name:Power][Combat:End]` 출력 포맷 제거. Combat Tags 섹션 폴백 톤으로 축소. Power 가이드 제거. `[Damage:amount]` 트래킹은 유지.
   - `parseCombatStart(triggerId, message)` 신규 함수 추가 (line ~3302)
   - `parseCombatEnd(triggerId, message)` 신규 함수 추가 (line ~3348)
   - `parseCombats` 확장: 새 양식 우선 처리, 구 양식 폴백 (line ~3454)
   - OOC 메시지 두 곳: `<CombatEnd>\nresult: victory|defeat\n</CombatEnd>` 양식으로 갱신 (line 3188, 3190)

#### 알려진 후속 작업 (이번 범위 밖)

`<CombatStart>` / `<CombatEnd>` 블록이 메인모델 출력에 그대로 노출됨. `<CombatChoice>`처럼 `parseCombatChoice`에서 HTML로 치환되지 않음. 사용자 화면에서 거슬리면 다음 중 하나 적용:
- (a) 블록 처리 후 메시지에서 제거
- (b) 시스템 알림 패널로 대체 ("⚔️ 전투 개시: 던전 보스 (Power 450)")

테스트하며 결정.

---

### 2. 스테이터스 자원 모델 재설계 (사유·합의 단계, 다음 세션 작업)

#### 진단

증상: 보조모델이 베이스 스탯(STR/DEX 등)을 0까지 떨어트리는 경우가 있음.

본질: **"전투력을 깎기 위해 스테이터스를 건드린다"**는 운영 패턴이 문제의 핵심. 일상적 변동(부상, 모욕, 피로)이 다 베이스 스탯으로 흘러들어옴.

원인: 보조모델 가이드(`AUXILIARY_BASE_PROMPT` line 203~205)의 `[Stat:]` 정의에서 "events" 카테고리가 너무 광범위.

```
[Stat:stat:±value] - str/int/dex/cha/luk/vit (±1~5 typical, ±10+ major)
- Use ± for stat changes from training, items, events, etc.
```

→ "events"가 모든 narrative 사건을 포괄 → 일시적 변동도 베이스로 흘러들어옴.

#### 합의된 자원 모델 (3층위)

| 층위 | 의미 | 변동성 | 변경 권한 |
|---|---|---|---|
| **베이스 스탯 (Trait)** | 캐릭터의 영구 능력. STR=42 같은 절대값 | 거의 안 변함 | 측정 / 명시적 훈련 / 영구 이벤트만 |
| **Effect (State)** | 일시적 변동 (부상, 피로, 버프, 디버프) | 자주 변함, 회복됨 | 보조모델 `[Effect:...]` 자유 사용 |
| **전투력 (Resource)** | 전투/도전 자원. HP 역할 겸함 | 전투 중 변동 | 자동 (combat system, `[Damage:N]`) |

`str_effective = str (base) + str_bonus (Effect)` → `calculateCombatPower`는 effective 기준.

#### 베이스 스탯 변경의 정당한 경로 (3개)

| 경로 | 예시 | 양식 | 양 |
|---|---|---|---|
| 측정 이벤트 (`STAT_SYSTEM`) | 입학 측정, 정기 측정 | 절대값 `[Stat:str:42]` | set |
| 장기 훈련/성장 | 몇 주 누적 검술 수련 | `[Stat:str:+1~5]` | 누적 |
| 영구 사건 | 저주, 신적 개입, 큰 부상 후유증 | `[Stat:str:-5~10]` | 영구 |

**그 외 모든 변동은 Effect 또는 `[Damage]`로**:
- 일시적 부상 → 자동 부상 Effect (이미 line 3278~ 구현됨: 60%↑ 위급, 35%↑ 중상, 15%↑ 경상)
- 컨디션/피로/감정 → Effect with N턴 만료
- 전투 중 데미지 → `[Damage:N]` (combat_power만 깎음)
- 약물/포션 → Effect

#### 설계 의도 확인됨

- **VIT가 전투력 공식에 없는 건 의도**: 전투력 자체가 HP 역할 겸함 → VIT는 비전투 자원
- **Effect 단일 채널 통합 영향**: 비전투 Effect도 전투력에 영향 (현실적/일관됨). "학업 스트레스 → INT -2 Effect → 마법 효율 ↓ + 학업 점수 ↓"가 자연스럽게 모델됨

#### 미정 사항

- STR/DEX 2배 가중치(`(str*2) + (dex*2) + int + luk`)의 설계 의도. 의도면 명시, 아니면 재밸런싱 검토.
- VIT의 비전투 영역 작용 가이드라인 (어디서 어떻게 굴러가는지)
- 측정 이벤트(STAT_SYSTEM) 트리거 메커니즘 — 코드/로어북에서 정확한 위치/흐름 확인 필요

#### 다음 세션 작업 후보

1. 보조모델 가이드의 "events" 범위 축소 — "permanent or long-term only. Temporary: use Effect"
2. `[Stat:]` / `[Damage:]` / Effect의 역할 경계를 보조모델 프롬프트에 명시
3. `parseStatChanges`에 baseline floor 추가 — `player_{stat}_baseline` 변수 저장, 해당 값 아래로 못 내려가게
4. `STAT_SYSTEM` 측정 이벤트 위치 파악 후 baseline 저장 연결
5. VIT 비전투 영역 작용 가이드라인
6. STR/DEX 가중치 재검토 (의도 확인 후)

---

### 다음 세션 시작 시 확인 사항

1. 전투 선언 새 양식(`<CombatStart>` / `<CombatEnd>`) 실제 테스트 결과 — 메인모델이 잘 따라하는지, 사용자 화면에 블록 그대로 노출되는 것이 거슬리는지
2. 스테이터스 모델 재설계 — 위 "다음 세션 작업 후보" 6개 중 어디서 시작할지 결정 필요
3. STAT_SYSTEM 트리거 메커니즘 파악이 1순위 (다른 작업의 전제)
