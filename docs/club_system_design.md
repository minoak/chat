# 동아리 시스템 설계 문서

## 개요

캐릭터/하우스별 테마 동아리를 시스템화하여 서사와 게임플레이를 통합.
주식투자 동아리(릴리 벨리)를 첫 번째 구현 대상으로 설정.

## 핵심 원칙

1. 기존 시스템 최대한 재사용 (아이템, Gold, 선택지)
2. 트리거 기반 활성화 (미가입 시 완전히 비활성)
3. 서사 중심, 시스템은 보조
4. 간접 정보 제공으로 플레이어 추론 유도

---

## 1. 주식투자 동아리 (릴리 벨리)

### 1.1 시스템 매핑

기존 시스템 활용:
- 자산 관리 → 아이템 시스템 (STOCK_LILY, STOCK_IMP, STOCK_NEP)
- 거래 선택 → 선택지 기능 (`<StockChoice>`)
- 자금 → Gold 시스템
- 수수료/배당 → `[Gold:±N]` 태그

### 1.2 데이터 구조

ChatVar (영구 저장):
```
club_stock_investing = "joined" / "declined" / ""
stock_lily_history = "95,97,98,100,102,101,100"  (최근 7-14일)
stock_lily_avgprice = "105"  (평균 매수가)
```

State (세션 임시):
```
club_stock_investing_active = true
stock_lily_price = 120
stock_imp_price = 245
stock_nep_price = 89
```

아이템:
```
STOCK_LILY: 릴리 거래소 주식 (수량 = 보유 주식 수)
STOCK_IMP: 황실 마나석 주식
STOCK_NEP: 네펜테스 제약 주식
```

### 1.3 가입 플로우

```
메인 AI: "릴리 벨리 주식투자 동아리 가입서가 놓여있다."
         <ClubApplication club="stock_investing" />
↓
editDisplay: CSS 스타일 가입서 + 가입/거절 버튼 표시
↓
onButtonClick: join_club_stock_investing
↓
setChatVar(triggerId, "club_stock_investing", "joined")
setState(triggerId, "club_stock_investing_active", true)
initializeStockSystem(triggerId)
↓
로어북 조건부 활성화: @@if club_stock_investing == "joined"
```

### 1.4 정보 제공 원칙

현실 주식과 유사한 간접 정보 제공:

직접 예측 금지:
- ❌ "릴리 주식은 다음 주 오를 것입니다"
- ❌ "지금 사면 이득입니다"

간접 힌트 제공:
- ✅ 뉴스/루머: "릴리 벨리에 대형 상단 입주 소문"
- ✅ 관찰: "거래소 앞이 평소보다 붐빈다"
- ✅ 기술적: 과거 차트 + 추세 설명
- ✅ 펀더멘털: "황실 납품 계약 체결"
- ✅ 내부자 정보 (고호감도): "다음 주 큰 발표 예정"

호감도별 정보 품질:
```
미라벨 호감도 0-20:  "글쎄요, 잘 모르겠는데요?"
미라벨 호감도 20-50: "최근 거래량이 늘어나는 추세예요"
미라벨 호감도 50-80: "개인적으로는 릴리가 유망해 보여요"
미라벨 호감도 80+:   "비밀인데... 다음 주 황실 발표가..."
```

### 1.5 주가 변동 메커니즘

```lua
function calculateStockMovement(triggerId, stockId)
    -- 1. 기본 변동성
    local baseVolatility = {
        lily = 0.08,  -- ±8% (중위험)
        imp = 0.05,   -- ±5% (저위험)
        nep = 0.15    -- ±15% (고위험)
    }

    -- 2. 이벤트 기반 조정
    local eventBonus = 0
    if getChatVar(triggerId, "event_lily_contract") == "true" then
        eventBonus = 0.12  -- 황실 계약 → +12% 확정
    end

    -- 3. 랜덤 요소
    local random = (math.random() * 2 - 1) * baseVolatility[stockId]

    -- 4. 불확실성 (정보도 100% 정확하지 않음)
    return eventBonus + random
end
```

주간 업데이트:
- 매주 금요일 or 주간 스케줄 종료 시
- 모든 종목 가격 변동
- 히스토리 업데이트 (최근 14일 유지)

### 1.6 UI 컴포넌트

editDisplay 변환 태그:

`<StockBoard />` → 실시간 시세표
```
종목명         현재가    등락      보유
릴리 거래소    120G     ▲+5.2%    10주
황실 마나석    245G     ▼-2.1%    5주
네펜테스 제약   89G     ▲+12.8%   0주
```

`<StockChart stock="lily" type="line" />` → 주가 그래프
- SVG 라인 차트 (권장)
- CSS 바 차트
- 유니코드 블록 차트

`<StockChoice>` → 거래 선택지
```
[선택1] LILY 10주 매수 (1200G)
[선택2] IMP 5주 매도 (1225G)
[선택3] 시세만 확인
[선택4] 오늘은 관망
```

