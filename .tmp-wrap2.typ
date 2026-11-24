#import "/src/letmeout/document.typ": letmeout

#let page-setter = page
#let f(body, ps) = {
  set page-setter(..ps)
  context {
    let adapted = letmeout(body)
    adapted
  }
}
#show: it => f(it, (paper: "a5", margin: 2cm, header: [Alias header]))
= X
Text.
