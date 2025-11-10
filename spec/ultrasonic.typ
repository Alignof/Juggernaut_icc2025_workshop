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
2 つの目玉のようなものが付いた，またもや謎の部品．一体なにを測っているんだ……？
プログラムを見てみると，何かの信号が返ってくるのを待ってる？

= 回路
回路の配線図を@wiring に示す．
#figure(
    image("./images/ultrasonic.pdf", width: 100%),
    caption: [配線図],
)<wiring>

@wiring の下側にある青色の大きな部品が，実際の装置の緑色の部品（形は同じ）に相当する．
図と実際のワイヤの位置が違うが，ブレッドボードの縦 5 つの穴は全て繋がっているので電気的には同じである．

また，図の都合上 LED の配線が見づらいので@wiring の右側に等価な回路を載せた．\
マイコンの出力ピン → LED の`+` → LED の `-` → 抵抗 → GND となっている．

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
        [タクトスイッチ], [2], [別紙参照],
        [LED], [5], [---],
        [???], [1], [@pulse と別紙参照],
    ),
    caption: [部品一覧],
)<parts>

謎の部品については解き方を見ながらその正体を一緒に考えてほしいが，LED がヒントになっている．
LED の色は特に意味があるわけではない．

= ソースコード
装置に書き込まれたプログラムを以下に示す．
```cpp
struct Challenge Ultrasonic = {
    .gaming = ultrasonic,
    .setup_pin = setup_dist,
    .time_limit = 900,
};

// giver pin assgin
const uint8_t TRIG = 16;
const uint8_t ECHO = 17;
const uint8_t LED1 = 2;
const uint8_t LED2 = 4;
const uint8_t LED3 = 18;
const uint8_t LED4 = 19;
const uint8_t LED5 = 21;
const uint8_t LEFT_BUTTON = 15;
const uint8_t RIGHT_BUTTON = 23;

void setup_dist(void) {
    pinMode(TRIG, OUTPUT); // 出力のためのピン
    pinMode(LED1, OUTPUT); // 出力のためのピン
    pinMode(LED2, OUTPUT); // 出力のためのピン
    pinMode(LED3, OUTPUT); // 出力のためのピン
    pinMode(LED4, OUTPUT); // 出力のためのピン
    pinMode(LED5, OUTPUT); // 出力のためのピン
    pinMode(ECHO, INPUT);  // 入力のためのピン
    pinMode(LEFT_BUTTON,  INPUT_PULLDOWN); // ボタンの入力を読むためのピン
    pinMode(RIGHT_BUTTON, INPUT_PULLDOWN); // ボタンの入力を読むためのピン
}

void ultrasonic(void *pvParameters) {
    bool flag1 = false;
    bool flag2 = false;
    bool flag3 = false;
    float duration, cm;

    while(1) {
        flag1 = (digitalRead(RIGHT_BUTTON)  == HIGH);
        flag2 = (digitalRead(LEFT_BUTTON) == HIGH);

        digitalWrite(TRIG, LOW);
        delayMicroseconds(2);
        digitalWrite(TRIG, HIGH);
        delayMicroseconds(10);
        digitalWrite(TRIG, LOW);

        // ECHO が HIGH になっている時間を返す（マイクロ秒）．
        duration = pulseIn(ECHO, HIGH);
        // duration を 2 で割って係数 0.0344 をかける．
        // 係数 0.0344 は 331.5 * (0.61 * t) （t は摂氏温度，今回は20度と想定）
        // の結果の単位を合わせたもの．
        // これは一般的に約 340 m/s と習う「あの」速さを
        // 温度に合わせて厳密に計算したものです．
        cm = (duration / 2) * 0.0344;

        // 先に LED1~LED5 までのピンを全部 LOW にしておく
        digitalWrite(LED1, LOW);
        digitalWrite(LED2, LOW);
        digitalWrite(LED3, LOW);
        digitalWrite(LED4, LOW);
        digitalWrite(LED5, LOW);
        if (10 <= cm) { // もし cm の値が 10 以下だったら
          digitalWrite(LED1, HIGH); // LED1 番のピンを HIGH に
        }
        if (15 <= cm) { // もし cm の値が 15 以下だったら
          digitalWrite(LED2, HIGH);
        }
        if (20 <= cm) { // もし cm の値が 20 以下だったら
          digitalWrite(LED3, HIGH);
        }
        if (25 <= cm) { // もし cm の値が 25 以下だったら
          digitalWrite(LED4, HIGH);
        }
        if (30 <= cm) { // もし cm の値が 30 以下だったら
          digitalWrite(LED5, HIGH);
        }

        if (flag1 && 15 < cm && cm <= 20) {
            flag3 = true;
        }

        // succeeded
        if(flag3) {
            succeeded();
        }

        // failed
        if(flag1 && flag2) {
            failed();
        }

        delay(100);
    } // while (true) { の行まで戻る
}
```

