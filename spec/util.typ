#import "@preview/showybox:2.0.4": showybox
#import "@preview/zebraw:0.5.5": *

#let def-box(def_title, body) = {
    showybox(
        title-style: (
            weight: 2500,
            color: green.darken(60%),
            sep-thickness: 0pt,
            align: left,
        ),
        frame: (
            title-color: green.lighten(80%),
            border-color: green.darken(40%),
            thickness: (left: 1pt),
            radius: 0pt,
        ),
        title: "定義: " + def_title,
    )[ #body ]
}

#let term-box(def_title, body) = {
    showybox(
        title-style: (
            weight: 2500,
            color: green.darken(60%),
            sep-thickness: 0pt,
            align: left,
        ),
        frame: (
            title-color: green.lighten(80%),
            border-color: green.darken(40%),
            thickness: (left: 1pt),
            radius: 0pt,
        ),
        title: "用語: " + def_title,
    )[ #body ]
}

#let side-color-box(def_title, color, body) = {
    showybox(
        title-style: (
            weight: 2500,
            color: color.darken(60%),
            sep-thickness: 0pt,
            align: left,
        ),
        frame: (
            title-color: color.lighten(80%),
            border-color: color.darken(40%),
            thickness: (left: 1pt),
            radius: 0pt,
        ),
        title: def_title,
    )[ #body ]
}

#let mybox(body, title: "", color: red) = {
    showybox(
        title-style: (
            boxed-style: (:),
            weight: 1500,
            color: white,
            align: left,
        ),
        shadow: (
            color: black.lighten(80%),
            offset: 3pt,
        ),
        frame: (
            thickness: 1.5pt,
            title-color: color.darken(50%),
            body-color: color.lighten(90%),
            title-inset: 10pt,
        ),
        title: title,
        body,
    )
}

#let terminal(body) = {
    zebraw(
        numbering: false,
        indentation: 0,
        inset: (top: 4pt, bottom: 4pt, left: 6pt),
        body,
    )
}


#let quote_block(body) = {
    block(width: 100%, fill: silver, inset: 8pt, body)
}

