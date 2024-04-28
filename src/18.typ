= 实验目的

通过本次实验，我们将了解并掌握 DHCP（Dynamic Host Configuration Protocol）的工作原理，并学习如何在路由器上配置 DHCP 服务。然后在实践过程中观察和理解动态分配 IP 地址的过程，更好地理解 DHCP 服务的应用场景与优势。

= 实验原理

+ 动态主机配置协议（DHCP，Dynamic Host Configuration Protocol）是一种网络管理协议，通常被应用在大型的局域网环境中，主要作用是集中管理、分配 IP 地址，使网络环境中的主机动态地获得 IP 地址、Gateway 地址、DNS 服务器地址等信息，并能够提升地址的使用率。
+ DHCP 协议采用客户端/服务器模型，主机地址的动态分配任务由网络主机驱动。当 DHCP 服务器接收到来自网络主机申请地址的信息时，才会向网络主机发送相关的地址配置等信息，以实现网络主机地址信息的动态配置。
+ DHCP 协议采用 UDP 作为传输协议，主机发送请求消息到 DHCP 服务器的 67 号端口，DHCP 服务器回应应答消息给主机的 68 号端口。详细的交互过程如下图：
  #figure(
    image("..\assets\18_01.png", width: 80%),
    caption: [DHCP 协议交互过程],
  ) <fig-18_01>
+ 由于 DHCP 是 C/S 模式运行的，所以使用 DHCP 的设备为客户端，而提供 DHCP 服务的为服务端。DHCP 客户端可以让设备自动地从 DHCP 服务器获得 IP 地址以及其他配置参数。
+ 使用 DHCP 客户端可以带来如下好处：
  + 降低了配置和部署设备的时间；
  + 降低了发生配置错误的可能性；
  + 可以集中管理设备的 IP 地址分配。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\18_02.png", width: 80%),
    caption: [网络拓扑图],
  ) <fig-18_02>
  / Router0: FA 0/0: 192.168.1.1 Mask: 255.255.255.0\ 
             FA 0/1: 192.168.2.1 Mask: 255.255.255.0
+ 按上述配置对 Router0 的接口进行配置；
  ```bash
  interface FastEthernet0/0
  ip address 192.168.1.1 255.255.255.0
  nu shutdown
  exit
  interface FastEthernet0/1
  ip address 192.168.2.1 255.255.255.0
  nu shutdown
  ```
+ 查看各 PC 的 IP 地址情况；
+ 配置路由器 DHCP 左右两边的网络：
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

+ 将 PC 的 IP 配置改为 DHCP；
  #figure(
    image("..\assets\18_05.png", width: 80%),
    caption: [将 PC IP 配置改为 DHCP],
  ) <fig-18_05>
+ 查看各 PC 的 IP 地址情况；
  
+ 按图新增一台 PC 并将 IP 配置改为 DHCP，查看 IP 地址情况；
  #figure(
    image("..\assets\18_07.png", width: 80%),
    caption: [新增 PC],
  ) <fig-18_07>
  
+ 新增路由器 Router1，两台路由器各自连接交换机，配置 Router1 路由器的接口和 DHCP 服务，步骤同上：
  #figure(
    image("..\assets\18_09.png", width: 80%),
    caption: [新增路由器后的网络拓扑图],
  ) <fig-18_09>
  / Router1: FA 0/0: 172.16.3.1 Mask: 255.255.255.0\ 
             FA 0/1: 172.16.4.1 Mask: 255.255.255.0
+ 配置路由器的串口端口地址：
  - Router0 配置如下：
    ```bash
    interface Serial0/0/0
    ip address 202.120.17.18 255.255.255.0
    clock rate 56000
    ```
  - Router1 配置如下：
    ```bash
    interface Serial0/0/0
    ip address 202.120.17.29 255.255.255.0
    clock rate 56000
    ```
+ 配置两台路由器的 OSPF，确保两边可以相互访问：
  + Router0 配置如下：
    ```bash
    router ospf 1
    network 192.168.1.0 0.0.0.255 area 0
    network 192.168.2.0 0.0.0.255 area 0
    network 202.120.17.0 0.0.0.255 area 0
    ```
  + Router1 配置如下：
    ```bash
    router ospf 1
    network 172.16.3.0 0.0.0.255 area 0
    network 172.16.4.0 0.0.0.255 area 0
    network 202.120.17.0 0.0.0.255 area 0
    ```
+ 查看各 PC 的 IP 地址，让两边电脑互相 ping，观察实验现象。

#pagebreak()

= 实验现象

+ 配置 DHCP 前查看各 PC 的 IP 地址情况：#h(500pt)
  各 PC 的 IP 地址相同，都为 `0.0.0.0`
  #figure(
    image("..\assets\18_03.png", width: 80%),
    caption: [配置 DHCP 前查看 PC 的 IP 地址情况],
  ) <fig-18_03>
  
+ 配置 DHCP 后查看各 PC 的 IP 地址情况：
  #figure(
    image("..\assets\18_04.png", width: 80%),
    caption: [配置 DHCP 后查看 PC0 的 IP 地址情况],
  ) <fig-18_04>
  可以得到各 PC 的 IP 如下：
    / 左边两台: \ 
      / PC0: 192.168.1.11
      / PC1: 192.168.1.12
    / 右边两台: \ 
      / PC2: 192.168.2.11
      / PC3: 192.168.2.12
  
+ 新增 PC 后查看 PC 的 IP 地址：
  #figure(
    image("..\assets\18_06.png", width: 80%),
    caption: [新增 PC 查看 IP 地址],
  ) <fig-18_06>
  新增 PC8 的 IP 地址：192.168.2.13
  
+ 增加路由器并配置好 DHCP 后，查看新增 PC 的 IP 地址如下：
  / PC4: 172.16.3.11
  / PC5: 172.16.3.12
  / PC6: 172.16.4.11
  / PC7: 172.16.4.12

+ 左右电脑相互 ping，均能 ping 通：
  #figure(
    image("..\assets\18_08.png", width: 70%),
    caption: [PC1 ping 其他 PC 结果],
  ) <fig-18_08>
  
= 分析讨论

通过本次实验，我了解了 DHCP 的工作原理，通过上手实践，学会了如何在路由器上配置 DHCP 服务，并在这个过程中理解了 DHCP 服务的应用场景与优势，切身体会到 DHCP 带来的便利。

在实验过程中，若配置好路由器的 DHCP 后 PC 仍没有分配的 IP 地址或路由器左右的 PC 无法 ping 通，则应该检查 PC 的网关/DNS设置是否也改为了 DHCP（默认为静态分配）。若 PC 的 DNS 设置仍然是静态的，这意味着它们可能使用的是不正确或不再有效的 DNS 服务器地址。这会导致 PC 间使用主机名相互 ping 时主机名无法解析为正确的 IP 地址，导致 ping 失败。

