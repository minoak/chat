// V2 — DARK PRESS
// Dark Financial Times. Ink-black + salmon + ivory. Serif everywhere.
// Column rules, drop caps, bylines, small-caps section labels.

const pressStyles = {
  bg:        '#161210',
  panel:     '#1b1612',
  card:      '#221b16',
  cardHi:    '#2b2219',
  rule:      'rgba(240, 227, 204, 0.16)',
  ruleSoft:  'rgba(240, 227, 204, 0.08)',
  ruleHeavy: 'rgba(240, 227, 204, 0.30)',
  textHi:    '#f5e9d2',
  text:      '#ddc8a7',
  textDim:   '#9a8a72',
  textMute:  '#6e604c',
  salmon:    '#e8a679',     // FT signature, muted for dark
  salmonHi:  '#f4b88e',
  ivory:     '#f0e3cc',
  gold:      '#d4af6a',
  up:        '#d94c47',     // warm red (Korean ↑)
  down:      '#5e7a99',     // ink blue (↓)
  flat:      '#9a8a72',
  fontSerif: "'Noto Serif KR', Georgia, 'Times New Roman', 'Bodoni 72', serif",
  fontMono:  "'JetBrains Mono', 'IBM Plex Mono', Menlo, monospace",
};

const pressBg = {
  background: `
    radial-gradient(circle at 100% 0%, rgba(232, 166, 121, 0.06), transparent 50%),
    #161210
  `,
};

// Double rule divider — like a newspaper masthead.
const DoubleRule = ({ color = pressStyles.ruleHeavy }) => (
  <div style={{ position: 'relative', padding: '6px 0' }}>
    <div style={{ height: 1, background: color }} />
    <div style={{ height: 1, background: color, marginTop: 2 }} />
  </div>
);

// Single thin rule.
const Rule = ({ color = pressStyles.rule, mt = 0, mb = 0 }) => (
  <div style={{ height: 1, background: color, marginTop: mt, marginBottom: mb }} />
);

// Small-caps section label.
const PressLabel = ({ children, color = pressStyles.salmon, align = 'left' }) => (
  <div style={{
    fontFamily: pressStyles.fontSerif,
    fontSize: 10.5, letterSpacing: '0.32em', textTransform: 'uppercase',
    color, fontVariant: 'small-caps', fontWeight: 600,
    textAlign: align, marginBottom: 10,
  }}>
    {children}
  </div>
);

const PressKicker = ({ children, color = pressStyles.salmon }) => (
  <div style={{
    fontFamily: pressStyles.fontMono, fontSize: 9, letterSpacing: '0.34em',
    textTransform: 'uppercase', color, marginBottom: 6,
  }}>
    {children}
  </div>
);

// Direction marker.
const PressArrow = ({ dir, color }) => {
  if (dir === 0) return <span style={{ color, fontFamily: pressStyles.fontSerif }}>—</span>;
  return <span style={{ color }}>{dir > 0 ? '▲' : '▼'}</span>;
};

// ────────────────────────────────────────────────────────────────
// Shell
// ────────────────────────────────────────────────────────────────

