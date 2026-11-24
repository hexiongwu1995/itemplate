#let ps = (paper: "a5", margin: 2cm)
#let page-key() = (w: std.page.width, h: std.page.height)
#let probe = {
  show: page.with(..ps)
  [#context [#metadata(page-key()) <pk>]]
}
#context {
  probe
  let q = query(<pk>)
  [Q=#repr(q.first(default: none).value)]
}
