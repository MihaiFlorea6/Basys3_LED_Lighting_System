/*-----------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: led_animator.v
Description: Generates a 16-bit moving wave pattern for the 03:00
             special lighting mode.
-----------------------------------------------------------------*/

module led_animator(
    input wire i_clk, // 100MHz System Clock
    input wire i_rst, // Global Reset
    output reg [15:0] o_led_pattern // 16-bit output to LEDs
);

    // Timing Configuration
    // 8,000,000 cycles at 100MHz = 80ms step duration
    localparam STEP_DELAY = 24'd8_000_000;

    reg [3:0] r_pos; 
    reg [23:0] r_delay_cnt;

    // Step Counter (Scanning Position)
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_pos <= 4'd0;
            r_delay_cnt <= 24'd0;
        end else begin
            if (r_delay_cnt >= STEP_DELAY) begin
                r_delay_cnt <= 24'd0;
                r_pos <= r_pos + 1'b1; // Auto-wraps at 15
            end else begin
                r_delay_cnt <= r_delay_cnt + 1'b1;
            end
        end
    end

    // Pattern Generation
    // Creates a moving window of 7 active LEDs centered around r_pos
    integer i;
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            // Professional bitwise approach: check if LED 'i' is within +/- 3 of r_pos
            if((i >= r_pos -3 && i <= r_pos + 3))
                o_led_pattern[i] = 1'b1;
            else
                o_led_pattern[i] = 1'b0;    
        end
    end

endmodule
