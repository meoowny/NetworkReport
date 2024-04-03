= 实验目的

本实验主要通过使用交换机，进行以太网的组网，从而熟悉局域网和交换机的基本原理、配置及测试方法，了解与局域网相关的 IP 配置、`ping` 命令的使用，以及子网规划的基础概念。进而对局域网的实际应用进行充分了解，为后续学习奠定基础。

= 实验原理

+ 局域网：局部地区形成的一个区域网络，其特点是分布地区范围有限，可大可小，大到一栋建筑楼与相邻建筑之间的连接，小到可以是办公室之间的联系。
+ 局域网优点：局域网自身相对其他网络传输速度更快，性能更稳定，框架简易，并且是封闭性，因而被很多机构选择。
+ 局域网组成部分：局域网自身的组成大体由计算机设备、网络连接设备、网络传输介质三大部分构成。
+ 使用的主要命令：
  - `ipconfig`：用于查看本机的 IP 地址；
  - `ping`：用于测试目标网络到本机是否连通。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境
  - Cisco2950 交换机，拥有 24 个默认 100M 百兆端口

= 实验步骤

+ 打开 Cisco Packet Tracer 虚拟实验环境，并按照实验要求，完成实验拓扑结构连接：#h(500pt)
  #align(center)[#image("./12_01.png", width: 38%)]
+ 使用图形界面或命令行配置各 PC 的 IP 及掩码，配置如下：
  - PC0: IP: 192.168.1.20  SubMask: 255.255.255.0
  - PC1: IP: 192.168.1.250  SubMask: 255.255.255.0
  - PC2: IP: 192.168.1.22  SubMask: 255.255.255.0
+ 使用 `ping` 测试各 PC 之间的连通性：
  - 打开 PC0 的命令行窗口，输入 `ping 192.168.1.250` 和 `ping 192.168.1.22`，查看结果；
  - PC1 和 PC2 进行相同操作，查看结果。
+ 两台终端直接连接，相互 `ping` 并查看结果。
  #align(center)[#image("./12_04.png", width: 60%)]

= 实验现象

+ 各 PC 之间可以相互 ping 通，局域网组组网成功：#h(500pt)
  #grid(
    columns: (1fr, 1fr),
    align(center + horizon)[#image("./12_02.png", width: 95%)],
    align(center + horizon)[#image("./12_03.png", width: 95%)],
  )
+ 两台终端连接后，也可以相互 `ping` 通：
  #align(center)[#image("./12_05.png", width: 60%)]

= 分析讨论

在计算机网络中，交换机可以连接多个以太网物理段，隔离冲突域，并对以太网帧进行高速而透明的交换转发，也可以自行学习和维护 MAC 地址信息。它主要可以对 MAC 地址进行转发，每个交换机都有一张 MAC 地址表，该表是计算机自动学习的。与路由器不同的是，路由器寻址是找 IP 地址，而交换机是找 MAC 地址。

在连接方式上，本次实验采用星形拓扑结构，这是一种最常见的局域网连接方式，其特点是以交换机为中心，将计算机和其他设备连接到交换机上，并且同一交换机上的设备间不会相互干扰，能够提高网络的稳定性和效率。同时这种连接方式具有良好的可扩展性，操作简单，易于维护。

还有一种连接方式是环形拓扑结构，这是一种较少使用的局域网连接方式，其特点是将计算机和其他设备连接成一个逆行结构，通过交换机将数据进行转发。这种连接方式适合与小规模的局域网，其连接方式是：将第一台设备通过网线连接到交换机上，第二台设备再通过网线连接到第一台设备上，后续设备依此类推，最后一台设备再通过网线连接到交换机上。

