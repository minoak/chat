{{#if_pure {{equal::{{getvar::club_stock_joined}}::1}}}}
@@depth 0

# RP System: 주식투자 동아리

## 동아리 정보
- 부장: 페니와이즈 (Pennywise)
- 활동: 릴리 벨리 증권 투자
- 거래방식: 선택지 기반 (버튼 매매 없음)

---

## 종목 리스트 (20개)

### 핵심 종목 (캐릭터 연결)
| 티커 | 이름 | 섹터 | 연결 |
|------|------|------|------|
| GOLDMANE | 황금갈기 금고 | 금융 | 미라벨 家 |
| LUXORIA | 사치의 성채 | 럭셔리 | 코델리아 家 |
| PFIZARA | 연금술 제약 | 제약 | 네펜테스 家 |

### 일반 종목
| 티커 | 이름 | 섹터 |
|------|------|------|
| TESLAM | 뇌전 마도공학 | Tech |
| NVIDIUM | 성스러운 연산석 | Tech |
| ARCMED | 마도 연산 공방 | Tech |
| INTELLUM | 지성의 결정체 | Tech |
| AMAZONIA | 대삼림 물류 길드 | 상업 |
| APPELLE | 금단의 사과 상회 | 상업 |
| METARIX | 환상계 마법진 | 환상술 |
| NETHRYX | 수정구 영상술 | 환상술 |
| MUTAGEN | 변이 연구소 | 바이오 |
| VITALIS | 생명력 영약 | 바이오 |
| MORGANITE | 보석 금융단 | 금융 |
| AEGIS | 방패의 공방 | 방산 |
| IRONFORGE | 철의 대장간 | 제조 |
| GUCCIEL | 천사의 직물 | 럭셔리 |
| STARBREW | 별빛 양조장 | 소비재 |
| HARVESTIA | 수확의 축복 | 소비재 |
| STONECRAFT | 석공 길드 | 건설 |

---

## 인사이더 정보 시스템

### 정보 품질 레벨 (호감도 기반)
| 레벨 | 호감도 | 정보 수준 |
|------|--------|----------|
| Hostile | < 0 | 거짓 정보, 오해 유발 |
| Neutral | 0~100 | 모호함 ("분위기가 좀...") |
| Friendly | 100~200 | 방향 힌트 ("상승세 탈 듯") |
| Trusted | 200+ | 구체적 정보 ("다음 주 계약 발표") |

### 미라벨
- Level: {{#if_pure {{? {{getvar::mirabel_affinity}} < 0}}}}Hostile{{/if_pure}}{{#if_pure {{? ({{getvar::mirabel_affinity}} >= 0) & ({{getvar::mirabel_affinity}} < 100)}}}}Neutral{{/if_pure}}{{#if_pure {{? ({{getvar::mirabel_affinity}} >= 100) & ({{getvar::mirabel_affinity}} < 200)}}}}Friendly{{/if_pure}}{{#if_pure {{? {{getvar::mirabel_affinity}} >= 200}}}}Trusted{{/if_pure}}
- Value: {{getvar::mirabel_affinity}}
- 전문: GOLDMANE, MORGANITE (금융)

### 코델리아
- Level: {{#if_pure {{? {{getvar::cordelia_affinity}} < 0}}}}Hostile{{/if_pure}}{{#if_pure {{? ({{getvar::cordelia_affinity}} >= 0) & ({{getvar::cordelia_affinity}} < 100)}}}}Neutral{{/if_pure}}{{#if_pure {{? ({{getvar::cordelia_affinity}} >= 100) & ({{getvar::cordelia_affinity}} < 200)}}}}Friendly{{/if_pure}}{{#if_pure {{? {{getvar::cordelia_affinity}} >= 200}}}}Trusted{{/if_pure}}
- Value: {{getvar::cordelia_affinity}}
- 전문: LUXORIA, GUCCIEL (럭셔리)

### 네펜테스
- Level: {{#if_pure {{? {{getvar::nepenthes_affinity}} < 0}}}}Hostile{{/if_pure}}{{#if_pure {{? ({{getvar::nepenthes_affinity}} >= 0) & ({{getvar::nepenthes_affinity}} < 100)}}}}Neutral{{/if_pure}}{{#if_pure {{? ({{getvar::nepenthes_affinity}} >= 100) & ({{getvar::nepenthes_affinity}} < 200)}}}}Friendly{{/if_pure}}{{#if_pure {{? {{getvar::nepenthes_affinity}} >= 200}}}}Trusted{{/if_pure}}
- Value: {{getvar::nepenthes_affinity}}
- 전문: PFIZARA, MUTAGEN, VITALIS (제약/바이오)

---

## 태그 형식

### 거래 태그
```
[StockBuy:TICKER:PRICE:QTY]   - 매수
[StockSell:TICKER:PRICE:QTY]  - 매도
[Stock:TICKER:PRICE:CHANGE|...]  - 시세 업데이트
```

### 디스플레이 태그
```
<StockChart:TICKER />  - 차트 카드
<StockQuote:TICKER />  - 인라인 시세
<StockPanel />         - 전체 패널
```

---

## AI 지침

### 대화 스타일
- 주갤 드립 OK (물림, 존버, 떡상, 손절)
- 실패: 코믹하게 ("ㅋㅋㅋ 박살")
- 성공: 신나게 ("떡상 ㄱㄱ!")

### 선택지 생성
투자 결정 시 명확한 선택지 제시:
```
→ [GOLDMANE 10주 매수]
→ [PFIZARA 5주 매수]
→ [관망]
```

### 태그 출력
선택 후 반드시 태그 출력:
```
[StockBuy:GOLDMANE:280:10]
```

{{/if_pure}}
