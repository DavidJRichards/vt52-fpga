module top (
	    input       pclk,
	    input       clr, //asynchronous reset
	    output wire hsync,
	    output wire vsync,
	    output wire video,
	    output wire LED1,
	    output wire LED2,
            output wire LED3,
	    output wire LED4,
	    output wire LED5,
            input ps2_data,
            input ps2_clk
            );

   // sync generator outputs
   wire [10:0]          hc;
   wire [10:0]          vc;
   wire                 vblank, hblank;
   wire                 px_clk;

   // cursor
   wire                 cursor_blink_on;
   wire [3:0] cursor_y;
   wire [5:0] cursor_x;
   // to allow modifications
   reg [3:0]  new_cursor_y;
   reg [5:0]  new_cursor_x;
   reg write_cursor_pos;

   // char generator outputs
   reg [3:0] row;
   reg [5:0] col;
   wire      char_pixel;
   // char buffer inputs
   reg [7:0] new_char;
   // we can do this because width is a power of 2 (2^6 = 64)
   wire [9:0] new_char_address;
   assign new_char_address = {cursor_y, cursor_x};
   reg        char_wen;

   // TODO rewrite this instantiations to used the param names
   sync_generator mysync_generator(pclk, clr, hsync, vsync, hblank, vblank, hc, vc, px_clk);
   char_generator mychar_generator(px_clk, clr, hblank, vblank, row, col, char_pixel,
                                   new_char_address, new_char, new_char_wen);
   led_counter myled_counter(vblank, {LED1, LED2, LED3, LED4, LED5});
   cursor_blinker mycursor_blinker(vblank, clr, write_cursor_pos, cursor_blink_on);
   cursor_position #(.SIZE(6)) mycursor_x (px_clk, clr, new_cursor_x, write_cursor_pos, cursor_x);
   cursor_position #(.SIZE(4)) mycursor_y (px_clk, clr, new_cursor_y, write_cursor_pos, cursor_y);

   // Now we just need to combine the chars & the cursor
   parameter video_on = 1'b1;
   localparam video_off = ~video_on;

   wire video_out;
   wire is_under_cursor;
   wire cursor_pixel;

   assign is_under_cursor = (cursor_x == col) & (cursor_y == row);
   // invert video when we are under the cursor (if it's blinking)
   assign cursor_pixel = is_under_cursor & cursor_blink_on;
   assign video_out = char_pixel ^ cursor_pixel;
   // only emit video on non-blanking periods
   assign video = (hblank || vblank)? video_off : video_out;

   reg [1:0] ps2_old_clks;
   reg [10:0] ps2_raw_data;
   reg [3:0]  ps2_count;
   reg [7:0]  ps2_byte;
   // we are processing a break_code (key up)
   reg        ps2_break_keycode;
   // we are processing a long keycode (two bytes)
   reg        ps2_long_keycode;

   // we don't need to do this on the pixel clock, we could use
   // something way slower, but it works
   always @ (posedge px_clk or posedge clr) begin
      if (clr) begin
         new_cursor_y <= 0;
         new_cursor_x <= 0;
         write_cursor_pos <= 0;

         new_char <= 0;
         new_char_wen <= 0;

         // the clk is usually high and pulled down to start
         ps2_old_clks <= 2'b00;
         ps2_count <= 0;
         ps2_byte <= 0;
         ps2_raw_data <= 0;
         ps2_clk_buf <= 0;

         ps2_break_keycode <= 0;
         ps2_long_keycode <= 0;
      end
      else begin
         if (write_cursor_pos | new_char_wen) begin
            write_cursor_pos <= 0;
            new_char_wen <= 0;
            ps2_break_keycode <= 0;
            ps2_long_keycode <= 0;
            ps2_byte <= 0;
         end
         ps2_old_clks <= {ps2_old_clks[0], ps2_clk};

	 if(ps2_clk && ps2_old_clks == 2'b01) begin
	    ps2_count <= ps2_count + 1;
	    if(ps2_count == 10) begin
               // 11 bits means we are done (XXX/TODO check parity and stop bits)
	       ps2_count <= 0;
	       ps2_byte <= ps2_raw_data[10:3];
               // handle the breaks & long keycodes
               if (ps2_raw_data[10:3] == 8'he0) begin
                  ps2_long_keycode <= 1;
                  ps2_break_keycode <= 0;
               end
               else if (ps2_raw_data[10:3] == 8'hf0) begin
                  ps2_break_keycode <= 1;
               end
               else if (ps2_byte != 8'he0 && ps2_byte != 8'hf0) begin
                  ps2_break_keycode <= 0;
                  ps2_long_keycode <= 0;
               end
	    end
            // the data comes lsb first
            ps2_raw_data <= {ps2_data, ps2_raw_data[10:1]};
	 end // if (ps2_clk_pos == 1)
         if (!write_cursor_pos && !new_char_wen) begin
 	    if(!ps2_long_keycode && !ps2_break_keycode) begin
               new_char_wen <= 1;
	       new_cursor_x <= cursor_x == 63? cursor_x : cursor_x + 1;
               write_cursor_pos <= 1;
               case (ps2_byte)
                 8'h16: new_char <= "1";
                 8'h1e: new_char <= "2";
                 8'h26: new_char <= "3";
                 8'h25: new_char <= "4";
                 8'h2e: new_char <= "5";
                 8'h36: new_char <= "6";
                 8'h3d: new_char <= "7";
                 8'h3e: new_char <= "8";
                 8'h46: new_char <= "9";
                 8'h45: new_char <= "0";

                 8'h15: new_char <= "q";
                 8'h1d: new_char <= "w";
                 8'h24: new_char <= "e";
                 8'h2d: new_char <= "r";
                 8'h2c: new_char <= "t";
                 8'h35: new_char <= "y";
                 8'h3c: new_char <= "u";
                 8'h43: new_char <= "i";
                 8'h44: new_char <= "o";
                 8'h4d: new_char <= "p";

                 8'h1c: new_char <= "a";
                 8'h1b: new_char <= "s";
                 8'h23: new_char <= "d";
                 8'h2b: new_char <= "f";
                 8'h34: new_char <= "g";
                 8'h33: new_char <= "h";
                 8'h3b: new_char <= "j";
                 8'h42: new_char <= "k";
                 8'h4b: new_char <= "l";

                 8'h1a: new_char <= "z";
                 8'h22: new_char <= "x";
                 8'h21: new_char <= "c";
                 8'h2a: new_char <= "v";
                 8'h32: new_char <= "b";
                 8'h31: new_char <= "n";
                 8'h3a: new_char <= "m";

                 8'h66: begin
                    new_char_wen <= 0;
	            new_cursor_x <= cursor_x == 0? cursor_x : cursor_x - 1;
                 end
                 8'h29: new_char <= " ";
                 8'h5a: begin
                    new_char_wen <= 0;
	            new_cursor_x <= 0;
	            new_cursor_y <= cursor_y == 15? cursor_y : cursor_y + 1;
                 end
                 default: begin
                    new_char_wen <= 0;
	            new_cursor_x <= cursor_x;
                    write_cursor_pos <= 0;
                 end
               endcase // case (ps2_byte)
            end
 	    if(ps2_long_keycode && !ps2_break_keycode) begin
	       if(ps2_byte == 8'h75) begin		// up
		  new_cursor_y <= cursor_y == 0? cursor_y : cursor_y - 1;
                  write_cursor_pos <= 1;
  	       end
	       else if(ps2_byte == 8'h6b) begin	// left
		  new_cursor_x <= cursor_x == 0? cursor_x : cursor_x - 1;
                  write_cursor_pos <= 1;
  	       end
	       else if(ps2_byte == 8'h72) begin // down
		  new_cursor_y <= cursor_y == 15? cursor_y : cursor_y + 1;
                  write_cursor_pos <= 1;
  	       end
	       else if(ps2_byte == 8'h74) begin // right
		  new_cursor_x <= cursor_x == 63? cursor_x : cursor_x + 1;
                  write_cursor_pos <= 1;
  	       end
	    end // if (ps2_long_keycode && !ps2_break_keycode)
         end // if (~write_cursor_pos && ~new_char_wen)
      end // else: !if(clr)
   end // always @ (posedge px_clk or posedge clr)
endmodule
