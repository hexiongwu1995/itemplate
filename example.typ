#import "/lib.typ": *
#show: itemplate.with(doc-title: "example")

= #lorem(3)

#lorem(20)

== #lorem(3)

#lorem(20)



#context if (target() == "html" or target() == "bundle") {
  html.elem("div", attrs: (
    style: "background: white; margin-top: 50px; width: 100%; height: 30vh",
    id: "three-orbital-cube",
  ))[]

  html.script(
    type: "module",
    src: "https://unpkg.com/@hexiongwu1995/itemplate/examples/itemplate/three-orbital-cube.js",
  )
}

= #lorem(3)

#lorem(20)

== #lorem(3)

#lorem(20)