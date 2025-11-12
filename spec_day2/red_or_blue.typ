#import "@preview/zebraw:0.5.5": *
#import "style/specification.typ": *
#import "util.typ": *

#show: zebraw
#show: zebraw-init.with(
    lang: true,
    indentation: 4,
    background-color: rgb("#1d2433"),
    highlight-color: rgb("#2d4640"),
    comment-color: rgb("#2f3645"),
    lang-color: rgb("#0d4443"),
)
#show: style.with(
    title: "Red or Blue",
    number: "icc2025-001",
    author: (
        name: "Norimasa TAKANA",
        organization: [University of Tsukuba],
        email: "contact@takana.dev",
    ),
    date: datetime(year: 2025, month: 10, day: 20),
    time_limit: datetime(hour: 0, minute: 10, second: 0),
)

= 作問者より一言
赤を切るべきか青を切るべきか……
プログラムと回路を読んで考えてみよう．

= 回路
回路の配線図を@wiring のようになってます．
#figure(
    image("./images/red_or_blue_circuit.pdf", width: 100%),
    caption: [配線図],
)<wiring>

センサなどは特にありません．2 本のワイヤが`+`に繋がっています．
ワイヤを引っこ抜けば `+` でなくなり `-` に繋がります#footnote[電磁気学的に自然にそうなるわけではなく，（プログラムに載せてませんが）私がそう設定しています．]．

#pagebreak()

= プログラム
マイコンに書かれたプログラムはこんな感じの動きをします．
オンラインではこちら: #link("https://scratch.mit.edu/projects/1241556510")

#figure(
    image("./images/red_or_blue_code.png", width: 100%),
    caption: [書かれているプログラム],
)<code>

`RED_WIRE` 番のピンと `BLUE_WIRE` 番のピンがプラスとマイナスどっちに繋がっているか調べているようです．
