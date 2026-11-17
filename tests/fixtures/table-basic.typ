#import "/lib.typ": *

#show: itemplate.with(
  doc-title: "Table fixture",
  lang: "en",
)

= Tables

#table(
  columns: 3,
  table.header([Name], [Type], [Notes]),
  [Alpha], [Short], [A narrow table stays inside the article column.],
  [Beta], [Long], [A cell with enough text to wrap inside its column.],
)

#table(
  columns: 8,
  [A], [B], [C], [D], [E], [F], [G], [H],
  [1], [2], [3], [4], [5], [6], [7], [8],
)
