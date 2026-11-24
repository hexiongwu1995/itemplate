#import "/lib.typ": *

#show: itemplate.with(doc-title: "Merged", lang: "en")

= First section

A paragraph with *bold* and `code`.

#grid(columns: (1fr, 1fr), gutter: 12pt,
  rect(fill: aqua.lighten(60%), radius: 4pt)[A card],
  rect(stroke: (dash: "dashed"))[Another],
)

#line(length: 100%, stroke: (paint: blue, dash: "dashed"))

#align(center)[Centered text]

== Subsection

#table(columns: 2, [A], [B])

#pagebreak()

= Next page

Text.
