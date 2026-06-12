# Belladonna Academy RPG · Lua 함수 색인

`belladonna_academy_rpg_new.lua` (8561줄 / 97 함수) 작업 진입 시 첫 참조 문서.
새 작업 시작할 때 이 색인만 보고 정확한 함수/라인 잡으면 됨 — 큰 파일 통째로 안 읽어도 OK.

**API 컨벤션** (v1 → 작업 시 자주 헷갈리는 부분)
- 변수 저장: `setChatVar(triggerId, key, value)` + `setState(triggerId, key, value)` 더블 콜 패턴
- 변수 읽기: `getChatVar(triggerId, key)` (보통 `tostring`, 숫자면 `tonumber(... ) or 0`)
- 로그: `log(...)` (자체 정의 함수)
- 디버그 로그: `addDebugLog(category, message)` (50개 순환 버퍼)

---

## 메인 진입점 (자주 참조)

| 함수 | 라인 | 역할 |
|---|---|---|
| `onStart(triggerId)` | **L4725** | 챗 시작 시 — 초기화 한꺼번에 |
| `processOutput(triggerId)` | **L4985** | onOutput 메인 처리 (1084줄, 가장 큰 함수) |
| `onEndOfTurn(e)` | **L8359** | 턴 종료 후 — 스케줄 리셋 등 |
| `updateRpgDisplayVars(triggerId)` | **L851** | 모든 RPG 디스플레이 변수 갱신 — exp%, *_effective/bonus, items_html, hex_polygon. 파싱 사이클 마지막에 호출 (L5165 등) |
| `callAuxiliaryModel(triggerId, mainResponse)` | **L3512** | 보조모델 호출 → 태그 반환 |

---

## 시스템 그룹

### 1. Utility — L503–595

| 함수 | 라인 | 역할 |
|---|---|---|
| `clampValue(value, min, max)` | L507 | min/max 클램프 |
| `checkEnding(affinity)` | L513 | 호감도 → ending 분기 |
| `getRouteText(ending)` | L520 | ending → 한글 라벨 |
| `removeDuplicateTags(main, aux)` | L527 | 보조 응답에서 메인과 중복 태그 제거 |

### 2. Effects — 활성 효과 관리 — L596–820

`getActiveEffects` / `saveActiveEffects`로 직렬화-역직렬화. 모든 효과 변경은 `addEffect`/`removeEffect` 거치고 끝에 `saveActiveEffects` → `updateEffectsDisplay` 자동 호출.

| 함수 | 라인 | 역할 |
|---|---|---|
| `getActiveEffects(triggerId)` | L600 | 효과 리스트 파싱 (변수 → 테이블) |
| `saveActiveEffects(triggerId, effects)` | L630 | 직렬화 저장 + updateEffectsDisplay 트리거 |
| `updateEffectsDisplay(triggerId, effects)` | L661 | `active_effects_display` 변수 갱신 |
| `addEffect(...)` | L699 | 효과 추가 (같은 이름이면 덮어쓰기) |
| `removeEffect(triggerId, name)` | L730 | 효과 제거 |
| `updateEffectDurations(triggerId)` | L750 | 턴마다 duration −1, 만료 효과 제거 |
| `calculateEffectBonus(triggerId, statName)` | L780 | 특정 스탯 효과 합계 |
| `getStatWithEffects(triggerId, statName)` | L798 | 효과 적용된 실제 스탯 값 |

### 3. Display · Hex Radar — L820–913

| 함수 | 라인 | 역할 |
|---|---|---|
| `updateHexPolygon(triggerId)` | **L825** | 6스탯 → SVG polygon 좌표 문자열, `player_hex_polygon` 변수 저장 (오늘 추가) |
| `updateRpgDisplayVars(triggerId)` | **L851** | 진입점 — exp%, _effective, _bonus, combat_power_max, items_html, hex_polygon 한꺼번에 갱신 |

### 4. Affinity / Sin — L914–939

| 함수 | 라인 | 역할 |
|---|---|---|
| `updatePercent(triggerId, char)` | L918 | 캐릭터별 호감도·죄악도 → percent 변수 |

