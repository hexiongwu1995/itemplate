#let ps = (paper: "a5", margin: 2cm)
#page.with(..ps)[
  Hello
  #metadata((w: 1)) <pg>
]
#context [Q=#repr(query(<pg>))]
