`timescale 1ns/10ps
module test_flag (Da, final_result);
	input logic [63:0] Da;
	logic [63:0] result;
	output logic final_result;
	 and (result[0],1'b1,Da[0]);
	 genvar i; // loop through all 64 bits
	 generate
			for(i = 1;i<64;i++)begin: ok
				or #0.05 n1 (result[i],result[i-1],Da[i]);
			end
	 endgenerate
	not #0.05 z1 (final_result,result[63]); // assign Zero
endmodule 

module tb_testFlag();
	logic [63:0] Da;
	logic [63:0] result;
	logic final_result;
test_flag dut (.Da,.final_result);

initial begin
 Da = 3'd5; #10;
 Da = 2'd0; #10;
 Da = 3'd4; #10; 
 Da = 2'd0; #10;
end

endmodule 