function PressShell({ activeTab, children }) {
  const tabs = [
    { id: 'board',    kor: '시세', eng: 'Quotes',   no: 'I'   },
    { id: 'chart',    kor: '차트', eng: 'Chart',    no: 'II'  },
    { id: 'asset',    kor: '자산', eng: 'Holdings', no: 'III' },
    { id: 'business', kor: '경영', eng: 'Ventures', no: 'IV'  },
  ];
  return (
    <div style={{
      ...pressBg,
      width: '100%', minHeight: '100%',
      fontFamily: pressStyles.fontSerif,
      color: pressStyles.text,
    }}>
      {/* Masthead */}
      <div style={{ padding: '22px 24px 14px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
          <div style={{
            fontFamily: pressStyles.fontMono, fontSize: 9, letterSpacing: '0.32em',
            color: pressStyles.salmon, textTransform: 'uppercase',
          }}>
            Vol. III · No. 142
          </div>
          <div style={{
            fontFamily: pressStyles.fontMono, fontSize: 9, letterSpacing: '0.24em',
            color: pressStyles.textDim, textTransform: 'uppercase',
          }}>
            Friday, 3 Octrose · Late Edition
          </div>
        </div>

        <Rule color={pressStyles.rule} mt={10} mb={14} />

        <div style={{ textAlign: 'center' }}>
          <div style={{
            fontFamily: pressStyles.fontSerif, fontSize: 36, fontWeight: 600,
            color: pressStyles.ivory, letterSpacing: '0.01em',
            lineHeight: 1, fontStyle: 'italic',
          }}>
            The Lilybelly <span style={{ color: pressStyles.salmon }}>Ledger</span>
          </div>
          <div style={{
            marginTop: 8, fontFamily: pressStyles.fontSerif, fontStyle: 'italic',
            fontSize: 12, color: pressStyles.textDim, letterSpacing: '0.04em',
          }}>
            “Fortunes told in figures, since the year of three suns”
          </div>
        </div>

        <DoubleRule />
      </div>

      {/* Balance bar (sub-masthead) */}
      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'center',
        padding: '0 24px 14px',
      }}>
        <div>
          <PressKicker>The Reader's Account</PressKicker>
          <div style={{
            fontFamily: pressStyles.fontSerif, fontSize: 13, color: pressStyles.text,
          }}>
            Held in cash <span style={{ color: pressStyles.gold, fontWeight: 600 }}>{fmt(PLAYER_GOLD)} G</span>
          </div>
        </div>
        <div style={{
          fontFamily: pressStyles.fontMono, fontSize: 10, letterSpacing: '0.22em',
          color: pressStyles.salmon, padding: '6px 12px',
          border: `1px solid ${pressStyles.salmon}`, cursor: 'pointer',
        }}>
          ▲ FOLD
        </div>
      </div>

      {/* Tab bar — newspaper section index */}
      <div style={{
        display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)',
        borderTop: `1px solid ${pressStyles.rule}`,
        borderBottom: `1px solid ${pressStyles.rule}`,
        background: pressStyles.panel,
      }}>
        {tabs.map((t, i) => {
          const active = t.id === activeTab;
          return (
            <div key={t.id} style={{
              padding: '14px 8px 12px',
              borderRight: i < tabs.length - 1 ? `1px solid ${pressStyles.ruleSoft}` : 'none',
              background: active ? 'rgba(232,166,121,0.07)' : 'transparent',
              textAlign: 'center', position: 'relative',
            }}>
              <div style={{
                fontFamily: pressStyles.fontMono, fontSize: 8.5, letterSpacing: '0.32em',
                color: active ? pressStyles.salmon : pressStyles.textMute,
              }}>
                SECT. {t.no}
              </div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 16,
                color: active ? pressStyles.ivory : pressStyles.text,
                fontStyle: active ? 'italic' : 'normal',
                marginTop: 4, fontWeight: active ? 600 : 400,
              }}>
                {t.kor}
              </div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontStyle: 'italic',
                fontSize: 10.5, color: pressStyles.textDim, marginTop: 2,
              }}>
                {t.eng}
              </div>
              {active && (
                <div style={{
                  position: 'absolute', left: '20%', right: '20%', bottom: -1, height: 2,
                  background: pressStyles.salmon,
                }} />
              )}
            </div>
          );
        })}
      </div>

      {/* View body */}
      <div style={{ padding: '22px 24px 0' }}>
        {children}
      </div>

      {/* Footer / colophon */}
      <div style={{
        marginTop: 24, padding: '14px 24px 18px',
        borderTop: `2px double ${pressStyles.rule}`,
        background: pressStyles.panel,
        display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      }}>
        <div style={{
          fontFamily: pressStyles.fontSerif, fontStyle: 'italic',
          fontSize: 10.5, color: pressStyles.textMute, letterSpacing: '0.06em',
        }}>
          — End of session edition —
        </div>
        <div style={{
          fontFamily: pressStyles.fontSerif, fontSize: 12, letterSpacing: '0.16em',
          color: pressStyles.salmon, padding: '8px 18px',
          border: `1px solid ${pressStyles.salmon}`,
          fontVariant: 'small-caps',
        }}>
          거래 종료
        </div>
      </div>
    </div>
  );
}

// ────────────────────────────────────────────────────────────────
// BOARD
// ────────────────────────────────────────────────────────────────

