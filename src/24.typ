// ARP 消息分析实验

= 实验目的

可以使用 `arp -a` 查看本机 ARP 情况。

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
    image("..\assets\24_01.png", width: 80%),
    caption: [ARP 报文格式],
  ) <fig-24_01>
+ 可以使用 `arp -a` 命令查看本机 ARP 内容，也可以使用 `arp -d` 删除本机的 ARP 内容。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境，WireShark

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\24_02.png", width: 80%),
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

= 实验现象

  #figure(
    image("..\assets\24_03.png", width: 80%),
    caption: [报文内容],
  ) <fig-24_03>
  #figure(
    image("..\assets\24_04.png", width: 80%),
    caption: [报文内容 1],
  ) <fig-24_04>
  #figure(
    image("..\assets\24_05.png", width: 80%),
    caption: [报文内容 2],
  ) <fig-24_05>

  #figure(
    image("..\assets\24_06.png", width: 80%),
    caption: [本机 ARP 内容],
  ) <fig-24_06>

  #figure(
    image("..\assets\24_07.png", width: 80%),
    caption: [抓取到的 ARP 报文内容],
  ) <fig-24_07>

= 分析讨论

