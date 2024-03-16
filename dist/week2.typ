#import "/template.typ": report, subreport

#let date = [2024 年 3 月 4 日]

#show: report.with(
  title: "lab03-网络线的制作和测试实验",
  date: date
)

#include "../03/03.typ"

#show: subreport.with(
  title: "lab04-基本网络测试工具及应用工具实验",
  date: date
)

#include "../04/04.typ"

