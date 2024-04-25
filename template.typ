#let heiti = ("Source Han Sans", "Heiti SC", "Heiti TC", "SimHei")
#let songti = ("Times New Roman", "Source Han Serif SC", "Songti SC", "Songti TC", "SimSun")

#let bib_cite(..names) = {
  for name in names.pos() {
    cite(name)
  }
}

#let indent() = {
  box(width: 2em)
}

#let indent_par(body) = {
  box(width: 1.8em)
  body
}

#let equation_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("equation-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    "(" + str(chapt) + "-" + str(n + 1) + ")"
  })
}

#let table_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("table-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "-" + str(n + 1)
  })
}

#let image_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("image-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "-" + str(n + 1)
  })
}

#let algo_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("algorithm-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "-" + str(n + 1)
  })
}


#let equation(equation, caption: "") = {
  figure(
    equation,
    caption: caption,
    supplement: [公式],
    numbering: equation_num,
    kind: "equation",
  )
}

#let tbl(tbl, caption: "") = {
  figure(
    tbl,
    caption: caption,
    supplement: [表],
    numbering: table_num,
    kind: "table",
  )
}

#let img(img, caption: "") = {
  figure(
    img,
    caption: caption,
    supplement: [图],
    numbering: image_num,
    kind: "image",
  )
}

#let figure_algo(algorithm, caption: "") = {
  figure(
    algorithm,
    caption: caption,
    supplement: [算法],
    numbering: algo_num,
    kind: "algorithm",
  )
}


#let empty_par() = {
  v(-1em)
  box()
}

// inspired from https://github.com/lucifer1004/pkuthss-typst.git
#let chinese_outline() = {
  align(center)[
    #text(font: heiti, size: 18pt, weight: "medium")[*目录*]
  ]

  set text(font: songti, size: 12pt)
  // 临时取消目录的首行缩进
  set par(leading: 1.24em, first-line-indent: 0pt)
  locate(loc => {
    let elements = query(heading.where(outlined: true), loc)
    for el in elements {
      // 是否有 el 位于前面，前面的目录中用拉丁数字，后面的用阿拉伯数字
      let before_toc = query(heading.where(outlined: true).before(loc), loc).find((one) => {one.body == el.body}) != none
      let page_num = if before_toc {
        numbering("I", counter(page).at(el.location()).first())
      } else {
        counter(page).at(el.location()).first()
      }

      link(el.location())[#{
        // acknoledgement has no numbering
        let chapt_num = if el.numbering != none {
          numbering(el.numbering, ..counter(heading).at(el.location()))
        } else {none}

        if el.level == 1 {
          if chapt_num == none {
            text(weight: "bold")[#el.body]
          } else {
             text(weight: "bold")[#chapt_num]
            el.body
          }
        } else {
          let level = el.level - 1
          h(2em*level)
          chapt_num
          el.body
        }
      }]

      // 填充 ......
      box(width: 1fr, h(0.5em) + box(width: 1fr, repeat[.]) + h(0.5em))
      [#page_num]
      linebreak()
    }
  })
}

// 原创性声明和授权书
#let declaration(anonymous: false) = {
  set text(font: songti, 12pt)

  v(5em)
  align(center)[
    #text(font: heiti, size: 18pt)[
      学位论文原创性声明
    ]
  ]
  text(font: songti, size: 12pt)[
    #set par(justify: false, leading: 1.24em, first-line-indent: 2em)
    本人郑重声明：所呈交的论文是本人在导师的指导下独立进行研究所取得的 研究成果。除了文中特别加以标注引用的内容外，本论文不包括任何其他个人或集体已经发表或撰写的成果作品。本人意识到本声明的法律后果由本人承担。
  ]
  v(2em)
  align(right)[
    #if not anonymous {
      text("作者签名：　　　　　　　年　　月　　日")
    } else {
      text("作者签名：██████████年███月███日")
    }
  ]
  
  v(6em)
  align(center)[
    #text(font: heiti, size: 18pt)[
      学位论文版权使用授权书
    ]
  ]
  text(font: songti, size: 12pt)[
    #set par(justify: false, leading: 1.24em, first-line-indent: 2em)
    #if not anonymous [
      本学位论文作者完全了解学校有关保障、使用学位论文的规定，同意学校保留并向有关学位论文管理部门或机构送交论文的复印件和电子版，允许论文被查阅和借阅。本人授权省级优秀学士论文评选机构将本学位论文的全部或部分内容编入有关数据进行检索，可以采用影印、缩印或扫描等复制手段保存和汇编本学位论文。
    ] else [
      本学位论文作者完全了解学校有关保障、使用学位论文的规定，同意学校保留并向有关学位论文管理部门或机构送交论文的复印件和电子版，允许论文被查阅和借阅。本人授权█████████████将本学位论文的全部或部分内容编入有关数据进行检索，可以采用影印、缩印或扫描等复制手段保存和汇编本学位论文。
    ]
    

    学位论文属于 1、保密 □，在#h(3em)年解密后适用本授权书。

    #h(6.3em) 2、不保密 □

    #h(6.3em)请在以上相应方框内打 “√”
  ]

  v(3em)
  align(right)[
    #if not anonymous {
      text("作者签名：　　　　　　　年　　月　　日")
    } else {
      text("作者签名：██████████年███月███日")
    }
  ]

  align(right)[
    #if not anonymous {
      text("导师签名：　　　　　　　年　　月　　日")
    } else {
      text("导师签名：██████████年███月███日")
    }
  ]
}