function PressBoard() {
  const own = Object.fromEntries(HOLDINGS.map((h) => [h.id, h.qty]));
  const lead = NEWS[0];
  const leadC = lead.dir === 'rising' ? pressStyles.up : pressStyles.down;

  return (
    <>
      {/* Lead story */}
      <PressLabel>Market Intelligence · Page 1</PressLabel>
      <div style={{
        padding: '16px 18px 18px',
        background: pressStyles.card,
        borderLeft: `3px double ${leadC}`,
        marginBottom: 18,
      }}>
        <div style={{
          fontFamily: pressStyles.fontMono, fontSize: 9, letterSpacing: '0.3em',
          color: leadC, marginBottom: 8,
        }}>
          <PressArrow dir={1} color={leadC} /> &nbsp; {lead.ticker} &nbsp;·&nbsp; {lead.dir.toUpperCase()}
        </div>
        <div style={{
          fontFamily: pressStyles.fontSerif, fontSize: 17, fontWeight: 600,
          color: pressStyles.ivory, lineHeight: 1.35, letterSpacing: '-0.005em',
        }}>
          <span style={{
            float: 'left', fontSize: 38, lineHeight: 0.95, marginRight: 6,
            color: pressStyles.salmon, fontStyle: 'italic',
            fontFamily: pressStyles.fontSerif,
          }}>“</span>
          {lead.text.split(' • ')[0]}
        </div>
        <div style={{
          marginTop: 8, fontFamily: pressStyles.fontSerif, fontSize: 12,
          color: pressStyles.text, lineHeight: 1.55, fontStyle: 'italic',
        }}>
          {lead.text.split(' • ').slice(1).join(' · ')}
        </div>
        <div style={{
          marginTop: 12, paddingTop: 8, borderTop: `1px solid ${pressStyles.ruleSoft}`,
          fontFamily: pressStyles.fontSerif, fontStyle: 'italic',
          fontSize: 10.5, color: pressStyles.textDim,
        }}>
          — By the Markets Desk
        </div>
      </div>

      {/* Secondary briefs */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14, marginBottom: 22 }}>
        {NEWS.slice(1, 3).map((n) => {
          const isUp = n.dir === 'rising' || n.dir === 'up';
          const c = isUp ? pressStyles.up : pressStyles.down;
          return (
            <div key={n.ticker} style={{
              borderTop: `1px solid ${pressStyles.rule}`,
              paddingTop: 8,
            }}>
              <div style={{
                fontFamily: pressStyles.fontMono, fontSize: 8.5, letterSpacing: '0.28em',
                color: c, marginBottom: 4,
              }}>
                {n.ticker}
              </div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 12.5, lineHeight: 1.45,
                color: pressStyles.text, fontWeight: 500,
              }}>
                {n.text.split(' • ')[0]}
              </div>
            </div>
          );
        })}
      </div>

      <DoubleRule />

      {/* Quote table */}
      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
        marginTop: 14, marginBottom: 10,
      }}>
        <div>
          <PressLabel>The Quotations Page</PressLabel>
        </div>
        <div style={{
          fontFamily: pressStyles.fontSerif, fontStyle: 'italic',
          fontSize: 10.5, color: pressStyles.textDim,
        }}>
          Closing values, in gold
        </div>
      </div>

      {/* Column header */}
      <div style={{
        display: 'grid', gridTemplateColumns: '2fr 1fr 1fr 0.8fr',
        padding: '6px 0',
        borderTop: `1px solid ${pressStyles.rule}`,
        borderBottom: `1px solid ${pressStyles.rule}`,
        fontFamily: pressStyles.fontSerif, fontSize: 10, fontVariant: 'small-caps',
        letterSpacing: '0.28em', color: pressStyles.textDim,
      }}>
        <div>Issue</div>
        <div style={{ textAlign: 'right' }}>Close</div>
        <div style={{ textAlign: 'right' }}>Change</div>
        <div style={{ textAlign: 'right' }}>Held</div>
      </div>

      {TICKERS.slice(0, 8).map((t, i) => {
        const dir = t.change > 0 ? 1 : (t.change < 0 ? -1 : 0);
        const c = dir > 0 ? pressStyles.up : (dir < 0 ? pressStyles.down : pressStyles.flat);
        const pct = (t.change / (t.price - t.change)) * 100;
        const qty = own[t.id] || 0;
        return (
          <div key={t.id} style={{
            display: 'grid', gridTemplateColumns: '2fr 1fr 1fr 0.8fr', gap: 6,
            padding: '11px 0', alignItems: 'baseline',
            borderBottom: `1px dotted ${pressStyles.ruleSoft}`,
          }}>
            <div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 14, fontWeight: 600,
                color: pressStyles.ivory,
              }}>
                {t.name}
              </div>
              <div style={{
                fontFamily: pressStyles.fontMono, fontSize: 9, letterSpacing: '0.18em',
                color: pressStyles.textDim, marginTop: 2,
              }}>
                {t.id} · {t.sector}
              </div>
            </div>
            <div style={{
              textAlign: 'right', fontFamily: pressStyles.fontSerif,
              fontSize: 16, fontWeight: 500, color: pressStyles.ivory,
              fontVariantNumeric: 'tabular-nums',
            }}>
              {fmt(t.price)}
            </div>
            <div style={{
              textAlign: 'right', fontFamily: pressStyles.fontSerif, fontSize: 13,
              color: c, fontVariantNumeric: 'tabular-nums',
            }}>
              <PressArrow dir={dir} color={c} /> {signed(pct)}%
            </div>
            <div style={{
              textAlign: 'right', fontFamily: pressStyles.fontSerif, fontSize: 13,
              color: qty > 0 ? pressStyles.gold : pressStyles.textMute,
              fontStyle: qty > 0 ? 'normal' : 'italic',
              fontVariantNumeric: 'tabular-nums',
            }}>
              {qty > 0 ? qty : '—'}
            </div>
          </div>
        );
      })}
    </>
  );
}

