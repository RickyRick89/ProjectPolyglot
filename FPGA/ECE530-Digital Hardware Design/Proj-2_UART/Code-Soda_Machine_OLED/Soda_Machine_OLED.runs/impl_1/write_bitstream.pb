
t
Command: %s
53*	vivadotcl2C
/write_bitstream -force soda_machine_wrapper.bit2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7s252default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7s252default:defaultZ17-349h px� 
x
,Running DRC as a precondition to command %s
1349*	planAhead2#
write_bitstream2default:defaultZ12-1349h px� 
>
IP Catalog is up to date.1232*coregenZ19-1839h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
�Missing CFGBVS and CONFIG_VOLTAGE Design Properties: Neither the CFGBVS nor CONFIG_VOLTAGE voltage property is set in the current_design.  Configuration bank voltage select (CFGBVS) must be set to VCCO or GND, and CONFIG_VOLTAGE must be set to the correct configuration voltage, in order to determine the I/O voltage support for the pins in bank 0.  It is suggested to specify these either using the 'Edit Device Properties' function in the GUI or directly in the XDC file using the following syntax:

 set_property CFGBVS value1 [current_design]
 #where value1 is either VCCO or GND

 set_property CONFIG_VOLTAGE value2 [current_design]
 #where value2 is the voltage provided to configuration bank 0

