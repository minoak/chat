# Hex Radar Polygon — Lua 함수

`rpg_status_panel_tarot_v3.html`의 SVG `<polygon class="hex-fill" points="{{getvar::player_hex_polygon}}"/>`가 작동하려면, Lua에서 6 스탯 값으로 polygon 좌표 문자열을 미리 계산해 `player_hex_polygon` 변수에 저장해야 함.

## 함수 정의

`belladonna_academy_rpg.lua`에 추가:

```lua
-- 6 스탯 → SVG hex radar polygon 좌표 문자열
-- 중심 (160, 150), 반지름 스케일 = stat 값 (0~99 가정)
-- 꼭짓점 순서 (시계방향, 12시부터): STR · INT · DEX · CHA · LUK · VIT
function updateHexPolygon(triggerId)
    local function n(k) return tonumber(getvar(triggerId, k)) or 0 end

    local str_  = n("str_effective")
    local int_  = n("int_effective")
    local dex_  = n("dex_effective")
    local cha_  = n("cha_effective")
    local luk_  = n("luk_effective")
    local vit_  = n("vit_effective")

    local cx, cy = 160, 150
    local s = 0.866  -- sin(60°)

    local points = string.format(
        "%.1f,%.1f %.1f,%.1f %.1f,%.1f %.1f,%.1f %.1f,%.1f %.1f,%.1f",
        cx,             cy - str_,         -- STR  (top, 12시)
        cx + int_ * s,  cy - int_ * 0.5,   -- INT  (2시)
        cx + dex_ * s,  cy + dex_ * 0.5,   -- DEX  (4시)
        cx,             cy + cha_,         -- CHA  (6시)
        cx - luk_ * s,  cy + luk_ * 0.5,   -- LUK  (8시)
        cx - vit_ * s,  cy - vit_ * 0.5    -- VIT  (10시)
    )

    setvar(triggerId, "player_hex_polygon", points)
end
```

## 어디서 호출할지

스탯이 바뀌는 모든 곳에서 호출. 가장 안전한 위치는 `onOutput()` 마지막 (모든 파싱이 끝난 후) 또는 `parseStatChanges()` 같은 함수의 끝.

예:

```lua
function onOutput(triggerId, message)
    -- ... 기존 파싱 ...
    parseStatChanges(triggerId, message)
    parseGoldChanges(triggerId, message)
    parseItems(triggerId, message)
    -- ... 호감도, EXP 등 ...

    -- 마지막에 hex polygon 갱신
    updateHexPolygon(triggerId)

    -- 그 다음 패널 출력
    local finalMessage = message .. "\n\n" .. auxiliaryMessage .. "\n" .. rpgStatsPanel
    setChat(triggerId, -1, finalMessage)
end
```

## 초기화

게임 시작 시 (Lua의 `onStart` 또는 첫 메시지 처리 시) 한 번 호출해서 초기 polygon이 그려지도록:

```lua
function onStart(triggerId)
    -- ... 기존 초기화 ...
    updateHexPolygon(triggerId)
end
```

## 좌표 검증 (디버깅용)

stat 값이 0이면 모든 점이 중심 (160, 150)으로 모이고 polygon이 점 하나로 보임. stat 값이 99이면 가장 바깥 hex(viewBox의 max ring)에 닿음. SVG viewBox는 `0 0 320 300`.

샘플 — STR 42, INT 78, DEX 55, CHA 88, LUK 30, VIT 65:
```
160,108  227.6,111  207.6,177.5  160,238  134,165  103.7,117.5
```

(현재 preview HTML에 박혀있는 값과 동일)

## 변수 없을 때 동작

`{{getvar::player_hex_polygon}}`이 비어있으면 `<polygon points="">` 가 되어 polygon이 그려지지 않음 (선은 그대로 보임). Lua 함수 추가 전엔 v2와 동일한 모양 — 안전한 점진적 향상.
