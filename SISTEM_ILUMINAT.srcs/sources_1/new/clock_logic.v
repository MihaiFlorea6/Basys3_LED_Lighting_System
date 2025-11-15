module clock_logic(
    input clk_1hz,
    input rst,
    input inc_hours,
    input inc_minutes,
    output reg [5:0] hours,
    output reg [5:0] minutes
);
    always @(posedge clk_1hz or posedge rst) begin
        if (rst) begin
            hours <= 0;
            minutes <= 0;
        end else begin
            if (inc_minutes) begin
                if (minutes == 59)begin
                    minutes <= 0;
                    hours <= hours +1;
               end else
                    minutes <= minutes + 1;
            end
            if (inc_hours) begin
                if (hours == 23)
                    hours <= 0;
                else
                    hours <= hours + 1;
            end
        end
    end
endmodule