Refer to the device configuration user guide for more information.%s*DRC2(
 DRC|Pin Planning2default:default8ZCFGBVS-1h px� 
�
�LUT equation term check: Used physical LUT pin 'A1' of cell %s (pin %s) is not included in the LUT equation: 'O5=(A2*A3)+(A2*(~A3)*(~A4))+((~A2))'. If this cell is a user instantiated LUT in the design, please remove connectivity to the pin or change the equation and/or INIT string of the LUT to prevent this issue. If the cell is inferred or IP created LUT, please regenerate the IP and/or resynthesize the design to attempt to correct the issue.%s*DRC2�
 "�
Rdbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/temp_curid[31]_i_1	Rdbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/temp_curid[31]_i_12default:default2default:default2�
 "�
Udbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/temp_curid[31]_i_1/I0Udbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/temp_curid[31]_i_1/I02default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8Z	PDCN-1569h px� 
�
�LUT equation term check: Used physical LUT pin 'A3' of cell %s (pin %s) is not included in the LUT equation: 'O6=(A6+~A6)*((A2))'. If this cell is a user instantiated LUT in the design, please remove connectivity to the pin or change the equation and/or INIT string of the LUT to prevent this issue. If the cell is inferred or IP created LUT, please regenerate the IP and/or resynthesize the design to attempt to correct the issue.%s*DRC2�
 "�
Bdbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.id_state[0]_i_1	Bdbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.id_state[0]_i_12default:default2default:default2�
 "�
Edbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.id_state[0]_i_1/I0Edbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.id_state[0]_i_1/I02default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8Z	PDCN-1569h px� 
�
�LUT equation term check: Used physical LUT pin 'A5' of cell %s (pin %s) is not included in the LUT equation: 'O5=(A2*A3)+(A2*(~A3)*(~A4))+((~A2))'. If this cell is a user instantiated LUT in the design, please remove connectivity to the pin or change the equation and/or INIT string of the LUT to prevent this issue. If the cell is inferred or IP created LUT, please regenerate the IP and/or resynthesize the design to attempt to correct the issue.%s*DRC2�
 "�
Rdbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/temp_curid[31]_i_1	Rdbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/temp_curid[31]_i_12default:default2default:default2�
 "�
Udbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/temp_curid[31]_i_1/I1Udbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/temp_curid[31]_i_1/I12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8Z	PDCN-1569h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
char_num[0]_i_3_n_0char_num[0]_i_3_n_02default:default2default:default2P
 ":
char_num[0]_i_3/Ochar_num[0]_i_3/O2default:default2default:default2L
 "6
char_num[0]_i_3	char_num[0]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
char_num[1]_i_3_n_0char_num[1]_i_3_n_02default:default2default:default2P
 ":
char_num[1]_i_3/Ochar_num[1]_i_3/O2default:default2default:default2L
 "6
char_num[1]_i_3	char_num[1]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
char_num[2]_i_3_n_0char_num[2]_i_3_n_02default:default2default:default2P
 ":
char_num[2]_i_3/Ochar_num[2]_i_3/O2default:default2default:default2L
 "6
char_num[2]_i_3	char_num[2]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
char_num[3]_i_3_n_0char_num[3]_i_3_n_02default:default2default:default2P
 ":
char_num[3]_i_3/Ochar_num[3]_i_3/O2default:default2default:default2L
 "6
char_num[3]_i_3	char_num[3]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
char_num[4]_i_3_n_0char_num[4]_i_3_n_02default:default2default:default2P
 ":
char_num[4]_i_3/Ochar_num[4]_i_3/O2default:default2default:default2L
 "6
char_num[4]_i_3	char_num[4]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
char_num[5]_i_3_n_0char_num[5]_i_3_n_02default:default2default:default2P
 ":
char_num[5]_i_3/Ochar_num[5]_i_3/O2default:default2default:default2L
 "6
char_num[5]_i_3	char_num[5]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
char_num[6]_i_3_n_0char_num[6]_i_3_n_02default:default2default:default2P
 ":
char_num[6]_i_3/Ochar_num[6]_i_3/O2default:default2default:default2L
 "6
char_num[6]_i_3	char_num[6]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
char_num[7]_i_3_n_0char_num[7]_i_3_n_02default:default2default:default2P
 ":
char_num[7]_i_3/Ochar_num[7]_i_3/O2default:default2default:default2L
 "6
char_num[7]_i_3	char_num[7]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
line_num[0]_i_3_n_0line_num[0]_i_3_n_02default:default2default:default2P
 ":
line_num[0]_i_3/Oline_num[0]_i_3/O2default:default2default:default2L
 "6
line_num[0]_i_3	line_num[0]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
line_num[1]_i_3_n_0line_num[1]_i_3_n_02default:default2default:default2P
 ":
line_num[1]_i_3/Oline_num[1]_i_3/O2default:default2default:default2L
 "6
line_num[1]_i_3	line_num[1]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
line_num[2]_i_3_n_0line_num[2]_i_3_n_02default:default2default:default2P
 ":
line_num[2]_i_3/Oline_num[2]_i_3/O2default:default2default:default2L
 "6
line_num[2]_i_3	line_num[2]_i_32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2T
 ">
line_num[3]_i_4_n_0line_num[3]_i_4_n_02default:default2default:default2P
 ":
line_num[3]_i_4/Oline_num[3]_i_4/O2default:default2default:default2L
 "6
line_num[3]_i_4	line_num[3]_i_42default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[0]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[0]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[0]_LDC_i_1/O'uart1/gen/tick_counter_reg[0]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[0]_LDC_i_1	%uart1/gen/tick_counter_reg[0]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[10]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[10]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[10]_LDC_i_1/O(uart1/gen/tick_counter_reg[10]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[10]_LDC_i_1	&uart1/gen/tick_counter_reg[10]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[11]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[11]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[11]_LDC_i_1/O(uart1/gen/tick_counter_reg[11]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[11]_LDC_i_1	&uart1/gen/tick_counter_reg[11]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[12]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[12]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[12]_LDC_i_1/O(uart1/gen/tick_counter_reg[12]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[12]_LDC_i_1	&uart1/gen/tick_counter_reg[12]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[13]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[13]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[13]_LDC_i_1/O(uart1/gen/tick_counter_reg[13]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[13]_LDC_i_1	&uart1/gen/tick_counter_reg[13]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[14]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[14]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[14]_LDC_i_1/O(uart1/gen/tick_counter_reg[14]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[14]_LDC_i_1	&uart1/gen/tick_counter_reg[14]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[15]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[15]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[15]_LDC_i_1/O(uart1/gen/tick_counter_reg[15]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[15]_LDC_i_1	&uart1/gen/tick_counter_reg[15]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[16]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[16]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[16]_LDC_i_1/O(uart1/gen/tick_counter_reg[16]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[16]_LDC_i_1	&uart1/gen/tick_counter_reg[16]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[17]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[17]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[17]_LDC_i_1/O(uart1/gen/tick_counter_reg[17]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[17]_LDC_i_1	&uart1/gen/tick_counter_reg[17]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[18]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[18]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[18]_LDC_i_1/O(uart1/gen/tick_counter_reg[18]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[18]_LDC_i_1	&uart1/gen/tick_counter_reg[18]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[19]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[19]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[19]_LDC_i_1/O(uart1/gen/tick_counter_reg[19]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[19]_LDC_i_1	&uart1/gen/tick_counter_reg[19]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[1]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[1]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[1]_LDC_i_1/O'uart1/gen/tick_counter_reg[1]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[1]_LDC_i_1	%uart1/gen/tick_counter_reg[1]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[20]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[20]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[20]_LDC_i_1/O(uart1/gen/tick_counter_reg[20]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[20]_LDC_i_1	&uart1/gen/tick_counter_reg[20]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[21]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[21]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[21]_LDC_i_1/O(uart1/gen/tick_counter_reg[21]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[21]_LDC_i_1	&uart1/gen/tick_counter_reg[21]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[22]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[22]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[22]_LDC_i_1/O(uart1/gen/tick_counter_reg[22]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[22]_LDC_i_1	&uart1/gen/tick_counter_reg[22]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[23]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[23]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[23]_LDC_i_1/O(uart1/gen/tick_counter_reg[23]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[23]_LDC_i_1	&uart1/gen/tick_counter_reg[23]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[24]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[24]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[24]_LDC_i_1/O(uart1/gen/tick_counter_reg[24]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[24]_LDC_i_1	&uart1/gen/tick_counter_reg[24]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "l
*uart1/gen/tick_counter_reg[25]_LDC_i_1_n_0*uart1/gen/tick_counter_reg[25]_LDC_i_1_n_02default:default2default:default2~
 "h
(uart1/gen/tick_counter_reg[25]_LDC_i_1/O(uart1/gen/tick_counter_reg[25]_LDC_i_1/O2default:default2default:default2z
 "d
&uart1/gen/tick_counter_reg[25]_LDC_i_1	&uart1/gen/tick_counter_reg[25]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[2]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[2]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[2]_LDC_i_1/O'uart1/gen/tick_counter_reg[2]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[2]_LDC_i_1	%uart1/gen/tick_counter_reg[2]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[3]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[3]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[3]_LDC_i_1/O'uart1/gen/tick_counter_reg[3]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[3]_LDC_i_1	%uart1/gen/tick_counter_reg[3]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[4]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[4]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[4]_LDC_i_1/O'uart1/gen/tick_counter_reg[4]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[4]_LDC_i_1	%uart1/gen/tick_counter_reg[4]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[5]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[5]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[5]_LDC_i_1/O'uart1/gen/tick_counter_reg[5]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[5]_LDC_i_1	%uart1/gen/tick_counter_reg[5]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[6]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[6]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[6]_LDC_i_1/O'uart1/gen/tick_counter_reg[6]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[6]_LDC_i_1	%uart1/gen/tick_counter_reg[6]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[7]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[7]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[7]_LDC_i_1/O'uart1/gen/tick_counter_reg[7]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[7]_LDC_i_1	%uart1/gen/tick_counter_reg[7]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[8]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[8]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[8]_LDC_i_1/O'uart1/gen/tick_counter_reg[8]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[8]_LDC_i_1	%uart1/gen/tick_counter_reg[8]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "j
)uart1/gen/tick_counter_reg[9]_LDC_i_1_n_0)uart1/gen/tick_counter_reg[9]_LDC_i_1_n_02default:default2default:default2|
 "f
'uart1/gen/tick_counter_reg[9]_LDC_i_1/O'uart1/gen/tick_counter_reg[9]_LDC_i_1/O2default:default2default:default2x
 "b
%uart1/gen/tick_counter_reg[9]_LDC_i_1	%uart1/gen/tick_counter_reg[9]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�'
`No routable loads: 21 net(s) have no routable loads. The problem bus(es) and/or net(s) are %s.%s*DRC2�&
 "�
Adbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_inst/TMSAdbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_inst/TMS2default:default"�
�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_RD/U_RD_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_rdfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gr1.gr1_int.rfwft/aempty_fwft_i�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_RD/U_RD_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_rdfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gr1.gr1_int.rfwft/aempty_fwft_i2default:default"�
]dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD7_CTL/ctl_reg[2:0]Xdbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD7_CTL/ctl_reg2default:default"�
\dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD1/ctl_reg_en_2[1]\dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD1/ctl_reg_en_2[1]2default:default"�
`dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD7_CTL/ctl_reg_en_2[1]`dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD7_CTL/ctl_reg_en_2[1]2default:default"�
Rdbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/m_bscan_capture[0]Odbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/m_bscan_capture2default:default"�
Odbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/m_bscan_drck[0]Ldbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/m_bscan_drck2default:default"�
Rdbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/m_bscan_runtest[0]Odbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.bscan_switch/m_bscan_runtest2default:default"�
�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_WR/U_WR_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_wrfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/rstblk/ngwrdrst.grst.rd_rst_reg[0]�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_WR/U_WR_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_wrfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/rstblk/ngwrdrst.grst.rd_rst_reg[0]2default:default"�
�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_WR/U_WR_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_wrfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/rstblk/ngwrdrst.grst.wr_rst_reg[2]�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_WR/U_WR_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_wrfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/rstblk/ngwrdrst.grst.wr_rst_reg[2]2default:default"�
�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_RD/U_RD_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_rdfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/rstblk/ngwrdrst.grst.wr_rst_reg[2]�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_RD/U_RD_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_rdfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/rstblk/ngwrdrst.grst.wr_rst_reg[2]2default:default"�
�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_WR/U_WR_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_wrfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwhf.whf/overflow�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_WR/U_WR_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_wrfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwhf.whf/overflow2default:default"�
�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_RD/U_RD_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_rdfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwhf.whf/overflow�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_RD/U_RD_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_rdfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwhf.whf/overflow2default:default"�
�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_RD/U_RD_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_rdfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gras.rsts/ram_empty_i�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_RD/U_RD_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_rdfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gras.rsts/ram_empty_i2default:default"�
�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_WR/U_WR_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_wrfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwas.wsts/ram_full_i�dbg_hub/inst/BSCANID.u_xsdbm_id/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_WR/U_WR_FIFO/SUBCORE_FIFO.xsdbm_v3_0_0_wrfifo_inst/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwas.wsts/ram_full_i2default:..."/
(the first 15 of 19 listed)2default:default2default:default2=
 %DRC|Implementation|Routing|Chip Level2default:default8Z	RTSTAT-10h px� 
g
DRC finished with %s
1905*	planAhead2)
0 Errors, 43 Warnings2default:defaultZ12-3199h px� 
i
BPlease refer to the DRC report (report_drc) for more information.
1906*	planAheadZ12-3200h px� 
i
)Running write_bitstream with %s threads.
1750*designutils2
22default:defaultZ20-2272h px� 
?
Loading data files...
1271*designutilsZ12-1165h px� 
>
Loading site data...
1273*designutilsZ12-1167h px� 
?
Loading route data...
1272*designutilsZ12-1166h px� 
?
Processing options...
1362*designutilsZ12-1514h px� 
<
Creating bitmap...
1249*designutilsZ12-1141h px� 
7
Creating bitstream...
7*	bitstreamZ40-7h px� 
e
%Bitstream compression saved %s bits.
26*	bitstream2
38405442default:defaultZ40-26h px� 
k
Writing bitstream %s...
11*	bitstream2.
./soda_machine_wrapper.bit2default:defaultZ40-11h px� 
F
Bitgen Completed Successfully.
1606*	planAheadZ12-1842h px� 
�
�WebTalk data collection is mandatory when using a ULT device. To see the specific WebTalk data collected for your design, open the usage_statistics_webtalk.html or usage_statistics_webtalk.xml file in the implementation directory.698*projectZ1-1876h px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
142default:default2
432default:default2
02default:default2
02default:defaultZ4-41h px� 
a
%s completed successfully
29*	vivadotcl2#
write_bitstream2default:defaultZ4-42h px� 


End Record