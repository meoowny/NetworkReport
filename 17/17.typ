= 实验目的

通过本次实验，我们将理解并掌握 OSPF（开放最短路径优先）的动态路由配置方法，并在实践中熟悉 OSPF 的工作原理及其在自治系统内部的应用。最终通过配置 OSPF 实现网络中的路由之间的动态路由交换，提高网络的可靠性和数据传输的效率。

= 实验原理

+ OSPF 路由协议是一种典型的链路状态（Link-state）的路由协议，一般用于同一个路由域内。
+ 在这里，路由域是指一个自治系统（Autonomous System, AS），它是指一组通过统一的路由政策或路由协议互相交换路由信息的网络。在这个 AS 中，所有的 OSPF 路由器都维护一个相同的描述这个 AS 结构的数据库，该数据库中存放的是路由域中相应链路的状态信息，OSPF 路由器正是通过这个数据库计算出其 OSPF 路由表的。
+ 作为一种链路状态的路由协议，OSPF 将链路状态组播数据 LSA（Link State Advertisement）传送给在某一区域内的所有路由器，这一点与距离矢量路由协议不同。运行距离矢量路由协议的路由器是将部分或全部的路由表传递给与其相邻的路由器。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\17_01.png", width: 80%),
    caption: [网络拓扑图],
  ) <fig-17_01>
  / RA: FA0/0: 192.168.1.254 Mask: 255.255.255.0\ 
        FA0/1: 10.60.2.254 Mask: 255.255.255.0\ 
        Serial0/0/0: 202.120.17.18 Mask: 255.255.255.0
  / RB: FA0/0: 172.16.3.254 Mask: 255.255.255.0\ 
        FA0/1: 118.18.4.254 Mask: 255.255.255.0\ 
        Serial0/0/0: 202.120.17.29 Mask: 255.255.255.0
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

+ 按上述配置对 PC 的地址、网关和掩码进行配置；
+ 按上述配置对路由器的端口地址进行配置；
+ 配置路由器的串口端口地址：
  - RA 配置如下：
    ```bash
    interface Serial0/0/0
    ip address 202.120.17.18 255.255.255.0
    clock rate 56000
    ```
  - RB 配置如下：
    ```bash
    interface Serial0/0/0
    ip address 202.120.17.29 255.255.255.0
    clock rate 56000
    ```
+ 配置 OSPF 之前检查 PC 间能否相互 ping 通；
+ 使用如下命令配置 RA 的 OSPF 路由表：
  ```bash
  router ospf 1
  network 192.168.1.0 0.0.0.255 area 0
  network 10.60.2.0 0.0.0.255 area 0
  network 202.120.17.0 0.0.0.255 area 0
  ```
+ 再次验证不同 PC 之间的互通性；
+ 使用如下命令配置 RB 的 OSPF 路由表：
  ```bash
  router ospf 1
  network 172.16.3.0 0.0.0.255 area 0
  network 118.18.4.0 0.0.0.255 area 0
  network 202.120.17.0 0.0.0.255 area 0
  ```
+ 再次验证不同 PC 之间的互通性；
+ 使用 `sh ip ospf neighbor` 查看路由器的邻居。

= 实验现象

+ 配置 OSPF 之前，任何两个 PC 之间都不能相互 ping 通：

  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\17_02.png", width: 95%),
      caption: [OSPF 配置前 PC1 的访问结果],
    ),
    figure(
      image("..\assets\17_03.png", width: 95%),
      caption: [OSPF 配置前 PC3 的访问结果],
    )
  )

+ 配置好 RA 后几台计算机互相 ping，连接 RA 的两台 PC 之间可以相互 ping 通：

  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\17_04.png", width: 95%),
      caption: [仅配置 RA 的 OSPF 后 PC0 的访问结果],
    ),
    figure(
      image("..\assets\17_05.png", width: 95%),
      caption: [仅配置 RA 的 OSPF 后 PC2 的访问结果],
    )
  )

+ 路由器 RA 和 RB 均配置好 OSPF 后，几台计算机相互 ping，均可以 ping 通：
  
  #grid(
    columns: (1fr, 1fr),
    align: (center + horizon),
    figure(
      image("..\assets\17_06.png", width: 95%),
      caption: [RA 和 RB 的 OSPF 均配置完成后 PC0 的访问结果],
    ),
    figure(
      image("..\assets\17_07.png", width: 95%),
      caption: [RA 和 RB 的 OSPF 均配置完成后 PC3 的访问结果],
    )
  )

+ 查看路由器的网络邻居，结果如下：
  
  #figure(
    image("..\assets\17_08.png", width: 80%),
    caption: [查看 RA 的邻居],
  ) <fig-17_08>
  
  #figure(
    image("..\assets\17_09.png", width: 80%),
    caption: [查看 RB 的邻居],
  ) <fig-17_09>
  
= 分析讨论

+ 配置 OSPF 之前 PC0 和 PC1 无法相互 ping 通：

  在配置 OSPF 之前，PC0 与 PC1 虽然连接到同一个路由器 RA 上，但它们被配置到了不同的子网中，因此即使它们连接到同一个物理路由器上，在没有配置跨子网路由的情况下，它们也无法直接通信。

  在经过实验中的 OSPF 配置后，即允许跨子网进行通信。

