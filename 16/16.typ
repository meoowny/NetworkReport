= 实验目的

通过本次实验，我们将理解接入控制列表（ACLs）的基本原理和功能，在实践中学习如何配置扩展 IP 访问列表，并验证 ACL 配置对网络访问的影响。

= 实验原理

+ ACLs 全称接入控制列表（Access Control Lists），也称为访问列表（Access Lists），俗称为防火墙，有的文档还称之为包过滤。
+ ACLs 通过定义一些规则对网络设备接口上的数据报文进行控制：允许通过或丢弃，从而提高网络可管理性和安全性；
+ IP ACL 分为两种：
  / 标准 IP 访问列表: 编号范围为 1~99、1300~1999，可以根据数据包的源 IP 地址定义规则，进行数据包的过滤；
  / 扩展 IP 访问列表: 编号范围为 100~199、2000~2699，可以根据数据包的源 IP、目的 IP、源端口、目的端口、协议来定义规则，进行数据包的过滤。
+ IP ACL 基于接口进行规则的应用可以分为：入栈应用和出栈应用。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\16_01.png", width: 80%),
    caption: [网络拓扑图],
  ) <fig-16_01>

  / RA: FA0/0: 192.168.1.254 Mask: 255.255.255.0\ 
        FA0/1: 10.60.2.254 Mask: 255.255.255.0\ 
        Serial0/0/0: 202.120.17.18 Mask: 255.255.255.0
  / RB: FA0/0: 172.16.3.254 Mask: 255.255.255.0\ 
        FA0/1: 118.18.4.254 Mask: 255.255.255.0\ 
        Serial0/0/0: 202.120.17.29 Mask: 255.255.255.0
  #grid(
    columns: (1fr, 1fr),
    [
    / PC0: IP: 192.168.1.11\ 
        Mask: 255.255.255.0\ 
        GateWay: 192.168.1.254
    / PC1: IP: 10.60.2.22\ 
        Mask: 255.255.255.0\ 
        GateWay: 10.60.2.254
    ],
    [
    / Server0: IP: 172.16.3.33\ 
        Mask: 255.255.255.0\ 
        GateWay: 172.16.3.254
    / PC2: IP: 118.18.4.44\ 
        Mask: 255.255.255.0\ 
        GateWay: 118.18.4.254
  ])
+ 然后使用图形界面配置各 PC 及服务器的地址、网关及掩码；
  #grid(
    columns: (1fr, 1fr),
    align: center + horizon,
    figure(
      image("..\assets\16_41.png", width: 95%),
      caption: [PC0 网关配置],
    ),
    figure(
      image("..\assets\16_42.png", width: 95%),
      caption: [PC0 IP 配置],
    ),
  )

+ 使用命令行配置路由器的端口地址、串口端口地址和静态路由表：
  - RA 配置如下：
    ```bash
    enable
    configure terminal
    # 配置端口地址
    interface FastEthernet0/0
    ip address 192.168.1.254 255.255.255.0
    no shutdown
    exit
    interface FastEthernet0/1
    ip address 10.60.2.254 255.255.255.0
    no shutdown
    exit
    # 配置串口地址
    interface Serial0/0/0
    ip address 202.120.14.18
    clock rate 56000
    no shutdown
    exit
    # 配置静态路由表
    ip route 172.16.3.0 255.255.255.0 Serial0/0/0
    ip route 118.18.4.0 255.255.255.0 Serial0/0/0
    ```
  - 类似地，RB 配置如下：
    ```bash
    enable
    configure terminal
    # 配置端口地址
    interface FastEthernet0/0
    ip address 172.16.3.254 255.255.255.0
    no shutdown
    exit
    interface FastEthernet0/1
    ip address 118.8.4.254 255.255.255.0
    no shutdown
    exit
    # 配置串口地址
    interface Serial0/0/0
    ip address 202.120.17.29
    clock rate 56000
    no shutdown
    exit
    # 配置静态路由表
    ip route 172.16.1.0 255.255.255.0 Serial0/0/0
    ip route 10.60.2.0 255.255.255.0 Serial0/0/0
    ```
+ 打开 `172.16.3.33` 服务器端的 WEB 并在其他 PC 端通过 ping 和 http 访问，观察结果；
+ 配置 RB 的扩展 ACL 表，相关指令如下：
  ```bash
  # 拒绝 ping 包
  access-list 101 deny icmp host 192.168.1.11 host 172.16.3.33
  # 允许 www 访问
  access-list permit tcp host 192.168.1.11 host 172.16.3.33 eq www
  # 应用到端口上
  interface Serial0/0/0
  ip access-group 101 in
  ```
+ 在其他 PC 上通过 ping 和 http 的方法重新尝试访问 `172.16.3.33` 的服务器，观察结果。

= 实验现象

+ ACL 配置前，各 PC 访问服务器均成功：

  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\16_03.png", width: 95%),
      caption: [ACL 配置前 PC0 的 ping 访问],
    ),
    figure(
      image("..\assets\16_02.png", width: 95%),
      caption: [ACL 配置前 PC0 的 HTTP 访问],
    )
  )

+ ACL 配置后，各 PC 访问结果如下：
  
  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\16_04.png", width: 95%),
      caption: [ACL 配置后 PC0 ping 访问失败],
    ),
    figure(
      image("..\assets\16_05.png", width: 95%),
      caption: [ACL 配置后 PC0 HTTP 仍成功访问],
    )
  )

  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\16_06.png", width: 95%),
      caption: [ACL 配置后 PC1 ping 访问失败],
    ),
    figure(
      image("..\assets\16_08.png", width: 95%),
      caption: [ACL 配置后 PC1 HTTP 访问失败],
    ),
  )

  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\16_07.png", width: 95%),
      caption: [ACL 配置后 PC2 ping 仍成功访问],
    ),
    figure(
      image("..\assets\16_09.png", width: 95%),
      caption: [ACL 配置后 PC2 HTTP 仍成功访问],
    )
  )

访问结果总结如下：

#let ack = [#set text(fill: teal.darken(50%));*成功*]
#let nck = [#set text(fill: red.darken(50%));*失败*]
#set table(
  fill: (x, y) =>
    if x == 0 or y == 0 {
      gray.lighten(40%)
    },
  align: center + horizon,
)
#show table.cell.where(x: 0): strong
#show table.cell.where(y: 0): strong
#table(
  columns: (1fr, 1fr, 1fr),
  table.header(
    [PC], [ping], [http],
  ),
  [PC0], nck, ack,
  [PC1], nck, nck,
  [PC2], ack, ack,
)

= 分析讨论

本次实验中，我们学习了如何在路由器上配置 ACL 以及 ACL 对网络通信会产生何种影响。通过逐步地配置和观察结果，我们了解了 ACL 的基本功能和它在网络管理中的重要性。

通过对 ACL 的配置，我们能够对特定的数据流进行限制。在本次实验中，我们对来自 PC0 到服务器的 ping 请求进行了拦截，但允许 http 请求。对于 PC1 的 http 请求也进行了拦截。但不对 PC2 进行任何限制。实验结果表明：

/ PC0: ping 失败但 http 成功，因为 ACL 拦截了 ping 包但允许了 http 请求；
/ PC1: ping 与 http 均失败，这说明在 ACL 中有其他规则阻止了来自 PC1 的请求或 PC1 的配置存在问题；
/ PC2: ping 和 http 均成功，说明 PC2 没有受到 ACL 的任何限制。

