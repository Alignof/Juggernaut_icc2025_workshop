#import "@preview/zebraw:0.5.5": *
#import "@preview/theorion:0.3.2": *
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
    title: "ULTRASONIC",
    number: "icc2025-003",
    author: (
        name: "Norimasa TAKANA",
        organization: [University of Tsukuba],
        email: "contact@takana.dev",
    ),
    date: datetime(year: 2025, month: 11, day: 08),
    time_limit: datetime(hour: 0, minute: 15, second: 0),
)

= 作問者より一言
2 つの目玉のようなものが付いた，謎の部品．何かを計測しているようです．
LED の光り方をヒントに何のセンサなのか当ててみましょう．

= 回路
回路の配線図を@wiring に示す．
#figure(
    image("./images/ultrasonic.pdf", width: 100%),
    caption: [配線図],
)<wiring>

@wiring の下側にある青色の大きな部品が，実際の装置の緑色の部品（形は同じ）に相当します．
図と実際のワイヤの位置が違いますが，ブレッドボードの縦 5 つの穴は全て繋がっているので電気的には同じです．

また，図の都合上 LED の配線が見づらいので@wiring の右側に等価な回路を載せました．\
マイコンの出力ピン → LED の`+` → LED の `-` → 抵抗 → GND となっています．

#pagebreak()

回路に使われている部品の一覧を@parts に示す．
#figure(
    table(
        stroke: (x: none),
        columns: 3,
        align: (x, y) => (
            if x == 1 and y >= 1 { right } else { left }
        ),
        table.header([部品名], [個数], [概要]),
        [タクトスイッチ], [2], [スライド参照],
        [LED], [5], [---],
        [???], [1], [],
    ),
    caption: [部品一覧],
)<parts>

= ソースコード
装置に書き込まれたプログラムはこんな感じです．長いので順番に見ていきましょう．
オンラインではここから見られます: #link("https://scratch.mit.edu/projects/1241563990")
#figure(
    image("./images/ultrasonic_code_1.png", width: 100%),
    caption: [書かれているプログラム],
)<code1>

左側はピンの番号の設定です．
最初の処理ですが，センサからデータをもらうために信号を送っています．
@pulse のような感じです．

#figure(
    image("./images/pulse.png", width: 100%),
    caption: [信号の意味],
)<pulse>

このセンサは 10 $mu s$ の間電気を`+`にすると，これが合図になって超音波を飛ばします．
超音波はセンサの2つあるうちの "T"(Transmit，送信) の方の目玉のような部分から発射されます．

そしてその超音波がもう1つの目玉へ返ってくるまでの時間を測ります．
なぜ前に飛ばした超音波が隣にある目玉に返ってくるかというと，*超音波はものにぶつかると跳ね返るからです*．

そして返ってくるまでの時間を信号にしてマイコンに教えてあげます．
「`duration` を `ECHO` が `high` になるまでの時間にする」の部分です．

そして音の速さをかけて `cm` という値を得ます．
`cm` が何かの略なのかそれとも別の意味なのかは自分で考えてみましょう．
#side-color-box("やってみよう", orange)[
    - `cm` は何の値か考えてみよう．
    - なぜ返ってくるまでの時間を 2 で割っているのか考えよう．
    - つまりこのセンサは何を測っているか考えよう．

    #tip-box[
        `cm` は `(超音波がなにかにぶつかって戻ってくるまでの時間 / 2) * 音の速さ`でした
    ]
]


`cm` の値が爆弾解除の鍵のようですが，具体的に今`cm`がいくつなのか分かりません．
これでは解きづらいので今回は LED とリンクさせてみました．それが次の部分です．

#figure(
    image("./images/ultrasonic_code_2.png", width: 100%),
    caption: [書かれているプログラム（続き）],
)<code2>

プログラムが持っている cm の具体的な数値が分からないので LED で可視化してみました．
`cm` が 10 以上なら LED の 1 が，`cm` が 15 以上なら 1 と 2 が光りそうです

最後に解除条件と失敗条件です．
#figure(
    image("./images/ultrasonic_code_3.png", width: 100%),
    caption: [書かれているプログラム（解除条件と失敗条件）],
)<code3>

`15 < cm` かつ `cm < 20` とはどういうことでしょうか？
`cm` は 15 より大きく同時に 20 より小さいということです．
この条件は数直線にすると@number_line になります．
#figure(
    image("./images/number_line.png", width: 100%),
    caption: [`15 < cm` かつ `cm < 20`],
)<number_line>

この条件を満たしているタイミングは LED を見れば分かるはずです．
