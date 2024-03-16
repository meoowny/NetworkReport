#import "/template.typ": report, subreport

#let date = [2024 年 3 月 11 日]

#show: report.with(
  title: "lab05-主机路由实验",
  date: date
)

#include "../05/05.typ"

#show: subreport.with(
  title: "lab07-异常串口通信收发实验",
  date: date,
  cooperator: ""
)

#include "../07/07.typ"

