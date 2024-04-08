= 实验目的

= 实验原理

+ 网络地址转换（Network Address Translation, NAT）优势：
  + NAT 可以完美解决 IP 地址不足的问题；
  + 能够有效避免来自网络外部的攻击，隐藏并保护网络内部的计算机。
  + 基于以上优势，NAT 被广泛应用于各种类型 Internet 接入方式和各种类型的网络中。
+ 默认情况下，内部 IP 地址是无法被路由到外网的，内部主机要与外部网络或 Internet 通信，IP 包到达 NAT 路由器时，IP 包头的源地址被替换成一个合法的外网 IP，并在 NAT 转换表中保存这条记录。
+ 当外部主机发送一个应答到内网时，NAT 路由器收到后，查看当前 NAT 转换表，用内网地址替换掉这个外网地址。
+ NAT 将网络划分为内部网络和外部网络两部分，局域网主机利用 NAT 访问网络时，是将局域网内部的本地地址转换为全局地址（外部网络或互联网合法的 IP 地址）后转发数据包。
+ NAT 的类型：NAT（网络地址转换）和 NAPT（网络端口地址转换 IP 地址对应一个全局地址）
  / 静态 NAT: 实现内部地址与外部地址一对一的映射。现实中一般都用于服务器；
  / 动态 NAT: 定义一个地址池，自动映射，也是一对多的。现实中用得比较少；
  / NAPT: 使用不同的端口来映射多个内网 IP 地址到一个指定的外网 IP 地址，多对一。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #align(center)[#image("./14_01.png", width: 80%)]
  / RA: FA0/0: 192.168.1.254 Mask: 255.255.255.0;\ 
      FA0/1: 10.60.2.254 Mask: 255.255.255.0;\ 
      Seial0/0/0: 202.120.17.18 Mask 255.255.255.0
  / RB: FA0/0: 172.16.3.254 Mask: 255.255.255.0;\ 
      FA0/1: 118.18.4.254 Mask: 255.255.255.0;\ 
      Seial0/0/0: 202.120.17.29 Mask 255.255.255.0
  #grid(
    columns: (1fr, 1fr),
    [
    / PC0: IP: 192.168.1.11\ 
        Mask: 255.255.255.0\ 
        GateWay: 192.168.1.254
    / PC1: IP: 10.60.2.22\ 
        Mask: 255.255.255.0\ 
        GateWay: 10.60.2.254
    ],
    [
    / PC2: IP: 172.16.3.33\ 
        Mask: 255.255.255.0\ 
        GateWay: 172.16.3.254
    / PC3: IP: 118.18.4.44\ 
        Mask: 255.255.255.0\ 
        GateWay: 118.18.4.254
  ])
+ 配置 PC 机、服务器及路由器口 IP 地址：
  + PC 机配置：使用图形界面配置好 PC 的地址、网关及掩码。以 PC0 为例进行如下配置，其他 PC 机操作类似：
    #grid(
      columns: (1fr, 1fr),
      align(center + horizon)[#image("./14_02.png", width: 85%)],
      align(center + horizon)[#image("./14_03.png", width: 100%)],
    )
  + 配置路由器的端口地址：这里使用命令行配置路由器的端口地址。以路由器 RA 为例，相关命令如下：
    ```bash
    configure terminal
    interface FastEthernet0/0
    ip address 192.168.1.254 255.255.255.0
    no shutdown
    interface FastEthernet0/1
    ip address 10.60.2.254 255.255.255.0
    no shutdown
    interface Serial0/0/0
    ip address 202.120.17.18 255.255.255.0
    clock rate 56000
    no shutdown
    ```
    RB 配置操作类似。
+ 在各路由器上配置静态路由协议，让 PC 间能相互 ping 通：
  + 在 RA 上使用命令行在全局配置模型下的配置命令如下：
    ```bash
    ip route 218.100.3.0 255.255.255.0 serial0/0/0
    ip route 118.18.4.0 255.255.255.0 serial0/0/0
    ```
  + 类似地，RB 配置指令如下：
    ```bash
    ip route 10.60.2.0 255.255.255.0 serial0/0/0
    ip route 210.120.1.0 255.255.255.0 serial0/0/0
    ```
+ 配置路由器的 NAT 出入口：
  + 对于 RA 和 RB，在全局配置模型下使用的相关配置命令如下：
    ```bash
    interface FastEthernet0/0
    ip nat inside
    interface Serial0/0/0
    ip nat outside
    ```
+ 配置路由器的 NAT 转换：
+ 观测 NAT 配置情况：

= 实验现象

= 分析讨论

