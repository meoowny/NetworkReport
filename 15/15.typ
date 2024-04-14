#set enum(full: true)

= 实验目的

通过本次实验，我们将了解帧中继的网络的基本概念和原理，并实践配置帧中继网络中的地址映射表，从而理解帧中继网络中的帧转发过程，并掌握帧中继的配置方法，理解帧中继的基本原理和特点，并验证其在网络中的工作效果。

= 实验原理

帧中继是一种重要而流行的 WAN 连接标准，它是 ITU-T 和 ANSI 制定的一种标准。其核心原理和特点如下：
  / 面向连接的数据链路技术: 帧中继连接运行在虚电路（VC）上，每条虚电路都由一个数据链路标识符 DLCI 标识，后者被映射到一个 IP 地址。虚电路包括如下两种类型：
    / PVC: 永久虚电路，是永久性连接，建立后可直接使用，无需再建立。
    / SVC: 交换虚电路，是暂时的。Cisco IOS11.2 以后版本中支持 SVC.
  / DLCI 的功能与作用: 帧中继通过为每一对 DTE 设备分配一个数据链连接标识符 DLCI，并且用 DLCI 将每对 Router 关联起来，在路由器（CPE）和 Frame-Relay 交换机之间生成一条逻辑虚拟链路 PVC。
  / 多路复用: 帧中继允许多个虚电路在同一个物理链路上进行多路复用，以有效利用带宽资源，降低通信成本。
  / 数据转发: 在帧中继交换机中存在一个映射表，该表将 DLCI 映射到相应的输出端口。当交换机收到一个帧时，它会根据帧的 DLCI 查找映射表，并将帧转发到与其相关联的输出端口。
  / 地址映射: 在 Cisco 路由器中，地址映射可以是手动配置的，也可以使用动态地址映射。动态地址映射时，帧中继地址解析协议（ARP）会为特定的连接查找下一个跳转的协议地址。帧中继 ARP 通常也被称为反向 ARP。
  / 封装选项: 在连接 Cisco 路由器时，默认封装是 Cisco，但当与非 Cisco 路由器连接时，应选择“IETF”作为封装选项。
通过这些原理与重点。帧中继为广域网络提供了一个高效、灵活且可靠的数据传输机制。

#pagebreak()

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #align(center + horizon)[#image("./15_01.png", width: 80%)]
  / Router1: \ 
      Serial0/0/0.102: IP Address: 1.1.1.1 SubMask: 255.255.255.252\ 
      Serial0/0/0.103: IP Address: 1.1.1.5 SubMask: 255.255.255.252
  / Router2: \ 
      Serial0/0/0.201: IP Address: 1.1.1.2 SubMask: 255.255.255.252
  / Router3: \ 
      Serial0/0/0.301: IP Address: 1.1.1.5 SubMask: 255.255.255.252
