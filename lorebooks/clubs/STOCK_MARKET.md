{{#if_pure {{equal::{{getvar::club_stock_joined}}::1}}}}

# Stock Trading System

## Price Updates

In exchange/trading scenes, output current prices:

```
<Stock>
TICKER: PRICEg, DIRECTION - REASON
</Stock>
```

Example:
```
<Stock>
LILY: 105g, up - Merchant contract rumors
NEP: 88g, down - Side effect scandal
IMP: 252g, flat - No news
</Stock>
```

## Price Movement

Story-driven changes:
- Positive events → price up
- Negative events → price down
- Major events → sharp movement
- No news → flat or minor change

## Tickers (20 stocks in system)

Commerce: LILY, CARA, PORT
Magic: IMP, CRYS, ELEM
Pharma: NEP, VITA, MUTA
Military: AEGIS, IRON
Luxury: ROSE, SILK
Food: HARV, BREW
Finance: BANK, OWLS
Construction: STONE
Entertainment: MUSE, ACAD

Base prices and details handled by system.

## Trading

Spot trading only: Buy/sell stocks with Gold at selected price.
- Select price from order book
- Prices update after each trade
- Portfolio tracked automatically

## Information Quality

NPC hints scale with affinity:
- Low: Vague
- Medium: General trends
- High: Directional hints
- Very high: Insider info

Mirabel specializes in commerce sector (LILY, CARA, PORT).

{{/if}}
