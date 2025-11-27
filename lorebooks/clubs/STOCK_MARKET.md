{{#if_pure {{equal::{{getvar::club_stock_joined}}::1}}}}

# Lily Valley Stock Market

## Market Overview

A securities trading system operated by Lily Valley House in partnership with the academy. Connected to the actual imperial economy, it provides students with investment education and practical experience.

Trading Hours: Always open (settlement is weekly)
Trading Unit: 1 share
Commission: None (educational purposes)

---

## Listed Stocks (20)

### Commerce/Trade Sector

LILY - Lily Valley Exchange (Base 100G, Medium volatility)
- Comprehensive commercial platform directly operated by Lily Valley House
- Close ties to Mirabel's family
- Rise factors: Major merchant contracts, festival season, trade expansion
- Fall factors: Competitor emergence, bandit activity, war
- Insider: Mirabel (hints at high affinity)

CARA - Caravan Alliance (Base 80G, Medium volatility)
- Intercontinental logistics company
- Rise factors: Trade route stability, new route development
- Fall factors: Bandits, war, bad weather

PORT - Harbor Authority (Base 120G, Low volatility)
- Imperial port facility operations
- Rise factors: Maritime trade increase, new port construction
- Fall factors: Pirates, epidemic quarantine

### Magic/Resources Sector

IMP - Imperial Manastone Corporation (Base 250G, Low volatility)
- Imperial-operated manastone mining/supply
- Most stable stock, dividend expected
- Rise factors: Imperial events, magic demand increase
- Fall factors: Mine accidents, political instability

CRYS - Crystal Works (Base 150G, Medium volatility)
- Magic crystal processing and distribution
- Rise factors: Academy events, magic research boom
- Fall factors: Raw stone shortage, processing accidents

ELEM - Elemental Energy (Base 200G, Medium-High volatility)
- Spirit contract-based energy supply
- Rise factors: Energy demand increase, new contracts
- Fall factors: Spirit realm anomalies, contract disputes

### Pharmaceutical/Alchemy Sector

NEP - Nepenthes Pharmaceuticals (Base 90G, High volatility)
- Potion and poison/antidote specialist
- Connected to Rafflesia House
- Rise factors: New drug approval, epidemics, war
- Fall factors: Side effect scandals, regulation tightening
- Insider: Rafflesia contacts

VITA - Vita Healing (Base 110G, Medium volatility)
- Healing potion specialist
- Rise factors: War, accidents, epidemics
- Fall factors: Peace times, competitors

MUTA - Mutagen Labs (Base 60G, Very High volatility)
- Mutation/enhancement drug research (gray area)
- Big win or total loss
- Rise factors: Illegal experiment success, military contracts
- Fall factors: Crackdowns, scandals, victim incidents

### Military/Security Sector

AEGIS - Aegis Defense (Base 180G, Medium volatility)
- Mercenary and security services
- Rise factors: War, noble disputes, security deterioration
- Fall factors: Peace, military reduction

IRON - Ironforge (Base 140G, Medium volatility)
- Weapons and armor manufacturing
- Rise factors: Military expansion, new weapon development
- Fall factors: Peace treaties, imports

### Luxury/Fashion Sector

ROSE - Rose House (Base 220G, Medium volatility)
- High-end clothing and jewelry
- Connected to Rose House
- Rise factors: Social season, imperial events, trends
- Fall factors: Economic recession, frugality trends

SILK - Silk Road Textiles (Base 95G, Low volatility)
- Magic textile manufacturing
- Rise factors: Fashion trends, export increase
- Fall factors: Raw material shortage

### Food/Agriculture Sector

HARV - Harvest Farms (Base 70G, Low volatility)
- Large-scale food production
- Rise factors: Good harvest, population growth
- Fall factors: Bad harvest, pests

BREW - Brewery Guild (Base 85G, Low volatility)
- Brewing and beverage production
- Rise factors: Festivals, economic boom
- Fall factors: Prohibition, tax increase

### Finance/Information Sector

BANK - Continental Central Bank (Base 300G, Low volatility)
- Core of imperial financial system
- Most expensive stock, most stable
- Rise factors: Interest rate hikes, economic growth
- Fall factors: Financial crisis, bank runs

OWLS - Owl Communications (Base 130G, Medium volatility)
- Information and postal services
- Rise factors: Information demand increase, new routes
- Fall factors: Censorship tightening, competitors

### Construction/Infrastructure Sector

STONE - Stonemason Construction (Base 160G, Low volatility)
- Large-scale architecture and infrastructure
- Rise factors: Reconstruction projects, new city development
- Fall factors: Economic recession, disasters

### Entertainment/Education Sector

MUSE - Muse Theatre (Base 75G, High volatility)
- Performance and entertainment business
- Rise factors: Hit shows, star emergence
- Fall factors: Flops, scandals

ACAD - Academia Publishing (Base 100G, Low volatility)
- Magic books and textbook publishing
- Rise factors: Academic discoveries, bestsellers
- Fall factors: Book banning, plagiarism scandals

---

## Trade Types

### Spot Trading
Standard stock buy/sell.
Buy with Gold, sell holdings to receive Gold.

### Leverage Trading
Trading at 2-5x scale using margin as collateral.
- 2x: Margin call line -25%
- 3x: Margin call line -17%
- 5x: Margin call line -10% (bankruptcy risk)

### Short Selling
Betting on price decline. Borrow shares to sell, rebuy when price drops.
Unlimited loss potential (if price rises infinitely).

---

## Main Model Guide

### Price Output Rules

Output current prices with `<Stock>` tag in exchange-related scenes.
Format is flexible, but "Ticker: Price, Direction - Reason" structure recommended.

```
<Stock>
LILY: 105G, Rising - Buying increased on major merchant arrival rumors
IMP: 243G, Falling - Supply concerns following mine accident
NEP: 98G, Surging - Phase 3 clinical trial success news
CARA: 82G, Flat - No special news
</Stock>
```

### Price Movement Criteria

- Determine naturally in connection with story events
- Positive news → Related stock rises
- Negative news → Related stock falls
- Major events → Sharp rise/fall possible
- Unrelated stocks show minor movement or stay flat

### Information Quality (Affinity-linked)

Mirabel (LILY, Commerce sector specialist)
- Affinity 0-30: "Well, I'm not sure..." (vague response)
- Affinity 30-60: "Trading volume has been increasing lately" (general info)
- Affinity 60-80: "Personally, it looks promising" (directional hint)
- Affinity 80+: "It's a secret, but... next week's announcement..." (insider info)

### Narrative Handling Items

Handle these situations through narrative, not system:

Margin Call
```
Create tense atmosphere
→ Explain situation ("Your margin is about to run out")
→ Present choices (Add funds / Cut losses / Hold)
→ Drama based on outcome
```

Big Win/Bankruptcy
```
Dramatic moment staging
→ NPC reactions (Mirabel's evaluation, other members' gazes)
→ Follow-up effects (debt, reputation, relationship changes)
```

News/Rumors
```
Deliver naturally through dialogue or bulletin boards
→ "Did you hear? There was an accident at Nepenthes..."
→ Keep authenticity unclear (guide player judgment)
```

---

## Investment Tips (Club Shared Information)

- Beginners: Low volatility stocks like IMP, BANK, HARV recommended
- Aggressive: High volatility stocks like NEP, MUTA, MUSE
- Balanced: Sector diversification
- Leverage: Only when confident, 2x recommended max

"The market is always right. It's your analysis that's wrong." - Mirabel

{{/if}}
