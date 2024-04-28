= 实验目的

通过本次实验，我们将了解 IP 电话的基本原理，并学习如何配置并使用 IP 电话进行语音通话。通过具体实践认识 IP 电话的特点。

= 实验原理

+ IP 电话：俗称网络电话，又称为 VoIP 电话，是通过互联网直接拨打对方的固定电话和手机等。宏观上讲可以分为软件电话和硬件电话。
+ 根据国际上公认的分类方式，VoIP 有四种实现方式：Phone-Phone、Phone-PC、PC-Phone、PC-PC；
+ IP 电话基本原理：网络电话通过把语音信号经过数字化处理、压缩编码打包、透过网络传输、解压、把数字信号还原成声音，让通话对方听到。其基本过程是：
  + 声电转换：通过压电陶瓷等类似装置将声波变换为电信号；
  + 量化采样：将模拟电信号按照某种采样方法转换成数字信号；
  + 打包：将一定最长的数字化之后的语音信号组合为一帧，随便按照国际电联（ITU-T）的标准，将这些话音帧封装到一个实时传输协议（RTP）报文中，并进一步封装到 UDP 报文和 IP 报文中；
  + 传输：IP 报文在 IP 网络由源端传递到目的端；
+ 完整大规模商用运营的 IP 电话系统的主要技术组成：
  + 寻址话音编解码；
  + 回声消除和回声抵制；
  + 传输 IP 报文时延控制功能；
  + 去抖动 IP 报文（de-jitter）功能。
+ IP 电话协议：包括 H323 和 SIP。其中 H323 已经很少使用，SIP 协议应用较为广泛，类似于 HTTP 协议，负责电话的建立和释放。而真正的语音及视频数据通过 RTP 协议传输。
+ Cisco IP 电话主要配置步骤：
  + 路由器 2811 配置 CME（Call Manager Express）
  + 使用 Cisco 7960 电话；
  + 设置拨号位长等；
  + 连接 Cisco IP 电话；

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\21_00.png", width: 80%),
    caption: [网络拓扑图],
  ) <fig-21_00>
+ 配置路由器接口 IP 地址：
  ```bash
  enable
  configure terminal
  interface FastEthernet0/0
  ip address 192.168.10.1 255.255.255.0
  no shutdown
  ```
+ 配置路由器的 DHCP 服务：
  ```bash
  ip dhcp pool VOICE
  network 192.168.10.0 255.255.255.0
  default-router 192.168.10.1
  option 150 ip 192.168.10.1
  ```
+ 配置路由器器的电话服务（CME）：
  ```bash
  telephony-service
  max-dn 5
  max-ephones 5
  ip source-address 192.168.10.1 port 2000
  auto assign 4 to 6
  auto assign 1 to 5
  ```
+ 配置交换机的 VLAN：
  ```bash
  interface range fa0/1-5
  switchport mode access
  switchport voice vlan 1
  ```
+ 连接各电话并配置路由器中 IP 电话的号码：
  - 以 IP Phone0 为例，首先确保当前除 IP Phone0 外无其他电话或 PC 接入交换机，连接好 IP Phone0 和交换机后，在路由器中进行如下配置：
    ```bash
    ephone-dn 1
    number 54001
    ```
  - 54001 电话就绪后，再连接一个 Cisco7960，在路由器中进行如下配置：
    ```bash
    ephone-dn 2
    number 54002
    ```
+ 检测两台电话拨号回铃情况；
+ 再向网络中连接一台笔记本，按上述步骤为笔记本配置 IP 电话号码；
+ 检测笔记本与 IP Phone 的呼叫情况。
+ 类似地，加入一个 PC 并配置，检测呼叫情况。

= 实验现象

+ 配置完成后，两台电话可以正常拨号回铃：#h(500pt)
  #grid(
    columns: (1fr, 1fr),
    figure(
      image("..\assets\21_01.png", width: 100%),
      caption: [IP Phone0 拨出号码],
    ),
    figure(
      image("..\assets\21_02.png", width: 100%),
      caption: [IP Phone1 收到呼叫],
    )
  )

+ 接通后两台电话可以正常互通：
  #figure(
    image("..\assets\21_03.png", width: 90%),
    caption: [电话成功互通],
  ) <fig-21_03>

+ 笔记本 IP 电话号码配置成功，号码为 54003，可与 IP Phone0 正常互通：
  #figure(
    image("..\assets\21_04.png", width: 40%),
    caption: [Laptop 配置成功],
  ) <fig-21_04>
  #figure(
    image("..\assets\21_05.png", width: 80%),
    caption: [Laptop 与 IP Phone0 成功互通],
  ) <fig-21_05>
+ PC 配置成功，各 IP 电话可正常互通：
  #figure(
    image("..\assets\21_06.png", width: 80%),
    caption: [PC 配置成功],
  ) <fig-21_06>

= 分析讨论

通过本次实验，我理解了 IP 电话的基本原理，并通过实际操作，成功配置了几台 IP 电话并使之成功互通，熟悉了 IP 电话的配置过程。并在这个过程中，了解了 IP 电话的特点，它可以利用现有的互联网基础设施，在任何具有 IP 网络接入的地点进行通信，实现了语音与数据的融合。

