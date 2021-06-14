module clock_pll48
  (input  clk_in,
   output clk_out,
   output clk_reset,
   output clk_tick
   );

   wire pll_feedback;
   wire clk_out_unbuf;
   reg [23:0] ledCounter;

	PLLE2_BASE #(
		.CLKFBOUT_MULT(36),
		.CLKOUT0_DIVIDE(25),
		.CLKOUT0_DUTY_CYCLE(0.5),
		.CLKOUT0_PHASE(0.0)
	) PLL_1 (
		.CLKIN1(clk_in),
		.CLKOUT0(clk_out_unbuf),
		.CLKFBOUT(pll_feedback),
		.CLKFBIN(pll_feedback),
		.PWRDWN(1'b0),
		.LOCKED(clk_locked),
		.RST(1'b0)
	);

	BUFG pixel_clk_buf (
		.O(clk_out),
		.I(clk_out_unbuf)
	);

   // Generate reset signal
   reg [5:0] reset_cnt = 0;
   assign clk_reset = ~reset_cnt[5];
   always @(posedge clk_out) begin
     if (clk_locked) 
       reset_cnt <= reset_cnt + clk_reset;
       ledCounter <= ledCounter + 1; 
    end
 
   assign clk_tick = ledCounter[ 23 ];

endmodule
