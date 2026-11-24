#import "/src/letmeout/document.typ": letmeout
#let f(body, ps) = {
  set page(..ps)
  context if true {
    html.html(lang: "en", {
      html.head(html.title([T]))
      html.elem("body", letmeout(body))
    })
  }
}
#show: it => f(it, (paper: "a5", margin: 2cm))
= X
#context [BODYW=#std.page.width]
