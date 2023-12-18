`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2023 13:04:00
// Design Name: 
// Module Name: imageSourceControl
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


module imageSourceControl(
input                    i_clk,
input                    i_rst,
input [7:0]              i_pixel_data,
input                    i_pixel_data_valid,
output reg [71:0]        o_pixel_data,
output                   o_pixel_data_valid,
output reg               o_intr
    );
    
      reg [8:0] pixelCounter;
    reg [8:0] readCounter;
    reg [11:0] totalPixelCounter; 
    reg [1:0] currentWriteLineBuffer; // points to the active write pointer of the buffer
    reg [1:0] currentRdLineBuffer; // control signal of multiplexer
    reg [3:0] lineBufferDataValid; // points towards the active data stream
    reg [3:0] lineBufferReadData; // points towards the 3 active buffers to read
    reg read_line_buffer; // interupt
    reg rdState; // checks if line buffers reach 1536 bits, then starts to shift buffers
    
    wire [23:0] lb0data;
    wire [23:0] lb1data;
    wire [23:0] lb2data;
    wire [23:0] lb3data;
    
    localparam IDLE = 'b0,
           RD_BUFFER = 'b1;
    
    // increments counter, unless and until buffer is full
    always @(posedge i_clk)
    begin
        if(i_rst)
            totalPixelCounter <= 0;
        else
        begin
            if(i_pixel_data_valid & !read_line_buffer)
                totalPixelCounter <= totalPixelCounter + 1;
            else if(!i_pixel_data_valid & read_line_buffer)
                totalPixelCounter <= totalPixelCounter - 1;
        end
    end
    
    // responsible for managing the interrupt and setting state, after sufficient data in line buffers
    // sets the control signal
    always @(posedge i_clk)
    begin
        if(i_rst)
        begin
            rdState <= IDLE;
            read_line_buffer <= 1'b0;
            o_intr <= 1'b0;
        end
        else
        begin
            case(rdState)
                IDLE:begin
                    o_intr <= 1'b0;
                    if(totalPixelCounter >= 1536)
                    begin
                        read_line_buffer <= 1'b1;
                        rdState <= RD_BUFFER;
                    end
                end
                RD_BUFFER:begin
                    if(readCounter == 511)
                    begin
                        rdState <= IDLE;
                        read_line_buffer <= 1'b0;
                        o_intr <= 1'b1;
                    end
                end
            endcase
        end
    end
    
    
    always @(posedge i_clk)
    begin
        if(i_rst)
            pixelCounter <= 0;
        else
        begin
            if(i_pixel_data_valid)
                pixelCounter <= pixelCounter + 1;
        end
    end
    
    always @(posedge i_clk)
    begin
        if(i_rst)
            currentWriteLineBuffer <= 0;
        else
        begin
            if(pixelCounter == 511 & i_pixel_data_valid)
                currentWriteLineBuffer <= currentWriteLineBuffer+1;
        end
    end
    
    always @(*)
    begin
        lineBufferDataValid = 4'h0;
        lineBufferDataValid[currentWriteLineBuffer] = i_pixel_data_valid;
    end
    
    always @(posedge i_clk)
    begin
        if(i_rst)
            readCounter <= 0;
        else
        begin
            if(read_line_buffer)
                readCounter <= readCounter + 1;
        end
    end
    
    always @(posedge i_clk)
    begin
        if(i_rst)
        begin
            currentRdLineBuffer <= 0;
        end
        else
        begin
            if(readCounter == 511 & read_line_buffer)
                currentRdLineBuffer <= currentRdLineBuffer + 1;
        end
    end
    
    // another part of multiplexer
    always @(*)
    begin
        case(currentRdLineBuffer)
            0:begin
                o_pixel_data = {lb2data,lb1data,lb0data};
            end
            1:begin
                o_pixel_data = {lb3data,lb2data,lb1data};
            end
            2:begin
                o_pixel_data = {lb0data,lb3data,lb2data};
            end
            3:begin
                o_pixel_data = {lb1data,lb0data,lb3data};
            end
        endcase
    end
    
    // Working of multiplexer
    always @(*)
    begin
        case(currentRdLineBuffer)
            0:begin
                lineBufferReadData[0] = read_line_buffer;
                lineBufferReadData[1] = read_line_buffer;
                lineBufferReadData[2] = read_line_buffer;
                lineBufferReadData[3] = 1'b0;
            end
           1:begin
                lineBufferReadData[0] = 1'b0;
                lineBufferReadData[1] = read_line_buffer;
                lineBufferReadData[2] = read_line_buffer;
                lineBufferReadData[3] = read_line_buffer;
            end
           2:begin
                 lineBufferReadData[0] = read_line_buffer;
                 lineBufferReadData[1] = 1'b0;
                 lineBufferReadData[2] = read_line_buffer;
                 lineBufferReadData[3] = read_line_buffer;
           end  
          3:begin
                lineBufferReadData[0] = read_line_buffer;
                 lineBufferReadData[1] = read_line_buffer;
                 lineBufferReadData[2] = 1'b0;
                 lineBufferReadData[3] = read_line_buffer;
           end        
        endcase
    end

    
    lineBuffer lB0(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_incoming_data(i_pixel_data),
    .i_data_valid(lineBufferDataValid[0]), // controls where to store what pixel in which line buffer
    .i_read_data(lineBufferReadData[0]),
    .o_data(lb0data)
    );
    
    lineBuffer lB1(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_incoming_data(i_pixel_data),
    .i_data_valid(lineBufferDataValid[1]),
    .i_read_data(lineBufferReadData[1]),
    .o_data(lb1ata)
    );
    
    lineBuffer lB2(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_incoming_data(i_pixel_data),
    .i_data_valid(lineBufferDataValid[2]),
    .i_read_data(lineBufferReadData[2]),
    .o_data(lb2data)
    );
    
    lineBuffer lB3(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_incoming_data(i_pixel_data),
    .i_data_valid(lineBufferDataValid[3]),
    .i_read_data(lineBufferReadData[3]),
    .o_data(lb3data)
    );
    
endmodule
