
# final_project.do

vlib work
vlog +acc  "final_project.v"
vlog +acc  "final_project_test.v"
vsim -t 1ps -lib work final_project_test
do {final_project_wave.do}
view wave
view structure
view signals
log -r *
run 14us
WaveRestoreZoom {0 ps} {14000000 ps}
run 4us