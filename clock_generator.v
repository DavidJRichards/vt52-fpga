module clock_generator
  (input  clk,
   output clk_usb,
   output reset_usb,
   output clk_vga,
   output reset_vga,
   );

   wire locked;
   reg vga_clk_divider;
   
	wire pll_feedback_1;
	wire clk_usb_unbuf;

	PLLE2_BASE #(
		.CLKFBOUT_MULT(36),
		.CLKOUT0_DIVIDE(25),
		.CLKOUT0_DUTY_CYCLE(0.5),
		.CLKOUT0_PHASE(0.0)
	) PLL_1 (
		.CLKIN1(clk),
		.CLKOUT0(clk_usb_unbuf),
		.CLKFBOUT(pll_feedback_1),
		.CLKFBIN(pll_feedback_1),
		.PWRDWN(1'b0),
		.LOCKED(locked),
		.RST(1'b0)
	);

	BUFG pixel_clk_buf (
		.O(clk_usb),
		.I(clk_usb_unbuf)
	);

   // Generate reset signal
   reg [5:0] reset_cnt = 0;
   assign reset_usb = ~reset_cnt[5];

   always @(posedge clk_usb)
     if (locked) reset_cnt <= reset_cnt + reset_usb;

   // divide usb clock by by two to get vga clock
   always @(posedge clk_usb) begin
      if (reset_usb) vga_clk_divider <= 0;
      else vga_clk_divider <= ~vga_clk_divider;
   end

   assign clk_vga = vga_clk_divider;
   assign reset_vga = reset_usb;
endmodule
