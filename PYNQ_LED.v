`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/29 11:35:19
// Design Name:
// Module Name: PYNQ_LED
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


module LED (
    input            clk,
    input            rst,
    output reg [3:0] LED
);

    parameter  CNT_LEN = 4;
    reg [25:0] cntr       ;
    reg [ 1:0] cnt4       ;

    always @(posedge clk) begin
        if (rst) begin
            cntr <= 'b0;
        end
        else if (cntr == 26'd49_999_999) begin
            cntr <= 'b0;
        end
        else begin
            cntr <= cntr+1;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            cnt4 <= 2'b0;
        end
        else if (cntr==26'd49_999_999) begin
            if (cnt4 ==3) begin
                cnt4 <= 0;
            end
            else begin
                cnt4 <= cnt4+1;
            end
        end
    end

    always @(cnt4) begin
        case (cnt4)
            2'd0    : LED <= 4'b0001;
            2'd1    : LED <= 4'b0010;
            2'd2    : LED <= 4'b0100;
            2'd3    : LED <= 4'b1000;
            default : LED <= 4'b0000;
        endcase
    end

endmodule
