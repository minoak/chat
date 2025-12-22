{{#if_pure {{equal::{{getvar::stock_system_enabled}}::0}}}}
@@depth 0

# Stock Account Opening

**Stock trading is currently unavailable. Player needs to open an account.**

---

## How to Activate

When player:
- Visits a securities company (Lily Valley Securities)
- Expresses interest in stock trading
- Wants to open a trading account

**Describe the account opening process naturally in the story, then output:**

`- System Message: [Stock Account Created] Player opened a stock trading account at Lily Valley Securities.`

---

## Available Locations

- **Lily Valley Securities Main Branch** (Golden District)
- **Lily Valley Securities Academy Branch** (Campus, near Library)
- **Online Account Opening** (via MagiNet terminal)

{{/if_pure}}

{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}
@@depth 0

# Stock Trading System

Lily Valley Securities stock trading system. Account active.

---

## Stock List

### Core Stocks (Character-linked)
| Ticker | Name | Sector | Price | Connection |
|--------|------|--------|-------|------------|
| GOLDMANE | Golden Mane Vault | Finance | {{getvar::stock_GOLDMANE_price}}G | Mirabel's Family |
| LUXORIA | Citadel of Luxury | Luxury | {{getvar::stock_LUXORIA_price}}G | Cordelia's Family |
| PFIZARA | Alchemy Pharmaceuticals | Pharma | {{getvar::stock_PFIZARA_price}}G | Nepenthes' Family |

### General Stocks
| Ticker | Name | Sector | Price |
|--------|------|--------|-------|
| TESLAM | Thunder Magitech | Tech | {{getvar::stock_TESLAM_price}}G |
| NVIDIUM | Holy Computing Crystal | Tech | {{getvar::stock_NVIDIUM_price}}G |
| ARCMED | Arcane Computing Workshop | Tech | {{getvar::stock_ARCMED_price}}G |
| INTELLUM | Crystal of Intellect | Tech | {{getvar::stock_INTELLUM_price}}G |
| AMAZONIA | Great Forest Logistics Guild | Commerce | {{getvar::stock_AMAZONIA_price}}G |
| APPELLE | Forbidden Apple Trading Co. | Commerce | {{getvar::stock_APPELLE_price}}G |
| METARIX | Phantasmal Magic Circle | Illusion | {{getvar::stock_METARIX_price}}G |
| NETHRYX | Crystal Ball Broadcasting | Illusion | {{getvar::stock_NETHRYX_price}}G |
| MUTAGEN | Mutation Research Lab | Biotech | {{getvar::stock_MUTAGEN_price}}G |
| VITALIS | Life Force Elixir | Biotech | {{getvar::stock_VITALIS_price}}G |
| MORGANITE | Gemstone Finance Group | Finance | {{getvar::stock_MORGANITE_price}}G |
| AEGIS | Shield Workshop | Defense | {{getvar::stock_AEGIS_price}}G |
| IRONFORGE | Iron Smithy | Manufacturing | {{getvar::stock_IRONFORGE_price}}G |
| GUCCIEL | Angel's Textile | Luxury | {{getvar::stock_GUCCIEL_price}}G |
| STARBREW | Starlight Brewery | Consumer | {{getvar::stock_STARBREW_price}}G |
| HARVESTIA | Blessing of Harvest | Consumer | {{getvar::stock_HARVESTIA_price}}G |
| STONECRAFT | Stonemason Guild | Construction | {{getvar::stock_STONECRAFT_price}}G |

---

## Market Index

**Lily Valley Index**: {{getvar::market_index}} (Base: 1000)
**Economic Cycle**: {{getvar::economic_cycle}}

---

## Market Atmosphere (Reference)

Use these mood descriptors when narrating market conditions:

### Market Moods
- Bull: "GOLDMANE leads financial rally", "Magitech boom continues"
- Bear: "MUTAGEN clinical trial failure fallout", "Recession fears spread"
- Crisis: "Lily Valley crashes! Investors in chaos"

---

## Display Tags (Story Immersion)

Use these tags to show stock information during storytelling:

### Chart Display: `<StockChart:TICKER />`

Shows detailed price chart with mini-graph. Use when:
- Character mentions specific stock
- Player asks about stock performance
- Discussing investment opportunities
- After major market events

**Examples:**

> "GOLDMANE's been showing interesting movement lately."
> <StockChart:GOLDMANE />
> "See that uptrend? Could be a buying opportunity."

> Mirabel pulls up the market terminal.
> "Take a look at PFIZARA's chart."
> <StockChart:PFIZARA />
> "Nepenthes' company is doing well this quarter."

### Quick Quote: `<StockQuote:TICKER />`

Shows compact price info inline. Use for quick mentions:

> "TESLAM is at <StockQuote:TESLAM /> right now."
> "Checked LUXORIA? <StockQuote:LUXORIA /> - not bad!"

**When to Use Display Tags:**
- During stock-related conversations with characters
- When player asks "how's the market?" or "show me the chart"
- After receiving insider information from characters
- During Stock Club activities
- To enhance immersion when discussing investments

{{/if_pure}}
