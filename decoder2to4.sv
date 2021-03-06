`timescale 1ns/10ps
module decoder2_4(in, out, en);

input [1:0] in;
input en;
output [3:0] out;
logic not0, not1;

not #0.05 n0 (not0, in[0]);
not #0.05 n1 (not1, in[1]);

and #0.05 a0 (out[0], not0, not1, en);
and #0.05 a1 (out[1], in[0], not1, en);
and #0.05 a2 (out[2], not0, in[1], en);
and #0.05 a3 (out[3], in[0], in[1], en);


endmodule

module decoder_2_4_test;
reg [1:0] in;
wire [3:0] out;
reg en;

decoder2_4 test (.in, .out, .en);

initial begin
 en = 1;
 in = 2'b00; #300;
 in = 2'b01; #300;
 in = 2'b10; #300;
 in = 2'b11; #300;
 in = 2'b00; #300;
 in = 2'b01; #300;
 in = 2'b10; #300;
 in = 2'b11; #300;
 en = 0;
 in = 2'b00; #300;
 in = 2'b01; #300;
 in = 2'b10; #300;
 in = 2'b11; #300;
 in = 2'b00; #300;
 in = 2'b01; #300;
 in = 2'b10; #300;
 in = 2'b11; #300;
 end

endmodule