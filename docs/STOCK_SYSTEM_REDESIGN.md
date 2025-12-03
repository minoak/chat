# 주식 시스템 개편 설계안

## 참고 자료
- STONKS-9800 (스팀 게임)
- 1980년대 일본 버블경제 주식 시뮬레이터

## 핵심 컨셉
STONKS-9800의 시스템을 벨라도나 아카데미 세계관에 맞게 적용

---

## 1. 캐릭터별 인사이더 정보

### 구현 방법
로어북 추가/수정 (STOCK_MARKET.md 또는 별도 파일)

### 전문가 목록
| 캐릭터 | 섹터 | 종목 |
|--------|------|------|
| Pennywise | 전체 시장 | 모든 종목 (동아리 부장) |
| Cordelia | 럭셔리 | ROSE, SILK |
| Nepenthes | 제약 | NEP, VITA, MUTA |
| Lilith | 마법 | IMP, CRYS, ELEM |
| Robert 교수 | 금융/전체 | BANK, OWLS + 시장 동향 |

### 정보 품질 (호감도 기반)
- 0 미만: 거짓 정보 가능
- 0~100: "요즘 분위기가..." (모호)
- 100~200: "상승/하락할 것 같아" (방향)
- 200+: "다음 주 계약 발표 예정" (구체적)

---

## 2. 주가 조작

### 구현 방법
로어북 내용에 포함

### 조건
- Pennywise 호감도 300+ 또는 미드나잇 앨리 연줄
- 비용: 500G+
- 효과: 특정 종목 다음 턴 ±10~20%
- 위험: 적발 시 경고 수치 대폭 상승

---

## 3. 정보상

### 결정
❌ 별도 구현 안 함 - 기존 메인캐릭터 활용

---

## 4. 경고 수치 시스템

### 개요
학사경고 대신 "경고 수치" 도입
- 일정 수치 이상 시 풍기위원회/선도부 로어북 활성화
- AI가 자연스럽게 상황 묘사

### 수치 구간
```
경고 수치: 0 ~ 100
├── 0~29: 정상 (로어북 비활성)
├── 30~59: 주의 (풍기위원회 관심)
├── 60~89: 경고 (선도부 조사)
└── 90+: 위험 (징계 위원회 소집)
```

### 수치 변동
| 행동 | 변동 |
|------|------|
| 내부자 거래 적발 | +15 |
| 주가 조작 적발 | +25 |
| 금지 구역 침입 | +10 |
| The Pit 발각 | +20 |
| 결투 규정 위반 | +10 |
| 시즌 경과 (무위반) | -10 |
| 교수 변호 | -15 |

### 로어북 활성화 조건
```markdown
{{#if_pure {{greater::{{getvar::warning_level}}::29}}}}
# 풍기위원회 / 선도부
(경고 수치에 따른 내용)
{{/if_pure}}
```

### Lua 구현
```lua
-- 경고 수치 증가
function addWarning(triggerId, amount, reason)
    local current = tonumber(getChatVar(triggerId, "warning_level")) or 0
    local newLevel = math.min(100, current + amount)
    setChatVar(triggerId, "warning_level", tostring(newLevel))
    log("⚠️ 경고 수치 +" .. amount .. " (" .. reason .. ") → " .. newLevel)
end

-- 경고 수치 감소
function reduceWarning(triggerId, amount)
    local current = tonumber(getChatVar(triggerId, "warning_level")) or 0
    local newLevel = math.max(0, current - amount)
    setChatVar(triggerId, "warning_level", tostring(newLevel))
end
```

---

## 5. 기존 구현 현황

### 이미 있는 기능
- 20개 종목 시스템
- 기본 매수/매도
- 뉴스 시스템 (AI 출력 → 파싱 → UI 표시)
- 가격 히스토리
- 차트 뷰

### 추가 필요
- [ ] 로어북: 캐릭터별 인사이더 정보 조건
- [ ] 로어북: 주가 조작 내용
- [ ] 로어북: 풍기위원회/선도부 (DISCIPLINE_COMMITTEE.md)
- [ ] Lua: 경고 수치 함수 (addWarning, reduceWarning)
- [ ] Lua: 적발 확률 체크
- [ ] UI: 경고 수치 표시 (선택사항)

---

## 작업 순서 (제안)

1. 경고 수치 Lua 함수 구현
2. DISCIPLINE_COMMITTEE.md 로어북 생성
3. STOCK_MARKET.md에 인사이더 정보/조작 내용 추가
4. 적발 확률 체크 로직 구현
5. 테스트

---

## 날짜
2025-12-02
