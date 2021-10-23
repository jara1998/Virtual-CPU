`timescale 1ns/10ps
// basic DFF module
module D_FF (q, d, reset, clk);
 output reg q;
 input d, reset, clk;
 always_ff @(posedge clk)
 if (reset)
 q <= 0; // On reset, set to 0
 else
 q <= d; // Otherwise out = d
endmodule 

module DFF_en (q, d, reset, clk, en);
	output logic q;
	input logic d;
	input logic reset, clk;
	input logic en;
	logic mux_out;
	mux2to1_bit mux1 (mux_out, q, d, en);
	D_FF dff1 (.q, .d(mux_out), .reset, .clk);

endmodule 

// DFF module that takes 64 bits input
// when enabled, the q will output new loaded d, else will follow the original value
module D_FF64 (q, d, reset, clk, en);
 output logic [63:0] q;
 input logic [63:0] d;
 input logic reset, clk;
 input logic en;
 logic [63:0] mux_out;
 mux2_1 mux1 (.out(mux_out), .i0(q), .i1(d), .sel(en));
	 genvar i;
	 generate
	 for(i=0; i<64; i++) begin: name
		D_FF dff1 (.q(q[i]), .d(mux_out[i]), .reset, .clk);
	 end
	 endgenerate
	
	 
endmodule 

module D_FF64_testbench();
logic [63:0] q;
logic [63:0] d;
logic reset;
logic clk;
logic en;
parameter PERIOD = 100; // period = length of clock
 // Make the clock LONG to test
initial begin
 clk <= 0;
 forever #(PERIOD/2) clk = ~clk;
end 

 D_FF64 dut (.q, .d, .reset, .clk,.en);
 initial begin
 reset=0; d=64'd25; en = 1'b1; #500;
 reset=0; d=64'd17;  #500;
 reset=0; d=64'd5;   en = 1'b0;#500;
 reset=0; d=64'd16;  en = 1'b1;#500;
 reset=1; d=64'd17;  #500;
 reset=0; d=64'd5;   #500;
 end

endmodule

// DFF module that takes 64 bits input
// when enabled, the q will output new loaded d, else will follow the original value
module DFF_VAR #(parameter size = 32) (q, d, reset, clk, en);
 output logic [size - 1:0] q;
 input logic [size - 1:0] d;
 input logic reset, clk;
 input logic en;
 logic [size - 1:0] mux_out;
 mux2to1_VAR  #(.sizem(size)) mux_var (mux_out, q, d, en);
	 genvar i;
	 generate
	 for(i=0; i<size; i++) begin: name
		D_FF dff1 (.q(q[i]), .d(mux_out[i]), .reset, .clk);
	 end
	 endgenerate
	
	 
endmodule 
