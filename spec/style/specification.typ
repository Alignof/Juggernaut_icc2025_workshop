// This function gets your whole document as its `body` and formats
// it as an article in the style of the IEEE.

#let style(
    // The paper's title.
    title: "Challenge Title",
    // Challenge ID
    number: (),
    // Author
    author: (),
    // Date
    date: (),
    // Time limit
    time_limit: (),
    // The article's paper size. Also affects the margins.
    paper-size: "a4",
    // The paper's content.
    body,
) = {
    // Set document metadata.
    set document(title: title, author: author.name)

    // Set the body font.
    set text(lang: "ja", size: 10pt, font: "Noto Serif CJK JP")

    // Set image size.
    set image(width: 80%)

    // Set table caption upper.
    show figure.where(
        kind: table,
    ): set figure.caption(position: top)

    // Configure the page.
    set page(
        paper: paper-size,
        // The margins depend on the paper size.
        margin: if paper-size == "a4" {
            (x: 61.5pt, top: 40.51pt, bottom: 49.51pt)
        },
        // header: align(right, text(8pt)[
        //     Juggernaut\#002
        // ]),
        footer: align(left, text(8pt)[
            $copyright$ 2020 Norimasa TAKANA
        ]),
        numbering: "1",
    )

    set text(
        lang: "ja",
        size: 12pt,
        font: (
            (name: "Open Sans", covers: "latin-in-cjk"),
            "Noto Sans CJK JP",
        ),
    )
    set footnote.entry(
        separator: line(
            start: (0% + 1em, 0% + 0pt),
            length: 30% + 10pt,
            stroke: 0.5pt,
        ),
        indent: 3em,
    )
    set terms(separator: [: ])
    set scale(reflow: true)
    set list(indent: 1em, spacing: 1.03em)
    set enum(indent: 1em, spacing: 1.03em)
    set raw(theme: "../monokai.tmTheme", tab-size: 4)

    show figure: set block(breakable: true)
    show figure.where(
        kind: table,
    ): set figure.caption(position: top)

    show raw: it => {
        show regex("pinxxx\d"): it => pin(eval(it.text.slice(6)))
        it
    }
    show raw.where(block: false): box.with(
        fill: luma(240),
        inset: (x: 3pt),
        outset: (y: 6pt),
        radius: 6pt,
    )
    show raw.where(block: true): set text(size: 10pt, fill: rgb("#c2cacc"))

    // Configure equation numbering and spacing.
    set math.equation(numbering: "(1)")
    show math.equation: set block(spacing: 0.65em)

    // Configure headings.
    set heading(numbering: "1.")

    set par(
        first-line-indent: (amount: 1em, all: true),
        justify: true,
    )

    // Display the paper's title.
    figure(
        image("../images/logo.png", width: 80%),
    )
    v(6mm, weak: true)
    figure(
        table(
            columns: (20%, 70%),
            stroke: (x: none),
            align: left,
            table.hline(y: 1, start: 0),
            table.vline(x: 1, start: 0),
            [装置名], [#title],
            [装置番号], [#number],
            [作問者], [#author.name],
            [作問日], [#date.display()],
            [制限時間], [#time_limit.display()],
        ),
    )
    v(12mm, weak: true)

    counter(figure.where(kind: figure)).update(0)
    counter(figure.where(kind: table)).update(0)

    // Display the paper's contents.
    body
}

