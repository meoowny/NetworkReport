#set enum(full: true)
#set table(
  fill: (x, y) =>
    if x == 0 or y == 0 {
      gray.lighten(40%)
    },
  align: center + horizon,
)
#show table.cell.where(x: 0): strong
#show table.cell.where(y: 0): strong

= 实验目的

本次实验利用路由器的 NAT 功能，结合访问控制列表，实现具有一定安全保护能力的私网与互联网互通。在这个过程中，我们将了解地址转换原理，理解私有网与互联网互通与互联网接入共享原理，熟练掌握 NAT 的基本技术原理和配置方法，理解 NAT 在解决 IP 地址不足及提供网络隔离的作用。

= 实验原理

+ 网络地址转换（Network Address Translation, NAT）优势：
  + NAT 可以完美解决 IP 地址不足的问题；
  + 能够有效避免来自网络外部的攻击，隐藏并保护网络内部的计算机。
  + 基于以上优势，NAT 被广泛应用于各种类型 Internet 接入方式和各种类型的网络中。
+ 默认情况下，内部 IP 地址是无法被路由到外网的，内部主机要与外部网络或 Internet 通信，IP 包到达 NAT 路由器时，IP 包头的源地址被替换成一个合法的外网 IP，并在 NAT 转换表中保存这条记录。
+ 当外部主机发送一个应答到内网时，NAT 路由器收到后，查看当前 NAT 转换表，用内网地址替换掉这个外网地址。
+ NAT 将网络划分为内部网络和外部网络两部分，局域网主机利用 NAT 访问网络时，是将局域网内部的本地地址转换为全局地址（外部网络或互联网合法的 IP 地址）后转发数据包。
+ NAT 的类型：NAT（网络地址转换）和 NAPT（网络端口地址转换 IP 地址对应一个全局地址）
  / 静态 NAT: 实现内部地址与外部地址一对一的映射。现实中一般都用于服务器；
  / 动态 NAT: 定义一个地址池，自动映射，也是一对多的。现实中用得比较少；
  / NAPT: 使用不同的端口来映射多个内网 IP 地址到一个指定的外网 IP 地址，多对一。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #align(center)[#image("./14_01.png", width: 80%)]
  / RA: FA0/0: 192.168.1.254 Mask: 255.255.255.0;\ 
      FA0/1: 10.60.2.254 Mask: 255.255.255.0;\ 
      Seial0/0/0: 202.120.17.18 Mask 255.255.255.0
  / RB: FA0/0: 172.16.3.254 Mask: 255.255.255.0;\ 
      FA0/1: 118.18.4.254 Mask: 255.255.255.0;\ 
      Seial0/0/0: 202.120.17.29 Mask 255.255.255.0
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
    / PC2: IP: 172.16.3.33\ 
        Mask: 255.255.255.0\ 
        GateWay: 172.16.3.254
    / PC3: IP: 118.18.4.44\ 
        Mask: 255.255.255.0\ 
        GateWay: 118.18.4.254
  ])
