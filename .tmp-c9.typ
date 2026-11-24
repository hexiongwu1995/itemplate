#let ps = (paper: "a5", margin: 2cm)
#let st = state("pg", none)
#context {
  page.with(..ps)[#context { st.update((w: std.page.width, h: std.page.height)) }]
}
#context [Q=#repr(st.get())]
