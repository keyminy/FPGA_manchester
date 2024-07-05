restart

add_force rst {1 0ns} {0 1ps} {1 5ns}
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns
add_force pls_1m {0 0ns} {1 500ns} -repeat_every 1us
add_force sync_done 0
add_force d_sync -radix hex cc
add_force length -radix hex 04
add_force pd0 -radix hex 1a
add_force pd1 -radix hex 2b
add_force pd2 -radix hex 3c
add_force pd3 -radix hex 4d

run 9.52us
add_force sync_done 1
run 1us
add_force sync_done 0
run 70us