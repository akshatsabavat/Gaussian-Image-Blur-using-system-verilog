`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2023 20:21:54
// Design Name: 
// Module Name: fileModule
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


module fileModule(
input clk,
input trigger,
input [31:0] din,
input [4:0] address,
output reg [31:0] dout
    );
    
    reg [31:0]mem[0:25]; 
    
    initial
        $readmemh("digits.txt", mem, 0, 25);
    always@ (posedge clk)
    begin
    if (trigger)
        mem[address] <= din;
    else
        dout <= mem[address];
   end
    
endmodule
