module led_animator(
    input clk,
    input rst,
    output reg [15:0] led_pattern
);

    reg [4:0] pos = 0; 
    reg [23:0] delay_counter = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pos <= 0;
            delay_counter <= 0;
        end else begin
            if (delay_counter == 24'd8_000_000) begin // ~0.08s delay la 100MHz
                delay_counter <= 0;
                if (pos == 15)
                    pos <= 0;
                else
                    pos <= pos + 1;
            end else begin
                delay_counter <= delay_counter + 1;
            end
        end
    end

    integer i;
    always @(*) begin
        led_pattern = 16'b0;
        for (i = 0; i < 16; i = i + 1) begin
            case (i - pos)
                0: led_pattern[i] = 1; 
                -1, 1: led_pattern[i] = 1; 
                -2, 2: led_pattern[i] = 1;
                -3, 3: led_pattern[i] = 1; 
                default: led_pattern[i] = 0;
            endcase
        end
    end

endmodule
