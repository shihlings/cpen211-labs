module cpu(clk,reset, mem_cmd, mem_addr, read_data, write_data);
   input clk, reset;

   output [1:0] mem_cmd;
   output [8:0] mem_addr;
   input [15:0] read_data;
   output [15:0] write_data;

   reg		 loada, loadb, loadc, loads, asel, bsel, write;
   reg [1:0]	 vsel;
   reg [1:0]	 ALUop;
   reg [1:0]	 shift;
   reg [2:0]	 readnum;
   reg [2:0]	 writenum;
   reg [15:0]	 sximm5;
   reg [15:0]	 sximm8;
   wire reset_pc, load_pc;
   wire [8:0] PC;

   wire [2:0]	 Z_out;
   wire [15:0]	 instruction_reg_out;
   
   // Interface between decoder and state machine
   wire [1:0]	 nsel;
   wire [2:0]	 opcode;
   wire [1:0]	 op;

   wire addr_sel;
   wire [8:0] data_addr;
   // Address select multiplexer
   assign mem_addr = addr_sel ? PC : data_addr;

   datapath DP (.clk(clk),
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
                .mdata(read_data), 
                .sximm5(sximm5),
                .sximm8(sximm8), 
                .datapath_out(write_data),
                .Z_out(Z_out));

   program_counter PC_reg (.clk(clk),
                           .load_pc(load_pc),
                           .reset_pc(reset_pc),
                           .PC(PC));

   data_address data_addr_reg (.clk(clk),
                              .load_addr(load_addr),
                              .in(write_data[8:0]),
                              .out(data_addr));

   instruction_register instruction_reg (.clk(clk),
                                         .load(load),
                                         .in(read_data),
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
   
   state_machine controller (.reset(reset), 
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
                             .clk(clk),
                             .load_pc(load_pc),
                             .reset_pc(reset_pc),
                             .load_addr(load_addr),
                             .addr_sel(addr_sel),
                             .mem_cmd(mem_cmd));
endmodule

module instruction_register (clk, load, in, out);
   input [15:0] in;
   input	load, clk;
   output [15:0] out;

   vDFFE #(16) instr_reg (clk, load, in, out);
endmodule

module program_counter (clk, load_pc, reset_pc, PC);
   output [8:0] PC;
   input reset_pc;
   input	load_pc, clk;

   wire [8:0] next_pc = reset_pc ? 9'b0 : PC + 1;
   vDFFE #(9) PC_DFF(clk, load_pc, next_pc, PC);
endmodule

module data_address (clk, load_addr, in, out);
   input [8:0]	 in;
   input	load_addr, clk;
   output [8:0] out;
   
   vDFFE #(9) data_addr_DFF(clk, load_addr, in, out);
endmodule

module instruction_decoder (instruction, opcode, op, nsel, writenum, readnum, shift, sximm8, sximm5, ALUop);
   input [15:0] instruction;
   input [1:0]	nsel;
   output [2:0]	opcode;
   output [1:0]	op;
   output [2:0]	writenum;
   output [2:0]	readnum;
   output [1:0]	shift;
   output [15:0] sximm8;
   output [15:0] sximm5;
   output [1:0]	 ALUop;

   wire [4:0]	 imm5;
   wire [7:0]	 imm8;
   
   wire [2:0]	 Rn;
   wire [2:0]	 Rd;
   wire [2:0]	 Rm;

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

// Common States
`define Reset 5'b00000
`define Decode 5'b00001
`define GetA 5'b00010
`define GetB 5'b00011
`define Add 5'b00100
`define WriteReg 5'b00101
`define WriteImm 5'b00110
`define ALUNoOp 5'b00111
`define CMP 5'b01000
`define BitwiseAND 5'b01001
`define BitwiseNOT 5'b01010
`define IF1 5'b01011
`define IF2 5'b01100
`define UpdatePC 5'b01101

// Opcode macros
`define ALU_instruction 3'b101
`define Move_instruction 3'b110

// Memory commands
`define MWRITE 2'b00
`define MREAD 2'b01

module state_machine (clk, reset, opcode, op, nsel, loada, loadb, loadc, loads, asel, bsel, vsel, write, load_pc, reset_pc, load_addr, addr_sel, mem_cmd);
   input clk, reset;
   input [2:0] opcode;
   input [1:0] op;
   output reg [1:0] nsel;
   output reg asel, bsel, write, loada, loadb, loadc, loads, load_pc, reset_pc, load_addr, addr_sel;
   output reg [1:0] vsel;
   output reg [1:0] mem_cmd;
   
   reg [4:0]	    state;

   always_ff @(posedge clk) begin
      if (reset)
        state = `Reset;
      else
        casex ({state, opcode, op})
         {`Reset, {5{1'bx}}}: state = `IF1;
         {`IF1, {5{1'bx}}}: state = `IF2;
         {`IF2, {5{1'bx}}}: state = `UpdatePC;
         {`UpdatePC, {5{1'bx}}}: state = `Decode;

          // Start instructions
          {`Decode, `Move_instruction, 2'b00}: state = `GetB;
          {`Decode, `Move_instruction, 2'b10}: state = `WriteImm;
          {`Decode, `ALU_instruction, 2'b00}: state = `GetA;
          {`Decode, `ALU_instruction, 2'b01}: state = `GetA;
          {`Decode, `ALU_instruction, 2'b10}: state = `GetA;
          {`Decode, `ALU_instruction, 2'b11}: state = `GetB;
          
          // All instructions that use GetA also use GetB
          {`GetA, {5{1'bx}}}: state = `GetB;
          
          // Decide on what ALU operation to do
          {`GetB, `Move_instruction, 2'b00}: state = `ALUNoOp;
          {`GetB, `ALU_instruction, 2'b00}: state = `Add; 
          {`GetB, `ALU_instruction, 2'b01}: state = `CMP;
          {`GetB, `ALU_instruction, 2'b10}: state = `BitwiseAND;
          {`GetB, `ALU_instruction, 2'b11}: state = `BitwiseNOT;
          
          // These operations feed back to the register file
          {`Add, {5{1'bx}}}: state = `WriteReg;
          {`BitwiseAND, {5{1'bx}}}: state = `WriteReg;
          {`BitwiseNOT, {5{1'bx}}}: state = `WriteReg;
          {`ALUNoOp, {5{1'bx}}}: state = `WriteReg;

          // This only writes the status register
          {`CMP, {5{1'bx}}}: state = `IF1;
          
          // Once finished writing, always go back to wait
          {`WriteReg, {5{1'bx}}}: state = `IF1;
          {`WriteImm, {5{1'bx}}}: state = `IF1;
          
          // should not end up here
          default: state = {5{1'bx}};
        endcase
   end

   always_comb begin
      if (state == `Reset) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b1;
         reset_pc = 1'b1;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `IF1) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `IF2) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `UpdatePC) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b1;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `Decode) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `GetA) begin
         {write, loada ,loadb, loadc, loads} = 5'b01000;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b100000;  
      end
      else if (state == `GetB) begin
         {write, loada ,loadb, loadc, loads} = 5'b00100;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `Add) begin
         {write, loada ,loadb, loadc, loads} = 5'b00010;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `CMP) begin
         {write, loada ,loadb, loadc, loads} = 5'b00001;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `BitwiseAND) begin
         {write, loada ,loadb, loadc, loads} = 5'b00010;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `BitwiseNOT) begin
         {write, loada ,loadb, loadc, loads} = 5'b00010;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
      end
      else if (state == `ALUNoOp) begin
         {write, loada ,loadb, loadc, loads} = 5'b00010;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b001000;
      end
      else if (state == `WriteReg) begin
         {write, loada ,loadb, loadc, loads} = 5'b10000;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b010000;
      end
      else if (state == `WriteImm) begin
         {write, loada ,loadb, loadc, loads} = 5'b10000;
         load_pc = 1'b0;
         reset_pc = 1'b0;
         load_addr = 3'b000;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b100010;
      end
      else begin // should not end up here
         {write, loada ,loadb, loadc, loads} = {5{1'bx}};
         load_pc = 1'bx;
         reset_pc = 1'bx;
         load_addr = 3'bxxx;
         mem_cmd = 2'bxx;
         addr_sel = 1'bx;
         {nsel, asel, bsel, vsel} = {6{1'bx}};
      end
   end
endmodule
