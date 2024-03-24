// 计划放入家目录下的 typst 包目录中，制成包来使用

#let report_config(
  title: none,
  author: "段子涛",
  body,
) = {
  // 设置报告的元信息
  set document(author: author, title: title)

  // 设置字体
  set text(
    size: 12pt,
    font: ("STIX Two Text", "Source Han Serif SC")
  )
  show raw: set text(
    font: "Source Han Sans SC"
  )

  // 配置页面属性
  set page(numbering: "— 1 —")

  // 配置列表属性
  set list(marker: "﹡")

  // 配置标题显示样式
  set heading(numbering: "一、")
  show heading: it => {
    it
    v(-0.6em)
    box()
  }

  body
}

#let subreport(
  title: none,
  author: "段子涛",
  position: "济事楼 330",
  cooperator: "无",
  date: none,
  body
) = {
  // 初始化页面
  pagebreak(weak: true)
  counter(page).update(1)
  counter(heading).update(0)

  // 标题
  align(
    center,
    text(22pt)[
      *#title*
    ],
  )

  // 图表样式（无用）
  //show figure.where(
  //  kind: table
  //): set figure(supplement: [表格])
  //show figure.where(
  //  kind: figure
  //): set figure(supplement: [图片])

  // 报告作者信息
  pad(
    x: 4em,
    top: 0.5em,
    bottom: 1em,
    grid(
      columns: (1fr, 1fr),
      align(left)[
        学生姓名：#author \
        实验地点：#position
      ],
      align(left)[
        合作学生：#cooperator \
        实验时间：#date
      ],
    )
  )

  // Main body
  set par(justify: true, first-line-indent: 2em, leading: 1em)

  body
}

#let report(
  title: none,
  author: "段子涛",
  position: "济事楼 330",
  cooperator: "无",
  date: none,
  body
) = {
  show: report_config.with(
    title: title,
    author: author,
  )

  subreport(
    title: title,
    author: author,
    position: position,
    cooperator: cooperator,
    date: date,
    body,
  )
}

// from: https://typst.app/ 的模版
// This function gets your whole document as its `body` and formats
// it as a simple fiction book.
#let book(
  // The book's title.
  title: [Book title],

  // The book's author.
  author: "Author",

  // The paper size to use.
  paper: "iso-b5",

  // A dedication to display on the third page.
  dedication: none,

  // Details about the book's publisher that are
  // display on the second page.
  publishing-info: none,

  // The book's content.
  body,
) = {
  // Set the document's metadata.
  set document(title: title, author: author)

  // Set the body font. TeX Gyre Pagella is a free alternative
  // to Palatino.
  //set text(font: "TeX Gyre Pagella")
  set text(font: ("STIX Two Text", "Source Han Serif SC"))

  // Configure the page properties.
  set page(
    paper: paper,
    margin: (bottom: 1.75cm, top: 2.25cm),
  )

  // The first page.
  page(align(center + horizon)[
    #text(2em)[*#title*]
    #v(2em, weak: true)
    #text(1.6em, author)
  ])

  // Display publisher info at the bottom of the second page.
  if publishing-info != none {
    align(center + bottom, text(0.8em, publishing-info))
  }

  pagebreak()

  // Display the dedication at the top of the third page.
  if dedication != none {
    v(15%)
    align(center, strong(dedication))
  }

  // Books like their empty pages.
  pagebreak(to: "odd")

  // Configure paragraph properties.
  set par(leading: 0.78em, first-line-indent: 12pt, justify: true)
  show par: set block(spacing: 0.78em)

  // Start with a chapter outline.
  outline(title: [Chapters])

  // Configure page properties.
  set page(
    numbering: "1",

    // The header always contains the book title on odd pages and
    // the chapter title on even pages, unless the page is one
    // the starts a chapter (the chapter title is obvious then).
    header: locate(loc => {
      // Are we on an odd page?
      let i = counter(page).at(loc).first()
      if calc.odd(i) {
        return text(0.95em, smallcaps(title))
      }

      // Are we on a page that starts a chapter? (We also check
      // the previous page because some headings contain pagebreaks.)
      let all = query(heading, loc)
      if all.any(it => it.location().page() in (i - 1, i)) {
        return
      }

      // Find the heading of the section we are currently in.
      let before = query(selector(heading).before(loc), loc)
      if before != () {
        align(right, text(0.95em, smallcaps(before.last().body)))
      }
    }),
  )

  // Configure chapter headings.
  set heading(numbering: "I.")
  show heading.where(level: 1): it => {
    // Always start on odd pages.
    pagebreak(to: "odd")

    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    v(5%)
    text(2em, weight: 700, block([#number #it.body]))
    v(1.25em)
  }
  show heading: set text(11pt, weight: 400)

  counter(page).update(1)

  body
}
