#import "globals.typ": *
#show: zebraw
#show: zebraw-init.with(
    lang: false,
    indentation: 4,
    background-color: rgb("#1d2433"),
    highlight-color: rgb("#2d4640"),
    comment-color: rgb("#0f1625"),
    lang-color: rgb("#0d4443"),
)
#import cosmos.fancy: *
#show: show-theorion
#set-primary-symbol[] // no symbol
#set-secondary-symbol[] // no symbol
#set-inherited-levels(1)
#set-zero-fill(true)
#set-leading-zero(true)
#set-theorion-numbering("1.1")

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(
    reduce: cetz.canvas,
    cover: cetz.draw.hide.with(bounds: true),
)
#let fletcher-diagram = touying-reducer.with(
    reduce: fletcher.diagram,
    cover: fletcher.hide,
)

#show: formal-theme.with(
    aspect-ratio: "16-9",
    // align: horizon,
    // config-common(handout: true),
    config-common(frozen-counters: (
        theorem-counter,
    )), // freeze theorem counter for animation
    config-info(
        title: [Juggernaut],
        subtitle: [爆弾解除でプログラミングと電子回路を学ぼう],
        footer-title: [Juggernaut],
        author: [Norimasa TAKANA],
        date: datetime(year: 2025, month: 11, day: 12),
        event: [International Cybersecurity Challenge TOKYO 2025],
        place: [ホテルニューオータニ幕張],
        logo: none,
    ),
)

#set terms(separator: [: ])
#set heading(numbering: numbly("{1}.", default: "1.1"))
#show raw.where(block: true): set text(size: 14pt, fill: rgb("#c2cacc"))

#let stress(body) = text(fill: rgb("#cb007b"), strong(body))

#title-slide()

= 目次 <touying:hidden>
== 本講義資料の目次 <touying:hidden>

#outline(title: none, indent: 1em)

= はじめに

== 自己紹介
#slide(composer: (1.8fr, 1fr))[
    / 名前: 髙名 典雅 (Norimasa TAKANA)
    / 所属: 筑波大学 理工情報生命学術院
    / 専門分野: システムソフトウェア，セキュリティ
    / 経歴:
        - 船橋市立大穴中学校
        - 国立木更津工業高等専門学校
        - 筑波大学 情報学群 情報科学類
        - 筑波大学 理工情報生命学術院
        - セキュリティ・キャンプ 講師
        - 未踏 スーパークリエータ
][
    #figure(
        image("images/self_portrait.png", width: 90%),
        caption: [講師近影],
    )<portrait>
]

== 今回の内容
今回は*爆弾解除*を通して*プログラミング*と*電子回路*に入門します．\
主な流れはこんな感じです．
#components.adaptive-columns[
    - 事前知識の説明（20分）
        - この競技の概要
        - 回路の基礎
        - プログラミングの基礎
        - 問題1
    - 問題2（15分）
        - 問題に挑戦してみよう
        - 解説
    - 問題3（15分）
        - 問題に挑戦してみよう
        - 解説
    - まとめ
]

#include "src/introduction.typ"
#include "src/red_or_blue.typ"
#include "src/unknown_sensor.typ"
#include "src/ultrasonic.typ"

= 付録
== 参考文献
#set text(size: 16pt, lang: "en")
#bibliography("refs.bib", title: none)
