module led_controller(
    input clk,
    input rst,
    input [5:0] hour,
    output [3:0] pwm_value,
    output use_animation
);

reg [3:0] pwm_reg;
reg anim_reg;

assign pwm_value = pwm_reg;
assign use_animation = anim_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pwm_reg <= 0;
        anim_reg <= 0;
    end else 
          if(hour >= 0 && hour < 3) begin
            pwm_reg <= 4'd15;
            anim_reg <= 0;
            end else if( hour == 3) begin
               pwm_reg <= 4'd0;  anim_reg <= 1; end 
            else if( hour >3 && hour < 6) begin
               pwm_reg <= 4'd5;
               anim_reg <= 0;
            end else if (hour >= 6 && hour < 18) begin
                    pwm_reg <= 4'd2; 
                    anim_reg <= 0;
            end else if (hour >=18 && hour < 21) begin
                 pwm_reg <= 4'd5;
                 anim_reg <= 0;
            end else if ( hour >=21 && hour <=23) begin
                pwm_reg <= 4'd10;
                anim_reg <=0;
        
    end
end

endmodule
