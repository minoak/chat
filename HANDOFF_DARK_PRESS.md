# Dark Press 톤 적용 · 인수인계 문서

> Cowork → Claude Code 인수인계. 큰 lua 함수 교체 작업이 Cowork Edit의 잘림 위험에 취약해 환경을 옮김.

---

## 작업 목표

벨라도나 아카데미 RisuAI 챗봇의 **주식+경영 패널 5개 함수**(L6499~L7341)를 **V2 Dark Press** 디자인 톤으로 재스타일.

- 기존: GitHub Dark (#0d1117/#58a6ff/#d29922)
- 신규: V2 Dark Press = FT/WSJ 다크 신문 톤 (ink black + 살몬 + 골드)
- 챗봇 내 다른 패널들(호감도/스텟창/퍼스트메시지/주간보고서/미래시/선택지/시스템메시지)은 이미 별도 **Tarot v3 톤**으로 통일됨. 주식 패널은 의도적으로 다른 톤 (증권/신문 분위기).

---

## 파일 위치

| 역할 | 경로 |
|---|---|
| 메인 lua | `belladonna_academy_rpg_new.lua` |
| 디자인 스펙 시트 | `app-press.jsx` (StyleSpec + PressApp) |
| **디자인 본체** | `variation-press.jsx` (PressShell + PressBoard/Chart/Asset/Business) ← **핵심 참조** |
| 추출본 (lua 원본 5개 함수) | `주식경영_패널_스타일_초안용.md` |
| RisuAI HTML 셸 | `Dark Press Style Draft.html` |

---

## 진행 상황 (5단계)

| # | 함수 (lua) | 컴포넌트 (jsx) | 라인 | 상태 |
|---|---|---|---|---|
| 1 | `generateStockPanelUI` | `PressShell` | L6499~6613 | ✅ **완료** |
| 2 | `generateStockBoardView` | `PressBoard` | L6616~6794 | ⏳ 대기 |
| 3 | `generateStockChartView` | `PressChart` | L6797~7138 | ⏳ 대기 |
| 4 | `generateStockAssetView` | `PressAsset` | L7141~7341 | ⏳ 대기 |
| 5 | `generateBusinessView` | `PressBusiness` | L6143~6373 | ⏳ 대기 |

⚠️ 라인 번호는 PressShell 변환 후 기준 — 변환 진행하며 약간씩 밀림. `grep -n "^function generateStockBoardView"` 등으로 재확인 필수.

---

## V2 Dark Press 디자인 토큰 (변하지 않는 진실)

### Colors
| 토큰 | 값 | 용도 |
|---|---|---|
| `bg` | `#161210` | ink black 메인 배경 |
| `panel` | `#1b1612` | 패널 (탭 헤더/푸터) |
| `card` | `#221b16` | 카드 |
| `cardHi` | `#2b2219` | 강조 카드 |
| `text` | `#ddc8a7` | 본문 (warm sand) |
| `textHi` | `#f5e9d2` | 강조 본문 |
| `textDim` | `#9a8a72` | 메타데이터 |
| `textMute` | `#6e604c` | placeholder |
| `salmon` | `#e8a679` | FT 시그니처 액센트 |
| `salmonHi` | `#f4b88e` | 호버 |
| `ivory` | `#f0e3cc` | 마스트헤드/제목 |
| `gold` | `#d4af6a` | 골드 (보유/현금) |
| `up` | `#d94c47` | **warm red** (한국식 상승 ↑) |
| `down` | `#5e7a99` | **ink blue** (한국식 하락 ↓) |
| `flat` | `#9a8a72` | 변화 없음 |
| `rule` | `rgba(240,227,204,0.16)` | 헤어라인 |
| `ruleSoft` | `rgba(240,227,204,0.08)` | 약한 헤어라인 |
| `ruleHeavy` | `rgba(240,227,204,0.30)` | 더블 룰 (마스트헤드) |

### Typography
- 본문: `'Noto Serif KR', Georgia, 'Times New Roman', serif`
- 모노 (키커/숫자): `'JetBrains Mono', 'IBM Plex Mono', Menlo, monospace`
- 마스트헤드: italic 600 36px ivory
- 헤드라인: italic 600 ivory 24px
- 본문: 13px 1.65 serif
- 라벨: 10.5px small-caps letter-spacing 0.32em salmon
- 키커: 9px mono letter-spacing 0.34em uppercase salmon
- 숫자: serif tabular-nums

### 기호 컨벤션
- 상승: `▲` warm red
- 하락: `▼` ink blue
- 변화 없음: `—` flat
- 구분: `◇` / `◆` / `⁕` (장식)

---

## RisuAI 기술 제약 (반드시 준수)

1. **들여쓰기 0**: HTML 줄 앞 leading whitespace 금지 (4칸 이상이면 마크다운 코드블록으로 잘못 처리됨). `<style>` 안 CSS는 OK.
2. **`%%` 이스케이프**: `string.format([[ ... ]])` 안의 `%` 문자(`100%`, `calc(100% - 16px)`, `border-radius:50%` 등)는 반드시 `%%`로 이스케이프. 아니면 lua format 오류.
3. **트리거 보존 필수**:
   - `risu-btn="xxx"` 클릭 시 lua의 `_G["xxx"]` 호출
   - 이름 바꾸면 동작 안 함
4. **인라인 스타일만**: `<style>` 태그/외부 stylesheet 사용 불가. 모든 `style="..."` 속성으로.
5. **변수 페치**: `getChatVar` / `getState` / `STOCK_BASE_PRICES` / `STOCK_NAMES` 등 lua 로직은 보존.
6. **연속 빈 줄 금지**: 마크다운 paragraph break 회피.

---

## 각 함수의 보존 요소 (절대 손대지 말 것)

### `generateStockBoardView` (L6616~6794) — PressBoard
- 종목 리스트 루프 (STOCK_NAMES / HOLDINGS 데이터 매핑)
- 매수/매도 트리거: `risu-btn="stock_buy_<TICKER>"` / `stock_sell_<TICKER>"`
- 필터/정렬 상태 변수가 있다면 보존
- `formatNumber()` 호출

### `generateStockChartView` (L6797~7138) — PressChart
- 차트 SVG 데이터 (히스토리 가져와서 path 계산)
- 종목 정보 텍스트
- 매수/매도/종목 전환 트리거 (`stock_buy_<TICKER>` 등 + 종목 선택 `stock_select_<TICKER>`)
- 캔들/라인 데이터 변수

### `generateStockAssetView` (L7141~7341) — PressAsset
- 시장 지수 변수 (`market_index`, `market_index_change` 등)
- 보유 종목 루프
- 손익 계산 로직
- 거래 내역 (있다면)

### `generateBusinessView` (L6143~6373) — PressBusiness
- 회사 리스트 분기 (`mirabel_company_joined` / `cordelia_company_joined` / `nepenthes_company_joined`)
- 각 회사 변수 (`<ticker>_revenue` / `_profit` / `_cash` / `_debt` / `_market_share` / `_brand_value` / `_employees` / `_rd_progress` / `_player_share` / `_influence` + 모든 `_change` 변수)
- `formatChange(change, isPercent)` 함수 (Tarot로 변경한 적 있음 — Press 톤에 맞게 ▲▼ + warm red/ink blue로 다시)
- `stockEnabled` 분기 (주가 카드 포함 여부)
- 빈 상태 ("경영 중인 회사 없음") 분기

---

## 디자인 매핑 (jsx → lua)

### PressBoard
```
Lead story (drop cap 인용구 " + Markets Desk byline)
↓
Secondary briefs 2개 (1px hairline + ticker + brief text)
↓
DoubleRule
↓
"The Quotations Page" 라벨 + "Closing values, in gold" italic
↓
4-col table header (Issue / Close / Change / Held) — small-caps
↓
종목 행 루프 (점선 디바이더):
  좌측 (Issue): 종목명 italic ivory + ticker · sector mono
  Close: ivory tabular-nums
  Change: ▲/▼ + warm red/ink blue + tabular-nums
  Held: gold (qty>0) or em-dash italic textMute
```
→ **데이터**: NEWS, TICKERS, HOLDINGS 매핑. lua에선 `STOCK_NAMES[ticker]`, `getState(triggerId, "stock_"..ticker.."_price")`, `getState(triggerId, "stock_"..ticker.."_change")`, 보유는 `getChatVar(triggerId, "stock_"..ticker.."_owned")`.
→ **뉴스(NEWS)**: 챗봇 변수에 없으면 일단 정적/생략. 또는 보조 AI 출력 태그로 별도 분리. 현재 lua엔 없을 가능성 — **신중히 처리** (없으면 lead story 섹션 생략 또는 정적 placeholder).

### PressChart
```
"The Featured Issue" 라벨
↓
Issue header (좌: ticker mono + 종목명 italic ivory / 우: 가격 + ▲ +change · +pct)
↓
DoubleRule
↓
Chart panel (card 배경):
  좌측 Y축 라벨 (max/mid/min)
  SVG: 해치 fill 45° salmon@0.12 + 라인 (up/down 컬러) + end dot
  하단 시간 라벨 (09:00 12:00 15:00 close) italic textMute
↓
OHLC strip (시가/고가/저가/기준) small-caps + tabular-nums
↓
"The Issuer · An Editor's Note" 라벨
↓
Dossier (드롭캡 "제" salmon italic + 본문 serif)
↓
Tag strip (부문/규모/재무/변동성) small-caps + ivory
↓
▲ Up notes (warm red italic) / ▼ Down notes (ink blue italic)
↓
Insider quote (cardHi + 좌측 골드 2px + italic) — "Insider sources name {name} as the issue's principal voice."
↓
"Other Issues" 라벨 + 종목 선택기 (선택된 종목 cardHi + salmon 보더)
```
→ **데이터**: 현재 ticker의 history (`stock_<ticker>_history` 또는 함수로 생성). 종목별 설명/insider 등 별도 변수 또는 정적 매핑 테이블.

### PressAsset
```
"The Lilybelly Index" 라벨
↓
Index card (card 배경 + 보더): 좌측 "LBLY · COMPOSITE" mono salmon + 큰 숫자 ivory · 우측 ▲ +change% + "compared with prior session"
↓
DoubleRule
↓
Net worth banner (중앙 정렬):
  "The reader's estate, valued" italic small-caps textDim
  48px ivory 숫자 + salmon italic "G"
  2칸 (총 손익 / 수익률) — small-caps + warm red 큰 숫자
↓
DoubleRule
↓
"Composition" 라벨
↓
2 columns (현금/주식) — top 2px border color + 22px ivory 숫자 + italic % of estate
↓
"Holdings · N issues on the books" 라벨
↓
보유 종목 테이블 (점선 디바이더):
  좌측: 종목명 italic ivory + "{ticker} · {qty}주 held at avg {avg} G" italic textDim
  우측: {value} G ivory + ▲/▼ {profit} · {pct}%
```
→ **데이터**: `player_gold`, 각 종목 보유 (`stock_<ticker>_owned`, `stock_<ticker>_avg_price`), 시장지수 (`market_index_value`, `market_index_change`).

### PressBusiness
```
"The Reader's Ventures · N Concerns" 라벨
↓
회사 루프 (회사 간 더블 룰 구분):
  Headline (중앙):
    ticker · SECTOR (mono salmon)
    회사명 italic ivory 24px
    "in partnership with {character}" italic textDim · {character} 골드
  ↓ Rule
  "Financial standing · in millions" kicker salmon
  2x2 grid (매출/순이익 N%/현금/부채 N%): 라벨 small-caps + 큰 숫자 색칠 (수익 warm red 또는 다른 색) + Delta ▲▼ 색상
  ↓
  "Market position" kicker salmon
  2x2 grid (시장점유율/브랜드가치/주가/직원): 위와 동일
  ↓
  "Ownership · the reader holds N%" kicker salmon
  진척바 (1px rule frame, 골드 fill + 해치 잔여 영역)
  하단 italic: "독자 지분 N%" / "R&D 진척 N%"
```
→ **데이터**: lua 변수 전부 그대로 사용. `Delta` 컴포넌트는 lua에서 `formatChange()`로 (Press 톤에 맞게 ▲/▼ + warm red/ink blue + 단위 표시).

---

## 작업 순서 추천

1. **`grep -n "^function generateStockBoardView"` 으로 정확한 시작 라인 확인**
2. **함수 끝 라인 찾기** (`function ` 또는 `^end$` 추적)
3. **현재 함수 본문 통째 추출** → 보존할 lua 로직 식별 (변수 페치, 분기, 트리거)
4. **PressBoard jsx 마크업** + **추출한 lua 변수**를 매핑해 새 함수 본문 작성
5. **Edit으로 교체**
6. **검증**:
   - 옛 색깔 토큰(`#0d1117`, `#58a6ff`, `#d29922`, `#fff`) 잔여 0 (해당 함수 내)
   - Press 토큰(`#161210`, `#e8a679`, `#d4af6a`) 적용
   - 트리거 보존
   - `string.format` 인자 개수 = `%s/%d` 개수, 단일 `%` 없음
   - 파일 끝 정상 (`tail -3` 확인)
7. **함수 단위로 git diff + 사용자 확인 후 다음 함수로**

---

## 위험 신호 + 대응

| 신호 | 대응 |
|---|---|
| `string.format` 단일 % 발견 | `%%`로 이스케이프 |
| 파일 끝 byte 깨짐 / 본문 누락 | 즉시 git diff로 확인 → 망가졌으면 `git checkout` 후 변경 다시 적용 |
| Edit 도구가 `File has been modified since read` | Python으로 직접 read/write |
| div 짝 불균형 | 함수 단위로 `<div`/`</div>` 카운트 검증 |
| RisuAI에서 렌더 깨짐 | 들여쓰기 0인지 / 마크다운 파서 트리거할 4칸+ 들여쓰기 없는지 확인 |

---

## 이미 적용된 다른 작업 (손대지 말 것)

다음 변경들은 별도 작업으로 완료. 디버깅 중 실수로 되돌리지 말 것:

1. **주간보고서 Tarot v3 + 위치 이동**
   - `convertWeeklyReport` 함수 (L6078 부근) HTML 본문 Tarot v3로 교체됨
   - `editDisplay` 안 `<WeeklyReport>` 처리가 in-place gsub → 추출 후 메시지 끝에 append로 변경됨
   
2. **선택지 시스템 Tarot v3 + 한글 난이도**
   - `parseCombatChoice` (L3344 부근) — 5가지 색깔 분기 제거, 단일 자주 톤, `diffLabels` 매핑 (매우 쉬움/쉬움/보통/어려움/매우 어려움)
   - `editDisplay` 안 `<CombatChoice>` 변환도 동일하게 변경됨

3. **시스템 메시지 Tarot v3**
   - `editDisplay` 안 `- System Message:` 변환이 3타입 색 분기 → 단일 자주+골드 + 좌측 보더만 미세 분기 (business 골드 / stock 핑크 / general 탁한 골드)
   - 이모지 ✦/❖/◆로 변경

4. **미래시 정규식** (별도 파일 `미래시`)
   - 정규식모음 [14]번 항목용 HTML — Tarot v3 톤
   - lua 작업 아님 (정규식 모음에 별도 등록 필요)

5. **PressShell 변환 완료** (이번 작업의 1단계)
   - `generateStockPanelUI` 본문 (L6499~) The Lilybelly Ledger 마스트헤드 + 4탭 + 푸터

---

## 게임 시간 동적 매핑 (PressShell에서 사용 중)

PressShell의 마스트헤드는 게임 시간을 동적으로 표시:
```lua
local seasonVol = {["봄"]="I", ["여름"]="II", ["가을"]="III", ["겨울"]="IV"}
local season = getChatVar(triggerId, "current_season") or "봄"
local week = getChatVar(triggerId, "week_of_season") or "1"
local dayName = getChatVar(triggerId, "day_of_week_name") or "Friday"
local currentTime = getChatVar(triggerId, "current_time") or "오후"
local volRoman = seasonVol[season] or "I"
local edition = (currentTime == "오전") and "Morning Edition" or "Late Edition"
```
→ "Vol. {volRoman} · No. {week}" + "{dayName} · {edition}"

다른 view 함수에서도 동일 매핑 필요하면 재활용 가능.

---

## 검증 체크리스트 (각 함수 변환 후 실행)

```bash
cd "벨라도나 아카데미"
python3 <<'PYEOF'
import re
content = open("belladonna_academy_rpg_new.lua", encoding="utf-8").read()

# 1. 함수 영역 추출
m = re.search(r'(function generateStockBoardView\(triggerId\).*?\nend\n)', content, re.DOTALL)
func = m.group(1) if m else ""
print(f"함수 길이: {len(func)}c")

# 2. 옛 색 잔여
old_colors = ["#0d1117", "#161b22", "#58a6ff", "#d29922", "#ffd700", "#c9d1d9"]
for c in old_colors:
    cnt = func.count(c)
    print(f"  옛 색 '{c}': {cnt} (0이어야)")

# 3. Press 토큰 적용
press = ["#161210", "#e8a679", "#d4af6a", "#f0e3cc", "Noto Serif KR"]
for t in press:
    print(f"  Press '{t}': {func.count(t)}")

# 4. 트리거 보존
for trg in ["stock_buy_", "stock_sell_", "stock_select_"]:  # 함수별로 조정
    print(f"  트리거 '{trg}': {func.count(trg)}")

# 5. string.format 검증
fmts = re.findall(r'string\.format\(\s*\[\[(.*?)\]\]', func, re.DOTALL)
for i, f in enumerate(fmts):
    ss = len(re.findall(r'%s', f))
    dd = len(re.findall(r'%d', f))
    pp = len(re.findall(r'%%', f))
    single = re.findall(r'(?<!%)%(?![s%d])', f)
    print(f"  format[{i}] %s={ss} %d={dd} %%={pp} 단일={len(single)} {'⚠' if single else 'OK'}")

# 6. 파일 끝 정상
print(f"\n파일 끝 100자: {repr(content[-100:])}")
PYEOF
```

---

## 진행 후 보고

각 함수 변환이 끝나면 민옥에게 다음을 보고:
1. 어떤 함수 완료 (이름 + 라인 범위)
2. Press 디자인 적용 내용 요약
3. 보존된 lua 로직 확인
4. 검증 결과 (옛 색 잔여 0, 트리거 보존, format 매칭)
5. 다음 함수로 넘어갈지 확인

함수 5개 모두 완료 후:
- `RisuAI에서 실제 렌더 테스트` 권장 — 챗봇 열고 주식 패널 → 4개 탭 전환하며 시각 확인
- 깨지면 어떤 탭/요소가 깨졌는지 알려달라고

---

## 인수인계 끝

질문 있으면 민옥에게 직접. 그리고 작업 흐름이 좋은 단계로 끊기면 알려주면 됨.
