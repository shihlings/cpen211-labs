module datapath (clk, loada, loadb, loadc, loads, asel, bsel, vsel, write, ALUop, shift, readnum, writenum, PC, mdata, sximm5, sximm8, datapath_out, Z_out);
   input clk, loada, loadb, loadc, loads, asel, bsel, write;
   input [1:0] vsel;
   input [1:0] ALUop;
   input [1:0] shift;
   input [2:0] readnum;
   input [2:0] writenum;
   input [8:0] PC;
   input [15:0]	mdata;
   input [15:0]	sximm5;
   input [15:0]	sximm8;

   output [15:0] datapath_out;
   output [2:0]	 Z_out;

   wire [15:0]	 A;
   wire [15:0]	 B;
   wire [15:0]	 C;

   wire [15:0]	 sout;

   wire [15:0]	 Ain;
   wire [15:0]	 Bin;

   reg [15:0]	 data_in;
   wire [15:0]	 data_out;

   wire [15:0]	 out;
   wire [2:0]	 Z;
   
   regfile REGFILE(data_in, writenum, write, readnum, clk, data_out);
   ALU alu(Ain, Bin, ALUop, out, Z);
   shifter SHIFTER(B, shift, sout);

   // Register A
   vDFFE #(16) ADFF(clk, loada, data_out, A);
   // Register B
   vDFFE #(16) BDFF(clk, loadb, data_out, B);
   // Register C
   vDFFE #(16) CDFF(clk, loadc, out, C);
   // Register status
   vDFFE #(3) statusDFF(clk, loads, Z, Z_out);

   // vsel multiplexer
   always_comb begin
      case (vsel)
        2'b00: data_in = datapath_out;
        2'b01: data_in = {7'b0, PC};
        2'b10: data_in = sximm8;
        2'b11: data_in = mdata;
      endcase
   end

   // asel multiplexer
   assign Ain = asel ? 16'b0 : A;

   // bsel multiplxer
   assign Bin = bsel ? sximm5 : sout;

   // Output = C
   assign datapath_out = C;

endmodule // datapath

module vDFFE(clk, en, in, out);
   parameter n = 1; // width
   input     clk, en ;
   input [n-1:0] in ;
   output [n-1:0] out ;
   reg [n-1:0]	  out ;
   wire [n-1:0]	  next_out ;
   assign next_out = en ? in : out;
   
   always @(posedge clk)
     out = next_out;
endmodule
