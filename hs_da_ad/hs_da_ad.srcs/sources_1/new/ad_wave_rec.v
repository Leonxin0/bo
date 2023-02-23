`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/26 15:24:21
// Design Name: 
// Module Name: ad_wave_rec
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


module ad_wave_rec(
    input                 clk         ,  //时钟
    input                 rst_n       ,  //复位信号，低电平有效
    input         [7:0]   ad_data     ,  //AD输入数据
    //模拟输入电压超出量程标志(本次试验未用到)
    input                 ad_otr      ,  //0:在量程范围 1:超出量程
    output   reg          ad_clk         //AD(TLC5510)驱动时钟,最大支持20Mhz时钟
    );
//时钟分频(2分频,时钟频率为25Mhz),产生AD时钟
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        ad_clk <= 1'b0;
    else 
        ad_clk <= ~ad_clk; 
end  	
endmodule
