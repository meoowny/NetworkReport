// TCP 段分析实验

= 实验目的

通过本次实验，我们将借助虚拟实验环境和抓包工具，深入研究 TCP 协议的基本概念、报文结构和连接过程，理解并分析 TCP 数据包的结构和传输过程。本次实验中，我们将深入了解 TCP 的包括连接建立、数据传输和连接终止的过程。

= 实验原理

+ TCP 是传输层的协议，功能是在 IP 的数据报服务之上增加了最基本的*复用*和*分用*以及*差错检测*的服务。
+ TCP 是一个基于连接的四层协议，提供全双工的、可靠的传输系统。它能够保证数据被远程主机接收。并且能够为高层协议提供 flow-controlled 服务。
+ 空间上，TCP 需要在端系统中维护连接状态，需要一定的开销。些连接装入包括接收和发送缓存、拥塞控制参数和序号与确认号的参数。与 UDP 不同，UDP 不维护连接状态，也不跟踪这些参数，开销小，空间和时间上都具有优势。
+ TCP 报文板式：TCP 报文是 TCP 层传输的数据单元，也叫报文段。格式如下：
  #figure(
    image("..\assets\25_50.png", width: 65%),
    caption: [TCP 报文格式],
  ) <fig-25_50>
+ TCP 连接过程：相对于 SOCKET 开发者，TCP 创建过程和链接拆除过程是由 TCP/IP 协议栈自动创建的。因此开发者并不需要控制这个过程。但是对于理解 TCP 底层动作机制，相当有帮助。TCP 连接过程可以简单概括为：“三次握手四次挥手”。
  + TCP 三次握手：指建立一个 TCP 连接时，需要客户端和服务器总共发送 3 个包。三次握手的目的是连接服务器指定端口，建立 TCP 连接，并同步连接双方的序列号和确认号，并交换 TCP 窗口大小信息。在 socket 编程中，客户端执行 connect() 时，将触发三次握手。步骤如下：
    + 客户端发送一个 TCP 的 SYN 标志位置 1 的包指明客户打算连接的服务器的端口，以及初始序号 X，保存在包头的序列号字段中。
    + 服务器发回 SYN+ACK 包应答，该报文还将包含服务器的初始序列号和确认号（即客户端的序列号+1）。
    + 客户端再次发送 ACK 报文，并把服务器发来 ACK 的序号字段 + 1，放在确定字段中发送给对方。服务器收到该 ACK 报文后双方建立起稳定的连接。
  + TCP 四次挥手：指拆除一个 TCP 连接需要发送四个包。客户端或服务器均可主动发起挥手动作，在 socket 编程中，任何一方执行 close() 操作即可产生挥手操作。
  + TCP 三次握手涉及的 TCP 状态转换图如下：
    #figure(
      image("..\assets\25_51.png", width: 70%),
      caption: [三次握手的 TCP 状态转换图],
    ) <fig-25_51>

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境，WireShark

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\27_01.png", width: 80%),
    caption: [网络拓扑图],
  ) <fig-27_01>
  / Router0: FA 0/0: 192.168.1.1 Mask: 255.255.255.0\ 
             FA 0/1: 192.168.2.1 Mask: 255.255.255.0
  / DNS Server1: 192.168.1.2 Mask: 255.255.255.0 Gateway: 192.168.1.1
  / Web Server1: 192.168.1.5 Mask: 255.255.255.0 Gateway: 192.168.1.1
  / DNS Server2: 192.168.2.2 Mask: 255.255.255.0 Gateway: 192.168.2.1
  / Web Server2: 192.168.2.5 Mask: 255.255.255.0 Gateway: 192.168.2.1
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
+ 为 Web 和 DNS 服务器配置静态 IP；
+ 配置 DNS 服务器的域名解析服务：
  #figure(
    image("..\assets\27_02.png", width: 80%),
    caption: [域名配置],
  ) <fig-27_02>
+ 打开 PC3 的 Web Browser，在模拟模式下输入 Web 服务器的域名 `https:/www.tongji.edu.cn` 访问网页，产生 TCP 数据报文：
  #figure(
    image("..\assets\27_03.png", width: 80%),
    caption: [PC3 访问网页],
  ) <fig-27_03>