+ 配置交换机中继：
  - 需要在 Serial0, Serial1, Serial2 中配置，为 DLCI 命名，指示从一个端口的子链接（Sublink）到另一个端口的子链接的连接关系
  #grid(
    columns: (1fr, 1fr, 1fr),
    align(center + horizon)[#image("./15_03.png", width: 95%)],
    align(center + horizon)[#image("./15_04.png", width: 95%)],
    align(center + horizon)[#image("./15_05.png", width: 95%)],
  )
  #align(center + horizon)[#image("./15_02.png", width: 55%)]
+ 配置路由器：
  + 配置路由器 R1 时，使用命令行输入如下命令进行配置：
    ```bash
    enable
    configure terminal
    interface Serial0/0/0
    no shutdown
    encapsulation frame-relay
    exit
    interface Serial0/0/0.102 point-to-point
    ip address 1.1.1.1 255.255.255.252
    frame-relay interface-dlci 102
    exit
    interface Serial0/0/0.103 point-to-point
    ip address 1.1.1.5 255.255.255.252
    frame-relay interface-dlci 103
    ```
  + 路由器 R2 配置命令如下：
    ```bash
    enable
    configure terminal
    interface Serial0/0/0
    no shutdown
    encapsulation frame-relay
    exit
    interface Serial0/0/0.201 point-to-point
    ip address 1.1.1.2 255.255.255.252
    frame-relay interface-dlci 201
    ```
  + 路由器 R3 配置命令如下：
    ```bash
    enable
    configure terminal
    interface Serial0/0/0
    no shutdown
    encapsulation frame-relay
    exit
    interface Serial0/0/0.301 point-to-point
    ip address 1.1.1.6 255.255.255.252
    frame-relay interface-dlci 301
    ```
  + 使用如下命令分别配置路由器 R2 和 R3 的静态路由：
    ```bash
    #R2
    ip route 1.1.1.4 255.255.255.252 1.1.1.1
    #R3
    ip route 1.1.1.0 255.255.255.252 1.1.1.5
    ```
+ 验证接口之间的互通性，观察现象；
+ 创建三个电脑 PC0, PC1, PC2，并分别连接到 Router1, Router2 和 Router3 的 FastEthernet0/0 接口上：
  #align(center + horizon)[#image("./15_06.png", width: 80%)]
+ 再次配置三个路由器：
  + 为 R1 的 FastEthernet0/0 接口配置 IP 为 1.1.1.9，子网掩码为 255.255.255.252，在 RIP 路由协议中添加 1.0.0.0：
    #align(center + horizon)[#image("./15_07.png", width: 80%)]
    #align(center + horizon)[#image("./15_08.png", width: 80%)]
  + 类似地，为 R2 的 FastEthernet0/0 接口配置 IP 为 1.1.1.13，子网掩码为 255.255.255.252，在 RIP 路由协议中添加 1.0.0.0；为 R3 的 FastEthernet0/0 接口配置 IP 为 1.1.1.17，子网掩码为 255.255.255.252，在 RIP 路由协议中添加 1.0.0.0；
+ 配置 PC0, PC1, PC2：
  + 配置 PC0 的网关为 1.1.1.9，FastEthernet0 接口配置为 1.1.1.10 255.255.255.252；
  + 配置 PC1 的网关为 1.1.1.13，FastEthernet0 接口配置为 1.1.1.14 255.255.255.252；
  + 配置 PC2 的网关为 1.1.1.17，FastEthernet0 接口配置为 1.1.1.18 255.255.255.252；
+ 在 PC0, PC1, PC2 之间相互 ping 测试互通性，观察现象。

#pagebreak()

= 实验现象

+ 配置完计算机帧中继与路由器后，R1 可分别与 R2, R3 相互 ping 通，但 R2 和 R3 之间无法 ping 通：
  #figure(
    align(center + horizon)[#image("./15_09.png", width: 60%)],
    caption: [R1 测试结果],
  )
  #grid(
    columns: (1fr, 1fr),
    figure(
      align(center + horizon)[#image("./15_10.png", width: 90%)],
      caption: [R2 测试结果],
    ),
    figure(
      align(center + horizon)[#image("./15_11.png", width: 90%)],
      caption: [R3 测试结果],
    ),
  )

+ R2 和 R3 静态路由配置完成后，可以相互 ping 通：
  #grid(
    columns: (1fr, 1fr),
    figure(
      align(center + horizon)[#image("./15_12.png", width: 90%)],
      caption: [静态路由配置后 R2 测试结果],
    ),
    figure(
      align(center + horizon)[#image("./15_13.png", width: 90%)],
      caption: [静态路由配置后 R3 测试结果],
    ),
  )
+ PC0, PC1, PC2 之间可以相互 ping 通：
  #grid(
    columns: (1fr, 1fr, 1fr),
    figure(
      align(center + horizon)[#image("./15_14.png", width: 95%)],
      caption: [PC0 测试结果],
    ),
    figure(
      align(center + horizon)[#image("./15_15.png", width: 95%)],
      caption: [PC1 测试结果],
    ),
    figure(
      align(center + horizon)[#image("./15_16.png", width: 95%)],
      caption: [PC2 测试结果],
    ),
  )

= 分析讨论

+ 未配置静态路由时无法 ping 通的原因分析：

  因为 R2 与 R3 的 Serial 接口地址属于不同的网段。在子网掩码为 255.255.255.252 的情况下，只有两位用于主机编码，前 30 位用于网段编码，因此当两个路由器通过帧中继网络连接但它们的接口不在同一个 IP 网段时，这两个路由器之间的通信就需要额外的路由信息。

+ 帧中继技术的优势：

  帧中继使用虚拟通道的机制，通过在物理线路上创建了多个逻辑通道，可以同时传输多个数据流。这种机制可以有效地利用带宽，在单个物理链路上实现多路复用。因此在本次实验中，通过引入帧中继，只需要将 R1 连接到帧中继交换机，达到多路复用和中继的目的。

+ PC 之间的通信配置：

  由于地址空间有限（在子网掩码为 255.255.255.252 的情况下最多只有四个地址），因此每个 PC 与其连接的路由器处于不同的网段。考虑到网络首地址和末地址有特殊用途，所以选择中间地址作为路由器的端口地址和 PC 的地址，因此有了如上的 IP 配置。此外为了让 PC 之间可以 ping 通，还需要添加路由器到 PC 之间的配置，这里使用 RIP 动态路由协议，使用 `network 1.0.0.0` 让所有 1.x.x.x 地址范围的接口都应该广播 RIP 更新，并接收此范围内的其他路由器的 RIP 更新，以实现自动广播和学习。

