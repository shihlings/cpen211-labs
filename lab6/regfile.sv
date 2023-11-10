module regfile(data_in,writenum,write,readnum,clk,data_out);
   input [15:0] data_in;
   input [2:0]	writenum, readnum;
   input	write, clk;
   output reg [15:0] data_out;

   reg [15:0]	     R0;
   reg [15:0]	     R1;
   reg [15:0]	     R2;
   reg [15:0]	     R3;
   reg [15:0]	     R4;
   reg [15:0]	     R5;
   reg [15:0]	     R6;
   reg [15:0]	     R7;
   
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
	 endcase // case (writenum)
      end // if (write)
   end

   always_comb begin
      case (readnum)
	3'b000: data_out = R0;
	3'b001: data_out = R1;
	3'b010: data_out = R2;
	3'b011: data_out = R3;
	3'b100: data_out = R4;
	3'b101: data_out = R5;
	3'b110: data_out = R6;
	3'b111: data_out = R7;
	default: data_out = {16{1'bx}};
      endcase // case (readnum)
   end

endmodule
