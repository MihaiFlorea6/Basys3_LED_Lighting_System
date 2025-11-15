module ssd_multiplex(
    input clk,
    input [3:0] d0, d1, d2, d3,
    output [6:0] seg,
    output reg [3:0] an
);
    reg [1:0] sel = 0;
    reg [16:0] refresh_counter = 0;
    reg [3:0] current_digit;

    wire refresh_tick = (refresh_counter == 100_000); // ~1ms la 100MHz

    
    bcd_to_7seg bcd_converter (
        .digit(current_digit),
        .seg(seg)
    );

    always @(posedge clk) begin
        if (refresh_tick) begin
            refresh_counter <= 0;
            sel <= sel + 1;
        end else begin
            refresh_counter <= refresh_counter + 1;
        end
    end

    always @(*) begin
        case (sel)
            2'd0: begin an = 4'b1110; current_digit = d0; end
            2'd1: begin an = 4'b1101; current_digit = d1; end
            2'd2: begin an = 4'b1011; current_digit = d2; end
            2'd3: begin an = 4'b0111; current_digit = d3; end
            default: begin an = 4'b1111; current_digit = 4'd0; end
        endcase
    end

endmodule
