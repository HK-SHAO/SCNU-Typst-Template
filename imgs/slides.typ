#import "./touying/lib.typ": *
#import "@preview/tablem:0.1.0": tablem
#import "@preview/tablex:0.0.8": tablex, colspanx, rowspanx, hlinex, vlinex
#import "@preview/algo:0.3.3": algo, i, d, comment, code

#let songti = ("New Computer Modern",
 "Source Han Serif SC", "Songti SC", "Songti TC", "SimSun")
#let heiti = ("SimHei", "Source Han Sans")
#set text(size: 25pt, font: songti, lang: "cn")
#show page: set page(margin: (bottom: 8pt))
#show footnote.entry: set text(size: 14pt)
#set footnote.entry(gap: 0.4em)

#show raw: set text(
  font: ("New Computer Modern Mono", "KaiTi"), size: 18pt)

#let algo01 = [
#[
#set text(size: 16pt)
#set par(leading: 0.2em)
#algo(
  title: [
    #emph(smallcaps("Constrained-Generation"))
  ],
  parameters: (([$x in Sigma^*, G: "CFG"$]),),
  comment-prefix: none,
  indent-size: 1em,
  indent-guides: 1pt+gray,
  row-gutter: 5pt,
  column-gutter: 6pt,
  inset: 0.5em,
  stroke: 2pt + black,
  fill: none,
)[
  #let stsr = sym.triangle.stroked.r
  $hat(y) <- epsilon$#comment[#h(-12em)#text(size: 12pt)[#stsr 初始化空串 $epsilon$]]\
  while *True*:#i\
  $macron(y) <- "decode" P_("LLM")(y | x,G,hat(y),dots)$\
  $hat(y) <- hat(y)dot macron(y)#comment[#h(-10em) #text(size: 12pt)[#stsr 连接串并更新 $hat(y)$]]$\
  if $hat(y) in L(G)$:#comment[#h(-10em) #text(size: 12pt)[#stsr 尝试验证串 $hat(y) in L(G)$]]#i\
    return $hat(y)$#comment[#h(-8em) #text(size: 12pt)[#stsr 返回预期的DSL]]#d\
  else:#i\
    $y_("prefix"), M_P (y_("prefix")) <- bold("Generator")(hat(y), G)$\
    $omega^* <- arg max P_("LLM") (omega | omega in M_P (y_("prefix"))，y_("prefix"),dots)$\
    $hat(y) <- y_("prefix")dot omega^*$#comment[#h(-8em) #text(size: 12pt)[#stsr 更新 $hat(y) in P(G)$]]
    #d#d
]
]
]

#let algo-02 = [
  #set text(size: 16pt)
  #set par(leading: 0.2em)
  #algo(
  title: [
    #emph(smallcaps("First"))
  ],
  parameters: (([$A in N$]),),
  comment-prefix: none,
  indent-size: 1em,
  indent-guides: 1pt + gray,
  row-gutter: 5pt,
  column-gutter: 6pt,
  inset: 0.5em,
  stroke: 2pt + black,
  fill: none,
)[
  #let stsr = sym.triangle.stroked.r
  $s <- emptyset$\
  for $(A -> alpha)$ in $P$:#i\
  if $alpha -> epsilon$:#i\
    $s <- s union {epsilon}$#d\
  else if $alpha = a in Sigma$:#i\
    $s <- s union {a}$#d\
  else if $alpha = B in N$:#i\
    $s <- s union "First"(B)$
    #d#d\
  return $s$ 
]
]

#let show-jsonnext = align(center)[
#rect(stroke: 1pt, radius: 0.5em)[
  #link(label("edge"))[#image("../assets/zz03.png", width: 80%)] <jsonnext>]
]

#let show-edge = link(label("jsonnext"))[#image("../assets/zz04.png", width: 100%) <edge> ]

#let s = themes.dewdrop.register(
  aspect-ratio: "16-9",
  footer: [
    #text(font: heiti, fill: rgb("#000000").lighten(90%))[《引导大语言模型生成计算机可解析内容》 $dot.c$ 王家晔 #h(1fr) 华南师范大学本科毕设答辩#h(1em)]
    ],
  navigation: "sidebar",
  sidebar: (width: 10em),
  alpha: 33%,
  )