// 参考文献
#let references(path) = {
  // 这个取消目录里的 numbering
  set heading(level: 1, numbering: none)

  set par(justify: false, leading: 1.24em, first-line-indent: 2em)

  show <_refs>: {
    set align(center)
    set text(font: heiti, size: 18pt)
    [*参考文献*]
  } + empty_par()

  [= 参考文献 <_refs>]

  bibliography(path, title: none, style: "gb-7714-2015-numeric")
}


// 致谢，请手动调用
#let acknowledgement(zky: false, body) = if zky {} else {
  // 这个取消目录里的 numbering
  set heading(level: 1, numbering: none)
  show <_thx>: {
    set align(center)
    set text(font: heiti, size: 18pt)
    [*致谢*]
  } + empty_par()

  if not zky {
    [= 致谢 <_thx>]
  }

  body
}

// 中文摘要
#let zh_abstract_page(abstract, keywords: ()) = {
  set heading(level: 1, numbering: none)
  show <_zh_abstract_>: {
    align(center)[
      #text(font: heiti, size: 18pt, weight: "medium")[*摘要*]
    ]
  }
  [= 摘要 <_zh_abstract_>]

  set text(font: songti, size: 12pt)

  abstract
  par(first-line-indent: 2em)[
    #text(font: songti, size: 12pt)[
      关键词：#keywords.join("，")
    ]
  ]
}

// 英文摘要
#let en_abstract_page(abstract, keywords: ()) = {
  set heading(level: 1, numbering: none)
  show <_en_abstract_>: {
    align(center)[
      #text(font: heiti, size: 18pt, weight: "medium")[*Abstract*]
    ]
  }
  [= Abstract <_en_abstract_>]

  set text(font: songti, size: 12pt)

  abstract
  par(first-line-indent: 2em)[
    #text(font: songti, size: 12pt)[
      Key Words: #keywords.join(", ")
    ]
  ]
}

