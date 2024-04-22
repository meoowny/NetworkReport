= 实验目的

通过本次实验，我们将理解并掌握 OSPF（开放最短路径优先）的动态路由配置方法，并在实践中熟悉 OSPF 的工作原理及其在自治系统内部的应用。最终通过配置 OSPF 实现网络中的路由之间的动态路由交换，提高网络的可靠性和数据传输的效率。

= 实验原理

+ OSPF 路由协议是一种典型的链路状态（Link-state）的路由协议，一般用于同一个路由域内。
+ 在这里，路由域是指一个自治系统（Autonomous System, AS），它是指一组通过统一的路由政策或路由协议互相交换路由信息的网络。在这个 AS 中，所有的 OSPF 路由器都维护一个相同的描述这个 AS 结构的数据库，该数据库中存放的是路由域中相应链路的状态信息，OSPF 路由器正是通过这个数据库计算出其 OSPF 路由表的。
+ 作为一种链路状态的路由协议，OSPF 将链路状态组播数据 LSA（Link State Advertisement）传送给在某一区域内的所有路由器，这一点与距离矢量路由（RIP）协议不同。运行距离矢量路由协议的路由器是将部分或全部的路由表传递给与其相邻的路由器。

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

+ 配置 OSPF 之前，只有同一路由器下的 PC 之间可相互 ping 通：

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

+ 配置好 RA 后几台计算机互相 ping，仍然只有同一路由器下的 PC 之间可相互 ping 通：

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

通过本次实验，我了解了 OSPF 协议在动态路由中的作用和优势，掌握了 OSPF 路由的配置方法。

在未配置网络中所有 OSPF 前，由于缺乏足够的路由信息，连接不同路由器的 PC 之间无法正确传递数据包，因此无法 ping 通，而同一路由器下的 PC 能够相互通信。当两个路由器都配置好 OSPF 后，两个路由器之间交换路由信息之后，整个网络中的所有设备才可以相互通信。OSPF 的引入实现了动态路由的自动配置，为网络中的设备提供了更加便捷和自适应的选择机制。

相较于 RIP 协议，OSPF 作为一种基于链路状态的路由协议，只有发生链路状态更新时才会进行路由更新维护，且采用了区域划分的机制按区域进行链路状态的同步，减少了信息交互量，使得路由收敛速度。这让 OSPF 具有更高的性能，并且通过区分骨干区域和非骨干区域，可以有效避免路由环路问题。相较于 RIP，这些特性让 OSPF 更适用于大型复杂网络。

