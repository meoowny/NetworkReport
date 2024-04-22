= 实验目的

= 实验原理

+ DHCP（Dynamic Host Configuration Protocol，动态主机配置协议）通常被应用在大型的局域网环境中，主要作用是集中管理、分配 IP 地址，使网络环境中的主机动态地获得 IP 地址、Gateway 地址、DNS 服务器地址等信息，并能够提升地址的使用率。
+ DHCP 协议采用客户端/服务器模型，主机地址的动态分配任务由网络主机驱动。当 DHCP 服务器接收到来自网络主机𱋍地址的信息时，才会向网络主机发送相关的地址配置等信息，以实现网络主机地址信息的动态配置。
+ DHCP 协议采用 UDP 作为传输协议，主机发送请求消息到 DHCP 服务器的 67 号端口，DHCP 服务器回应应答消息给主机的 68 号端口。详细的交互过程如下图：
  #figure(
    image("..\assets\18_01.png", width: 80%),
    caption: [DHCP 协议交互过程],
  ) <fig-18_01>
+ 由于 DHCP 是 C/S 模式运行的，所以使用 DHCP 的设备为客户端，而提供 DHCP 服务的为服务端。DHCP 客户端可以让设备自动地从 DHCP 服务器获得 IP 地址以及其他配置参数。使用 DHCP 客户端可以带来如下好处：
  + 降低了配置和部署设备的时间；
  + 降低了发生配置错误的可能性；
  + 可以集中管理设备的 IP 地址分配。
+ DHCP 服务器指的是由服务器控制一段 IP 地址范围，客户端登录服务器时就可以自动获得服务器分配的 IP 地址和子网掩码。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：

= 实验步骤

#figure(
  image("..\assets\18_02.png", width: 80%),
  caption: [网络拓扑图],
) <fig-18_02>

#figure(
  image("..\assets\18_05.png", width: 80%),
  caption: [将 PC IP 配置改为 DHCP],
) <fig-18_05>

#figure(
  image("..\assets\18_07.png", width: 80%),
  caption: [新增 PC],
) <fig-18_07>

新增路由器并将两台路由器连接，使用 OSPF 动态路由进行配置

#figure(
  image("..\assets\18_09.png", width: 80%),
  caption: [新增路由器后的网络拓扑图],
) <fig-18_09>

= 实验现象

#figure(
  image("..\assets\18_03.png", width: 80%),
  caption: [配置 DHCP 前查看 PC 的 IP 地址情况],
) <fig-18_03>

#figure(
  image("..\assets\18_04.png", width: 80%),
  caption: [配置 DHCP 后查看 PC0 的 IP 地址情况],
) <fig-18_04>

/ PC0: 192.168.1.11
/ PC1: 192.168.1.12
/ PC2: 192.168.2.11
/ PC3: 192.168.2.12

#figure(
  image("..\assets\18_06.png", width: 80%),
  caption: [新增 PC 查看 IP 地址],
) <fig-18_06>

新增 PC8 的 IP 地址：192.168.2.13

#figure(
  image("..\assets\18_08.png", width: 80%),
  caption: [PC1 ping 其他 PC 结果],
) <fig-18_08>

/ PC4: 172.16.3.11
/ PC5: 172.16.3.12
/ PC6: 172.16.4.11
/ PC7: 172.16.4.12

= 分析讨论

