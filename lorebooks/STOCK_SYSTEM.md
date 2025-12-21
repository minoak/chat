{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}
@@depth 0

# Stock Trading System

Lily Valley Securities stock trading system. Enables stock investment gameplay.

---

## Stock List (20 stocks)

### Core Stocks (Character-linked)
| Ticker | Name | Sector | Connection |
|--------|------|--------|------------|
| GOLDMANE | Golden Mane Vault | Finance | Mirabel's Family |
| LUXORIA | Citadel of Luxury | Luxury | Cordelia's Family |
| PFIZARA | Alchemy Pharmaceuticals | Pharma | Nepenthes' Family |

### General Stocks
| Ticker | Name | Sector |
|--------|------|--------|
| TESLAM | Thunder Magitech | Tech |
| NVIDIUM | Holy Computing Crystal | Tech |
| ARCMED | Arcane Computing Workshop | Tech |
| INTELLUM | Crystal of Intellect | Tech |
| AMAZONIA | Great Forest Logistics Guild | Commerce |
| APPELLE | Forbidden Apple Trading Co. | Commerce |
| METARIX | Phantasmal Magic Circle | Illusion |
| NETHRYX | Crystal Ball Broadcasting | Illusion |
| MUTAGEN | Mutation Research Lab | Biotech |
| VITALIS | Life Force Elixir | Biotech |
| MORGANITE | Gemstone Finance Group | Finance |
| AEGIS | Shield Workshop | Defense |
| IRONFORGE | Iron Smithy | Manufacturing |
| GUCCIEL | Angel's Textile | Luxury |
| STARBREW | Starlight Brewery | Consumer |
| HARVESTIA | Blessing of Harvest | Consumer |
| STONECRAFT | Stonemason Guild | Construction |

---

## Current Stock Prices

When you need to show or reference stock prices, use these current values:

**Core Stocks:**
- GOLDMANE ({{getvar::stock_GOLDMANE_price}}G) - Golden Mane Vault
- LUXORIA ({{getvar::stock_LUXORIA_price}}G) - Citadel of Luxury
- PFIZARA ({{getvar::stock_PFIZARA_price}}G) - Alchemy Pharmaceuticals

**Tech Stocks:**
- TESLAM ({{getvar::stock_TESLAM_price}}G) - Thunder Magitech
- NVIDIUM ({{getvar::stock_NVIDIUM_price}}G) - Holy Computing Crystal
- ARCMED ({{getvar::stock_ARCMED_price}}G) - Arcane Computing Workshop
- INTELLUM ({{getvar::stock_INTELLUM_price}}G) - Crystal of Intellect

**Commerce:**
- AMAZONIA ({{getvar::stock_AMAZONIA_price}}G) - Great Forest Logistics Guild
- APPELLE ({{getvar::stock_APPELLE_price}}G) - Forbidden Apple Trading Co.

**Illusion/Media:**
- METARIX ({{getvar::stock_METARIX_price}}G) - Phantasmal Magic Circle
- NETHRYX ({{getvar::stock_NETHRYX_price}}G) - Crystal Ball Broadcasting

**Biotech:**
- MUTAGEN ({{getvar::stock_MUTAGEN_price}}G) - Mutation Research Lab
- VITALIS ({{getvar::stock_VITALIS_price}}G) - Life Force Elixir

**Finance:**
- MORGANITE ({{getvar::stock_MORGANITE_price}}G) - Gemstone Finance Group

**Defense/Manufacturing:**
- AEGIS ({{getvar::stock_AEGIS_price}}G) - Shield Workshop
- IRONFORGE ({{getvar::stock_IRONFORGE_price}}G) - Iron Smithy

**Luxury/Consumer:**
- GUCCIEL ({{getvar::stock_GUCCIEL_price}}G) - Angel's Textile
- STARBREW ({{getvar::stock_STARBREW_price}}G) - Starlight Brewery
- HARVESTIA ({{getvar::stock_HARVESTIA_price}}G) - Blessing of Harvest

**Construction:**
- STONECRAFT ({{getvar::stock_STONECRAFT_price}}G) - Stonemason Guild

---

## Tag Format

### Stock Update Tag

When showing stock market activity or checking prices, output `<Stock>` tag with current prices and market context:

```
<Stock>
GOLDMANE (Golden Mane Vault): 280G, rising - Quarterly earnings beat
MUTAGEN (Mutation Research Lab): 75G, falling - Clinical trial failure
TESLAM (Thunder Magitech): 250G, stable - Waiting for product launch
</Stock>
```

**How it works:**
- Your tags are displayed to the user as formatted HTML boxes
- The auxiliary model reads your tags and updates the game variables
- You focus on storytelling; auxiliary handles the system mechanics

### Trade Tags
```
[StockBuy:TICKER:PRICE:QTY]   - Buy
[StockSell:TICKER:PRICE:QTY]  - Sell
```

**When to output:**
- Output these tags when {{user}} makes buy/sell decisions in the narrative
- Tags will be shown to users as visual confirmation boxes
- The auxiliary model will process these to update portfolio and gold

---

## Lily Valley Index (Market Status)

### Index Levels
| Level | Index Range | State | Market Mood |
|-------|-------------|-------|-------------|
| Crisis | < 850 | Crash | Fear, panic selling, bankruptcies |
| Bear | 850~950 | Bearish | Anxiety, sell pressure |
| Stable | 950~1050 | Stable | Calm, wait-and-see |
| Bull | 1050~1150 | Bullish | Optimism, buy pressure |
| Boom | > 1150 | Boom | Euphoria, bubble warning |

- Base value: 1000
- Fluctuates based on current season/week

### Market Tags
```
[Market:INDEX:CHANGE:NEWS]  - Index update
```
Example: `[Market:1050:+2.5:Golden Mane Vault quarterly earnings beat]`

**Note**: Market index is displayed in the stock panel asset view. Do NOT output `<MarketPanel />` tag - it is no longer used.

### Market News Examples
- Bull: "GOLDMANE leads financial rally", "Magitech boom continues"
- Bear: "MUTAGEN clinical trial failure fallout", "Recession fears spread"
- Crisis: "Lily Valley crashes! Investors in chaos"

{{/if_pure}}
