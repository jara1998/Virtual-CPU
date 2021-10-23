`timescale 1ns/10ps
module fulladder(A,B,Cin,sum,Cout);
	input logic A,B,Cin;
	output logic sum,Cout;
	logic temp1,temp2,temp3;
	xor #0.05 x1 (temp1,A,B);
	xor #0.05 x2 (sum,temp1,Cin);
	and #0.05 a1 (temp2, A,B);
	and #0.05 a2 (temp3,temp1,Cin);
	or #0.05 o1 (Cout,temp2,temp3);

endmodule


/*
// testbench for full adder
module tb_fa();
logic A, B, Cin, sum, Cout;

fulladder dut (.A,.B,.Cin,.sum,.Cout);

integer i;
initial begin
	 for(i=0; i<8; i++) begin 
		{A,B,Cin} = i; #300;
	 end

end
endmodule 

// testbench for 2to1 mux(The code for 2to1 mux is at mux2_1 file)
module tb_twomux();
logic out, i1, i0, sel;

mux2to1_bit dut (.out, .i0, .i1, .sel);

integer i;
initial begin
	 for(i=0; i<8; i++) begin 
		{i1,i0,sel} = i; #300;
	 end

end
endmodule 

// testbench for 4to1 mux(The code for 2to1 mux is at mux4_1 file)
module tb_fourmux();
logic out, i00, i01, i10, i11, sel0, sel1;

mux4to1_bit dut (.out, .i00, .i01, .i10, .i11, .sel0, .sel1);

integer i;
initial begin
	 for(i=0; i<64; i++) begin 
		{i00,i01,i10,i11,sel0,sel1} = i; #300;
	 end

end
endmodule 
*/