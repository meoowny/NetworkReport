= 实验目的

= 实验原理

+ OSPF 路由协议是一种典型的链路状态（Link-state）的路由协议，一般一个同一个路由域内。
+ 在这里，路由域是指一个自治系统，即 AS，它是指一组通过统一的路由政策或路由协议互相交换路由信息的网络。在这个 AS 中，所有的 OSPF 路由器都维护一个相同的描述这个 AS 结构的数据库，该数据库中存放的是路由域中相应链路的状态信息，OSPF 路由器正是通过这个数据库计算出其 OSPF 路由表的。
+ 作为一种链路状态的路由协议，OSPF 将链路状态组播数据 LSA（）传送给在某一区域内的所有路由器，这一点与距离矢量路由协议不同。运行距离矢量路由协议的路由器是将部分或全部的路由表传递给与其相邻的路由器。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
#figure(
  image("..\assets\17_01.png", width: 80%),
  caption: [网络拓扑图],
) <fig-17_01>

= 实验现象

#figure(
  image("..\assets\17_02.png", width: 80%),
  caption: [OSPF 配置前 PC1 的访问结果],
) <fig-17_02>

#figure(
  image("..\assets\17_03.png", width: 80%),
  caption: [OSPF 配置前 PC3 的访问结果],
) <fig-17_03>

#figure(
  image("..\assets\17_04.png", width: 80%),
  caption: [仅配置 RA 的 OSPF 后 PC0 的访问结果],
) <fig-17_04>

#figure(
  image("..\assets\17_05.png", width: 80%),
  caption: [仅配置 RA 的 OSPF 后 PC2 的访问结果],
) <fig-17_05>

#figure(
  image("..\assets\17_06.png", width: 80%),
  caption: [RA 和 RB 的 OSPF 均配置完成后 PC0 的访问结果],
) <fig-17_06>

#figure(
  image("..\assets\17_07.png", width: 80%),
  caption: [RA 和 RB 的 OSPF 均配置完成后 PC3 的访问结果],
) <fig-17_07>

#figure(
  image("..\assets\17_08.png", width: 80%),
  caption: [查看 RA 的邻居],
) <fig-17_08>

#figure(
  image("..\assets\17_09.png", width: 80%),
  caption: [查看 RB 的邻居],
) <fig-17_09>

= 分析讨论

