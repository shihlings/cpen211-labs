module datapath (clk, loada, loadb, loadc, loads, asel, bsel, vsel, write, ALUop, shift, readnum, writenum, datapath_in, datapath_out, Z_out);
   input clk, loada, loadb, loadc, loads, asel, bsel, vsel, write;
   input [1:0] ALUop;
   input [1:0] shift;
   input [2:0] readnum;
   input [2:0] writenum;
   input [15:0]	datapath_in;
   output [15:0] datapath_out;
   output	 Z_out;

   wire [15:0]	 A;
   wire [15:0]	 B;
   wire [15:0]	 C;

   wire [15:0]	 sout;

   wire [15:0]	 Ain;
   wire [15:0]	 Bin;

   wire [15:0]	 data_in;
   wire [15:0]	 data_out;

   wire [15:0]	 out;
   wire		 Z;
   
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
   vDFFE #(1) statusDFF(clk, loads, Z, Z_out);

   // vsel multiplexer
   assign data_in = vsel ? datapath_in : datapath_out;
   
   // asel multiplexer
   assign Ain = asel ? 16'b0 : A;

   // bsel multiplxer
   assign Bin = bsel ? {11'b0, datapath_in[4:0]} : sout;

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