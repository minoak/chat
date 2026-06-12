// Single-direction style draft: V2 Dark Press, all four views.

// ───── Style spec sheet header ──────────────────────────────

function StyleSpec() {
  const tokens = [
    { name: '--press-bg',        hex: '#161210', note: 'ink black' },
    { name: '--press-panel',     hex: '#1b1612', note: 'panel' },
    { name: '--press-card',      hex: '#221b16', note: 'card' },
    { name: '--press-card-hi',   hex: '#2b2219', note: 'card emphasized' },
    { name: '--press-text-hi',   hex: '#f5e9d2', note: 'ivory / headings' },
    { name: '--press-text',      hex: '#ddc8a7', note: 'body' },
    { name: '--press-text-dim',  hex: '#9a8a72', note: 'metadata' },
    { name: '--press-text-mute', hex: '#6e604c', note: 'placeholder' },
    { name: '--press-salmon',    hex: '#e8a679', note: 'FT salmon · primary accent' },
    { name: '--press-salmon-hi', hex: '#f4b88e', note: 'hover / hi' },
    { name: '--press-ivory',     hex: '#f0e3cc', note: 'title/masthead' },
    { name: '--press-gold',      hex: '#d4af6a', note: 'gold / 보유' },
    { name: '--press-up',        hex: '#d94c47', note: '한국식 ↑ (warm red)' },
    { name: '--press-down',      hex: '#5e7a99', note: '한국식 ↓ (ink blue)' },
    { name: '--press-rule',      hex: 'rgba(240,227,204,0.16)', note: 'hairline rule' },
    { name: '--press-rule-soft', hex: 'rgba(240,227,204,0.08)', note: 'soft rule' },
    { name: '--press-rule-hi',   hex: 'rgba(240,227,204,0.30)', note: 'double-rule masthead' },
  ];

  const isRGBA = (s) => s.startsWith('rgba');

  return (
    <div style={{
      maxWidth: 1180, margin: '32px auto 0', padding: '0 24px',
      fontFamily: "'Noto Serif KR', Georgia, serif", color: '#ddc8a7',
    }}>
      {/* Masthead */}
      <div style={{ textAlign: 'center', paddingTop: 8 }}>
        <div style={{
          fontFamily: "'JetBrains Mono', monospace", fontSize: 11, letterSpacing: '0.34em',
          color: '#e8a679', textTransform: 'uppercase',
        }}>
          Style Draft · V2 Dark Press
        </div>
        <div style={{
          fontFamily: "'Noto Serif KR', Georgia, serif", fontSize: 44, fontStyle: 'italic',
          fontWeight: 600, color: '#f0e3cc', letterSpacing: '-0.005em', marginTop: 10,
        }}>
          The Lilybelly <span style={{ color: '#e8a679' }}>Ledger</span>
        </div>
        <div style={{
          fontFamily: "'Noto Serif KR', Georgia, serif", fontStyle: 'italic',
          fontSize: 13, color: '#9a8a72', marginTop: 8, letterSpacing: '0.04em',
        }}>
          주식 + 경영 패널을 위한 다크 신문 톤 — Belladonna Academy · RisuAI
        </div>
      </div>

      <div style={{ height: 1, background: 'rgba(240,227,204,0.30)', marginTop: 16 }} />
      <div style={{ height: 1, background: 'rgba(240,227,204,0.30)', marginTop: 2 }} />

      {/* Style intent */}
      <div style={{
        marginTop: 22, padding: '14px 20px',
        background: '#1b1612',
        borderLeft: '3px solid #e8a679',
      }}>
        <div style={{
          fontFamily: "'Noto Serif KR', serif", fontSize: 10.5, fontVariant: 'small-caps',
          letterSpacing: '0.32em', color: '#e8a679', fontWeight: 600,
        }}>
          The intent
        </div>
        <div style={{ fontSize: 13.5, lineHeight: 1.65, marginTop: 8, color: '#ddc8a7' }}>
          FT/WSJ 같은 경제지의 위계와 활자 감각을 다크 모드로 옮긴 톤.
          본문은 세리프, 라벨은 small-caps, 표는 더블 룰과 점선으로 단을 나누고,
          UP은 warm red <span style={{ color: '#d94c47' }}>▲</span>,
          DOWN은 ink blue <span style={{ color: '#5e7a99' }}>▼</span>,
          액센트는 살몬과 골드. 이모지는 ▲▼◇◆로 통일.
        </div>
      </div>

      {/* Token grid */}
      <div style={{
        marginTop: 22, fontFamily: "'Noto Serif KR', serif", fontSize: 10.5,
        fontVariant: 'small-caps', letterSpacing: '0.32em', color: '#e8a679', fontWeight: 600,
      }}>
        ⁕ Colour tokens
      </div>
      <div style={{
        marginTop: 10,
        display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 0,
        borderTop: '1px solid rgba(240,227,204,0.16)',
        borderLeft: '1px solid rgba(240,227,204,0.16)',
      }}>
        {tokens.map((t, i) => (
          <div key={i} style={{
            padding: '12px 14px',
            borderRight: '1px solid rgba(240,227,204,0.16)',
            borderBottom: '1px solid rgba(240,227,204,0.16)',
            background: '#1b1612',
            display: 'flex', flexDirection: 'column', gap: 8,
          }}>
            <div style={{
              height: 26, width: '100%',
              background: t.hex,
              border: isRGBA(t.hex) ? '1px dashed rgba(240,227,204,0.25)' : 'none',
            }} />
            <div>
              <div style={{
                fontFamily: "'JetBrains Mono', monospace", fontSize: 10.5,
                color: '#f0e3cc', letterSpacing: '0.04em',
              }}>{t.name}</div>
              <div style={{
                fontFamily: "'JetBrains Mono', monospace", fontSize: 9,
                color: '#9a8a72', marginTop: 2, letterSpacing: '0.06em',
                overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
              }}>{t.hex}</div>
              <div style={{
                fontFamily: "'Noto Serif KR', serif", fontStyle: 'italic',
                fontSize: 11, color: '#ddc8a7', marginTop: 4,
              }}>{t.note}</div>
            </div>
          </div>
        ))}
      </div>

      {/* Type & rule conventions */}
      <div style={{
        marginTop: 28, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 22,
      }}>
        {/* Typography column */}
        <div>
          <div style={{
            fontFamily: "'Noto Serif KR', serif", fontSize: 10.5,
            fontVariant: 'small-caps', letterSpacing: '0.32em', color: '#e8a679', fontWeight: 600,
            marginBottom: 12,
          }}>
            ⁕ Typography
          </div>

          <div style={{ padding: '10px 0', borderTop: '1px solid rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              MASTHEAD · 36/1.05 italic 600
            </div>
            <div style={{
              fontFamily: "'Noto Serif KR', serif", fontSize: 36, fontStyle: 'italic',
              fontWeight: 600, color: '#f0e3cc', marginTop: 4,
            }}>The Lilybelly Ledger</div>
          </div>

          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              HEADLINE · 24/1.15 italic 600 ivory
            </div>
            <div style={{ fontFamily: "'Noto Serif KR', serif", fontSize: 24, fontStyle: 'italic', fontWeight: 600, color: '#f0e3cc', marginTop: 4 }}>
              간판 치료제 임상 실패
            </div>
          </div>

          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              BODY · 13/1.65 serif text
            </div>
            <div style={{ fontFamily: "'Noto Serif KR', serif", fontSize: 13, lineHeight: 1.65, color: '#ddc8a7', marginTop: 4 }}>
              본문은 Noto Serif KR (또는 Georgia 폴백) · 자간 0 · 행간 1.6 내외
            </div>
          </div>

          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              LABEL · 10.5 small-caps · letter-spacing 0.32em salmon
            </div>
            <div style={{
              fontFamily: "'Noto Serif KR', serif", fontSize: 10.5,
              fontVariant: 'small-caps', letterSpacing: '0.32em', color: '#e8a679', fontWeight: 600, marginTop: 4,
            }}>
              The Quotations Page
            </div>
          </div>

          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              KICKER · 9 mono · letter-spacing 0.34em salmon
            </div>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.34em', textTransform: 'uppercase', color: '#e8a679', marginTop: 4 }}>
              Vol. III · No. 142
            </div>
          </div>

          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              NUMBER · serif tabular-nums
            </div>
            <div style={{
              fontFamily: "'Noto Serif KR', serif", fontSize: 28, color: '#f0e3cc',
              marginTop: 4, fontVariantNumeric: 'tabular-nums', fontWeight: 500,
            }}>
              87,420 <span style={{ color: '#d4af6a', fontSize: 16 }}>G</span>
            </div>
          </div>
        </div>

        {/* Rules / iconography column */}
        <div>
          <div style={{
            fontFamily: "'Noto Serif KR', serif", fontSize: 10.5,
            fontVariant: 'small-caps', letterSpacing: '0.32em', color: '#e8a679', fontWeight: 600,
            marginBottom: 12,
          }}>
            ⁕ Rules &amp; signals
          </div>

          {/* Up/down */}
          <div style={{ padding: '10px 0', borderTop: '1px solid rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              UP / DOWN · ▲ ▼ · serif tabular
            </div>
            <div style={{ marginTop: 6, display: 'flex', gap: 18 }}>
              <span style={{ fontFamily: "'Noto Serif KR', serif", fontSize: 18, color: '#d94c47', fontVariantNumeric: 'tabular-nums' }}>
                ▲ +156 · +4.9%
              </span>
              <span style={{ fontFamily: "'Noto Serif KR', serif", fontSize: 18, color: '#5e7a99', fontVariantNumeric: 'tabular-nums' }}>
                ▼ −47 · −5.0%
              </span>
            </div>
          </div>

          {/* Double rule */}
          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              DOUBLE RULE · masthead/footer
            </div>
            <div style={{ marginTop: 6 }}>
              <div style={{ height: 1, background: 'rgba(240,227,204,0.30)' }} />
              <div style={{ height: 1, background: 'rgba(240,227,204,0.30)', marginTop: 2 }} />
            </div>
          </div>

          {/* Hairline */}
          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              HAIRLINE · table dividers
            </div>
            <div style={{ marginTop: 6 }}>
              <div style={{ height: 1, background: 'rgba(240,227,204,0.16)' }} />
              <div style={{ height: 1, background: 'rgba(240,227,204,0.16)', borderBottom: '1px dotted rgba(240,227,204,0.16)', marginTop: 4 }} />
            </div>
          </div>

          {/* Drop cap */}
          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              DROP CAP · article lead
            </div>
            <div style={{ fontFamily: "'Noto Serif KR', serif", fontSize: 13, lineHeight: 1.6, color: '#ddc8a7', marginTop: 6 }}>
              <span style={{
                float: 'left', fontFamily: "'Noto Serif KR', serif", fontSize: 44,
                lineHeight: 0.85, color: '#e8a679', fontStyle: 'italic',
                marginRight: 8, marginTop: 2,
              }}>제</span>
              제국 마법공학 칩 설계 1위. 군부·연구원 대상 독점 공급 계약 다수 보유.
            </div>
            <div style={{ clear: 'both' }} />
          </div>

          {/* Hatch fill */}
          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              HATCH FILL · chart area · 45° salmon @ 0.12
            </div>
            <div style={{
              height: 38, marginTop: 6,
              background: `repeating-linear-gradient(45deg, transparent, transparent 3px, rgba(232,166,121,0.12) 3px, rgba(232,166,121,0.12) 4px)`,
              border: '1px solid rgba(240,227,204,0.16)',
            }} />
          </div>

          {/* Pill / tag */}
          <div style={{ padding: '10px 0', borderTop: '1px dotted rgba(240,227,204,0.16)' }}>
            <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 9, letterSpacing: '0.28em', color: '#9a8a72' }}>
              TAGS · serif 13 ivory · 1px rule frame
            </div>
            <div style={{ marginTop: 6, display: 'flex', gap: 14, flexWrap: 'wrap' }}>
              {['Tech', '대형', '재무 성장', '변동성 중'].map((t, i) => (
                <span key={i} style={{
                  fontFamily: "'Noto Serif KR', serif", fontSize: 13, color: '#f0e3cc',
                  paddingBottom: 1, borderBottom: '1px solid rgba(240,227,204,0.16)',
                }}>{t}</span>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div style={{ height: 1, background: 'rgba(240,227,204,0.30)', marginTop: 32 }} />
      <div style={{ height: 1, background: 'rgba(240,227,204,0.30)', marginTop: 2 }} />

      <div style={{ textAlign: 'center', marginTop: 18, marginBottom: 6 }}>
        <div style={{
          fontFamily: "'Noto Serif KR', serif", fontStyle: 'italic',
          fontSize: 13, color: '#9a8a72',
        }}>
          — Below, the four sections of the panel —
        </div>
      </div>
    </div>
  );
}

function PressFrame({ children }) {
  return (
    <div style={{
      width: '100%', minHeight: '100%',
      boxShadow: '0 0 0 1px rgba(232,166,121,0.30), 0 18px 40px rgba(0,0,0,0.55)',
      overflow: 'hidden',
    }}>
      {children}
    </div>
  );
}

function PressApp() {
  const W = 540;
  const sections = [
    { id: 'board',    tab: 'board',    title: 'Sect. I · 시세 — Quotations',  subtitle: '뉴스 + 종목 시세표', view: <PressBoard />,    h: 1180 },
    { id: 'chart',    tab: 'chart',    title: 'Sect. II · 차트 — Chart',       subtitle: '캔들/라인 + 기업 정보',  view: <PressChart />,    h: 1340 },
    { id: 'asset',    tab: 'asset',    title: 'Sect. III · 자산 — Holdings',  subtitle: '시장 지수 + 평가자산',   view: <PressAsset />,    h: 1140 },
    { id: 'business', tab: 'business', title: 'Sect. IV · 경영 — Ventures',   subtitle: '공동 경영 회사 카드',    view: <PressBusiness />, h: 1300 },
  ];

  return (
    <>
      <StyleSpec />
      <DesignCanvas>
        <DCSection id="all" title="All four sections" subtitle="좌→우: 시세 · 차트 · 자산 · 경영. 드래그로 재정렬 / 더블클릭으로 풀스크린 / 우상단 메뉴로 PNG·HTML 추출.">
          {sections.map((s) => (
            <DCArtboard key={s.id} id={s.id} label={s.title} width={W} height={s.h}>
              <PressFrame>
                <PressShell activeTab={s.tab}>{s.view}</PressShell>
              </PressFrame>
            </DCArtboard>
          ))}
        </DCSection>
      </DesignCanvas>
    </>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<PressApp />);
