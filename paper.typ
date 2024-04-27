#import "template.typ": *
#import "@preview/codelst:2.0.0": sourcecode
#import "@preview/tablex:0.0.8": tablex, colspanx, rowspanx, hlinex, vlinex
#import "@preview/algo:0.3.3": algo, i, d, comment, code

#let title = "一种基于XXXXXXXX的研究"
#let author = "作者姓名"
#let keywords_zh = ("华南师范大学", "论文", "排版", "编程语言")
#let keywords_en = ("SCNU", "Paper", "Typesetting", "Programming Language")
#let author_id = 20202012345
#let mentor = "导师姓名"
#let date = datetime(year: 2024, month: 3, day: 26)
#let institution = ("华南师范大学软件学院", "XXXX公司")
#let author_email = link("mailto:author@email.com")[author\@email.com]
#let first_public_at = [https://github.com/HK-SHAO/SCNU-Typst-Template]

#let anonymous = false
#let zky = false


#if anonymous {
  author = "█████"
  mentor = "█████"
  author_id = "█████"
  author_email = "█████"
  institution = ("█████", )
  first_public_at = [█████]
}

#set text(
  font: "New Computer Modern Mono", size: 12pt)

#show: project.with(
  anonymous: anonymous,
  zky: zky,
  title: title,
  author: author,
  keywords_zh: keywords_zh,
  keywords_en: keywords_en,
  institution: institution,
  author_email: author_email,
  first_public_at: first_public_at,
  school: "软件学院",
  id: author_id,
  mentor: mentor,
  class: "软件工程",
  graduated_time: "2024年6月",
  date: date,
  abstract_zh: [

此模板轻度修改自本人的文章《引导大语言模型生成计算机可解析内容@wang2024guiding》和对应的幻灯片。请必须知悉这不是官方模板，仅供参考。每一届、每一个老师可能都会有不同的标准，请务必做好修改本模板以满足上级要求的准备。

请自行解决好 `Source Han Sans`, `Source Han Serif SC` 等字体。 #lorem(90)

#lorem(38) 本模板的源代码在：https://github.com/HK-SHAO/SCNU-Typst-Template
  ],
  abstract_en: [
#lorem(40)

#lorem(80)

#lorem(38) 本模板的源代码在：https://github.com/HK-SHAO/SCNU-Typst-Template
  ],
)


= 绪论

== 选题背景及意义

#lorem(320)@Lundberg2024guidance

#pagebreak()
== 国内外研究现状

#lorem(80)

=== #lorem(4)

#lorem(80)@radford2018improving

=== #lorem(4)


#lorem(80)@yao2023react

#pagebreak()

=== #lorem(4)

#lorem(80)

== 课题研究内容

#lorem(60)


== 论文结构安排

#lorem(80)


== 本章小结

#lorem(40)

#pagebreak()
= 模板的基础用法

== 脚注

这是一个脚注#footnote[我是脚注内容]。

== 图片

#img(caption: [图片名])[
  #rect(inset: 1em)[图片内容]
] <img1>

引用#[@img1]了。#[@img2]引用了 #cite(label("Burghardt2020"), style: "gb-7714-2015-author-date") 。

#img(caption: [C语言的语法示意图@Burghardt2020])[
  #image("imgs/C_grammar_stmt_svg.svg")
] <img2>

== 表格

#tbl(caption: [错误率 $r(e)$ 与平均字符串长度 $|s|$ 的关系])[
  #align(center)[
  #tablex(
  columns: 5,
  align: center + horizon,
  auto-vlines: false,
  auto-hlines: false,
  repeat-header: true,
  hlinex(),
  [模型名称],[参数量],[$"Date"^("GMT"+8)$],[$|s|_(r(e)> 50%)$], 
  hlinex(),
  [$|s|_(r(e)> 95%)$],
  [GPT-2], [117M],  [2019-2-14], [$14$], [$20$],
  [GPT-2 Large], [774M],[2019-2-14],[$24$],  [$32$],
  [GPT-2 XL], [1558M],[2019-2-14], [$32$], [$36$],
  [Gemma], [7751M],[2024-2-21], [$194$], [$282$],
  hlinex(),
)]] <tbl01>

