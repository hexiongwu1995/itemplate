#let ps = (paper: "a5", margin: 2cm)
#let page-key() = (w: std.page.width, h: std.page.height)
#let probe = context {
  show: page.with(..ps)
  [#context [#metadata(page-key()) <pk>]]
}
#probe
#context {
  let q = query(<pk>)
  html.html(lang: "en", [#html.elem("article")[W=#repr(q.first(default: none).value)]])
}
