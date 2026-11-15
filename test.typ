#import "lib.typ": *
#show: itemplate.with(
  doc-title: "iTemplate Refactor Verification Document",
  doc-author: "Hexiong Wu",
  lang: "en",
)

= Introduction

This document verifies the layout, table of contents, tables, and interactive behavior of the refactored `itemplate`. It contains sufficiently long paragraphs, deep headings, wide tables, code blocks, math, images, and lists so that the layout can be checked on both desktop and mobile.

Long-form reading is the primary use case, so the body text here is deliberately verbose. A well-set document should keep a comfortable measure, consistent line height, and clear vertical rhythm even when paragraphs run for many lines. The refactor should not change any of those qualities; it should only make the structure more robust and the interactive parts more predictable.

== Research Background

The template was originally written as a single monolithic file. Over time, the sidebar table of contents, table wrappers, and mobile drawer logic were added incrementally, which made the source hard to follow and easy to break. The refactor splits these concerns into clearly separated sections while preserving the visual result.

=== Finer Hierarchy

Deeper heading levels are included to verify numbering and indentation in the sidebar table of contents. Each level should be visually distinguishable and the numbering should remain stable.

==== Fourth-Level Heading

Fourth-level headings should still render correctly even if they are not shown in the sidebar by default.

== Contributions

+ A numbered sidebar table of contents is generated at compile time.
+ Tables support horizontal scrolling with hidden scrollbars and a fullscreen view.
+ The mobile drawer supports edge-swipe gestures.



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
    }
    ```.text,
  )
}




= Typography

== Paragraphs and Emphasis

This is a regular paragraph containing *bold emphasis*, _italic emphasis_, `inline code`, and an #link("https://typst.app")[external link]. Line height and letter spacing should suit long-form reading.

#quote(
  block: true,
)[Block quotes carry excerpts or side notes. The accent-colored rule on the left should match the overall style without becoming too loud.]

== Lists

- First item
- Second item
  - Nested item
  - Another nested item
- Third item

+ First ordered item
+ Second ordered item
+ Third ordered item

== Code

```typst
#let itemplate(doc-title: "Document", body) = {
  set heading(numbering: "1.1.1")
  body
}
```

Below is a long single-line code snippet, used to verify that horizontal scrolling does not break the page:

```js
const extremelyLongVariableName = someFunctionCall(argumentOne, argumentTwo, argumentThree, argumentFour, argumentFive, argumentSix, argumentSeven);
```

== Math

An inline formula $a^2 + b^2 = c^2$, and a display formula:

$ integral_0^infinity e^(-x) dif x = 1 $

= Tables

== Regular Table

#table(
  columns: 3,
  [*Item*], [*Description*], [*Status*],
  [Sidebar], [Numbered, collapsible, drag-to-resize], [Done],
  [Tables], [Horizontal scroll, hidden scrollbar, fullscreen], [Done],
  [Gestures], [Edge-swipe to open and close on mobile], [Done],
)

== Wide Table

When a table has many columns, it should scroll horizontally inside its own container rather than stretching the whole page.

#table(
  columns: 9,
  [*No.*], [*Name*], [*Type*], [*Length*], [*Width*], [*Height*], [*Weight*], [*Remarks*], [*Action*],
  [1], [Aluminum enclosure], [Structural], [120.5], [80.0], [12.0], [340], [Anodized], [View],
  [2], [Control board], [Electronic], [95.0], [60.0], [1.6], [45], [Four-layer PCB], [View],
  [3], [Li-polymer battery], [Power], [110.0], [70.0], [8.0], [180], [With protection board], [View],
  [4], [Display assembly], [Optical], [130.0], [85.0], [3.2], [95], [Fully laminated], [View],
)

== Empty Cells and Alignment

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, right),
  [*Parameter*], [*Description*], [*Value*],
  [Operating voltage], [DC input range], [5 V],
  [Standby current], [], [12 mA],
  [Operating temperature], [Industrial grade], [-20 -- 70 °C],
)


= Images

#figure(
  image("assets/test.png", width: 100%),
  caption: [Screenshot of the previous template's interface, used as a visual regression test.],
)

= Conclusion

The sections above cover the full range of elements the template is expected to support. If every element renders correctly on both desktop and mobile, the refactor can be considered behavior-preserving.
