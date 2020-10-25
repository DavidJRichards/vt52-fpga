/**
 * Char Buffer RAM (2000x8)
 * (25 lines of 80 characters)
 */
module char_buffer
  #(parameter BUF_SIZE = 2000,
    parameter ADDR_BITS = 11)
   (input wire [7:0] din,
    input wire [ADDR_BITS-1:0] waddr,
    input wire write_en,
    input wire clk,
    input wire [ADDR_BITS-1:0] raddr,
    output reg [7:0] dout,
    input wire read_en
    );

   reg [7:0] mem [BUF_SIZE-1:0];

   initial begin
      $readmemh("mem/test.hex", mem) ;
      //$readmemh("mem/empty.hex", mem) ;
   end

   always @(posedge clk) begin
      if (write_en) mem[waddr] <= din;
      if (read_en) dout <= mem[raddr];
   end
endmodule
