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
        output led_red,
        output led_green,
        output led_blue,
        output pin_led

        //output [3:0] debug
    );

    wire clk_48mhz;
    wire clk_reset;
    wire det_reset;
  
    // zynq clock generator pll
    clock_pll48  clock_pll48
    (
       .clk_in(pin_clk),
       .clk_out(clk_48mhz),
       .clk_reset(clk_reset)
       //.clk_tick(led_green)
    );
    
    // uart pipeline in
    wire [7:0] uart_in_data;
    wire       uart_in_valid;
    wire       uart_in_ready;

    // assign debug = { uart_in_valid, uart_in_ready, reset, clk_48mhz };

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

        // echo to uart out
        .uart_out_data( uart_in_data ),
        .uart_out_valid( uart_in_valid ),
        .uart_out_ready( uart_in_ready  ),
        
        .det_reset( det_reset )

        //.debug( debug )
    );

    assign pin_pu = pin_button;
    assign pin_led = ~det_reset;

endmodule
