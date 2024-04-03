= 实验目的

通过动手配置 RIP 路由，让我们可以通过静态路由以外的方式配置路由，从而进一步理解 RIP 协议的基本原理和工作机制。进而可以学习如何配置和管理 RIP 路由，掌握 RIP 路由的自动更新和传递过程。

= 实验原理

+ RIP（Routing Information Protocols，路由信息协议）：它是应用较早、使用较普遍的 IGP 内部网关协议，适用于小型同类网络，是距离矢量协议；
+ RIP 协议跳数：RIP 协议使用跳数作为衡量路径开销的指标，RIP 协议里规定最大跳数为 15，因此使用 RIP 时，任何超过 15 跳的路径被认为是不可达的；
+ RIP 协议版本：RIP 协议有两个版本：RIPv1 和 RIPv2：
  / RIPv1: 属于有类路由协议，不支持 VLSM，以广播形式进行路由信息的更新，更新周期为 30 秒；
  / RIPv2: 属于无类路由协议，支持 VLSM，以组播形式进行路由更新。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #align(center)[#image("./13_01.png", width: 80%)]
  / RA: FA0/0: 192.168.1.254 Mask: 255.255.255.0;\ 
      FA0/1: 10.60.2.254 Mask: 255.255.255.0;\ 
      Seial0/1/0: 202.120.17.18 Mask 255.255.255.0
  / RB: FA0/0: 172.16.3.254 Mask: 255.255.255.0;\ 
      FA0/1: 118.18.4.254 Mask: 255.255.255.0;\ 
      Seial0/1/0: 202.120.17.29 Mask 255.255.255.0
  #grid(
    columns: (1fr, 1fr),
    [
    / PC1: IP: 192.168.1.11\ 
        Mask: 255.255.255.0\ 
        GateWay: 192.168.1.254
    / PC2: IP: 10.60.2.22\ 
        Mask: 255.255.255.0\ 
        GateWay: 10.60.2.254
    ],
    [
    / PC3: IP: 172.16.3.33\ 
        Mask: 255.255.255.0\ 
        GateWay: 172.16.3.254
    / PC4: IP: 118.18.4.44\ 
        Mask: 255.255.255.0\ 
        GateWay: 118.18.4.254
  ])
+ 配置 PC 机、服务器及路由器口 IP 地址：
  + PC 机配置：使用图形界面配置好 PC 的地址、网关及掩码。以 PC1 为例进行如下配置，其他 PC 机操作类似：
    #grid(
      columns: (1fr, 1fr),
      align(center + horizon)[#image("./13_03.png", width: 85%)],
      align(center + horizon)[#image("./13_04.png", width: 100%)],
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
    interface Serial0/1/0
    ip address 202.120.17.18 255.255.255.0
    clock rate 56000
    no shutdown
    ```
    RB 配置操作类似。
+ 配置 RIP 之前检查 PC 间能否相互 ping 通；
+ 在 RA 上配置 RIP：使用命令行配置的相关命令如下：
  ```bash
  router rip
  network 192.168.1.1
  network 10.60.2.22
  network 202.120.17.18
  ```
+ 验证主机之间的互通性；
+ 在 RB 上配置 RIP，配置操作同 RA；
+ 验证主机之间的互通性。

= 实验现象

1. 在配置 RIP 前，同一路由器下的 PC 之间可以 `ping` 通，连接不同路由器的 PC 不可达：

  #grid(
    columns: (1fr, 1fr),
    align(center)[#image("./13_06_1.png", width: 95%)],
    align(center)[#image("./13_06_3.png", width: 95%)],
  )

2. 配置好路由器 A 或 B 后，同一路由器下的 PC 之间可以 `ping` 通，连接不同路由器的 PC 不可达：

  #grid(
    columns: (1fr, 1fr),
    align(center)[#image("./13_07_1.png", width: 95%)],
    align(center)[#image("./13_07_4.png", width: 95%)],
  )

#pagebreak()

3. 路由器 A 和 B 的 RIP 均配置完成后，四台 PC 可相互 ping 通：

  #grid(
    columns: (1fr, 1fr),
    align(center)[#image("./13_05_1.png", width: 95%)],
    align(center)[#image("./13_05_2.png", width: 95%)],
  )

  #grid(
    columns: (1fr, 1fr),
    align(center)[#image("./13_05_3.png", width: 95%)],
    align(center)[#image("./13_05_4.png", width: 95%)],
  )

= 分析讨论

通过本次实验，我认识到了 RIP 协议在动态路由中的作用和优势，掌握了 RIP 路由的配置方法。

在未配置 RIP 前，由于缺乏足够的路由信息，连接不同路由器的 PC 之间无法正确传递数据包，因此无法 `ping` 通，但同一路由器下的 PC 能够相互通信。在配置好一个路由器上 RIP 后，连接不同路由器的 PC 之间仍缺乏路由信息，无法通信。只有两个路由器都配置好 RIP，两个路由器之间交换路由信息后，整个网络中的所有设备才可以互相通信。这突显了 RIP 在路由器之间建立相互连接的重要作用。RIP 的引入实现了动态路由的自动配置，为网络中的设备提供了更加和自适应的选择机制。

相较于静态路由的方法，RIP 更具灵活性。通过简单地路由器所连接的电脑 IP 地址以及自身 IP 地址加入 RIP 中，就能实现自动的路由配置，极大简化了网络配置的过程，使管理者无需手动干预每一台路由器的路由表，提高了配置便捷性。

