`timescale 1ns/10ps
module control (instru, BrTaken, UncondBr, overflow, zero, zero_hold, negative, cout, 
						Reg2Loc, RegWrite, MemWrite, MemToReg, ALUOp, ALUSrc,
						ZEout, read_en, IsMOVZ, xfer_size, setFlag, isZero_accBr, isBLT, isMOV_ID);
	input logic [31:0] instru;
	input logic overflow, zero, zero_hold, negative, cout, isZero_accBr;
	output logic BrTaken, UncondBr, Reg2Loc, RegWrite, MemWrite, MemToReg, ZEout, read_en, IsMOVZ, setFlag, isBLT, isMOV_ID;
	output logic [3:0] xfer_size;
	output logic [1:0] ALUSrc;
	output logic [2:0] ALUOp;
	logic Br_decision;
	
	
	xor #0.05 (Br_decision, overflow, negative);
	
	
	always_comb begin
		casex (instru[31:21])
			default: begin
				RegWrite = 0;
				isMOV_ID = 0;
			end
			// ADDI
			11'b1001000100x: begin
				ALUOp = 3'b010;
				ALUSrc = 2'b10;
				MemToReg = 0;
				RegWrite = 1;
				Reg2Loc = 1'bx;
				MemWrite = 0;
				UncondBr = 1'bx;
				BrTaken = 0;
				// new cntr signals
				xfer_size = 4'bxxxx;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'bx;
				setFlag = 1'b0;
				isBLT = 1'b0;
				isMOV_ID = 0;
				end
			// ADDS
			11'b10101011000: begin
				ALUOp = 3'b010;
				ALUSrc = 2'b00;
				MemToReg = 0;
				RegWrite = 1;
				Reg2Loc = 1'b1;
				MemWrite = 0;
				UncondBr = 1'bx;
				BrTaken = 0;
				// new cntr signals
				xfer_size = 4'bxxxx;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'bx;
				setFlag = 1'b1;
				isBLT = 1'b0;
				isMOV_ID = 0;
				end
			
			// B Imm26
			11'b000101xxxxx: begin
				ALUOp = 3'bxxx;
				ALUSrc = 2'bxx;
				MemToReg = 1'bx;
				RegWrite = 0;
				Reg2Loc = 1'bx;
				MemWrite = 0;
				UncondBr = 1'b1;
				BrTaken = 1;
				// new cntr signals
				xfer_size = 4'bxxxx;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'bx;
				setFlag = 1'b0;
				isBLT = 1'b0;
				isMOV_ID = 0;
				end
			
			// B.LT
			11'b01010100xxx: begin
				ALUOp = 3'bxxx;
				ALUSrc = 2'bxx;
				MemToReg = 1'bx;
				RegWrite = 0;
				Reg2Loc = 1'bx;
				MemWrite = 0;
				UncondBr = 1'b0;
				BrTaken = Br_decision;
				// new cntr signals
				xfer_size = 4'bxxxx;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'bx;
				setFlag = 1'b0;
				isBLT = 1'b1;
				isMOV_ID = 0;
				end
			
			// CBZ Rd, Imm19
			11'b10110100xxx: begin
				ALUOp = 3'b000;
				ALUSrc = 2'b00;
				MemToReg = 1'bx;
				RegWrite = 0;
				Reg2Loc = 1'b0;
				MemWrite = 0;
				UncondBr = 1'b0;
				BrTaken = isZero_accBr;
				// new cntr signals
				xfer_size = 4'bxxxx;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'bx;
				setFlag = 1'b0;
				isBLT = 1'b0;
				isMOV_ID = 0;
				end
			
			// LDUR
			11'b11111000010: begin
				ALUOp = 3'b010;
				ALUSrc = 2'b01;
				MemToReg = 1;
				RegWrite = 1;
				Reg2Loc = 1'bx;
				MemWrite = 0;
				UncondBr = 1'bx;
				BrTaken = 0;
				// new cntr signals
				xfer_size = 4'b1000;
				ZEout = 1'b0;
				read_en = 1;
				IsMOVZ = 1'bx;
				setFlag = 1'b0;
				isBLT = 1'b0;
				isMOV_ID = 0;
				end
			
			// LDURB
			11'b00111000010: begin
				ALUOp = 3'b010;
				ALUSrc = 2'b01;
				MemToReg = 1;
				RegWrite = 1;
				Reg2Loc = 1'bx;
				MemWrite = 0;
				UncondBr = 1'bx;
				BrTaken = 0;
				// new cntr signals
				xfer_size = 4'b0001;
				ZEout = 1'b1;
				read_en = 1;
				IsMOVZ = 1'bx;
				setFlag = 1'b0;
				isBLT = 1'b0;
				isMOV_ID = 0;
				end
			
			// MOVK
			11'b111100101xx: begin
				ALUOp = 3'b000;
				ALUSrc = 2'b11;
				MemToReg = 0;
				RegWrite = 1;
				Reg2Loc = 1'b0;
				MemWrite = 0;
				UncondBr = 1'bx;
				BrTaken = 0;
				// new cntr signals
				xfer_size = 4'bxxxx;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'b0; // do movk path
				setFlag = 1'b0;
				isBLT = 1'b0;
				isMOV_ID = 1;
				end
			
			// MOVZ
			11'b110100101xx: begin
				ALUOp = 3'b000;
				ALUSrc = 2'b11;
				MemToReg = 0;
				RegWrite = 1;
				Reg2Loc = 1'b0;
				MemWrite = 0;
				UncondBr = 1'bx;
				BrTaken = 0;
				// new cntr signals
				xfer_size = 4'bxxxx;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'b1;
				setFlag = 1'b0;
				isBLT = 1'b0;
				isMOV_ID = 1;
				end
			
			// STUR
			11'b11111000000: begin
				ALUOp = 3'b010;
				ALUSrc = 2'b01;
				MemToReg = 1'bx;
				RegWrite = 0;
				Reg2Loc = 1'b0;
				MemWrite = 1;
				UncondBr = 1'bx;
				BrTaken = 0;
				// new cntr signals
				xfer_size = 4'b1000;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'bx;
				setFlag = 1'b0;
				isBLT = 1'b0;
				isMOV_ID = 0;
				end
			
			// STURB
			11'b00111000000: begin
				ALUOp = 3'b010;
				ALUSrc = 2'b01;
				MemToReg = 1'bx;
				RegWrite = 0;
				Reg2Loc = 1'b0;
				MemWrite = 1;
				UncondBr = 1'bx;
				BrTaken = 0;
				// new cntr signals
				xfer_size = 4'b0001;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'bx;
				setFlag = 1'b0;
				isBLT = 1'b0;
				isMOV_ID = 0;
				end
			
			// SUBS
			11'b11101011000: begin
				ALUOp = 3'b011;
				ALUSrc = 2'b00;
				MemToReg = 0;
				RegWrite = 1;
				Reg2Loc = 1'b1;
				MemWrite = 0;
				UncondBr = 1'bx;
				BrTaken = 0;
				// new cntr signals
				xfer_size = 4'bxxxx;
				ZEout = 1'bx;
				read_en = 0;
				IsMOVZ = 1'bx;
				setFlag = 1'b1;
				isBLT = 1'b0;
				isMOV_ID = 0;
				end
		endcase
	end
endmodule
			