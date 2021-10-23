`timescale 1ns/10ps
module datapath (instru, BrTaken, UncondBr, overflow, zero, zero_hold, negative, cout, 
						Reg2Loc_ID, RegWrite_ID, MemWrite_ID, MemToReg_ID, ALUOp_ID, ALUSrc,
						ZEout_ID, read_en_ID, IsMOVZ_ID, xfer_size_ID, clk, reset, setFlag_ID, isZero_accBr, isBLT_ID);
						
	output logic [31:0] instru;
	logic [31:0] instru_EX, instru_MEM, instru_IF;
	output logic overflow, zero, negative, cout,zero_hold, isZero_accBr;
	logic overflow_hold, negative_hold, cout_hold;
	logic overflow_reg, negative_reg, cout_reg, zero_reg;
	input logic BrTaken, UncondBr, Reg2Loc_ID, RegWrite_ID,  MemWrite_ID, MemToReg_ID, 
					ZEout_ID, read_en_ID, IsMOVZ_ID, setFlag_ID, isBLT_ID;
					
	logic RegWrite_WB, RegWrite_EX, RegWrite_MEM, MemWrite_EX, MemWrite_MEM, MemToReg_EX, ZEout_EX, ZEout_MEM, read_en_EX, read_en_MEM, setFlag_EX, MemToReg_MEM;
					
	input logic [3:0] xfer_size_ID;
	logic [3:0] xfer_size_EX, xfer_size_MEM;
	input logic [1:0] ALUSrc;
	input logic [2:0] ALUOp_ID;
	logic [2:0] ALUOp_EX;
	input logic clk, reset;
	logic [63:0] ALU_result, ALU_result_reg;
	logic [63:0] ALUSrc_out, ALUSrc_out_Reg, ALU_a_ID, ALU_a_EX, ALU_b_ID, ALU_b_EX;
	
	//regfile logic 
	logic [4:0] Rd, Rm, Rn, Aa, Ab, Rd_WB, Rd_EX, Rd_MEM; // not signed
	logic [63:0] Da, Db_ID, DaReg, Db_EX, Db_MEM, Db;
	logic [63:0] Datamem_out,Datareg_in, Datareg_in_reg;
	

	//Imm12 ZE logic
	logic [63:0] Imm12_ZE;
	logic [11:0] Imm12; // not signed
	zeroEx #(.addrLen(12)) ZEImm (.a(Imm12), .b(Imm12_ZE));
					 
	//Dadder9_SE logic
   logic [63:0] Dadder9_SE;
	logic [8:0] Dadder9;
	signEx #(.addrLen(9)) SEDaddr (.a(Dadder9), .b(Dadder9_SE));
	
	// MOVZ and MOVK
	logic [1:0] shiftamt;
	logic [63:0] shiftbit;
	logic [63:0] shiftnmsk, shiftmsk,finalmsk;
	logic [15:0] Imm16;
	logic [63:0] MOVZ_val,MOVK_val,MOV_val;
	logic test_result_MEM;
	logic [63:0] PC, PC_ID, noBr_out, Br_out, Br_out_EX;
	logic [63:0] ex_CondAddr, ex_BrAddr, shifted_Br, uncondBr_out;
	logic direct_flag;
	logic [1:0] ALUSrc_a, ALUSrc_b;
	logic BrTaken_EX;
	
	assign Imm12 = instru[21:10];
	assign Imm16 = instru[20:5];
	assign Dadder9 = instru[20:12];
	assign shiftamt = instru[22:21];
	assign Rn = instru[9:5];
	assign Rm = instru[20:16];
	assign Rd = instru[4:0];
	
	

	
	
	

	// ### IF ###
	fetchInstru IF (instru_IF, clk, reset, PC, Br_out, BrTaken);
	
	
	// IF/ID registers
	DFF_VAR #(.size(64)) L1_PC_reg (PC_ID, PC, reset, clk, 1'b1);
	DFF_VAR #(.size(32)) L1_Instru_reg (instru, instru_IF, reset, clk, 1'b1);
	
	
	
	
	
	
	
	
	
	
	
	
	// ### ID ###
	mux2to1_5bit m_reg2loc (.out(Ab), .i0(Rd), .i1(Rm), .sel(Reg2Loc_ID));
	regfile  rgfl (.ReadData1(DaReg), .ReadData2(Db_ID), .WriteData(Datareg_in), 
					 .ReadRegister1(Rn), .ReadRegister2(Ab), .WriteRegister(Rd_WB),
					 .RegWrite(RegWrite_WB), .clk(clk));
	
	// MOVZ and MOVK
	shifter sft1 (.value({62'd0,shiftamt}), .direction(1'b0), .distance(6'd4), .result(shiftbit));
	shifter sft2 (.value(64'hffff), .direction(1'b0), .distance(shiftbit[5:0]), .result(shiftnmsk));
	shifter sft3 (.value({48'd0,Imm16}), .direction(1'b0), .distance(shiftbit[5:0]), .result(MOVZ_val));

	genvar i; // loop through all 64 bits
   generate
		for(i = 0;i<64;i++)begin: Not
			not #0.05 (shiftmsk[i],shiftnmsk[i]);
			and #0.05 (finalmsk[i],shiftmsk[i],Db_ID[i]);
			or #0.05 (MOVK_val[i],finalmsk[i],MOVZ_val[i]);
		end
   endgenerate	
	mux2_1 MOVZK (.out(MOV_val), .i0(MOVK_val), .i1(MOVZ_val), .sel(IsMOVZ_ID));
	//ALUSrc logic
   mux4_1 mRegF(.out(ALUSrc_out_Reg), .i00(Db_ID), .i01(Dadder9_SE), .i10(Imm12_ZE), .i11(MOV_val), .sel0(ALUSrc[0]), .sel1(ALUSrc[1]));	
	
	
	
	// CBZ test
	logic isZero;
	test_flag test (Db_ID, isZero_accBr); // isZero_accBr goes to control signal to determine CBZ or not

	// Db
	
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
	alu adder1 (.A(64'd4), .B(PC_ID), .cntrl(3'b010), .result(noBr_out));
	alu adder2 (.A(shifted_Br), .B(PC_ID), .cntrl(3'b010), .result(Br_out));
	mux2_1 BrTakenChoose (.out(PC), .i0(noBr_out), .i1(Br_out), .sel(BrTaken));
	*/
	// brTaken path
	// SE
	signEx #(.addrLen(19))  SE (.a(instru[23:5]), .b(ex_CondAddr));
	signEx #(.addrLen(26))  SE2 (.a(instru[25:0]), .b(ex_BrAddr));
	mux2_1 UncondBrChoose (.out(uncondBr_out), .i0(ex_CondAddr), .i1(ex_BrAddr), .sel(UncondBr));
	shifter superShifter (.value(uncondBr_out), .direction(1'b0), .distance(6'b000010), .result(shifted_Br));
	
	// address of branch target
	alu adder2 (.A(shifted_Br), .B(PC_ID), .cntrl(3'b010), .result(Br_out));
	
	
	
	
	
	
	
	
	forwardingUnit fw (setFlag_EX, isBLT_ID, RegWrite_EX, Rd_EX, RegWrite_MEM, Rd_MEM, Rn, Rm, ALUSrc_a, ALUSrc_b, direct_flag);
	// alusrc_a mux
	mux4_1 alusrc_a_mux (ALU_a_ID, DaReg, ALU_result_reg, Datamem_out, 64'd0, ALUSrc_a[0], ALUSrc_a[1]); // has a garbage port
	// alusrc_b mux
	mux4_1 alusrc_b_mux (ALU_b_ID, ALUSrc_out_Reg, ALU_result_reg, Datamem_out, 64'd0, ALUSrc_b[0], ALUSrc_b[1]); // has a garbage port
	
	
	
	// ID/EX
	DFF_VAR #(.size(64)) L2_br_out_register (Br_out_EX, Br_out, reset, clk, 1'b1);
	DFF_en L2_brtaken_register (BrTaken_EX, BrTaken, reset, clk, 1'b1);
	
	DFF_VAR #(.size(64)) L2_alu_a_register (ALU_a_EX, ALU_a_ID, reset, clk, 1'b1);
	DFF_VAR #(.size(64)) L2_alu_b_register (ALU_b_EX, ALU_b_ID, reset, clk, 1'b1);
	DFF_VAR #(.size(64)) L2_ALUSrc_input_register (ALUSrc_out, ALUSrc_out_Reg, reset, clk, 1'b1);
	DFF_VAR #(.size(5))  L2_Rd_register (Rd_EX, Rd, reset, clk, 1'b1);
	DFF_VAR #(.size(4))  L2_xfersize_register (xfer_size_EX, xfer_size_ID, reset, clk, 1'b1);
	DFF_VAR #(.size(64)) L2_Db_register (Db_EX, Db_ID, reset, clk, 1'b1);
	
	DFF_VAR #(.size(32)) L2_instru_register (instru_EX, instru, reset, clk, 1'b1);
	// signals
	DFF_en L2r1 (RegWrite_EX, RegWrite_ID, reset, clk, 1'b1);
	DFF_en L2r2 (MemWrite_EX, MemWrite_ID, reset, clk, 1'b1);
	DFF_en L2r3 (MemToReg_EX, MemToReg_ID, reset, clk, 1'b1);
	DFF_en L2r4 (ZEout_EX, ZEout_ID, reset, clk, 1'b1);
	DFF_en L2r5 (read_en_EX, read_en_ID, reset, clk, 1'b1);
	DFF_en L2r6 (setFlag_EX, setFlag_ID, reset, clk, 1'b1);
	DFF_VAR #(.size(3)) L2r7 (ALUOp_EX, ALUOp_ID, reset, clk, 1'b1);
	
	// data for forwarding test
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// ### EX ###
	
	// ALU
	alu a1 (.A(ALU_a_EX), .B(ALU_b_EX), .cntrl(ALUOp_EX), .result(ALU_result_reg), .negative(negative_hold), .zero(zero_hold), .overflow(overflow_hold), .carry_out(cout_hold));
	// setFlag
	DFF_en setNeg (negative_reg, negative_hold, reset, clk, setFlag_EX);
	DFF_en setZ (zero_reg, zero_hold, reset, clk, setFlag_EX);
	DFF_en setOverflow (overflow_reg, overflow_hold, reset, clk, setFlag_EX);
	DFF_en setCout (cout_reg, cout_hold, reset, clk, setFlag_EX);
	
	// flags forwarding for BLT edge case
	mux2to1_bit mux21_Neg (negative, negative_reg, negative_hold, direct_flag);
	mux2to1_bit mux21_z (zero, zero_reg, negative_hold, direct_flag);
	mux2to1_bit mux21_of (overflow, overflow_reg, negative_hold, direct_flag);
	mux2to1_bit mux21_co (cout, cout_reg, negative_hold, direct_flag);

	
	
	
	// EX/MEM
	DFF_VAR #(.size(64)) L3_Db_register (Db_MEM, Db_EX, reset, clk, 1'b1);
	DFF_VAR #(.size(64)) L3_ALUresult_register (ALU_result, ALU_result_reg, reset, clk, 1'b1);
	DFF_VAR #(.size(5))  L3_Rd_register (Rd_MEM, Rd_EX, reset, clk, 1'b1);
	DFF_VAR #(.size(4))  L3_xfersize_register (xfer_size_MEM, xfer_size_EX, reset, clk, 1'b1);
	DFF_VAR #(.size(32)) L3_instru_register (instru_MEM, instru_EX, reset, clk, 1'b1);
	// flag_registers
	
	// signals
	DFF_en L3r1 (RegWrite_MEM, RegWrite_EX, reset, clk, 1'b1);
	DFF_en L3r2 (MemWrite_MEM, MemWrite_EX, reset, clk, 1'b1);
	DFF_en L3r3 (MemToReg_MEM, MemToReg_EX, reset, clk, 1'b1);
	DFF_en L3r4 (ZEout_MEM, ZEout_EX, reset, clk, 1'b1);
	DFF_en L3r5 (read_en_MEM, read_en_EX, reset, clk, 1'b1);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// ### MEM ###
	
	logic [63:0] Dmem1, Dmem0;
	datamem dm (.address(ALU_result), .write_enable(MemWrite_MEM), .write_data(Db_MEM), .clk, .xfer_size(xfer_size_MEM), .read_data(Dmem0), .read_enable(read_en_MEM));
	zeroEx #(.addrLen(8)) ZEDm (.a(Dmem0[7:0]), .b(Dmem1));
	mux2_1 dataMemOut (.out(Datamem_out), .i0(Dmem0), .i1(Dmem1), .sel(ZEout_MEM));
	
	// Mem to Reg logic
	mux2_1 Mem2Reg(.out(Datareg_in_reg), .i0(ALU_result), .i1(Datamem_out), .sel(MemToReg_MEM));
	
	// MEM/WB
	DFF_VAR #(.size(64))  L4_MemtoReg_register (Datareg_in, Datareg_in_reg, reset, clk, 1'b1);
	DFF_VAR #(.size(5))  L4_Rd_register (Rd_WB, Rd_MEM, reset, clk, 1'b1);
	// signals
	DFF_en L4r1 (RegWrite_WB, RegWrite_MEM, reset, clk, 1'b1);

endmodule
