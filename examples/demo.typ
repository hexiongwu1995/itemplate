#import "/lib.typ": *

#show: itemplate.with(
  doc-title: "iTemplate Demo",
  doc-author: "hexiongwu",
  lang: "en",
)

= Introduction

iTemplate turns Typst markup into a documentation site with a numbered sidebar table of contents, a responsive article column, and default, paper, green, and dark themes.

== Text

*Bold*, _italic_, `inline code`, and an #link("https://typst.app")[external link]. Inline math such as $e^(i pi) + 1 = 0$ uses the configured math font.

- First item
- Second item
  - Nested item

#quote(block: true)[Block quotes use an accent-colored rule and a serif face.]

== Code

```typst
#let greet(name) = [Hello, #name!]
```

= Interactive Components

== ECharts 3D Surface

#context if (target() == "html") {
  html.elem("div", attrs: (
    id: "echarts-surface",
    style: "width: 100%; height: 420px; margin-top: 12px;",
  ))[]

  html.script(
    type: "module",
    ```js
    import * as echarts from "echarts";
    // The UMD build of echarts-gl reads the main library from window.echarts
    window.echarts = echarts;
    await import("echarts-gl");

    const el = document.getElementById("echarts-surface");
    if (el) {
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

      const chart = echarts.init(el);
      chart.setOption({
        tooltip: { show: false },
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
          axisPointer: { show: false },
        },
        series: [{
          type: "surface",
          data,
          wireframe: { show: true, lineStyle: { color: ink, width: 0.5 } },
        }],
      });
      window.addEventListener("resize", () => chart.resize());
    }
    ```.text,
  )
}

= Tables

#table(
  columns: 3,
  [*Feature*], [*Status*], [*Notes*],
  [Sidebar], [Done], [Numbered, collapsible, resizable],
  [Tables], [Done], [Horizontal scroll and fullscreen],
)

Wide tables scroll inside their own container instead of stretching the page.
