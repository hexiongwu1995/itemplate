// 用于验证 lib.typ 中重构后的 JS：标题编号、目录构建、箭头展开、侧边栏开合与拖拽
#import "@local/itemplate:0.7.0": itemplate

#show: itemplate.with(doc-title: "JS 重构测试")

= 第一章：标题编号

== 小节 1.1

=== 子小节 1.1.1

#lorem(60)

=== 子小节 1.1.2

#lorem(40)

== 小节 1.2

#lorem(50)

= 第二章：目录层级

== 小节 2.1

#lorem(50)

=== 子小节 2.1.1

#lorem(40)

=== 子小节 2.1.2

#lorem(40)

== 小节 2.2

#lorem(50)

= 第三章：滚动与公式

#lorem(80)

```js
const message = "这是一段很长的代码行，用于验证可横向滚动的容器内触摸手势不会被侧边栏滑动逻辑接管";
console.log(message);
```

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $

#lorem(120)