#pagebreak()
== 算法

#figure_algo(
  caption: [约束大模型生成DSL的算法@wang2023grammar])[
#algo(
  title: [
    #set text(size: 15pt)
    #emph(smallcaps("Constrained-Generation"))
  ],
  parameters: ([$x in Sigma^*$], [$G: "CFG"$]),
  comment-prefix: none,
  indent-size: 2em,
  indent-guides: 1pt + gray,
  row-gutter: 0.5em,
  column-gutter: 0.5em,
  inset: 0.5em,
  stroke: 2pt + black,
  fill: none,
)[
  #let stsr = sym.triangle.stroked.r
  #let comm(x) = text(size: 9pt, x)
  $hat(y) <- epsilon$#comment[#h(-12em)#comm[#stsr 初始化空串 $epsilon$]]\
  while *True*:#i\
  $macron(y) <- "decode" P_("LLM")(y | x,G,hat(y),dots)$\
  $hat(y) <- hat(y)dot macron(y)#comment[#h(-10em)#comm[#stsr 连接串并更新 $hat(y)$]]$\
  if $hat(y) in L(G)$:#comment[#h(-10em)#comm[#stsr 尝试验证串 $hat(y) in L(G)$]]#i\
    return $hat(y)$#comment[#h(-8em)#comm[#stsr 返回预期的DSL]]#d\
  else:#i\
    $y_("prefix"), M_P (y_("prefix")) <- "Generator"(hat(y), G)$\
    $omega^* <- arg max P_("LLM") (omega | omega in M_P (y_("prefix"))，y_("prefix"),dots)$\
    $hat(y) <- y_("prefix")dot omega^*$#comment[#h(-8em)#comm[#stsr 更新 $hat(y) in P(G)$]]
    #d#d
]
] <algo001>

引用#[@algo001]了。

== 公式

这是行内 $sum_(i=1)^x (sum_(j=1)^y i j)$ 公式。

$
f(x, y) = sum_(i=1)^x (sum_(j=1)^y i j)
$

上面是行间公式。这是行内代码 #box(stroke: 1pt, inset: 0.3em, baseline: 0.2em, radius: 0.5em)[```ts let abc = 123;```] 。

== 代码
#v(-1em)
#img(caption: [这是代码的图])[
#set par(leading: 0.39em)
  ```py
class MermaidGenerator(TextGenerator):
    def top(self):
        yield self.mermaid
    def mermaid(self):
        match (yield self.graph_name):
            case 'flowchart':
                yield self.flowchart
    def graph_name(self):
        yield select('flowchart')
    def flowchart(self):
        yield (' ', self.flowchart_type, '\n')
        yield join('\n', self.flowchart_rules)
    def flowchart_type(self):
        yield select('TD', 'LR')
    def flowchart_rules(self):
        rand_times = randint(10, 20)
        single_line = (' '*4, self.flowchart_rule)
        yield from repeat(single_line, rand_times)
    def flowchart_rule(self):
        yield self.node
        yield ' --> '
        yield self.node
    def node(self):
        yield select(*range(1, 10))
  ```
]

#pagebreak()
= #lorem(4)

#lorem(40)

== #lorem(4)

#lorem(300)@Scholak2021:PICARD

== #lorem(4)

#lorem(300)@Sveidqvist2014

#pagebreak()
= #lorem(4)

#lorem(40)

== #lorem(4)

#lorem(280)

#pagebreak()
== #lorem(4)

#lorem(300)

#pagebreak()
= #lorem(4)

#lorem(40)

== #lorem(4)

#lorem(300)

== #lorem(4)

#lorem(300)


#pagebreak()

#references("./refs.bib")

#if not zky {
  pagebreak()
}

#acknowledgement(zky: zky)[

#lorem(100)

#lorem(100)

#lorem(100)

#lorem(30)
]