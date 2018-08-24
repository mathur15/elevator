vlib work
vlog -timescale 1ns/1ns elevator5.v
vsim elevator5
log {/*}
add wave {/*}

force {SW[9]} 0 0, 1 20, 0 40
force {CLOCK_50} 0 0, 1 10 -r 20
force {KEY[3]} 0 0, 1 60, 0 80
force {KEY[2]} 0 0, 1 60, 0 80
 

run 4000ns