### 5. Parse · Stats / Gold / EXP / HP — L940–1100

기본 파싱 시리즈. 보조모델 출력 태그를 변수로 흡수.

| 함수 | 라인 | 태그 형식 |
|---|---|---|
| `parseStatChanges` | L944 | `[Stat:str:+5]` |
| `parseGoldChanges` | L997 | `[Gold:±value]` |
| `parseExpChanges` | L1015 | `[EXP:+N]` + 레벨업 체크 |
| `parseHeal` | L1053 | `[Heal:N]` |
| `parseDamage` | L1076 | `[Damage:N]` |

### 6. Market (시장 지수) — L1380–1433

| 함수 | 라인 | 역할 |
|---|---|---|
| `getMarketLevel(index)` | L1391 | 지수 → MARKET_LEVELS 레벨 매칭 |
| `initMarketIndex(triggerId)` | L1401 | 시장 지수 초기화 |
| `parseMarketIndex` | L1412 | `[Market:1050:+2.5:뉴스]` 파싱 |

### 7. Stock (주식 시스템) — L1434–1962

| 함수 | 라인 | 역할 |
|---|---|---|
| `initStockSystem(triggerId)` | L1438 | 주식 시스템 초기화 |
| `generateStockTicker(stockData)` | L1521 | 인라인 티커 HTML 생성 |
| `parseStockChanges` | L1552 | `[Stock:TICKER:price:+10\|market_share:+5]` |
| `parseBusinessTags` | L1641 | `<Business:TICKER:revenue:+200>` |
| `parseStockSystemEnable` | L1713 | `[StockSystem:Enable]` |
| `parseBusinessEnable` | L1725 | `[Business:Enable:TICKER]` |
| `parseClubChanges` | L1806 | `[Club:Join:stock]` |
| `parseStockTrades` | L1836 | `[StockBuy:T:P:Q]` / `[StockSell:T:P:Q]` |
| `parseStockChartUpdate` | L1925 | `<StockChart:TICKER:±N />` |

### 8. Stock History (주가 캔들) — L1962–2105

| 함수 | 라인 | 역할 |
|---|---|---|
| `initStockHistory(triggerId, ticker)` | L1963 | 12-캔들 기본 히스토리 생성 (20개 데이터) |
| `addPriceToHistory(triggerId, ticker, newPrice)` | L2051 | 가격 추가 (20개 유지) |
| `getStockHistory(triggerId, ticker)` | L2075 | 히스토리 조회 (부족하면 재생성) |

### 9. Level — L2107–2145

| 함수 | 라인 | 역할 |
|---|---|---|
| `checkLevelUp(triggerId)` | L2108 | EXP 누적 체크 → 레벨업 처리 |

### 10. Inventory (아이템) — L2146–2270

15-슬롯 기반. `player_item_slot_{1..15}_name/_count`.

| 함수 | 라인 | 역할 |
|---|---|---|
| `parseItemList(itemsStr)` | L2147 | 문자열 → 테이블 |
| `serializeItemList(items)` | L2161 | 테이블 → 문자열 |
| `updateItemSlotVars(triggerId)` | L2173 | 슬롯별 변수 갱신 (버튼 텍스트용) |
| `addItem(triggerId, name, qty, effect)` | L2206 | 아이템 추가 |
| `removeItem(triggerId, name, qty)` | L2227 | 아이템 제거 |
| `parseItems(triggerId, message)` | L2251 | `[Item:Add:이름:1:효과]` |

### 11. Traits (특성) — L2271–2479

| 함수 | 라인 | 역할 |
|---|---|---|
| `parseTraitIdList(traitsStr)` | L2272 | Trait ID 문자열 → 리스트 |
| `serializeTraitIdList(traitIds)` | L2283 | 리스트 → 문자열 |
| `addTrait(triggerId, name, desc)` | L2289 | 특성 추가 |
| `removeTrait(triggerId, traitId)` | L2321 | 특성 제거 |
| `updateTraitsDisplay(triggerId)` | L2353 | `player_traits_html` 변수 갱신 |
| `parseTrait(triggerId, traitTag)` | L2408 | 단일 특성 태그 |
| `parseTraits(triggerId, message)` | L2459 | 특성 태그 묶음 |
| `parseExams(triggerId, message)` | L2466 | `[Exam:...]` 태그 |

