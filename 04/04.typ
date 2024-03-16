//#import "/template.typ": report
//
//#show: report.with(title: "lab04-基本网络测试工具及应用工具实验", date: "2024 年 3 月 4 日")

= 实验目的

操作系统内置了一些非常有用的软件网络测试工具，如果使用得当，并點撥一定的测试技巧，完全可以满足一般需求。

本实验将会熟悉这些网络测试工具的基本使用，对它们有简单的了解。

这些工具虽然不能称之为专业测试工具，但可以简单判断网络具体的实际状况。通过改写，甚至可以制作出许多黑客工具。

= 实验原理

+ `ping` 命令是 Windows9X/NT 中集成的一个专用于 TCP/IP 协议的测试工具，`ping` 命令用于查看网络上的主机是否在工作，它通过向该主机发送 ICMP ECHO_REQUEST 包进行测试来达成目的。一般而言，凡是应用 TCP/IP 协议的局域或广域网络，当客户端与客户端之间无法正常进行访问或者网络工作出现各种不稳定状况时，可以先用 `ping` 命令测试一下网络的通信是否正常，多数时候可以一次奏效；
+ `ipconfig [/all][/batch file][/renew all][/release all][/renew n][/release n]`
  - `all` 显示与TCP/IP协议相关的所有细节信息，其中包括测试的主机名、IP地址、子网掩码、节点类型、是否启用IP路由、网卡的物理地址、默认网关等；
  - `batch file` 将测试的结果存入指定的“file”文件名中，以便于逐项查看，如果省略file文件名，则系统会把这测试的结果保存在系统的“winipcfg.out”文件中；
  - `renew all` 更新全部适配器的通信配置情况，所有测试重新开始；
  - `release all` 释放全部适配器的通信配置情况；
  - `renew n` 更新第n号适配器的通信配置情况，所有测试重新开始；
  - `release n` 释放第n号适配器的通信配置情况。
+ `nbtstat [ [-a RemoteName] [-A IP address] [-c] [-n] [-r] [-R] [-RR] [-s] [-S] [interval] ]` 命令用于查看当前基于 NETBIOS 的 TCP/IP 连接状态，通过该工具可以获得远程或本地机器的组名和机器名：
  - `-a Remotename` 说明使用远程计算机的名称列出其名称表，此参数可以通过远程计算机的 NetBios 名来查看他的当前状态；
  - `-A IP address` 说明使用远程计算机的 IP 地址并列出名称表，这个和 `-a` 不同的是就是这个只能使用 IP；
  - `-c` 列出远程计算机的NetBIOS 名称的缓存和每个名称的 IP 地址 这个参数就是用来列出在你的 `NetBIOS` 里缓存的你连接过的计算机的IP；
  - `-n` 列出本地机的 NetBIOS 名称。
+ `tracert [-d] [-h maximum_hops] [-j host-list] [-w timeout] target_name` （跟踪路由）命令是路由跟踪实用程序，用于确定 IP 数据报访问目标所采取的路径：
  - `-d` 指定不将 IP 地址解析到主机名称；
  - `-h maximum_hops` 指定跃点数以跟踪到称为target_name 的主机的路由；
  - `-j host-list` 指定 Tracert 实用程序数据包所采用路径中的路由器接口列表；
  - `-w timeout` 等待 timeout 为每次回复所指定的毫秒数；
  - `target_name` 目标主机的名称或 IP 地址。
+ `net` 命令是一个命令行命令，`net` 命令有很多函数用于实用和核查计算机之间的 NetBIOS 连接，可以查看管理网络环境、服务、用户、登陆等信息内容；
+ `route [-f] [-p] [Command [Destination] [mask Netmask] [Gateway] [metric Metric]] [if Interface]]` 可以在本地 IP 路由表中显示和修改条目：
  - `-f` 除所有不是主路由（网掩码为 255.255.255.255 的路由）、环回网络路由（目标为 127.0.0.0，网掩码为 255.255.255.0 的路由）或多播路由（目标为 224.0.0.0，网掩码为 240.0.0.0 的路由）的条目的路由表。如果它与命令之一（例如 `add`、`change` 或 `delete`）结合使用，表会在运行命令之前清除；
  - `-p` 与 `add` 命令共同使用时，指定路由被添加到注册表并在启动 TCP/IP 协议的时候初始化 IP 路由表。默认情况下，启动 TCP/IP 协议时不会保存添加的路由。与 `print` 命令一起使用时，则显示永久路由列表。所有其它的命令都忽略此参数。

= 实验设备

- 实验硬件：济事楼 330 机房电脑与个人笔记本电脑

= 实验步骤

使用 `Win+R` 打开 cmd 窗口，将上述命令逐个输入运行，观察实验现象并记录。实验现象如下。

#pagebreak()

= 实验现象

1. `ping` 实验部分截图：
  
  #align(center)[#image("./04_01.png", width: 90%)]
  #align(center)[#image("./04_02.png", width: 90%)]

#pagebreak()

2. `ipconfig` 部分实验截图：

  #align(center)[#image("./04_03.png", width: 85%)]

3. `nbtstat` 部分实验截图：

  #align(center)[#image("./04_04.png", width: 85%)]

4. `tracert` 部分实验截图：

  #align(center)[#image("./04_05.png", width: 90%)]

5. `net` 部分实验截图：

  #align(center)[#image("./04_06.png", width: 90%)]

6. `net` 部分实验截图：

  #align(center)[#image("./04_07.png", width: 90%)]

= 分析讨论

通过本次实验，我们掌握了基本网络测试工具的简单使用，并在使用过程中了解到一些网络知识，如 ICMP 是 TCP/IP 协议族的一个子协议，用于在 IP 主机、路由器之间传递控制消息。控制消息是指网络通不通、主机是否可达、路由是否可用等网络本身的消息。

`ping` 命令中有一个 TTL 参数，该参数用来指定 ICMP 包的存活时间，这里的存活时间是指数据包所能经过的节点总数。例如，如果一个 ICMP 包的 TTL 值被设置成 2，那么这个 ICMP 包在网络上只能传到邻近的第二个节点；如果被设置成“1”，那么这个 ICMP 包只能传到邻近的第一个节点。tracert 就是根据这个原理设计的，使用该命令时，本机发出的 ICMP 数据包 TTL 值从“1”开始自动增加，相当于 ping 遍历通往目标主机的每个网络设备，然后显示每个设备的回应，从而探知网络路径中的每一个节点。

