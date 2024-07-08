#module mch_codec
#(
#    input 	btnl, // rst. High Active Reset
#    input 	clk,  // 100MHz Clock Input
#    input 	btnr, // run_md_btn. Tact Switch Input. Push High
#    input 	[15:0] sw,
#    output  txsd,
#    output 	reg [15:0] led
#);          

restart

add_force btnl {0 0ns} {1 1ps} {0 10ns}
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns
add_force btnr 0
add_force btnd 0
add_force sw -radix hex 123f

run 10us
add_force btnd 1
run 40us
add_force btnd 0
run 10us

add_force btnr 1
run 40us
add_force btnr 0
run 80us
