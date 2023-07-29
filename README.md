# RISC-V-miniCPU
- 此项目为HITSZ2023年夏季学期计算机设计与实践课程代码，项目名称为基于miniRV的SoC设计，本README.md节选自实验报告。
## 单周期CPU设计与实现
模块说明：
1. 取指模块
- PC：存储当前指令地址的 32 位寄存器，指令执行时负责更新当前 PC 值（时序逻辑）
- NPC：得到下一条指令的 PC 值（组合逻辑）
- IROM：指令存储器，根据 PC 值得到对应的指令
- MUX：多路选择器，选择 NPC.pc 的值（组合逻辑）
2. 译码模块
- RF：寄存器堆，可根据寄存器编号读出源寄存器数据或将数据写入目标寄存器（异步读（组合逻辑）、同步写（时序逻辑））
- SEXT：立即数扩展单元，根据指令中立即数的格式进行扩展（组合逻辑）
- MUX：多路选择器，选择写回寄存器堆的数据
3. 执行模块
- ALU：运算器，根据控制信号对输入数据执行加、减、与、或、异或、移位、比较等运算（组合逻辑）
- MUX：多路选择器，选择输入 ALU.B 端口的数据
4. 存储模块
- DRAM：数据存储器，可读可写，用于存储数据
5. 写回模块
6. 控制模块
- control：控制器，根据指令中 opcode、func3、func7 的值得到各个器件的控制信号
![image](https://github.com/YounG-0516/RISC-V-miniCPU/blob/main/proj_single_cycle/RISCV-CPU-single.png)

## 流水线CPU设计与实现
模块说明：
1. 取指模块
- PC：存储当前指令地址的 32 位寄存器，指令执行时负责更新当前 PC 值（时序逻辑）
- NPC：得到下一条指令的 PC 值（组合逻辑）
- IROM：指令存储器，根据 PC 值得到对应的指令
2. 译码模块
- RF：寄存器堆，可根据寄存器编号读出源寄存器数据或将数据写入目标寄存器（异
步读（组合逻辑）、同步写（时序逻辑））
- SEXT：立即数扩展单元，根据指令中立即数的格式进行扩展（组合逻辑）
3. 执行模块
- MUX：多路选择器，选择输入 ALU.B 端口的数据
- ALU：运算器，根据控制信号对输入数据执行加、减、与、或、异或、移位、比较等运算（组合逻辑）
- wD_MUX_1：多路选择器，对写回寄存器堆的数据进行第一次选择（也即 EX 阶段
前递的数据）
- Judge_Jump：得到 B 型/jal/jalr 型指令跳转到的 pc 值，包括 pc+imm、pc+4、rs1+imm
三种情况，并将是否跳转及跳转地址返回给 IF 阶段的 NPC 部件
4. 存储模块
- DRAM：数据存储器，可读可写，用于存储数据
- wD_MUX_2：多路选择器，选择写回寄存器堆的数据是执行阶段的结果还是访存取出的数据
5. 控制模块
- Control：控制器，根据指令中 opcode、func3、func7 的值得到各个器件的控制信号
6. 冒险检测器模块
- Data_HazardDetection：检测并处理数据冒险，发出前递、停顿、清除的控制信号和
前递相关数据
- Control_HazardDetection：检测并处理控制冒险，发出清除的控制信号
7. 流水线寄存器模块
- REG_IF_ID：IF 和 ID 之间的流水线寄存器
- REG_ID_EX：ID 和 EX 之间的流水线寄存器
- REG_EX_MEM：EX 和 MEM 之间的流水线寄存器
- REG_MEM_WB：MEM 和 WB 之间的流水线寄存
![image](https://github.com/YounG-0516/RISC-V-miniCPU/blob/main/proj_pipeline/RISCV-CPU-pipeline.png)
