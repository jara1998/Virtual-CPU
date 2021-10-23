`timescale 1ns/10ps
// basic mux module, choose from 32 inputs with 5 select wire
// assembled by 9 4by1 muxes and a 2by1 mux
module mux32_1(out, in00000, in00001, in00010, in00011, in00100, in00101,in00110,in00111, in01000, in01001, in01010, in01011, in01100, in01101,in01110,in01111,in10000, in10001, in10010, in10011, in10100, in10101,in10110,in10111, in11000, in11001, in11010, in11011, in11100, in11101,in11110,in11111, sel);
 output logic [63:0]out;
 input logic [63:0]in00000, in00001, in00010, in00011, in00100, in00101,in00110,in00111, in01000, in01001, in01010, in01011, in01100, in01101,in01110,in01111,in10000, in10001, in10010, in10011, in10100, in10101,in10110,in10111, in11000, in11001, in11010, in11011, in11100, in11101,in11110,in11111;
 input logic [4:0] sel;

 logic [63:0] v0, v1,v2,v3,v4,v5,v6,v7,v8,v9;

 mux4_1 m0(.out(v0), .i00(in00000), .i01(in00001), .i10(in00010), .i11(in00011), .sel0(sel[0]),.sel1(sel[1]));
 mux4_1 m1(.out(v1), .i00(in00100), .i01(in00101), .i10(in00110), .i11(in00111), .sel0(sel[0]),.sel1(sel[1]));
 mux4_1 m2(.out(v2), .i00(in01000), .i01(in01001), .i10(in01010), .i11(in01011), .sel0(sel[0]),.sel1(sel[1]));
 mux4_1 m3(.out(v3), .i00(in01100), .i01(in01101), .i10(in01110), .i11(in01111), .sel0(sel[0]),.sel1(sel[1]));
 mux4_1 m4(.out(v4), .i00(in10000), .i01(in10001), .i10(in10010), .i11(in10011), .sel0(sel[0]),.sel1(sel[1]));
 mux4_1 m5(.out(v5), .i00(in10100), .i01(in10101), .i10(in10110), .i11(in10111), .sel0(sel[0]),.sel1(sel[1]));
 mux4_1 m6(.out(v6), .i00(in11000), .i01(in11001), .i10(in11010), .i11(in11011), .sel0(sel[0]),.sel1(sel[1]));
 mux4_1 m7(.out(v7), .i00(in11100), .i01(in11101), .i10(in11110), .i11(in11111), .sel0(sel[0]),.sel1(sel[1]));
 mux4_1 m8(.out(v8), .i00(v0), .i01(v1), .i10(v2), .i11(v3), .sel0(sel[2]),.sel1(sel[3]));
 mux4_1 m9(.out(v9), .i00(v4), .i01(v5), .i10(v6), .i11(v7), .sel0(sel[2]),.sel1(sel[3]));
 mux2_1 m10 (.out(out), .i0(v8), .i1(v9), .sel(sel[4]));
endmodule

module mux32_1_testbench();
 logic [63:0]in00000, in00001, in00010, in00011, in00100, in00101,in00110,in00111, in01000, in01001, in01010, in01011, in01100, in01101,in01110,in01111,in10000, in10001, in10010, in10011, in10100, in10101,in10110,in10111, in11000, in11001, in11010, in11011, in11100, in11101,in11110,in11111;
 logic [4:0] sel;

 logic [63:0]out;

 mux32_1 dut (.out, .in00000, .in00001, .in00010, .in00011, .in00100, .in00101, .in00110, .in00111, .in01000, .in01001, .in01010, .in01011, .in01100, .in01101, .in01110, .in01111, .in10000, .in10001, .in10010, .in10011, .in10100, .in10101, .in10110, .in10111, .in11000, .in11001, .in11010, .in11011, .in11100, .in11101, .in11110, .in11111, .sel);

 genvar	i;
 initial begin
 in00000 = 64'd17; in00001=64'd15; in00010=64'd15; in00011=64'd15; in00100=64'd15; in00101=64'd15;in00110=64'd15;in00111=64'd15; in01000=64'd15; in01001=64'd15; in01010=64'd15; in01011=64'd15; in01100=64'd2; in01101=64'd25;in01110=64'd15;in01111=64'd15;in10000=64'd15; in10001=64'd151; in10010=64'd15; in10011=64'd15; in10100=64'd15; in10101=64'd15;in10110=64'd15;in10111=64'd15; in11000=64'd15; in11001=64'd15; in11010=64'd15; in11011=64'd15; in11100=64'd15; in11101=64'd15;in11110=64'd15;in11111=64'd15;sel=5'b11;#1000;
 sel = 5'd0;#1000;
 sel = 5'd13;#1000;

 end
endmodule 