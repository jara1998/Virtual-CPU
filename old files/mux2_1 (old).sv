`timescale 1ns/10ps
// basic mux module, choose from 2 inputs with 1 select wire
module mux2_1(out, i0, i1, sel);
 output logic [63:0] out;
 input logic [63:0] i0, i1;
 input logic sel;
 logic nsel;
 not #0.05 (nsel,sel);
 logic [63:0]temp1,temp2;
 genvar i; // loop through all 64 bits
 generate
		for(i = 0;i<64;i++) begin: ok
			and #0.05 a1 (temp1[i],sel,i1[i]);
			and #0.05 a2 (temp2[i],nsel,i0[i]);
			or #0.05 o1 (out[i],temp1[i],temp2[i]);
		end
 endgenerate		

endmodule



module mux2_1_testbench();
 logic [63:0]out;
 logic [63:0] i0, i1;
 logic sel;

 mux2_1 dut (.out, .i0, .i1, .sel);

 initial begin
 sel=0; i0=64'b0; i1=64'b0; #200;
 sel=0; i0=64'b0; i1=64'b1; #200;
 sel=0; i0=64'd171; i1=64'b0; #200;
 sel=0; i0=64'd3; i1=64'd1; #200;
 sel=1; i0=64'b0; i1=64'd200; #200;
 sel=1; i0=64'b0; i1=64'd151; #200;
 sel=1; i0=64'b1; i1=64'd90; #200;
 sel=1; i0=64'b1; i1=64'd1; #200;
 end
endmodule 