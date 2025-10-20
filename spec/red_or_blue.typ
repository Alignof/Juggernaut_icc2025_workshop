#import "@preview/zebraw:0.5.5": *
#import "style/specification.typ": *

#show: zebraw
#show: zebraw-init.with(
    lang: true,
    background-color: rgb("#1d2433"),
    highlight-color: rgb("#2d4640"),
    comment-color: rgb("#2f3645"),
    lang-color: rgb("#0d4443"),
)
#show: style.with(
    title: "Example",
    number: "icc2025-001",
    author: (
        name: "Norimasa TAKANA",
        organization: [University of Tsukuba],
        email: "contact@takana.dev",
    ),
    date: datetime(year: 2025, month: 10, day: 20),
    time_limit: datetime(hour: 0, minute: 15, second: 0),
)

= 作問者より一言
やっぱり最初は定番のこれ！
落ち着いてよくプログラムを読めばどっちを切るべきか分かるはずです．
ピンの設定がプルアップになっていることに注意！

= 回路
回路を構成する部品を @parts に示す．
#figure(
    table(
        stroke: (x: none),
        columns: 3,
        table.header([部品名], [個数], [データシート]),
        [???],
        [1],
        [#link("https://akizukidenshi.com/goodsaffix/hc-sr04_v20.pdf")],
    ),
    caption: [部品一覧],
)<parts>

= ソースコード
装置に書き込まれたプログラムを以下に示す．
```cpp
```
