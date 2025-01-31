//#import "/template.typ": report
//
//#show: report.with(title: "lab07-异常串口通信收发实验", date: "2024 年 3 月 11 日", cooperator: "")

= 实验目的

本实验主要通过实际操作和实验，让我们深入了解串口与并口的工作原理和应用场景，掌握其在数据传输中的优缺点。在实验中，我们将通过配置和控制串口通信参数，实现通过串口接收数据，并在此过程中体验到使用异步串口通信进行设备间数据传输的实际场景，用实际操作来促进我们对计算机网络原理的理解。

= 实验原理

+ 串口（Serial Port）：只能用一条线传输一位数据，每次传输一个字节的一位；
  - PC 系统中串口的物理连接方式有 9 针和 25 针两种方式，通过额外的子卡挡板与电脑连接；
  - 随着 PC 技术的发展，25 针的串口逐渐被淘汰，目前串口都使用 9 针的连接方式直接集成在主板上。一般的 PC 主板都提供 COM1 和 COM2 两个串口；
  - 标准串口能够达到最高 115Kbps 的数据传输速度，而一些增强型串口如 ESP(Enhanced Serial Port)、Super ESP 等则能达到 460Kbps 的数据传输速率。
+ 并口（Parallel Port）：即 LPT 接口，同时通过八或多条数据线传输信息，一次传输一个或多个字节；
  - 由于并口可以同时传输更多的信息，速度明显高于串口，但数据传输距离不如串口远；
  - 使用并行通信协议的扩展接口，数据传输速率比串口快 8 倍，标准并口的数据传输速率为 1Mbps。一般用来连接打印机、扫描仪等，所以并口又称打印口。
+ 串口特性
  - RS232 接口是 1970 年由美国电子工业协会（EIA）联合贝尔系统、调制解调器厂家及计算机终端生产厂家共同制定的用于串行通讯的标准。全称“数据终端设备（DTE）和数据通讯设备（DCE）之间串行二进制数据交换接口技术标准”。
  - 该标准规定采用一个 25 个脚的 DB25 连接器，对连接器的每个引脚的信号内容加以规定，还对各种信号的电平加以规定。
  - 随着设备的不断改进，出现了代替 DB25 的 DB9 接口，现在都把 RS232 接口叫做 DB9。
  - RS232 采用负逻辑电平：-15\~-3 表示逻辑 1；+15\~+3 表示逻辑 0。电压值通常在 7V 左右。
  #figure(
    image("./07_01.png", width: 50%),
    caption: [RS232 接口],
  )

= 实验设备

- 实验硬件：济事楼 330 机房两台电脑及 RS232 串口线
- 实验软件：串口调试工具

= 实验步骤

+ *准备*
  + 确保两台 PC 主机都具备 COM1 串口，并准备好一根 DB9 串口线；
  + 在两台 PC 主机上分别安装串口调试软件。本实验使用友善串口调试助手与 XCOM V2.0。
+ *连接*
  + 确保 PC 主机关机后，使用 DB9 串口线将两台 PC 主机的 COM1 口连接起来。
+ *配置*
  + 分别打开两台电脑上的串口调试软件；
  + 在串口调试软件的界面中，选择“串口模式（Serial）”；
  + 在软件中进行以下参数的设置：
    - 选择 COM1 作为操作的串口；
    - 设置每秒位数（Baud Rate），如 9600 或 115200；
    - 设置数据位（Data Bits），如 8 位；
    - 设置奇偶校验（Parity），如 None；
    - 设置停止位（Stop Bits），如 1 位。
+ *数据传输*
  - 在两台主机上分别通过串口进行数据传输，确保发送和接收均成功；
  - 记录数据传输的速度、延迟和任何可能的错误。
+ *参数调整*
  - 改变串口参数，如每秒位数、数据位等，重新进行数据传输；
  - 记录改变参数后的数据传输速度、延迟和效率。

= 实验现象

+ 当两台电脑数据位均设置为八位、奇偶校验设置一致、停止位设置相同时，串口通信成功，可以正常传输数据。

  #grid(
    columns: (1fr, 1fr),
    align(left)[
      #image("./07_02.png", width: 90%)
    ],
    align(right)[
      #image("./07_03.png", width: 90%)
    ],
  )

+ 当上述三个设置中任一设置不一致时，串口通信失败。
  
  #grid(
    columns: (1fr, 1fr),
    align(left)[
      #image("./07_04.png", width: 90%)
    ],
    align(right)[
      #image("./07_05.png", width: 90%)
    ],
  )

= 分析讨论

+ 通信失败原因分析
  + 数据位不同
    - 串口通信中数据位指每个数据字节中用于传输数据的位数。当发送端与接收端数据位不匹配时，接收端将无法准确解码发送端的信息，从而导致数据传输错误；
  + 校验方式不同
    - 串口通信中奇偶校验是为了确保数据的完整性和准确性。当发送端与接收端校验方式不匹配时，通常会导致数据被误判为已损坏，从而被丢弃或需要重新传输；
  + 停止位不同
    - 串口通信中停止位用于识别字符或命令的结束位置。当发送端与接收端停止位不匹配时，接收端将无法准确识别字符或命令的结束，从而导致数据传输中断或发生错误。
+ 不同的串口调试工具都可以进行数据的传输
  - 这个问题可以从 OSI 模型的角度解释：OSI 模型中，应用层负责处理特定应用程序的细节，而物理层负责底层的数据传输。不同串口调试工具工作在应用层，而 RS232 协议作为物理层的通信标准，可以确保不同应用层软件下的主机可以在物理层完成一致且准确的数据交换，成功进行通信。

