#let ps = (paper: "a5", margin: 2cm)
#let compute() = { set page(..ps); (width: std.page.width, height: std.page.height) }
#context {
  let d = compute()
  html.html(lang: "en", [#d.width])
}