+ 配置 PC 机、服务器及路由器口 IP 地址：
  + PC 机配置：使用图形界面配置好 PC 的地址、网关及掩码。以 PC0 为例进行如下配置，其他 PC 机操作类似：
    #grid(
      columns: (1fr, 1fr),
      align(center + horizon)[#image("./14_02.png", width: 85%)],
      align(center + horizon)[#image("./14_03.png", width: 100%)],
    )
  + 配置路由器的端口地址：这里使用命令行配置路由器的端口地址。以路由器 RA 为例，相关命令如下：
    ```bash
    configure terminal
    interface FastEthernet0/0
    ip address 192.168.1.254 255.255.255.0
    no shutdown
    interface FastEthernet0/1
    ip address 10.60.2.254 255.255.255.0
    no shutdown
    interface Serial0/0/0
    ip address 202.120.17.18 255.255.255.0
    clock rate 56000
    no shutdown
    ```
    RB 配置操作类似。
+ 在各路由器上配置静态路由协议，让 PC 间能相互 ping 通：
  + 在 RA 上使用命令行在全局配置模式下的配置命令如下：
    ```bash
    ip route 218.100.3.0 255.255.255.0 serial0/0/0
    ip route 118.18.4.0 255.255.255.0 serial0/0/0
    ```
  + 类似地，RB 配置指令如下：
    ```bash
    ip route 10.60.2.0 255.255.255.0 serial0/0/0
    ip route 210.120.1.0 255.255.255.0 serial0/0/0
    ```
+ 配置路由器的 NAT 出入口：
  + 在 RA 和 RB 上使用命令行在全局配置模式下的配置命令如下：
    ```bash
    interface FastEthernet0/0
    ip nat inside
    interface Serial0/0/0
    ip nat outside
    ```
+ 配置路由器的 NAT 转换：
  + 在 RA 上使用命令行在全局配置模式下的配置命令如下：
    ```bash
    ip nat inside source static 192.168.1.11 210.120.1.11
    ```
  + RB 配置操作同 RA，指令为：
    ```bash
    ip nat inside source static 172.16.3.33 218.100.3.33
    ```
+ 观测 NAT 配置情况：
    ```bash
    show ip nat translations
    ```

= 实验现象

#let ack = [#set text(fill: teal.darken(50%));*可以*访问]
#let nck = [#set text(fill: red.darken(50%));*不可*访问]

+ 观察路由器 NAT 的配置结果：#h(500pt)

  #align(center)[#image("./14_09.png", width: 80%)]
  #align(center)[#image("./14_10.png", width: 80%)]

+ 各 PC 间的访问结果：

  #set table.hline(stroke: 1.4pt)
  #table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    table.header(
      [], table.vline(), [PC0], [PC1], [PC2], [PC3],
    ),
    table.hline(),
    [`192.168.1.11`], ack, ack, nck, nck,
    [`210.120.1.11`], nck, nck, ack, ack,
    [`10.60.2.22`], ack, ack, ack, ack,
    [`172.16.3.33`], nck, nck, ack, ack,
    [`218.100.3.33`], ack, ack, nck, nck,
    [`118.18.4.44`], ack, ack, ack, ack,
  )

  #grid(
    columns: (1fr, 1fr),
    align(center + horizon)[#image("./14_08.png", width: 97%)],
    align(center + horizon)[#image("./14_07.png", width: 97%)],
    align(center + horizon)[#image("./14_05.png", width: 97%)],
    align(center + horizon)[#image("./14_06.png", width: 97%)],
  )

#pagebreak()

= 分析讨论

- 对 PC 互相访问结果的分析：

  在 NAT 技术下，网络可以分为内部网络和外部网络，默认情况下内部 IP 地址无法被路由到外网，当外部主机发送一个应答到内网时，需要 NAT 路由器查看当前 NAT 转换表，用内网地址替换掉这个外网地址。

  在本次实验中，4 个 PC 的 ip 配置情况如下：
  #table(
    columns: (1fr, 1fr, 1fr),
    table.header(
      [], table.vline(), [内部 IP], [外部 IP],
    ),
    [PC0], [`192.168.1.11`], [`210.120.1.11`],
    [PC1], [`10.60.2.22`], [],
    [PC2], [`172.16.3.33`], [`218.100.3.33`],
    [PC3], [`118.18.4.44`], [],
  )

  #box()
  #v(-1em)

  从 PC 间的访问结果可以看出，在同一路由器下，可以访问内网 IP，无法访问公网 IP；在不同路由器下，可以访问公网 IP，无法访问内网 IP。

  借助 NAT 技术，使得私有网络服务器可以同时为内网和外网提供服务，实现了信息服务的共享，在网络设计中更巧妙地处理了内外网设备的地址分配问题，让网络架构更为灵活和可管理。同时，NAT 有选择地对私有网络内的主机地址进行转换，为网络安全提供了一定的控制和保护机制，使得私有网络在互联网环境中能够更好地保护内部资源和数据。

