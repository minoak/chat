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

When business decisions or events occur, output system message with clear impacts:

`- System Message: [TICKER] Event description. Numerical impacts.`

**Examples:**

**Investment:**
Current: Cash 500M, Debt 200M, R&D 45%
Decision: Major R&D investment
`- System Message: [GOLDMANE] AI Platform Development approved. Cash -300M, R&D +35%, influence +5.`

**Crisis:**
Current: Brand value 65, Revenue 800M
Event: Data breach scandal
`- System Message: [GOLDMANE] Data breach crisis. Brand value -20, revenue -150M, market share -4%.`

**Success:**
Current: R&D 90%, Market share 22%
Event: Product launch succeeds
`- System Message: [LUXORIA] Metaverse Fashion Line launch success. R&D complete, revenue +250M, market share +8%, brand value +12.`

**Competition:**
Current: Market share 23% (competitor 28%)
Decision: Aggressive marketing campaign
`- System Message: [PFIZARA] Direct competition attack initiated. Cash -180M, market share +6%, brand value +4.`

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

After player chooses, immediately output system message:

**Player chooses to invest:**
> "Alright, let's go all in on the AI platform!"
>
> `- System Message: [GOLDMANE] AI Platform Investment approved. Cash -250M, R&D +35%, influence +8%.`
>
> "Project approved. 250M allocated. Development team assembled."

**Player chooses crisis response:**
> "Yes, launch the PR campaign immediately."
>
> `- System Message: [LUXORIA] Emergency PR campaign launched. Cash -120M, brand value +15.`
>
> "Campaign launched. Media response improving."

**Player chooses aggressive expansion:**
> "Attack now while we have the cash."
>
> `- System Message: [PFIZARA] Market domination push initiated. Cash -200M, market share +7%, brand value +5.`
>
> "Marketing blitz initiated. Early results promising."

**Player refuses/declines:**
> "Too risky. Let's wait."
>
> `- System Message: [GOLDMANE] Investment declined. Influence -3.`
>
> "Mirabel looks disappointed but nods."

Always output system message with clear numerical impacts when choice affects company.

{{/if_pure}}
