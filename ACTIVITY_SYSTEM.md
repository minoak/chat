# Belladonna Academy Activity System

## Activation Conditions
```
{{#if {{getvar::is_weekend}}=="false"}}
{{#if {{getvar::current_time}}=="오전"}}
[Weekday Morning Activities]
{{/if}}
{{#if {{getvar::current_time}}=="오후"}}
[Weekday Afternoon Activities]
{{/if}}
{{/if}}

{{#if {{getvar::is_weekend}}=="true"}}
[Weekend Activities]
{{/if}}

{{#if {{getvar::week_of_season}}=="4" OR "8" OR "12"}}
[Exam Week]
{{/if}}
```

---

## Weekday Morning - Class Selection

### 🗡️ Combat Training (Dueling Grounds)
{{user}}는 결투장에서 전투 기술을 연마한다. 실전 스파링과 무기 다루기, 전술 훈련이 진행된다. 땀 흘리며 몸을 단련하고 전투 감각을 키운다.

### 📚 Magic Theory (Common Lecture Halls)
{{user}}는 강의실에서 마법 이론을 배운다. 마법진 구조, 마력 제어, 속성 이론 등을 학습한다. 복잡한 마법 공식과 이론을 머리에 새긴다.

### 📖 Self-Study (Central Library)
{{user}}는 중앙 도서관에서 혼자 공부한다. 조용한 환경에서 원하는 분야를 자유롭게 탐구하고 책을 읽으며 지식을 쌓는다.

### 💤 Skip Class (Dormitory)
{{user}}는 수업을 빠지고 기숙사에서 쉰다. 침대에 누워 여유를 즐기거나 개인 시간을 보낸다. 피로가 풀리지만 배움은 없다.

---

## Weekday Afternoon - Free Time

### 🏋️ Training Grounds
{{user}}는 훈련장에서 개인 훈련을 한다. 체력 단련, 기술 연마, 실력 향상에 집중한다.

### ☕ Café District
{{user}}는 카페 거리를 방문한다. 따뜻한 음료를 마시며 여유를 즐기고, 마주치는 사람들과 대화를 나눈다.

### 🏬 Shopping Plaza
{{user}}는 상업 광장에서 쇼핑을 즐긴다. 다양한 상점을 둘러보며 필요한 물품을 구입하거나 구경한다.

### 📋 Quest Board (Midnight Alley)
{{user}}는 미드나이트 앨리의 의뢰 게시판을 확인한다. 몬스터 퇴치, 용병 일, 수상한 임무 등 다양한 퀘스트를 받을 수 있다. 위험하지만 보상도 크다.

### 🎭 Club Activities
{{user}}는 동아리 활동에 참여한다. 동료들과 함께 특정 분야를 탐구하고, 단체 활동을 통해 우정을 쌓는다.

### 🛌 Rest (Dormitory)
{{user}}는 기숙사로 돌아가 푹 쉰다. 침대에 누워 체력을 회복하고 다음 날을 준비한다.

---

## Weekend - Major Activities

### 💕 Character Date
{{user}}는 친밀한 캐릭터와 데이트를 즐긴다. 함께 시간을 보내며 특별한 추억을 만들고 관계를 깊게 한다. 이벤트와 대화를 통해 유대감이 강해진다.

### 🏰 Dungeon Exploration
{{user}}는 위험한 던전에 도전한다. 강력한 몬스터와 싸우고, 함정을 피하며, 귀중한 보물을 찾는다. 높은 난이도지만 큰 보상이 기다린다.

### 🌿 Full Rest & Recovery
{{user}}는 주말 내내 푹 쉬며 지친 몸과 마음을 회복한다. 느긋하게 시간을 보내며 에너지를 완전히 충전한다.

---

## Exam Week (Week 4, 8, 12)

### 📝 Quarterly Exam Period
분기별 시험 주간이다. {{user}}는 원하는 과목의 시험을 선택해 응시할 수 있다. 시험 결과에 따라 성적이 평가되고, 우수한 성적은 특별한 보상으로 이어진다.

시험 과목은 전투 실기, 마법 이론, 역사, 연금술 등 다양하며, {{user}}의 강점을 살려 선택할 수 있다.

---

## System Notes

- 활동 선택은 버튼 클릭 또는 자유로운 대화로 진행
- 로케이션 변수(current_location)는 선택 시 자동으로 업데이트됨
- 보상(스탯, 골드, 아이템 등)은 보조 AI가 상황에 맞게 자동 판단하여 태그 출력
- 캐릭터 등장 및 행동은 각 캐릭터의 캐릭터 시트에 따라 자연스럽게 결정됨
