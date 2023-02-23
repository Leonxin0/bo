`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/26 15:32:47
// Design Name: 
// Module Name: tb_hs_da_ad
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
module tb_hs_da_ad(
    );
	reg sys_clk;
	reg sys_rst_n;
	reg [1:0] show_mode;
	reg [9:0] show_freq;
	reg [1:0] show_amp;
	reg [1:0] show_zkb;
	wire da_clk;
	wire [7:0] da_data;
	
	initial begin
		sys_clk = 0;
		sys_rst_n = 0;
		show_mode = 1;
		show_freq = 100;
		show_amp = 1;
		show_zkb=0;
		#60;
		sys_rst_n = 1;
		#8000000;
		show_mode = 3;
		#6000000;
		show_mode = 2;
		show_zkb = 1;
		#8000000;
		show_mode = 1;
		show_amp=2;
		#8000000;
		show_mode = 2;
		show_amp=3;		
	end
	always #10 sys_clk = ~sys_clk;
	
hs_da_ad hs_da_ad(
    .sys_clk(sys_clk),  
    .sys_rst_n(sys_rst_n),  
    .show_mode(show_mode),
	.show_freq(show_freq),
	.show_amp(show_amp),
	.show_zkb(show_zkb),
    .da_clk(da_clk),  
    .da_data(da_data) 
    );	
endmodule
