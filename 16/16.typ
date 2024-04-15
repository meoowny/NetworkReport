= 实验目的

= 实验原理

+ ACLs 全称接入控制列表（Access Control Lists），也称为访问列表（Access Lists），俗称为防火墙，有的文档还称之为包过滤。
+ ACLs 通过定义一些规则对网络设备接口上的数据报文进行控制：允许通过或丢弃，从而提高网络可管理性和安全性；
+ IP ACL 分为两种：
  / 标准 IP 访问列表: 编号范围为 1~99、1300~1999，可以根据数据包的源 IP 地址定义规则，进行数据包的过滤；
  / 扩展 IP 访问列表: 编号范围为 100~199、2000~2699，可以根据数据包的源 IP、目的 IP、源端口、目的端口、协议来定义规则，进行数据包的过滤。
+ IP ACL 基于接口进行规则的应用可以分为：入栈应用和出栈应用。

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：Cisco Packet Tracer 虚拟实验环境

= 实验步骤

+ 首先规划网络地址及拓扑图：本次实验采用的网络拓扑及地址规划如下图所示：#h(500pt)
  #figure(
    image("..\assets\16_01.png", width: 80%),
    caption: [网络拓扑图],
  ) <fig-16_01>

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
    / Server0: IP: 172.16.3.33\ 
        Mask: 255.255.255.0\ 
        GateWay: 172.16.3.254
    / PC2: IP: 118.18.4.44\ 
        Mask: 255.255.255.0\ 
        GateWay: 118.18.4.254
  ])
+ 然后使用图形界面配置各 PC 及服务器的地址、网关及掩码；
  #grid(
    columns: (1fr, 1fr),
    align: center + horizon,
    figure(
      image("..\assets\16_41.png", width: 95%),
      caption: [PC0 网关配置],
    ),
    figure(
      image("..\assets\16_42.png", width: 95%),
      caption: [PC0 IP 配置],
    ),
  )

  #figure(
    image("..\assets\16_02.png", width: 80%),
    caption: [ACL 配置前 PC0 的 ping 访问],
  ) <fig-16_02>
  
  #figure(
    image("..\assets\16_03.png", width: 80%),
    caption: [ACL 配置前 PC0 的 HTTP 访问],
  ) <fig-16_03>
  
  #figure(
    image("..\assets\16_04.png", width: 80%),
    caption: [ACL 配置后 PC0 ping 访问失败],
  ) <fig-16_04>
  
  #figure(
    image("..\assets\16_05.png", width: 80%),
    caption: [ACL 配置后 PC0 HTTP 访问仍然成功],
  ) <fig-16_05>
  #figure(
    image("..\assets\16_06.png", width: 80%),
    caption: [ACL 配置后 PC1 ping 访问失败],
  ) <fig-16_06>
  #figure(
    image("..\assets\16_07.png", width: 80%),
    caption: [ACL 配置后 PC2 ping 访问仍然成功],
  ) <fig-16_07>
  #figure(
    image("..\assets\16_08.png", width: 80%),
    caption: [ACL 配置后 PC1 HTTP 访问失败],
  ) <fig-16_08>
  #figure(
    image("..\assets\16_09.png", width: 80%),
    caption: [ACL 配置后 PC2 HTTP 访问仍然成功],
  ) <fig-16_09>

= 实验现象

= 分析讨论

