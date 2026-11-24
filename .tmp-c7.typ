#let ps = (paper: "a5", margin: 2cm)
#context {
  set page(..ps)
  [#metadata((w: std.page.width, h: std.page.height)) <pg>]
}
#context [Q=#query(<pg>).first().value.w]
