`timescale 1ns/10ps
module decoder3_8(in, out, en);

input [2:0] in;
input en;
output [7:0] out;

wire in00,in01,in02;

not #0.05 n1 (in00,in[0]);
not #0.05 n2 (in01,in[1]);
not #0.05 n3 (in02,in[2]);

and #0.05 a1 (out[0],in00,in01,in02, en);
and #0.05 a2 (out[1],in[0],in01,in02, en);
and #0.05 a3 (out[2],in00,in[1],in02, en);
and #0.05 a4 (out[3],in[0],in[1],in02, en);
and #0.05 a5 (out[4],in00,in01,in[2], en);
and #0.05 a6 (out[5],in[0],in01,in[2], en);
and #0.05 a7 (out[6],in00,in[1],in[2], en);
and #0.05 a8 (out[7],in[0],in[1],in[2], en);

endmodule


module decoder_3to8_test;
reg [2:0] in;
reg en;
wire [7:0] out;

decoder3_8 test (.in, .out, .en);

initial begin
	en = 1;
	in = 3'b000; #300;
	in = 3'b001; #300;
	in = 3'b010; #300;
	in = 3'b011; #300;
	in = 3'b100; #300;
	in = 3'b101; #300;
	in = 3'b110; #300;
	in = 3'b111; #300;
	en = 0;
	in = 3'b000; #300;
	in = 3'b001; #300;
	in = 3'b010; #300;
	in = 3'b011; #300;
	in = 3'b100; #300;
	in = 3'b101; #300;
	in = 3'b110; #300;
	in = 3'b111; #300;

 end

endmodule