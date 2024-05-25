// ARP 消息分析实验

= 实验目的

本次实验中，我们将学习理解 ARP（Address Resolution Protocol，地址解析协议）的工作原理，并了解它在网络通信中的作用。通过虚拟实验环境和抓包工具，我们将学习利用工具观测分析 ARP 报文结构与通信过程，并在这个过程中了解 ARP 协议是如何将 IP 地址映射到 MAC 地址的。

= 实验原理

+ ARP 协议：它是“Address Resolution Protocol”（地址解析协议）的缩写。在以太网环境中，数据的传输所依赖的是 MAC 地址而非 IP 地址，而 ARP 协议的工作就是将已知 IP 地址转换为 MAC 地址。
+ ARP 映射方式：
  + 静态映射：指手动创建一张 ARP 表，把逻辑（IP）地址和物理地址关联起来。这个 ARP 表储存在网络中的每一台机器上。这样做有一定的局限性，因为物理地址可能在如下情况下发生变化，为避免这些问题的出现就需要定期维护更新 ARP 表，但会影响网络性能：
    + 机器可能更换 NIC（网络适配器），结果变成一个新的物理地址；
    + 在某些局域网中，每当计算机加电时，它的物理地址都要改变一次；
    + 移动电脑可以从一个物理网络转移到另一个物理网络，此时物理地址会改变。
  + 动态映射：动态映射时，每次只要机器知道另一台机器的逻辑（IP）地址，就可以使用协议找出相对应的物理地址。已设计出的实现了动态映射协议的有 ARP 和 RARP 两种。ARP 把逻辑（IP）地址映射为物理地址；RARP 把物理地址映射为逻辑（IP）地址。
+ ARP 原理及流程：任何时候，一台主机有 IP 数据报文发送给另一台主机时，它都要知道接收方的逻辑（IP）地址。但是 IP 地址必须封装成帧才能通过物理网络。这就需要发送方必须有接收方的物理（MAC）地址，因此需要完成逻辑地址到物理地址的映射。而 ARP 协议可以接收来自 IP 协议的逻辑地址，将其映射为相应的物理地址，然后把物理地址递交给数据链路层。
  + ARP 请求：任何时候，当主机需要找出该网络中的另一个主机的物理地址时，它就可以发送一个 ARP 请求报文，这个报文包好了发送方的 MAC 地址和接收方的 IP 地址。因为发送方不知道接收方的物理地址，所以这个查询分组会在网络层中进行广播。
  + ARP 响应：局域网中的每一台主机都会接受并处理这个 ARP 请求报文，然后进行验证，查看接收方 IP 地址是不是自己的地址，只有验证成功的主机才会返回一个 ARP 响应报文，这个响应报文包含接收方的 IP 地址和物理地址。这个报文利用收到的 ARP 请求报文中的请求方物理地址以单播的方式直接发送给 ARP 请求报文的请求方。
+ ARP 报文格式：
  #figure(
    image("..\assets\24_01.png", width: 50%),
    caption: [ARP 报文格式],
  ) <fig-24_01>
+ 可以使用 `arp -a` 命令查看本机 ARP 内容，也可以使用 `arp -d` 删除本机的 ARP 内容。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境，WireShark

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\24_02.png", width: 55%),
    caption: [网络拓扑图],
  ) <fig-24_02>
  / Router0: FA 0/0: 192.168.1.1 Mask: 255.255.255.0\ 
             FA 0/1: 192.168.2.1 Mask: 255.255.255.0
+ 按上述配置对 Router0 接口进行配置：
  ```bash
  interface FastEthernet0/0
  ip address 192.168.1.1 255.255.255.0
  nu shutdown
  exit
  interface FastEthernet0/1
  ip address 192.168.2.1 255.255.255.0
  nu shutdown
  ```
+ 配置 Router0 的 DHCP 左右两边的 DHCP：
  ```bash
  # 路由器 DHCP 左边网络
  ip dhcp excluded-address 192.168.1.0 192.168.1.10
  
  ip dhcp pool myleftnet
  network 192.168.1.0 255.255.255.0
  default-router 192.168.1.1
  option 150 ip 192.168.1.3
  dns-server 192.168.1.2

  # 路由器 DHCP 右边网络
  ip dhcp excluded-address 192.168.2.0 192.168.2.10
  
  ip dhcp pool myrightnet
  network 192.168.2.0 255.255.255.0
  default-router 192.168.2.1
  option 150 ip 192.168.2.3
  dns-server 192.168.2.2
  ```
+ 打开 PC0 的命令提示符，在模拟模式下输入 `ping 192.168.2.11`（PC2 的动态 IP 地址） `ping` PC2，产生 ARP 数据报文；
+ 分析产生的报文情况；
+ 使用 `arp -a` 查看本机的 ARP 内容；
+ 使用 WireShark 抓取本机 ARP 数据包；
+ 查看 ARP 报文字段内容并解读。

#pagebreak()

= 实验现象

