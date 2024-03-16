#import "/template.typ": report

#show: report.with(title: "lab05-主机路由实验", date: "2024 年 3 月 11 日")

= 实验目的

= 实验原理

= 实验设备

- 实验硬件：济事楼 330 机房电脑与个人笔记本电脑
- 实验软件：命令提示符 cmd

= 实验步骤

+ 以管理员身份打开命令提示符；
+ 使用 `route PRINT` 命令查看当前的路由表；
+ 记录显示的路由表项；
+ 使用 `route ADD` 命令添加新的路由，然后使用 `route PRINT` 观察路由表的变化；
  ```sh
  route ADD [目标网络] MASK [子网掩码] [网关地址] METRIC [跃点数]
  ```
+ 使用 `route CHANGE` 命令尝试修改现有的路由，然后使用 `route PRINT` 观察路由表的变化；
  ```sh
  route CHANGE [目标网络] MASK [新子网掩码] [新网关地址] METRIC [新跃点数]
  ```
+ 使用 `route DELETE` 命令删除刚才添加的路由，然后使用 `route PRINT` 观察路由表的变化；
  ```sh
  route DELETE [目标网络]
  ```

= 实验现象

+ `route PRINT` 命令显示了当前的路由表；
  #figure(
    image("05_01.png"),
    caption: [`route PRINT -4` 命令运行结果，仅显示 IPv4 路由表],
  )
+ 使用 `route ADD` 后，可以看到新的路由项出现在路由表中；
  #figure(
    image("05_02_01.png"),
    caption: [`route ADD 192.168.56.100 MASK 255.255.255.255 192.168.56.1` 添加了一个到 192.168.56.1 的网络，子网掩码为 255.255.255.255，通过 网关],
  )
+ 使用 `route CHANGE` 后，可以看到选定的路由项被修改了；
  #figure(
    image("05_03_01.png"),
    caption: [一些说明],
  )
+ 使用 `route DELETE` 后，选定的路由项在路由表中消失。
  #figure(
    image("05_04_01.png"),
    caption: [一些说明],
  )

= 分析讨论