#(s.outline-title = [大纲 (Outline)])
#let s = (s.methods.info)(
  self: s,
  title: [#text(size: 28pt)[*引导大语言模型生成计算机可解析内容*
  #footnote(numbering: "1")[
    初公开于：https://chinaxiv.org/abs/202403.00340
  ]
  #footnote()[
    英文版本：https://arxiv.org/abs/2404.05499
  ]
  ]],
  subtitle: [Guiding Large Language Models to Generate\ Computer-Parsable Content],
  author: [王家晔
  #counter(footnote).update(0)
  #footnote(numbering: numbering("*", 1))[
    作者邮箱：#link("mailto:hk-shao@outlook.com")[hk-shao\@outlook.com]
  ]~$dot.c$~2024/4/22\
  答辩第四小组~$dot.c$~指导老师蔡妍\
  // 此工作由作者在腾讯PCG实习期间独立完成
  ],
  // date: datetime.today(),
  institution: [
    #box(baseline: 0.8em)[#image("../assets/paper-scnu.svg", width: 40%)] #text(size: 24pt, font: heiti)[~$dot.c$~本科毕设答辩]
  ],
)
#let (init, slides, touying-outline, alert) = utils.methods(s)
#show: init

#show strong: alert

#let (slide, empty-slide, title-slide, new-section-slide, focus-slide) = utils.slides(s)
#show: slides.with(
  slide-level: 2,
  // outline-slide: false
)

#let heitizi(x) = text(font: heiti, x)

= 背景 (Background)

== 概述 (Overview)

#heitizi[*关键词*：]#("结构化内容生成", "大语言模型", "约束解码", "元语言", "协程")

#heitizi[*一句话概括全文*：]#text(size: 16pt)[*领域特定语言* (DSL) 通用且实用，本研究从*理论*和*实验*两方面说明了*大语言模型* (LLM) 在生成DSL的任务上存在*性能缺陷*，因此提出了基于*协程*和Python*元编程*的元语言*YieldLang*作为*约束解码器*来引导LLM生成DSL，实验数据表明本研究取得了*显著的效果*，还有望*降低推理成本*。]

// 研究不是大模型训练、微调、应用方面，而是LLM解码策略的软件方法

== 关于本文 (About)

#[
#set par(justify: false)
*指导*：蔡妍 (Yan Cai)\
*作者*：王家晔$\ ^(1,2)$ (Jiaye Wang)\
*单位*：$\ ^1$华南师范大学·软件学院 (School of Software, SCNU), 
$\ ^2$腾讯·PCG (Platform and Content Group, Tencent Inc.)
]

\
#counter(footnote).update(2)
*Note*: 作者在腾讯转正后的*业余时间独自研究*，并于在校期间*独立完成写作*。
文章已通过中科院预印本平台#footnote(numbering: "1")[
    初公开于：https://chinaxiv.org/abs/202403.00340
  ] (ChinaXiv) 和arXiv#footnote()[
    英文版本：https://arxiv.org/abs/2404.05499
  ]的审核，诚挚接受大家的批评和指正，欢迎关注与讨论。

#let _red(x) = text(fill: rgb(75%,0,0), x)
#let _green(x) = text(fill: rgb(0,75%,0), x)

== 大语言模型 (LLM)

目前流行的LLM基于*Transformer*架构。

$
P(x) &= product_(i=1)^n p(x_i | x_1 dot x_2 dot dots dot x_(i-1))\
P(x_(n+1)|x) 
&= p(x_(n+1) | x_1 dot x_2 dot dots dot x_n)
$

- Transformer: 一种*自回归的生成模型*
  - LLM的词表：字母表 $Sigma$
  - LLM所有可能的Token串：$Sigma^*$ // LLM所有可能的输出
  - 提示词：串 $x = (x_1 dot x_2 dot dots dot x_n) in Sigma^*$ // 输入模型的 Prompt
  - *下一个Token在 $Sigma$ 上的概率分布 $P(x_(n+1)|x)$*
*Note*: 本研究暂不讨论Transformer的细节。

#let bigbold(x) = text(size: 22pt, weight: "bold", x)
#let titlebig(x) = text(size: 1.4em, x)
#let small(x) = text(size: 18pt, x)
#let gray(x) = text(fill: white.darken(50%), x)
#let cold(x) = text(fill: rgb("2878b5"), weight: "bold", x)
#let hot(x) = text(fill: rgb("c82423"), weight: "bold", x)
#let newpage = {pagebreak(); v(1em)}

#newpage

#bigbold[*国外*]

- *OpenAI*·ChatGPT —— AI独角兽 // Sam Altman 大戏
  - *2018* GPT-1: #cold[不温不热]
  - *2019* GPT-2: #cold[不温不热]
  - *2020* GPT-3: #cold[不温不热]
  - *2022* 年底ChatGPT: #hot[火爆全球]
    - *5*天，注册用户达*100万*
    - *2*个月，活跃用户达一个亿 (*10000万*)