### 1.7 거래 처리

onButtonClick 핸들러:
```lua
if code:match("^stock_choice_") then
    local choice = code:gsub("stock_choice_", "")

    if choice == "1" then  -- 매수
        local price = getState(triggerId, "stock_lily_price")
        local quantity = 10
        local cost = price * quantity
        local fee = math.floor(cost * 0.02)  -- 2% 수수료

        parseGoldChanges(triggerId, "[Gold:-" .. (cost + fee) .. "]")
        parseItems(triggerId, "[Item:Add:STOCK_LILY:" .. quantity .. "]")
        updateAveragePrice(triggerId, "lily", price, quantity)

        addChat(triggerId, 'user', '릴리 거래소 주식 10주를 매수했다.')
    end
end
```

### 1.8 종목 설정

릴리 거래소 (LILY):
- 기준가: 100G
- 변동성: 중간 (±8%)
- 테마: 상업, 미라벨 영향
- 이벤트: 계약 체결, 경쟁사 동향

황실 마나석 (IMP):
- 기준가: 250G
- 변동성: 낮음 (±5%)
- 테마: 안정적, 황실 이벤트 영향
- 이벤트: 황실 정책, 마나석 수급

네펜테스 제약 (NEP):
- 기준가: 90G
- 변동성: 높음 (±15%)
- 테마: 고위험고수익, 네펜테스 루트 연동
- 이벤트: 신약 개발, 스캔들

---

## 2. 구현 체크리스트

### Phase 1: 기본 구조
- [ ] 동아리 가입 시스템 (가입서 UI + 버튼)
- [ ] 초기화 함수 (주가, 히스토리)
- [ ] 로어북 조건부 활성화 (@@if)
- [ ] 주식 아이템 정의

### Phase 2: 정보 시스템
- [ ] 로어북 정보 제공 가이드라인
- [ ] 호감도별 정보 품질 구현
- [ ] 이벤트 플래그 시스템

### Phase 3: 거래 시스템
- [ ] 선택지 생성 (StockChoice 태그)
- [ ] 매수/매도 처리
- [ ] 평균 매수가 계산
- [ ] 수수료 처리

### Phase 4: 주가 시스템
- [ ] 주간 변동 함수
- [ ] 히스토리 저장/업데이트
- [ ] 이벤트 기반 조정

### Phase 5: UI/시각화
- [ ] 시세표 (StockBoard)
- [ ] 주가 그래프 (StockChart)
- [ ] 포트폴리오 손익 계산

### Phase 6: 서사 통합
- [ ] 미라벨 대화 이벤트
- [ ] 뉴스/루머 시스템
- [ ] 황실/네펜테스 연동 이벤트

---

## 3. 향후 확장

### 3.1 다른 동아리 아이디어

연금술 동아리 (라플레시아):
- 아이템 제작 시스템
- 재료 수집 퀘스트
- 특수 포션 제조

결투 동아리 (아코니툼):
- 토너먼트 시스템
- 전투 훈련 보너스
- 카산드라 지도

음악/예술 동아리 (로즈):
- 공연 이벤트
- 캐릭터 친밀도 보너스
- 명성 시스템

### 3.2 고급 주식 기능

- 배당금 시스템 (분기별 Gold 지급)
- 공매도 (고위험 전략)
- 포트폴리오 다각화 보너스
- 시장 뉴스 알림 시스템

### 3.3 크로스 동아리 시너지

- 연금술 동아리 + 네펜테스 주식 정보
- 결투 동아리 + 전투 용품 주식
- 황실 이벤트 참여 → 마나석 내부정보

---

## 4. 기술 스택

Lua 함수:
- initializeStockSystem(triggerId)
- calculateStockMovement(triggerId, stockId)
- updateStockPrice(triggerId, stockId, newPrice)
- updateAveragePrice(triggerId, stockId, price, quantity)
- getStockInfoQuality(triggerId, character)
- generateStockBoard(...)
- generateStockChart(...)

editDisplay 태그:
- `<ClubApplication club="..." />`
- `<StockBoard />`
- `<StockChart stock="..." type="..." />`
- `<StockChoice>...</StockChoice>`

onButtonClick 코드:
- join_club_stock_investing
- decline_club_stock_investing
- stock_choice_N

로어북:
- CLUB_STOCK_INVESTING.md (@@if 조건부)
- 정보 제공 가이드라인
- 종목별 상세 정보

---

## 5. 참고사항

밸런스:
- 초보자도 안전하게 플레이 가능해야 함
- 안정주 (IMP) 항상 제공
- 정보 없이도 최소 손실

AI 일관성:
- 로어북 가이드라인 명확히
- 직접 예측 절대 금지
- 힌트와 실제 결과 연결

재미 요소:
- 정보 수집 = 게임
- 호감도의 실질적 가치
- 리스크/보상 균형
- 장기 전략 수립 가능

---

마지막 업데이트: 2025-11-26
상태: 설계 단계
