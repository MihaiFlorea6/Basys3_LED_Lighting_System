module pwm_led(
    input clk,
    input [3:0] brightness, 
    output reg led_out
);

reg [3:0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;
    led_out <= (counter < brightness);
end

endmodule
