# itemplate

`itemplate` turns Typst markup into a documentation site with a modern academic look. It exports a single HTML file containing a fixed top bar, a numbered and collapsible table of contents, and a responsive article column.

The warm paper palette, serif headings, hairline rules, and single terracotta accent are adapted from the [Claudette Typora theme](https://github.com/CookPiu/typora-theme-claudette) by CookPiu (MIT).

## Features

- **Numbered sidebar TOC** generated at compile time from `heading`, with nested levels, per-section collapse, and scroll-spy highlighting.
- **Responsive app shell** built on `100dvh` and safe-area insets, so browser toolbars and notches are handled correctly.
- **Mobile drawer** with edge-swipe to open and swipe-left to close, plus an overlay, focus management, and `inert` support.
- **Wide tables** scroll horizontally inside their own container with hidden scrollbars, a soft edge fade, and a fullscreen button on touch layouts. Fullscreen uses the Fullscreen API with a CSS-rotate fallback for iOS.
- **Light and dark themes** driven by `prefers-color-scheme`, using the Claudette warm paper palette, a terracotta accent, and serif headings.
- **Desktop sidebar resizing** by dragging the divider; width and open state persist in `localStorage`.
- **Print styles**, reduced-motion support, and keyboard-accessible controls.

## Usage

```typst
#import "@preview/itemplate:0.8.0": *

#show: itemplate.with(
  doc-title: "My Document",
  doc-author: "Author Name",
  lang: "en",
)

= Introduction

#lorem(40)

== Background

#lorem(40)
```

`doc-title` is shown in the top bar and in the sidebar footer. `doc-author` is optional.

## Theme

All design tokens can be overridden. Values may be Typst colors or raw CSS color strings.

```typst
#show: itemplate.with(
  doc-title: "My Document",
  theme: (
    accent: "#d97757",
    bg: "#faf9f5",
  ),
  dark-theme: (
    accent: "#d97757",
  ),
)
```

The full token list lives in `default-theme` at the top of `lib.typ`: `bg`, `surface`, `surface-strong`, `ink`, `ink-muted`, `ink-faint`, `line`, `line-strong`, `accent`, `accent-soft`, `accent-ink`, `sidebar-bg`, `header-bg`, `code-bg`, `selection`, `overlay`, `font-ui`, `font-serif`, `font-mono`, `font-math`.

## Compile

```powershell
typst compile test.typ --features html --format html
```

The HTML export of Typst is still under active development, so the emitted markup may change between Typst releases. `bundle` export is not supported by this template; a PDF target renders the body without the HTML shell.

Math rendering loads the Latin Modern web fonts from `fred-wang.github.io`. The optional import map for `three`, `plotly`, and `echarts` is included for documents that embed those libraries; remove it if you do not need them.

## Examples

`test.typ` exercises headings of every level, wide and regular tables, code, math, figures, lists, and a Three.js scene. Open the generated `test.html` in a browser to inspect the layout.
