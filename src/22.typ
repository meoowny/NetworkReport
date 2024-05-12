= 实验目的

通过本次实验，我们将学习并理解以太网技术及其框架结构，然后分析 MAC 地址和以太网帧的构成，并通过 WireShark 软件抓取分析 MAC 数据包，在这个过程中加深对于以太网的理解。

= 实验原理

+ 以太网是一种计算机局域网技术，IEEE 组织的 IEEE802.3 标准制定了以太网的技术标准，它规定了包括物理层的连线、电子信号和介质访问层协议的内容。以太网是目前应用最普遍的局域网技术。
+ 以太网的种类：
  + 经典以太网，是以太网的原始形式，运行速度从 3~10 Mbps 不等；
  + 交换式以太网，使用交换机连接不同的计算机，是目前广泛应用的以太网，可运行在 100、1000 和 10000 Mbps 的高速率，分别以快速以太网、千兆以太网和万兆以太网的形式呈现。
+ 以太网的拓扑结构：
  + 总线型拓扑：是以太网的标准拓扑结构；
  + 星型拓扑：目前的快速以太网为了减少冲突，最大化网络速度和使用效率，使用交换机来进行网络连接和组织。但在逻辑上，以太网仍然使用总线型拓扑和 CSMA/CD 的总线技术。每一个节点有全球唯一的 MAC 地址，以保证以太网上所有节点能互相鉴别。
+ 由于以太网十分普遍，许多制造商把以太网卡直接集成进计算机主板。
+ MAC 地址：也别物理地址、硬件地址，由网络设备制造商生产时烧录在网卡（Network Interface Card）的 EPROM 中。MAC 地址在世界是唯一的。
  + 格式：它的长度为 48 位（6 个字节），通常表示为 12 位十六进制数。其中前 3 个字节表示 OUI，是 IEEE 分配给不同厂家的代码，用于区分不同的厂家；后 3 个字节代表该制造商所制造的某个网络产品的系列号，由厂家自行分配。
    // - MAC 地址最高字节（MSB）的低二位（LSb）表示这个 MAC 地址是全局的还是本地的，即 U/L（Universal/Local）位，为 0 表示是全局地址。所有 OUI 的这一位都是 0。
    // - MAC 地址的低第一位（LSb）表示这个 MAC 地址是单播还是多播。0 表示单播。
+ MAC 数据包格式：
  + 前导码与帧开始符：一帧以 7 字节前导码和 1 字节帧开始符作为帧的开始。
  + 报头：包含源地址和目标地址的 MAC 地址，以太类型字段和可选的用于说明 VLAN 成员关系和传输优先级的 IEEE802.1Q VLAN 标签。
  + 帧校验码：是一个 32 位循环冗余校验码，以后验证帧数据是否被损坏。

= 实验设备

- 实验硬件：济事楼 330 机房电脑，个人笔记本电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境，WireShark

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\22_01.png", width: 40%),
    caption: [网络拓扑图],
  ) <fig-22_01>
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
+ 配置 Router0 的 DHCP 左右两边的网络：
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
+ 点击模拟 ICMP 包，查看相关数据并进行分析：
  + 点击 Simulation 进入模拟模式后，在 PC0 终端输入 `ping 192.168.2.11` 后点击向右的箭头单步执行，或点击播放按键自动执行；
  + 在 Event List 处查看数据包信息，点击任一数据包可查看具体信息。
  #figure(
    image("..\assets\22_02.png", width: 70%),
    caption: [模拟模式界面],
  ) <fig-22_02>

+ 安装 WireShark 软件；
+ 使用 `ipconfig /all` 查看本机 MAC 地址：
  #figure(
    image("..\assets\22_03.png", width: 80%),
    caption: [查看本机 MAC 地址],
  ) <fig-22_03>
+ 使用 WireShark 抓取 MAC 数据包：打开 WireShark 选择需要抓包的方式；\ 
  个人电脑使用 WLAN 连接网络，因此这里使用 WLAN：
  #figure(
    image("..\assets\22_04.png", width: 50%),
    caption: [WireShark 界面],
  ) <fig-22_04>
+ 查看 MAC 数据包字段内容并解读：点击相应的条目即可查看其 MAC 数据包内容。

= 实验现象

// 解读 80 字段？