`cm` の値が爆弾解除の鍵のようですが，具体的に今`cm`がいくつなのか分かりません．
これでは解きづらいので今回は LED とリンクさせてみました．是非試してみてください．

#pagebreak()

= 解き方
== 配線と部品を確認する
今回はかなり配線の数が多く苦労しそうです．
@parts を見ると，謎の部品・LEDが5つとボタンが2つという構成のようです．
この問題もボタンを押したり，謎の部品を使って解除の条件を満たしていけば良さそうです．

#side-color-box("やってみよう", orange)[
    - 手元の装置を見て，謎の部品・左のボタン・右のボタンがマイコンのピンの何番に繋がっているか調べよう．
        - 謎の部品: #underline(box(width: 5em, repeat(sym.space)))
        - 左のボタン: #underline(box(width: 5em, repeat(sym.space)))
        - 右のボタン: #underline(box(width: 5em, repeat(sym.space)))

    - プログラムを見て，`SENSOR`, `BUTTON_LEFT`，`BUTTON_RIGHT` がそれぞれ何番を表すのか調べよう．
        - `SENSOR`: #underline(box(width: 5em, repeat(sym.space)))
        - `BUTTON_LEFT`: #underline(box(width: 5em, repeat(sym.space)))
        - `BUTTON_RIGHT`: #underline(box(width: 5em, repeat(sym.space)))
]

次にボタンとワイヤの関係も見ておきましょう．
ボタンを押すと電気はどちらに流れていきますか？
#side-color-box("やってみよう", orange)[
    ペンを使って Vcc からピンまでの流れを塗ってみよう．
]

== 解除成功・失敗の条件を調べる
次に，書かれているプログラムを見てみると，`flag1` と `flag2` と `flag3` があります．
`flag1`，`flag2`，`flag3`はデータを入れる#highlight[変数]というものでした．
この変数には `true`/`false` のどちらかが入ります．

`flag1` と `flag2` は前の問題と同じような形ですが，`flag3` は多少複雑です．
#zebraw(
    numbering-offset: 29,
    [
        ```cpp
        if (flag1 && 15 < cm && cm <= 20) {
            flag3 = true;
        }
        ```
    ],
)
`&&` は"かつ"（英語で AND）という意味です．例えば `A && B` とあったら *A と B 両方*が`true`であるときに`true`という意味です．
今回は `&&` が 2 つあるので `A && B && C` となり *A と B と C 全部*が`true`であるときに`true`という意味になります．

つまり，以下の条件全てが `true` （成り立つ）とき `flag3` が `true` になります．
/ 条件1: `flag1` が `true`
/ 条件2: `cm` に入っている値が *15 より大きい*．
/ 条件3: `cm` に入っている値が *20 以下である*．

同様に失敗の条件も探してみましょう．