- *Anthropic*·Claude #gray[—— AI独角兽]
- *Google*·Gemini —— #gray[互联网巨头] // 谷歌不用多说了吧
- *Meta*·LLaMA —— #gray[社交巨头] // Facebook 马克·扎克伯格
- *xAI*·Grok —— #gray[Elon Musk] // 特斯拉电车、SpaceX航空、整活大师 Elon Musk
- $dots.c$

// 仅按照长短排序
// 还有很多LLM创业公司，井喷

#newpage


#bigbold[*国内*]

- *百度*·文心一言 #gray[—— 互联网大厂]
- *阿里*·通义千问 #gray[—— 互联网大厂]
- *字节*·豆包 #gray[—— 互联网大厂]
- *腾讯*·混元 #gray[—— 互联网大厂]
- *商汤*·商量 #gray[—— 科研机构]
- *智谱*·清言 #gray[—— 出自高校]
- $dots.c$

1. 各高校、科研机构推出自家大模型
2. 互联网大厂角逐大模型霸主，加速落地
3. *#text(fill: rgb("ce2c45"))[华为]、#text(fill: rgb("ed7221"))[小米]、#text(fill: rgb("409063"))[OPPO]、#text(fill: rgb("56bcf9"))[vivo]*等各家手机厂商也开始*拥抱大语言模型*为用户提供智能服务 // 抢走用户，争夺市场



== 领域特定语言 (DSL)

#let three-line-table = tablem.with(
  render: (columns: auto, ..args) => {
    table(
      columns: columns,
      stroke: none,
      align: center + horizon,
      inset: 0.4em,
      table.hline(y: 0),
      table.hline(y: 1, stroke: 1pt),
      ..args,
      table.hline(),
    )
  }
)
#v(-0.5em)
#align(center)[
#three-line-table[
  | *类型* | *例子* | *用途* |
  |:---:|:---:|:---:|
  | *编程语言* | Python | 编写程序 |
  | *数据格式* | JSON | 数据交换 |
  | *配置文件* | YAML | 配置管理 |
  | *指令集* | x86 | 芯片指令 |
  | *协议* | HTTP | 网络通信 |
]
]

领域特定语言 (Domain Specific Language, DSL) 
- 为*特定领域*应用程序设计的计算机语言
  - #small[能够被计算机准确识别的*结构化字串*]
    - #small[被程序员或程序所*期望的数据结构*] // 计算机内存中

#newpage

#bigbold[*各领域使用DSL*]

- *工业界*
  - 编程语言、数据格式、配置文件、指令集、协议
- *学术界*
  - 图文排版、分子结构#footnote[例如使用ASCII字符串明确分子结构的OpenSMILES]、蛋白质结构、量子算法#footnote[例如拥有了良好句法定义的λ-Q\#是一种领域特定语言]
- *商业和艺术领域* // Common Business Oriented Language
  - COBOL#footnote[专用于商业的编程语言，也是最早的高级编程语言之一]、Csound、ChucK#footnote[专用于实时声音合成或音乐创作的计算机编程语言]和Processing#footnote[为电子艺术以及视觉交互设计而创建的编程语言]等

*Note*: DSL与通用编程语言 (GPL) 有区别，本研究不强调区别，统一称之为DSL。 // 为了方便指代

= 动机 (Motivation)

#titlebig[*动机 (Motivation)*]

// 学术界、工业界近年来有控制LLM和结构化串的需求
#heitizi[*一句话概括动机*：]


学术界、工业界近年来有*控制LLM*#footnote[OpenAI. #link("https://openai.com/blog/new-models-and-developer-products-announced-at-devday")[“More Control”].]#footnote[https://www.langchain.com]#footnote[https://arxiv.org/abs/2305.19234]#footnote[https://arxiv.org/abs/2109.05093]#footnote[https://github.com/guidance-ai/guidance]和*生成DSL*#footnote[https://github.com/mangiucugna/json_repair
]#footnote[https://github.com/vllm-project/vllm/pull/2105]#footnote[https://github.com/huggingface/transformers/pull/27557]#footnote[#link("https://pub.towardsai.net/openai-json-mode-vs-functions-92b15baa38d9")[João Lages: OpenAI JSON Mode vs Functions. Medium. 2024]]的需求，我的实践表明*现有方法可以改进*。

- 两个需求异曲同工，能够进行统一处理

#newpage
#image("./imgs/pic701-1.svg", width: 128*2.6pt)
#v(-1em)
#image("./imgs/pic702-1.svg", width: 128*3pt)

