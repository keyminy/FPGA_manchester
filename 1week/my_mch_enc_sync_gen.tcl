restart

add_force rst {1 0ns} {0 1ps} {1 5ns}
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns
add_force pls_1m {0 0ns} {1 500ns} -repeat_every 1us
add_force start 0

run 10us
add_force start 1
run 5us
add_force start 0
run 20us