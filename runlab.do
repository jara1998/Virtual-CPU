# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./mux2_1.sv"
vlog "./decoder2to4.sv"
vlog "./decoder5to32.sv"
vlog "./decoder3to8.sv"
vlog "./dff_64.sv"
vlog "./mux4_1.sv"
vlog "./mux32_1.sv"
vlog "./control.sv"
vlog "./CPU.sv"
vlog "./fetchInstru.sv"
vlog "./instructmem.sv"
vlog "./datapath.sv"
vlog "./fa.sv"
vlog "./ALU.sv"
vlog "./signEx.sv"
vlog "./zeroEx.sv"
vlog "./math.sv"
vlog "./datamem.sv"
vlog "./bit_ALU.sv"
vlog "./regFile.sv"
vlog "./forwardingUnit.sv"
vlog "./test_flag_33.sv"



# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work CPU_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
