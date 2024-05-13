// TCP 段分析实验

= 实验目的

= 实验原理

+ TCP 是传输层的协议，功能是在 IP 的数据报服务之上增加了最基本的*复用*和*分用*以及*差错检测*的服务。
+ TCP 是一个基于连接的四层协议，提供全双工的、可靠的传输系统。它能够保证数据被远程主机接收。并且能够为高层协议提供 flow-controlled 服务。
+ TCP 报文字段：
  + 端口号
    + 源端口：
    + 目的端口：
  + 序号和确认号
  + 数据偏移/首部长度
  + 保留
  + 控制位
    + URG
    + ACK
    + PSH
    + RST
    + SYN
    + FIN
  + 窗口
  + 检验和
  + 紧急指针
  + 选项和填充
  + 数据部分
+ TCP 连接过程
  + TCP 三次握手
  + TCP 四次握手

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
+ 打开 PC3 的 Web Browser，在模拟模式下输入 Web 服务器的域名访问网页，产生 TCP 数据报文：
+ 分析产生的报文；
+ 使用 WireShark 抓切本机 TCP 数据包，解读报文；
+ 研读 TCP 连接建立过程数据报文及 TCP 拆链过程数据报文

= 实验现象

= 分析讨论

