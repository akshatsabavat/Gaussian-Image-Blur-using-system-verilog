`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2023 21:08:14
// Design Name: 
// Module Name: fileWriteModule_tb
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


module fileWriteModule_tb();
    reg clk, rst;
    reg [7:0] buffer[1:30];
    wire [7:0] count;
    integer file;
    integer i; // incrementer

    fileWriteModule dut(
        .clk(clk),
        .rst(rst),
        .count(count)
    );
    
    initial begin
        clk = 1'b0;
        rst = 1'b0;
        
        #10 rst = 1'b0;
    end
    
    always 
    #5 clk = ~clk;
    
    initial begin
        $readmemh("digits1to30", buffer, 1, 29);
        
        for(i = 1; i <= 29; i=i+1)
            begin
            $fwrite(file, "%d ", count);
            end
    end
    
    initial begin
        file=$fopen("WrittenDigits.txt");
    end
    
    initial begin
        #2500 $fdisplay(file);
    end
    
    initial
        #5000 $fclose(file);
    
    initial
        #5000 $stop;
endmodule