- *上图*：*#_red[难题]*（*应用程序**#_red[不易]*处理*模糊*的信息）
- *下图*：本研究的*解决方案*（基于约束解码器） // 无需微调，即插即用

== DSL异步解析需求
#v(0.5em)
1. *大语言模型补全代码*
   - 输出了*1000个Token*的Java代码，但是因为某个地方*少了一个括号*，导致整个代码无法运行 (*Syntax Error*) ，连*Parser*都过不了 // 浪费了那么多算力，还要人工帮AI修bug
2. *大文件的传输和解析*
   - 小明传输了一个*1000#h(0.125em)GiB*的JSON数据文件，小红的程序收到后*解析出错*。小红找小明修复，小明发现原来JSON末尾*多了一个逗号* // 传输那么大的文件真不容易，要是能尽早发现错误或者过滤错误就好了
#line(length: 100%, stroke: rgb("0c4842"))
- 为什么要*人工修复*？
- 为什么要*传输完毕之后才能解析*？
- *浪费的算力、带宽和时间*由谁来承担？！

#newpage

#bigbold[*现有方法*] // 各种 Parser 和 Parser Generator

1. *大部分时间消耗*在LLM的生成（或传输）过程
2. Parser通常假设给定的串 (DSL) 正确，是*同步*的
   - *鲁棒性不好*，不容易灵活处理错误和恢复解析
   - 增量解析*复杂度下限*是： $O(n^2)=sum_(i=1)^n O(i)$

如果能够*异步*地处理DSL，那么就可以一边“传输”一边“处理”。若在传输过程中就*发现错误*，就*及时止损*并给予通知，能够*节省带宽和时间*。

#rect(stroke: 1pt, radius: 0.5em)[#show-edge]
- Microsoft Edge 浏览器无法给予足够精确的提示 // 基于 Chromium 内核
#let askllm = rect(
stroke: 1pt,
width: 100%,
inset: 1em,
radius: 0.5em,
[
#set text(size: 10pt)
#show raw: set text(size: 10pt)
#align(right)[
JSON 前缀空字符串 $s$，什么是 $M_P (s)$？ ~#box(baseline: 0.8em)[#circle()[*A*]]]

#align(left)[
#box(baseline: 1.2em)[#circle()[*B*]]~
在 JSON(JavaScript Object Notation) 上下文中，我们通常会考虑 JSON 的syntax规#v(-1.8em) #h(3em)则，以确定哪些字符串或字符可以出现在特定上下文中。JSON 是一种轻量级数据交换格式，基于 JavaScript 对象字面语法，但独立于任何语言，许多编程语言都支持它。
如果我们将空字符串 $s=epsilon$ 视为前缀，那么我们要确定所有可能的字符 $m$ ，从而使 $s m$ 成为 JSON 结构的有效前缀。一个 JSON 的结构可以是：
- 对象，以 ```js '{'``` 开头
- 数组，以 ```js '['``` 开头
- 字串，以 ```js '"'``` 开头
- 数字，以 ```py /0-9/``` 或 ```js '-'``` 开头
- 布尔，以 ```js 't'``` (true) 或 ```js 'f'``` (false) 开头
- 空值，以 ```js 'n'``` 开头
因此，对于空字符串 $s$ ，集合 $M_P (s)$ 将包含所有可以作为 JSON 开头的字符：
$M_P (s) = {#[```py '{', '[', '"', '0', /1-9/, '-', 't', 'f', 'n'```]}$ 。
这包括所有数字字符和符号 ```js '-'```，因为负数也是有效的 JSON 数字。请注意，这组字符不包括空格、制表符或其他空白字符，它们虽然可以出现在 JSON 文本中，但并不构成独立的 JSON 结构。
]
]
)

== DSL生成性能不好

#bigbold[*设计实验*] // 验证LLM的DSL生成性能

常见的DSL句法特征：*匹配的括号对*。
- 构成语言 $L(G)$, $G$ 是一个CFG
- 若 $s in L(G)$ 且 $l=$ ```py '('``` 且 $r=$ ```py ')'```
- *集合 $I = {s r x | forall s in L(G), x in Sigma^*}$*
  - 全部都是非法的括号对 // s 可以为空串
  - 令 $s=l^n r^n in L(G)$
