= 实验目的

本实验主要通过软件模拟来深入理解实验网络的物理组网原理，并掌握各设备之间的连接策略及其作用。同时还将学习如何登录路由器，让学生熟悉并掌握路由器操作系统 IOS 的基本操作，为在未来的网络配置与管理工作中运用这些知识与技能提供保证。

= 实验原理

+ IOS 简介：IOS 是思科（Cisco）设备上运行的操作系统，类似于计算机上的操作系统，负责运载网络协议和功能、对产生高速流量的设备进行连接、增加网络安全性、提供网络的可扩展性来简明网络的增长和冗余问题，并确保网络资源连接的可靠性；
+ IOS 常用配置方法：
  + 使用路由器的 CONSOLE 中，用本地 PC 上面的 COM 口连接到路由器上面的控制口；
  + 通过 MODEM 连接 aux 口，用于远程配置；
  + 使用 VTY 线路进行 telnet 连接；
  + 此外也可以通过 TFTP 下载配置文件。
+ 路由器操作模式：
  + setup 安装形式：这种模式可以对路由器进行一些配置，但是一般避免使用。进入此模式之前会有提示出现，可以选择进入或退出。可以使用 `Ctrl+C` 随时退出 setup 模式；
  + 用户模式：进入路由器后，如果不进入 setup 模式则进入了用户模式，可以执行基本操作但不能进行复杂配置；
  + 特权模式：一般用于查看路由器的一些配置、路由信息；
  + 全局配置模式：可以进行一些高级配置，如配置接口和路由；
  + 其他模式：可根据需要进行其他特定模式进行配置，如接口配置或路由配置模式；
  + 各模式的进入与退出方法见下。

#figure(
  table(
    columns: (1fr, 1fr, 1fr, 1fr),
    align: (center, horizon, horizon, horizon),
    table.header(
      [*路由器模式*], [*进入方式*], [*命令提示符*], [*退出方式*],
    ),
    [用户模式],
    [进入路由器],
    [`>`],
    [退出路由器],

    [特权模式\ 
    （特机模式）],
    [`enable`],
    [`#`],
    [`disable`],

    [全局配置模式\ 
    （配置模式）],
    [`configure terminal`],
    [`(config)#`],
    [`exit` / `Ctrl+Z`],

    [端口配置模式\ 
    （接口模式）],
    [`interface ethernet 0`],
    [`(config-if)#`],
    [`exit` / `Ctrl+Z`],

    [子接口配置模式],
    [`interface FastEthernet 0/0.1`],
    [`(config-subif)#`],
    [`exit` / `Ctrl+Z`],

    [线路配置模式],
    [`line console 0`],
    [`(config-line)#`],
    [`exit` / `Ctrl+Z`],

    [路由配置模式],
    [`router rip`],
    [`(config-router)#`],
    [`exit` / `Ctrl+Z`],
  ),
  caption: [路由器常用操作模式],
)

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 安装并使用 Cisco Packet Tracer 虚拟实验环境进行模拟练习；
+ 使用不同方法配置 IOS：
  - 通过路由器的 CONSOLE 口，连接至 PC 的 COM 口进行本地配置；
  - 利用 MODEM 连接到 aux 口进行远程配置；
  - 通过 VTY 线路进行  telnet；
  - 使用 TFTP 下载配置文件；
  - 最常用的方法是通过控制台和 telnet。
+ 学习 IOS 的启动过程：
  - 设备首先加电以后硬件自检；
  - 然后定位并载入 IOS 文件；
  - 最后定位并运行配置文件。完成后设备即可正常工作。
+ 在路由器上配置不同的接口模式：
  / 用户模式: 主要用于查看路由器的状态，执行有限制的命令。\ 
    点击路由器并点击 CLI 可进入用户模式；
  / 特权模式: 用于查看路由器的配置和路由信息。\ 
    在用户模式中输入 `enable` 进入，特权模式中输入 `disable` 切回用户模式；
  / 全局配置模式: 可进行路由器的基本配置。\ 
    在特权模式下输入 `configure terminal`（简写为 `conf t`）进入全局模式；
  / 接口模式: 针对特定接口进行配置。\ 
    在全局模式中使用 `interface ethernet 0`（简写为 `int e0`）即可配置路由器上的特定以太网接口，其中 `ethernet` 指定要进入的以太网类型的接口，`0` 是接口的编号；
  / 子接口配置模式: 配置特定子接口。\ 
    在全局模式下输入 `interface FastEthernet 0/0.1`（简写为 `int f0/0.1`）即可进入该模式；
  / 线路配置模式: 配置特定线路，例如 `console` 线。\ 
    在全局模式下输入 `line console 0` 即可切换到线路配置模式；
  / 路由配置模式: 配置特定的路由协议。\ 
    在特权模式下输入 `route rip` 即可切换到线路配置模式。
+ 在接口模式中，输入 `ip address <IP 地址> <子网掩码>` 可以配置接口的 IP 地址、子网掩码，输入 `no shutdown` 可以打开接口，使用 `end` 可以退回特权模式；
+ 依据连接基本原则，连接路由器、交换机和 PC。
  - 连接基本原则：同种类型设备之间使用交叉线连接，不同类型设备间使用直通线连接；
  - 路由器和 PC 属于 DTE 类型，即数据终端设备，交换机和 HUB 属于 DCE 类型，即数据通信设备；
  - 所以路由器和交换机、PC 和交换机之间用直通线连接，路由器和 PC 之间用交叉线连接。

= 实验现象

+ 进入用户模式：#h(500pt)
  #align(center)[#image("./08_01.png", width: 45%)]

+ 进入特权模式：
  #align(center)[#image("./08_02.png", width: 30%)]

+ 进入全局配置模式：
  #align(center)[#image("./08_03.png", width: 70%)]

+ 进入接口模式：
  #align(center)[#image("./08_04.png", width: 70%)]

+ 进入子接口模式：
  #align(center)[#image("./08_05.png", width: 70%)]

+ 进入线路配置模式：
  #align(center)[#image("./08_06.png", width: 50%)]

+ 进入路由配置模式：
  #align(center)[#image("./08_07.png", width: 50%)]

+ 连接好路由器、交换机和 PC 并配置完成后，线路上绿灯亮起，设备间使用 `ping` 可接收到消息：
  #grid(
    columns: (1fr, 1fr),
    align(center + horizon)[#image("./08_08.png", width: 85%)],
    align(center + horizon)[#image("./08_09.png", width: 100%)],
  )

= 分析讨论

- 网络连接中直通线和交叉线的使用涉及到不同类型设备之间的有效通信。直通线常用于连接不同类型的设备，如连接 PC 和交换机；而交叉线则用于连接相同类型的设备，如 PC 与 PC 或交换机与交换机。通过模拟软件 Packet Tracer，我们可以通过在虚拟环境中操作这些连接方式，以更好地理解它们的实际应用。
- 借助 IOS 系统，我们可以方便且高效地完成 Cisco 设备的配置与管理，它提供的多种模式可以满足不同的配置需求。
- Packet Tracer 提供了网络配置的模拟环境，让我们可以在不影响实际物理硬件与网络的情况下进行实践，降低了学习成本。

