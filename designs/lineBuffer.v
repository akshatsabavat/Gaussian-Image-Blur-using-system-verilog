`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2023 15:57:53
// Design Name: 
// Module Name: lineBuffer
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


module lineBuffer(
input i_clk,
input i_rst,
input [7:0] i_incoming_data,
input i_data_valid,
input i_read_data,
output [23:0] o_data // Cannot have multidemntionl array, says we expect 3 variations of 8 bits, hence 24 bits
    );
    
    reg [7:0] line_buffer [511:0]; // Line buffer, assuming image is 512x512
    reg [8:0] write_pointer;
    reg [8:0] read_pointer;
    
    always @(posedge i_clk)
    begin
        if(i_data_valid)
            line_buffer[write_pointer] <= i_incoming_data;
    end
    
    always @(posedge i_clk)
    begin
        if(i_rst)
            write_pointer <= 'd0;
        else if(i_data_valid)
            write_pointer <= write_pointer + 'd1;
    end
    
    //ensures data is prefetched and available at the output
    assign o_data = {line_buffer[read_pointer], line_buffer[read_pointer+1], line_buffer[read_pointer+2]};
    
    //runs first when the board starts up and initializes the first 3 bit values
    always @(posedge i_clk)
     begin
        if(i_rst)
            read_pointer <= 'd0;
        else if(i_read_data)
            read_pointer <= read_pointer + 'd1;
    end
    
endmodule
