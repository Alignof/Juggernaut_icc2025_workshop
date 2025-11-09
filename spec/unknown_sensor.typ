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
マイコンの先には謎の物体．センサっぽいけど何だこれ？振るとなんかカチャカチャ聞こえるし……
こういうときに必要なのは逆転の発想なのかもしれない．

= 回路
回路の配線図を@wiring に示す．
#figure(
    image("./images/unknown_sensor.pdf", width: 100%),
    caption: [配線図],
)<wiring>

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
        [フルカラーLED], [1], [別紙参照],
        [???], [1], [別紙と@sensor を参照],
    ),
    caption: [部品一覧],
)<parts>

金の筒状の部品(???)は，どういう構造をしているのか別紙と最後の方のページで紹介するのでどんなセンサなのか考えてみてください．
片方が Vcc に，片方が入力のピンに繋がっているので，なにかの条件が達成されると Vcc と入力のピンが繋がって `HIGH` になりそうです．

= FAQ
/ [Q]: 何のセンサか調べるためにセンサに触れても良いですか？
/ [A]: 良いですよ．
/ [Q]: 何のセンサか調べるために基板を持ち上げても良いですか？
/ [A]: 良いですよ．
/ [Q]: 何のセンサか調べるためにセンサ指で温めたり息を吹きかけても良いですか？
/ [A]: 良いですよ．
/ [Q]: 2 点を導通させれば良さそうなのでセンサの足を曲げて接触させても良いですか？
/ [A]: それは流石にダメです．

= ソースコード
装置に書き込まれたプログラムを以下に示す．
```cpp
struct Challenge UnknownSensor = {
    .gaming = unknown_sensor,
    .setup_pin = setup_unknown,
    .time_limit = 900,
};

// giver pin assgin
const uint8_t SENSOR = 17;
const uint8_t LED_B = 18;
const uint8_t LED_G = 19;
const uint8_t BUTTON_LEFT = 15;
const uint8_t BUTTON_RIGHT = 23;

void setup_unknown(void) {
    pinMode(LED_B, OUTPUT); // LED を点灯させるためのピン
    pinMode(LED_G, OUTPUT); // LED を点灯させるためのピン
    pinMode(SENSOR, INPUT_PULLDOWN); // センサの値を読み取るピン
    pinMode(BUTTON_LEFT, INPUT_PULLDOWN); // ボタンの入力を読み取るピン
    pinMode(BUTTON_RIGHT, INPUT_PULLDOWN); // ボタンの入力を読み取るピン
}

void unknown_sensor(void *pvParameters) {
    // 最初は全部 false
    bool flag1 = false;
    bool flag2 = false;
    bool flag3 = false;

    while(1) {
        // BUTTON_LEFT 番のピンが HIGH なら true そうでなければ false
        flag1 = (digitalRead(BUTTON_LEFT)  == HIGH);

        // BUTTON_RIGHT 番のピンが HIGH なら true そうでなければ false
        flag2 = (digitalRead(BUTTON_RIGHT)  == HIGH);

        // SENSOR 番のピンが HIGH なら true そうでなければ false
        flag3 = (digitalRead(SENSOR) == LOW);

        // もし，flag1 の中身が true だったら { } の中へ
        if (flag1) {
          digitalWrite(LED_G, HIGH);
        // そうじゃなかったら↓の { } の中へ
        } else {
          digitalWrite(LED_G, LOW);

        }

        // もし，flag3 の中身が true だったら { } の中へ
        if (flag3) {
          digitalWrite(LED_B, HIGH);
        // そうじゃなかったら↓の { } の中へ
        } else {
          digitalWrite(LED_B, LOW);

        }

        // もし，flag3 と flag2 の*両方*が true なら
        if(flag3 && flag2) {
            succeeded();
        }

        // もし，flag3 と flag1 の*両方*が true なら
        if(flag3 && flag1) {
            failed();
        }

        delay(100);
    } // while (true) { の行まで戻る
}
```

