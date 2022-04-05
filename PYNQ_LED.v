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


module led_twinkle (
    input            sys_clk ,
    input            sys_rstn,
    input            BTN1    ,
    input            BTN2    ,
    input            BTN3    ,
    input      [1:0] SW      ,
    output reg [3:0] MonoLED ,
    output reg [2:0] TriLED4 ,
    output reg [2:0] TriLED5
);

    parameter  CNT_LEN       = 4             ;
    parameter  TIMER_COUNTER = 26'd25_000_000; //200ms
    reg [25:0] counter_reg                   ;
    reg [ 1:0] status_led                    ;
    wire [2:0] led_temp4;
    wire [2:0] led_temp5;

    // 计数器 0~24_999_999 200ms
    always @(posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            counter_reg <= 'b0;
        end
        else if (counter_reg < TIMER_COUNTER) begin
            counter_reg <= counter_reg + 1'b1;
        end
        else begin
            counter_reg <= 'b0;
        end
    end

    // 状态更改
    always @(posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            status_led <= 'b0;
        end
        else if (counter_reg == TIMER_COUNTER) begin
            if (status_led < 4) begin
                status_led <= status_led + 1;
            end
           else begin
               status_led <= 0;
           end 
        end
    end

    always @(status_led) begin
        case (status_led)
            2'd0:begin
                MonoLED = 4'b0001;
                TriLED4 = 3'b001;
            end 
            2'd1:begin
                MonoLED = 4'b0010;
                TriLED4 = 3'b010;
            end 
            2'd2: begin
                MonoLED = 4'b0100;
                TriLED4 = 3'b100;
            end 
            2'd3:begin
                MonoLED = 4'b1000;
                TriLED4 = 3'b111;
            end 
            default : MonoLED = 4'b0000;
        endcase
    end

    assign led_temp5 = (2'b0 == SW[1:0]) ? 3'b000:
                       (2'b01 == SW[1:0]) ? 3'b001:
                       (2'b10 == SW[1:0]) ? 3'b010 :
                       (2'b11 == SW[1:0]) ? 3'b100 : 3'b111;
                       
    always @(posedge sys_clk) begin
        TriLED5 <= led_temp5;
    end

endmodule


module key_debounce (
    input sys_clk,
    input sys_rstn,
    input key,
    output key_out
);

parameter DEBOUNCE_COUNT = 26'd5000_0000;
reg [1:0] key_out;

always @(posedge sys_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        key_out <= 2'b0;
    end
    else begin
        key_out <= 
    end
end
    
endmodule