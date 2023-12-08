module ALU(Ain,Bin,ALUop,out,Z);
   input [15:0] Ain, Bin;
   input [1:0]	ALUop;
   output reg [15:0] out;
   output reg [2:0]  Z;

   wire [15:0] temp_add;
   wire [15:0] temp_not;
   wire [15:0] temp_and;

   add adder(Ain, Bin, temp_add);
   subtract subtractor(Ain, Bin, Z);
   AND_MOD ANDER(Ain, Bin, temp_and);
   NOT_MOD notter(Bin, temp_not);
   
   always_comb begin
      case (ALUop)
         2'b00: out = temp_add;
         2'b10: out = temp_and;
         2'b11: out = temp_not;
         default: out = {16{1'bx}};
      endcase
   end
endmodule

module add (Ain, Bin, out);
   input [15:0] Ain;
   input [15:0] Bin;
   output [15:0] out;
   
   assign out = Ain + Bin;
endmodule

module subtract (Ain, Bin, status);
   input [15:0] Ain;
   input [15:0] Bin;
   output [2:0] status;

   wire neg = Ain < Bin;
      
   assign status[0] = Ain == Bin ? 1'b1 : 1'b0;
   assign status[1] = neg;
   assign status[2] = (Ain[15] ^ Bin[15]) & (neg ^ Ain);
endmodule

module NOT_MOD (Bin, out);
   input [15:0] Bin;
   output [15:0] out;
   
   assign out = ~Bin;
endmodule

module AND_MOD (Ain, Bin, out);
   input [15:0] Ain;
   input [15:0] Bin;

   output [15:0] out;
   assign out = Ain & Bin;
endmodule