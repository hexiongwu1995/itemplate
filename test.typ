#import "lib.typ": *
#show: itemplate.with(doc-title: "test")

= #lorem(3)

#lorem(20)

== #lorem(3)

#lorem(20)

= #lorem(3)

#lorem(20)

== #lorem(3)

#lorem(20)

#html.elem("div", attrs: (
  style: "background: white; margin-top: 50px; width: 100%; height: 30vh",
  id: "three-orbital-cube",
))[]

#html.script(
  type: "module",
  src: "https://unpkg.com/@hexiongwu1995/itemplate/examples/itemplate/three-orbital-cube.js",
)