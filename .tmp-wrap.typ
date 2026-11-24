#import "/src/letmeout/document.typ": letmeout

#let f(body, ps) = {
  set page(..ps)
  context {
    let adapted = letmeout(body)
    adapted
  }
}
#show: it => f(it, (paper: "a5", margin: 2cm, header: [Wrapped header]))
= X
Text.
