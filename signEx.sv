`timescale 1ns/10ps
module signEx #(parameter addrLen = 26) (a, b);
	input logic [addrLen - 1: 0] a;
	output logic [63: 0] b;
	assign b = {{(64 - addrLen){a[addrLen - 1]}}, a};
	
endmodule

// pass
module signEx_tb();
	logic [15:0] a;
	logic [63:0] b;
	
	signEx #(.addrLen(16)) dut (.a, .b);
	
	initial begin
		a = 16'b1011111111111111; #10;
		a = 16'b0011111111111111; #10;
	end
	
endmodule
	