### 12. Effects (parse 태그) — L2480–2645

| 함수 | 라인 | 역할 |
|---|---|---|
| `parseEffects(triggerId, message)` | L2484 | 효과 태그 묶음 |
| `parseEffect(triggerId, tag)` | L2490 | 단일 `[Effect:Add:Name:StatBonus]` |

### 13. Combat (전투) — L2646–3370

가장 큰 시스템 중 하나. 전투력 계산 → 난이도 → 선택지 → 주사위 → 결과 처리.

| 함수 | 라인 | 역할 |
|---|---|---|
| `calculateCombatPower(triggerId)` | L2649 | 플레이어 전투력 계산 |
| `getDifficulty(statPower, enemyPower)` | L2661 | 비율 기반 난이도 판정 |
| `findCombatTrait(triggerId)` | L2682 | 전투 관련 특성 찾기 |
| `prepareCombatChoices(triggerId, enemyPower)` | L2742 | 전투 선택지 준비 |
| `getDifficultyTarget(difficulty)` | L2796 | 난이도 → 주사위 목표값 |
| `rollChoiceDice(...)` | L2812 | 선택지 주사위 (combat_active 독립) |
| `rollCombat(triggerId, choiceNum)` | L2864 | (legacy) 전투 주사위 |
| `rollCombatCheck(triggerId, statName, difficulty)` | L2887 | 주사위 + 체크 |
| `getCombatRewards(enemyPower)` | L2925 | 몬스터 파워 → 보상 |
| `processCombatResult(...)` | L2954 | 전투 결과 처리 |
| `adjustCombatDifficulty(triggerId, adjustment)` | L3103 | 유리/불리 난이도 조정 |
| `updateInjuryEffect(triggerId)` | L3148 | 부상 Effect 자동 업데이트 |
| `parseCombat(triggerId, tag)` | L3192 | Combat 태그 단일 |
| `parseCombats(triggerId, message)` | L3257 | Combat 태그 묶음 |
| `parseCombatChoice(triggerId, choiceBlock)` | L3264 | 선택지 → HTML 버튼 |
| `parseCombatChoices(triggerId, message)` | L3355 | 선택지 묶음 |

### 14. Auxiliary Model (보조모델) — L3372–3580

| 함수 | 라인 | 역할 |
|---|---|---|
| `buildAuxiliaryMessages(triggerId, mainResponse)` | L3376 | 보조모델용 4-메시지 구조 (system/user/prefill) |
| `callAuxiliaryModel(triggerId, mainResponse)` | L3512 | `axLLM` 호출 + 태그 반환 |

### 15. Snapshot (롤백/재생) — L3582–3795

리롤·재시도 시 상태 복원. 캐릭터별 스냅샷과 RPG 스냅샷 분리.

| 함수 | 라인 | 역할 |
|---|---|---|
| `takeSnapshot(triggerId, char)` | L3586 | 캐릭터별 스냅샷 |
| `restoreSnapshot(triggerId, char)` | L3603 | 캐릭터 복원 |
| `clearChanges(triggerId, char)` | L3628 | 캐릭터 변경량 초기화 |
| `takeRpgSnapshot(triggerId)` | L3638 | RPG 변수 스냅샷 (전체) |
| `restoreRpgSnapshot(triggerId)` | L3690 | RPG 변수 복원 |
| `clearRpgChanges(triggerId)` | L3787 | RPG 변경량 초기화 |
| `clearBusinessChanges(triggerId)` | L3797 | 경영/주식 변경량 초기화 |

### 16. Location · Schedule — L3893–4350

장소 매칭과 시간대·요일·주간 스케줄.

