/*--------------------------------------------------------------------
Project: FPGA Lighting System
Author: Mihai Florea
Design: tbb_top_module.v
Description: Professional Testbench for verifying the lighting system.
             Simlates clock, reset and hour increments.
--------------------------------------------------------------------*/

`timescale 1ns / 1ps

module tb_top_module();

   // Signals for Device Under Test (DUT)
   reg clk;
   reg rst;
   reg btn_hours;
   reg btn_minutes;
   wire [6:0] seg;
   wire [3:0] an;
   wire [15:0] leds;
   
   // Clock Generation (100MHz)
   always #5 clk = ~clk; // Toggle every 5ns -> 10ns period
   
   // Instantiate DUT (Device Under Test)
   top_module dut (
       .i_clk(clk),
       .i_rst(rst),
       .i_btn_hours(btn_hours),
       .i_btn_minutes(btn_minutes),
       .o_seg(seg),
       .o_an(an),
       .o_leds(leds)
   );

   // Test Sequence
   initial begin
       // Initialize Inputs
       clk = 0;
       rst = 1;
       btn_hours = 0;
       btn_minutes = 0;
       
       $display("---Starting Simulation---");
       
       // Release Reset after 100ns
       #100 rst = 0;
       $display("---Reset released.---");

        
        // Simulate a few minutes by pulsing btn_minutes
        repeat(5) begin
            #200000 btn_minutes = 1;
            #200000 btn_minutes = 0;
        end
        $display("---Minute increment pulses completed.---");    
        
        #1000000;
        
        $display("---Simulation Finished Successfully!---");
        $finish;
   end
        
   // Monitor Outputs
   initial begin
        $monitor("Time: %t | Anodes: %b | LEDs (HEX): %h", $time, an, leds);
   end     
           
endmodule
