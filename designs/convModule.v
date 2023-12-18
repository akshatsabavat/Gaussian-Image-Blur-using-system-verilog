`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2023 16:57:56
// Design Name: 
// Module Name: convModule
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


module convModule(
input i_clk,
input [71:0] i_incoming_pixel_data,
input i_pixel_data_valid,
output reg [7:0] o_convolved_data,
output reg o_convolved_data_valid
    );
    
    integer i;
    reg [7:0] kernel [8:0]; // 8 bit wide kernel with a depth of 9 bits, 2-D kernel
    reg [15:0] o_multiplication [8:0]; // 16 bit wide as we multiply 8 bit data of kernel with 8 bit data of pixel
    reg [15:0] sumDataInt;
    reg [15:0] sumData;
    reg o_multiplication_data_valid;
    reg sumData_data_valid;
    reg convolved_data_valid;
    
    initial
    begin
        for(i=0;i<9;i=i+1)
        begin
            kernel[i] = 1;
        end
    end
    
    // Pipelining Level 01
    always @(posedge i_clk)
    begin
        for(i=0;i<=9;i=i+1)
        begin
            o_multiplication[i] = kernel[i]*i_incoming_pixel_data[i*8+:8];
        end
        o_multiplication_data_valid <= i_pixel_data_valid;
    end
    
    always @(*)
    begin
        sumData = 0;
        for(i=0;i<9;i=i+1)
        begin
            sumData = sumData + o_multiplication[i];
        end
    end
    
    // Pipelining Level 02
    always @(i_clk)
    begin
        sumData <= sumDataInt;
        sumData_data_valid <= o_multiplication_data_valid;
    end
    
    // Pipelining Level 03
    always @(posedge i_clk)
    begin
        o_convolved_data <= sumData/9;
        o_convolved_data_valid <= sumData_data_valid;
    end
    
endmodule
