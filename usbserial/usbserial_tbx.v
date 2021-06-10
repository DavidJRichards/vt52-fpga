/*
    USB Serial

    Wrapping usb/usb_uart_ice40.v to create a loopback.
*/

module usbserial_tbx (
        input  pin_clk,

        inout  pin_usb_p,
        inout  pin_usb_n,
        output pin_pu,

        input  pin_button,
        output pin_led

//        output [3:0] debug
    );

    wire clk_48mhz;
    wire clk_reset;

// zynq clock generator pll
    clock_pll48  clock_pll48
    (
   .clk_in(pin_clk),
   .clk_out(clk_48mhz),
   .clk_reset(clk_reset),
   .clk_button(pin_button),
   .clk_tick(pin_led)
   );

    // uart pipeline in
    wire [7:0] uart_in_data;
    wire       uart_in_valid;
    wire       uart_in_ready;

    // assign debug = { uart_in_valid, uart_in_ready, reset, clk_48mhz };

    wire usb_p_tx;
    wire usb_n_tx;
    wire usb_p_rx;
    wire usb_n_rx;
    wire usb_tx_en;

    // usb uart - this instanciates the entire USB device.
    usb_uart uart (
        .clk_48mhz  (clk_48mhz),
        .reset      (clk_reset),

        // pins
        .pin_usb_p( pin_usb_p ),
        .pin_usb_n( pin_usb_n ),

        // uart pipeline in
        .uart_in_data( uart_in_data ),
        .uart_in_valid( uart_in_valid ),
        .uart_in_ready( uart_in_ready ),

        .uart_out_data( uart_in_data ),
        .uart_out_valid( uart_in_valid ),
        .uart_out_ready( uart_in_ready  )

        //.debug( debug )
    );

    // USB Host Detect Pull Up
//    assign pin_pu = 1'b1;
    assign pin_pu = ~clk_reset;

endmodule
