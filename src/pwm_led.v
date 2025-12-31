/*------------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: pwm_led.v
Description: Simple PWM generator for LED brightness control.
------------------------------------------------------------------*/

module pwm_led(
    input wire i_clk,
    input wire [3:0] i_brightness, 
    output reg o_led_out
);

reg [3:0] r_counter = 0;

always @(posedge i_clk) begin
    r_counter <= r_counter + 1;
    o_led_out <= (r_counter < i_brightness) ? 1'b1 : 1'b0;
end

endmodule