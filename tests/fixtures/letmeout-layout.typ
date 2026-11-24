#import "/lib.typ": *

#show: itemplate.with(
  doc-title: "Merged layout",
  lang: "en",
  page: (paper: "a5", margin: 2cm, header: [Merged header]),
)

= Layout

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  rect(fill: aqua.lighten(60%), radius: 4pt)[First card],
  rect(stroke: (dash: "dashed"))[Second card],
)

#line(length: 100%, stroke: (paint: blue, dash: "dashed"))

#align(center)[Centered text]

== Table

#table(
  columns: 3,
  table.header([Name], [Type], [Notes]),
  [Alpha], [Short], [First cell],
  [Beta], [Long], [Second cell],
)

#pagebreak()

= After break

Text after the page break.