// 如果LLM“过拟合”，总是倾向于选择左括号，那么合法的括号对字符串将无限长
#[
#set text(size: 15pt, fill: rgb("#0c4842"))
#show raw: set text(size: 13.7pt)
#table(
  stroke: none,
  columns: 2,
  gutter: 0.0em,
   [
    `    ((((()))))` $x->$ #box(
      baseline: 1.2em,
    )[#table(
      columns: 2,
      rows: 2,
      [`(`],[97.8%],
      [`)`],_red[2.2%],
    )]
   ],[
  `    (((((())))))` $x->$ #box(
      baseline: 1.2em,
    )[#table(
      columns: 2,
      rows: 2,
      [`(`],[99.9%],
      [`)`],_red[0.1%],
    )]
   ],[
  `((((((()))))))` $x->$ #box(
      baseline: 1.2em,
    )[#table(
      columns: 2,
      rows: 2,
      [`(`],[97.4%],
      [`)`],_red[0.6%],
    )]
   ],[
  `(((((((())))))))` $x->$ #box(
      baseline: 1.2em,
    )[#table(
      columns: 2,
      rows: 2,
      [`(`],[97.9%],
      [`)`],_red[2.1%],
    )]
   ]
   )
]

#newpage

#bigbold[*性能曲线*]
#small[*$(X,Y):$* *平均字符串长度 $|s|$*, *错误概率 $p(e)$*]
#v(-0.5em)
#[
    #set text(size: 12pt)
    #set align(center)
    #table(
  stroke: none,
  columns: 2,
   gutter: -0em,
  [
#image("../assets/gpt2-fig-003.svg")
#v(-1em) (1) OpenAI/GPT-2 117M
  ],[
#image("../assets/gpt2-large-fig-003.svg")
#v(-1em) (2) OpenAI/GPT-2 Large 774M
  ],[
#image("../assets/gpt2-xl-fig-003.svg")
#v(-1em) (3) OpenAI/GPT-2 XL 1558M
  ],[
#image("../assets/gemma-fig-003.svg")
#v(-1em) (4) Google/Gemma-7B 7751M
  ]
)
]

#[
#set text(size: 18pt)
- #text(fill: rgb("295ca0"), weight: "bold")[蓝点]：*错误Token*（右括号）的可能性
- #text(fill: rgb("ea3323"), weight: "bold")[红线]：*错误DSL前缀*（非法括号串）的可能性 // 前缀是DSL的前提，前缀错，怎样都错
]
// 曲线越低越好
#newpage

\
*参数量达到近78亿*的Gemma模型，其 *$|s|$ 达到282*时，*错误率高达#_red[#text(weight: "bold")[95%]]*以上。

- 这些语言模型的DSL生成性能是*难以接受*的

#[
#set text(size: 17pt)
#align(center)[#tablex(
  columns: 5,
  align: center + horizon,
  auto-vlines: false,
  auto-hlines: false,
  repeat-header: true,
  hlinex(),
  [*模型名称*],[*参数量*],[*$"Date"^("GMT"+8)$*],[*$|s|_(r(e)> 50%)$*], 
  hlinex(),
  [*$|s|_(r(e)> 95%)$*],
  [GPT-2], [117M],  [2019-2-14], [$14$], [$20$],
  [GPT-2 Large], [774M],[2019-2-14],[$24$],  [$32$],
  [GPT-2 XL], [1558M],[2019-2-14], [$32$], [$36$],
  [Gemma], [7751M],[2024-2-21], [$194$], [$282$],
  hlinex(),
)]
]

- 四种模型在 $|s|$ 增加时，错误概率 $p(e)$ 不断提升
- *匹配的括号对是非常普遍的DSL句法特征*
- 能够生成DSL的子集是生成DSL的前提
- #_red[#text(weight: "bold")[LLM的DSL生成性能在快速下降！]]

#newpage

*为什么现有LLM生成DSL的性能不好？*

$
"softmax"(-bold(z)/(T))_i = e^(-z_i\/T)/(sum_(j=1)^(K)e^(-z_j\/T))
$

#import "@preview/cetz:0.2.2": canvas, draw, tree

#let data001 = (
  ([$ epsilon $]), 
  ([(], ([(],[(],[)]), (_green[)],[(],_red[)])),
  (_red[)], (_red[(],_red[(],_red[)]), (_red[)],_red[(],_red[)])),
)
#v(-0.8em)
#align(center)[
  #set text(weight: "bold", font: "New Computer Modern Mono")
  #set text(size: 20pt)
  #canvas(length: 1.6em, {
  import draw: *

  set-style(content: (padding: 0em),
    fill: none,
    stroke: 1pt+black)

  tree.tree(data001, spread: 1.8, grow: 1.3, draw-node: (node, ..) => {
    circle((), radius: .45, stroke: 1pt)
    content((), text(size: 14pt, font: "Consolas", weight: "black" , node.content))
  }, draw-edge: (from, to, ..) => {
    line((a: from, number: .6, b: to),
         (a: to, number: .6, b: from), mark: (end: ">"),fill: black)
  }, name: "tree")

  // Draw a "custom" connection between two nodes
  let (a, b) = ("tree.0-0-1", "tree.0-1-0",)
  // line((a, .6, b), (b, .6, a), mark: (end: ">", start: ">"))
})]

