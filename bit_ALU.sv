`timescale 1ns/10ps
module bit_ALU(S0,S1,S2,A,B,Cin,Cout,out);
 input logic A,B,S0,S1,S2,Cin;
 output logic Cout,out;
 logic sum;
 logic nB,Bin,AND,OR,XOR,outA,outB;

 not #0.05 (nB,B);
 mux2to1_bit m1 (.out(Bin), .i0(B), .i1(nB), .sel(S0));
 fulladder fa (.A(A),.B(Bin),.Cin(Cin),.sum(sum),.Cout(Cout));
 and #0.05 (AND,A,B);
 or #0.05 (OR,A,B);
 xor #0.05 (XOR,A,B);
 mux4to1_bit m2(.out(outA), .i00(B), .i01(sum), .i10(sum), .i11(sum), .sel0(S0), .sel1(S1));
 mux4to1_bit m3(.out(outB), .i00(AND), .i01(OR), .i10(XOR), .i11(OR), .sel0(S0), .sel1(S1));
 mux2to1_bit m4 (.out(out), .i0(outA), .i1(outB), .sel(S2));
endmodule 



module tb_bit_ALU();

logic S0,S1,S2,A,B,Cin,Cout,out;

bit_ALU dut (.S0,.S1,.S2,.A,.B,.Cin,.Cout,.out);

initial begin
 S0 = 0; S1 = 0; S2 = 0; A = 0; B = 0; Cin = 0; #1000; 
 S0 = 0; S1 = 1; A = 0; B = 0; Cin = 0; #1000; 
 A = 1; B = 0; Cin = 0; #1000; 
 A = 1; B = 0; Cin = 0; #1000; 
 A = 0; B = 1; Cin = 0; #1000; 
 A = 0; B = 1; Cin = 0; #1000; 
 S0 = 1; Cin = 1; #1000;
 A= 1; B= 1; #1000;
 {S0,S1,S2} = 3'b000; #1000;
 {S2,S1,S0} = 3'b010; #1000;
 {S2,S1,S0} = 3'b011; #1000;
 {S2,S1,S0} = 3'b100; #1000;
 {S2,S1,S0} = 3'b101; #1000;
 {S2,S1,S0} = 3'b110; #1000;
end

endmodule 