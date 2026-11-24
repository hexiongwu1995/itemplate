#let f(body, ps) = context if true {
  set page(..ps)
  let w = std.page.width
  html.html(lang: "en", { body; [W=#w] })
}
#show: it => f(it, (paper: "a5", margin: 2cm))
= X
