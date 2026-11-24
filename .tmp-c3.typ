#import "/src/letmeout/document.typ": letmeout
#let f(body, ps) = {
  set page(..ps)
  context if true {
    let a = letmeout(body)
    a
  }
}
#show: it => f(it, (paper: "a5", margin: 2cm))
= X
#context [BODYW=#std.page.width]
