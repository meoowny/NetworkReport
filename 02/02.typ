#import "/model.typ": make-title

#set text(
  size: 12pt,
  font: ("STIX Two Text", "Source Han Serif SC")
)
#set page(numbering: "— 1 —")

#set list(marker: "﹡")
#set heading(numbering: "一、")
#let fake_par = {
  v(-0.6em)
  box()
}
#show heading: it => {
  it
  fake_par
}
#set par(justify: true, first-line-indent: 2em, leading: 1em)

#make-title(title: "lab02-网络端口地址实验", date: "2024 年 2 月 26 日")

= 实验目的

+ 理解网络进程与一般进程的相同和不同之处；
+ 掌握网络端口地址的概念和重要性；
+ 了解在实际网络通信中如何使用端口。

= 实验原理

网络进程与一般进程具有基本相同的属性，唯一不同的特性是网络进程需要开启一个到多个传输端口号用于接收或发送数据。这些端口号范围为 0-65535，其中 0-1023 为保留端口号或系统端口。一般来说，对于 C/S 或 B/S 架构的网络，客户端网络进程和服务端网络进程使用端口来接收和发送数据。端口指的是访问主机上的某一进程的标识符，通过端口实现了计算机之间进程的通信。

= 实验设备

- 实验硬件：济事楼 330 机房电脑与个人笔记本电脑
- 实验软件：Windows 操作系统

= 实验步骤

+ 在浏览器分别输入地址：
  - https://www.tongji.edu.cn:8080
  - https://www.tongji.edu.cn:80
  - http://www.tongji.edu.cn:8080
  - http://www.tongji.edu.cn:80
+ 观察结果并分析；
+ 进入 CMD 命令行环境中输入命令 `netstat -ano` 观测结果。

= 实验现象

1. 浏览器表现如下：

  1. 访问 https://www.tongji.edu.cn:8080 ：连接失败

  由于使用了 HTTPS 协议并指定端口号 8080，此时由于服务器没有配置相应的端口监听，因此访问失败。

  #image("02_01.png")

  2. 访问 https://www.tongji.edu.cn:80 ：连接失败

  由于使用了 HTTPS 协议但未指定 HTTPS 默认端口的端口号 443，因此未能成功访问。

  #image("02_02.png")

  3. 访问 http://www.tongji.edu.cn:8080 ：连接失败

  由于使用了 HTTP 协议并指定端口号 8080，此时由于服务器没有配置相应的端口监听，因此访问失败。

  #image("02_03.png")

  4. 访问 http://www.tongji.edu.cn:80 ：连接成功

  由于使用了 HTTP 协议并指定了 HTTP 默认端口的端口号 80，因此可以成功访问。

  #image("02_04.png")

2. 在 CMD 命令行环境中，使用 `netstat -ano` 命令观察端口状态：

通过该命令，可以查看计算机上当前打开的端口的端口号、协议及连接状态。

#image("02_05.png")

= 分析讨论

1. 实验内容过程记录
  - 使用浏览器访问提供的地址，观察能否连接成功，以及页面响应；
  - 使用 `netstat -ano` 命令查看当前计算机的端口状态。

2. 相关端口号使用举例
  - 20/21 端口：FTP 数据传输服务端口；
  - 23 端口：Telnet 端口；
  - 25 端口：SMTP 邮件发送服务端口；
  - 53 端口：DNS 域名解析服务端口；
  - 67/68 端口：DHCP 服务的服务器端/客户端端口；
  - 69 端口：TFTP 数据传输服务端口；
  - 110 端口：POP3 邮件接收服务端口；
  - 80 端口：HTTP Web 服务默认端口；
  - 443 端口：HTTPS Web 服务默认端口；

