= 实验目的

学习并理解蓝牙技术的原理，了解其在移动通信终端之间以及设备与 Internet 之间的通信应用，并实践电脑与手机之间使用蓝牙进行文件传输的操作。

= 实验原理

- 蓝牙技术：实际上是一种短距离无线通信技术，利用“蓝牙”技术，能够有效地简化掌上电脑、笔记本电脑和移动电话手机等移动通信终端设备之间的通信，也能够成功地简化以上这些设备与 Internet 之间的通信，从而使这些现代通信设备与 Internet 之间的数据传输变得更加迅速高效，为无线通信拓宽道路。
  - 通俗而言，蓝牙技术可以使一些现代便携的移动通信设备和电脑设备可以不借助电缆就能联网，并且能够实现无线上 Internet。
- 蓝牙技术原理：蓝牙技术规定每一对设备之间进行蓝牙通讯时，必须一个为主角色，另一个为从角色，才能进行通信。通信时，必须由方端进行查找，发起配对，建链成功后，双方即可收发数据。
  - 理论上，一个蓝牙主端设备可以在两个角色间切换，平时工作在从模式，等待其他主设备发起呼叫。一个蓝牙设备以主模式发起呼叫时，需要知道对方的蓝牙地址、配对密码等信息。配对完成后，可直接发起呼叫。

= 实验设备

- 实验硬件：个人笔记本电脑与手机
- 操作系统：Windows11

#pagebreak()

= 实验步骤

+ 打开电脑与手机的蓝牙功能； #h(500pt)
+ 在电脑上向手机发起连接请求，或在手机上连接到电脑；
  #grid(
    columns: (1fr, 1fr),
    align(center)[#image("./11_02.png", width: 55%)],
    align(center)[#image("./11_06.jpg", width: 45%)],
  )
+ 打开“设置>蓝牙和其他设备>设备>通过蓝牙发送或接收文件>发送文件”，选择电脑本地的文件发送给手机；
  #grid(
    columns: (1fr, 1fr),
    align(center)[#image("./11_11.png", width: 95%)],
    align(center)[#image("./11_12.png", width: 95%)],
  )

= 实验现象

+ 从电脑向手机发送文件，手机可以成功接收文件：#h(500pt)
  #align(center)[#image("./11_17.jpg", width: 35%)]
  #grid(
    columns: (1fr, 1fr),
    align(center)[#image("./11_13.png", width: 95%)],
    align(center)[#image("./11_14.png", width: 95%)],
  )
+ 从手机向电脑发送文件，当电脑处于接收状态时，才能成功收到文件，否则手机将会发送失败：
  #grid(
    columns: (1fr, 1fr),
    align(center)[#image("./11_03.png", width: 95%)],
    align(center)[#image("./11_05.png", width: 95%)],
  )
  #align(center)[#image("./11_04.png", width: 55%)]

= 分析讨论

通过本次实验，我们体验了蓝牙技术的便捷。借助蓝牙技术，一些便携移动设备和计算机设备能够不需要电缆就能连接到互联网，并无线接入互联网。

在使用蓝牙将文件从手机传至电脑时，大致经历了如下过程：
+ 手机向电脑发起呼叫，建立蓝牙连接；
+ 手机对文件进行编码与封装；
+ 手机的蓝牙模块发送信号，将文件信号发送至周围；
+ 电脑的蓝牙模块接收到乌兹别克并经过处理后转交上层的其他协议处理；
+ 上层协议通过一系列操作将收到的内容恢复为原文件。
