= 实验目的

= 实验原理

+ RIP（Routing Information Protocols，路由信息协议）：它是应用较早、使用较普遍的 IGP 内部网关协议，适用于小型同类网络，是距离矢量协议；
+ RIP 协议跳数：RIP 协议跳数是作为衡量路径开销用的，RIP 协议里规定最大跳数为 15；
+ RIP 协议版本：RIP 协议有两个版本：RIPv1 和 RIPv2：
  / RIPv1: 属于有类路由协议，不支持 VLSM，以广播形式进行路由信息的更新，更新周期为 30 秒；
  / RIPv2: 属于无类路由协议，支持 VLSM，以组播形式进行路由更新。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：

= 实验步骤

+ 规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #align(center)[#image("./13_01.png", width: 80%)]
  / RA: FA0/0: 192.168.1.254 Mask: 255.255.255.0;\ 
      FA0/1: 10.60.2.254 Mask: 255.255.255.0;\ 
      Seial0/1/0: 202.120.17.18 Mask 255.255.255.0
  / RB: FA0/0: 172.16.3.254 Mask: 255.255.255.0;\ 
      FA0/1: 118.18.4.254 Mask: 255.255.255.0;\ 
      Seial0/1/0: 202.120.17.29 Mask 255.255.255.0
  #grid(
    columns: (1fr, 1fr),
    [
    / PC1: IP: 192.168.1.11\ 
        Mask: 255.255.255.0\ 
        GateWay: 192.168.1.254
    / PC2: IP: 10.60.2.22\ 
        Mask: 255.255.255.0\ 
        GateWay: 10.60.2.254
    ],
    [
    / PC3: IP: 172.16.3.33\ 
        Mask: 255.255.255.0\ 
        GateWay: 172.16.3.254
    / PC4: IP: 118.18.4.44\ 
        Mask: 255.255.255.0\ 
        GateWay: 118.18.4.254
  ])
+ 配置 PC 机、服务器及路由器口 IP 地址：
  + PC 机配置：使用图形界面配置好 PC 的地址、网关及掩码。以 PC1 为例进行如下配置，其他 PC 机操作类似：
    #grid(
      columns: (1fr, 1fr),
      align(center + horizon)[#image("./13_03.png", width: 85%)],
      align(center + horizon)[#image("./13_04.png", width: 100%)],
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
    interface Serial0/1/0
    ip address 202.120.17.18 255.255.255.0
    clock rate 56000
    no shutdown
    ```
    RB 配置操作类似。
+ 配置 RIP 之前检查 PC 间能否相互 ping 通；
+ 在 RA 上配置 RIP：使用命令行配置的相关命令如下：
  ```bash
  router rip
  network 192.168.1.1
  network 10.60.2.22
  network 202.120.17.18
  ```
  RB 配置操作同上。
+ 验证主机之间的互通性。

= 实验现象

= 分析讨论

