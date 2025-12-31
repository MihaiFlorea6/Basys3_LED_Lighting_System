/*-----------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: clock_divider.v
Description: Generates a slow clock tick from the system clock
-----------------------------------------------------------------*/

module clock_divider #(
    parameter p_DIVIDER_VALUE = 26'd50_000_000 // Default for 1Hz from 100MHz
)(
    input wire i_clk,
    input wire i_rst,
    output reg o_clk_1hz
);
    reg [25:0] r_counter;
    
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_counter <= 26'd0;
            o_clk_1hz <= 1'b0;
        end else begin
            if (r_counter >= p_DIVIDER_VALUE -1) begin
                r_counter <= 26'd0;
                o_clk_1hz <= ~o_clk_1hz;
            end else begin
                r_counter <= r_counter + 1'b1;
            end
        end
    end
endmodule