- *LLM的生成是具有随机性的*
  - 基于*自回归模型*获得一个串需要*多次采样*
  - 深度神经网络输出层概率的*可解释性不好*
  - *温度*参数会影响概率分布，*采样有随机性*

= 方法 (Method)

== 元语言和协程~

#v(1em)
- *元语言*
  - 用于*表述语言*的语言
  - 本文特指描述*CFG*的语言，是一种*形式语言*
    - 被*广泛使用*的、可被*图灵机识别*的语言之一
  - 四元组 *$G=(N, Sigma, P, S)$* 定义了形式文法
    - 有限的非终结符集 *$N$*
    - 有限的终结符集（字母表） *$Sigma$*
    - 有限的产生规则集 *$P$*
    - 开始符号 *$S in N$*
  - 产生规则
    - 形如 *$(Sigma union N)^*N(Sigma union N)^* -> (Sigma union N)^*$*

#newpage

#bigbold[*合法的括号对的语言*]

- *产生规则 $P$*
  - 若 $l=$ ```py '('```, $r=$ ```py ')'```, 开始符号 $S$, 空串 $epsilon$
$
P = {
  S -> epsilon,
  S -> l S r S
}
$

- *更清晰的表示*
$
angle.l "Pairs" angle.r &-> angle.l "Pair" angle.r\
angle.l "Pairs" angle.r &-> angle.l "Pair" angle.r angle.l "Pairs" angle.r\
angle.l "Pair" angle.r &-> #_red[(~] angle.l "Pairs" angle.r #_red[~)]\
angle.l "Pair" angle.r &-> epsilon
$

- *`()`, `(())`, `(())()`, `(()())()`, ...*

#newpage


- *C语言代码的例子*
  - #box(stroke: 0pt, baseline: 0.6em)[```c if ( x > 9 ) { x = 0; y = y + 1; }```]
#v(-0.5em)
#image("../assets/C_grammar_stmt_svg.svg", width: 100%)
// #v(-0.5em)
- *左侧*：C语言的一个子集CFG表示
- *右侧*：将代码表示为CFG的推导树

== 约束解码器 // 很可惜，在我想到之前，就发现已经有人提出了

#algo01

- *2021* 首次提出：ElementAI $->$ *EMNLP*
- *2023* 进一步发展：MIT, Google $->$ *NIPS*
- 本研究实现了一种采用*协程*、*异步*的解码器
- *YieldLang* $<->$ 元语言框架 $<->$ *Generator*

// *理解*：语法引导、语法采样、DSL解码、$dots.c$ // “掐脖子说话”


== YieldLang

#align(center)[
#rect(stroke: 1pt, radius: 0.5em, inset: 0.5em)[
#set par(leading: 0.4em)
#show raw: set text(size: 16pt)
```python
class PairsGenerator(TextGenerator):
    def top(self):
        yield self.pairs
    def pairs(self):
        yield select(
            (self.pair),
            (self.pair, self.pairs)
        )
    def pair(self):
        yield optional(
            '(', self.pairs, ')'
        )
```
]
]

- *生成器*：```py class TextGenerator```
  - 括号对、浮点数、对象、列表、JSON、流图、$dots.c$
- *采样器*：```py class TextSampler```
  - 随机采样、LLM采样、自定义处理器、$dots.c$

#newpage

- *YieldLang的JSON生成器*
  - 根据JSON官方的语法表达#footnote[https://www.json.org/json-en.html]

#[
#set par(leading: 0.384em)
#show raw: set text(size: 12pt)