#let project(
  anonymous: false, // 是否匿名化处理
  zky: false,
  title: "",
  abstract_zh: [],
  abstract_en: [],
  keywords_zh: (),
  keywords_en: (),
  institution: (),
  first_public_at: (),
  author_email: (),
  school: "",
  author: "",
  id: "",
  mentor: "",
  class: "",
  graduated_time: "2024年6月",
  date: (2021, 3, 1),
  body,
) = {
  // 引用的时候，图表公式等的 numbering 会有错误，所以用引用 element 手动查
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      let el = it.element
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)

      // 自动跳转
      link(loc)[#if el.kind == "image" or el.kind == "table" or el.kind == "algorithm" {
          // 每章有独立的计数器
          let num = counter(el.kind + "-chapter" + str(chapt)).at(loc).at(0) + 1
          it.element.supplement
          " "
          str(chapt)
          "-"
          str(num)
        } else if el.kind == "equation" {
          // 公式有 '(' ')'
          let num = counter(el.kind + "-chapter" + str(chapt)).at(loc).at(0) + 1
          it.element.supplement
          " ("
          str(chapt)
          "-"
          str(num)
          ")"
        } else {
          it
        }
      ]
    } else {
      it
    }
  }

  // 图表公式的排版
  show figure: it => {
    set align(center)
    if it.kind == "image" {
      set text(font: songti, size: 12pt)
      it.body
      set text(weight: "bold")
      it.supplement
      " " + it.counter.display(it.numbering)
      "　" + it.caption.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("image-chapter" + str(chapt))
        c.step()
      })
    } else if it.kind == "table" {
      set text(font: songti, size: 12pt, weight: "bold")
      it.supplement
      " " + it.counter.display(it.numbering)
      "　" + it.caption.body
      set text(font: songti, size: 10.5pt)
      set text(weight: "medium")
      it.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("table-chapter" + str(chapt))
        c.step()
      })
    } else if it.kind == "algorithm" {
      set text(weight: "medium")
      it.body
      set text(font: songti, size: 12pt, weight: "bold")
      it.supplement
      " " + it.counter.display(it.numbering)
      "　" + it.caption.body
      set text(font: songti, size: 10.5pt)
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("algorithm-chapter" + str(chapt))
        c.step()
      })
    }
    
    else if it.kind == "equation" {
      // 通过大比例来达到中间和靠右的排布
      grid(
        columns: (20fr, 1fr),
        it.body,
        align(center + horizon, 
          it.counter.display(it.numbering)
        )
      )
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("equation-chapter" + str(chapt))
        c.step()
      })
    } else {
      it
    }
  }
  set page(paper: "a4", margin: (
    top: 2.5cm,
    bottom: 2.5cm,
    left: 3cm,
    right: 3cm
  ))

  // 封面
  let scnufm = align(center)[
    // SCNU logo
    #v(20pt)

    #if anonymous {
      text(size: 5em)[
        $X X X X$ 大学
      ]
    } else {
      image("./imgs/paper-scnu.svg", width: 80%)
    }

    // #v(30pt)

    #text(
      size: 24pt,
      font: songti
    )[*本科毕业论文（设计）*]

    #v(40pt)

    // #text(
    //   font: heiti,
    //   size: 22pt,
    // )[
    //   #title
    // ]

    #v(80pt)

    #let info_value(body) = {
      rect(
        width: 100%,
        inset: 2pt,
        stroke: (
          bottom: 1pt + black
        ),
        text(
          font: songti,
          size: 14pt,
          bottom-edge: "descender"
        )[
          #body
        ]
      ) 
    }
    
    #let info_key(body) = {
      rect(width: 100%, inset: 2pt, 
       stroke: none,
       text(
        font: songti,
        size: 14pt,
        body
      ))
    }

    #grid(
      columns: (68pt, 314pt),
      rows: (40pt, 40pt),
      // gutter: 3pt,
      info_key("论文题目："),
      info_value(if not false { title } else { "██████████" }),
      info_key("指导老师："),
      info_value(if not anonymous { mentor } else { "██████████" }),
      info_key("学生姓名："),
      info_value(if not anonymous { author } else { "██████████" }),
      info_key("学　　号："),
      info_value(if not anonymous { id } else { "██████████" }),
      info_key("院　　系："),
      info_value(if not anonymous { school } else { "██████████" }),
      info_key("专　　业："),
      info_value(if not anonymous { class } else { "██████████" }),
      info_key("毕业时间："),
      info_value(if not anonymous { graduated_time } else { "██████████" }),
    )

    #v(30pt)
    #let 某年某月制 = text(
      font: songti,
      size: 16pt,
    )[
      2024 年 3 月 制
    ]

    // #某年某月制

    // #pagebreak()
  ]

  let zkyfm = align(center)[
    #text(size: 22pt, weight: "medium", font: heiti)[
        #title
    ]
    
    #set par(leading: 0.75em)
    #set text(size: 1.0em)
    #author$\ ^(
      #for i in range(institution.len()){
        [#(i + 1)]
      }
    )$#footnote(numbering: "*")[
          初公开于：#first_public_at
        ]#footnote(numbering: "*")[
      作者邮箱：#author_email
    ]\
    #for i in range(institution.len()) {
      $\ ^#(i + 1)$
      institution.at(i)
      v(-0.5em)
    }
    #date.display()#footnote(numbering: "*")[
          版本日期：#datetime.today().display()
        ]
    #v(6em)
  ]

  if zky {
    // zkyfm
  }else{
    scnufm

    counter(page).update(0)
  }

  // 原创性声明
  // declaration(anonymous: anonymous)
  // pagebreak()
  // 页眉
  set page(
    header: {
      set text(font: songti, 10pt, baseline: 8pt, spacing: 3pt)
      set align(center)
      if not anonymous {
        [华 南 师 范 大 学 毕 业 设 计 （ 论 文 ） ]
      } else {
        [█████████████████████████]
      }
      
      line(length: 100%, stroke: 1pt)
      counter(footnote).update(0)
    }
  )

  // 页脚
  // 封面不算页数
  set page(
    footer: {
      set align(center)
      
      grid(
        columns: (5fr, 1fr, 5fr),
        line(length: 100%, stroke: 1pt),
        text(font: songti, 10pt, baseline: -3pt, 
          counter(page).display("I")
        ),
        line(length: 100%, stroke: 1pt)
      )
    }
  )

  set text(font: songti, 12pt)
  set par(justify: true, leading: 1.24em, first-line-indent: 2em)
  show par: set block(spacing: 1.24em)

  set heading(numbering: (..nums) => {
    nums.pos().map(str).join(".") + "　"
  })
  show heading.where(level: 1): it => {
    set align(center)
    set text(weight: "bold", font: songti, size: 20pt)
    set block(spacing: 1.5em)
    it
  }
  show heading.where(level: 2): it => {
    set text(weight: "bold", font: songti, size: 14pt)
    set block(above: 1.5em, below: 1.5em)
    it
  }

  // 首段不缩进，手动加上 box
  show heading: it => {
    set text(weight: "bold", font: songti, size: 12pt)
    set block(above: 1.5em, below: 1.5em)
    it
  } + empty_par()

  if not zky {
    pagebreak()
  }else{
    zkyfm
  }
  counter(page).update(1)

  // 摘要
  zh_abstract_page(abstract_zh, keywords: keywords_zh)

  pagebreak()

  // abstract
  en_abstract_page(abstract_en, keywords: keywords_en)

  pagebreak()

  // 目录
  chinese_outline()

  // 正文的页脚
  
  set page(
    footer: {
      set align(center)
      
      grid(
        columns: (5fr, 1fr, 5fr),
        line(length: 100%, stroke: 1pt),
        text(font: songti, 10pt, baseline: -3pt, 
          counter(page).display("1")
        ),
        line(length: 100%, stroke: 1pt)
      )
    }
  )


  counter(page).update(1)

  show raw: it => {
    set text(
    font: "New Computer Modern Mono")
    set block(inset: 6pt)
    it
  }

  show heading: set heading(
    supplement: [章节],
  )

  body
}

