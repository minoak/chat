# 현재 시스템 변수 정리

## 📊 기존에 관리 중인 변수

### 1. 캐릭터 관계 (14명)
```
{캐릭터}_affinity           // 호감도 (-500 ~ 500)
{캐릭터}_sin_pos            // 죄악 유혹 (0 ~ 30)
{캐릭터}_sin_neg            // 죄악 저항 (0 ~ 30)
{캐릭터}_route              // 루트 상태
```

### 2. 시간 시스템
```
current_season              // "봄/여름/가을/겨울"
week_of_season              // "1" ~ "12"
current_day                 // "1" ~ "7"
current_time                // "오전/오후/저녁/밤"
```

### 3. 장소/상태
```
current_location            // "중앙 광장" 등
current_weather             // "맑음" 등
active_event                // "none" 또는 이벤트명
```

### 4. 플레이어 RPG 스탯
```
player_level                // 레벨
player_exp                  // 경험치
player_gold                 // 골드
player_str                  // 근력
player_int                  // 지능
player_dex                  // 민첩
player_cha                  // 매력
player_luk                  // 행운
player_vit                  // 생명
player_items                // 아이템 목록
player_traits               // 특성 목록
```

---

## ✨ 주간 스케줄에 추가할 변수 (단 2개!)

```lua
current_curriculum = ""     // 선택한 커리큘럼 (교수)
current_lifestyle = ""      // 선택한 라이프스타일
```

**그게 끝입니다.**

---

## 🎯 동작 방식

### 1. HTML 버튼
```html
<button risu-trigger="set_curriculum_viper">Professor Viper</button>
<button risu-trigger="set_curriculum_nightshade">Professor Nightshade</button>

<button risu-trigger="set_lifestyle_study">범생이</button>
<button risu-trigger="set_lifestyle_social">사교형</button>
```

### 2. Lua 함수 (엄청 간단)
```lua
_G["set_curriculum_viper"] = function(triggerId)
    setChatVar(triggerId, "current_curriculum", "viper")
end

_G["set_lifestyle_study"] = function(triggerId)
    setChatVar(triggerId, "current_lifestyle", "study")
end
```

### 3. 로어북 조건
```markdown
{{#if {{equal::{{getvar::current_curriculum}}::viper}}}}
이번 주는 Professor Viper의 실전 암살술...
{{/if}}

{{#if {{equal::{{getvar::current_lifestyle}}::study}}}}
방과후에는 도서관에서 공부...
{{/if}}
```

**끝!**

---

## 📝 onStart 초기화 추가

```lua
function onStart(triggerId)
    -- 기존 코드...

    -- 주간 스케줄 변수 추가 (이것만!)
    if not getChatVar(triggerId, "current_curriculum") then
        setChatVar(triggerId, "current_curriculum", "")
    end
    if not getChatVar(triggerId, "current_lifestyle") then
        setChatVar(triggerId, "current_lifestyle", "")
    end
end
```

---

## ✅ 정리

**기존 변수:**
- 시간, 장소, 캐릭터, RPG 스탯 → 이미 잘 관리됨

**추가할 변수:**
- `current_curriculum`
- `current_lifestyle`

**필요한 작업:**
1. Lua에 변수 2개 초기화
2. HTML에 버튼들 추가
3. 각 버튼마다 간단한 Lua 함수 (변수 설정만)
4. 로어북에서 if 조건으로 확인

**이게 전부입니다. 복잡할 게 없습니다.**
