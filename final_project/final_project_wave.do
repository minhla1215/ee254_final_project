onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /final_project_test/Clk
add wave -noupdate -format Logic /final_project_test/Left
add wave -noupdate -format Logic /final_project_test/Right
add wave -noupdate -format Logic /final_project_test/Start
add wave -noupdate -format Logic /final_project_test/Reset
add wave -noupdate -format Logic /final_project_test/player
add wave -noupdate -format Logic /final_project_test/q_Initial
add wave -noupdate -format Logic /final_project_test/q_Check
add wave -noupdate -format Logic /final_project_test/q_P1_Win
add wave -noupdate -format Logic /final_project_test/q_P2_Win
add wave -noupdate -format Logic /final_project_test/q_Draw
add wave -noupdate -format Logic /final_project_test/p1Win
add wave -noupdate -format Logic /final_project_test/p2Win
add wave -noupdate -format Logic /final_project_test/draw
add wave -noupdate -format Logic /final_project_test/location
add wave -noupdate -format Literal -radix ascii /final_project_test/state_string
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0} {{Cursor 2} {12000000 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {14000000 ps}
