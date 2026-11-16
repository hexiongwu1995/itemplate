#import "/lib.typ": *

#show: itemplate.with(
  doc-title: "Custom import map",
  lang: "en",
  import-map: default-import-map + (
    "d3": "https://cdn.jsdelivr.net/npm/d3@7/+esm",
  ),
)

= Section
