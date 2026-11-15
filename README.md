# itemplate

`itemplate` turns Typst markup into a documentation site with a modern academic look. It exports a single HTML file containing a fixed top bar, a numbered and collapsible table of contents, and a responsive article column.

The warm paper palette, serif headings, hairline rules, and single terracotta accent are adapted from the [Claudette Typora theme](https://github.com/CookPiu/typora-theme-claudette) by CookPiu (MIT).

## Features

- **Numbered sidebar TOC** generated at compile time from `heading`, with nested levels, per-section collapse, and scroll-spy highlighting.
- **Responsive app shell** built on `100dvh` and safe-area insets, so browser toolbars and notches are handled correctly.
- **Mobile drawer** with edge-swipe to open and swipe-left to close, plus an overlay, focus management, and `inert` support.
- **Wide tables** scroll horizontally inside their own container with hidden scrollbars, a soft edge fade, and a fullscreen button on touch layouts. Fullscreen uses the Fullscreen API with a CSS-rotate fallback for iOS.
- **Light and dark themes** driven by `prefers-color-scheme`, using the Claudette warm paper palette, a terracotta accent, and serif headings.
- **Interactive charts** via the built-in import map for `echarts`, `echarts-gl`, and `plotly`.
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

## Interactive charts

The generated HTML includes an import map for `echarts` and `echarts-gl`, so a `type: "module"` script can import them with bare specifiers — no extra CDN `<script>` tags are needed.

`echarts-gl` is a UMD bundle that reads the main library from `window.echarts`; assign it before the dynamic import. The example below renders a 3D surface with a greys color scale:

````typst
#context if (target() == "html") {
  html.elem("div", attrs: (
    id: "echarts-surface",
    style: "width: 100%; height: 420px;",
  ))[]

  html.script(
    type: "module",
    ```js
    import * as echarts from "echarts";
    // echarts-gl 的 UMD 构建从 window.echarts 读取主库
    window.echarts = echarts;
    await import("echarts-gl");

    const range = 8;
    const step = 0.25;
    const data = [];
    for (let x = -range; x <= range + 1e-6; x += step) {
      for (let y = -range; y <= range + 1e-6; y += step) {
        data.push([x, y, Math.sin(Math.sqrt(x * x + y * y))]);
      }
    }

    const ink = "#8a8a86";
    const axis = {
      axisLabel: { color: ink },
      axisLine: { lineStyle: { color: ink } },
      splitLine: { lineStyle: { color: ink, opacity: 0.35 } },
      nameTextStyle: { color: ink },
    };

    const chart = echarts.init(document.getElementById("echarts-surface"));
    chart.setOption({
      tooltip: {},
      visualMap: {
        show: false,
        dimension: 2,
        min: -1,
        max: 1,
        inRange: { color: ["#f2f2f2", "#bdbdbd", "#737373", "#3b3b39"] },
      },
      xAxis3D: { type: "value", name: "x", min: -range, max: range, interval: range, ...axis },
      yAxis3D: { type: "value", name: "y", min: -range, max: range, interval: range, ...axis },
      zAxis3D: { type: "value", name: "z", min: -1, max: 1, interval: 1, ...axis },
      grid3D: {
        boxWidth: 100,
        boxDepth: 100,
        boxHeight: 45,
        viewControl: { projection: "orthographic", distance: 190, alpha: 28, beta: 35 },
        light: { main: { intensity: 1.15 }, ambient: { intensity: 0.35 } },
      },
      series: [{
        type: "surface",
        data,
        wireframe: { show: true, lineStyle: { color: ink, width: 0.5 } },
      }],
    });
    window.addEventListener("resize", () => chart.resize());
    ```.text,
  )
}
````

The chart needs WebGL. If the document is exported to PDF or opened without JavaScript, the container simply stays blank, so put the chart in a section that reads fine without it.

## Compile

```powershell
typst compile test.typ --features html --format html
```

The HTML export of Typst is still under active development, so the emitted markup may change between Typst releases. `bundle` export is not supported by this template; a PDF target renders the body without the HTML shell.

Math rendering loads the Latin Modern web fonts from `fred-wang.github.io`. The import map is optional — remove entries you do not need.

## Examples

`test.typ` exercises headings of every level, wide and regular tables, code, math, figures, lists, and an interactive ECharts 3D surface. Open the generated `test.html` in a browser to inspect the layout.
