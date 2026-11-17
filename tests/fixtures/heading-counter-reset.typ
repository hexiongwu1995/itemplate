#import "/lib.typ": *

#show: itemplate.with(
  doc-title: "Heading counter reset",
  lang: "en",
)

= One

== One A

#counter(heading).update(0)

= Two

== Two A
