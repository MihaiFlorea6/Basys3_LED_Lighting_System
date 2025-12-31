/*------------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: clock_logic.v
Description: Main RTC (Real Time Clock) logic for Hours and Minutes.
------------------------------------------------------------------*/

module clock_logic(
    input wire i_clk_1hz, // 1Hz Timebase
    input wire i_rst, // Global Reset
    input wire i_inc_hours, // Debounced Hour Increment
    input wire i_inc_minutes, // Debounced Minute Increment
    output reg [5:0] o_hours,
    output reg [5:0] o_minutes
);
    always @(posedge i_clk_1hz or posedge i_rst) begin
        if (i_rst) begin
            o_hours <= 6'd0;
            o_minutes <= 6'd0;
        end else begin
            // Minute Increment Logic
            if (i_inc_minutes) begin
                if (o_minutes == 59)begin
                    o_minutes <= 6'd0;
                    o_hours <= (o_hours == 23) ? 6'd0: o_hours +1;
               end else begin
                    o_minutes <= o_minutes + 1'b1;
               end
            end

            // Hour Increment Logic
            if (i_inc_hours) begin
                if (o_hours == 23)
                    o_hours <= 6'd0;
                else
                    o_hours <= o_hours + 1'd1;
            end
        end
    end
endmodule
