// DNS 实验

= 实验目的

= 实验原理

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
+ 打开 PC3 的 Web Browser，在模拟模式下输入 Web 服务器的域名访问网页，产生 DNS 数据报文：
  #figure(
    image("..\assets\27_03.png", width: 80%),
    caption: [PC3 访问网页],
  ) <fig-27_03>
  #figure(
    image("..\assets\27_04.png", width: 80%),
    caption: [报文传输情况],
  ) <fig-27_04>
  #figure(
    image("..\assets\27_05.png", width: 80%),
    caption: [PC3 发出 DNS 请求],
  ) <fig-27_05>
  #figure(
    image("..\assets\27_06.png", width: 80%),
    caption: [DNS 报文内容],
  ) <fig-27_06>
  #figure(
    image("..\assets\27_07.png", width: 80%),
    caption: [DNS Server 收到请求],
  ) <fig-27_07>
  #figure(
    image("..\assets\27_08.png", width: 80%),
    caption: [DNS 报文内容],
  ) <fig-27_08>
  #figure(
    image("..\assets\27_09.png", width: 80%),
    caption: [DNS Server 收到的请求格式],
  ) <fig-27_09>
+ 分析产生的报文；
+ 使用 WireShark 抓切本机 DNS 数据包，解读报文。

= 实验现象

= 分析讨论

