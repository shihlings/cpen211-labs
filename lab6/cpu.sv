module cpu(clk,reset,s,load,in,out,N,V,Z,w);
   input clk, reset, s, load;
   input [15:0]	in;
   output [15:0] out;
   output	 N, V, Z, w;

   reg loada, loadb, loadc, loads, asel, bsel, write;
   reg [1:0] vsel;
   reg [1:0] ALUop;
   reg [1:0] shift;
   reg [2:0] readnum;
   reg [2:0] writenum;
   reg [7:0] PC;
   reg [15:0]	mdata;
   reg [15:0]	sximm5;
   reg [15:0]	sximm8;
   
   wire [2:0]	 Z_out;
   
   wire [15:0] instruction_reg_out;

   // Interface between decoder and state machine
   wire [1:0] nsel;
   wire [3:0] opcode;
   wire [2:0] op;

   assign {V, N, Z} = Z_out;

   datapath DP ( .clk(clk),
                       .loada(loada),
                       .loadb(loadb),
                       .loadc(loadc),
                       .loads(loads),
                       .asel(asel), 
                       .bsel(bsel), 
                       .vsel(vsel),
                       .write(write),
                       .ALUop(ALUop),
                       .shift(shift),
                       .readnum(readnum),
                       .writenum(writenum),
                       .PC(PC),
                       .mdata(mdata), 
                       .sximm5(sximm5),
                       .sximm8(sximm8), 
                       .datapath_out(out),
                       .Z_out(Z_out)                   );

   instruction_register instruction_reg (.clk(clk),
                                         .load(load),
                                         .in(in),
                                         .out(instruction_reg_out));

   instruction_decoder decode (.instruction(instruction_reg_out),
                                .nsel(nsel),
                                .opcode(opcode),
                                .op(op),
                                .writenum(writenum),
                                .readnum(readnum),
                                .shift(shift),
                                .sximm8(sximm8),
                                .sximm5(sximm5),
                                .ALUop(ALUop));
   
   state_machine controller (    .s(s),
                                 .reset(reset), 
                                 .w(w), 
                                 .opcode(opcode), 
                                 .op(op), 
                                 .nsel(nsel), 
                                 .loada(loada), 
                                 .loadb(loadb),
                                 .loadc(loadc), 
                                 .loads(loads), 
                                 .asel(asel), 
                                 .bsel(bsel), 
                                 .vsel(vsel),
                                 .write(write),
                                 .clk(clk)   );
endmodule

module instruction_register (clk, load, in, out);
   input [15:0] in;
   input	load, clk;
   output [15:0] out;

   vDFFE #(16) instr_reg (clk, load, in, out);
endmodule

module instruction_decoder (instruction, opcode, op, nsel, writenum, readnum, shift, sximm8, sximm5, ALUop);
   input [15:0] instruction;
   input [1:0]	nsel;
   output [3:0]	opcode;
   output [2:0]	op;
   output [2:0]	writenum;
   output [2:0]	readnum;
   output [1:0]	shift;
   output [15:0] sximm8;
   output [15:0] sximm5;
   output [1:0]	 ALUop;

   wire [4:0] imm5;
   wire [7:0] imm8;
   
   wire [2:0] Rn;
   wire [2:0] Rd;
   wire [2:0] Rm;

   reg [2:0]	 reg_mux_out;
   assign writenum = reg_mux_out;
   assign readnum = reg_mux_out;

   assign opcode = instruction[15:13];
   assign op = instruction[12:11];

   assign Rn = instruction[10:8];
   assign Rd = instruction[7:5];
   assign Rm = instruction[2:0];

   assign shift = instruction[4:3];

   assign imm5 = instruction[4:0];
   assign imm8 = instruction[7:0];

   assign sximm5 = {{11{imm5[4]}}, imm5};
   assign sximm8 = {{8{imm8[7]}}, imm8};

   assign ALUop = instruction[12:11];

   always_comb begin
      case (nsel)
        2'b00: reg_mux_out = Rm;
        2'b01: reg_mux_out = Rd;
        2'b10: reg_mux_out = Rn;
        default: reg_mux_out = 3'bxxx;
      endcase
   end
endmodule

`define wait 5'b00000;
`define 

module state_machine (clk, s, reset, w, opcode, op, nsel, loada, loadb, loadc, loads, asel, bsel, vsel, write);
   input clk, s, reset;
   input [3:0] opcode;
   input [2:0] op;
   output [1:0] nsel;
   output w, asel, bsel, write, loada, loadb, loadc, loads;
   output [1:0] vsel;

endmodule