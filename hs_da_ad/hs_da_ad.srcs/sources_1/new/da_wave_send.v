`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/26 14:43:13
// Design Name: 
// Module Name: da_wave_send
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


module da_wave_send(
    input                 clk    ,  //时钟
    input                 rst_n  ,  //复位信号，低电平有效
    input		 [1:0]	  show_mode,//1：正弦波；2：方波；3：三角波
	input		 [9:0]    show_freq,//100hz~1000hz,步进100hz
	input		 [1:0]	  show_amp,//0:1倍；1:1/2倍；2：1/4倍；3：1/8倍
	input        [1:0]    show_zkb,//1:10%;2:50%;3:80%
    //DA芯片接口
    output                da_clk ,  //DA(AD9708)驱动时钟,最大支持125Mhz时钟
    output    reg[7:0]    da_data   //输出给DA的数据  
    );


//reg define
reg    [9:0]    freq_cnt  ;    //频率调节计数器
reg    [7:0]    rd_data;   
reg    [7:0]    fangbo_data;    
wire   [7:0]    sin_data;
wire   [7:0]    sanjiao_data;
reg    [9:0]    rd_addr;       //读ROM地址
reg    [9:0]    fangbo_cnt;
reg    [9:0]    sin_addr; 
reg    [9:0]    sanjiao_addr;
reg    [9:0]    duty;
//数据rd_data是在clk的上升沿更新的，所以DA芯片在clk的下降沿锁存数据是稳定的时刻
//而DA实际上在da_clk的上升沿锁存数据,所以时钟取反,这样clk的下降沿相当于da_clk的上升沿
assign  da_clk = ~clk;       

//
always@(*)
begin
	if(~rst_n)
	begin
		sin_addr<=0;
		sanjiao_addr<=0;
	end
	else if(show_mode==1)
		sin_addr<=rd_addr;
	else if(show_mode==3)
		sanjiao_addr<=rd_addr;
	else
	begin
		sin_addr<=0;
		sanjiao_addr<=0;
	end		
end
//
always@(*)
begin
	if(~rst_n)
		rd_data <=0;
	else if(show_mode==1)
		rd_data <=sin_data;
	else if(show_mode==3)
		rd_data <=sanjiao_data;
	else if(show_mode==2)
		rd_data <=fangbo_data;
	else
		rd_data <=0;
end
//
always@(*)
begin
	if(~rst_n)
		da_data <=0;
	else if(show_amp==0)
		da_data <=rd_data;
	else if(show_amp==1)
		da_data <=rd_data/2;
	else if(show_amp==2)
		da_data <=rd_data/4;
	else 
		da_data <=rd_data/8;
end
//方波
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        fangbo_cnt <= 10'd0;
    else begin
        if(freq_cnt == show_freq) begin
			if(fangbo_cnt==100)
				fangbo_cnt <= 10'd0;
			else
				fangbo_cnt <= fangbo_cnt + 10'd1;
        end    
    end            
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
         fangbo_data <= 8'd0;
    else if(fangbo_cnt<duty)
		 fangbo_data <= 8'd1000;
	else
		 fangbo_data <= 8'd0;
end

always@(*)
begin
	if(~rst_n)
		duty <=0;
	else begin
		case(show_zkb)
		0:duty<=500;
		1:duty<=100;
		2:duty<=500;
		3:duty<=800;
		default:;
		endcase
	end
end
//频率调节计数器
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        freq_cnt <= 10'd0;
    else if(freq_cnt == show_freq)    
        freq_cnt <= 10'd0;
    else         
        freq_cnt <= freq_cnt + 10'd1;
end

//读ROM地址
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rd_addr <= 10'd0;
    else begin
        if(freq_cnt == show_freq) begin
            rd_addr <= rd_addr + 10'd1;
        end    
    end            
end

//正弦波
rom_sin rom_sin (
  .clka(clk),    // input wire clka
  .addra(sin_addr),  // input wire [9 : 0] addra
  .douta(sin_data)  // output wire [7 : 0] douta
);
//三角波
rom_sanjiao rom_sanjiao (
  .clka(clk),    // input wire clka
  .addra(sanjiao_addr),  // input wire [9 : 0] addra
  .douta(sanjiao_data)  // output wire [15 : 0] douta
);
endmodule