// ────────────────────────────────────────────────────────────────
// CHART
// ────────────────────────────────────────────────────────────────

function PressChart() {
  const t = TICKERS.find((x) => x.id === 'NVIDIUM');
  const hist = HISTORY.NVIDIUM;
  const pct = (t.change / (t.price - t.change)) * 100;
  const c = pressStyles.up;
  const info = {
    desc: '제국 마법공학 칩 설계의 절대 강자. 군부와 다년간 독점 공급 계약을 유지하며, 분기마다 마나 효율의 새 기준을 제시해 왔다.',
    sector: 'Tech', size: '대형', financial: '성장', volatility: '중',
    up: '신제품 발표, 군부 수주, 마나 효율 개선',
    down: '경쟁사 공정 추월, 핵심 인력 이탈',
    insider: 'Astrid von Synth',
  };

  const W = 420, H = 150;
  const min = Math.min(...hist) - 30, max = Math.max(...hist) + 30;
  const range = max - min;
  const pts = hist.map((v, i) => {
    const x = (i / (hist.length - 1)) * W;
    const y = H - ((v - min) / range) * H;
    return [x, y];
  });
  const linePts = pts.map(([x, y]) => `${x.toFixed(1)},${y.toFixed(1)}`).join(' ');
  const last = pts[pts.length - 1];

  return (
    <>
      <PressLabel>The Featured Issue</PressLabel>

      {/* Issue header */}
      <div style={{
        display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between',
        marginBottom: 6, gap: 12,
      }}>
        <div>
          <div style={{
            fontFamily: pressStyles.fontMono, fontSize: 9, letterSpacing: '0.32em',
            color: pressStyles.salmon, marginBottom: 4,
          }}>
            {t.id} · LILYBELLY {info.sector.toUpperCase()}
          </div>
          <div style={{
            fontFamily: pressStyles.fontSerif, fontSize: 28, fontWeight: 600,
            color: pressStyles.ivory, lineHeight: 1.05, fontStyle: 'italic',
            letterSpacing: '-0.005em',
          }}>
            {t.name}
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div style={{
            fontFamily: pressStyles.fontSerif, fontSize: 30, fontWeight: 600,
            color: c, lineHeight: 1, fontVariantNumeric: 'tabular-nums',
          }}>
            {fmt(t.price)}<span style={{ fontSize: 14, color: pressStyles.textDim, marginLeft: 4, fontWeight: 400 }}>G</span>
          </div>
          <div style={{
            fontFamily: pressStyles.fontSerif, fontSize: 13, color: c, marginTop: 2,
            fontVariantNumeric: 'tabular-nums',
          }}>
            <PressArrow dir={1} color={c} /> {signed(t.change, 0)} · {signed(pct)}%
          </div>
        </div>
      </div>

      <DoubleRule />

      {/* Chart panel */}
      <div style={{
        padding: '14px 14px 12px', marginTop: 14, marginBottom: 16,
        background: pressStyles.card, border: `1px solid ${pressStyles.rule}`,
      }}>
        <div style={{ display: 'flex' }}>
          <div style={{
            width: 44, display: 'flex', flexDirection: 'column',
            justifyContent: 'space-between', paddingRight: 6,
            fontFamily: pressStyles.fontSerif, fontSize: 10, color: pressStyles.textDim,
            fontVariantNumeric: 'tabular-nums', textAlign: 'right', fontStyle: 'italic',
          }}>
            <span>{Math.round(max)}</span>
            <span>{Math.round(max - range * 0.5)}</span>
            <span>{Math.round(min)}</span>
          </div>
          <div style={{ flex: 1, position: 'relative' }}>
            <svg width="100%" viewBox={`0 0 ${W} ${H}`} preserveAspectRatio="none" style={{ display: 'block' }}>
              <defs>
                <pattern id="press-hatch" patternUnits="userSpaceOnUse" width="4" height="4" patternTransform="rotate(45)">
                  <line x1="0" y1="0" x2="0" y2="4" stroke={pressStyles.salmon} strokeOpacity="0.12" strokeWidth="1" />
                </pattern>
              </defs>
              {/* horizontal rules */}
              {[0, 0.5, 1].map((p) => (
                <line key={p} x1="0" y1={H * p} x2={W} y2={H * p}
                  stroke={pressStyles.ruleSoft} strokeWidth="1" />
              ))}
              {/* hatched fill below line */}
              <polygon points={`0,${H} ${linePts} ${W},${H}`} fill="url(#press-hatch)" />
              {/* main line */}
              <polyline points={linePts} fill="none" stroke={c} strokeWidth="1.5" />
              {/* end dot */}
              <circle cx={last[0]} cy={last[1]} r="3" fill={c} />
            </svg>
            <div style={{
              display: 'flex', justifyContent: 'space-between', marginTop: 6,
              fontFamily: pressStyles.fontSerif, fontStyle: 'italic', fontSize: 10,
              color: pressStyles.textMute,
            }}>
              <span>09:00</span><span>12:00</span><span>15:00</span><span>close</span>
            </div>
          </div>
        </div>

        {/* OHLC strip in serif */}
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)',
          marginTop: 12, paddingTop: 10,
          borderTop: `1px solid ${pressStyles.ruleSoft}`,
          gap: 8,
        }}>
          {[
            ['시 가', hist[0], pressStyles.text],
            ['고 가', Math.max(...hist), pressStyles.up],
            ['저 가', Math.min(...hist), pressStyles.down],
            ['기준', 3000, pressStyles.textDim],
          ].map(([k, v, col], i) => (
            <div key={i} style={{ borderRight: i < 3 ? `1px solid ${pressStyles.ruleSoft}` : 'none', paddingRight: 4 }}>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 9.5, fontVariant: 'small-caps',
                letterSpacing: '0.28em', color: pressStyles.textDim,
              }}>{k}</div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 15, color: col,
                marginTop: 3, fontVariantNumeric: 'tabular-nums', fontWeight: 500,
              }}>{fmt(v)}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Dossier — newspaper article style */}
      <PressLabel>The Issuer · An Editor's Note</PressLabel>
      <div style={{
        columnCount: 1, fontFamily: pressStyles.fontSerif,
        fontSize: 13, lineHeight: 1.65, color: pressStyles.text,
        marginBottom: 14,
      }}>
        <span style={{
          float: 'left', fontFamily: pressStyles.fontSerif, fontSize: 44,
          lineHeight: 0.85, color: pressStyles.salmon, fontStyle: 'italic',
          marginRight: 8, marginTop: 2,
        }}>
          제
        </span>
        {info.desc}
      </div>

      {/* Tag strip */}
      <div style={{
        display: 'flex', flexWrap: 'wrap', gap: 14,
        padding: '10px 0', borderTop: `1px solid ${pressStyles.rule}`,
        borderBottom: `1px solid ${pressStyles.rule}`, marginBottom: 14,
      }}>
        {[
          ['부문', info.sector], ['규모', info.size],
          ['재무', info.financial], ['변동성', info.volatility],
        ].map(([k, v], i) => (
          <div key={i}>
            <div style={{
              fontFamily: pressStyles.fontSerif, fontSize: 9, fontVariant: 'small-caps',
              letterSpacing: '0.28em', color: pressStyles.textDim,
            }}>{k}</div>
            <div style={{
              fontFamily: pressStyles.fontSerif, fontSize: 13, color: pressStyles.ivory,
              marginTop: 2, fontWeight: 500,
            }}>{v}</div>
          </div>
        ))}
      </div>

      {/* Up/down notes */}
      <div style={{ marginBottom: 14 }}>
        <div style={{ display: 'flex', gap: 10, marginBottom: 8 }}>
          <span style={{ color: pressStyles.up, fontFamily: pressStyles.fontSerif, fontWeight: 700 }}>▲</span>
          <div style={{ fontFamily: pressStyles.fontSerif, fontSize: 12, color: pressStyles.text, fontStyle: 'italic' }}>{info.up}</div>
        </div>
        <div style={{ display: 'flex', gap: 10 }}>
          <span style={{ color: pressStyles.down, fontFamily: pressStyles.fontSerif, fontWeight: 700 }}>▼</span>
          <div style={{ fontFamily: pressStyles.fontSerif, fontSize: 12, color: pressStyles.text, fontStyle: 'italic' }}>{info.down}</div>
        </div>
      </div>

      <div style={{
        padding: '10px 12px',
        background: pressStyles.cardHi,
        borderLeft: `2px solid ${pressStyles.gold}`,
        fontFamily: pressStyles.fontSerif, fontSize: 11.5, fontStyle: 'italic',
        color: pressStyles.text,
      }}>
        — Insider sources name <span style={{ color: pressStyles.gold, fontWeight: 600, fontStyle: 'normal' }}>{info.insider}</span> as the issue's principal voice.
      </div>

      {/* Switcher */}
      <PressLabel align="left">Other Issues</PressLabel>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
        {TICKERS.slice(0, 6).map((x) => {
          const sel = x.id === t.id;
          const xc = x.change > 0 ? pressStyles.up : (x.change < 0 ? pressStyles.down : pressStyles.flat);
          const xpct = (x.change / (x.price - x.change)) * 100;
          return (
            <div key={x.id} style={{
              padding: '6px 10px',
              background: sel ? pressStyles.cardHi : 'transparent',
              border: `1px solid ${sel ? pressStyles.salmon : pressStyles.ruleSoft}`,
            }}>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 11, fontWeight: 600,
                color: sel ? pressStyles.ivory : pressStyles.text,
              }}>
                {x.id}
              </div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 10, color: xc,
                fontVariantNumeric: 'tabular-nums', marginTop: 1,
              }}>
                {signed(xpct)}%
              </div>
            </div>
          );
        })}
      </div>
    </>
  );
}

