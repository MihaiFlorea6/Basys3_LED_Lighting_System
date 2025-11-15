module top_module(
    input clk,               
    input rst,               
    input btn_hours,         
    input btn_minutes,       
    output [6:0] seg,        
    output [3:0] an,         
    output [15:0] leds        
);

    // Clock 1Hz
    wire clk_1hz;
    clock_divider clkdiv_inst (
        .clk(clk),
        .rst(rst),
        .clk_1hz(clk_1hz)
    );

    // Debounce butoane
    wire btn_h_clean, btn_m_clean;
    debounce db_hour (
        .clk(clk),
        .btn_in(btn_hours),
        .btn_out(btn_h_clean)
    );

    debounce db_min (
        .clk(clk),
        .btn_in(btn_minutes),
        .btn_out(btn_m_clean)
    );

    // Ore și minute
    wire [5:0] hours;
    wire [5:0] minutes;
    clock_logic clock_inst (
        .clk_1hz(clk_1hz),
        .rst(rst),
        .inc_hours(btn_h_clean),
        .inc_minutes(btn_m_clean),
        .hours(hours),
        .minutes(minutes)
    );

    // Cifre pentru SSD
    wire [3:0] d0 = minutes % 10;
    wire [3:0] d1 = minutes / 10;
    wire [3:0] d2 = hours   % 10;
    wire [3:0] d3 = hours   / 10;

    // Afișaj pe SSD
    ssd_multiplex display_inst (
        .clk(clk),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .seg(seg),
        .an(an)
    );

    // LED CONTROLLER
    wire [3:0] pwm_value;
    wire use_animation;

    led_controller led_ctrl (
        .clk(clk),
        .rst(rst),
        .hour(hours),
        .pwm_value(pwm_value),
        .use_animation(use_animation)
    );

    // LED ANIMATOR pentru ora 03:00
    wire [15:0] anim_leds;
    led_animator animator (
        .clk(clk),
        .rst(rst),
        .led_pattern(anim_leds)
    );

    // PWM pentru LED-uri
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : pwm_loop
            pwm_led pwm_inst (
    .clk(clk),
    .brightness(
        use_animation ? ( anim_leds[i] ? 4'd8 : 4'd0  ) : pwm_value),
    .led_out(leds[i])
);
        end
    endgenerate

endmodule
