#let ps = (paper: "a5", margin: 2cm)
#let page-key() = (w: std.page.width, h: std.page.height)
#let w = {
  show: page.with(..ps)
  [#context [#metadata(page-key()) <pg>]]
}
#w
#context [Q=#repr(query(<pg>))]
