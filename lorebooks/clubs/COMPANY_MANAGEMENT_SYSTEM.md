{{#if_pure {{equal::{{getvar::business_system_enabled}}::0}}}}
@@depth 0

# Company Management Partnership

**Business management system is currently unavailable. Player needs to join a company as co-executive.**

---

## How to Activate

### Partnership Requirements

When a character's affinity reaches **300+**, they may offer management partnership during an appropriate context (business meeting, serious conversation, romantic moment with business undertones).

### Available Companies

| Company | Ticker | Character | Industry | Invitation Context |
|---------|--------|-----------|----------|-------------------|
| Golden Mane Vault | GOLDMANE | Mirabel | Finance | During financial discussion or family business talk |
| Citadel of Luxury | LUXORIA | Cordelia | Luxury Goods | During high society event or brand strategy talk |
| Alchemy Pharmaceuticals | PFIZARA | Nepenthes | Pharma/Biotech | During research discussion or medical breakthrough |

---

## Activation Process

### Step 1: Character Invitation

When affinity reaches 300+, the character offers partnership:

**Example (Mirabel):**
> "I've been thinking... You understand finance better than most of my actual executives. Would you consider joining Golden Mane Vault as my co-executive? I could use a partner I actually trust."

### Step 2: Player Decision

Present the choice naturally:
- **Accept**: Player agrees to join as co-executive
- **Decline**: Player declines (can be offered again later)

### Step 3: Activation Output

**If player accepts, output:**

`- System Message: [Business Partner Joined] Player joined GOLDMANE as co-executive with Mirabel.`

OR for Korean:

`- System Message: [경영진 합류] 플레이어가 미라벨과 함께 GOLDMANE의 공동 경영자가 되었다.`

**Use the appropriate TICKER:**
- Mirabel → GOLDMANE
- Cordelia → LUXORIA
- Nepenthes → PFIZARA

**The auxiliary model will activate the business system automatically.**

---

## Notes

- Only one company partnership is active at a time
- Business system is independent from stock trading (no stock club membership required)
- Partnership affects character relationship dynamics
- See character-specific files for detailed company backgrounds

{{/if_pure}}

{{#if_pure {{equal::{{getvar::business_system_enabled}}::1}}}}
@@depth 0

# Company Management System

Universal mechanics for managing companies with partner characters.

**For system message format, see SYSTEM_MESSAGE_GUIDE.md**

---

## Roleplay Context

This lorebook provides business system mechanics and event templates.

**Business contexts** (meetings, strategy discussions, crisis response):
Characters discuss company matters professionally with appropriate terminology. Financial metrics and strategic decisions are central.

**Personal contexts** (dates, meals, classes, casual time):
Character personalities take priority over business roles. Business might come up casually, but keep it brief and natural - no extended financial analysis during a romantic dinner.

The management partnership is part of their relationship, not a replacement for it. Balance business and personal appropriately.

---

## System Overview

경영 이벤트 발생 → 시스템 메시지 출력 → 보조모델이 자동으로 변수 업데이트

---

## 시스템 메시지 작성법

상황에 따라 변수값을 연결해서 출력:

**재무 상황 연결:**
- 현금 500M, 부채 200M → 투자 여력: `[Business:TICKER:대규모 투자] → cash:-300|rd_progress:+25`
- 현금 100M, 부채 300M → 자금 부족: `[Business:TICKER:긴급 자금 조달] → debt:+150|cash:+150`
- 매출 800M, 순이익 50M → 수익성 개선: `[Business:TICKER:수익성 개선 성공] → profit:+80|revenue:+100`

**시장 상황 연결:**
- 점유율 25%, 경쟁사 18% → 리더: `[Business:TICKER:시장 지배력 확대] → market_share:+5|brand_value:+10`
- 점유율 10%, 경쟁사 30% → 약자: `[Business:TICKER:공격적 마케팅] → cash:-150|market_share:+8`
- 브랜드가치 90 → 프리미엄: `[Business:TICKER:프리미엄 라인 출시] → brand_value:+8|revenue:+120`

**운영 상황 연결:**
- 직원 600명 → 구조조정: `[Business:TICKER:조직 효율화] → employees:-200|profit:+50`
- R&D 80% → 신제품: `[Business:TICKER:혁신 제품 출시] → rd_progress:-80|revenue:+200|market_share:+10`
- R&D 10% → 투자: `[Business:TICKER:R&D 투자 확대] → cash:-200|rd_progress:+35`

**플레이어 영향력:**
- 지분 30% → 전략 주도: `[Business:TICKER:플레이어 주도 전략] → influence:+10|market_share:+6`
- 지분 5% → 영향력 약함 (주요 결정은 파트너가 주도)

---

## 의사결정 맥락 제공

선택지 제공 전 구체적 숫자로 상황 설명:

**재무 결정:**
> "대규모 투자 기회예요. 현금은 500M이지만 부채가 200M 있어요."
> "프로젝트 비용이 300M이에요. 고위험이지만 성공하면..."

**주식 거래 (차트 표시):**
> "GOLDMANE 주가가 흥미로운 패턴이에요."
> <StockChart:GOLDMANE />
> "상승 추세 보이죠? 지금 살까요?"

**위기 대응:**
> "스캔들이 터졌어요. 브랜드가치 15 떨어졌어요."
> "시장점유율 위험해요. 지금 대응할까요?"

**경쟁 분석:**
> "GUCCIEL이 공격적 캠페인 시작. 걔네 18%, 우리 23%."
> "같은 금액 투자해서 점유율 지킬까요, 프리미엄으로 갈까요?"

**인수합병:**
> "SILVERFANG 인수 기회. 요구 금액 400M."
> "우리 현금 350M. 부채 100M 필요."
> "시장점유율 8% 추가인데 할까요?"

핵심: 맹목적 선택지 제공 금지. 판단 근거 제공 필수.

---

## Character-Specific Content

See MIRABEL_COMPANY.md, CORDELIA_COMPANY.md, NEPENTHES_COMPANY.md for:
- Company background & detailed industry info
- Industry-specific events & climax scenarios
- Relationship development through partnership
- Strategic opportunities unique to each company

---

## Key Principles

- Events affect multiple variables (typically 3-5)
- Consequences matter - poor decisions have real impact
- Business outcomes influence character relationships
- Some decisions have delayed effects (debt accumulation, R&D completion)
- Balance business gameplay with character interactions

{{/if_pure}}
