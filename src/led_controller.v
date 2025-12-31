/*-----------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: led_controller.v
Description: Decision-making module that assigns PWM brightness
             and animation states based on the current hour.
-----------------------------------------------------------------*/

module led_controller(
    input wire i_clk, // System Clock
    input wire i_rst, // System Reset
    input wire [5:0] i_hour, // Current Hour (0-23)
    output wire [3:0] o_pwm_value, // Calculated Brightness (0-15)
    output wire o_use_animation // Animation Enable Flag
);

    // Time Threshold Parameters
    localparam HOUR_MIDNIGHT = 6'd0;
    localparam HOUR_ANIM = 6'd3;
    localparam HOUR_DAWN = 6'd6;
    localparam HOUR_DUSK = 6'd18;
    localparam HOUR_EVENING = 6'd21;
    
    // Brightness Levels
    localparam BRIGHT_MAX = 4'd15;
    localparam BRIGHT_HIGH = 4'd10;
    localparam BRIGHT_MED = 4'd5;
    localparam BRIGHT_LOW = 4'd2;
    localparam BRIGHT_OFF = 4'd0;

    // Internal Registers
    reg [3:0] r_pwm_reg;
    reg r_anim_reg;

    // Continuous Assignment
    assign o_pwm_value = r_pwm_reg;
    assign o_use_animation = r_anim_reg;

    // Brightness Control Logic
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_pwm_reg <= BRIGHT_OFF;
            r_anim_reg <= 1'b0;
        end else begin
            // Hour-based State Machine   
            if(i_hour == HOUR_ANIM) begin
               r_pwm_reg <= BRIGHT_OFF;  
               r_anim_reg <= 1'b1; // Enable "Wave" Effect 
            end else begin
               r_anim_reg <= 1'b0;
               case (1'b1)
                    (i_hour >= HOUR_MIDNIGHT && i_hour < HOUR_ANIM): r_pwm_reg <= BRIGHT_MAX;
                    (i_hour > HOUR_ANIM && i_hour < HOUR_DAWN): r_pwm_reg <= BRIGHT_MED;
                    (i_hour >= HOUR_DAWN && i_hour < HOUR_DUSK): r_pwm_reg <= BRIGHT_LOW;
                    (i_hour >= HOUR_DUSK && i_hour < HOUR_EVENING): r_pwm_reg <= BRIGHT_MED;
                    (i_hour >= HOUR_EVENING && i_hour <= 6'd23): r_pwm_reg <= BRIGHT_HIGH;
                    default: r_pwm_reg <= BRIGHT_LOW;
               endcase     
            end
        end
    end     

endmodule