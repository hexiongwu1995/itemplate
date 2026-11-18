#import "/lib.typ": *

#show: itemplate.with(
  doc-title: "Per-theme overrides",
  lang: "en",
  // Shared light override: should reach default, paper, AND green.
  theme: (accent: "#123456"),
  // Paper-only override: should only change the paper theme.
  paper-theme: (bg: "#a1b2c3", sidebar-bg: "#d4e5f6"),
  // Green-only override: should only change the green theme.
  green-theme: (bg: "#aabbcc", sidebar-bg: "#ddeeff"),
  // Dark keeps its own palette (not affected by light overrides).
  dark-theme: (accent: "#d97757"),
)

= Section
