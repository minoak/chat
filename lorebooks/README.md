# Belladonna Academy Lorebooks

벨라도나 아카데미 RPG 시스템의 모든 설정 파일들이 카테고리별로 정리되어 있습니다.

## 📁 디렉토리 구조

```
lorebooks/
├── ai/                 (5 files)  - AI 행동 및 프롬프트 설정
├── characters/        (24 files)  - 캐릭터 프로필 (학생 + 교수 + 특수)
├── clubs/             (6 files)   - 동아리 및 회사 경영 시스템
├── core/              (4 files)   - 핵심 아카데미 설정 및 매트릭스
├── houses/            (7 files)   - 7개 하우스 (학부) 정보
├── locations/         (8 files)   - 캠퍼스 및 도시 지역
├── schedules/         (3 files)   - 학사일정 및 스케줄 시스템
└── systems/           (4 files)   - 게임 메카닉스 (스탯, 전투, 주식)
```

## 📂 상세 카테고리

### 🤖 ai/
AI 동작 및 롤플레이 가이드라인
- `AI_GUIDANCE.md` - AI 행동 지침
- `AUXILIARY_PROMPT.md` - 보조 AI 프롬프트
- `AUXILIARY_PROMPT_NEW.md` - 새로운 보조 AI 프롬프트
- `RP_GUIDELINES.md` - 롤플레이 가이드라인
- `SYSTEM_MESSAGE_GUIDE.md` - 시스템 메시지 포맷 가이드

### 👥 characters/
총 24명의 캐릭터 프로필

**메인 학생 (8명):**
- Mirabel, Celestia, Cassandra, Evangeline, Amelia, Nepenthes, Lilith, Aurelia

**서브 학생 (6명):**
- Cordelia, Suah, Adelheid, Rosalie, Mika, Clover

**교수 (7명):**
- Vivienne, Margaret, Scar, Robert, Margot, Lydia, Hemlock

**특수:**
- Noctis (봉인된 마왕)
- Pennywise

### 🎪 clubs/
동아리 및 회사 경영 시스템
- `CLUBS.md` - 동아리 시스템
- `COMPANY_MANAGEMENT_SYSTEM.md` - 회사 경영 시스템
- `CORDELIA_COMPANY.md` - 코델리아의 회사
- `MIRABEL_COMPANY.md` - 미라벨의 회사
- `NEPENTHES_COMPANY.md` - 네펜테스의 회사
- `STOCK_CLUB.md` - 주식 동아리

### 🏛️ core/
아카데미 핵심 설정
- `ACADEMY.md` - 아카데미 전체 설명
- `CHARACTER_LIST.md` - 전체 캐릭터 목록 및 관계도
- `PROFESSOR_LIST.md` - 교수진 상세 프로필 (16KB)
- `DYNAMIC_MATRIX.md` - 캐릭터 호감도 및 행동 매트릭스 (116KB)

### 🏰 houses/
7개 하우스 (학부)
- `HOUSE_BELLADONNA.md` - 교양학부 (메인, 60-70% 학생)
- `HOUSE_ROSE.md` - 정치학부
- `HOUSE_IVY.md` - 예술학부
- `HOUSE_ACONITUM.md` - 전투학부
- `HOUSE_POPPY.md` - 마법학부
- `HOUSE_LILY_BELLY.md` - 상업학부
- `HOUSE_RAFFLESIA.md` - 연금술학부

### 🗺️ locations/
캠퍼스 및 도시 지역
- `LOCATION_SCARLET_STREET.md` - 스칼렛 거리
- `LOCATION_LOTUS_STREET.md` - 로터스 거리
- `LOCATION_MANA_SQUARE.md` - 마나 광장
- `LOCATION_MIDNIGHT_ALLEY.md` - 미드나잇 골목
- `LOCATION_RUBY_ROW.md` - 루비 로우
- `LOCATION_GOLDEN_DISTRICT.md` - 골든 디스트릭트
- `DUNGEON.md` - 지하 훈련 던전 및 봉인된 심연
- `FUTURE_CITY.md` - 확장 세계관 (24KB)

### 📅 schedules/
학사일정 및 스케줄 시스템
- `ACADEMIC_CALENDAR.md` - 전체 학사일정 (32KB)
- `SCHEDULE_WEEKLY.md` - 주간 스케줄 시스템
- `SCHEDULE.md` - 상세 스케줄링 (20KB)

### ⚙️ systems/
게임 메카닉스
- `STATUS_DETAILS.md` - 상태 시스템 상세 (19KB)
- `STAT_SYSTEM.md` - 스탯 시스템 (STR, INT, DEX, CHA, LUK, VIT)
- `STOCK_SYSTEM.md` - 주식 거래 메카닉스
- `COMBAT_GUIDELINES.md` - 전투 시스템 규칙

## 🎯 시스템 특징

### 3계층 아키텍처
1. **Lua 레이어** - 순수 변수 관리 및 계산
2. **Lorebook 레이어** - 조건부 정보 제공 (`{{#if}}` 문법)
3. **AI 레이어** - 메인 AI (스토리텔링) + 보조 AI (태그 생성)

### 주요 게임 메카닉스
- **호감도 시스템**: -500 ~ +500 범위
- **7대 죄악 시스템**: 메인 8명 캐릭터 전용
- **RPG 스탯**: STR, INT, DEX, CHA, LUK, VIT
- **레벨 시스템**: 1-20 레벨, 경험치 기반
- **아이템 시스템**: 15슬롯 인벤토리
- **경제 시스템**: 골드, 주식 거래
- **스냅샷/롤백**: 세이브/로드 기능

## 📝 참고사항

이 시스템은 RisuAI 플랫폼을 위한 종합 RPG 시스템으로, 상세한 캐릭터 상호작용, 스탯 관리, 서사 진행 시스템을 제공합니다.

메인 스크립트 파일:
- `/belladonna_academy_rpg.lua` (4,972줄) - 프로덕션 버전
- `/belladonna_academy_rpg_new.lua` (8,562줄) - 새 버전

개발 문서는 `/docs/` 디렉토리를 참고하세요.
