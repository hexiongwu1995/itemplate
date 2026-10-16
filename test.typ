#import "./lib.typ": *
#show: itemplate.with(
  doc-title: "itemplate 功能演示",
  doc-author: "HeXiongwu",
  lang: "zh",
)

= 简介

这是一个用于测试 itemplate 模板各项功能的示例文档，包含标题编号、目录折叠、数学公式、代码块、表格、引用与三维演示等内容。Typst 是一门基于标记的排版语言，它可以用来撰写论文、书籍与技术文档。

行内公式测试：质能方程 $E = m c^2$ 与欧拉恒等式 $e^(i pi) + 1 = 0$。还可以测试*加粗文字*、_倾斜文字_、`inline code` 以及外部链接 #link("https://typst.app")[Typst 官网]。

== 数学公式

块级公式测试：

$ sum_(i=1)^n i = (n (n + 1)) / 2 $

麦克斯韦方程组（ISO 80000-2 规范：算子与物理量用粗正体）：

$ bold(nabla) dot bold(B) &= 0 \
   bold(nabla) times bold(E) &= - (partial bold(B)) / (partial t) $

=== 向量箭头重音

不同宽度底符上的箭头居中检查（i 窄 / u 常规 / w 宽 / W 更宽 / AB 多字符）：

$ arrow(i) quad arrow(u) quad arrow(w) quad arrow(W) quad arrow(A B) $

_注：2026-10 复测（DOM 矩形 + canvas 墨迹度量，17px 真实字号）：Typst HTML 导出的 U+20D7 组合字符在 Chromium + NewComputerModern Math 下箭头整体左偏（字形墨迹全部位于原点左侧，MathML Core 仅按字距盒居中所致），且偏移量与底符宽度无关；间距字符 U+2192 渲染居中正常。属 Typst 导出端问题，已提交上游 issue typst/typst#8961，模板侧不做补丁。_

对照重音（hat、tilde、bar 走同样的 mover 机制，可对比箭头是否异常）：

$ hat(u) quad tilde(u) quad bar(u) $

向量点积（点积为零即垂直）：

$ arrow(u) dot arrow(v) = 0 $

=== 分段函数

$ f(x) = cases(
  1\, & x > 0,
  -1\, & x < 0,
) $

=== 嵌套标题

这是一个四级标题，用于测试目录的深层折叠。

==== 四级测试点

目录应当能够正确处理 h2 → h3 → h4 的层级嵌套与折叠展开。

== 代码示例

行内代码：使用 `npm install` 安装依赖。

```ts
interface DocumentOptions {
  title: string;
  author?: string;
}

export function render(options: DocumentOptions): string {
  return `<!DOCTYPE html><title>${options.title}</title>`;
}
```

== 表格

#table(
  columns: (auto, 1fr, auto),
  table.header([*特性*], [*说明*], [*状态*]),
  [标题编号], [自动生成多级序号，并识别保留文档自带编号], [✓],
  [目录折叠], [侧边目录支持逐级展开与全部展开], [✓],
  [深色主题], [跟随系统偏好，并可手动切换与记忆], [✓],
  [打印样式], [打印时自动隐藏侧栏与顶栏], [✓],
)

== 列表

- 无序列表第一项
- 无序列表第二项
- 无序列表第三项

+ 有序列表第一项
+ 有序列表第二项
+ 有序列表第三项

== 引用

#quote(block: true)[
  设计不仅仅是外观和感觉，设计是它如何运作。 — Steve Jobs
]

== 三维演示

下方演示通过 Three.js 渲染的旋转立方体（需要联网加载资源）。

#context if (target() == "html" or target() == "bundle") {
  html.elem("div", attrs: (
    style: "background: var(--bg-inset); margin: 40px 0; width: 100%; height: 30vh; border-radius: 10px;",
    id: "three-orbital-cube",
  ))[]

  html.script(
    type: "module",
    src: "https://unpkg.com/@hexiongwu1995/itemplate/examples/itemplate/three-orbital-cube.js",
  )
}

= 更多测试

#lorem(20)

== 更多文字样式

下划线 #underline[重要内容]、删除线 #strike[废弃内容]、高亮 #highlight[关键结论]，
以及上下标：H #sub[2] O、x #super[2] #sub[n]、葡萄糖 C #sub[6] H #sub[12] O #sub[6]。

== 多栏布局

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  [左栏内容：网格布局第一列，用于测试多栏排版。],
  [右栏内容：网格布局第二列，与左栏对齐检查。],
)

== 术语列表

/ 定义列表: 也称术语表（term list），用于解释概念。
/ HTML: 超文本标记语言，用于构建网页结构。
/ CSS: 层叠样式表，用于描述文档的呈现样式。

== 更多数学公式

矩阵与行列式：

$ A = mat(
  1, 2, 3;
  4, 5, 6;
  7, 8, 9;
) quad det(A) =abs(A) $

积分与极限：

$ integral_0^oo e^(-x^2) dif x = sqrt(pi) / 2 quad quad lim_(n -> oo) (1 + 1/n)^n = e $

多行对齐推导：

$ f(x) &= (x + 1)^2 \
      &= x^2 + 2x + 1 $

== 分隔线与行内块

#line(length: 100%, stroke: 1pt + luma(120))

行内块测试：#box[固定盒子] 与 #emph[强调] 混排，外加原始文本 #raw("raw(\"内部\")")。