| 함수 | 라인 | 역할 |
|---|---|---|
| `matchLocation(currentLoc, targetLoc)` | L3894 | 유연 장소 매칭 |
| `getCurrentPeriod(triggerId)` | L4334 | 시간대 (오전/오후/저녁) |
| `checkScheduleMatch(triggerId)` | L4354 | 현재 스케줄 매칭 |
| `initScheduleVars(triggerId)` | L4428 | 스케줄 변수 초기화 |
| `getDayName(dayNum)` *local* | L4576 | 요일 번호 → 이름 |
| `getDayNumber(dayName)` *local* | L4582 | 요일 이름 → 번호 |

### 17. Status Window (상태창) — L4590–4720

| 함수 | 라인 | 역할 |
|---|---|---|
| `parseStatusWindow(triggerId, message)` | L4594 | `<Status>...</Status>` 블록 파싱 |

### 18. Main (메인 진입점) — L4721–6068

| 함수 | 라인 | 역할 |
|---|---|---|
| `onStart(triggerId)` | **L4725** | 챗 시작 초기화 |
| `processOutput(triggerId)` | **L4985** | onOutput 메인 처리 (가장 큰 함수, ~1084줄) |
| `progressTime(...)` *local* | L5703 | 시간 진행 |
| `convertWeeklyReport(content)` *local* | L5966 | 주간 리포트 변환 |

### 19. View · Business (경영 현황 UI) — L6069–6308

| 함수 | 라인 | 역할 |
|---|---|---|
| `generateBusinessView(triggerId)` | L6073 | 경영 현황 HTML 생성 |

### 20. Debug — L6310–6425

| 함수 | 라인 | 역할 |
|---|---|---|
| `addDebugLog(category, message)` | L6314 | 디버그 로그 추가 (50개 순환 버퍼) |
| `generateDebugPanel(triggerId)` | L6334 | 디버그 패널 UI |

### 21. View · Stock Panel — L6425–7068

주식 패널 종합 UI — 시세표 / 차트 / 자산 뷰.

| 함수 | 라인 | 역할 |
|---|---|---|
| `generateStockPanelUI(triggerId)` | L6429 | 주식 패널 진입 |
| `formatNumber(num)` | L6536 | 천 단위 콤마 |
| `generateStockBoardView(triggerId)` | L6546 | 시세표 뷰 |
| `generateCandleData(triggerId, ticker, currentPrice)` | L6657 | OHLC 캔들 데이터 (히스토리 기반) |
| `generateStockChartView(triggerId, ticker)` | L6727 | 차트 뷰 (증권사 스타일 라인) |
| `generateStockAssetView(triggerId)` | L7071 | 내 자산 뷰 |

### 22. End-of-Turn — L8358–8561

| 함수 | 라인 | 역할 |
|---|---|---|
| `onEndOfTurn(e)` | **L8359** | AI 턴 종료 후 처리 (스케줄 선택값 초기화 등) |

---

## 작업 패턴 (클로드와 협업 시)

1. **이 색인부터 본다.** 큰 파일 통째로 안 읽음
2. **함수 라인이 정확하니** `Read offset/limit`로 정확한 부분만
3. **편집은 `Edit`로** unique한 컨텍스트 잡고 정밀 변경
4. **새 함수 추가 시 그룹 맞게** — 색인 분류 따라서. 같은 그룹 옆에 두면 추후 찾기 쉬움
5. **추가/변경 후 이 색인도 같이 업데이트** — 라인 번호 바뀜 (Edit 후 그룹 섹션만 부분 갱신)

## 빠진 / 추가 정보 후보 (필요할 때 채움)

- 각 함수의 *Reads / Writes 변수* (현재는 핵심 진입점만)
- 함수 *의존성 그래프* (누가 누구를 부르나)
- `local function` 외 `local 변수 = function` 형식 (현재 grep으로 안 잡힘)
- 상수/데이터 테이블 위치 (MARKET_LEVELS, CHARACTERS 등)
- 정규식모음 파일과의 연결 지점

깊이 들어갈 작업이 생기면 그때 해당 섹션에 추가.
