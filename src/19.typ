= 实验目的

通过本次实验，我们将理解和掌握无线网络的基本组成和工作原理，并通过实践来学习配置和管理无线路由器及无线访问接入点，最终运用所学知识尝试研究解决无线网络在实际应用中可能出现的问题。

= 实验原理

+ 无线保真（WiFi，Wireless Fidelity）：是当今使用最广的一种无线网络传输技术。实际上就是把有线网络信号转换成无线信号，供支持其技术的相关电脑、手机、Pad 等接收。
+ WiFi 无线网络在无线局域网范畴内是指“无线相容性认证”，实质上是一种商业认证，同时也是一种无线联网技术，以前通过网络连接电脑，而无线保真则是通过无线电波来连网。
+ WiFi 主要协议：IEEE802.11
  + IEEE802.11 定义了系统应该提供的服务。
  + 属于分配系统的任务分别为：联接（Association），结束联接（Disassociation），分配（Distribution），集成（Integration），再联接（Reassociation）
  + 属于站点的任务分别为：鉴权（Authentication），结束鉴权（Deauthentication），隐私（Privacy），MAC 数据传输（MSDU delivery）
+ WiFi 设备主要组成：
  + 无线网卡；
  + 一台桥接器（AP，Access Point，也叫无线访问接入点）：主要作为无线网络的接入点，在媒体存取控制层 MAC 中扮演无线工作站及有线局域网络的桥梁的角色；
  + 无线路由器：路由器提供了网络接入和数据包路由功能。
+ 性能影响因素：
  + 信号强度和覆盖范围：无线网络的性能受到物理环境、设备质量和距离的影响。
  + 干扰和容量：其他无线设备和网络可能影响 WiFi 网络的性能，尤其是在拥挤的频段。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\19_01.png", width: 80%),
    caption: [网络拓扑图],
  ) <fig-19_01>
  / Router0: F0/0: IP Address: 192.168.1.1 SubMask: 255.255.255.0\ 
             F0/1: IP Address: 192.168.2.1 SubMask: 255.255.255.0
  / LAN: IP 192.168.4.1 SubMask: 255.255.255.0
+ 配置路由器的端口地址：
  - Router0 配置如下：
    ```bash
    enable
    configure terminal
    interface FastEthernet0/0
    ip address 192.168.1.1 255.255.255.0
    no shutdown
    exit
    interface FastEthernet0/1
    ip address 192.168.2.1 255.255.255.0
    no shutdown
    exit
    ```
+ 配置有关 DHCP：
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
+ 配置无线路由器：
  + 将连接类型改为 DHCP；
  + 将 LAN 的 IP 地址配置为 192.168.4.1，子网掩码为 255.255.255.0；
  + 配置无线网络的名称 SSID，设置为 TestWifi，配置无线信道数量为 1，不启用无线网络的认定方法；

+ 为 PC 接入网卡以实现无线连网功能：
  #figure(
    image("..\assets\19_10.png", width: 80%),
    caption: [为 PC 接入无线网卡],
  ) <fig-19_10>
  
+ 配置 AP 接入点：
  + 配置无线网络的名称 SSID，设置为 AP0，配置无线信道数量为 6，不启用无线网线的认定方法；

+ 将 PC 分别连接到 AP 和无线路由器上：
  #figure(
    image("..\assets\19_11.png", width: 80%),
    caption: [将 PC 连入无线网络],
  ) <fig-19_11>

+ 观测各个 PC 的连通情况；

+ 为无线路由器配置密码并进行测试：
  + 分别为无线路由器和 PC 配置 WPA2-PSK 无线保护协议以及相应的密码，观察实验现象。
    #figure(
      image("..\assets\19_21.png", width: 80%),
      caption: [为无线路由器配置密码],
    ) <fig-19_21>
    #figure(
      image("..\assets\19_22.png", width: 80%),
      caption: [将 PC 连入无线网络],
    ) <fig-19_22>

= 实验现象

+ 配置好无线路由器和接入点，并将各 PC 连接到 AP 和无线路由器上后，各 PC 之间的连通情况如下：
  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\19_02.png", width: 80%),
      caption: [PC4 连通测试结果],
    ),
    figure(
      image("..\assets\19_03.png", width: 80%),
      caption: [Laptop0 连通测试结果],
    ),
    figure(
      image("..\assets\19_04.png", width: 80%),
      caption: [PC1 连通测试结果],
    ),
    figure(
      image("..\assets\19_05.png", width: 80%),
      caption: [PC2 连通测试结果],
    ),
  )
  无线路由器下的 PC 可正常 ping 通外界 PC，外界 PC 无法 ping 通无线路由器下的 PC；外界 PC 之间可以互相 ping 通。
+ 当无线路由器配置好 WPA2-PSK 但 PC4 和 PC6 未配置好时，无线网络失去连接；在 PC4 和 PC6 也配置好后，无线网络重新连接。
  #figure(
    image("..\assets\19_30.png", width: 60%),
    caption: [配置好无线路由器和两台 PC 的 WPA2-PSK 的网络连接情况],
  ) <fig-19_30>

= 分析讨论

+ 如果再接入一台路由器，应该如何配置？
  + 选择一个未被使用的 IP 地址段分配给新增路由器以避免与现有网络冲突，可以使用 192.168.5.x 或其他未被使用的地址段；
  + 将两个路由器通过串口线连接；
  + 采用 OSPF 路由协议配置动态路由，分别配置两台路由器的 OSPF 路由表来构造数据传输链路。

+ 如果改为静态 IP 地址如何处理？
  + 首先需要规划 IP 地址，确定每个设备的静态 IP 地址，确保这些地址在各自的子网内且不与其他设备冲突；
  + 然后配置路由器，确保 Router0 的两个接口保持默认的静态 IP 地址配置，将这些地址作为连接到相应交换机的设备的默认网关；
  + 接下来手动配置 PC 和笔记本电脑的 IP 地址、子网掩码、默认网关及 DNS 等设置，确保符合规划的 IP 地址；
  + 配置无线路由器和接入点的 IP 地址，确保无线路由器的 LAN 设置与主路由器 Router0 在同一网络段或确保路由器间可以路由到该子网，接入点的地址与与接入点子网内其他设备不冲突；
  + 最后验证网络配置，使用 ping 指令在每个设备上测试各设备之间的连通情况。

+ 为什么无线路由器子网外的设备无法 ping 通子网内的设备？

  因为连接到无线路由器的设备位于 192.168.4.0 子网，而 DHCP 服务器配置的是 192.168.2.0 子网，不会为连接到无线路由器的设备提供 IP 地址，因此连接到无线路由器的设备无法被正确路由，外网设备无法 ping 通内网设备。这为子网内的设备提供了一定的安全保障，避免子网内的设备暴露在公共网络中，确保子网内的设备免受外部的攻击。