#set enum(full: true)
+ 模拟 ICMP 包，查看相关数据：#h(500pt)
    #figure(
      image("..\assets\22_05.png", width: 50%),
      caption: [],
    ) <fig-22_05>
  + 第一张图显示了从 PC0 到 Router0 的入站 PDU 细节：
    + Layer1: 数据包在物理层通过 FastEthernet 端口接收；
    + Layer2: 是数据包的 Ethernet II 帧头信息，包含了源 MAC 地址和目标 MAC 地址；
    + Layer3: 是 IP 层的信息，显示了源 IP 地址和目的 IP 地址以及 ICMP 消息类型。
    #figure(
      image("..\assets\22_06.png", width: 60%),
      caption: [],
    ) <fig-22_06>
  + 第二张图显示了 Router0 的 PDU 格式，解释了 Ethernet II 帧的结构：
    + Ethernet II 帧：包含了前导码、目标 MAC 地址、源 MAC 地址、类型、数据和帧校验码（FCS）；
    + IP：包含了头部长度、服务类型、总长度、标识、标志、片位移、生存时间（TTL）、协议、头校验和、源 IP 和目的 IP；
    + ICMP：服务了类型、代码、校验和、标识符和序列号。
    #figure(
      image("..\assets\22_07.png", width: 60%),
      caption: [],
    ) <fig-22_07>
  + 第三张图显示了 Router0 处理完入站 PDU 后创建的出站 PDU：
    + Ethernet II 帧：目标 MAC 地址更新为下一个目标设备的 MAC 地址，源 MAC 地址更新为 Router0 的 MAC 地址；
    + IP：由于 IP 层是端到端的，不会在路由器传输时改变，因此信息保持不变，ICMP 信息也就保持不变。

#let pc = [0001.C93A.50A1]
#let s0 = [0005.5EB7.4201]
#let r0 = [0006.2A09.A4A1]
#let s1 = [0005.5EB7.4202]
+ ICMP 数据包转发过程中 MAC 地址变化情况（PC0 ping PC2）：
  #figure(
    table(
      columns: (1fr, 1fr, 1fr, 1fr),
      align: (center),
      table.header(
        [*Last Device*], [*At Device*], [*目的 MAC*], [*源 MAC*],
      ),
      [--], [PC0], [#s0], [#pc],
      [PC0], [Switch0], [#s0], [#pc],
      [Switch0], [Router0], [#r0], [#s1],
      [Router0], [Switch1], [#r0], [#s1],
      [Switch1], [PC2], [#s1], [#r0],
      [PC2], [Switch1], [#s1], [#r0],
      [Switch1], [Router0], [#pc], [#s0],
      [Router0], [Switch0], [#pc], [#s0],
      [Switch0], [PC0], [#pc], [#s0],
      [...], [...], [...], [...],
    )
  )

+ MAC 数据包字段内容解读：
  #figure(
    image("..\assets\22_08.png", width: 80%),
    caption: [],
  ) <fig-22_08>
  这是一个连接终止请求，是 TCP 连接终止握手过程中的一部分，表明发送方想要关闭连接。
  + Frame（帧信息）
    / Number: 数据包编号，这里为 21；
    / Length: 数据包长度，这里为 56 字节；
    / Protocol in frame: 数据包所含协议层，这里有 Ethernet II、IP 和 TCP。
  + Ethernet II
    / Destination MAC Address: 目标 MAC 地址 CloudNetword_df:79:27，指定了数据包的目的物理地址；
    / Source MAC Address: 源 MAC 地址 NewH3CTechno_0d:50:02
    / Type: 数据包类型，这里是 IPv4(0x0800)，表示这是一个 IPv4 网络层数据包。
  + Internet Protocol Version 4
    / Total Length: 整个 IP 数据包的总长度；
    / Time to live: 数据包在网络上的生存时间，这里是 54；
    / Source Address: 源 IP 地址 222.192.186.140；
    / Destination Address: 目的 IP 地址 100.80.16.122，数据包的目的地逻辑地址。
  + Transmission Control Protocol
    / Source Port: 443，这是发送数据包的设备使用的本地端口号；
    / Destination Port: 54462，这是数据包目标设备上的端口号；
    / Sequence Number: 1，数据包的序列号，用于确保数据的有序接收；
    / Acknowledgment Number: 0，接收方期望接收的下一个序列号，同时也是确认发送方的特定序列号的一个信号；
    / Header Length: 20 字节，TCP 头部的长度；
    / Flags: 0x004(RST)，TCP 头部中的控制位；
    / Window: 0，接收窗口的大小，表示接收方还可以接收的字节数，用于流量控制；
    / Checksum: 0x90f9，用于错误检测的检验值；
    / Urgent Pointer: 0， 用于指出数据包中的紧急数据，数值为 0 表示数据包中没有紧急数据。

= 分析讨论

通过本次实验，我对以太网技术及其框架结构有了更加深入的理解，通过对于 ICMP 数据包传输的模拟，我对于 MAC 地址的作用有了更加直观的理解。在模拟实验中，我也观察到 ICMP 数据包转发过程中 MAC 地址的变化，这是由于数据在同一网络层内转发时源可 MAC 不变而目的 MAC 需要更新为下一个设备的 MAC 地址，而如果数据通过路由器传送到另一个网络层时，路由器会在不同网络层间转发数据包时更改源 MAC 和目的 MAC 地址。

此外通过本次实验，我掌握了抓包工具的基本使用方法，并对数据包字段进行解读，对于所学过的网络协议有了更深刻的认识。

