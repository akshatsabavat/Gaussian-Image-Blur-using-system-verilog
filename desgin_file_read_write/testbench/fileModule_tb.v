`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2023 20:40:48
// Design Name: 
// Module Name: fileModule_tb
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


module fileModule_tb();
    reg clk;
    reg trigger;
    reg [4:0] address;
    reg [31:0] din;
    
    wire [31:0] dout;
    
    fileModule dut(
        .clk(clk),
        .trigger(trigger),
        .dout(dout),
        .address(address),
        .din(din)
    );
    
    initial begin
    clk = 0; trigger = 1;
    address = 0; din = 0;
    
    #100 trigger = 0;
    #100 address = 5'd1;
    #110 address = 5'd2;
    #120 address = 5'd3;
    #130 address = 5'd4;
    #140 address = 5'd5;
    #150 address = 5'd25;
    end
    
    always #5 clk = ~clk;
    
endmodule