+ 分析产生的报文；
+ 使用 WireShark 抓取本机 TCP 数据包，解读报文；
+ 研读 TCP 连接建立过程数据报文及 TCP 拆链过程数据报文。

= 实验现象

+ Packet Tracer 虚拟实验环境中 TCP 数据报情况：#h(500pt)
  以 `Switch0->Web Server1` 这一段为例进行分析：
  #figure(
    image("..\assets\25_60.png", width: 60%),
    caption: [],
  ) <fig-25_60>
  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\25_61.png", width: 90%),
      caption: [],
    ),
    figure(
      image("..\assets\25_62.png", width: 90%),
      caption: [],
    ),
  )
  - 输入 PDU 详情：
    - 源端口：1025；
    - 目标端口：443（通常用于 HTTPS 服务）；
    - 序列号和确认号均为 0，这通常是在建立连接时的 SYN 报文；
    - 源 IP：192.168.2.11；
    - 目的 IP：192.168.1.5；
    - 以太网 II 帧头：包含了目标和源 MAC 地址；
    - TCP 控制位：不显示在这个阶段的截图中，因为设置了 SYN 位，表明这是一个连接请求。
  - 输出 PDU 详情：
    - 源端口：443；
    - 目标端口：1025；
    - 序列号：0；
    - 确认号：1，表明第一阶段的 SYN 请求已被确认；
    - TCP 控制位：设置了 SYN 和 ACK，表明这是三次握手过程中的第二次握手。

+ 分析 WireShark 抓取的数据报：
  - TCP 连接建立过程：
    #figure(
      image("..\assets\25_63.png", width: 90%),
      caption: [WireShark 抓取的数据报],
    ) <fig-25_63>
    - 源端口号：52125，发送方的端口号；
    - 目的端口号：443，接收方的端口号；
    - 序列号：2958131102，发送的数据的第一个字节的序列号；
    - 确认号：1，接收方期望收到的下一个字节的序列号，它确认了接收方已经接收到的数据；
    - 数据位移：20 字节，表示没有额外的 TCP 选项被设置；
    - 标志位：0x010(ACK)，仅设置了 ACK 标志位；
    - 窗口大小：515，接收方当前的接收窗口大小，用于告知发送方它还能接收多少字节的数据；
    - 校验和：0x1a62，用于错误检测，这个值是对整个 TCP 段计算得出的；
    - 紧急指针：0，因为 URG 标志没有设置，所以这个字段不被使用；
    - 选项：此处没有显示 TCP 选项，但由于头部长度为 20 字节，因此可以推断没有额外的选项。
  - TCP 连接拆链过程：
    #figure(
      image("..\assets\25_64.png", width: 90%),
      caption: [WireShark 抓取的数据报],
    ) <fig-25_64>
    - 源端口号：443；
    - 目的端口号：52076；
    - 序列号：相对序列号为 1，因为它是相对于 TCP 连接初始化的序列号；
    - 确认号：7552217280，表示发送方已经收到对方发送的数据直到这个序号；
    - 标志位：0x011，设置了 FIN 和 ACK 标志。FIN 标志表示发送方已经完成了数据传输并希望开始终止连接；ACK 标志是对先前接收到的 TCP 段的确认；
    - 窗口大小：165，接收窗口的大小，表示在不接收进一步确认的情况下接收方还能接收多少字节的数据；
    - 校验和：0x59c7，用于验证数据包在传输过程中的完整性和正确性；
    - 紧急指针：0，因为 URG 标志未设置，所以该字段不被使用。

= 分析讨论

在本次实验中，我们在虚拟实验环境中模拟了 PC 通过 DNS 服务器的域名解析服务访问 Web 服务器的过程，在这个过程中观察到了 TCP 的连接建立、数据传输、连接终止的过程；并通过分析对虚拟实验环境中传输的数据报的分析及抓包工具捕获的报文，我们进一步了解了 TCP 协议的基本概念与报文结构，切实学习到了 TCP 数据包的结构与传输过程，更加深入地理解了 TCP 协议的特点与优势。

