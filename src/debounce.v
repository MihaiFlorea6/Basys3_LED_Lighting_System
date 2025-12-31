/*-----------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: debounce.v
Description: Filters mechanical button noise and synchronizes
             asynchronous inputs to the system clock
-----------------------------------------------------------------*/

module debounce(
    input wire i_clk, //100MHz System Clock
    input wire i_btn_in, // Raw button input
    output reg o_btn_out // Synchronized output
);

    reg [16:0] r_cnt;
    reg r_sync_0, r_sync_1; // Two-stage synchronizer
    

    always @(posedge i_clk) begin
        // Prevent metastability by synchronizing input to clk domain
        r_sync_0 <= i_btn_in;
        r_sync_1 <= r_sync_0;
        
        if (r_sync_1 == o_btn_out) begin
            r_cnt <= 17'd0;
        end else begin
            r_cnt <= r_cnt + 1'b1;
            if (r_cnt == 17'h1FFFF) begin // ~1.3ms delay at 100MHz
                o_btn_out <= r_sync_1;
            end
        end
    end    
endmodule
