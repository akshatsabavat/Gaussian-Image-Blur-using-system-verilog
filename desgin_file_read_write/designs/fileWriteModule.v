`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2023 21:01:11
// Design Name: 
// Module Name: fileWriteModule
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


module fileWriteModule(
input clk,
input rst,
output [7:0] count
    );
    
    reg [7:0] count;
    
    always@ (posedge clk or posedge rst)
    begin
    if (rst)
    count <= 8'b0;
    
    else begin
    if(count < 30)
    count <= count + 1;
    else
    count <= 8'b0;
    end
    end
    
endmodule
