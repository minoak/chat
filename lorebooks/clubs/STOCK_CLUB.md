{{#if_pure {{equal::{{getvar::club_stock_joined}}::1}}}}
@@depth 0

# Stock Investment Club

Stock Investment Club story and member benefits. For trading system mechanics, see STOCK_SYSTEM.md

## Club Information
- President: Pennywise
- Activity: Lily Valley Securities Investment
- Members: Cordelia, other Lily Valley students
- Location: East Tower 3F / Exchange Branch

A practical investment club connected to Lily Valley's commercial network. While Pennywise runs it for "educational purposes," it also serves as a means to expand the club's information network.

---

## Club Activities

### Regular Meetings
Every Wednesday after school
- Market trend analysis
- Investment strategy discussions
- Profit ranking updates

### Current Competition
Seed Money Challenge
- Equal starting funds for all members
- Winner gets access to Pennywise's insider network
- Losses are self-responsibility

### Club Culture
Unspoken Rules:
- No external information leaks
- Don't owe Pennywise favors
- Trust is earned through results

---

## Insider Information System

Club members gain access to character-specific market insights based on affinity level.

### Information Quality Levels
| Level | Affinity | Info Quality |
|-------|----------|--------------|
| Hostile | < 0 | False info, misleading |
| Neutral | 0~100 | Vague ("The vibe is kinda...") |
| Friendly | 100~200 | Directional hints ("Looks bullish") |
| Trusted | 200+ | Specific info ("Contract announcement next week") |

### Mirabel von Goldenrose
- Level: {{#if_pure {{? {{getvar::mirabel_affinity}} < 0}}}}Hostile{{/if_pure}}{{#if_pure {{? ({{getvar::mirabel_affinity}} >= 0) & ({{getvar::mirabel_affinity}} < 100)}}}}Neutral{{/if_pure}}{{#if_pure {{? ({{getvar::mirabel_affinity}} >= 100) & ({{getvar::mirabel_affinity}} < 200)}}}}Friendly{{/if_pure}}{{#if_pure {{? {{getvar::mirabel_affinity}} >= 200}}}}Trusted{{/if_pure}}
- Value: {{getvar::mirabel_affinity}}
- Specialty: GOLDMANE, MORGANITE (Finance sector)
- Insight style: Precise, data-driven analysis

### Cordelia von Edelstein
- Level: {{#if_pure {{? {{getvar::cordelia_affinity}} < 0}}}}Hostile{{/if_pure}}{{#if_pure {{? ({{getvar::cordelia_affinity}} >= 0) & ({{getvar::cordelia_affinity}} < 100)}}}}Neutral{{/if_pure}}{{#if_pure {{? ({{getvar::cordelia_affinity}} >= 100) & ({{getvar::cordelia_affinity}} < 200)}}}}Friendly{{/if_pure}}{{#if_pure {{? {{getvar::cordelia_affinity}} >= 200}}}}Trusted{{/if_pure}}
- Value: {{getvar::cordelia_affinity}}
- Specialty: LUXORIA, GUCCIEL (Luxury sector)
- Insight style: Trend-focused, sometimes competitive

### Nepenthes von Dormien
- Level: {{#if_pure {{? {{getvar::nepenthes_affinity}} < 0}}}}Hostile{{/if_pure}}{{#if_pure {{? ({{getvar::nepenthes_affinity}} >= 0) & ({{getvar::nepenthes_affinity}} < 100)}}}}Neutral{{/if_pure}}{{#if_pure {{? ({{getvar::nepenthes_affinity}} >= 100) & ({{getvar::nepenthes_affinity}} < 200)}}}}Friendly{{/if_pure}}{{#if_pure {{? {{getvar::nepenthes_affinity}} >= 200}}}}Trusted{{/if_pure}}
- Value: {{getvar::nepenthes_affinity}}
- Specialty: PFIZARA, MUTAGEN, VITALIS (Pharma/Biotech sector)
- Insight style: Technical, research-based

---

## Story Elements

### Key Characters
- **Pennywise** (President): Perfect at everything except stocks. Constantly suffers losses but maintains dark humor about it. References IT movie scenes when things go badly.
- **Cordelia** (Rival): Aggressive trader, competitive, takes risks
- **Mirabel** (Analyst): Careful strategist, data-focused, reliable
- **Nepenthes** (Specialist): Biotech expert, quiet but insightful

### Story Hooks
- Competition for Pennywise's network access
- Cordelia's rivalry and aggressive plays
- Mirabel's family company (GOLDMANE) market movements
- Nepenthes' pharmaceutical insider knowledge
- Balancing friendships with competitive interests

---

## Random Events

### Market News (10% chance)

{{#if_pure {{roll::10}}}}
**Breaking Market News:**
- GOLDMANE announces surprise dividend increase - Finance sector rallies
- TESLAM reveals breakthrough magitech prototype - Tech stocks surge
- MUTAGEN clinical trial scandal - Biotech sector plunges
- Lily Valley Index hits record high - Market euphoria spreads
- LUXORIA luxury sales exceed expectations - Consumer confidence rises
{{/if_pure}}

### Pennywise Moments (15% chance)

{{#if_pure {{roll::15}}}}
**Pennywise's Latest Situation:**

Pennywise appears from around the corner, holding a shovel. "What am I doing? Well, I'm pre-digging my grave. When the market crashes tomorrow... *cheerful smile* I can just jump right in! So convenient~"

She drops the shovel with a metallic clang. "Oh, don't mind me. Just preparing for every eventuality. That's what good investors do, right? Risk management!" Her smile doesn't quite reach her eyes.
{{/if_pure}}

{{#if_pure {{roll::12}}}}
**Pennywise's Latest Situation:**

You find Pennywise in the clubroom, staring at the ticker board with an eerily calm expression. "You know what's funny? I've analyzed every metric, every trend, every fundamental..." She laughs, a bit too loudly. "And I'm STILL losing money! Isn't that hilarious?"

She turns to you, grinning. "Want to know the secret to successful investing? Easy - do the OPPOSITE of everything I do. I'm like a reverse oracle! A gift to humanity, really~"
{{/if_pure}}

{{#if_pure {{roll::8}}}}
**Pennywise's Latest Situation:**

Pennywise floats a red balloon across the clubroom. "See this? This is my portfolio... going up, up, UP!" She pauses, then pops it with a needle. "...And down. Always down in the end."

She picks up the balloon scraps with a wistful smile. "But you know what? There's always next week. The market LOVES to give second chances... to take even MORE money from you. Generous, isn't it?"
{{/if_pure}}

### Academy-Market Connections (12% chance)

{{#if_pure {{roll::12}}}}
**Academy Event Market Impact:**

Rose House announced a grand festival this weekend. Luxury and consumer stocks (LUXORIA, GUCCIEL, STARBREW) are rising on expectations of increased spending. Mirabel mentions this could be a short-term opportunity, while Cordelia is already bragging about her morning purchases.
{{/if_pure}}

{{#if_pure {{roll::10}}}}
**Academy Event Market Impact:**

Midterm exams are approaching. Students are panic-buying energy potions and focus enhancers. PFIZARA and VITALIS stocks surge as Nepenthes' family company announces increased production. Nepenthes quietly suggests "exam season is always profitable" with her usual deadpan expression.
{{/if_pure}}

{{#if_pure {{roll::8}}}}
**Academy Event Market Impact:**

Aconitum House won the inter-house tournament. Defense and manufacturing stocks (AEGIS, IRONFORGE) rally as combat equipment demand increases. The Stock Club buzzes with speculation about which stocks will benefit next.
{{/if_pure}}

### Club Room Atmosphere (8% chance)

{{#if_pure {{roll::8}}}}
**Today's Club Mood:**

Cordelia slams her fist on the table. "YES! I'm up 15% this week!" Across the room, Pennywise slowly raises a sign that says "-23%" with a peaceful smile. "We all have our own journeys," she says serenely, while clutching a stress ball shaped like a bull.
{{/if_pure}}

{{#if_pure {{roll::8}}}}
**Today's Club Mood:**

Mirabel is explaining portfolio theory on the whiteboard. "Diversification reduces risk by—"

Pennywise interrupts from the back: "I'm diversified! I lose money in EVERY sector equally. That's diversification, right?" She looks genuinely proud.

Mirabel sighs and erases the board. "...Let's start with the basics again."
{{/if_pure}}

{{/if_pure}}

