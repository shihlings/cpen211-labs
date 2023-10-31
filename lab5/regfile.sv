module regfile(data_in,writenum,write,readnum,clk,data_out);
   input [15:0] data_in;
   input [2:0]	writenum, readnum;
   input	write, clk;
   output [15:0] data_out;

   reg [15:0] R0;
   reg [15:0] R1;
   reg [15:0] R2;
   reg [15:0] R3;
   reg [15:0] R4;
   reg [15:0] R5;
   reg [15:0] R6;
   reg [15:0] R7;

   wire [7:0] writenum_onehot;
   wire [7:0] readnum_onehot;
   
   always_ff @(posedge clk) begin
      if (write) begin
         case (writenum)
         3'b000: R0 = data_in;
         3'b001: R1 = data_in;
         3'b010: R2 = data_in;
         3'b011: R3 = data_in;
         3'b100: R4 = data_in;
         3'b101: R5 = data_in;
         3'b110: R6 = data_in;
         3'b111: R7 = data_in;   
      end
   end

   always_comb begin
      
   end

endmodule