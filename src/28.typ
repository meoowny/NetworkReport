// 组网技术

= 实验目的

本次实验将使用单臂路由技术完成一个简单的组网设计。设计需求如下：某公司有三个部门，每个部门 20 人，每人一台 PC。每个部门各自在同一网段，使部门内机器彼此可以互相访问，不同部门之间平时网络相互隔离，但部门人员混在一起办公。

此外还需要解决一个问题：年末时公司三个部门之间网络需保持互通，以进行网络互通“联欢”，需要给出网络解决方案。

= 实验原理

+ 单臂路由（router-on-a-stick）：指在路由器的一个接口上通过配置子掊（或“逻辑接口”，并不存在真正物理接口）的方式，实现原来相互隔离的不同 VLAN 之间的互联互通。配置中过程中交换机连接主机的端口为 access 链路，连接路由器的端口为 trunk 链路。
+ 单臂路由的应用：VLAN 可以有效分割局域网，实现各网络区域之间的访问控制。但现实中往往需要配置某些 VLAN 之间的访问控制。而单臂路由就可以实现跨越 VLAN 的访问控制。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

#pagebreak()

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\28_01.png", width: 80%),
    caption: [网络拓扑图],
  ) <fig-28_01>
  / Router0: \ 
            f0/0.1 192.168.1.254 MASK 255.255.255.0 VLAN10\ 
            f0/0.2 192.168.2.254 MASK 255.255.255.0 VLAN20\ 
            f0/0.3 192.168.3.254 MASK 255.255.255.0 VLAN30
  / Switch1: VLAN10
  / Switch2: VLAN20
  / Switch3: VLAN30
  / PC0 至 PC2: 192.168.1.1 至 192.168.1.3 *Mask* 255.255.255.0 *Gateway* 192.168.1.254
  / PC3 至 PC5: 192.168.2.1 至 192.168.2.3 *Mask* 255.255.255.0 *Gateway* 192.168.2.254
  / PC6 至 PC8: 192.168.3.1 至 192.168.3.3 *Mask* 255.255.255.0 *Gateway* 192.168.3.254
  说明：为确保交换机接口足够接入二十部 PC，各部门 PC 均连接至部门专属交换机：部门一的 PC 连接至 Switch1，部门二的 PC 连接至 Switch2，部门三的 PC 连接至 Switch3。为方便展示，这里每个部门仅配置三部 PC。
+ 按上述配置对各 PC 的地址、网关及掩码进行配置；
+ 配置 Switch0 与 Router0 的 VLAN；
  + 为 Router0 创建 VLAN：
    ```bash
    enable
    vlan database
    vlan 10
    vlan 20
    vlan 30
    exit
    ```
    //#figure(
    //  image("..\assets\28_02.png", width: 80%),
    //  caption: [Router0 新增 VLAN],
    //) <fig-28_02>
  + 配置 Switch0，为各端口分别配置 VLAN：
    #figure(
      image("..\assets\28_03.png", width: 75%),
      caption: [Switch0 新增 VLAN],
    ) <fig-28_03>
    ```bash
    interface f0/1
    switchport mode trunk
    exit

    interface f0/2
    switchport access vlan 10
    exit

    interface f0/3
    switchport access vlan 20
    exit

    interface f0/4
    switchport access vlan 30
    exit
    ```
    #figure(
      image("..\assets\28_04.png", width: 80%),
      caption: [VLAN 配置结果],
    ) <fig-28_04>
+ 测试设备连通性并分析：
  - 在 PC3 命令提示符中输入 `ping 192.168.2.3` 和 `ping 192.168.1.2` 分别测试与同部门 PC 与 不同部门 PC 间的连通性；
  - 在其他 PC 进行类似操作。
+ 当不同部门间需要网络互通时，为 Router0 配置单臂路由：
  ```bash
  enable
  configure terminal
  interface f0/0.1
  encapsulation dot1Q 10
  ip address 192.168.1.254 255.255.255.0
  exit

  interface f0/0.2
  encapsulation dot1Q 20
  ip address 192.168.2.254 255.255.255.0
  exit

  interface f0/0.3
  encapsulation dot1Q 30
  ip address 192.168.3.254 255.255.255.0
  exit
  ```
+ 测试设备连通性并分析：
  - 在 PC3 命令提示符中再次输入 `ping 192.168.2.3` 和 `ping 192.168.1.2` 分别测试与同部门 PC 与 不同部门 PC 间的连通性；
  - 在其他 PC 进行类似操作。

#pagebreak()

= 实验现象

+ 配置单臂路由前的连通性测试结果：#h(500pt)
  配置前，相同部门的 PC 间可以互相 ping 通，但不同部门的 PC 间不能 ping 通。

  #figure(
    image("..\assets\28_10.png", width: 80%),
    caption: [单臂路由配置前连通性测试结果],
  ) <fig-28_10>

+ 配置单臂路由前的连通性测试结果：
  配置前，相同部门的 PC 间可以互相 ping 通，不同部门的 PC 间也可以相互 ping 通。

  #figure(
    image("..\assets\28_11.png", width: 80%),
    caption: [单臂路由配置后连通性测试结果],
  ) <fig-28_11>

= 分析讨论

本次实验中，我们使用单臂路由技术完成一次简单的组网设计任务，实现了公司对于部门网络隔离及“联欢”时网络通信的需求。通过实践操作，熟悉了 VLAN 配置及借助单臂路由进行跨 VLAN 通信的相关配置，更加理解 VLAN 在实际应用中的用途与特点。

在平时工作时，仅配置 VLAN 而不配置单臂路由，使用 VLAN 在物理网络中创建逻辑隔离，使得不同部门间网络相互隔离。当需要“联欢”时，就为 Router0 配置单臂路由，引入 VLAN 间路由使得不同部门间可以相互通信。

配置好 VLAN 后配置单臂路由前，由于各部门设备不在同一网段且属于不同的 VLAN，它们之间的通信是隔离开的，因此无法 ping 通；而部门内部的设备在同一网段内，可以通过 Switch1 等部门专属路由器完成通信。

部门“联欢”互通后，单臂路由配置完成，通过 Router0 的单臂路由可以实现 VLAN 间的路由。单臂路由通过在路由器上配置子接口，每个子接口对应一个 VLAN 网关，从而实现了不同 VLAN 间的通信，数据通过 Router0 进行转发，使得不同部门间的设备可以通过 Router0 进行不同 VLAN 间设备的通信。因此这个时候不同部门间的设备可以相互通信。

除了单臂路由外，还可以通过三层交换技术实现 VLAN 间通信。它通过在交换机中嵌入路由功能，实现了数据包的高速转发和路由选择，提高了网络的性能和稳定性，也使得网络管理更加灵活高效。

