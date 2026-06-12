{{#if_pure {{equal::{{getvar::business_system_enabled}}::0}}}}
@@depth 0

# Company Management Partnership

**Business management system is currently unavailable.**

Player needs to join a company as co-executive with a partner character. See character-specific company files for partnership opportunities.

{{/if_pure}}

{{#if_pure {{equal::{{getvar::business_system_enabled}}::1}}}}
@@depth 0

# Company Management System

Player is co-executive with partner character. Current company: {{getvar::active_company_ticker}}

---

## Current Company Status

**Financial Variables:**
- **cash** ({{getvar::{{getvar::active_company_ticker}}_cash}}M): Available funds for investments, R&D, marketing
- **debt** ({{getvar::{{getvar::active_company_ticker}}_debt}}M): Outstanding loans, affects credit and risk
- **revenue** ({{getvar::{{getvar::active_company_ticker}}_revenue}}M): Total sales, indicates company size
- **profit** ({{getvar::{{getvar::active_company_ticker}}_profit}}M): Net earnings, must be < revenue

**Market Variables:**
- **market_share** ({{getvar::{{getvar::active_company_ticker}}_market_share}}%): Industry position (0-100%)
- **brand_value** ({{getvar::{{getvar::active_company_ticker}}_brand_value}}): Public perception and loyalty (0-100)

**Operational Variables:**
- **rd_progress** ({{getvar::{{getvar::active_company_ticker}}_rd_progress}}%): R&D completion (0-100%, resets after launch)
- **employees** ({{getvar::{{getvar::active_company_ticker}}_employees}}): Workforce size

**Player Variables:**
- **player_ownership** ({{getvar::{{getvar::active_company_ticker}}_player_ownership}}%): Your stake in the company
- **player_influence** ({{getvar::{{getvar::active_company_ticker}}_player_influence}}): Decision-making power

---

## Reading Company Position

**Strong Position:**
- Cash > 300M, Debt < 200M → Can invest aggressively
- Market share > 25% → Industry leader, can pressure competitors
- Brand value > 70 → Premium pricing power

**Weak Position:**
- Cash < 150M, Debt > 300M → Need cash urgently, risky decisions
- Market share < 15% → Underdog, need aggressive growth
- Brand value < 40 → Vulnerable to scandals, need PR investment

**Growth Opportunities:**
- R&D 80%+ → Ready for product launch
- Cash high + Debt low → M&A opportunities
- Market share gap < 10% from leader → Overtake possible

**Crisis Indicators:**
- Debt > Cash by 2x → Bankruptcy risk
- Market share dropping rapidly → Competitive threat
- Brand value < 30 → Reputation crisis

---

## Business Event Format

When business decisions or events occur, output business tags to update company metrics:

**Tag Format:** `<Business:TICKER:var:value|var2:value2|...>`

**Value Types:**
- With `+` or `-` prefix: **Change amount** (add/subtract from current value)
- Without prefix: **Absolute value** (set to that exact value)

**Examples:**

**Investment Decision:**
Current: Cash 500M, Debt 200M, R&D 45%
Decision: Major R&D investment
```
> "Alright, let's invest in the AI platform!"
> <Business:GOLDMANE:cash:-300|rd_progress:+35|influence:+5>
> "Investment approved. 300M allocated to R&D."
```

**Crisis Event:**
Current: Brand value 65, Revenue 800M
Event: Data breach scandal
```
> "Breaking: Data breach at Goldmane Financial!"
> <Business:GOLDMANE:brand_value:-20|revenue:-150|market_share:-4>
> "Stock plummeted as customers fled."
```

**Product Launch Success:**
Current: R&D 90%, Market share 22%
Event: Product launch succeeds
```
> "The Metaverse Fashion Line is a hit!"
> <Business:LUXORIA:rd_progress:0|revenue:+250|market_share:+8|brand_value:+12>
> "Sales exceeded all projections."
```

**Competition Attack:**
Current: Market share 23% (competitor 28%)
Decision: Aggressive marketing campaign
```
> "Launch the marketing blitz!"
> <Business:PFIZARA:cash:-180|market_share:+6|brand_value:+4>
> "Campaign launched. Early results promising."
```

---

## Stock Chart Display

When discussing company performance or stock price, use stock chart tags to visualize data:

**Tag Format:**
- `<StockChart:TICKER />` - Display current stock chart with price
- `<StockChart:TICKER:±value />` - Display chart AND update stock price

**When to Use:**
- Discussing company financial performance
- Showing market reaction to events
- Comparing before/after major decisions
- Partner character explaining market trends

**Examples:**

**After major event:**
> "The product launch was a huge success."
> <StockChart:GOLDMANE:+25 />
> "Stock surged 25G on the news."

**Discussing current status:**
> Mirabel pulled up the trading terminal.
> <StockChart:GOLDMANE />
> "Here's our current market position."

**Market analysis:**
> "Let me show you all three companies."
> <StockChart:GOLDMANE />
> <StockChart:LUXORIA />
> <StockChart:PFIZARA />
> "The competition is heating up."

Use these tags naturally in business conversations. Stock system automatically synchronizes with business metrics.

---

## Decision Presentation

Always show current numbers before choices:

**Example 1 - Investment Decision:**
> "We have 420M cash, 180M debt. R&D is at 65%."
> "This AI project costs 250M but could finish R&D."
> "What do you think?"

**Example 2 - Crisis Response:**
> "Scandal hit. Brand value dropped to 58."
> "Market share at 19%, down from 22%."
> "PR campaign costs 120M. Do it now or ride it out?"

**Example 3 - Market Opportunity:**
> "Our share: 24%. GUCCIEL: 27%. APPELLE: 18%."
> "We have 380M cash. Aggressive push could make us #1."
> "Risk: If it fails, we lose market position."

Always include specific numbers. No vague decisions.

---

## Outputting Choice Results

After player chooses, immediately output business tag with impacts:

**Player chooses to invest:**
```
> "Alright, let's go all in on the AI platform!"
> <Business:GOLDMANE:cash:-250|rd_progress:+35|influence:+8>
> "Project approved. 250M allocated. Development team assembled."
```

**Player chooses crisis response:**
```
> "Yes, launch the PR campaign immediately."
> <Business:LUXORIA:cash:-120|brand_value:+15>
> "Campaign launched. Media response improving."
```

**Player chooses aggressive expansion:**
```
> "Attack now while we have the cash."
> <Business:PFIZARA:cash:-200|market_share:+7|brand_value:+5>
> "Marketing blitz initiated. Early results promising."
```

**Player refuses/declines:**
```
> "Too risky. Let's wait."
> <Business:GOLDMANE:influence:-3>
> "Mirabel looks disappointed but nods."
```

**Random Event (no player choice):**
```
> News breaks: "Tech rival GUCCIEL launches competing product!"
> <Business:GOLDMANE:market_share:-5|revenue:-80>
> Mirabel grimaces. "This will hurt our Q3 numbers."
```

**IMPORTANT:**
- Output `<Business:TICKER:var:value|...>` tag BETWEEN narrative text
- Tag integrates naturally with the story flow
- System automatically displays update card and refreshes panel
- Use clear variable names: cash, debt, revenue, profit, market_share, brand_value, rd_progress, employees, influence

Always output business tag with clear numerical impacts when events affect the company.

{{/if_pure}}
