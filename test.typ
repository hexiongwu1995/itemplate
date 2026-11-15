#import "lib.typ": *
#show: itemplate.with(
  doc-title: "iTemplate 重构验证文档",
  doc-author: "Hexiong Wu",
  lang: "zh",
)

= 引言

本文档用于验证 `itemplate` 重构后的排版、目录、表格与交互行为。它包含足够长的段落、深层标题、宽表格、代码块、公式、图片与列表，以便在桌面端和移动端同时检查布局。

#lorem(60)

== 研究背景

#lorem(40)

=== 更细的层级

#lorem(30)

==== 第四级标题

#lorem(20)

== 本文贡献

+ 编译期生成带编号的侧边栏目录。
+ 表格支持隐藏滚动条的横向滚动与全屏查看。
+ 移动端抽屉支持边缘滑动手势。

= 排版元素

== 段落与强调

这是一段普通正文，包含 *加粗强调*、_斜体强调_、`行内代码` 以及一个 #link("https://typst.app")[外部链接]。正文的行高与字距应当适合长文阅读。

#quote(block: true)[引用块用于承载摘录或旁注。左侧的强调色边线应当与整体风格一致，但不应过于抢眼。]

== 列表

- 第一项
- 第二项
  - 嵌套项
  - 另一个嵌套项
- 第三项

+ 有序第一项
+ 有序第二项
+ 有序第三项

== 代码

```typst
#let itemplate(doc-title: "Document", body) = {
  set heading(numbering: "1.1.1")
  body
}
```

下面是一段很长的单行代码，用于验证横向滚动不会撑破页面：

```js
const extremelyLongVariableName = someFunctionCall(argumentOne, argumentTwo, argumentThree, argumentFour, argumentFive, argumentSix, argumentSeven);
```

== 数学

行内公式 $a^2 + b^2 = c^2$，以及独立公式：

$ integral_0^infinity e^(-x) dif x = 1 $

= 表格

== 常规表格

#table(
  columns: 3,
  [*项目*], [*说明*], [*状态*],
  [侧边栏], [带编号、可折叠、可拖拽调宽], [完成],
  [表格], [横向滚动、隐藏滚动条、全屏], [完成],
  [手势], [移动端边缘滑动开合], [完成],
)

== 宽表格

当表格列数较多时，它应当在自身容器内横向滚动，而不是撑宽整个页面。

#table(
  columns: 9,
  [*序号*], [*名称*], [*类型*], [*长度*], [*宽度*], [*高度*], [*重量*], [*备注*], [*操作*],
  [1], [铝合金外壳], [结构件], [120.5], [80.0], [12.0], [340], [阳极氧化], [查看],
  [2], [控制主板], [电子件], [95.0], [60.0], [1.6], [45], [四层板], [查看],
  [3], [锂聚合物电池], [电源], [110.0], [70.0], [8.0], [180], [带保护板], [查看],
  [4], [显示屏组件], [光学件], [130.0], [85.0], [3.2], [95], [全贴合], [查看],
)

== 空单元格与对齐

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, right),
  [*参数*], [*描述*], [*数值*],
  [工作电压], [直流输入范围], [5 V],
  [待机电流], [], [12 mA],
  [工作温度], [工业级], [-20 -- 70 °C],
)

= 图片

#figure(
  image("assets/test.png", width: 100%),
  caption: [旧版模板的界面截图，用作图片样式回归测试。],
)

= 交互组件

== Three.js 场景

#context if (target() == "html") {
  html.elem("div", attrs: (
    style: "background: white; margin-top: 50px; width: 100%; height: 30vh",
    id: "three-orbital-cube",
  ))[]

  html.script(
    type: "module",
    src: "https://unpkg.com/@hexiongwu1995/itemplate/examples/itemplate/three-orbital-cube.js",
  )
}

== ECharts 三维曲面

#context if (target() == "html") {
  html.elem("div", attrs: (
    id: "echarts-surface",
    style: "width: 100%; height: 420px; margin-top: 12px;",
  ))[]

  html.script(src: "https://cdn.jsdelivr.net/npm/echarts@5.5.1/dist/echarts.min.js")
  html.script(src: "https://cdn.jsdelivr.net/npm/echarts-gl@2.0.9/dist/echarts-gl.min.js")
  html.script(
    ```js
    (() => {
      const el = document.getElementById("echarts-surface");
      if (!el || !window.echarts) return;

      const range = 8;
      const step = 0.25;
      const data = [];
      for (let x = -range; x <= range + 1e-6; x += step) {
        for (let y = -range; y <= range + 1e-6; y += step) {
          data.push([x, y, Math.sin(Math.sqrt(x * x + y * y))]);
        }
      }

      const css = getComputedStyle(document.documentElement);
      const accent = css.getPropertyValue("--accent").trim() || "#d97757";
      const surface = css.getPropertyValue("--surface").trim() || "#f5f4ed";
      const ink = css.getPropertyValue("--ink-muted").trim() || "#73726c";
      const line = css.getPropertyValue("--line-strong").trim() || "rgba(31, 30, 29, 0.22)";
      const axis = {
        axisLabel: { textStyle: { color: ink } },
        axisLine: { lineStyle: { color: line } },
        splitLine: { lineStyle: { color: line } },
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
          inRange: { color: [surface, accent] },
        },
        xAxis3D: { type: "value", name: "x", ...axis },
        yAxis3D: { type: "value", name: "y", ...axis },
        zAxis3D: { type: "value", name: "z", ...axis },
        grid3D: {
          boxWidth: 100,
          boxDepth: 100,
          boxHeight: 45,
          viewControl: { distance: 190, alpha: 28, beta: 35 },
          light: { main: { intensity: 1.15 }, ambient: { intensity: 0.35 } },
        },
        series: [{ type: "surface", data }],
      });
      window.addEventListener("resize", () => chart.resize());
    })();
    ```.text,
  )
}

= 结语

#lorem(30)
