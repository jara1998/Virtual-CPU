`timescale 1ns/10ps
// the regFile module
module regfile (ReadData1, ReadData2, WriteData, 
					 ReadRegister1, ReadRegister2, WriteRegister,
					 RegWrite, clk);
					 
	input logic [4:0] WriteRegister, ReadRegister1, ReadRegister2;
	input logic RegWrite, clk;
	input logic [63:0] WriteData;
	output logic [63:0] ReadData1, ReadData2;
	
	logic [31:0] dec_out;
	logic clk_INV;
	
	decoder5_32 dec(.in(WriteRegister), .out(dec_out), .en(RegWrite));
	
	//assign regOut[31] = 0; // X31 = 0
	
	logic [31:0][63:0] register_out;
	
	not #0.05 notGate (clk_INV, clk); // advanced regFile
	
	// write data
	genvar i;
	generate 
		
		for (i = 0; i < 31; i++) begin: name2
			D_FF64  DFF64(.q(register_out[i][63:0]), .d(WriteData[63:0]), .reset(1'b0), .clk(clk_INV), .en(dec_out[i]));
		end
	endgenerate
	
	assign register_out[31][63:0] = 0;

	// read data
	// two 64bit 32:1 MUXes, use ReadRegister1, 2 to read ReadData1, 2
	mux32_1 mux1(.out(ReadData1), .in00000(register_out[0][63:0]), .in00001(register_out[1][63:0]), .in00010(register_out[2][63:0]), .in00011(register_out[3][63:0]), .in00100(register_out[4][63:0]), .in00101(register_out[5][63:0]),.in00110(register_out[6][63:0]),.in00111(register_out[7][63:0]), .in01000(register_out[8][63:0]), .in01001(register_out[9][63:0]), .in01010(register_out[10][63:0]), .in01011(register_out[11][63:0]), .in01100(register_out[12][63:0]), .in01101(register_out[13][63:0]),.in01110(register_out[14][63:0]),.in01111(register_out[15][63:0]),.in10000(register_out[16][63:0]), .in10001(register_out[17][63:0]), .in10010(register_out[18][63:0]), .in10011(register_out[19][63:0]), .in10100(register_out[20][63:0]), .in10101(register_out[21][63:0]),.in10110(register_out[22][63:0]),.in10111(register_out[23][63:0]), .in11000(register_out[24][63:0]), .in11001(register_out[25][63:0]), .in11010(register_out[26][63:0]), .in11011(register_out[27][63:0]), .in11100(register_out[28][63:0]), .in11101(register_out[29][63:0]),.in11110(register_out[30][63:0]),.in11111(register_out[31][63:0]), .sel(ReadRegister1));
   mux32_1 mux2(.out(ReadData2), .in00000(register_out[0][63:0]), .in00001(register_out[1][63:0]), .in00010(register_out[2][63:0]), .in00011(register_out[3][63:0]), .in00100(register_out[4][63:0]), .in00101(register_out[5][63:0]),.in00110(register_out[6][63:0]),.in00111(register_out[7][63:0]), .in01000(register_out[8][63:0]), .in01001(register_out[9][63:0]), .in01010(register_out[10][63:0]), .in01011(register_out[11][63:0]), .in01100(register_out[12][63:0]), .in01101(register_out[13][63:0]),.in01110(register_out[14][63:0]),.in01111(register_out[15][63:0]),.in10000(register_out[16][63:0]), .in10001(register_out[17][63:0]), .in10010(register_out[18][63:0]), .in10011(register_out[19][63:0]), .in10100(register_out[20][63:0]), .in10101(register_out[21][63:0]),.in10110(register_out[22][63:0]),.in10111(register_out[23][63:0]), .in11000(register_out[24][63:0]), .in11001(register_out[25][63:0]), .in11010(register_out[26][63:0]), .in11011(register_out[27][63:0]), .in11100(register_out[28][63:0]), .in11101(register_out[29][63:0]),.in11110(register_out[30][63:0]),.in11111(register_out[31][63:0]), .sel(ReadRegister2));
	
endmodule

module regfile_testbench();
logic [4:0] WriteRegister, ReadRegister1, ReadRegister2;
logic RegWrite, clk;
logic [63:0] WriteData;
logic [63:0] ReadData1, ReadData2;

regfile dut  (.ReadData1, .ReadData2, .WriteData, 
					 .ReadRegister1, .ReadRegister2, .WriteRegister,
					 .RegWrite, .clk);
					 
parameter PERIOD = 100; // period = length of clock
 // Make the clock LONG to test
initial begin
 clk <= 0;
 forever #(PERIOD/2) clk = ~clk;
end 
initial begin
	ReadData1 = 64'd172;ReadData2 = 64'd16;WriteRegister = 5'd15;ReadRegister1 = 5'd15; ReadRegister2 = 5'd15; RegWrite = 1;#500
	WriteRegister = 5'd16; #500;
	WriteRegister = 5'd26; #500;
	WriteRegister = 5'd31; #500;
	ReadData1 = 64'd25;ReadData2 = 64'd119;WriteRegister = 5'd17;ReadRegister1 = 5'd17; ReadRegister2 = 5'd26; RegWrite = 1;#500
	WriteRegister = 5'd16; #500;
	WriteRegister = 5'd26; #500;
	WriteRegister = 5'd31; #500;
 end

endmodule