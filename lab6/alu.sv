module ALU(Ain,Bin,ALUop,out,Z);
   input [15:0] Ain, Bin;
   input [1:0]	ALUop;
   output reg [15:0] out;
   output reg [2:0] Z;

   reg zero, negative, overflow;
   reg carry1, carry2;
   
   assign Z = {overflow, negative, zero};
   
   always_comb begin
      if (ALUop == 2'b00) begin
         {carry1, out[14:0]} = Ain[14:0] + Bin[14:0];
         {carry2, out[15]} = Ain[15] + Bin[15] + carry1;
      end
      
      else if (ALUop == 2'b01) begin
         {carry1, out[14:0]} = Ain[14:0] - Bin[14:0];
         {carry2, out[15]} = Ain[15] + Bin[15] - carry1;
      end

      else if (ALUop == 2'b10) begin
         carry1 = 1'b0;
         carry2 = 1'b0;
         out = Ain & Bin;
      end
      
      else if (ALUop == 2'b11) begin
         carry1 = 1'b0;
         carry2 = 1'b0;
         out = ~Bin;
      end

      if (out == 16'b0)
         zero = 1'b1;
      else
         zero = 1'b0;

      if (out[15] == 1'b1) 
         negative = 1'b1;
      else
         negative = 1'b0;
         
      if (carry1 != carry2) 
         overflow = 1'b1;
      else
         overflow = 1'b0;
   end
endmodule