module regfile(data_in,writenum,write,readA,readB,clk,A_out,B_out);
   input [15:0] data_in;
   input [2:0]	writenum, readA, readB;
   input	write, clk;
   output reg [15:0] A_out, B_out;

   wire [15:0]	     R0;
   wire [15:0]	     R1;
   wire [15:0]	     R2;
   wire [15:0]	     R3;
   wire [15:0]	     R4;
   wire [15:0]	     R5;
   wire [15:0]	     R6;
   wire [15:0]	     R7;
   reg [7:0] writenum_onehot;
   
   vDFFE #(16) REG0(clk, writenum_onehot[0], data_in, R0);
   vDFFE #(16) REG1(clk, writenum_onehot[1], data_in, R1);
   vDFFE #(16) REG2(clk, writenum_onehot[2], data_in, R2);
   vDFFE #(16) REG3(clk, writenum_onehot[3], data_in, R3);
   vDFFE #(16) REG4(clk, writenum_onehot[4], data_in, R4);
   vDFFE #(16) REG5(clk, writenum_onehot[5], data_in, R5);
   vDFFE #(16) REG6(clk, writenum_onehot[6], data_in, R6);
   vDFFE #(16) REG7(clk, writenum_onehot[7], data_in, R7);

   always_comb begin
      if (write)
         case (writenum)
            3'b000: writenum_onehot = 8'b00000001;
            3'b001: writenum_onehot = 8'b00000010;
            3'b010: writenum_onehot = 8'b00000100;
            3'b011: writenum_onehot = 8'b00001000;
            3'b100: writenum_onehot = 8'b00010000;
            3'b101: writenum_onehot = 8'b00100000;
            3'b110: writenum_onehot = 8'b01000000;
            3'b111: writenum_onehot = 8'b10000000;   
            default: writenum_onehot = {8{1'bx}};
         endcase // case (writenum)
      else
         writenum_onehot = 8'b00000000;
   end

   always_comb begin
      case (readA)
	3'b000: A_out = R0;
	3'b001: A_out = R1;
	3'b010: A_out = R2;
	3'b011: A_out = R3;
	3'b100: A_out = R4;
	3'b101: A_out = R5;
	3'b110: A_out = R6;
	3'b111: A_out = R7;
	default: A_out = {16{1'bx}};
      endcase // case (readA)

      case (readB)
   3'b000: B_out = R0;
   3'b001: B_out = R1;
   3'b010: B_out = R2;
   3'b011: B_out = R3;
   3'b100: B_out = R4;
   3'b101: B_out = R5;
   3'b110: B_out = R6;
   3'b111: B_out = R7;
   default: B_out = {16{1'bx}};
      endcase // case (readB)
   end

endmodule