== 謎の部品の正体を探る
後はこの 2 つの目玉のようなものが付いた部品の正体です．そもそもこの部品（センサ？）はどうやって値を取得しているのでしょうか？
さっきの問題は片方が Vcc(+) に片方が入力ピンに接続されていて，条件が揃うと Vcc と 入力ピンが繋がって `HIGH` が入力されるという仕組みでした．
今回のセンサは*出力と入力*のピン両方が繋がっています．
#zebraw(
    numbering: none,
    [
        ```cpp
        pinMode(TRIG, OUTPUT); // 出力のためのピン
        pinMode(ECHO, INPUT);  // 入力のためのピン
        ```
    ],
)

`TRIG` が出力 `ECHO` が入力です．これはセンサの正面にも書かれています．
`TRIG` はおそらく "trigger"の略で，銃の引き金や何かを動作させるための信号のことを指します．
`ECHO` は"echo"，つまり山びこのことです．
#zebraw(
    numbering-offset: 39,
    highlight-lines: 3,
    [
        ```cpp
        digitalWrite(TRIG, LOW);
        delayMicroseconds(2);
        digitalWrite(TRIG, HIGH);
        delayMicroseconds(10);
        digitalWrite(TRIG, LOW);
        ```
    ],
)

まず `TRIG` を `LOW` にして 2 $mu s$ 待ってそこから $10 mu s$ の間 `HIGH` にします．
この $10 mu s$ が trigger となる信号なのです．

#zebraw(
    numbering-offset: 44,
    [
        ```cpp
        // ECHO が HIGH になっている時間を返す（マイクロ秒）．
        duration = pulseIn(ECHO, HIGH);
        // duration を 2 で割って係数 0.0344 をかける．
        // 係数 0.0344 は 331.5 * (0.61 * t) （t は摂氏温度，今回は20度と想定）
        // の結果の単位を合わせたもの．
        // これは一般的に約 340 m/s と習う「あの」速さを
        // 温度に合わせて厳密に計算したものです．
        cm = (duration / 2) * 0.0344;
        ```
    ],
)

そして今度は `ECHO` の入力を待ってます．
`pulseIn` は信号が `HIGH` になっている長さを返す関数です．
データシートの図に意味を加えるとこうなってます．
#figure(
    image("./images/pulse.png", width: 100%),
    caption: [信号の意味],
)<pulse>

謎の部品から返ってくる信号の長さ（@pulse 一番下の山の幅）は何を表しているのでしょうか？
それはこの問題の名前に隠されています．"ultrasonic" これはズバリ「超音波」という意味です．

部品の正面に "T" と "R" という文字があるのに気づいたでしょうか？
これは "Transmit"（送信）と "Receive"（受信）という意味です．
この部品は `TRIG` に信号を受け取ると *"T" の方から 40 kHz の超音波を 8 回飛ばします*．
そして*超音波はなにかにぶつかって返ってきます．これを "R" で検知します*．

検知したら *"T"から超音波を飛ばして"R"に返ってくるまでの時間*を信号として `ECHO` に返します．
謎の部品から返ってくる信号の長さ（@pulse 一番下の山の幅）の正体はこれです．
この時間がプログラムの中だと `duration` という変数に入っています．

ここまで来ると何故 `duration` が 2 で割られるのか，謎の係数 `0.0344` とは何なのか，`cm` という変数が何を表しているのか分かると思います．
#side-color-box("やってみよう", orange)[
    謎のセンサの仕組みが分かったら以下の空欄を埋めてみよう．
    - `duration` が 2 で割られるのは，#underline(box(width: 12em, repeat(sym.space))) からである．
    - 0.0344 という係数は，#underline(box(width: 3em, repeat(sym.space))) の速さと時間をかけることで#underline(box(width: 12em, repeat(sym.space))) を求めるためのものである．
    - つまり，このセンサは，#underline(box(width: 12em, repeat(sym.space))) を測るためのものである．
]
