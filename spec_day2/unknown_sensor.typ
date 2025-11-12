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
    title: "逆転の発想",
    number: "icc2025-002",
    author: (
        name: "Norimasa TAKANA",
        organization: [University of Tsukuba],
        email: "contact@takana.dev",
    ),
    date: datetime(year: 2025, month: 11, day: 08),
    time_limit: datetime(hour: 0, minute: 15, second: 0),
)

= 作問者より一言
金色のピカピカした筒． 何かを検知してスイッチの役割をしているようです．\
一体何だろう？

= 回路
回路の配線図を@wiring に示す．
#figure(
    image("./images/unknown_sensor.pdf", width: 100%),
    caption: [配線図],
)<wiring>

どうやらボタンを押したり謎の部品が反応すると LED が光るようです．
色々試してみてください．

#pagebreak()

回路に使われている部品は以下です．
#figure(
    table(
        stroke: (x: none),
        columns: 3,
        align: (x, y) => (
            if x == 1 and y >= 1 { right } else { left }
        ),
        table.header([部品名], [個数], [概要]),
        [タクトスイッチ], [2], [別紙参照],
        [フルカラーLED], [1], [別紙参照],
        [???], [1], [別紙と@sensor を参照],
    ),
    caption: [部品一覧],
)<parts>

金の筒状の部品(???)は，@sensor のような構造をしています．
#figure(
    image("./images/sensor.png", width: 45%),
    caption: [謎の部品の内部構造],
)<sensor>

@sensor の赤い部分・青い部分は電気的に繋がっている（= 電気を通す）部分です．
青い部分は黒い部分を突き抜けています#footnote[つまり青い棒の部分の両端は電気的に繋がってます．]．
黒い「絶縁体」というのは電気を通さない（通しにくい）材質です#footnote[データシートにはナイロンでできていると書かれています．]．

中には球体が入っています．振ると音が鳴るのは中に"真鍮でメッキされた球体"，つまり電気を通すボールが入っているからです．
さてどんなときにスイッチの役割をするでしょうか？
#side-color-box("やってみよう", orange)[
    - @sensor の状態で A と B は繋がって #underline(box(width: 6em, "いる・いない"))．
    - A と Bが繋がらなくなるのは#underline(box(width: 18em, repeat(sym.space)))ときだ．
]

= ソースコード
装置に書き込まれたプログラムを以下に示す．\
オンラインではこちら: #link("https://scratch.mit.edu/projects/1240378142")

#figure(
    image("./images/unknown_sensor_code.png", width: 100%),
    caption: [書かれているプログラム],
)<code>

分かりやすいようにピンの状態を見て LED を光らせています．
参考にしてください．
