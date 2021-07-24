set period(200M) [expr 5*$MARGIN]
set period(150M) [expr 5*$MARGIN]

create_clock -period $period(200M) -add -name clock_clk -waveform [list 0 [expr $period(200M)*0.5]] [get_pins DLL_clk_PAD/DI]
create_clock -period $period(150M) -add -name clock_sck -waveform [list 0 [expr $period(150M)*0.5]] [get_pins O_spi_sck_PAD_rd0/DI]

set_clock_uncertainty -setup 0.3  [get_pins DLL_clk_PAD/DI]
set_clock_uncertainty -hold  0.15 [get_pins DLL_clk_PAD/DI]

set_clock_uncertainty -setup 0.4  [get_pins O_spi_sck_PAD_rd0/DI]
set_clock_uncertainty -hold  0.15 [get_pins O_spi_sck_PAD_rd0/DI]


set_false_path -from [get_clocks clock_clk] -to [get_clocks clock_sck]
set_false_path -from [get_clocks clock_sck] -to [get_clocks clock_clk]

set_false_path -from [list \
  [get_ports I_reset_n] \
  [get_ports I_reset_dll]  \
  [get_ports I_bypass ] \
  [get_ports I_SW0] \
  [get_ports I_SW1] \
  [get_ports I_bypass_fifo] ] 

set_input_delay  -clock clock_sck -clock_fall -add_delay [expr 0.0*$period(150M)] [get_pins IO_spi_data_PAD_rd0_GEN*/DI]
set_output_delay -clock clock_sck -clock_fall -add_delay [expr 0.2*$period(150M)] [get_pins IO_spi_data_PAD_rd0_GEN*/DO]
set_input_delay  -clock clock_clk -clock_fall -add_delay [expr 0.0*$period(200M)] [get_pins IO_spi_data_PAD_rd0_GEN*/DI]
set_output_delay -clock clock_clk -clock_fall -add_delay [expr 0.2*$period(200M)] [get_pins IO_spi_data_PAD_rd0_GEN*/DO]

set_output_delay -clock clock_clk -clock_fall -add_delay [expr 0.2*$period(200M)] [get_pins GEN_MONITOR_OUT*/DO]
set_output_delay -clock clock_clk -clock_fall -add_delay [expr 0.2*$period(200M)] [get_pins MONITOR_OUT_VALID_PAD/DO]

set_input_delay -clock clock_sck -clock_fall -add_delay [expr 0.0*$period(150M)] [get_pins OE_req_PAD_rd0/DI]
set_max_delay 8 -from [get_ports I_OE_req] -to [get_ports IO*]

set_input_delay -clock clock_sck -clock_fall -add_delay [expr 0.0*$period(150M)] [get_pins O_spi_cs_n_PAD_rd0/DI]
set_input_delay -clock clock_clk -clock_fall -add_delay [expr 0.0*$period(200M)] [get_pins O_spi_cs_n_PAD_rd0/DI]

set_input_delay -clock clock_clk -clock_fall -add_delay [expr 0.0*$period(200M)] [get_pins MONITOR_EN_PAD/DI]

set_input_delay -clock clock_clk -clock_fall -add_delay [expr 0.0*$period(200M)] [get_pins I_in_1_PAD_rd0/DI]
set_input_delay -clock clock_clk -clock_fall -add_delay [expr 0.0*$period(200M)] [get_pins I_in_2_PAD_rd0/DI]

# only clk
set_output_delay -clock clock_clk -clock_fall -add_delay [expr 0.2*$period(200M)] [get_pins config_req_PAD_rd0/DO]
set_output_delay -clock clock_clk -clock_fall -add_delay [expr 0.2*$period(200M)] [get_pins Switch_RdWr_PAD/DO]
# clk and sck
set_output_delay -clock clock_sck -clock_fall -add_delay [expr 0.2*$period(150M)] [get_pins near_full_PAD_rd0/DO]
set_output_delay -clock clock_clk -clock_fall -add_delay [expr 0.2*$period(200M)] [get_pins near_full_PAD_rd0/DO]

set_max_delay 10000 -from [get_ports I_spi_cs_n] -to [get_ports IO*]
set_max_delay 10000 -from [get_ports I_spi_cs_n] -to [get_ports IO*]

set_input_transition -min 0.05 [filter_collection [all_inputs] "full_name !~clk && full_name !~reset && full_name !~sck "]
set_input_transition -max 0.5  [filter_collection [all_inputs] "full_name !~clk && full_name !~reset && full_name !~sck "]
set_input_transition -min 0.05 [get_ports IO*]
set_input_transition -max 0.5  [get_ports IO*]

#set_driving_cell -library u055lscspmvbdr_108c125_wc -lib_cell BUFM4TM -pin Z [all_inputs]
#set_load [expr 8 * [load_of u055lsclpmvbdr_108c125_wc/BUFM4TM/A]] [all_outputs]
set_load -pin_load -max 1 [all_outputs]

set_max_transition 0.5 ${TOP_MODULE}
set_max_fanout 32 ${TOP_MODULE}

