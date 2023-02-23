`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/26 14:13:06
// Design Name: 
// Module Name: hs_da_ad
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


module hs_da_ad(
    input                 sys_clk     ,  //系统时钟
    input                 sys_rst_n   ,  //系统复位，低电平有效
    input		 [1:0]	  show_mode,//1：正弦波；2：方波；3：三角波
	input		 [9:0]    show_freq,//100hz~1000hz,步进100hz
	input		 [1:0]	  show_amp,//0:1倍；1:1/2倍；2：1/4倍；3：1/8倍
	input        [1:0]    show_zkb,//1:10%;2:50%;3:80%	
    //DA芯片接口
    output                da_clk      ,  //DA(AD9708)驱动时钟,最大支持125Mhz时钟
    output    [7:0]       da_data       //输出给DA的数据
    //AD芯片接口
   // input     [7:0]       ad_data     ,  //AD输入数据
    //模拟输入电压超出量程标志(本次试验未用到)
  //  input                 ad_otr      ,  //0:在量程范围 1:超出量程
   // output                ad_clk         //AD(AD9280)驱动时钟,最大支持32Mhz时钟 		
    );


//DA数据发送	
da_wave_send da_wave_send(
    .clk(sys_clk),  
    .rst_n(sys_rst_n),  
    .show_mode(show_mode),
	.show_freq(show_freq),
	.show_amp(show_amp),
	.show_zkb(show_zkb),
    .da_clk(da_clk), 
    .da_data(da_data)    
    );	
	
//AD数据接收
ad_wave_rec ad_wave_rec(
    .clk(sys_clk),  
    .rst_n(sys_rst_n),  
    .ad_data(da_data), 
    .ad_otr(), 
    .ad_clk()       
    );

//ILA采集AD数据
// ila_0  ila_0 (
    // .clk         (ad_clk ), // input wire clk
    // .probe0      (ad_otr ), // input wire [0:0]  probe0  
    // .probe1      (ad_data)  // input wire [7:0]  probe0  
// );
	
endmodule
