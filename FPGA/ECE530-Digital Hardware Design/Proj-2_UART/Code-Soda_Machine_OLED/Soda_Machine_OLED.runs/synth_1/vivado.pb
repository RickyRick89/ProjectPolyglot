
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental {Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/utils_1/imports/synth_1/soda_machine_wrapper.dcp}2default:defaultZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/utils_1/imports/synth_1/soda_machine_wrapper.dcp2default:defaultZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
�
Command: %s
53*	vivadotcl2P
<synth_design -top soda_machine_wrapper -part xc7s25csga225-12default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7s252default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7s252default:defaultZ17-349h px� 
V
Loading part %s157*device2#
xc7s25csga225-12default:defaultZ21-403h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
�
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
22default:defaultZ8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
_
#Helper process launched with PID %s4824*oasys2
62482default:defaultZ8-7075h px� 
�
%s*synth2�
yStarting RTL Elaboration : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1275.055 ; gain = 411.863
2default:defaulth px� 
�
synthesizing module '%s'%s4497*oasys2(
soda_machine_wrapper2default:default2
 2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
282default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
	clk_wiz_02default:default2
 2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.runs/synth_1/.Xil/Vivado-3784-TXAVM001/realtime/clk_wiz_0_stub.v2default:default2
62default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
	clk_wiz_02default:default2
 2default:default2
02default:default2
12default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.runs/synth_1/.Xil/Vivado-3784-TXAVM001/realtime/clk_wiz_0_stub.v2default:default2
62default:default8@Z8-6155h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
locked2default:default2
	clk_wiz_02default:default2
clk02default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
902default:default8@Z8-7071h px� 
�
Kinstance '%s' of module '%s' has %s connections declared, but only %s given4757*oasys2
clk02default:default2
	clk_wiz_02default:default2
42default:default2
32default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
902default:default8@Z8-7023h px� 
�
synthesizing module '%s'%s4497*oasys2
UART_top2default:default2
 2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/UART_top.v2default:default2
232default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
baud_gen2default:default2
 2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/baud_gen.v2default:default2
232default:default8@Z8-6157h px� 
n
%s
*synth2V
B	Parameter clock_freq bound to: 28'b0010111110101111000010000000 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
baud_gen2default:default2
 2default:default2
02default:default2
12default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/baud_gen.v2default:default2
232default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2!
UART_receiver2default:default2
 2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/UART_receiver.v2default:default2
232default:default8@Z8-6157h px� 
�
-case statement is not full and has no default155*oasys2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/UART_receiver.v2default:default2
902default:default8@Z8-155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2!
UART_receiver2default:default2
 2default:default2
02default:default2
12default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/UART_receiver.v2default:default2
232default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
	uart_fifo2default:default2
 2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
42default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
FIFO18E12default:default2
 2default:default2K
5C:/Xilinx/Vivado/2023.1/scripts/rt/data/unisim_comp.v2default:default2
395512default:default8@Z8-6157h px� 
j
%s
*synth2R
>	Parameter ALMOST_FULL_OFFSET bound to: 1020 - type: integer 
2default:defaulth p
x
� 
`
%s
*synth2H
4	Parameter DATA_WIDTH bound to: 18 - type: integer 
2default:defaulth p
x
� 
[
%s
*synth2C
/	Parameter DO_REG bound to: 0 - type: integer 
2default:defaulth p
x
� 
]
%s
*synth2E
1	Parameter EN_SYN bound to: TRUE - type: string 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
FIFO18E12default:default2
 2default:default2
02default:default2
12default:default2K
5C:/Xilinx/Vivado/2023.1/scripts/rt/data/unisim_comp.v2default:default2
395512default:default8@Z8-6155h px� 
�
Pwidth (%s) of port connection '%s' does not match port width (%s) of module '%s'689*oasys2
102default:default2
DO2default:default2
322default:default2
FIFO18E12default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
482default:default8@Z8-689h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
ALMOSTEMPTY2default:default2
FIFO18E12default:default2
fifo2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
332default:default8@Z8-7071h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
DOP2default:default2
FIFO18E12default:default2
fifo2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
332default:default8@Z8-7071h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
FULL2default:default2
FIFO18E12default:default2
fifo2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
332default:default8@Z8-7071h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
RDCOUNT2default:default2
FIFO18E12default:default2
fifo2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
332default:default8@Z8-7071h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
RDERR2default:default2
FIFO18E12default:default2
fifo2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
332default:default8@Z8-7071h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
WRCOUNT2default:default2
FIFO18E12default:default2
fifo2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
332default:default8@Z8-7071h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
WRERR2default:default2
FIFO18E12default:default2
fifo2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
332default:default8@Z8-7071h px� 
�
Kinstance '%s' of module '%s' has %s connections declared, but only %s given4757*oasys2
fifo2default:default2
FIFO18E12default:default2
192default:default2
122default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
332default:default8@Z8-7023h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
	uart_fifo2default:default2
 2default:default2
02default:default2
12default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/FIFO/uart_fifo.sv2default:default2
42default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
UART_top2default:default2
 2default:default2
02default:default2
12default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/UART_top.v2default:default2
232default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
oled_driver2default:default2
 2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/OLED/oled_driver.sv2default:default2
52default:default8@Z8-6157h px� 
x
%s
*synth2`
L	Parameter CLOCK_FREQUENCY bound to: 32'sb00000000101101110001101100000000 
2default:defaulth p
x
� 
�
-case statement is not full and has no default155*oasys2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/OLED/oled_driver.sv2default:default2
9232default:default8@Z8-155h px� 
�
-case statement is not full and has no default155*oasys2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/OLED/oled_driver.sv2default:default2
11252default:default8@Z8-155h px� 
�
-case statement is not full and has no default155*oasys2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/OLED/oled_driver.sv2default:default2
11392default:default8@Z8-155h px� 
�
-case statement is not full and has no default155*oasys2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/OLED/oled_driver.sv2default:default2
9092default:default8@Z8-155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
oled_driver2default:default2
 2default:default2
02default:default2
12default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/OLED/oled_driver.sv2default:default2
52default:default8@Z8-6155h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
cleared2default:default2
oled_driver2default:default2
oled2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
952default:default8@Z8-7071h px� 
�
Kinstance '%s' of module '%s' has %s connections declared, but only %s given4757*oasys2
oled2default:default2
oled_driver2default:default2
222default:default2
212default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
952default:default8@Z8-7023h px� 
�
-case statement is not full and has no default155*oasys2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
2352default:default8@Z8-155h px� 
�
-case statement is not full and has no default155*oasys2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
1962default:default8@Z8-155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2(
soda_machine_wrapper2default:default2
 2default:default2
02default:default2
12default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
282default:default8@Z8-6155h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2$
tick_counter_reg2default:default2
baud_gen2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/baud_gen.v2default:default2
562default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2"
bd_counter_reg2default:default2
baud_gen2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/baud_gen.v2default:default2
572default:default8@Z8-7137h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2 
num_bits_reg2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/UART_receiver.v2default:default2
772default:default8@Z8-6014h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2
tick_no_reg2default:default2!
UART_receiver2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/UART_receiver.v2default:default2
872default:default8@Z8-7137h px� 
�
fMark debug on the nets applies keep_hierarchy on instance '%s'. This will prevent further optimization4399*oasys2
gen2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/UART_top.v2default:default2
782default:default8@Z8-6071h px� 
�
fMark debug on the nets applies keep_hierarchy on instance '%s'. This will prevent further optimization4399*oasys2
rcvr2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/UART_top.v2default:default2
792default:default8@Z8-6071h px� 
�
fMark debug on the nets applies keep_hierarchy on instance '%s'. This will prevent further optimization4399*oasys2
uart12default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
912default:default8@Z8-6071h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2
bg_r_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
1162default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2
bg_g_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
1172default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2
bg_b_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
1182default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2
	txt_r_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
1192default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2
	txt_g_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
1202default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2
	txt_b_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
1212default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2 
line_num_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
2062default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2 
char_num_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
2072default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2!
RxFIFO_rd_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
912default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2)
characters_r1_buf_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
2382default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2)
characters_r2_buf_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
2492default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2)
characters_r3_buf_reg2default:default2(
soda_machine_wrapper2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/sources_1/imports/new/soda_machine_wrapper.v2default:default2
2602default:default8@Z8-7137h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2!
config_reg[7]2default:default2
UART_top2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2!
config_reg[6]2default:default2
UART_top2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
clk2default:default2
UART_top2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
ja[2]2default:default2(
soda_machine_wrapper2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
led[3]2default:default2(
soda_machine_wrapper2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
led[2]2default:default2(
soda_machine_wrapper2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
btn[1]2default:default2(
soda_machine_wrapper2default:defaultZ8-7129h px� 
�
%s*synth2�
yFinished RTL Elaboration : Time (s): cpu = 00:00:13 ; elapsed = 00:00:15 . Memory (MB): peak = 1419.973 ; gain = 556.781
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:13 ; elapsed = 00:00:15 . Memory (MB): peak = 1419.973 ; gain = 556.781
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:13 ; elapsed = 00:00:15 . Memory (MB): peak = 1419.973 ; gain = 556.781
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.1212default:default2
1423.4142default:default2
0.0002default:defaultZ17-268h px� 
e
-Analyzing %s Unisim elements for replacement
17*netlist2
12default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
>

Processing XDC Constraints
244*projectZ1-262h px� 
=
Initializing timing engine
348*projectZ1-569h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
�y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.gen/sources_1/ip/clk_wiz_0_1/clk_wiz_0/clk_wiz_0_in_context.xdc2default:default2
clk0	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
�y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.gen/sources_1/ip/clk_wiz_0_1/clk_wiz_0/clk_wiz_0_in_context.xdc2default:default2
clk0	2default:default8Z20-847h px� 
�
Parsing XDC File [%s]
179*designutils2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/constrs_1/imports/Master_Constraints/Cmod-S7-25-Master.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/constrs_1/imports/Master_Constraints/Cmod-S7-25-Master.xdc2default:default8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/constrs_1/imports/Master_Constraints/Cmod-S7-25-Master.xdc2default:default2:
&.Xil/soda_machine_wrapper_propImpl.xdc2default:defaultZ1-236h px� 
�
Parsing XDC File [%s]
179*designutils2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/constrs_1/new/debug_contraints.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/constrs_1/new/debug_contraints.xdc2default:default8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.srcs/constrs_1/new/debug_contraints.xdc2default:default2:
&.Xil/soda_machine_wrapper_propImpl.xdc2default:defaultZ1-236h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0022default:default2
1498.5162default:default2
0.0002default:defaultZ17-268h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common24
 Constraint Validation Runtime : 2default:default2
00:00:002default:default2 
00:00:00.0452default:default2
1498.5162default:default2
0.0002default:defaultZ17-268h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
Finished Constraint Validation : Time (s): cpu = 00:00:25 ; elapsed = 00:00:29 . Memory (MB): peak = 1498.516 ; gain = 635.324
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Loading part: xc7s25csga225-1
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:25 ; elapsed = 00:00:29 . Memory (MB): peak = 1498.516 ; gain = 635.324
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Z
%s
*synth2B
.Start Applying 'set_property' XDC Constraints
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:25 ; elapsed = 00:00:29 . Memory (MB): peak = 1498.516 ; gain = 635.324
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2default:default2!
UART_receiver2default:defaultZ8-802h px� 
�
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2default:default2(
soda_machine_wrapper2default:defaultZ8-802h px� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
.
%s
*synth2
*
2default:defaulth p
x
� 
�
%s
*synth2s
_                 st_init |                             0001 |                             0001
2default:defaulth p
x
� 
�
%s
*synth2s
_              st_receive |                             0010 |                             0010
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
6No Re-encoding of one hot register '%s' in module '%s'3445*oasys2
	state_reg2default:default2!
UART_receiver2default:defaultZ8-3898h px� 
�
QFound Keep on FSM register '%s' in module '%s', re-encoding will not be performed4499*oasys2
	state_reg2default:default2(
soda_machine_wrapper2default:defaultZ8-6159h px� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
.
%s
*synth2
*
2default:defaulth p
x
� 
�
%s
*synth2s
_                 st_init |                             0001 |                             0001
2default:defaulth p
x
� 
�
%s
*synth2s
_            st_get_chars |                             0010 |                             0010
2default:defaulth p
x
� 
�
%s
*synth2s
_           st_disp_chars |                             0011 |                             0011
2default:defaulth p
x
� 
�
%s
*synth2s
_                 st_wait |                             0100 |                             0100
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
QFound Keep on FSM register '%s' in module '%s', re-encoding will not be performed4499*oasys2"
next_state_reg2default:default2(
soda_machine_wrapper2default:defaultZ8-6159h px� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
.
%s
*synth2
*
2default:defaulth p
x
� 
�
%s
*synth2s
_                 st_init |                             0001 |                             0001
2default:defaulth p
x
� 
�
%s
*synth2s
_            st_get_chars |                             0010 |                             0010
2default:defaulth p
x
� 
�
%s
*synth2s
_           st_disp_chars |                             0011 |                             0011
2default:defaulth p
x
� 
�
%s
*synth2s
_                 st_wait |                             0100 |                             0100
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:32 ; elapsed = 00:00:36 . Memory (MB): peak = 1498.516 ; gain = 635.324
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   32 Bit       Adders := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    8 Bit       Adders := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    7 Bit       Adders := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    6 Bit       Adders := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    5 Bit       Adders := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    5 Bit       Adders := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    4 Bit       Adders := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    3 Bit       Adders := 4     
2default:defaulth p
x
� 
8
%s
*synth2 
+---XORs : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   7 Input      1 Bit         XORs := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   3 Input      1 Bit         XORs := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      1 Bit         XORs := 1     
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               96 Bit    Registers := 9     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               32 Bit    Registers := 3     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               10 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                8 Bit    Registers := 39    
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                7 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                6 Bit    Registers := 5     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                5 Bit    Registers := 4     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                4 Bit    Registers := 5     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                3 Bit    Registers := 4     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                1 Bit    Registers := 26    
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	 256 Input   96 Bit        Muxes := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   96 Bit        Muxes := 15    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   5 Input   96 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input   96 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input   96 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   32 Bit        Muxes := 12    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input   32 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   26 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   5 Input   16 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input   10 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    8 Bit        Muxes := 351   
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    8 Bit        Muxes := 15    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    8 Bit        Muxes := 11    
2default:defaulth p
x
� 
X
%s
*synth2@
,	 256 Input    8 Bit        Muxes := 7     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   5 Input    8 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    7 Bit        Muxes := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   6 Input    7 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   7 Input    7 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    6 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	 256 Input    6 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    5 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    5 Bit        Muxes := 5     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   5 Input    5 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    5 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    4 Bit        Muxes := 24    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    4 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    4 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	 256 Input    4 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   5 Input    4 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    3 Bit        Muxes := 22    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    3 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	  35 Input    3 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	 256 Input    3 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    2 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    1 Bit        Muxes := 100   
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    1 Bit        Muxes := 14    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   5 Input    1 Bit        Muxes := 7     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    1 Bit        Muxes := 23    
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2i
UPart Resources:
DSPs: 80 (col length:40)
BRAMs: 90 (col length: RAMB18 40 RAMB36 20)
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
u
%s
*synth2]
IDSP Report: Generating DSP w_tick_count_target1, operation Mode is: A*B.
2default:defaulth p
x
� 
�
%s
*synth2i
UDSP Report: operator w_tick_count_target1 is absorbed into DSP w_tick_count_target1.
2default:defaulth p
x
� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2!
config_reg[7]2default:default2
UART_top2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2!
config_reg[6]2default:default2
UART_top2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
clk2default:default2
UART_top2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
ja[2]2default:default2(
soda_machine_wrapper2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
led[3]2default:default2(
soda_machine_wrapper2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
led[2]2default:default2(
soda_machine_wrapper2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
btn[1]2default:default2(
soda_machine_wrapper2default:defaultZ8-7129h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:01:20 ; elapsed = 00:01:26 . Memory (MB): peak = 1498.516 ; gain = 635.324
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
M
%s*synth25
!
ROM: Preliminary Mapping Report
2default:defaulth px� 
i
%s*synth2Q
=+------------+------------+---------------+----------------+
2default:defaulth px� 
j
%s*synth2R
>|Module Name | RTL Object | Depth x Width | Implemented As | 
2default:defaulth px� 
i
%s*synth2Q
=+------------+------------+---------------+----------------+
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | OPERATIONS | 64x3          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | OPERATIONS | 64x3          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>|oled_driver | SPI_BYTES  | 64x8          | LUT            | 
2default:defaulth px� 
j
%s*synth2R
>+------------+------------+---------------+----------------+

2default:defaulth px� 
�
%s*synth2p
\
DSP: Preliminary Mapping Report (see note below. The ' indicates corresponding REG is set)
2default:defaulth px� 
�
%s*synth2�
|+------------+-------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
2default:defaulth px� 
�
%s*synth2�
}|Module Name | DSP Mapping | A Size | B Size | C Size | D Size | P Size | AREG | BREG | CREG | DREG | ADREG | MREG | PREG | 
2default:defaulth px� 
�
%s*synth2�
|+------------+-------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
2default:defaulth px� 
�
%s*synth2�
}|baud_gen    | A*B         | 16     | 8      | -      | -      | 24     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
}+------------+-------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+

2default:defaulth px� 
�
%s*synth2�
�Note: The table above is a preliminary report that shows the DSPs inferred at the current stage of the synthesis flow. Some DSP may be reimplemented as non DSP primitives later in the synthesis flow. Multiple instantiated DSPs are reported only once.
2default:defaulth px� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
R
%s
*synth2:
&Start Applying XDC Timing Constraints
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:01:34 ; elapsed = 00:01:42 . Memory (MB): peak = 1498.516 ; gain = 635.324
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
}Finished Timing Optimization : Time (s): cpu = 00:01:54 ; elapsed = 00:02:02 . Memory (MB): peak = 1600.605 ; gain = 737.414
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
|Finished Technology Mapping : Time (s): cpu = 00:01:56 ; elapsed = 00:02:04 . Memory (MB): peak = 1618.699 ; gain = 755.508
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
vFinished IO Insertion : Time (s): cpu = 00:02:04 ; elapsed = 00:02:13 . Memory (MB): peak = 1618.699 ; gain = 755.508
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:02:04 ; elapsed = 00:02:13 . Memory (MB): peak = 1618.699 ; gain = 755.508
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:02:05 ; elapsed = 00:02:13 . Memory (MB): peak = 1618.699 ; gain = 755.508
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:02:05 ; elapsed = 00:02:13 . Memory (MB): peak = 1618.699 ; gain = 755.508
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:02:05 ; elapsed = 00:02:14 . Memory (MB): peak = 1618.699 ; gain = 755.508
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:02:05 ; elapsed = 00:02:14 . Memory (MB): peak = 1618.699 ; gain = 755.508
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
i
%s
*synth2Q
=
DSP Final Report (the ' indicates corresponding REG is set)
2default:defaulth p
x
� 
�
%s
*synth2�
|+------------+-------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
2default:defaulth p
x
� 
�
%s
*synth2�
}|Module Name | DSP Mapping | A Size | B Size | C Size | D Size | P Size | AREG | BREG | CREG | DREG | ADREG | MREG | PREG | 
2default:defaulth p
x
� 
�
%s
*synth2�
|+------------+-------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
2default:defaulth p
x
� 
�
%s
*synth2�
}|baud_gen    | A*B         | 14     | 5      | -      | -      | 24     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
}+------------+-------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+

2default:defaulth p
x
� 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
� 
O
%s
*synth27
#+------+--------------+----------+
2default:defaulth p
x
� 
O
%s
*synth27
#|      |BlackBox name |Instances |
2default:defaulth p
x
� 
O
%s
*synth27
#+------+--------------+----------+
2default:defaulth p
x
� 
O
%s
*synth27
#|1     |clk_wiz_0     |         1|
2default:defaulth p
x
� 
O
%s
*synth27
#+------+--------------+----------+
2default:defaulth p
x
� 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
F
%s*synth2.
|      |Cell     |Count |
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
F
%s*synth2.
|1     |clk_wiz  |     1|
2default:defaulth px� 
F
%s*synth2.
|2     |CARRY4   |   222|
2default:defaulth px� 
F
%s*synth2.
|3     |DSP48E1  |     1|
2default:defaulth px� 
F
%s*synth2.
|4     |FIFO18E1 |     1|
2default:defaulth px� 
F
%s*synth2.
|5     |LUT1     |    60|
2default:defaulth px� 
F
%s*synth2.
|6     |LUT2     |   201|
2default:defaulth px� 
F
%s*synth2.
|7     |LUT3     |   696|
2default:defaulth px� 
F
%s*synth2.
|8     |LUT4     |   245|
2default:defaulth px� 
F
%s*synth2.
|9     |LUT5     |   643|
2default:defaulth px� 
F
%s*synth2.
|10    |LUT6     |  1019|
2default:defaulth px� 
F
%s*synth2.
|11    |MUXF7    |    74|
2default:defaulth px� 
F
%s*synth2.
|12    |MUXF8    |    27|
2default:defaulth px� 
F
%s*synth2.
|13    |FDCE     |   653|
2default:defaulth px� 
F
%s*synth2.
|14    |FDCP     |     8|
2default:defaulth px� 
F
%s*synth2.
|15    |FDCPE    |     4|
2default:defaulth px� 
F
%s*synth2.
|16    |FDC      |     3|
2default:defaulth px� 
F
%s*synth2.
|17    |FDPE     |    41|
2default:defaulth px� 
F
%s*synth2.
|18    |FDP      |     1|
2default:defaulth px� 
F
%s*synth2.
|19    |FDRE     |   690|
2default:defaulth px� 
F
%s*synth2.
|20    |LDC      |    38|
2default:defaulth px� 
F
%s*synth2.
|21    |IBUF     |     2|
2default:defaulth px� 
F
%s*synth2.
|22    |OBUF     |     9|
2default:defaulth px� 
F
%s*synth2.
|23    |OBUFT    |     3|
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:02:05 ; elapsed = 00:02:14 . Memory (MB): peak = 1618.699 ; gain = 755.508
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
r
%s
*synth2Z
FSynthesis finished with 0 errors, 0 critical warnings and 8 warnings.
2default:defaulth p
x
� 
�
%s
*synth2�
Synthesis Optimization Runtime : Time (s): cpu = 00:01:49 ; elapsed = 00:02:10 . Memory (MB): peak = 1618.699 ; gain = 676.965
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:02:06 ; elapsed = 00:02:14 . Memory (MB): peak = 1618.699 ; gain = 755.508
2default:defaulth p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.1162default:default2
1618.6992default:default2
0.0002default:defaultZ17-268h px� 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
3792default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
g
1Inserted %s IBUFs to IO ports without IO buffers.100*opt2
12default:defaultZ31-140h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0012default:default2
1618.6992default:default2
0.0002default:defaultZ17-268h px� 
�
!Unisim Transformation Summary:
%s111*project2�
�  A total of 54 instances were transformed.
  FDCP => FDCP (FDCE, FDPE, LDCE, LUT3, VCC): 8 instances
  FDCPE => FDCPE (FDCE, FDPE, LDCE, LUT3, VCC): 4 instances
  FDC_1 => FDCE (inverted pins: C): 3 instances
  FDP_1 => FDPE (inverted pins: C): 1 instance 
  LDC => LDCE: 38 instances
2default:defaultZ1-111h px� 
h
%Synth Design complete | Checksum: %s
562*	vivadotcl2
38e8d2b12default:defaultZ4-1430h px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
562default:default2
442default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px� 
�
4The following parameters have non-default value.
%s
395*common2H
4tcl.statsThreshold, tcl.collectionResultDisplayLimit2default:defaultZ17-600h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
�Y:/School/ECE 530 - Digital Hardware Design/Projects/P2/Soda_Machine_OLED/Soda_Machine_OLED.runs/synth_1/soda_machine_wrapper.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2�
~Executing : report_utilization -file soda_machine_wrapper_utilization_synth.rpt -pb soda_machine_wrapper_utilization_synth.pb
2default:defaulth px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Wed Nov 29 17:46:04 20232default:defaultZ17-206h px� 


End Record