```python
class JSONGenerator(TextGenerator):
    def top(self):
        yield self.json
    def json(self):
        yield self.element
    def object(self):
        yield select(
            ('{', self.ws, '}'),
            ('{', self.members, '}')
        )
    def members(self):
        yield select(
            (self.member),
            (self.member, ',', self.members)
        )
    def member(self):
        yield (self.ws, self.string, self.ws, ':', self.element)
    def array(self):
        yield select(
            ('[', self.ws, ']'),
            ('[', self.elements, ']')
        )
    def elements(self):
        yield select(
            (self.element),
            (self.element, ',',  self.elements)
        )
    def string(self):
        yield ('"', self.characters, '"')
    def characters(self):
        yield optional(self.character, self.characters)
    def character(self):
        yield select(
            accept(range=('\u0020', '\uffff'), invalids=('"', '\\')),
            ('\\', self.escape)
        )
    def escape(self):
        yield select(
            *'\\"/bfnrt',
            ('u', repeat(self.hex, 4))
        )
    def hex(self):
        yield select(
            self.digit,
            select(*'ABCDEF'),
            select(*'abcdef')
        )
    def digit(self):
        yield select('0', self.onenine)
    def onenine(self):
        yield select(*'123456789')
    def number(self):
        yield (self.integer, self.fraction, self.exponent)
    def integer(self):
        yield select(
            (self.digit),
            (self.onenine, self.digits),
            ('-', self.digit),
            ('-', self.onenine, self.digits)
        )
    def digits(self):
        yield select(
            (self.digit),
            (self.digit, self.digits)
        )
    def fraction(self):
        yield optional('.', self.digits)
    def exponent(self):
        yield optional(select(
            ('E', self.sign, self.digits),
            ('e', self.sign, self.digits)
        ))
    def sign(self):
        yield optional(select('+', '-'))
    def boolean(self):
        yield select('true', 'false')
    def null(self):
        yield 'null'
    def value(self):
        yield select(
            self.object,
            self.array,
            self.string,
            self.number,
            self.boolean,
            self.null
        )
    def element(self):
        yield (self.ws, self.value, self.ws)
    def ws(self):
        yield optional(select(
            ('\u0020', self.ws),
            ('\u000A', self.ws),
            ('\u000D', self.ws),
            ('\u0009', self.ws)
        ))
```
]

#newpage
#v(-0.5em)
- *JSON语法的有环示意图*
#v(-2.5em)
#image("../assets/json-mermaid2.svg")

#newpage

#place(left + top, [
  #v(1em)
  #h(-6em)#box[
    - *Yield*
      - 产生
      - 屈服
    - *Lang*#text(fill: black.lighten(90%))[\uage]
      - 语言
  ]
])

- *YieldLang*
  - 从形式语言获得灵感、基于协程、支持异步
  - 基本思想：*采样* #box(baseline: -1pt)[$-->$] *生成 DSL* // 有啥用？
  - *跟踪符号*出入和完成情况，构造*AST* // 上面的图就是 YieldLang 生成的 Mermaid 框图
    - 即解析DSL为AST (IR)
// #v(-0.5em)
#show-jsonnext

#newpage

- *YieldLang的流图生成器（简单例子）*
  - Mermaid#footnote()[https://mermaid.js.org/intro/]是一个图表创建工具和DSL

#[
#set par(leading: 0.4em)
#show raw: set text(size: 12pt)
#show raw.where(lang: "py"): it => [
    #show regex("\b(case)\b"): k => text(
      fill: rgb("#c64741"), k)
    #it
]
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

== 采样器

#algo-02

- 非终结符 $A$，$"First"(A)$ 由三条规则定义
  1. 若 $A -> epsilon$, 则 $epsilon in "First"(A)$
  2. 若 $A -> #h(0.375em)a#h(0.375em)dot.c dots in Sigma^*$, 则 $a in "First"(A)$
  3. 若 $A -> B dot.c dots in Sigma^*$, 则 $"First"(B) subset.eq "First"(A)$

#newpage

// 若定义字母表 $Sigma$ ，上下文无关文法 $G$ 和语言 $L(G)$ ，将 $P(G)$ 称为语言 $L(G)$ 上的前缀语言。

#askllm

- *前缀*：$P(G)={x in Sigma^* | exists y in Sigma^*: x y in L(G)}$
- *采样*：$M_P (s) = {m in Sigma | s m in P(G)}$

// 字母表上正确的路径

#newpage

- *一种基于协程的DSL生成装置*
  - 关键点在于
    - 异步机制、生成指令
    - *yield*, *yield\** (yield from)


#align(center)[
#image("./imgs/pic704-1.svg", width: 100%)
]

- 两份相关专利已提交官方审核
  - #small[申请一：*2024102839325*]
  - #small[申请二：*2024102839471*] // 目前没有公开

#newpage
// #v(-0.5em)
#align(center)[
#image("./imgs/pic903.min.svg", width: 70%)
]

- 本研究结合*语言模型*的一个*系统流程图* // 概括如何结合LLM

= 效果 (Effect)

#titlebig[*效果 (Effect)*]