// ────────────────────────────────────────────────────────────────
// ASSET
// ────────────────────────────────────────────────────────────────

function PressAsset() {
  const lookup = Object.fromEntries(TICKERS.map((t) => [t.id, t]));
  let stockValue = 0, totalProfit = 0;
  const holds = HOLDINGS.map((h) => {
    const t = lookup[h.id];
    const value = t.price * h.qty;
    const profit = (t.price - h.avg) * h.qty;
    const pct = ((t.price - h.avg) / h.avg) * 100;
    stockValue += value; totalProfit += profit;
    return { ...h, name: t.name, currentPrice: t.price, value, profit, pct };
  });
  const totalValue = PLAYER_GOLD + stockValue;
  const totalPct = stockValue > 0 ? (totalProfit / (stockValue - totalProfit)) * 100 : 0;

  return (
    <>
      <PressLabel>The Lilybelly Index</PressLabel>
      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end',
        padding: '12px 16px', marginBottom: 16,
        background: pressStyles.card, border: `1px solid ${pressStyles.rule}`,
      }}>
        <div>
          <div style={{
            fontFamily: pressStyles.fontMono, fontSize: 9, letterSpacing: '0.32em',
            color: pressStyles.salmon,
          }}>LBLY · COMPOSITE</div>
          <div style={{
            fontFamily: pressStyles.fontSerif, fontSize: 30, fontWeight: 600,
            color: pressStyles.ivory, marginTop: 4, fontVariantNumeric: 'tabular-nums',
            letterSpacing: '-0.01em',
          }}>{fmt(MARKET_INDEX.value)}<span style={{ color: pressStyles.textDim, fontSize: 18 }}>.{(MARKET_INDEX.value % 1).toFixed(1).slice(2)}</span></div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div style={{
            fontFamily: pressStyles.fontSerif, fontSize: 18,
            color: pressStyles.up, fontVariantNumeric: 'tabular-nums',
          }}>▲ {signed(MARKET_INDEX.change, 2)}%</div>
          <div style={{
            fontFamily: pressStyles.fontSerif, fontStyle: 'italic',
            fontSize: 10.5, color: pressStyles.textDim, marginTop: 2,
          }}>compared with prior session</div>
        </div>
      </div>

      {/* Net worth (banner) */}
      <DoubleRule />
      <div style={{
        padding: '18px 0', textAlign: 'center', marginBottom: 6,
      }}>
        <div style={{
          fontFamily: pressStyles.fontSerif, fontStyle: 'italic',
          fontSize: 11, color: pressStyles.textDim, fontVariant: 'small-caps',
          letterSpacing: '0.32em', marginBottom: 8,
        }}>
          The reader's estate, valued
        </div>
        <div style={{
          fontFamily: pressStyles.fontSerif, fontSize: 48, fontWeight: 600,
          color: pressStyles.ivory, lineHeight: 1, fontVariantNumeric: 'tabular-nums',
          letterSpacing: '-0.01em',
        }}>
          {fmt(totalValue)}<span style={{ color: pressStyles.salmon, fontSize: 22, marginLeft: 6, fontStyle: 'italic' }}>G</span>
        </div>
        <div style={{
          marginTop: 14, display: 'flex', justifyContent: 'center', gap: 36,
        }}>
          <div style={{ textAlign: 'center' }}>
            <div style={{
              fontFamily: pressStyles.fontSerif, fontSize: 9.5, fontVariant: 'small-caps',
              letterSpacing: '0.28em', color: pressStyles.textDim,
            }}>총 손익</div>
            <div style={{
              fontFamily: pressStyles.fontSerif, fontSize: 17, color: pressStyles.up,
              marginTop: 4, fontVariantNumeric: 'tabular-nums',
            }}>▲ {signed(totalProfit, 0)} G</div>
          </div>
          <div style={{ width: 1, background: pressStyles.rule }} />
          <div style={{ textAlign: 'center' }}>
            <div style={{
              fontFamily: pressStyles.fontSerif, fontSize: 9.5, fontVariant: 'small-caps',
              letterSpacing: '0.28em', color: pressStyles.textDim,
            }}>수익률</div>
            <div style={{
              fontFamily: pressStyles.fontSerif, fontSize: 17, color: pressStyles.up,
              marginTop: 4, fontVariantNumeric: 'tabular-nums',
            }}>{signed(totalPct)}%</div>
          </div>
        </div>
      </div>
      <DoubleRule />

      {/* Allocation */}
      <PressLabel>Composition</PressLabel>
      <div style={{ display: 'flex', gap: 18, marginBottom: 18 }}>
        {[
          { label: '현금', en: 'Cash', v: PLAYER_GOLD, color: pressStyles.gold },
          { label: '주식', en: 'Equity', v: stockValue, color: pressStyles.salmon },
        ].map((r, i) => {
          const p = (r.v / totalValue) * 100;
          return (
            <div key={i} style={{ flex: 1, borderTop: `2px solid ${r.color}`, paddingTop: 8 }}>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 9.5, fontVariant: 'small-caps',
                letterSpacing: '0.28em', color: pressStyles.textDim,
              }}>{r.label} · {r.en}</div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 22, color: pressStyles.ivory,
                marginTop: 4, fontVariantNumeric: 'tabular-nums', fontWeight: 500,
              }}>{fmt(r.v)}<span style={{ fontSize: 11, color: pressStyles.textDim, marginLeft: 4 }}>G</span></div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontStyle: 'italic',
                fontSize: 11, color: r.color, marginTop: 2,
              }}>{p.toFixed(1)}% of estate</div>
            </div>
          );
        })}
      </div>

      {/* Holdings table */}
      <PressLabel>Holdings · {holds.length} issues on the books</PressLabel>
      <div style={{ borderTop: `1px solid ${pressStyles.rule}`, borderBottom: `1px solid ${pressStyles.rule}` }}>
        {holds.map((h, i) => {
          const pc = h.profit >= 0 ? pressStyles.up : pressStyles.down;
          return (
            <div key={h.id} style={{
              display: 'flex', padding: '14px 0', alignItems: 'baseline',
              borderBottom: i < holds.length - 1 ? `1px dotted ${pressStyles.ruleSoft}` : 'none',
            }}>
              <div style={{ flex: 1 }}>
                <div style={{
                  fontFamily: pressStyles.fontSerif, fontSize: 15, fontWeight: 600,
                  color: pressStyles.ivory,
                }}>{h.name}</div>
                <div style={{
                  fontFamily: pressStyles.fontSerif, fontStyle: 'italic',
                  fontSize: 10.5, color: pressStyles.textDim, marginTop: 2,
                }}>{h.id} · {h.qty}주 held at avg {fmt(h.avg)} G</div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{
                  fontFamily: pressStyles.fontSerif, fontSize: 15, fontWeight: 500,
                  color: pressStyles.ivory, fontVariantNumeric: 'tabular-nums',
                }}>{fmt(h.value)} G</div>
                <div style={{
                  fontFamily: pressStyles.fontSerif, fontSize: 11.5, color: pc,
                  marginTop: 2, fontVariantNumeric: 'tabular-nums',
                }}>
                  {h.profit >= 0 ? '▲' : '▼'} {signed(h.profit, 0)} · {signed(h.pct)}%
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </>
  );
}

// ────────────────────────────────────────────────────────────────
// BUSINESS
// ────────────────────────────────────────────────────────────────

function PressBusiness() {
  return (
    <>
      <PressLabel>The Reader's Ventures · {COMPANIES.length} Concerns</PressLabel>

      {COMPANIES.map((co, idx) => {
        const profitMargin = co.revenue > 0 ? Math.floor((co.profit / co.revenue) * 100) : 0;
        const debtRatio = Math.floor((co.debt / (co.cash + co.revenue)) * 100);
        const profitC = co.profit >= 0 ? pressStyles.up : pressStyles.down;
        const debtC = debtRatio > 70 ? pressStyles.up : (debtRatio > 40 ? pressStyles.gold : pressStyles.text);
        const stockPrice = TICKERS.find((t) => t.id === co.ticker)?.price || 0;

        const Delta = ({ v, suffix = '' }) => {
          if (v === 0) return <span style={{ color: pressStyles.textMute, fontSize: 10, marginLeft: 4 }}> →0</span>;
          const c = v > 0 ? pressStyles.up : pressStyles.down;
          return <span style={{ color: c, fontSize: 10, marginLeft: 4, fontFamily: pressStyles.fontSerif, fontVariantNumeric: 'tabular-nums' }}>{v > 0 ? '▲' : '▼'}{signed(v, 0)}{suffix}</span>;
        };

        return (
          <div key={co.ticker} style={{
            marginBottom: idx < COMPANIES.length - 1 ? 26 : 6,
            paddingBottom: idx < COMPANIES.length - 1 ? 22 : 0,
            borderBottom: idx < COMPANIES.length - 1 ? `2px double ${pressStyles.rule}` : 'none',
          }}>
            {/* Headline */}
            <div style={{ textAlign: 'center', marginBottom: 14 }}>
              <div style={{
                fontFamily: pressStyles.fontMono, fontSize: 9, letterSpacing: '0.34em',
                color: pressStyles.salmon,
              }}>
                {co.ticker} · {co.sector.toUpperCase()}
              </div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 24, fontWeight: 600,
                fontStyle: 'italic', color: pressStyles.ivory, marginTop: 6, lineHeight: 1.1,
              }}>
                {co.name}
              </div>
              <div style={{
                fontFamily: pressStyles.fontSerif, fontSize: 11.5, color: pressStyles.textDim,
                marginTop: 6, fontStyle: 'italic',
              }}>
                in partnership with <span style={{ color: pressStyles.gold, fontStyle: 'normal' }}>{co.character}</span>
              </div>
            </div>

            <Rule color={pressStyles.rule} mb={12} />

            {/* Financial table */}
            <PressKicker color={pressStyles.salmon}>Financial standing · in millions</PressKicker>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', columnGap: 18, rowGap: 10, marginBottom: 16 }}>
              {[
                { k: '매출 Revenue',     v: co.revenue, ch: co.revenueChange, suf: 'M', col: pressStyles.ivory },
                { k: `순이익 Profit  ${profitMargin}%`, v: co.profit, ch: co.profitChange, suf: 'M', col: profitC },
                { k: '현금 Cash',        v: co.cash,    ch: co.cashChange,    suf: 'M', col: pressStyles.gold },
                { k: `부채 Debt  ${debtRatio}%`, v: co.debt, ch: co.debtChange, suf: 'M', col: debtC },
              ].map((m, i) => (
                <div key={i} style={{ borderTop: `1px solid ${pressStyles.ruleSoft}`, paddingTop: 6 }}>
                  <div style={{
                    fontFamily: pressStyles.fontSerif, fontSize: 10, fontVariant: 'small-caps',
                    letterSpacing: '0.24em', color: pressStyles.textDim,
                  }}>{m.k}</div>
                  <div style={{
                    fontFamily: pressStyles.fontSerif, fontSize: 19, color: m.col,
                    marginTop: 3, fontVariantNumeric: 'tabular-nums', fontWeight: 500,
                  }}>
                    {fmt(m.v)}{m.suf}<Delta v={m.ch} suffix={m.suf} />
                  </div>
                </div>
              ))}
            </div>

            {/* Market table */}
            <PressKicker color={pressStyles.salmon}>Market position</PressKicker>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', columnGap: 18, rowGap: 10, marginBottom: 16 }}>
              {[
                { k: '시장점유율',  v: `${co.market_share}%`, ch: co.market_share_change, suf: '%', col: pressStyles.salmonHi },
                { k: '브랜드가치',  v: fmt(co.brand_value),   ch: co.brand_value_change,  suf: '',  col: pressStyles.gold },
                { k: '주가',       v: `${fmt(stockPrice)} G`, col: pressStyles.up },
                { k: '직원',       v: `${fmt(co.employees)} 명`, col: pressStyles.text },
              ].map((m, i) => (
                <div key={i} style={{ borderTop: `1px solid ${pressStyles.ruleSoft}`, paddingTop: 6 }}>
                  <div style={{
                    fontFamily: pressStyles.fontSerif, fontSize: 10, fontVariant: 'small-caps',
                    letterSpacing: '0.24em', color: pressStyles.textDim,
                  }}>{m.k}</div>
                  <div style={{
                    fontFamily: pressStyles.fontSerif, fontSize: 17, color: m.col,
                    marginTop: 3, fontVariantNumeric: 'tabular-nums', fontWeight: 500,
                  }}>
                    {m.v}{m.ch !== undefined && <Delta v={m.ch} suffix={m.suf} />}
                  </div>
                </div>
              ))}
            </div>

            {/* Ownership */}
            <PressKicker color={pressStyles.salmon}>Ownership · the reader holds {co.player_share}%</PressKicker>
            <div style={{ display: 'flex', height: 14, border: `1px solid ${pressStyles.rule}`, marginTop: 4 }}>
              <div style={{ width: `${co.player_share}%`, background: pressStyles.gold }} />
              <div style={{
                flex: 1,
                background: `repeating-linear-gradient(45deg, transparent, transparent 3px, ${pressStyles.ruleSoft} 3px, ${pressStyles.ruleSoft} 4px)`,
              }} />
            </div>
            <div style={{
              display: 'flex', justifyContent: 'space-between', marginTop: 6,
              fontFamily: pressStyles.fontSerif, fontSize: 10.5, color: pressStyles.textDim,
              fontStyle: 'italic',
            }}>
              <span>독자 지분 <span style={{ color: pressStyles.gold, fontStyle: 'normal' }}>{co.player_share}%</span></span>
              <span>R&D 진척 <span style={{ color: pressStyles.salmon, fontStyle: 'normal' }}>{co.rd_progress}%</span></span>
            </div>
          </div>
        );
      })}
    </>
  );
}

Object.assign(window, { PressShell, PressBoard, PressChart, PressAsset, PressBusiness });
