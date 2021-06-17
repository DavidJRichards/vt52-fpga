/**
 * Char Buffer RAM (1920x8)
 * (24 lines of 80 characters)
 */
module char_buffer
  #(parameter BUF_SIZE = 1920,
    parameter ADDR_BITS = 11)
   (input wire clk,
    input wire [7:0] din,
    input wire [ADDR_BITS-1:0] waddr,
    input wire wen,
    input wire [ADDR_BITS-1:0] raddr,
    output reg [7:0] dout,
    input wire graphic_mode
    );

   reg [7:0] mem [BUF_SIZE-1:0];
   reg [7:0] atr [BUF_SIZE-1:0];

   initial begin
      //$readmemh("mem/test.hex", mem) ;
      $readmemh("empty.mem", mem) ;
   end

   always @(posedge clk) begin
      if (wen) begin 
        mem[waddr] <= din;
        atr[waddr] <= graphic_mode;
      end
      
      if(atr[raddr]==1) 
      begin
        case (mem[raddr])
            "p": begin
                dout = "-";
            end
            
            default: begin
                dout <= mem[raddr]; 
            end
        endcase        
      end      
      else
        dout <= mem[raddr];
   end
endmodule
