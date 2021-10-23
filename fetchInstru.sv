`timescale 1ns/10ps
module fetchInstru (instru, clk, reset, PC, BrPC, BrTaken);
	input logic clk, reset, BrTaken; // brTaken calculated in ID stage
	output logic [31:0] instru;
	// logic [63:0] currPC, muxOut, Br_out, noBr_out, ex_CondAddr, ex_BrAddr, shifted_Br, uncondBr_out;
	// logic [31:0] instruReg;
	output logic [63:0] PC;
	input logic [63:0] BrPC; // generated in ID stage
	logic [63:0] muxOut, noBr_out;
	
	
	instructmem instruMem (.address(PC), .instruction(instru), .clk);
	
	
	
	// no brTaken path
	alu adder1 (.A(64'd4), .B(PC), .cntrl(3'b010), .result(noBr_out));
	
	/*
	// brTaken path
	// SE
	signEx #(.addrLen(19))  SE (.a(instru[23:5]), .b(ex_CondAddr));
	signEx #(.addrLen(26))  SE2 (.a(instru[25:0]), .b(ex_BrAddr));
	// uncondBr mux
	mux2_1 UncondBrChoose (.out(uncondBr_out), .i0(ex_CondAddr), .i1(ex_BrAddr), .sel(UncondBr));
	// shifter
	shifter superShifter (.value(uncondBr_out), .direction(1'b0), .distance(6'b000010), .result(shifted_Br));
	// adder
	alu adder2 (.A(shifted_Br), .B(currPC), .cntrl(3'b010), .result(Br_out));
	*/
	

	// BrTaken mux
	mux2_1 BrTakenChoose (.out(muxOut), .i0(noBr_out), .i1(BrPC), .sel(BrTaken));
	D_FF64 programCounter (.q(PC), .d(muxOut), .reset, .clk, .en(1'b1));
	

endmodule



