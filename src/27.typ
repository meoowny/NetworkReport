// DNS 实验

= 实验目的

本次实验中，我们将探究 DNS（域名系统）的功能和运作机制，通过模拟和分析 DNS 域名解析的过程，深入理解域名转换为 IP 地址的基本原理和工作过程，了解 DNS 服务的体系结构，并掌握 DNS 域名解析的顺序。

= 实验原理

+ DNS（Domain Name System）：“域名系统”的英文缩写，是一种组织成域层次结构的计算机和网络服务命名系统，用于 TCP/IP 网络，它所提供的服务是将主机名和域名转换为 IP 地址。
+ DNS 的过程：
  + 用户主机上运行 DNS 客户端；
  + 浏览器将接收到的 URL 中抽取出域名字段，即访问的主机名，并将这个主机名传送给 DNS 应用的客户端；
  + DNS 客户端向 DNS 服务器端发送一份查询报文，报文中包含着要访问的主机名字段（中间包括一些列缓存查询以及分布式 DNS 集群的工作）；
  + 该 DNS 客户机最终会收到一份回答报文，其中包含有该主机对应的 IP 地址；
  + 一旦该浏览器收到来自 DNS 的 IP 地址，就可以向该 IP 地址定位的 HTTP 服务器发起 TCP 连接。
+ DNS 服务的体系架构：从用户主机上调用应用程序的角度来看，DNS 是一个提供简单、直接的转换服务的黑盒子。但事实上，实现这个服务的黑盒子非常复杂，它由分布于全球的大量 DNS 服务器以及定义了 DNS 服务器与查询主机通信方式的应用层协议组成。DNS 服务器一般分为三种：根 DNS 服务器、顶级 DNS 服务器、权威 DNS 服务器。使用分布式的层次数据库形式以及缓存方法来解决单点集中式的问题。
  #figure(
    image("..\assets\27_70.png", width: 48%),
    caption: [DNS 服务器的部分层次结构],
  ) <fig-27_70>
+ DNS 域名解析顺序：
  + 浏览器、系统及路由器缓存；
  + ISP（互联网服务提供商） DNS 缓存；
  + 根域名服务器；
  + 顶级域名服务器；
  + 主域名服务器；
  + 保存结果至缓存。

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
    image("..\assets\27_02.png", width: 57%),
    caption: [域名配置],
  ) <fig-27_02>
+ 打开 PC3 的 Web Browser，在模拟模式下输入 Web 服务器的域名 `https://www.tongji.edu.cn` 访问网页，产生 DNS 数据报文：
  #figure(
    image("..\assets\27_03.png", width: 50%),
    caption: [PC3 访问网页],
  ) <fig-27_03>

+ 分析产生的报文；
+ 使用 WireShark 抓取本机 DNS 数据包，解读报文。

= 实验现象

+ 本次实验中 PC3 访问 Web Server1 时产生的相关数据包如下：#h(500pt)
  #figure(
    image("..\assets\27_04.png", width: 82%),
    caption: [报文传输情况],
  ) <fig-27_04>

  // #figure(
  //   image("..\assets\27_05.png", width: 80%),
  //   caption: [PC3 发出 DNS 请求],
  // ) <fig-27_05>
  // #figure(
  //   image("..\assets\27_06.png", width: 80%),
  //   caption: [DNS 报文内容],
  // ) <fig-27_06>
+ Packet Tracer 虚拟实验环境中 DNS 报文情况：
  以 `Switch1->DNS Server2` 的 DNS 报文为例：
  #figure(
    image("..\assets\27_07.png", width: 80%),
    caption: [DNS Server 收到请求],
  ) <fig-27_07>
  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\27_08.png", width: 100%),
      caption: [DNS 报文内容],
    ),
    figure(
      image("..\assets\27_09.png", width: 100%),
      caption: [DNS Server 收到的请求格式],
    ),
  )
  - DNS 头部信息：
    - 事务 ID：这是由客户端生成的一个随机数，用于匹配 DNS 请求和响应，以使客户端可以识别并关联响应与它的原始查询；
    - 标志位：包括多个部分，如 QR（查询/响应标志）、OPCODE（操作码）、AA（授权应答）、TC（截断）、RD（期望递归）、RA（递归可用）、RCODE（响应代码）；
    - 问题计数：表示查询中问题的数量。这里为 1，表示该 DNS 请求只查询了一个域名。
  - DNS 查询与应答部分：
    - NAME：客户端请求解析的域名，这里是 `www.tongji.edu.cn`。DNS 服务器需要在其记录中查找这个特定的域名，并返回相应的 IP 地址；
    - TYPE：查询类型字段提示了客户端请求的 DNS 记录类型。这里为 1 表示这是一个 A 记录查询，客户端期望得到域名对应的 IPv4 地址；
    - CLASS：表示查询的类别，这里是 1 表示 IN（Internet），即这是一个标准的互联网 DNS 查询；
    - TTL：该字段指定了 DNS 记录的生存时间。86400秒表示一旦这个 DNS 记录被 DNS 解析器缓存，它将在缓存中保留 24 个小时，除非被提前清除；
    - LENGTH：这个字段通常表示应答记录中数据字段的长度。这里应答的 LENGTH 为 4，表示查询结果的 IP 地址有 4 个字节；
    - IP：所查询的域名对应的 IP 地址，这里是 192.168.1.5，符合网络部署时的设置。

+ 分析 WireShark 抓取的 DNS 数据报：
  #figure(
    image("..\assets\27_10.png", width: 80%),
    caption: [WireShark 抓取的 DNS 数据报],
  ) <fig-27_10>
  - 事务 ID：0xb0f8；
  - 标志：0x0100 标准查询，表明这是一体标准 DNS 查询消息。该消息仅是一个查询请求；
  - 问题数：1；
  - 回答资源记录数：0，表示响应中没有包含答案资源的记录，没有返回与查询域名相对应的 IP 地址；
  - 授权资源记录数：0，表示响应中没有授权资源记录，没有返回权威 DNS 服务器的信息；
  - 附加资源记录数：0，表示响应中没有附加资源记录，没有额外的资源记录信息；
  - 查询：
    - 名称：要查询的域名为 `1.tongji.edu.cn`；
    - 类型：A(1)，表示查询的类型是互联网（IN）；
    - 类：IN(0x0001)，表示查询的类别是互联网。
  - 响应编号：67901，表明响应可以在 WireShark 捕获的第 67901 号帧中找到。

= 分析讨论

DNS 是互联网不可或缺的一部分，它负责将对用户的域名转换为机器识别的 IP 地址。在本次实验中，我们在虚拟实验环境中模拟了 PC 通过 DNS 服务器的域名解析服务访问 Web 服务器的过程，在这个过程中观察到了 DNS 将域名转换为 IP 地址的过程；并通过分析对虚拟实验环境中传输的数据报的分析及抓包工具捕获的报文，我们进一步了解了 DNS 协议的基本概念与报文结构，了解了 DNS 服务的体系结构，更加深入地理解了 DNS 对于互联网的重要作用。DNS 查询作为网络访问中的第一步，在 TCP 连接与 HTTP 请求之前进行，其高效运作将对整个网络访问流程起到至关重要的作用。

