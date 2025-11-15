module debounce(
    input clk,
    input btn_in,
    output reg btn_out
);
    reg [15:0] cnt = 0;
    reg btn_sync = 0;

    always @(posedge clk) begin
        if (btn_in == btn_sync)
            cnt <= 0;
        else begin
            cnt <= cnt + 1;
            if (cnt == 16'hFFFF)
                btn_sync <= btn_in;
        end
        btn_out <= btn_sync;
    end
endmodule
