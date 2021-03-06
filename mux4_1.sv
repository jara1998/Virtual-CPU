// basic mux module, choose from 4 inputs with 2 select wire
// assembled by 3 2by1 muxes
module mux4_1(out, i00, i01, i10, i11, sel0, sel1);
 output logic [63:0]out;
 input logic [63:0]i00, i01, i10, i11;
 input logic sel0, sel1;

 logic [63:0] v0, v1;

 mux2_1 m0(.out(v0), .i0(i00), .i1(i01), .sel(sel0));
 mux2_1 m1(.out(v1), .i0(i10), .i1(i11), .sel(sel0));
 mux2_1 m (.out(out), .i0(v0), .i1(v1), .sel(sel1));
endmodule

// 4 to 1 mux for 1 bit, uses same algorithm
module mux4to1_bit(out, i00, i01, i10, i11, sel0, sel1);
 output logic out;
 input logic i00, i01, i10, i11;
 input logic sel0, sel1;

 logic v0, v1;

 mux2to1_bit m0(.out(v0), .i0(i00), .i1(i01), .sel(sel0));
 mux2to1_bit m1(.out(v1), .i0(i10), .i1(i11), .sel(sel0));
 mux2to1_bit m (.out(out), .i0(v0), .i1(v1), .sel(sel1));
endmodule

module mux4_1_testbench();
 logic [63:0]i00, i01, i10, i11;
 logic sel0, sel1;
 logic [63:0]out;

 mux4_1 dut (.out, .i00, .i01, .i10, .i11, .sel0, .sel1);

 integer i;
 initial begin
 sel1=0;sel0=0; i00=64'd100; i01=64'b0; i10=64'b10; i11=64'b0; #10;
 sel1=0;sel0=0; i00=64'd7; i11=64'b1; #10;
 sel1=0;sel0=0; i01=64'd111; i10=64'b0; #10;
 sel1=0; sel0=0; i10=64'd1; i11=64'b1; #10;
 sel1=1;sel0=1; i10=64'b0010; i11=64'b0011; #10;
 sel1=1;sel0=1; i00=64'b0; i01=64'b1; #10;
 sel1=0;sel0=1; i10=64'b100; i11=64'b0010; #10;
 sel1=0;sel0=1; i00=64'b1; i11=64'b1; #10;
 end
endmodule 