#box(baseline: 1.5em)[#image("../assets/fig_save3.svg", width: 50%)]~#box(width: 45%, height: 4.5em)[
  #set par(leading: 0.8em)
  - 当 $Sigma_"LLM" subset.eq "Unicode"$
    - *节约 $83.5%$ 采样*
  - 可能产生的益处
    - #_green[#text(weight: "bold")[*节约计算资源*]]
]

- DSL生成下游任务上提升 $1.09$ 到 $11.6$ 倍

#align(center)[
#set text(size: 16pt)
#tablex(
  columns: 7,
  align: center + horizon,
  auto-vlines: false,
  auto-hlines: false,
  repeat-header: true,

  /* --- header --- */
  hlinex(),
  rowspanx(2)[*模型名称*], colspanx(2)[*JSON Text*], (), 
  colspanx(2)[*Mermaid*], (), 
  colspanx(2)[*Function Call*], (), 
   hlinex(),
   [*基准*], [*本文*],[*基准*], [*本文*],
   [*基准*], [*本文*],
    (),
     hlinex(),
  /* -------------- */

  [GPT-2],[6.7%],[*12.1%*],[7.2%],[*83.6%*],[16.7%],[*18.9%*],
   [GPT-2 XL],[13.5%],[*19.6%*],[11.3%],[*87.4%*],[19.0%],[*20.7%*],
    [Gemma-2B],[20.4%],[*42.1%*],[23.2%],[*91.1%*],[23.7%],[*26.4%*],
     [Gemma-7B],[29.3%],[*49.9%*],[34.4%],[*97.7%*],[28.2%],[*31.9%*],
      hlinex(),
)

]

= 展望 (Prospect)

#titlebig[*展望 (Prospect)*]

- 相关方法“教会”AI使用工具
  - *可能是 $"AI" -> "AGI"$ 的途径之一*
- LLM领域很“卷” // 感谢前人
  - GPL用*DSL采样*“适配”LLM#footnote[https://www.moonbitlang.com/blog/moonbit-ai]
  - 相关研究还在不断出现...

- 本研究不足之处或展望
  - YieldLang的*易用性*可以进一步论证
  - 约束解码在*更多任务*上的条件概率
  - 是否有益于LLM的*预训练*或*微调*
  - 本研究装置的*性能表现*需要分析

= 致谢 (ACKs)

#titlebig[*致谢 (ACKs)*]

1. *感谢上海交通大学和英特尔的Hansimov#footnote[https://github.com/Hansimov]* // 于泽汉，在繁忙之际热情非常热情非常仔细的阅读了我的文章初稿，并给予了大量靠谱的修改意见和支持
2. 感谢软件协会 (SoCoding#footnote[https://socoding.cn/]) 、香农和椰社#footnote[https://socoding.cn/organization]
3. 感谢Joseph Pan#footnote[https://github.com/wzpan]支持我的相关工作 // 潘伟洲
4. 感谢Typst#footnote[https://github.com/typst/typst]、NewCM#footnote[https://git.gnu.org.ua/newcm.git]、Noto#footnote[https://fonts.google.com/noto]
   - Paper和Slides采用Typst 语言排版
   - Slides的字体采用NewCM和Noto
5. *感谢前人、亲人、学校和指导老师*

// 想讲的有很多，但是限于篇幅和时间。。。

#let ref = [
#newpage

#bigbold[*参考文献@Lundberg2024guidance@radford2018improving@yao2023react@Scholak2021:PICARD@OpenAIFunctionCalling2024@openaiJsonVsFunction2024@wang2023grammar@Wolf2024huggingface@Baccianella2024mangiucugna@Kwon2024vllm@geng2024grammarconstrained@Shinan2024lark@lin2024mitigating@sammet1969programming@wexelblat1981history@Max2024tree@rfc7159@rfc2854@rfc3023@rfc4180@Sveidqvist2014@weininger1988smiles@ion1998mathematical@o2018deepsmiles@rfc2045@Vandermeersch2021opensmiles@Singhal_2023@OFER20211750@10.1162_COMJ_a_00324@lazzarini2016csound@bohnacker2012generative@madje2022programmable@team2024gemma@radford2019language@wolfram2023chatgpt@chomsky1956three@MASCARENHAS2014235@Burghardt2020@KernighanRitchie1988@rfc5234@newystats2019exponential@achiam2023gpt@touvron2023llama@wang2023cost@renze2024effect@rfc2616@ntdpa2006@davies2012async@dahl1972car@python2019yield@vaswani2017attention@fei2024moonbit*]
#v(0.5em)
#[
#set par(justify: false)
#set text(size: 12pt)
#bibliography("../ref.bib", style: "gb-7714-2015-numeric", title: none)
]
]

#ref