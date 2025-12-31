/*------------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: bcd_7_seg.v
Description: Combinational decoder for a 7-segment display.
             Converts 4-bit BCD input into 7-bit cathode signals.
             Logic: Active LOW (0 = Segment ON, 1 = Segment OFF). 
------------------------------------------------------------------*/

module bcd_to_7seg(
    input wire [3:0] i_digit, // 4-bit BCD input digit (0-9)
    output reg [6:0] o_seg // 7-segment output vector (g f e d c b a)
);

    // Segment Mapping (Basys3 Standard)
    // Index:   6 5 4 3 2 1 0
    // Segment: g f e d c b a

    always @(*) begin
        case(i_digit)
            // Segments:   gfedcba
            4'd0: o_seg = 7'b1000000; // Display 0
            4'd1: o_seg = 7'b1111001; // Display 1
            4'd2: o_seg = 7'b0100100; // Display 2
            4'd3: o_seg = 7'b0110000; // Display 3
            4'd4: o_seg = 7'b0011001; // Display 4
            4'd5: o_seg = 7'b0010010; // Display 5
            4'd6: o_seg = 7'b0000010; // Display 6
            4'd7: o_seg = 7'b1111000; // Display 7
            4'd8: o_seg = 7'b0000000; // Display 8
            4'd9: o_seg = 7'b0010000; // Display 9
            default: o_seg = 7'b1111111; // All OFF (Error or Blank)
        endcase
    end
endmodule