restart
add_force rst {1 0ns} {0 1ps} {1 5ns}
# 10MHZ 클럭, 주기 10ns생성
add_force clk -radix hex {0 0ns} {1 5ns} -repeat_every 10ns 
# 1MHz클럭 생성
add_force pls_1m {0 0ns} {1 500ns} -repeat_every 1us
add_force start 0

run 10us
add_force start 1
run 5us
add_force start 0
run 10us