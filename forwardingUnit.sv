module forwardingUnit(setFlag_EX, isBLT_ID, RegWrite_EX, Rd_EX, RegWrite_MEM, Rd_MEM, Rn, Rm, ALUSrc_a, ALUSrc_b, direct_flag, isMOV_ID, Rd, Db_forward_ID);
input logic [4:0] Rd_EX, Rd_MEM, Rn, Rm, Rd;
input logic isBLT_ID, RegWrite_EX, RegWrite_MEM, setFlag_EX, isMOV_ID;
output logic [1:0] ALUSrc_a, ALUSrc_b, Db_forward_ID;
output logic direct_flag;


	always_comb begin
		// forward data for Rn
		if (Rn == 5'b11111) begin
			ALUSrc_a = 2'd0;
		end
		// data in last cycle 
		else if ((Rn == Rd_EX) && (RegWrite_EX)) begin
			ALUSrc_a = 2'd1;
		end
		
		else if ((Rn == Rd_MEM) && (RegWrite_MEM)) begin
			ALUSrc_a = 2'd2;
		end
		else begin
			ALUSrc_a = 2'd0;
		end
		
		
		
		// forward data for Rm
		if (Rm == 5'b11111) begin
			ALUSrc_b = 2'd0;
		end
		// data in last cycle 
		else if (((Rm == Rd_EX) && (RegWrite_EX)) || ((Rd == Rd_EX) && (RegWrite_EX) && isMOV_ID)) begin
			ALUSrc_b = 2'd1;
		end
		
		else if (((Rm == Rd_MEM) && (RegWrite_MEM)) || ((Rd == Rd_MEM) && (RegWrite_MEM) && isMOV_ID)) begin
			ALUSrc_b = 2'd2;
		end
		else begin
			ALUSrc_b = 2'd0;
		end
		
		
		// forward data for Rd (Db)
		if (Rd == 5'b11111) begin
			Db_forward_ID = 0;
		end
		// data in last cycle 
		else if ((Rd == Rd_EX) && (RegWrite_EX)) begin
			Db_forward_ID = 1;
		end
		
		else if ((Rd == Rd_MEM) && (RegWrite_MEM)) begin
			Db_forward_ID = 2;
		end
		else begin
			Db_forward_ID = 0;
		end
		
		
		
		// B.LT and last cycle is subs or adds
		if (setFlag_EX & isBLT_ID) begin
			direct_flag = 1;
		end
		else begin
			direct_flag = 0;
		end
		
		
	end
endmodule 