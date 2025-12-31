/*------------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: ssd_multiplex.v
Description: TDM Multiplexer for 4-digit 7-segment display.
------------------------------------------------------------------*/

module ssd_multiplex(
    input wire i_clk,
    input wire [3:0] i_d0, i_d1, i_d2, i_d3,
    output wire [6:0] o_seg,
    output reg [3:0] o_an
);

    reg [1:0] r_sel;
    reg [16:0] r_refresh_counter;
    reg [3:0] r_current_digit;

    // Segment Decoder Instantiation
    bcd_to_7seg bcd_converter (
        .i_digit(r_current_digit),
        .o_seg(o_seg)
    );

    always @(posedge i_clk) begin
        r_refresh_counter <= r_refresh_counter + 1'b1;
        r_sel <= r_refresh_counter[16:15]; // Refresh rate ~760Hz
    end

    always @(*) begin
        case (r_sel)
            2'd0: begin o_an = 4'b1110; r_current_digit = i_d0; end
            2'd1: begin o_an = 4'b1101; r_current_digit = i_d1; end
            2'd2: begin o_an = 4'b1011; r_current_digit = i_d2; end
            2'd3: begin o_an = 4'b0111; r_current_digit = i_d3; end
            default: begin o_an = 4'b1111; r_current_digit = 4'd0; end
        endcase
    end

endmodule