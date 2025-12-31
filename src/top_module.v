/*-----------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: top_module.v
Description: Top-level integration of the adaptive lighting system.
             Features: 24h RTC, PWM Dimming, 7-Segment Multiplexing
             and Hour-based LED Animations for Basys3 FPGA
-----------------------------------------------------------------*/

module top_module(
    input wire i_clk, // 100 MHz System Clock           
    input wire i_rst, // Reset Button (Active High)              
    input wire i_btn_hours, // Hour increment button        
    input wire i_btn_minutes, // Minute increment button       
    output wire [6:0] o_seg, // 7-segment cathodes        
    output wire [3:0] o_an, // 7-segment anodes      
    output wire [15:0] o_leds // 16 On-board LEDs (PWM controlled)        
);

    // Internal Signal Declarations
    wire w_clk_1hz;
    wire w_btn_h_clean; 
    wire w_btn_m_clean;
    wire [5:0] w_hours;
    wire [5:0] w_minutes;
    wire [3:0] w_pwm_value;
    wire w_use_animation;
    wire [15:0] w_anim_leds;

    // 1. Clock Management
    clock_divider #(.p_DIVIDER_VALUE(26'd50_000_000)) clkdiv_inst (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_clk_1hz(w_clk_1hz)
    );

    // 2. Input Conditioning (Debouncing & Sync)
    debounce db_hour (
        .i_clk(i_clk),
        .i_btn_in(i_btn_hours),
        .o_btn_out(w_btn_h_clean)
    );

    debounce db_min (
        .i_clk(i_clk),
        .i_btn_in(i_btn_minutes),
        .o_btn_out(w_btn_m_clean)
    );

    // 3. Real-Time Clock Logic
    clock_logic clock_inst (
        .i_clk_1hz(w_clk_1hz),
        .i_rst(i_rst),
        .i_inc_hours(w_btn_h_clean),
        .i_inc_minutes(w_btn_m_clean),
        .o_hours(w_hours),
        .o_minutes(w_minutes)
    );

    // 4. Display Driver (TDM Multiplexing)
    ssd_multiplex display_inst (
        .i_clk(i_clk),
        .i_d0(w_minutes % 10),
        .i_d1(w_minutes / 10),
        .i_d2(w_hours % 10),
        .i_d3(w_hours / 10),
        .o_seg(o_seg),
        .o_an(o_an)
    );

    // 5. Lighting Control
    led_controller led_ctrl (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_hour(w_hours),
        .o_pwm_value(w_pwm_value),
        .o_use_animation(w_use_animation)
    );

    // 6. Animation Engine
    led_animator animator (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_led_pattern(w_anim_leds)
    );

    // 7. PWM Output Generation (16 LEDs)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : pwm_loop
            pwm_led pwm_inst (
                .i_clk(i_clk),
                .i_brightness(w_use_animation ? (w_anim_leds[i] ? 4'd8 : 4'd0) : w_pwm_value),
                .o_led_out(o_leds[i])
            );
        end
    endgenerate

endmodule
