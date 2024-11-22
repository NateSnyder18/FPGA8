# FPGA8
Modules:

up_counter-this module counts to 4095 and then wraps to 0. Has an enable signal to control execution and a done signal to signify when it has counted.

up_counter_tb-used to test up_counter

Bin2BCD- covnerts a 12-bit binary number to 16-bit binary coded decimal, using the double dabble algorithm. Uses a FSM to accomplish this.
Bin2BCD_tb- used to test Bin2BCD

Display_Top-contains the previous modules (including the multi-digit display driver modules from previous labs), as well as the new strobe module which acts as a clock divider.
It instantiates the modules according to the block diagram.
