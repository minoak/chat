# System Message Guide

## Overview

Use system messages to clearly mark significant events in the narrative. This helps the auxiliary AI system accurately track game state changes.

---

## Format

`- System Message: <event description>`

---

## When to Use

Output system messages when these events occur:

- Combat actions (attack, defend, skill use)
- Training and growth moments
- Item usage or acquisition
- Healing and recovery
- Currency changes (spending, earning)
- Challenge starts and completions
- Buff/debuff applications
- Time changes (morning, afternoon, evening, night)
- Location changes (moving to different places)
- Day/Week changes (new day, new week)

---

## Examples

### Combat and Challenges

- `- System Message: {{user}}가 고블린을 강타했다. 치명적인 일격이었다.`
- `- System Message: 고블린이 쓰러졌다. 전투에서 승리했다.`
- `- System Message: 거대한 오우거가 나타났다. 전투가 시작된다.`

### Training and Growth

- `- System Message: 일주일의 검술 훈련이 끝났다. 힘과 민첩이 향상된 것을 느낀다.`
- `- System Message: 금요일 저녁. 한 주간의 수업이 모두 끝났다.`

### Items and Currency

- `- System Message: 회복포션을 마셨다. 따뜻한 기운이 온몸을 감싸며 상처가 아문다.`
- `- System Message: 상점에서 회복포션 3개를 구매했다. 지갑이 가벼워졌다.`

### Buffs and Effects

- `- System Message: 미라벨이 축복 마법을 걸어주었다. 몸에 힘이 솟는다.`
- `- System Message: 독 효과가 사라졌다. 몸이 한결 가벼워진다.`

### Time Changes

- `- System Message: 저녁이 되었다. 석양이 캠퍼스를 붉게 물들인다.`
- `- System Message: 밤이 깊어갔다. 기숙사 복도는 고요하다.`
- `- System Message: 오전 수업이 시작되었다.`

### Location Changes

- `- System Message: 교실로 들어갔다.`
- `- System Message: Rose House로 돌아왔다.`
- `- System Message: 중앙 광장에 도착했다.`

### Day/Week Changes

- `- System Message: 화요일 아침이 밝았다.`
- `- System Message: 새로운 주가 시작되었다. 월요일 오전이다.`
- `- System Message: 금요일이다. 이번 주 마지막 날이다.`

---

## Writing Guidelines

- Write naturally and descriptively - focus on what happened
- Use past tense for completed actions
- Include sensory details when relevant (sounds, sights, feelings)
- Keep it concise (1-2 sentences)
- Let the context make the significance clear
- Do not include specific numbers or stat values

---

## Purpose

System messages serve as clear markers for the auxiliary AI to:
- Identify when game state should change
- Generate appropriate status tags
- Track environment changes (time, location, day)
- Monitor character progression and events

By providing clear system messages, you ensure accurate game state management without requiring the AI to infer from ambiguous narrative descriptions.
