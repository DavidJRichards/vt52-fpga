module top (input       pin_clk,
            output wire vga_clk,
            output wire vga_blank,
            output wire hsync,
            output wire vsync,
            output wire [7:0]vga_r,
            output wire [7:0]vga_g,
            output wire [7:0]vga_b,
            output wire pin_led,
            input       ps2_data,
            input       ps2_clk,
            inout       pin_usb_p,
            inout       pin_usb_n,
            output wire pin_pu,
            input wire uart_rxd,
            output wire uart_txd
            
            );
   localparam ROWS = 24;
   localparam COLS = 80;
   localparam ROW_BITS = 5;
   localparam COL_BITS = 7;
   localparam ADDR_BITS = 11;

   // clock generator outputs
   wire clk_usb, reset_usb;
   wire clk_vga, reset_vga;

   // scroll
   wire [ADDR_BITS-1:0] new_first_char;
   wire new_first_char_wen;
   wire [ADDR_BITS-1:0] first_char;
   // cursor
   wire [ROW_BITS-1:0]  new_cursor_y;
   wire [COL_BITS-1:0]  new_cursor_x;
   wire new_cursor_wen;
   wire cursor_blink_on;
   wire [ROW_BITS-1:0] cursor_y;
   wire [COL_BITS-1:0] cursor_x;
   // char buffer
   wire [7:0] new_char;
   wire [ADDR_BITS-1:0] new_char_address;
   wire new_char_wen;
   wire [ADDR_BITS-1:0] char_address;
   wire [7:0] char;
   // char rom
   wire graphic_mode_state;
   wire graphic_mode;
   wire [11:0] char_rom_address;
   wire [7:0] char_rom_data;

   // video generator
   wire vblank, hblank;
   wire video;
   assign vga_clk = clk_vga;
   assign vga_blank = ~hblank; // background colour always black if vblank added as well
 
   // uart input/output
   wire [7:0] uart_out_data;
   wire uart_out_valid;
   wire uart_out_ready;

   wire [7:0] uart_in_data;
   wire uart_in_valid;
   wire uart_in_ready;

    wire det_reset;
    assign pin_led = det_reset;

    assign uart_rts = 1'b1;
        
   // led follows the cursor blink
//   assign pin_led = cursor_blink_on;

   // USB host detect and reset
   assign pin_pu = 1'b1;

   // amber text on dark blue, alt full drive {8{video}};
   assign vga_r = (video) ? 240 : 0;
   assign vga_g = (video) ? 240 : 0;
   assign vga_b = (video) ? 0 : 64;
 
   assign graphic_mode_state = graphic_mode;
   
   //
   // Instantiate all modules
   //
   clock_generator clock_generator(.clk(pin_clk),
                                   .clk_usb(clk_usb),
                                   .reset_usb(reset_usb),
                                   .clk_vga(clk_vga),
                                   .reset_vga(reset_vga)
                                   );

   keyboard keyboard(.clk(clk_usb),
                     .reset(reset_usb),
                     .ps2_data(ps2_data),
                     .ps2_clk(ps2_clk),
                     .data(uart_in_data),
                     .valid(uart_in_valid),
                     .ready(uart_in_ready)
                     );

   cursor #(.ROW_BITS(ROW_BITS), .COL_BITS(COL_BITS))
      cursor(.clk(clk_usb),
             .reset(reset_usb),
             .tick(vblank),
             .x(cursor_x),
             .y(cursor_y),
             .blink_on(cursor_blink_on),
             .new_x(new_cursor_x),
             .new_y(new_cursor_y),
             .wen(new_cursor_wen)
            );

   simple_register #(.SIZE(ADDR_BITS))
      scroll_register(.clk(clk_usb),
                      .reset(reset_usb),
                      .idata(new_first_char),
                      .wen(new_first_char_wen),
                      .odata(first_char)
                      );

   char_buffer char_buffer(.clk(clk_usb),
                           .din(new_char),
                           .waddr(new_char_address),
                           .wen(new_char_wen),
                           .raddr(char_address),
                           .dout(char),
                           .graphic_mode(graphic_mode)
                           );

   char_rom char_rom(.clk(clk_usb),
                     .addr(char_rom_address),
                     .dout_(char_rom_data)
//                     .graphic_mode(graphic_mode)
                     );

   video_generator #(.ROWS(ROWS),
                     .COLS(COLS),
                     .ROW_BITS(ROW_BITS),
                     .COL_BITS(COL_BITS),
                     .ADDR_BITS(ADDR_BITS))
      video_generator(.clk(clk_vga),
                      .reset(reset_vga),
                      .hsync(hsync),
                      .vsync(vsync),
                      .video(video),
                      .hblank(hblank),
                      .vblank(vblank),
                      .cursor_x(cursor_x),
                      .cursor_y(cursor_y),
                      .cursor_blink_on(cursor_blink_on),
                      .first_char(first_char),
                      .char_buffer_address(char_address),
                      .char_buffer_data(char),
                      .char_rom_address(char_rom_address),
                      .char_rom_data(char_rom_data)
                      );

`ifdef ALT_UART

    uart uart_inst (
                    .clk(clk_usb),
                    .rst(reset_usb),
                    // AXI input
                    .s_axis_tdata(uart_in_data),
                    .s_axis_tvalid(uart_in_valid),
                    .s_axis_tready(uart_in_ready),
                    // AXI output
                    .m_axis_tdata(uart_out_data),
                    .m_axis_tvalid(uart_out_valid),
                    .m_axis_tready(uart_out_ready),
                    // uart
                    .rxd(uart_rxd),
                    .txd(uart_txd),
                    // status
                    .tx_busy(),
                    .rx_busy(),
                    .rx_overrun_error(),
                    .rx_frame_error(),
                    // configuration
//                    .prescale(125000000/(9600*8)) // 9600 bps
//                    .prescale(125000000/(115200*8)) // 115200 bps
                    .prescale(48000000/(115200*8)) // 115200 bps
//                    .prescale(48000000/(9600*8)) // 9600 bps
//                    .prescale(52) // 115200 bps with 48 mhz clock
                );
                                      
`else

   usb_uart uart(.clk_48mhz(clk_usb),
                 .reset(reset_usb),
                 // usb pins
                 .pin_usb_p(pin_usb_p),
                 .pin_usb_n(pin_usb_n),
                 // uart pipeline in (keyboard->usb)
                 .uart_in_data(uart_in_data),
                 .uart_in_valid(uart_in_valid),
                 .uart_in_ready(uart_in_ready),
                 // uart pipeline out (usb->command_handler)
                 .uart_out_data(uart_out_data),
                 .uart_out_valid(uart_out_valid),
                 .uart_out_ready(uart_out_ready),
                 .det_reset(det_reset)
                 );
`endif

   command_handler #(.ROWS(ROWS),
                     .COLS(COLS),
                     .ROW_BITS(ROW_BITS),
                     .COL_BITS(COL_BITS),
                     .ADDR_BITS(ADDR_BITS))
      command_handler(.clk(clk_usb),
                      .reset(reset_usb),// || det_reset),
                      .data(uart_out_data),
                      .valid(uart_out_valid),
                      .ready(uart_out_ready),
                      .new_first_char(new_first_char),
                      .new_first_char_wen(new_first_char_wen),
                      .new_char(new_char),
                      .new_char_address(new_char_address),
                      .new_char_wen(new_char_wen),
                      .new_cursor_x(new_cursor_x),
                      .new_cursor_y(new_cursor_y),
                      .new_cursor_wen(new_cursor_wen),
                      .graphic_mode(graphic_mode)
                      );
                      
 endmodule