+ 虚拟实验环境中的 ARP 报文\ 
  以 PC0->Router0 为例：
  #figure(
    image("..\assets\24_03.png", width: 60%),
    caption: [报文内容],
  ) <fig-24_03>
  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\24_04.png", width: 90%),
      caption: [报文内容 1],
    ),
    figure(
      image("..\assets\24_05.png", width: 90%),
      caption: [报文内容 2],
    ),
  )
  - OSI 模型分析：
    - 该报文在 OSI 模型第二层数据链路层；
    / Ethernet II 源 MAC 地址: 0000.0C28.5440（PC0）；
    / Ethernet II 目的 MAC 地址: FFFF.FFFF.FFFF（广播地址），表明这是一个广播帧；
    / ARP 包源 IP 地址: 192.168.1.11（PC0）；
    / ARP 包目的 IP 地址: 192.168.1.1（Router 左端口），说明主机尝试解析 IP 地址为 192.168.1.1 对应的 MAC 地址。
  - 输入 PDU 详情：
    / 硬件类型 HARDWARE TYPE: 0x0001，表示这是一个以太网帧；
    / 硬件长度 HLEN: 0x06，表示物理地址（MAC 地址）的长度为 6 个字节；
    / 协议长度 PLEN: 0x04，表示协议地址（IP 地址）的长度为 4 个字节；
    / 操作码 OPCODE: 0x0001，表示这是一个 ARP 请求报文；
    / 发送方 MAC 地址 SOURCE MAC: 0000.0C28.5440，即 PC0 的物理地址；
    / 发送方 IP 地址 SOURCE IP: 192.68.1.11，即 PC0 对应的 IP 地址；
    / 目标 MAC 地址 TARGET MAC: 0000.0000.0000，由于这是一个 ARP 请求，因此为该值，表示发送方正在查询这个 MAC 地址；
    / 目标 IP 地址 TARGET IP: 192.168.1.1，即请求 ARP 解析的 IP 地址。
  - 输出 PDU 详情：
    / 硬件类型 HARDWARE TYPE: 0x0001，表示这是一个以太网帧；
    / 硬件长度 HLEN: 0x06，表示物理地址（MAC 地址）的长度为 6 个字节；
    / 协议长度 PLEN: 0x04，表示协议地址（IP 地址）的长度为 4 个字节；
    / 操作码 OPCODE: 0x0002，表示这是一个 ARP 响应报文；
    / 发送方 MAC 地址 SOURCE MAC: 00D0.D3AE.6701，即 Router0 的物理地址；
    / 发送方 IP 地址 SOURCE IP: 192.68.1.1，即 Router0 对应的 IP 地址；
    / 目标 MAC 地址 TARGET MAC: 0000.0C28.5440，由于是响应，ARP 所请求设备的 MAC 地址；
    / 目标 IP 地址 TARGET IP: 192.168.1.11，这里为发起请求的设备。

#pagebreak()
2. 本机 ARP 内容：
  #figure(
    image("..\assets\24_06.png", width: 50%),
    caption: [本机 ARP 内容],
  ) <fig-24_06>

+ 分析 WireShark 抓取的 ARP 报文：
  #figure(
    image("..\assets\24_07.png", width: 100%),
    caption: [抓取到的 ARP 报文内容],
  ) <fig-24_07>
  - 对图中 ARP 请求信息的分析如下：
    / 硬件类型: 1，表示这是一个以太网帧；
    / 硬件长度: 6，表示物理地址（MAC 地址）的长度为 6 个字节；
    / 协议长度: 4，表示协议地址（IP 地址）的长度为 4 个字节；
    / 操作码: 1，表示这是一个 ARP 请求报文；
    / 发送方 MAC 地址: 9c:54:c2:0d:50:02，即发送方的物理地址；
    / 发送方 IP 地址: 100.81.255.254，即发送方的 IP 地址；
    / 目标 MAC 地址: 00:00:00:00:00:00，由于这是一个 ARP 请求，因此为该值，表示发送方正在查询这个 MAC 地址；
    / 目标 IP 地址: 100.81.191.46，即本机 IP 地址。

= 分析讨论

在本次实验中，我们在虚拟实验环境中模拟了 PC 发送 ARP 请求及路由器处理并返回 ARP 响应报文的过程，在这个过程中我们观察到了 ARP 报文的结构及其通信过程；并通过分析对虚拟实验环境中传输的报文及抓包工具捕获的报文，我们了解了 ARP 协议的工作原理，更加深入地理解了 ARP 协议在网络通信中的重要作用。

实验过程中，如果在一次 `ping` 之后重新 `ping` 的话，PC 不会发送 ARP 请求报文，需要清除 ARP 缓存才可以在模拟模式下访问到 ARP 报文。这是因为只有在以下情况下才会发出 ARP 包：新设备加入网络、ARP 缓存中没有该条目、IP 地址冲突、IP 地址更改、ARP 缓存超时、网络设备重启或连接恢复。在第一次的 `ping` 操作后 PC 中就有了目标 IP 对应的 ARP 缓存，需要清除该缓存 PC 才会重新发出 ARP 包。