// 三线表
#let tlt_header(content) = {
  set align(center)
  rect(
    width: 100%,
    stroke: (bottom: 1pt),
    [#content],
  )
}

#let tlt_cell(content) = {
  set align(center)
  rect(
    width: 100%,
    stroke: none,
    [#content]
  )
}

#let tlt_row(r) = {
  (..r.map(tlt_cell).flatten())
}

#let three_line_table(values) = {
  rect(
    stroke: (bottom: 1pt, top: 1pt),
    inset: 0pt,
    outset: 0pt,
    grid(
      columns: (auto),
      rows: (auto),
      // table title
      grid(
        columns: values.at(0).len(),
        ..values.at(0).map(tlt_header).flatten()
      ),

      grid(
        columns: values.at(0).len(),
        ..values.slice(1).map(tlt_row).flatten()
      ),
    )
  )
}

#let TeX = style(styles => {
  set text(font: "New Computer Modern")
  let e = measure("E", styles)
  let T = "T"
  let E = text(1em, baseline: e.height * 0.31, "E")
  let X = "X"
  box(T + h(-0.15em) + E + h(-0.125em) + X)
})

#let LaTeX = style(styles => {
  set text(font: "New Computer Modern")
  let a-size = 0.66em
  let l = measure("L", styles)
  let a = measure(text(a-size, "A"), styles)
  let L = "L"
  let A = box(scale(x: 105%, text(a-size, baseline: a.height - l.height, "A")))
  box(L + h(-a.width * 0.67) + A + h(-a.width * 0.25) + TeX)
})