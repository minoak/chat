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

## Tag Format

### Trade Tags
```
[StockBuy:TICKER:PRICE:QTY]   - Buy
[StockSell:TICKER:PRICE:QTY]  - Sell
[Stock:TICKER:PRICE:CHANGE|...]  - Price update
```

### Display Tags
```
<StockChart:TICKER />  - Chart card
<StockQuote:TICKER />  - Inline quote
<StockPanel />         - Full panel
```

**Using Charts for Investment Decisions**:
Before presenting investment choices, show relevant chart data:
- **Pattern hints**: Display <StockChart:TICKER /> to show recent price trends
- **Context**: Let {{user}} analyze chart patterns before deciding
- **Example**: "Here's GOLDMANE's recent chart. Notice the trend?" <StockChart:GOLDMANE /> "Buy now, or wait?"

Charts display last 12 candles - enough to spot trends, support/resistance levels.

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

### Market Display
```
<MarketPanel />  - Market status panel (latest chat only)
```

### Market News Examples
- Bull: "GOLDMANE leads financial rally", "Magitech boom continues"
- Bear: "MUTAGEN clinical trial failure fallout", "Recession fears spread"
- Crisis: "Lily Valley crashes! Investors in chaos"

{{/if_pure}}