ヒントとして `flag1` と `flag3` が `true`/`false` かと LED の状態をリンクさせてみました．
これで条件が分かりやすくなっただけでなく，センサの条件が推理しやすくなったのではないでしょうか．

#pagebreak()

= 解き方
== 配線と部品を確認する
何にせよまずは配線と部品を確認しましょう．
@parts を見ると，謎の部品・フルカラーLEDとボタンが2つという構成のようです．
ボタンを押したり，謎の部品を使って解除の条件を満たしていけば良さそうです．

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

どんなときに `true` が入るかコードを見て探してみましょう．
#zebraw(
    numbering-offset: 29,
    [
        ```cpp
        // BUTTON_LEFT 番のピンが HIGH なら true そうでなければ false
        flag1 = (digitalRead(BUTTON_LEFT) == HIGH);

        // BUTTON_RIGHT 番のピンが HIGH なら true そうでなければ false
        flag2 = (digitalRead(BUTTON_RIGHT) == HIGH);

        // SENSOR 番のピンが HIGH なら true そうでなければ false
        flag3 = (digitalRead(SENSOR) == LOW);
        ```
    ],
)
落ち着いて赤と青のワイヤのときのように情報を集めていけば条件が分かるでしょう．


== 謎の部品の正体を探る
成功・失敗の条件が分かったところで，どういうときに `SENSOR` のピンが `LOW` になるか分からなければ意味がありません．

そこで販売ページにあるデータシートを別紙で配布しました．
これは部品の仕様が書かれたもので，型番や寸法，電気特性などが載っている，エンジニアが最初に読むものです．
が，こういうのは大抵共通語である英語と製造元の言語（中国が多い）で書かれていて日本語のものはありません．
エンジニアに英語能力が必要なのはこういう事情だったりします．

そんなに難しい英語は使われてないので，せっかくなので読んでみましょう#footnote[カウントダウンが迫ってるのに英語なんて読んでる暇無いって？それはそうかも……]．
単語を@word_list に補足します．
#figure(
    table(
        stroke: (x: none),
        columns: 2,
        align: (left),
        row-gutter: (2.2pt, auto),
        table.header([単語], [意味]),
        [specification], [仕様，仕様書],
        [Rating], [定格（どれくらいの電気で使えるか）],
        [angle], [角度],
        [compliant], [（ルールなどに）従っている、準拠した],
        [resistance], [抵抗],
        // [initial], [初期の，最初の],
        [temperature], [温度],
        [Electrical life], [電気的寿命（何回使えるか）],
        [Manual soldering], [手によるはんだ付け],
        [Operating temperature], [作動温度],
        [Recommended], [推奨される，おすすめの],
        [actual], [実際の],
        // [desiccant], [乾燥剤],
        [oxidation], [酸化（さびること）],
        [vibration], [振動],
        [MATERIAL], [材料、材質],
        [brass], [真鍮],
        [Au plated], [金メッキした],
        [Tin], [錫],
        [Nylon], [ナイロン],
    ),
    caption: [主な単語の意味],
)<word_list>

これだけだと内部の構造が見えづらいのでもう少し解説したものを@sensor に示します．
#figure(
    image("./images/sensor.png", width: 45%),
    caption: [謎の部品の内部構造],
)<sensor>

@sensor の赤い部分・青い部分は電気的に繋がっている（= 電気を通す）部分です．
青い部分は黒い部分を突き抜けています#footnote[つまり青い棒の部分の両端は電気的に繋がってます．]．
黒い「絶縁体」というのは電気を通さない（通しにくい）材質です#footnote[データシートにはナイロンでできていると書かれています．]．

中には球体が入っています．振ると音が鳴るのは中に"真鍮でメッキされた球体"が入っているからです．
と，ここまでくればこれが何の部品なのか分かったと思います．
いまいちピンと来ないときはまだまだヒントを用意しているので声をかけてください．
#side-color-box("やってみよう", orange)[
    この部品の目的は#underline(box(width: 21em, repeat(sym.space)))である．
]
