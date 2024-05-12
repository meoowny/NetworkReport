= 实验目的

通过本次实验，我们将深入理解并掌握 IP 协议的数据报文格式和传输过程。通过对 IP 数据包的分析，我们将更好地理解网络层的工作机制，使我们能够更好地解决网络设计与故障排除中遇到的问题。

= 实验原理

+ IP 协议：这是一种不可靠无连接的数据报传输服务，IP 层提供的服务是通过 IP 层对数据报的封装与拆封来实现的。
+ IP 数据报格式：分为报头区和数据区两大部分。其中报头区是为了正确传输高层数据而加的各种控制信息，数据区包括高层协议需要传输的数据。
  + 头部包含了版本、首部长度、区分服务、总长度、标识、标志、片偏移、生存时间、协议、首部检验和、源地址和目的地址。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境，WireShark

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\23_01.png", width: 80%),
    caption: [网络拓扑图],
  ) <fig-23_01>
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
+ 为 Web 服务器配置静态 IP：
  #figure(
    image("..\assets\23_10.png", width: 80%),
    caption: [Web 服务器 IP 配置],
  ) <fig-23_10>

+ 打开 PC2 的 Web Browser，在模拟模式下输入 Web 服务器的 IP 地址，产生 IP 数据报文：
  #figure(
    image("..\assets\23_11.png", width: 40%),
    caption: [访问 Web 服务器],
  ) <fig-23_11>
  #figure(
    image("..\assets\23_12.png", width: 100%),
    caption: [数据包传输],
  ) <fig-23_12>
+ 分析产生的报文；
+ 使用 WireShark 抓切本机 IP 数据包，解读报文。

= 实验现象

+ 虚拟实验环境中的报文\ 
  以 Switch1->Router0 的报文为例：
  #figure(
    image("..\assets\23_13.png", width: 50%),
    caption: [],
  ) <fig-23_13>
  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\23_14.png", width: 90%),
      caption: [],
    ),
    figure(
      image("..\assets\23_15.png", width: 90%),
      caption: [],
    )
  )
  - OSI Model 分析：
    + Layer3 Inbound: 数据包进入的 IP 头部显示源 IP 地址为 192.168.2.11，目的 IP 地址为 192.168.1.13；
    + Layer2 Inbound: 以太网 II 帧的源 MAC 地址是 0006.2A09.A4A1，目的 MAC 地址是路由器接口的 MAC 地址 0005.5EB7.4202；
    + Layer1 Inbound: 数据包通过 FastEthernet0/1 接口进入。
  - IP 报文分析：
    + 版本 VER：4，即使用的是 IPv4 协议；
    + 首部长度 IHL：5，通常表示 IP 数据包头部的长度，以 32 位字为单位；
    + 区分服务 DSCP：0x00，用于标识数据包的服务类型，这里表示没有特殊的区分服务；
    + 总长度 TL：表示整个 IP 数据包的长度，包括头部和数据；
    + 标识 ID：0x0011，用于唯一识别主机发送的每一个数据报；
    + 标志 FLAGS 和片偏移 FRAG OFFSET：标志位通常用于控制和识别数据包的分片行为，片偏移表示数据片在原始数据报文中的位置。这里片偏移为 0x000，表示该数据包未分片或是第一个分片；
    + 生存时间 TTL：表示数据包在网络中可以经过的最大路由器数；
    + 协议 PRO：表示数据包的上层协议，这里的 0x06 表示 TCP 协议；
    + 头部校验和 CHKSUM：用于错误检测，保证头部信息的正确性；
    + 源 IP 地址 SRC IP：发送数据包的主机 IP 地址，这里为 192.168.2.11；
    + 目的 IP 地址 DST IP：接收数据包的主机 IP 地址，这里为 192.168.1.13；
+ 本机的 IP 报文\ 
  以如下报文为例：
  #figure(
    image("..\assets\23_16.png", width: 80%),
    caption: [本机 IP 报文],
  ) <fig-23_16>
  - 版本：4，表示使用的是 IPv4 协议；
  - 首部长度：20 字节（5个32位字），这是不包含任何选项的标准IPv4头部长度；
  - 区分服务字段：0x00，表示没有特殊的区分服务或流量优先级被设置；
  - 总长度：这个字段指定了整个 IP 数据包的长度，包括头部和数据。该报文该字段的值是 40；
  - 标识：0x0000，这是一个用于唯一标识主机发送的每一个数据报的值，它在数据报的分片和重组过程中起到关键作用；
  - 标志：Don't fragment，表示该数据包不应被分片；
  - 片偏移：0，这表明该数据包不是一个更大数据包的分片，或者是一系列分片中的第一个；
  - 生存时间：值为 54，它减少的次数通常等于数据包经过的路由器数量；
  - 协议：TCP（6），表明上层协议是TCP；
  - 头部校验和：这是一个用于检测头部信息在传输过程中是否出现错误的校验和；
  - 源 IP 地址：222.192.186.140，发送数据包的设备的IP地址；
  - 目的 IP 地址：100.80.16.122，接收数据包的设备的IP地址。

= 分析讨论

通过本次实验，我更加深入地理解了 IP 协议的数据报文格式和它的传输过程。通过对于虚拟实验环境和本机的 IP 数据包的分析，我更加熟悉了 IP 协议数据报文的格式与 IP 协议的特点。

此外在实验过程中，我注意到，虚拟实验环境中当 PC2 发送 HTTP 请求时，开始出现的是 TCP 数据块。这是由于 HTTP 是应用层上的协议，而 TCP 是传输层上的协议，HTTP 协议基于 TCP 协议。

