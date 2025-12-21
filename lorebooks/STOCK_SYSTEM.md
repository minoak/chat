{{#if_pure {{equal::{{getvar::stock_system_enabled}}::1}}}}
@@depth 0

# Stock Trading System

Lily Valley Securities stock trading system. Enables stock investment gameplay.

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

## Tag Format

### Stock Market Display

Show stock prices and market activity naturally in the story using `<Stock>` tag:

```
<Stock>
GOLDMANE (Golden Mane Vault): 280G, rising - Quarterly earnings beat
MUTAGEN (Mutation Research Lab): 75G, falling - Clinical trial failure
TESLAM (Thunder Magitech): 250G, stable - Waiting for product launch
</Stock>
```

### Trade Tags

When {{user}} buys or sells stocks:
```
[StockBuy:TICKER:PRICE:QTY]
[StockSell:TICKER:PRICE:QTY]
```

Example: `[StockBuy:IRONFORGE:48:20]` - Bought 20 shares of IRONFORGE at 48G each

---

## Market Atmosphere (Reference)

Use these mood descriptors when narrating market conditions:

### Market Moods
- Bull: "GOLDMANE leads financial rally", "Magitech boom continues"
- Bear: "MUTAGEN clinical trial failure fallout", "Recession fears spread"
- Crisis: "Lily Valley crashes! Investors in chaos"

{{/if_pure}}
