#import "/template.typ": report, subreport

#let date = [2024 年 2 月 26 日]

#show: report.with(
  title: "lab01-网络相关进程与服务实验",
  date: date
)

#include "../01/01.typ"

#show: subreport.with(
  title: "lab02-网络端口地址实验",
  date: date
)

#include "../02/02.typ"

