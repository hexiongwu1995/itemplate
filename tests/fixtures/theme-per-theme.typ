#import "/lib.typ": *

#show: itemplate.with(
  doc-title: "Per-theme overrides",
  lang: "en",
  // Default-only override: should only change the default theme.
  default-theme: (accent: "#123456", bg: "#112233", "sidebar-bg": "#445566"),
  // Paper-only override: should only change the paper theme.
  paper-theme: (bg: "#a1b2c3", sidebar-bg: "#d4e5f6"),
  // Green-only override: should only change the green theme.
  green-theme: (bg: "#aabbcc", sidebar-bg: "#ddeeff"),
  // Dark keeps its own palette (not affected by light overrides).
  dark-theme: (accent: "#d97757"),
)

= Section
