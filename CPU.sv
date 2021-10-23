`timescale 1ns/10ps
module CPU (clk, reset);
	input logic clk, reset;
	
	logic [31:0] instru, instruReg;
	// logic BrTaken, UncondBr, overflow, zero, zero_hold, negative, cout, Reg2Loc, RegWrite, MemWrite, MemToReg, setFlag;
	logic ZEout, read_en, IsMOVZ;
	logic [3:0] xfer_size_ID;
	logic [1:0] ALUSrc_ID;
	logic [2:0] ALUOp_ID;
	logic BrTaken, UncondBr, overflow, zero, zero_hold, negative, cout, Reg2Loc_ID, RegWrite_ID, MemWrite_ID, MemToReg_ID, setFlag_ID;
	logic ZEout_ID, read_en_ID, IsMOVZ_ID, isZero_accBr, isBLT_ID, isMOV_ID;
	
	
	// need control module
	control cntrl (instru, BrTaken, UncondBr, overflow, zero, zero_hold, negative, cout, 
						Reg2Loc_ID, RegWrite_ID, MemWrite_ID, MemToReg_ID, ALUOp_ID, ALUSrc_ID,
						ZEout_ID, read_en_ID, IsMOVZ_ID, xfer_size_ID, setFlag_ID, isZero_accBr, isBLT_ID, isMOV_ID);
						

	
	
	// need datapath module
	datapath dp (instru, BrTaken, UncondBr, overflow, zero, zero_hold, negative, cout, Reg2Loc_ID, RegWrite_ID, MemWrite_ID, MemToReg_ID, ALUOp_ID, ALUSrc_ID, ZEout_ID, read_en_ID, IsMOVZ_ID, xfer_size_ID, clk, reset, setFlag_ID, isZero_accBr, isBLT_ID, isMOV_ID);
	

endmodule

module CPU_tb();
	logic clk, reset;
	
	CPU dut (clk, reset);
	
	parameter CLK_PERIOD = 10000;
	
	initial begin
		clk <= 0;
		forever #(CLK_PERIOD/2) clk <= ~clk;
	end 
	
	
	int i;
   initial begin
	reset = 1; @(posedge clk);
	reset = 0; @(posedge clk);
	for (i = 0; i < 5000; i++) begin
		@(posedge clk);
		end
	$stop;
	end
	
	
	
endmodule
	
	